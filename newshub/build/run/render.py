#!/usr/bin/env python3
"""
Script Python para renderização de Markdown - Apple Newsroom
Versão: 2.0 com pypandoc e processamento avançado de componentes
"""

import os
import sys
import yaml
import re
import json
import argparse
import webbrowser
from pathlib import Path
from datetime import datetime

try:
    import pypandoc
except ImportError:
    print("❌ ERRO: pypandoc não está instalado")
    print("Execute: pip install pypandoc")
    print("Ou execute: python config.py")
    sys.exit(1)

class NewsroomRenderer:
    def __init__(self, base_dir=None):
        """Inicializa o renderizador"""
        if base_dir is None:
            self.base_dir = Path(__file__).parent
        else:
            self.base_dir = Path(base_dir)
        
        self.template_file = self.base_dir / ".." / "modelos" / "template.html"
        self.components_dir = self.base_dir / ".." / "components"
        self.output_dir = self.base_dir / "output"
        
        # Criar diretório de saída
        self.output_dir.mkdir(exist_ok=True)
    
    def log(self, message, level="INFO"):
        """Sistema de log com timestamp"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        color_codes = {
            "INFO": "\033[96m",     # Cyan
            "SUCCESS": "\033[92m",  # Green
            "WARNING": "\033[93m",  # Yellow
            "ERROR": "\033[91m",    # Red
            "RESET": "\033[0m"      # Reset
        }
        
        color = color_codes.get(level, color_codes["RESET"])
        reset = color_codes["RESET"]
        print(f"{color}[{timestamp}] {level}: {message}{reset}")
    
    def check_dependencies(self):
        """Verifica se todas as dependências estão disponíveis"""
        self.log("Verificando dependências...")
        
        # Verificar pypandoc
        try:
            version = pypandoc.get_pandoc_version()
            self.log(f"✓ Pandoc via pypandoc: {version}", "SUCCESS")
        except Exception as e:
            self.log(f"✗ Erro no pypandoc: {e}", "ERROR")
            return False
        
        # Verificar template
        if not self.template_file.exists():
            self.log(f"✗ Template não encontrado: {self.template_file}", "ERROR")
            self.log("Certifique-se de que template.html está na pasta modelos/", "ERROR")
            return False
        else:
            self.log(f"✓ Template encontrado: {self.template_file}", "SUCCESS")
        
        return True
    
    def extract_frontmatter(self, content):
        """Extrai frontmatter YAML do conteúdo markdown"""
        try:
            # Regex para frontmatter
            pattern = r'^---\s*\n(.*?)\n---\s*\n(.*)$'
            match = re.match(pattern, content, re.DOTALL)
            
            if match:
                yaml_content = match.group(1)
                markdown_body = match.group(2)
                
                # Parse YAML
                try:
                    metadata = yaml.safe_load(yaml_content)
                    return metadata or {}, markdown_body
                except yaml.YAMLError as e:
                    self.log(f"Erro ao processar YAML: {e}", "WARNING")
                    return {}, content
            else:
                self.log("Nenhum frontmatter YAML encontrado", "WARNING")
                return {}, content
                
        except Exception as e:
            self.log(f"Erro ao extrair frontmatter: {e}", "ERROR")
            return {}, content
    
    def load_component(self, component_name):
        """Carrega um componente HTML"""
        try:
            component_path = self.components_dir / f"{component_name}.html"
            if component_path.exists():
                with open(component_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                self.log(f"✓ Componente carregado: {component_name}")
                return content
            else:
                self.log(f"⚠ Componente não encontrado: {component_name}", "WARNING")
                return f"<!-- Componente {component_name} não encontrado -->"
        except Exception as e:
            self.log(f"Erro ao carregar componente {component_name}: {e}", "ERROR")
            return f"<!-- Erro ao carregar {component_name} -->"
    
    def process_includes(self, html_content, metadata):
        """Processa includes/componentes no HTML"""
        try:
            includes = metadata.get('includes', {})
            
            if not includes:
                self.log("Nenhum include definido no frontmatter")
                return html_content
            
            self.log(f"Processando {len(includes)} includes...")
            
            # Processar includes simples (true/false)
            for include_name, include_value in includes.items():
                if include_value is True:
                    component_html = self.load_component(include_name)
                    
                    # Mapear posições de inserção
                    replacements = {
                        'header_global': (
                            r'(<div id="globalheader">)(.*?)(</div>)',
                            r'\1' + component_html + r'\3'
                        ),
                        'footer_global': (
                            r'(<footer id="globalfooter"[^>]*>)(.*?)(</footer>)',
                            r'\1' + component_html + r'\3'
                        ),
                        'local_nav': (
                            r'(<nav class="localnav"[^>]*>)(.*?)(</nav>)',
                            r'\1' + component_html + r'\3'
                        ),
                        'article_header': (
                            r'(<div class="article-header-extended">)(.*?)(</div>)',
                            r'\1' + component_html + r'\3'
                        )
                    }
                    
                    if include_name in replacements:
                        pattern, replacement = replacements[include_name]
                        html_content = re.sub(pattern, replacement, html_content, flags=re.DOTALL)
                        self.log(f"✓ Include processado: {include_name}")
                    else:
                        self.log(f"⚠ Posição de include desconhecida: {include_name}", "WARNING")
            
            return html_content
            
        except Exception as e:
            self.log(f"Erro ao processar includes: {e}", "ERROR")
            return html_content
    
    def process_images(self, html_content, input_path, output_file):
        """Processa imagens no HTML e ajusta caminhos"""
        try:
            import shutil
            
            # Diretório de origem das imagens (mesmo diretório do markdown)
            source_dir = input_path.parent
            
            # Diretório de destino das imagens
            output_dir = output_file.parent
            src_dir = output_dir / "src"
            src_dir.mkdir(exist_ok=True)
            
            # Encontrar todas as imagens no HTML
            import re
            img_pattern = r'<img[^>]+src="([^"]+)"[^>]*>'
            img_matches = re.findall(img_pattern, html_content)
            
            if not img_matches:
                self.log("Nenhuma imagem encontrada no HTML")
                return html_content
            
            self.log(f"Processando {len(img_matches)} imagens...")
            
            for img_src in img_matches:
                # Ignorar URLs absolutas
                if img_src.startswith(('http://', 'https://', '//')):
                    continue
                
                # Arquivo de origem
                source_file = source_dir / img_src
                
                if source_file.exists():
                    # Arquivo de destino
                    dest_file = src_dir / source_file.name
                    
                    # Copiar arquivo
                    shutil.copy2(source_file, dest_file)
                    self.log(f"✓ Imagem copiada: {source_file.name} → src/{source_file.name}")
                    
                    # Atualizar caminho no HTML
                    old_src = f'src="{img_src}"'
                    new_src = f'src="src/{source_file.name}"'
                    html_content = html_content.replace(old_src, new_src)
                    
                else:
                    self.log(f"⚠ Imagem não encontrada: {source_file}", "WARNING")
            
            return html_content
            
        except Exception as e:
            self.log(f"Erro ao processar imagens: {e}", "ERROR")
            return html_content
    
    def render(self, input_file, output_file=None, verbose=False):
        """Renderiza arquivo markdown para HTML"""
        try:
            input_path = Path(input_file)
            
            if not input_path.exists():
                raise FileNotFoundError(f"Arquivo não encontrado: {input_file}")
            
            # Determinar arquivo de saída
            if output_file is None:
                # Verificar se o arquivo de entrada é artigo.md e definir como index.html
                if input_path.stem == "artigo":
                    filename = "index"
                else:
                    filename = input_path.stem

                # Verificar se existe pasta output local junto com o arquivo de entrada
                local_output_dir = input_path.parent / "output"
                if local_output_dir.exists():
                    output_file = local_output_dir / (filename + ".html")
                    self.log(
                        f"Usando diretório de output local: {local_output_dir}")
                else:
                    output_file = self.output_dir / (filename + ".html")
            else:
                output_file = Path(output_file)
            
            self.log("=" * 60, "INFO")
            self.log("RENDERIZAÇÃO MARKDOWN - APPLE NEWSROOM (Python)", "INFO")
            self.log("=" * 60, "INFO")
            self.log(f"Entrada: {input_path}", "INFO")
            self.log(f"Saída: {output_file}", "INFO")
            self.log(f"Template: {self.template_file}", "INFO")
            self.log("=" * 60, "INFO")
            
            # Ler arquivo markdown
            with open(input_path, 'r', encoding='utf-8') as f:
                markdown_content = f.read()
            
            self.log("Arquivo markdown carregado")
            
            # Extrair frontmatter
            metadata, markdown_body = self.extract_frontmatter(markdown_content)
            
            if metadata:
                self.log(f"Frontmatter extraído: {len(metadata)} campos")
                if verbose:
                    self.log(f"Metadados: {json.dumps(metadata, indent=2, ensure_ascii=False)}")
            
            # Preparar variáveis para pypandoc
            extra_args = [
                '--standalone',
                f'--template={self.template_file}',
                '--from=markdown+yaml_metadata_block',
                '--to=html5',
                '--section-divs',
                '--wrap=none'
            ]
            
            # Adicionar metadados como variáveis
            for key, value in metadata.items():
                if key != 'includes':  # Includes são processados separadamente
                    if isinstance(value, (str, int, float, bool)):
                        extra_args.extend(['-V', f'{key}:{value}'])
                    elif isinstance(value, list):
                        # Converter listas para string
                        extra_args.extend(['-V', f'{key}:{",".join(map(str, value))}'])
            
            if verbose:
                self.log(f"Argumentos pandoc: {' '.join(extra_args)}")
            
            # Executar pypandoc
            self.log("Executando pypandoc...")
            
            # Recriar markdown com frontmatter para pypandoc
            full_markdown = f"---\n{yaml.dump(metadata, allow_unicode=True)}---\n{markdown_body}" if metadata else markdown_body
            
            html_output = pypandoc.convert_text(
                full_markdown,
                'html5',
                format='markdown+yaml_metadata_block',
                extra_args=extra_args
            )
            
            self.log("HTML básico gerado pelo pypandoc")
            
            # Processar includes
            if metadata:
                html_output = self.process_includes(html_output, metadata)
            
            # Processar imagens
            html_output = self.process_images(html_output, input_path, output_file)
            
            # Salvar arquivo final
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(html_output)
            
            # Estatísticas
            input_size = input_path.stat().st_size
            output_size = output_file.stat().st_size
            
            self.log("=" * 60, "SUCCESS")
            self.log("SUCESSO: Arquivo HTML gerado!", "SUCCESS")
            self.log("=" * 60, "SUCCESS")
            self.log(f"Arquivo: {output_file}", "SUCCESS")
            self.log(f"Tamanho: Input {input_size} bytes → Output {output_size} bytes", "SUCCESS")
            
            return True, str(output_file)
            
        except Exception as e:
            self.log(f"Erro durante renderização: {e}", "ERROR")
            return False, str(e)
    
    def batch_render(self, input_dir, pattern="*.md", verbose=False):
        """Renderiza múltiplos arquivos"""
        try:
            input_path = Path(input_dir)
            if not input_path.exists():
                raise FileNotFoundError(f"Diretório não encontrado: {input_dir}")
            
            markdown_files = list(input_path.glob(pattern))
            
            if not markdown_files:
                self.log(f"Nenhum arquivo {pattern} encontrado em {input_dir}", "WARNING")
                return []
            
            self.log(f"Renderizando {len(markdown_files)} arquivos...")
            
            results = []
            for i, md_file in enumerate(markdown_files, 1):
                self.log(f"Processando arquivo {i}/{len(markdown_files)}: {md_file.name}")
                success, output = self.render(md_file, verbose=verbose)
                results.append({
                    'input': str(md_file),
                    'output': output,
                    'success': success
                })
            
            # Resumo
            success_count = sum(1 for r in results if r['success'])
            self.log(f"Processamento em lote concluído: {success_count}/{len(results)} sucessos")
            
            return results
            
        except Exception as e:
            self.log(f"Erro no processamento em lote: {e}", "ERROR")
            return []

def main():
    """Função principal"""
    parser = argparse.ArgumentParser(
        description='Renderizador Apple Newsroom - Versão Python',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Exemplos de uso:
  python render.py artigo.md
  python render.py artigo.md -o meu_artigo.html
  python render.py . --batch
  python render.py artigo.md --open --verbose
        '''
    )
    
    parser.add_argument('input', help='Arquivo markdown ou diretório para processar')
    parser.add_argument('-o', '--output', help='Arquivo de saída (opcional)')
    parser.add_argument('-b', '--batch', action='store_true', help='Modo lote para processar diretório')
    parser.add_argument('-v', '--verbose', action='store_true', help='Saída detalhada')
    parser.add_argument('--open', action='store_true', help='Abrir resultado no navegador')
    parser.add_argument('--base-dir', help='Diretório base do projeto')
    
    args = parser.parse_args()
    
    # Inicializar renderizador
    renderer = NewsroomRenderer(args.base_dir)
    
    # Verificar dependências
    if not renderer.check_dependencies():
        sys.exit(1)
    
    if args.batch:
        # Modo lote
        results = renderer.batch_render(args.input, verbose=args.verbose)
        
        # Mostrar resultados
        for result in results:
            status = "✓" if result['success'] else "✗"
            renderer.log(f"{status} {Path(result['input']).name} → {result['output']}")
        
        success_count = sum(1 for r in results if r['success'])
        if success_count == len(results):
            renderer.log("🎉 Todos os arquivos processados com sucesso!", "SUCCESS")
        elif success_count > 0:
            renderer.log(f"⚠ {success_count}/{len(results)} arquivos processados", "WARNING")
        else:
            renderer.log("❌ Nenhum arquivo foi processado com sucesso", "ERROR")
            sys.exit(1)
    
    else:
        # Arquivo único
        success, output = renderer.render(args.input, args.output, args.verbose)
        
        if success:
            renderer.log("🎉 Renderização concluída com sucesso!", "SUCCESS")
            
            # Abrir no navegador se solicitado
            if args.open:
                renderer.log("Abrindo no navegador...", "INFO")
                webbrowser.open(f"file://{Path(output).absolute()}")
        else:
            renderer.log(f"❌ Falha na renderização: {output}", "ERROR")
            sys.exit(1)

if __name__ == "__main__":
    main()
