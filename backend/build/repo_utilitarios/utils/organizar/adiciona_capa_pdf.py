from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from PyPDF2 import PdfReader, PdfWriter

def image_to_pdf(image_path, pdf_path):
    c = canvas.Canvas(pdf_path, pagesize=letter)
    c.drawImage(image_path, 0, 0, width=letter[0], height=letter[1])
    c.save()

# Substitua pelos caminhos dos seus arquivos
image_path = 'EBed2-CapaCC2.png'
pdf_cover_path = 'capa.pdf'
image_to_pdf(image_path, pdf_cover_path)



def merge_pdfs(capa_pdf_path, original_pdf_path, output_pdf_path):
    # Ler os PDFs
    capa_pdf = PdfReader(capa_pdf_path)
    original_pdf = PdfReader(original_pdf_path)
    
    # Criar um PDF de saída
    writer = PdfWriter()
    
    # Adicionar a capa
    writer.add_page(capa_pdf.pages[0])
    
    # Adicionar o PDF original
    for page in original_pdf.pages:
        writer.add_page(page)
    
    # Salvar o PDF final
    with open(output_pdf_path, 'wb') as output_pdf:
        writer.write(output_pdf)

# Substitua pelos caminhos dos seus arquivos
original_pdf_path = 'Estatística Bayesiana (Paulino, Carlos Daniel Murteira etc.).pdf'
output_pdf_path = 'Estatística Bayesiana (Paulino, Carlos Daniel Murteira etc.).pdf'
merge_pdfs(pdf_cover_path, original_pdf_path, output_pdf_path)
