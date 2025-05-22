import os
import tempfile
from PyPDF2 import PdfReader, PdfWriter
from PIL import Image
import fitz  # PyMuPDF

def split_pdf_image(input_pdf_path):
    # Abrir o PDF usando PyMuPDF (fitz)
    pdf_document = fitz.open(input_pdf_path)
    page_number = 0

    # Criar diretório temporário
    temp_dir = tempfile.mkdtemp()

    try:
        # Iterar sobre as páginas do PDF
        for i in range(len(pdf_document)):
            page = pdf_document.load_page(i)  # Carregar a página

            # Aumentar a qualidade da imagem ao converter
            zoom_x = 2.0  # Fator de zoom horizontal (2.0 = 200% de resolução)
            zoom_y = 2.0  # Fator de zoom vertical (2.0 = 200% de resolução)
            mat = fitz.Matrix(zoom_x, zoom_y)  # Criar matriz de transformação

            pix = page.get_pixmap(matrix=mat)  # Converter a página em uma imagem rasterizada com qualidade melhorada

            # Criar uma imagem a partir do Pixmap (usando Pillow)
            img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)

            # Verifica se é a primeira página para não dividir, mas salvá-la no resultado
            if i == 0:
                # Salvar a primeira página inteira como PDF
                img_file = os.path.join(temp_dir, f"pagina_{page_number:03}.pdf")
                img.save(img_file, "PDF")
                page_number += 1
            else:
                # Dividir a imagem ao meio (metade esquerda e metade direita)
                width, height = img.size
                esquerda = img.crop((0, 0, width // 2, height))
                direita = img.crop((width // 2, 0, width, height))

                # Salvar as partes cortadas como arquivos temporários em PDF
                esquerda_file = os.path.join(temp_dir, f"esquerda_{page_number:03}.pdf")
                direita_file = os.path.join(temp_dir, f"direita_{page_number+1:03}.pdf")

                esquerda.save(esquerda_file, "PDF")
                direita.save(direita_file, "PDF")

                page_number += 2

        return temp_dir

    except Exception as e:
        print(f"Erro ao dividir o PDF: {e}")
        return None

def merge_split_pdfs(temp_dir, output_pdf_path):
    writer = PdfWriter()

    # Mesclar todos os PDFs divididos na ordem correta (incluindo a primeira página inteira)
    for filename in sorted(os.listdir(temp_dir)):
        if filename.endswith(".pdf"):
            file_path = os.path.join(temp_dir, filename)
            reader = PdfReader(file_path)
            writer.add_page(reader.pages[0])

    # Escrever o PDF concatenado final
    with open(output_pdf_path, "wb") as output_file:
        writer.write(output_file)

if __name__ == "__main__":
    # Caminho do PDF de entrada
    input_pdf = "Análise Combinatória e Probabilidade ( etc.) (Z-Library).pdf"
    
    # Nome do PDF final
    output_pdf = "Análise Combinatória e Probabilidade.pdf"

    # Dividir o PDF e salvar em arquivos temporários
    temp_dir = split_pdf_image(input_pdf)

    if temp_dir:
        # Mesclar os PDFs divididos
        merge_split_pdfs(temp_dir, output_pdf)

        # Excluir a pasta temporária após mesclar
        try:
            for file in os.listdir(temp_dir):
                file_path = os.path.join(temp_dir, file)
                os.remove(file_path)  # Excluir arquivos individuais
            os.rmdir(temp_dir)  # Excluir o diretório temporário
            print(f"PDF final gerado com sucesso: {output_pdf}")
        except Exception as e:
            print(f"Erro ao limpar arquivos temporários: {e}")
    else:
        print("Erro ao dividir o PDF.")
