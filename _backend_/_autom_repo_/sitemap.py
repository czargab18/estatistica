# crie um script python que vasculhe o meu repositório e
# crie uma estrutura sitemap.xml
# para seo 

# para seo 

import os
import xml.etree.ElementTree as ET
from datetime import datetime

def generate_sitemap(directory, base_url):
    urlset = ET.Element("urlset", xmlns="http://www.sitemaps.org/schemas/sitemap/0.9")
    ignore_dirs = {'backend', '.automacao'}

    for root, dirs, files in os.walk(directory):
        # Remove diretórios a serem ignorados
        dirs[:] = [d for d in dirs if d not in ignore_dirs]
        for file in files:
            if file.endswith(".html"):
                file_path = os.path.join(root, file)
                print(f"Encontrado arquivo HTML: {file_path}")  # Mensagem de depuração
                url = ET.SubElement(urlset, "url")
                loc = ET.SubElement(url, "loc")
                loc.text = f"{base_url}/{os.path.relpath(file_path, directory).replace(os.sep, '/')}"
                lastmod = ET.SubElement(url, "lastmod")
                lastmod.text = datetime.fromtimestamp(os.path.getmtime(file_path)).strftime("%Y-%m-%d")

    tree = ET.ElementTree(urlset)
    sitemap_path = os.path.join(directory, "sitemap.xml")
    with open(sitemap_path, "wb") as f:
        tree.write(f, encoding="utf-8", xml_declaration=True)
    print("sitemap.xml gerado com sucesso")  # Mensagem de depuração

if __name__ == "__main__":
    repo_directory = "c:/Users/cesar.oliveira/Documents/github/estatistica/"
    base_url = "https://www.estatistica.pro"
    generate_sitemap(repo_directory, base_url)