import requests
from bs4 import BeautifulSoup
import os

# URL da página que contém os links para os PDFs
url = 'http://lib.ysu.am/disciplines_bk/'

# Diretório onde os PDFs serão salvos
output_dir = 'pdfs'
os.makedirs(output_dir, exist_ok=True)

try:
    response = requests.get(url)
    response.raise_for_status()  # Verifica se a requisição foi bem-sucedida
except requests.exceptions.HTTPError as err:
    print(f"HTTP error occurred: {err}")
except Exception as err:
    print(f"An error occurred: {err}")
else:
    # Continue com o processamento da resposta
    soup = BeautifulSoup(response.content, 'html.parser')

    # Encontra todos os links para arquivos PDF
    pdf_links = soup.find_all('a', href=True)
    for link in pdf_links:
        href = link['href']
        if href.endswith('.pdf'):
            pdf_url = f"http://lib.ysu.am/disciplines_bk//{href}"
            pdf_name = href.split('/')[-1]
            
            # Faz o download do arquivo PDF
            pdf_response = requests.get(pdf_url)
            pdf_response.raise_for_status()  # Verifica se a requisição foi bem-sucedida
            
            # Salva o arquivo PDF no diretório de saída
            pdf_path = os.path.join(output_dir, pdf_name)
            with open(pdf_path, 'wb') as f:
                f.write(pdf_response.content)
            
            print(f"Baixado: {pdf_name}")

print("Download concluído.")
