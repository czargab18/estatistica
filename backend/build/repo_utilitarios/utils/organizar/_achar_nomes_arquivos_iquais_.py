import os

def find_similar_files(directory):
    files_map = {}

    for filename in os.listdir(directory):
        if not os.path.isfile(os.path.join(directory, filename)):
            continue

        base_name = filename.replace("-Lib", "").strip()
        
        if base_name in files_map:
            files_map[base_name].append(filename)
        else:
            files_map[base_name] = [filename]

    duplicates = {key: value for key, value in files_map.items() if len(value) > 1}

    if duplicates:
        print("Arquivos semelhantes encontrados:\n")
        for base, variants in duplicates.items():
            print(f"{base}:")
            for variant in variants:
                print(f"  - {variant}")
            print()
    else:
        print("Nenhum arquivo semelhante encontrado.")


# 📂 Defina o diretório onde estão os arquivos
# Altere para o caminho desejado
directory_path = "C:\\Users\\cesargabrielphd\\Documents\\recuperado"
find_similar_files(directory_path)
