import pandas as pd
from collections import Counter

# Parâmetros
arquivo_excel = "data/RESPOSTAS EMPRESAS FORMULARIO FORMP&D 2023.xlsx"
nome_coluna = "AperfeicoamentoSistema"
top_n = 10

# Carregar o arquivo Excel
df = pd.read_excel(arquivo_excel, engine="openpyxl")

# Verificar se a coluna existe
if nome_coluna not in df.columns:
    raise ValueError(f"A coluna '{nome_coluna}' não foi encontrada no arquivo.")

# Remover valores nulos e normalizar texto
frases = df[nome_coluna].dropna().astype(str).str.strip()

# Contar a frequência das frases
contagem = Counter(frases)

# Exibir as frases mais frequentes
print(f"\n🔝 Top {top_n} frases mais repetidas na coluna '{nome_coluna}':\n")
for frase, frequencia in contagem.most_common(top_n):
    print(f"{frequencia}x - {frase}")

# Caminho do arquivo de saída
arquivo_saida = "scripts/python/analise-texto/top_frases_FORMpd_2023.txt"

# Salvar as frases mais frequentes em um arquivo .txt
with open(arquivo_saida, "w", encoding="utf-8") as f:
    f.write(f"🔝 Top {top_n} frases mais repetidas na coluna '{nome_coluna}':\n\n")
    for frase, frequencia in contagem.most_common(top_n):
        f.write(f"{frequencia}x - {frase}\n")

print(f"\nAs frases mais frequentes foram salvas em '{arquivo_saida}'.")
