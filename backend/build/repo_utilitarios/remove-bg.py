import os
import requests

def remove_background(input_image_path, output_image_path, api_key):
    """
    Remove o fundo de uma imagem usando a API remove.bg.

    Args:
        input_image_path (str): Caminho da imagem de entrada.
        output_image_path (str): Caminho para salvar a imagem sem fundo.
        api_key (str): Chave da API remove.bg.
    """
    with open(input_image_path, 'rb') as image_file:
        response = requests.post(
            'https://api.remove.bg/v1.0/removebg',
            files={'image_file': image_file},
            data={'size': 'auto'},
            headers={'X-Api-Key': api_key}
        )

    if response.status_code == 200:
        with open(output_image_path, 'wb') as output_file:
            output_file.write(response.content)
        print(f"Imagem salva em: {output_image_path}")
    else:
        print(f"Erro ao remover fundo: {response.status_code} - {response.text}")

# Exemplo de uso
if __name__ == "__main__":
    API_KEY = "valor_chave_api"

    # Diretório atual
    input_dir = "./"
    output_dir = "temp/"

    # Cria o diretório de saída, se não existir
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Processa todas as imagens no diretório
    for image in os.listdir(input_dir):
        if image.endswith(('.png', '.jpg', '.jpeg')):
            input_image_path = os.path.join(input_dir, image)
            output_image_path = os.path.join(output_dir, image).replace("\\", "/")
            try:
                remove_background(input_image_path, output_image_path, API_KEY)
            except Exception as e:
                print(f"Erro ao processar {image}: {e}")
