import csv

def calcular_ira(disciplinas):
    """Calcula o IRA com base em uma lista de disciplinas."""
    soma_ponderada = sum(d["mencao"] * d["creditos"] * d["semestre"] for d in disciplinas)
    soma_creditos = sum(d["creditos"] * d["semestre"] for d in disciplinas)
    ira = soma_ponderada / soma_creditos if soma_creditos > 0 else 0
    return ira


def entrada_manual():
    """Entrada manual dos dados de disciplinas."""
    print("Bem-vindo ao cálculo do IRA da UnB (entrada manual).")
    disciplinas = []
    aparicoes_disciplina = {}

    for semestre in range(1, 21):  # Semestres de 1 a 20
        print(f"\n--- Semestre {semestre} ---")
        while True:
            codigo = input("Código da disciplina: ")

            # Validação da menção
            while True:
                mencao = input("Menção obtida (SS, MS, MM, MI, II, SR): ").strip().upper()
                valores_mencao = {"SS": 5, "MS": 4, "MM": 3, "MI": 2, "II": 1, "SR": 0}
                if mencao in valores_mencao:
                    E_i = valores_mencao[mencao]
                    break
                print("Menção inválida. Insira SS, MS, MM, MI, II ou SR.")

            # Validação dos créditos
            while True:
                try:
                    creditos = int(input("Número de créditos da disciplina: "))
                    if creditos > 0:
                        break
                    print("O número de créditos deve ser positivo.")
                except ValueError:
                    print("Entrada inválida. Insira um número inteiro.")

            # Validação do semestre
            while True:
                try:
                    semestre_disciplina = int(input(f"Em qual semestre a disciplina {codigo} foi cursada (1-20)? "))
                    if 1 <= semestre_disciplina <= 20:
                        break
                    print("Semestre inválido. Insira um semestre entre 1 e 20.")
                except ValueError:
                    print("Entrada inválida. Insira um número inteiro.")

            # Registro da disciplina
            disciplinas.append({"codigo": codigo, "mencao": E_i, "creditos": creditos, "semestre": semestre_disciplina})

            # Controle de até 6 registros por disciplina
            aparicoes_disciplina[codigo] = aparicoes_disciplina.get(codigo, 0) + 1
            if aparicoes_disciplina[codigo] > 6:
                print(f"A disciplina {codigo} já foi registrada 6 vezes, mas será considerada apenas até 6 aparições para o cálculo do IRA.")

            # Pergunta se deseja adicionar outra disciplina
            mais = input("Deseja adicionar outra disciplina neste semestre? (s/n): ").strip().lower()
            if mais != 's':
                break

        avancar = input("Deseja passar para o próximo semestre? (s/n): ").strip().lower()
        if avancar != 's':
            break

    ira = calcular_ira(disciplinas)
    print(f"\nSeu IRA calculado manualmente é: {ira:.2f}")
    salvar_csv(disciplinas, 'csv/disciplinas.csv')
    print("Dados salvos no arquivo 'csv/disciplinas.csv'.")


def salvar_csv(disciplinas, nome_arquivo):
    """Salva a lista de disciplinas em um arquivo CSV."""
    with open(nome_arquivo, mode='w', newline='', encoding='utf-8') as csvfile:
        campos = ["Semestre", "Código", "Mencao", "Creditos"]
        escritor = csv.DictWriter(csvfile, fieldnames=campos)
        escritor.writeheader()
        for d in disciplinas:
            escritor.writerow({
                "Semestre": d["semestre"],
                "Código": d["codigo"],
                "Mencao": d["mencao"],
                "Creditos": d["creditos"],
            })


def calcular_ira_csv(nome_arquivo):
    """Calcula o IRA a partir de um arquivo CSV."""
    print("Bem-vindo ao cálculo do IRA da UnB (via CSV).")
    disciplinas = []
    aparicoes_disciplina = {}

    try:
        with open(nome_arquivo, newline='', encoding='utf-8') as csvfile:
            leitor = csv.DictReader(csvfile)
            print(f"Colunas do arquivo CSV: {leitor.fieldnames}")

            for row in leitor:
                try:
                    # Ajusta para usar as colunas existentes no CSV
                    codigo = row['Código']
                    mencao = row['Resultado'].strip().upper()
                    semestre_disciplina = int(float(row['Semestre']))  # Suporta semestres como "2024.2"
                    creditos = 4  # Assumindo créditos padrão de 4, ajuste conforme necessário
                    
                    # Mapeia as menções para valores numéricos
                    valores_mencao = {"SS": 5, "MS": 4, "MM": 3, "MI": 2, "II": 1, "SR": 0}

                    # Ignora menções inválidas (exemplo: "--")
                    if mencao not in valores_mencao:
                        print(f"Menção inválida para a disciplina {codigo}. Ignorando essa linha.")
                        continue

                    E_i = valores_mencao[mencao]

                    # Armazena a disciplina com o semestre correto
                    disciplinas.append({"codigo": codigo, "mencao": E_i, "creditos": creditos, "semestre": semestre_disciplina})

                    # Controle de até 6 registros por disciplina
                    aparicoes_disciplina[codigo] = aparicoes_disciplina.get(codigo, 0) + 1
                    if aparicoes_disciplina[codigo] > 6:
                        print(f"A disciplina {codigo} já foi registrada 6 vezes, ignorando registros extras.")
                        disciplinas = [d for d in disciplinas if not (d["codigo"] == codigo and d["semestre"] == semestre_disciplina)]

                except (ValueError, KeyError) as e:
                    print(f"Erro ao processar linha: {row}. Erro: {e}")

        # Cálculo do IRA
        soma_ponderada = sum(d["mencao"] * d["creditos"] * d["semestre"] for d in disciplinas)
        soma_creditos = sum(d["creditos"] * d["semestre"] for d in disciplinas)
        ira = soma_ponderada / soma_creditos if soma_creditos > 0 else 0
        print(f"\nSeu IRA calculado a partir do CSV é: {ira:.2f}")

    except FileNotFoundError:
        print(f"Arquivo '{nome_arquivo}' não encontrado.")
    except Exception as e:
        print(f"Erro ao ler o arquivo CSV: {e}")


def menu():
    """Menu principal para escolher o modo de cálculo."""
    while True:
        print("\n=== Menu de Opções ===")
        print("1. Entrada manual")
        print("2. Calcular IRA a partir de um arquivo CSV")
        print("3. Sair")
        escolha = input("Escolha uma opção: ").strip()

        if escolha == '1':
            entrada_manual()
        elif escolha == '2':
            nome_arquivo = input("Informe o caminho do arquivo CSV: ").strip().strip('"').strip("'")
            calcular_ira_csv(nome_arquivo)
        elif escolha == '3':
            print("Encerrando o programa.")
            break
        else:
            print("Opção inválida. Tente novamente.")


# Executa o menu
menu()
