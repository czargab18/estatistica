import os
import re
from PIL import Image
import fitz  # PyMuPDF


def ordenar_numerico(lista_arquivos):
    """Ordena arquivos numericamente considerando números no nome do arquivo."""
    def extrair_numero(nome):
        # Captura o primeiro número no nome do arquivo
        match = re.search(r'\d+', nome)
        # Se não houver número, vai para o final
        return int(match.group()) if match else float('inf')
    return sorted(lista_arquivos, key=extrair_numero)


def imagens_para_pdf(pasta, nome_saida, dpi=300):
    """Converte imagens de uma pasta para um PDF de alta qualidade."""
    imagens = ordenar_numerico(
        [f for f in os.listdir(pasta) if f.lower().endswith(
            ('png', 'jpg', 'jpeg', 'tiff', 'bmp'))]
    )
    imagens = [os.path.join(pasta, f) for f in imagens]  # Caminho completo

    if not imagens:
        print(f"Nenhuma imagem encontrada na pasta: {pasta}")
        return

    pdf_bytes = fitz.open()  # Cria um PDF vazio

    for img_path in imagens:
        img_pil = Image.open(img_path)

        # Converte para RGB se for PNG com transparência
        if img_pil.mode in ("RGBA", "P"):
            img_pil = img_pil.convert("RGB")

        # Salva imagem temporária com qualidade máxima
        temp_path = os.path.join(pasta, "temp.jpg")
        img_pil.save(temp_path, "JPEG", quality=300, dpi=(dpi, dpi))

        # Adiciona ao PDF
        pdf_page = pdf_bytes.new_page(
            width=img_pil.width, height=img_pil.height)
        pdf_page.insert_image(pdf_page.rect, filename=temp_path)

        # Remove arquivo temporário
        os.remove(temp_path)

    # Salva o PDF
    pdf_bytes.save(nome_saida)
    pdf_bytes.close()
    print(f"PDF gerado: {nome_saida}")


def processar_pasta_principal(pasta_raiz, pasta_saida):
    """Itera sobre subpastas dentro da pasta raiz e gera um PDF para cada na pasta de saída."""
    os.makedirs(pasta_saida, exist_ok=True)

    for subpasta in sorted(os.listdir(pasta_raiz)):
        caminho_subpasta = os.path.join(pasta_raiz, subpasta)

        if os.path.isdir(caminho_subpasta):  # Verifica se é uma pasta
            nome_pdf = os.path.join(pasta_saida, f"{subpasta}.pdf")
            imagens_para_pdf(caminho_subpasta, nome_pdf)


# Exemplo de uso
pasta_raiz = "./utils/pdf/files/"
pasta_saida = "./utils/pdf/resultado/"

processar_pasta_principal(pasta_raiz, pasta_saida)
