# pip install pillow pymupdf
import os
from PIL import Image
import fitz  # PyMuPDF


def imagens_para_pdf(pasta, nome_saida="output.pdf", dpi=300):
    # Obtém todas as imagens na pasta (ordem alfabética)
    imagens = sorted(
        [os.path.join(pasta, f) for f in os.listdir(
            pasta) if f.lower().endswith(('png', 'jpg', 'jpeg', 'tiff', 'bmp'))]
    )

    if not imagens:
        print("Nenhuma imagem encontrada na pasta.")
        return

    # Abre a primeira imagem
    img_pil = Image.open(imagens[0])
    pdf_bytes = fitz.open()  # Cria um PDF vazio

    # Adiciona cada imagem ao PDF mantendo qualidade
    for img_path in imagens:
        img_pil = Image.open(img_path)

        # Converte para RGB se for PNG com transparência
        if img_pil.mode in ("RGBA", "P"):
            img_pil = img_pil.convert("RGB")

        # Salva a imagem temporária com 300 DPI
        temp_path = os.path.join(pasta, "temp.jpg")
        img_pil.save(temp_path, "JPEG", quality=100, dpi=(dpi, dpi))

        # Adiciona ao PDF
        pdf_page = pdf_bytes.new_page(
            width=img_pil.width, height=img_pil.height)
        pdf_page.insert_image(pdf_page.rect, filename=temp_path)

        # Remove imagem temporária
        os.remove(temp_path)

    # Salva o PDF final
    pdf_bytes.save(os.path.join(pasta, nome_saida))
    pdf_bytes.close()

    print(f"PDF gerado com sucesso: {os.path.join(pasta, nome_saida)}")


# Exemplo de uso
pasta_imagens = "./utils/pdf/files/1"



imagens_para_pdf(pasta_imagens, "resultado.pdf")
