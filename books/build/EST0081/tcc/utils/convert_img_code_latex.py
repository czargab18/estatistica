# > pip install "pix2tex[gui]"

import json
import os
from PIL import Image
from pix2tex.cli import LatexOCR


def process_images(image_directory):
    image_paths = []
    for indice in os.listdir(image_directory):
        if indice.endswith(".png"):
            image_paths.append(os.path.join(image_directory, indice))
    return image_paths

def convert_images_to_latex(image_directory, output_directory, max_iterations=2):
    # Processar imagens no diretório
    image_paths = process_images(image_directory)
    results = {}
    iteration = 0

    # Inicializar o modelo
    model = LatexOCR()

    while iteration < max_iterations:
        for image_path in image_paths:
            img = Image.open(image_path)
            latex_code = model(img)
            results[image_path] = latex_code
            print(f"LaTeX code for {image_path}: {latex_code}")

        # Exportar os resultados para um arquivo JSON
        os.makedirs(output_directory, exist_ok=True)
        output_file = os.path.join(output_directory, 'formulas-convertidas.json')
        with open(output_file, 'w') as f:
            json.dump(results, f, indent=4)
        iteration += 1
    print(f"Results saved to {output_file}")

# Exemplo de uso
if __name__ == "__main__":
    image_directory = "./utils/"
    output_directory = "./utils/"
    convert_images_to_latex(image_directory, output_directory)
