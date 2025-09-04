#!/usr/bin/env python3
"""
Script para adicionar breadcrumbs manualmente em arquivos HTML
Processa caminhos em lowercase e adiciona seguindo estrutura de diretórios
"""

import os
import re
import glob
from pathlib import Path
from typing import List, Dict, Tuple


class BreadcrumbsManager:
    """Gerenciador para adicionar breadcrumbs em arquivos HTML"""
    
    def __init__(self, root_path: str):
        self.root_path = Path(root_path)
        
    def get_page_title(self, html_content: str, segment: str) -> str:
        """Gera título baseado apenas no nome do diretório"""
        # Usar apenas capitalização do nome do diretório
        return segment.capitalize()
    
    def generate_breadcrumbs(self, file_path: Path, html_content: str) -> str:
        """Gera o HTML dos breadcrumbs baseado no caminho do arquivo"""
        # Obter caminho relativo
        relative_path = file_path.relative_to(self.root_path)
        
        # Converter para string, normalizar barras e processar em lowercase
        path_str = str(relative_path).lower().replace('\\', '/')

        # Dividir pelo "/" e filtrar segmentos
        segments = []
        path_parts = path_str.split('/')

        for part in path_parts:
            # Ignorar apenas arquivos .html, mas manter diretórios
            if part and not part.endswith('.html'):
                segments.append(part)
            elif part.endswith('.html') and part != 'index.html':
                # Se for arquivo HTML que não é index, adicionar sem extensão
                segments.append(part.replace('.html', ''))
        
        print(f"📁 Processando: {relative_path}")
        print(f"🔧 Path parts: {path_parts}")
        print(f"🔧 Segmentos extraídos: {segments}")
        
        # Páginas especiais que não devem ter breadcrumbs (apenas raiz real)
        if len(segments) == 0 and str(relative_path) == 'index.html':
            print("⏭️  Página raiz - pulando breadcrumbs")
            return ''

        if len(segments) == 0:
            print("⚠️  Nenhum segmento encontrado mas não é página raiz")
            return ''
        
        # Gerar itens dos breadcrumbs
        breadcrumb_items = []
        for i, segment in enumerate(segments):
            url = '/' + '/'.join(segments[:i+1]) + '/'
            name = self.get_page_title(html_content, segment)
            
            if i == len(segments) - 1:
                # Último item (página atual) - sem link
                breadcrumb_items.append({'name': name})
            else:
                # Item intermediário - com link
                breadcrumb_items.append({'name': name, 'url': url})
        
        if not breadcrumb_items:
            return ''
        
        print(f"🍞 Breadcrumb items: {breadcrumb_items}")

        # Gerar HTML dos itens
        items_html = []
        for index, item in enumerate(breadcrumb_items):
            if 'url' in item:
                items_html.append(f'''
              <li class="ac-gf-breadcrumbs-item" property="itemListElement" typeof="ListItem">
                <a class="ac-gf-breadcrumbs-link" href="{item['url']}" target="_self" property="item" typeof="WebPage">
                  <span property="name">{item['name']}</span>
                </a>
                <meta property="position" content="{index + 1}">
              </li>''')
            else:
                items_html.append(f'''
              <li class="ac-gf-breadcrumbs-item" property="itemListElement" typeof="ListItem">
                <span property="name">{item['name']}</span>
                <meta property="position" content="{index + 1}">
              </li>''')
        
        # HTML completo dos breadcrumbs
        breadcrumbs_html = f'''
      <nav class="ac-gf-breadcrumbs" aria-label="Breadcrumbs" role="navigation">
        <a href="/" class="ac-gf-breadcrumbs-home" target="_self">
          <span class="ac-gf-breadcrumbs-home-icon" aria-hidden="true"></span>
          <span class="ac-gf-breadcrumbs-home-label">Estatística UnB</span>
        </a>
        <div class="ac-gf-breadcrumbs-path">
          <ol class="ac-gf-breadcrumbs-list" vocab="http://schema.org/" typeof="BreadcrumbList">{''.join(items_html)}
          </ol>
        </div>
      </nav>'''
        
        return breadcrumbs_html
    
    def process_file(self, file_path: Path, dry_run: bool = False, force: bool = False) -> bool:
        """Processa um arquivo HTML adicionando breadcrumbs"""
        try:
            # Ler arquivo
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Verificar se já tem breadcrumbs
            if 'ac-gf-breadcrumbs' in content and not force:
                print(f"⚠️  {file_path.relative_to(self.root_path)} - já possui breadcrumbs (use --force para sobrescrever)")
                return False
            
            # Se force=True e já tem breadcrumbs, remover os existentes
            if 'ac-gf-breadcrumbs' in content and force:
                print(f"🔄 {file_path.relative_to(self.root_path)} - removendo breadcrumbs existentes")
                # Remover breadcrumbs existentes
                pattern = r'<nav class="ac-gf-breadcrumbs"[^>]*>.*?</nav>\s*'
                content = re.sub(pattern, '', content, flags=re.DOTALL)
            
            # Gerar breadcrumbs
            breadcrumbs_html = self.generate_breadcrumbs(file_path, content)
            
            if not breadcrumbs_html:
                print(f"⏭️  {file_path.relative_to(self.root_path)} - página especial, pulando")
                return False
            
            # Encontrar onde inserir (antes do nav.ac-gf-directory)
            pattern = r'(\s*)<nav class="ac-gf-directory[^"]*"[^>]*id="globalfooter-navgation"[^>]*>'
            match = re.search(pattern, content)
            
            if not match:
                # Tentar padrão alternativo sem id
                pattern = r'(\s*)<nav class="ac-gf-directory[^"]*"[^>]*>'
                match = re.search(pattern, content)

            if not match:
                # Se não encontrar nav.ac-gf-directory, tentar inserir antes do </footer>
                pattern = r'(\s*)</footer>'
                match = re.search(pattern, content)
                
                if not match:
                    # Se não encontrar footer, tentar antes do </body>
                    pattern = r'(\s*)</body>'
                    match = re.search(pattern, content)
                    
                    if not match:
                        print(f"❌ {file_path.relative_to(self.root_path)} - não encontrou local para inserir breadcrumbs")
                        return False
            
            # Inserir breadcrumbs
            new_content = content[:match.start()] + breadcrumbs_html + '\n' + content[match.start():]
            
            if dry_run:
                print(f"🔍 {file_path.relative_to(self.root_path)} - breadcrumbs seriam adicionados")
                return True
            
            # Salvar arquivo
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print(f"✅ {file_path.relative_to(self.root_path)} - breadcrumbs adicionados")
            return True
            
        except Exception as e:
            print(f"❌ {file_path.relative_to(self.root_path)} - erro: {e}")
            return False
    
    def process_directory(self, pattern: str = "**/*.html", dry_run: bool = False, force: bool = False):
        """Processa múltiplos arquivos HTML"""
        files = list(self.root_path.glob(pattern))
        
        # Filtrar arquivos que não devem ser processados
        excluded_patterns = [
            'ac/',           # Arquivos de componentes
            'wss/',          # Web services
            'sd/',           # Static data
            'backend/',      # Backend files
            'dados/',        # Data files
            '404.html',      # Página de erro
            'demo-breadcrumbs.html',  # Demo file
            '/index.html'    # Index da raiz
        ]
        
        filtered_files = []
        for file_path in files:
            relative_str = str(file_path.relative_to(self.root_path))

            # Verificar se o arquivo está na raiz (apenas index.html da raiz é excluído)
            if relative_str == 'index.html':
                print(f"⏭️  Pulando arquivo raiz: {relative_str}")
                continue

            # Verificar outros padrões de exclusão
            should_exclude = False
            for pattern in excluded_patterns:
                if pattern in relative_str:
                    print(
                        f"⏭️  Excluindo por padrão '{pattern}': {relative_str}")
                    should_exclude = True
                    break

            if not should_exclude:
                filtered_files.append(file_path)
        
        print(f"📁 Arquivos encontrados: {len(files)}")
        print(
            f"📁 Arquivos filtrados para processamento: {len(filtered_files)}")
        if dry_run:
            print("🔍 MODO DRY-RUN - nenhum arquivo será modificado")
        print("-" * 80)
        
        success_count = 0
        for file_path in filtered_files:
            print(f"\n📄 Processando: {file_path.relative_to(self.root_path)}")
            if self.process_file(file_path, dry_run, force):
                success_count += 1
        
        print("-" * 80)
        print(f"✅ Processamento concluído: {success_count}/{len(filtered_files)} arquivos")


def main():
    """Função principal"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Adiciona breadcrumbs em arquivos HTML')
    parser.add_argument('--path', '-p', default='.', 
                       help='Caminho raiz do projeto (padrão: diretório atual)')
    parser.add_argument('--pattern', default='**/*.html',
                       help='Padrão de arquivos para processar (padrão: **/*.html)')
    parser.add_argument('--dry-run', '-d', action='store_true',
                       help='Modo dry-run - apenas mostra o que seria feito')
    parser.add_argument('--force', action='store_true',
                       help='Forçar sobrescrita de breadcrumbs existentes')
    parser.add_argument('--file', '-f', 
                       help='Processar apenas um arquivo específico')
    
    args = parser.parse_args()
    
    manager = BreadcrumbsManager(args.path)
    
    if args.file:
        # Processar arquivo específico
        file_path = Path(args.file)
        if not file_path.exists():
            print(f"❌ Arquivo não encontrado: {file_path}")
            return
        
        manager.process_file(file_path, args.dry_run, args.force)
    else:
        # Processar múltiplos arquivos
        manager.process_directory(args.pattern, args.dry_run, args.force)


if __name__ == '__main__':
    main()
