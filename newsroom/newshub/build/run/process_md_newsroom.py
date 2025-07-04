#!/usr/bin/env python3
"""
Sistema de publicação de artigos em Markdown para Apple Newsroom
Versão Python usando pypandoc para comparação com PowerShell
"""

import os
import sys
import json
import yaml
import re
from pathlib import Path
import pypandoc
from datetime import datetime

class NewsroomProcessor:
    def __init__(self, base_dir=None):
        """Inicializa o processador com diretório base"""
        if base_dir is None:
            self.base_dir = Path(__file__).parent.parent
        else:
            self.base_dir = Path(base_dir)
        
        self.components_dir = self.base_dir / "components"
        self.output_dir = self.base_dir / "output"
        self.template_file = self.base_dir / "run" / "template.html"
        
        # Criar diretórios se não existirem
        self.output_dir.mkdir(exist_ok=True)
        
    def log(self, message, level="INFO"):
        """Sistema de log simples"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {level}: {message}")
    
    def extract_frontmatter(self, markdown_content):
        """Extrai frontmatter YAML do conteúdo markdown"""
        try:
            # Regex para extrair frontmatter YAML
            frontmatter_pattern = r'^---\s*\n(.*?)\n---\s*\n(.*)$'
            match = re.match(frontmatter_pattern, markdown_content, re.DOTALL)
            
            if match:
                yaml_content = match.group(1)
                markdown_body = match.group(2)
                
                # Parse do YAML
                metadata = yaml.safe_load(yaml_content)
                return metadata, markdown_body
            else:
                self.log("Nenhum frontmatter encontrado", "WARNING")
                return {}, markdown_content
                
        except yaml.YAMLError as e:
            self.log(f"Erro ao processar YAML: {e}", "ERROR")
            return {}, markdown_content
        except Exception as e:
            self.log(f"Erro inesperado ao extrair frontmatter: {e}", "ERROR")
            return {}, markdown_content
    
    def load_component(self, component_name):
        """Carrega um componente HTML"""
        try:
            component_path = self.components_dir / f"{component_name}.html"
            if component_path.exists():
                with open(component_path, 'r', encoding='utf-8') as f:
                    return f.read()
            else:
                self.log(f"Componente não encontrado: {component_name}", "WARNING")
                return f"<!-- Componente {component_name} não encontrado -->"
        except Exception as e:
            self.log(f"Erro ao carregar componente {component_name}: {e}", "ERROR")
            return f"<!-- Erro ao carregar {component_name} -->"
    
    def process_includes(self, html_content, metadata):
        """Processa os includes/componentes no HTML gerado"""
        try:
            includes = metadata.get('includes', {})
            
            if not includes:
                self.log("Nenhum include definido no frontmatter")
                return html_content
            
            # Ordenar includes por posição
            sorted_includes = []
            for position, components in includes.items():
                if isinstance(components, list):
                    for component in components:
                        if isinstance(component, dict) and 'component' in component:
                            sorted_includes.append({
                                'position': position,
                                'component': component['component'],
                                'priority': component.get('priority', 0)
                            })
            
            # Ordenar por prioridade
            sorted_includes.sort(key=lambda x: x['priority'])
            
            # Processar cada include
            for include in sorted_includes:
                position = include['position']
                component_name = include['component']
                
                # Carregar o componente
                component_html = self.load_component(component_name)
                
                # Inserir no HTML baseado na posição
                if position == 'head':
                    html_content = html_content.replace('</head>', f'{component_html}\n</head>')
                elif position == 'body-start':
                    html_content = html_content.replace('<body>', f'<body>\n{component_html}')
                elif position == 'body-end':
                    html_content = html_content.replace('</body>', f'{component_html}\n</body>')
                elif position == 'header':
                    html_content = html_content.replace('<header>', f'<header>\n{component_html}')
                elif position == 'main-start':
                    html_content = html_content.replace('<main>', f'<main>\n{component_html}')
                elif position == 'main-end':
                    html_content = html_content.replace('</main>', f'{component_html}\n</main>')
                else:
                    self.log(f"Posição desconhecida para include: {position}", "WARNING")
            
            return html_content
            
        except Exception as e:
            self.log(f"Erro ao processar includes: {e}", "ERROR")
            return html_content
    
    def convert_markdown_to_html(self, input_file, output_file=None):
        """Converte arquivo markdown para HTML usando pypandoc"""
        try:
            input_path = Path(input_file)
            
            if not input_path.exists():
                raise FileNotFoundError(f"Arquivo não encontrado: {input_file}")
            
            if output_file is None:
                output_file = self.output_dir / (input_path.stem + ".html")
            else:
                output_file = Path(output_file)
            
            self.log(f"Processando: {input_path}")
            
            # Ler o arquivo markdown
            with open(input_path, 'r', encoding='utf-8') as f:
                markdown_content = f.read()
            
            # Extrair frontmatter
            metadata, markdown_body = self.extract_frontmatter(markdown_content)
            self.log(f"Metadados extraídos: {len(metadata)} campos")
            
            # Preparar opções do pandoc
            pandoc_args = [
                '--standalone',
                '--template', str(self.template_file),
                '--from', 'markdown',
                '--to', 'html5'
            ]
            
            # Adicionar metadados como variáveis do pandoc
            for key, value in metadata.items():
                if key != 'includes':  # Includes são processados separadamente
                    if isinstance(value, (str, int, float, bool)):
                        pandoc_args.extend(['-V', f'{key}:{value}'])
                    elif isinstance(value, list):
                        # Para listas, converter para string separada por vírgulas
                        pandoc_args.extend(['-V', f'{key}:{",".join(map(str, value))}'])
            
            # Converter usando pypandoc
            self.log("Executando conversão pandoc...")
            html_output = pypandoc.convert_text(
                markdown_body,
                'html5',
                format='markdown',
                extra_args=pandoc_args
            )
            
            # Processar includes/componentes
            self.log("Processando includes...")
            final_html = self.process_includes(html_output, metadata)
            
            # Salvar arquivo final
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(final_html)
            
            self.log(f"Conversão concluída: {output_file}")
            return True, str(output_file)
            
        except FileNotFoundError as e:
            self.log(f"Arquivo não encontrado: {e}", "ERROR")
            return False, str(e)
        except Exception as e:
            self.log(f"Erro durante conversão: {e}", "ERROR")
            return False, str(e)
    
    def batch_convert(self, input_dir, pattern="*.md"):
        """Converte múltiplos arquivos markdown"""
        try:
            input_path = Path(input_dir)
            if not input_path.exists():
                raise FileNotFoundError(f"Diretório não encontrado: {input_dir}")
            
            markdown_files = list(input_path.glob(pattern))
            
            if not markdown_files:
                self.log(f"Nenhum arquivo {pattern} encontrado em {input_dir}", "WARNING")
                return []
            
            results = []
            for md_file in markdown_files:
                self.log(f"Processando arquivo {len(results)+1}/{len(markdown_files)}: {md_file.name}")
                success, output = self.convert_markdown_to_html(md_file)
                results.append({
                    'input': str(md_file),
                    'output': output,
                    'success': success
                })
            
            return results
            
        except Exception as e:
            self.log(f"Erro no processamento em lote: {e}", "ERROR")
            return []

def main():
    """Função principal"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Processador Apple Newsroom - Versão Python')
    parser.add_argument('input', help='Arquivo markdown ou diretório para processar')
    parser.add_argument('-o', '--output', help='Arquivo de saída (opcional)')
    parser.add_argument('-b', '--batch', action='store_true', help='Modo lote para processar diretório')
    parser.add_argument('--base-dir', help='Diretório base do projeto')
    
    args = parser.parse_args()
    
    # Inicializar processador
    processor = NewsroomProcessor(args.base_dir)
    
    processor.log("=== Sistema Apple Newsroom - Versão Python ===")
    processor.log(f"Processando: {args.input}")
    
    if args.batch:
        # Modo lote
        results = processor.batch_convert(args.input)
        
        success_count = sum(1 for r in results if r['success'])
        processor.log(f"Processamento em lote concluído: {success_count}/{len(results)} sucessos")
        
        # Mostrar resultados
        for result in results:
            status = "✓" if result['success'] else "✗"
            processor.log(f"{status} {Path(result['input']).name} -> {result['output']}")
    
    else:
        # Arquivo único
        success, output = processor.convert_markdown_to_html(args.input, args.output)
        
        if success:
            processor.log(f"✓ Conversão bem-sucedida: {output}")
        else:
            processor.log(f"✗ Falha na conversão: {output}", "ERROR")
            sys.exit(1)

if __name__ == "__main__":
    main()
