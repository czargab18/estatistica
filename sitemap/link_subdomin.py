#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Crawler para extrair todos os links do subdomínio boasvindas.unb.br
Salva os caminhos completos em um arquivo txt, excluindo CSS e JS
"""

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import time
import os
from typing import Set, List
import re


class BoasVindasCrawler:
    def __init__(self, base_url: str = "https://est.unb.br"):
        self.base_url = base_url
        self.domain = urlparse(base_url).netloc
        self.visited_urls: Set[str] = set()
        self.found_links: Set[str] = set()
        self.to_visit: List[str] = [base_url]
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })

    def is_valid_url(self, url: str) -> bool:
        """Verifica se a URL é válida e pertence ao domínio"""
        try:
            parsed = urlparse(url)
            # Verifica se é do mesmo domínio
            if parsed.netloc != self.domain:
                return False

            # Exclui arquivos CSS, JS e outros recursos não desejados
            excluded_extensions = {'.css', '.js', '.ico', '.png', '.jpg', '.jpeg',
                                   '.gif', '.svg', '.woff', '.woff2', '.ttf', '.eot',
                                   '.map', '.min.css', '.min.js'}

            path_lower = parsed.path.lower()
            for ext in excluded_extensions:
                if path_lower.endswith(ext):
                    return False

            # Exclui URLs com parâmetros específicos do WordPress
            if 'ver=' in parsed.query or 'elementor' in path_lower:
                return False

            return True
        except:
            return False

    def extract_links_from_page(self, url: str) -> Set[str]:
        """Extrai todos os links de uma página"""
        try:
            print(f"Processando: {url}")
            response = self.session.get(url, timeout=10)
            response.raise_for_status()

            soup = BeautifulSoup(response.content, 'html.parser')
            links = set()

            # Extrai links de tags <a>
            for link in soup.find_all('a', href=True):
                href = link['href']
                full_url = urljoin(url, href)
                if self.is_valid_url(full_url):
                    links.add(full_url)

            # Extrai links de forms (action)
            for form in soup.find_all('form', action=True):
                action = form['action']
                full_url = urljoin(url, action)
                if self.is_valid_url(full_url):
                    links.add(full_url)

            return links

        except requests.RequestException as e:
            print(f"Erro ao acessar {url}: {e}")
            return set()
        except Exception as e:
            print(f"Erro inesperado ao processar {url}: {e}")
            return set()

    def crawl(self, max_pages: int = 100, delay: float = 1.0):
        """Executa o crawling do site"""
        print(f"Iniciando crawling de {self.base_url}")
        print(f"Máximo de páginas: {max_pages}")
        print("-" * 50)

        pages_processed = 0

        while self.to_visit and pages_processed < max_pages:
            current_url = self.to_visit.pop(0)

            if current_url in self.visited_urls:
                continue

            self.visited_urls.add(current_url)
            self.found_links.add(current_url)

            # Extrai links da página atual
            new_links = self.extract_links_from_page(current_url)

            # Adiciona novos links à lista de visitação
            for link in new_links:
                self.found_links.add(link)
                if link not in self.visited_urls and link not in self.to_visit:
                    self.to_visit.append(link)

            pages_processed += 1
            print(
                f"Páginas processadas: {pages_processed}, Links encontrados: {len(self.found_links)}")

            # Delay entre requisições para não sobrecarregar o servidor
            time.sleep(delay)

        print("-" * 50)
        print(f"Crawling finalizado!")
        print(f"Total de links encontrados: {len(self.found_links)}")
        print(f"Total de páginas visitadas: {len(self.visited_urls)}")

    def save_links_to_file(self, filename: str = "est.unb.b_links.txt"):
        """Salva todos os links encontrados em um arquivo"""
        try:
            # Ordena os links alfabeticamente
            sorted_links = sorted(list(self.found_links))

            with open(filename, 'w', encoding='utf-8') as f:
                f.write(f"# Links encontrados no subdomínio {self.domain}\n")
                f.write(f"# Total de links: {len(sorted_links)}\n")
                f.write(
                    f"# Data de extração: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
                f.write(f"# Arquivos CSS, JS e recursos excluídos\n")
                f.write("-" * 80 + "\n\n")

                for link in sorted_links:
                    f.write(f"{link}\n")

            print(f"\nLinks salvos no arquivo: {filename}")
            print(f"Localização: {os.path.abspath(filename)}")

        except Exception as e:
            print(f"Erro ao salvar arquivo: {e}")

    def generate_report(self):
        """Gera um relatório resumido dos links encontrados"""
        print("\n" + "=" * 60)
        print("RELATÓRIO DE CRAWLING")
        print("=" * 60)

        # Categoriza os links por tipo
        pages = []
        pdfs = []
        images = []
        others = []

        for link in self.found_links:
            path = urlparse(link).path.lower()
            if path.endswith('.pdf'):
                pdfs.append(link)
            elif any(path.endswith(ext) for ext in ['.png', '.jpg', '.jpeg', '.gif', '.svg']):
                images.append(link)
            elif path.endswith('/') or not '.' in path.split('/')[-1]:
                pages.append(link)
            else:
                others.append(link)

        print(f"Total de links encontrados: {len(self.found_links)}")
        print(f"  - Páginas HTML: {len(pages)}")
        print(f"  - Arquivos PDF: {len(pdfs)}")
        print(f"  - Imagens: {len(images)}")
        print(f"  - Outros: {len(others)}")

        if pdfs:
            print(f"\nArquivos PDF encontrados:")
            for pdf in sorted(pdfs)[:10]:  # Mostra apenas os primeiros 10
                print(f"  - {pdf}")
            if len(pdfs) > 10:
                print(f"  ... e mais {len(pdfs) - 10} arquivos PDF")


def main():
    """Função principal"""
    print("🔍 Crawler para boasvindas.unb.br")
    print("=" * 50)

    # Cria o crawler
    crawler = BoasVindasCrawler()

    try:
        # Executa o crawling
        # Limite de 50 páginas com delay de 1.5s
        crawler.crawl(max_pages=50, delay=1.5)

        # Gera relatório
        crawler.generate_report()

        # Salva os links no arquivo
        crawler.save_links_to_file("est.unb.br_links.txt")

    except KeyboardInterrupt:
        print("\n\nCrawling interrompido pelo usuário.")
        print(f"Links coletados até agora: {len(crawler.found_links)}")

        # Salva o que foi coletado
        if crawler.found_links:
            crawler.save_links_to_file("est.unb.br_links_parcial.txt")

    except Exception as e:
        print(f"\nErro durante o crawling: {e}")


if __name__ == "__main__":
    main()
