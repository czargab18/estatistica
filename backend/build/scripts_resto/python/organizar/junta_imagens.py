from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
import os

def criar_pdf_com_imagens(pasta_imagens, caminho_pdf):
    """
    Cria um PDF com as imagens em uma pasta, dispostas uma embaixo da outra.
    """
    c = canvas.Canvas(caminho_pdf, pagesize=letter)
    largura_pagina, altura_pagina = letter
    
    # Definindo margens
    margem_esquerda = 10
    margem_superior = 10
    
    # Obtendo a largura útil e altura útil da página
    largura_util = largura_pagina - 2 * margem_esquerda
    altura_util = altura_pagina - 2 * margem_superior

    # Obter todas as imagens da pasta e ordenar
    imagens = [f for f in os.listdir(pasta_imagens) if f.lower().endswith(('jpg', 'jpeg', 'png'))]
    imagens.sort()  # Ordenar para garantir uma ordem consistente

    y_atual = altura_pagina - margem_superior  # Posicionar as imagens a partir do topo da página

    for imagem_nome in imagens:
        caminho_imagem = os.path.join(pasta_imagens, imagem_nome)
        img = Image.open(caminho_imagem)
        largura_imagem, altura_imagem = img.size

        # Ajustar a imagem para caber na largura e altura da página
        proporcao_largura = largura_util / largura_imagem
        proporcao_altura = altura_util / altura_imagem
        proporcao = min(proporcao_largura, proporcao_altura)

        largura_imagem = largura_imagem * proporcao
        altura_imagem = altura_imagem * proporcao

        # Verificar se a imagem cabe na página
        if y_atual - altura_imagem < margem_superior:
            c.showPage()  # Adiciona uma nova página
            y_atual = altura_pagina - margem_superior  # Reseta a posição y para o topo da nova página

        # Adicionar a imagem ao PDF
        c.drawImage(caminho_imagem, margem_esquerda, y_atual - altura_imagem, width=largura_imagem, height=altura_imagem, preserveAspectRatio=True)
        y_atual -= altura_imagem  # Atualizar a posição y para a próxima imagem

    c.save()

# Defina os caminhos para a pasta de imagens e o caminho do PDF de saída
pasta_imagens = 'imgs_divididas/'
caminho_pdf = 'Estatística Bayesiana (Paulino, Carlos Daniel Murteira etc.).pdf'

# Criar o PDF
criar_pdf_com_imagens(pasta_imagens, caminho_pdf)
