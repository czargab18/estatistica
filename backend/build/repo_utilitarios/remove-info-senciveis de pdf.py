import re
from PyPDF2 import PdfReader, PdfWriter

def remove_sensitive_info_from_pdf(input_pdf_path, output_pdf_path, sensitive_text):
    # Abrir o PDF para leitura
    with open(input_pdf_path, "rb") as infile:
        reader = PdfReader(infile)
        writer = PdfWriter()

        # Remover texto sensível das páginas
        pattern = re.compile(re.escape(sensitive_text), re.IGNORECASE)
        for page in reader.pages:
            text = page.extract_text()
            if text and sensitive_text in text:
                # Não há uma forma direta de remover texto de páginas PDF sem reescrever o conteúdo.
                # Aqui apenas marcamos: AVISO: solução completa requer OCR ou re-renderização do PDF.
                # Você pode adicionar um overlay ou redigir, mas não é trivial com PyPDF2.
                print("Texto sensível encontrado em uma página. A remoção direta do texto não é suportada por PyPDF2.")
            writer.add_page(page)

        # Remover texto dos metadados
        metadata = reader.metadata
        new_metadata = {}
        for k, v in metadata.items():
            if isinstance(v, str):
                # Remove o texto sensível encontrado nos metadados
                new_value = pattern.sub("", v)
                new_metadata[k] = new_value
            else:
                new_metadata[k] = v
        writer.add_metadata(new_metadata)

        # Salvar o PDF limpo
        with open(output_pdf_path, "wb") as outfile:
            writer.write(outfile)

        print(f"Processamento concluído. Novo PDF salvo em: {output_pdf_path}")

# Exemplo de uso:
if __name__ == "__main__":
    remove_sensitive_info_from_pdf(
      input_pdf_path = "name.pdf",
      output_pdf_path = "output_name.pdf",,
      sensitive_text = "texto com informções importantes"
    )
