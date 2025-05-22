
from PIL import Image
import os

def dividir_imagem(imagem, destino, prefixo):
    """
    Divide a imagem em duas partes verticais e salva em dois arquivos.
    """
    largura, altura = imagem.size
    meio = largura // 2
    
    # Cortar a imagem em duas partes
    parte1 = imagem.crop((0, 0, meio, altura))
    parte2 = imagem.crop((meio, 0, largura, altura))
    
    # Criar os caminhos para salvar as partes
    caminho_parte1 = os.path.join(destino, f"{prefixo}_parte1.jpg")
    caminho_parte2 = os.path.join(destino, f"{prefixo}_parte2.jpg")
    
    # Salvar as partes
    parte1.save(caminho_parte1)
    parte2.save(caminho_parte2)

def dividir_imagens_pasta(pasta_origem, pasta_destino):
    """
    Divide todas as imagens em uma pasta e salva as partes em outra pasta.
    """
    if not os.path.exists(pasta_destino):
        os.makedirs(pasta_destino)
    
    for arquivo in os.listdir(pasta_origem):
        if arquivo.lower().endswith(('jpg', 'jpeg', 'png')):
            caminho_imagem = os.path.join(pasta_origem, arquivo)
            imagem = Image.open(caminho_imagem)
            
            # Extrair o nome base do arquivo sem a extensão
            nome_base = os.path.splitext(arquivo)[0]
            
            # Dividir a imagem e salvar as partes
            dividir_imagem(imagem, pasta_destino, nome_base)

# Defina os caminhos para a pasta de origem e destino
pasta_origem = 'imgs/'
pasta_destino = 'imgs_divididas/'

# Dividir as imagens
dividir_imagens_pasta(pasta_origem, pasta_destino)
