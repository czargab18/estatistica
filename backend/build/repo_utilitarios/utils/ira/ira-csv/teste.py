import csv

def calcular_ira_csv(nome_arquivo):
    print("Bem-vindo ao cálculo do IRA da UnB.")
    disciplinas = []  # Lista para armazenar todas as disciplinas com seus dados
    aparicoes_disciplina = {}  # Dicionário para contar as aparições de cada disciplina

    try:
        # Abre o arquivo CSV com os dados das disciplinas
        with open(nome_arquivo, newline='', encoding='utf-8') as csvfile:
            leitor = csv.DictReader(csvfile)
            
            # Verifica os nomes das colunas
            print(f"Colunas do arquivo CSV: {leitor.fieldnames}")
            
            for row in leitor:
                # Adapta os campos do CSV para o que o script espera
                codigo = row['Código']  # Coluna do código da disciplina
                mencao = row['Resultado'].strip().upper()  # Resultado da menção
                semestre_disciplina = int(row['Semestre'])  # Semestre
                creditos = 4  # Você pode ajustar isso com base na lógica da UnB ou no CSV
                
                # Mapeia as menções para suas notas
                valores_mencao = {"SS": 5, "MS": 4, "MM": 3, "MI": 2, "II": 1, "SR": 0}
                
                # Verifica se a menção é válida
                if mencao not in valores_mencao:
                    print(f"Menção inválida para a disciplina {codigo}. Ignorando essa linha.")
                    continue
                
                E_i = valores_mencao[mencao]
                
                # Armazena a disciplina com o semestre correto
                disciplinas.append({"codigo": codigo, "mencao": E_i, "creditos": creditos, "semestre": semestre_disciplina})

                # Atualiza a contagem de aparições da disciplina
                if codigo in aparicoes_disciplina:
                    aparicoes_disciplina[codigo] += 1
                else:
                    aparicoes_disciplina[codigo] = 1
                
                # Caso a disciplina tenha sido registrada mais de 6 vezes, ignora as entradas seguintes
                if aparicoes_disciplina[codigo] > 6:
                    print(f"A disciplina {codigo} já foi registrada 6 vezes, não será registrada novamente.")
                    # Remove a última adição
                    disciplinas = [d for d in disciplinas if not (d["codigo"] == codigo and d["semestre"] == semestre_disciplina)]

    except FileNotFoundError:
        print(f"Arquivo {nome_arquivo} não encontrado.")
        return None
    except Exception as e:
        print(f"Erro ao ler o arquivo CSV: {e}")
        return None

    # Cálculo do IRA
    soma_ponderada = sum(d["mencao"] * d["creditos"] * d["semestre"] for d in disciplinas)
    soma_creditos = sum(d["creditos"] * d["semestre"] for d in disciplinas)
    ira = soma_ponderada / soma_creditos if soma_creditos > 0 else 0

    print(f"\n--- Resultado ---")
    print(f"Seu IRA é: {ira:.2f}")
    return ira


# Teste do cálculo do IRA com dados do CSV
def testar_calculo_ira_csv():
    nome_arquivo = 'csv/disciplinas.csv'  # Caminho correto para o arquivo CSV na pasta 'csv'

    # Chama a função para calcular o IRA a partir do CSV
    calcular_ira_csv(nome_arquivo)


# Executa o teste
testar_calculo_ira_csv()
