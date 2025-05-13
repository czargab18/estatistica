import PyPDF2
import pandas as pd
import re
# configuração para exibir todas as linhas e colunas do DataFrame
pd.set_option('display.max_rows', None)  # Nenhuma linha será truncada
pd.set_option('display.max_columns', None)  # Nenhuma coluna será truncada


# Caminho do arquivo PDF
pdf_path = "pdf/Sistema Integrado de Gestão de Atividades Acadêmicas.pdf"

# Lê o PDF e extrai o texto
with open(pdf_path, 'rb') as file:
    reader = PyPDF2.PdfReader(file)
    text = ""
    for page in reader.pages:
        text += page.extract_text()

# Processamento do texto para capturar disciplinas corretamente
def extract_all_disciplines(text):
    data = []
    lines = text.split("\n")
    current_semester = None
    
    for line in lines:
        # Identifica o semestre
        if line.strip().endswith(".2") or line.strip().endswith(".1"):
            current_semester = line.strip()
        elif current_semester and len(line.split()) >= 5:  # Linhas válidas têm pelo menos 5 partes
            parts = line.split()
            
            # Identificar dados estruturados no final da linha
            try:
                nota1, resultado, faltas, situacao = parts[-4:]
                codigo = parts[0]
                disciplina = " ".join(parts[1:-4])  # Tudo entre código e notas é o nome da disciplina
                
                # Adicionar aos dados apenas se estiver no formato correto
                if codigo.isalnum() and faltas.isdigit():  
                    data.append([current_semester, codigo, disciplina, nota1, resultado, faltas, situacao])
            except ValueError:
                # Pula linhas que não possuem o formato esperado
                continue
    return data

# Extração de todas as disciplinas
disciplinas = extract_all_disciplines(text)

# Cria um DataFrame com os dados extraídos
columns = ["Semestre", "Código", "Disciplina", "Nota 1", "Resultado", "Faltas", "Situação"]
df = pd.DataFrame(disciplinas, columns=columns)

# Função para corrigir a concatenação do nome da disciplina
def corrigir_disciplina_particionada(row):
    """
    Corrige a separação do nome da disciplina em diferentes colunas.
    Se o código foi encontrado na coluna 'Código', mas o nome da disciplina está fragmentado,
    ele será concatenado corretamente, removendo os códigos de situação.
    """
    # Expressão regular para capturar o código da disciplina (3 letras + 4 números)
    pattern_codigo = r'([A-Z]{3}\d{4})'  # Regex para o código (3 letras + 4 números)
    
    # Expressão regular para capturar as situações (SS, MS, MM, MI, SR, II)
    pattern_situacao = r'\b(SS|MS|MM|MI|SR|II)\b'  # Expressão para capturar as situações

    # Tenta encontrar o código na coluna "Código"
    match_codigo = re.search(pattern_codigo, row["Código"])
    if match_codigo:
        codigo = match_codigo.group(1)  # Captura o código encontrado
        # Remove o código da string para separar o nome da disciplina
        disciplina_parcial = row["Código"].replace(codigo, "").strip()
    else:
        # Se o código não for encontrado, tratamos a string como sendo o nome da disciplina
        codigo = ""  
        disciplina_parcial = row["Código"].strip()

    # Verifica se há alguma situação (SS, MS, MM, MI, SR, II) na coluna "Disciplina"
    match_situacao = re.search(pattern_situacao, row["Disciplina"])
    if match_situacao:
        situacao = match_situacao.group(1)  # Captura a situação
        # Remove a situação da disciplina (porque é irrelevante para o nome)
        disciplina_completa = f"{disciplina_parcial} {row['Disciplina'].replace(situacao, '').strip()}"
    else:
        # Caso não haja situação, concatenamos a parte do nome da disciplina
        disciplina_completa = f"{disciplina_parcial} {row['Disciplina']}".strip()

    # Remove espaços extras e corrige possíveis fragmentações
    disciplina_completa = ' '.join(disciplina_completa.split())

    return pd.Series([codigo, disciplina_completa])

# Aplica a função ao DataFrame e garante que a função retorne as duas colunas
df[["Código", "Disciplina"]] = df.apply(lambda row: corrigir_disciplina_particionada(row), axis=1)

# Exibe as primeiras linhas do DataFrame
print(df.sort_values(by="Semestre"))

df.to_csv("csv/disciplinas.csv", index=False)