"""
Identificar os arquivos '.png' que tem nomes parecidos mas diferem apenas de ' - qualiti' no final do nome.
- "qualiti" é apenas uma identificação para imagem com qualidade melhorada.
-  Exemplo: 'imagem - qualiti.png' e 'imagem.png' são considerados iguais, pois o sufixo ' - qualiti' é irrelevante para a comparação.

Função pega os arquivos parecidos sob a restrição acima e redimenciona os arquivos que possuem o sufixo ' - qualiti' para as mesmas dimensões do arquivo original.

Mantenha a qualidade original do arquivo, ou seja, não aplique compressão ou redimensionamento que altere a qualidade da imagem.
- (1) O arquivo original é o que não tem o sufixo ' - qualiti'.
- (2) O arquivo redimensionado é o que tem o sufixo ' - qualiti'.

resultado:
- o (2) é salva nas mesmas dimensões de (1) mas mantendo sua qualidade original.
- o (2) é salva na pasta temp.

salva na pasta temp.
"""

import os
from PIL import Image

images = os.listdir("./")

def process_images():
    if not os.path.exists("./temp"):
        os.makedirs("./temp")
    
    base_images = {}
    for image in images:
        if image.endswith(".png"):
            if " - qualiti" in image:
                base_name = image.replace(" - qualiti", "")
                base_images.setdefault(base_name, []).append(image)
            else:
                base_images.setdefault(image, [])
    
    for base_name, variants in base_images.items():
        if not variants:
            continue
        
        original_path = os.path.join("./", base_name)
        if not os.path.exists(original_path):
            continue
        
        with Image.open(original_path) as original_image:
            original_size = original_image.size
            
            for variant in variants:
                variant_path = os.path.join("./", variant)
                with Image.open(variant_path) as variant_image:
                    resized_image = variant_image.resize(original_size, Image.Resampling.LANCZOS)
                    # Salva o arquivo sem o sufixo " - qualiti"
                    variant_name_without_suffix = variant.replace(" - qualiti", "")
                    resized_image.save(f"./temp/{variant_name_without_suffix}", quality=100)

process_images()

