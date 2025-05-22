from PyPDF2 import PdfReader, PdfWriter
from PyPDF2.generic import RectangleObject


def split_pdf_pages(input_pdf, output_pdf, direction="vertical"):
    # Abrir o arquivo PDF
    reader = PdfReader(input_pdf)
    writer = PdfWriter()

    for page in reader.pages:
        # Obter o tamanho da página
        media_box = page.mediabox
        width = media_box.width
        height = media_box.height

        if direction == "vertical":
            # Criar a primeira metade (esquerda)
            left_half = page
            left_half.mediabox = RectangleObject([0, 0, width / 2, height])
            writer.add_page(left_half)

            # Criar a segunda metade (direita)
            right_half = page
            right_half.mediabox = RectangleObject([width / 2, 0, width, height])
            writer.add_page(right_half)

        elif direction == "horizontal":
            # Criar a primeira metade (superior)
            top_half = page
            top_half.mediabox = RectangleObject([0, height / 2, width, height])
            writer.add_page(top_half)

            # Criar a segunda metade (inferior)
            bottom_half = page
            bottom_half.mediabox = RectangleObject([0, 0, width, height / 2])
            writer.add_page(bottom_half)

        else:
            raise ValueError("Direção deve ser 'vertical' ou 'horizontal'")

    # Salvar o novo PDF
    with open(output_pdf, "wb") as output_file:
        writer.write(output_file)

    print(f"PDF dividido salvo em: {output_pdf}")


# Usar a função
split_pdf_pages("input.pdf", "saida.pdf", direction="vertical")
