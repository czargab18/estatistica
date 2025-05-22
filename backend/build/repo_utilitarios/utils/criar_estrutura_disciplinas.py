import os
import shutil

# Função para criar a estrutura de diretórios e arquivos vazios
def criar_estrutura(disciplina="disciplina-01"):
    dirs = [
        f"{disciplina}/Estudos/conteúdos/bibliografia",
        f"{disciplina}/Estudos/conteúdos/teoria-leve",
        f"{disciplina}/Estudos/conteúdos/teoria-avançada",
        f"{disciplina}/exercícios/teoria-leve",
        f"{disciplina}/exercícios/teoria-avançada",
        f"{disciplina}/projeto/data/bruto",
        f"{disciplina}/projeto/data/tratados",
        f"{disciplina}/projeto/code/importação",
        f"{disciplina}/projeto/code/tratamento",
        f"{disciplina}/projeto/code/analise",
        f"{disciplina}/projeto/resultado/graficos",
        f"{disciplina}/projeto/resultado/relatórios"
    ]

    if os.path.exists(disciplina):
        print(f"O diretório '{disciplina}' já existe.")
        return

    for dir in dirs:
        os.makedirs(dir, exist_ok=True)
        # Cria um arquivo vazio em cada subpasta
        with open(os.path.join(dir, "README.md"), 'w') as f:
            f.write(f"# {os.path.basename(dir)}\n")

    print(f"Estrutura de diretórios para '{disciplina}' criada com sucesso!")

# Função para deletar a estrutura de diretórios
def deletar_estrutura(disciplinas):
    for disciplina in disciplinas:
        if os.path.exists(disciplina):
            shutil.rmtree(disciplina)
            print(f"Estrutura de diretórios para '{disciplina}' deletada com sucesso!")
        else:
            print(f"O diretório '{disciplina}' não existe.")

# Solicita ao usuário a ação desejada
acao = input("Digite 'c' para criar uma disciplina ou 'd' para deletar uma disciplina: ").strip().lower()

if acao == 'c':
    # Solicita os nomes das disciplinas ao usuário
    disciplinas_input = input("Digite os nomes das disciplinas separados por vírgula (ex: disciplina-01,disciplina-02): ")
    if not disciplinas_input.strip():
        criar_padrao = input("Nenhuma disciplina foi digitada. Deseja criar a disciplina padrão 'disciplina-01'? (s/n): ").strip().lower()
        if criar_padrao in ['s', 'sim']:
            criar_estrutura("disciplina-01")
        else:
            print("Nenhuma disciplina foi criada.")
    else:
        disciplinas = [disciplina.strip() for disciplina in disciplinas_input.split(",")]
        for disciplina in disciplinas:
            criar_estrutura(disciplina)

elif acao == 'd':
    # Solicita os nomes das disciplinas a serem deletadas
    disciplinas_input = input("Digite os nomes das disciplinas a serem deletadas separados por vírgula (ex: disciplina-01,disciplina-02): ")
    if not disciplinas_input.strip():
        print("Nenhuma disciplina foi digitada. Por favor, digite pelo menos uma disciplina.")
    else:
        disciplinas = [disciplina.strip() for disciplina in disciplinas_input.split(",")]
        confirmar = input(f"Tem certeza que deseja deletar as disciplinas: {', '.join(disciplinas)}? (s/n): ").strip().lower()
        if confirmar in ['s', 'sim']:
            deletar_estrutura(disciplinas)
        else:
            print("Nenhuma disciplina foi deletada.")

else:
    print("Ação inválida. Por favor, digite 'c' para criar ou 'd' para deletar.")
