import os
import shutil
import re

class GerenciadorDisciplinas:
    def __init__(self):
        pass

    @staticmethod
    def criar_estrutura(disciplina="padrao"):
        """
        Criar a estrutura do repositório.
        """
        name = re.sub(r'[<>:"/\\|?*]', '', disciplina)
        dirs = [
            f"{name}/Estudos/conteúdos/bibliografia",
            f"{name}/Estudos/conteúdos/teoria-leve",
            f"{name}/Estudos/conteúdos/teoria-avançada",
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

    @staticmethod
    def deletar_estrutura(disciplinas):
        for disciplina in disciplinas:
            if os.path.exists(disciplina):
                shutil.rmtree(disciplina)
                print(f"Estrutura de diretórios para '{disciplina}' deletada com sucesso!")
            else:
                print(f"O diretório '{disciplina}' não existe.")

    @staticmethod
    def executar():
        acao = input("Digite 'c' para criar uma disciplina ou 'd' para deletar uma disciplina: ").strip().lower()

        if acao in ['c', 'criar', 'create']:
            disciplinas_input = input("Digite os nomes das disciplinas separados por vírgula (ex: disciplina-01,disciplina-02): ")
            if not disciplinas_input.strip():
                criar_padrao = input("Nenhuma disciplina foi digitada. Deseja criar a disciplina padrão 'disciplina-01'? (s/n): ").strip().lower()
                if criar_padrao in ['s', 'sim']:
                    GerenciadorDisciplinas.criar_estrutura("disciplina-01")
                else:
                    print("Nenhuma disciplina foi criada.")
            else:
                disciplinas = [disciplina.strip() for disciplina in disciplinas_input.split(",")]
                for disciplina in disciplinas:
                    GerenciadorDisciplinas.criar_estrutura(disciplina)

        elif acao in ['d', 'deletar', 'delete']:
            disciplinas_input = input("Digite os nomes das disciplinas a serem deletadas separados por vírgula (ex: disciplina-01,disciplina-02): ")
            if not disciplinas_input.strip():
                print("Nenhuma disciplina foi digitada. Por favor, digite pelo menos uma disciplina.")
            else:
                disciplinas = [disciplina.strip() for disciplina in disciplinas_input.split(",")]
                confirmar = input(f"Tem certeza que deseja deletar as disciplinas: {', '.join(disciplinas)}? (s/n): ").strip().lower()
                if confirmar in ['s', 'sim']:
                    GerenciadorDisciplinas.deletar_estrutura(disciplinas)
                else:
                    print("Nenhuma disciplina foi deletada.")

        else:
            print("Ação inválida. Por favor, digite 'c' para criar ou 'd' para deletar.")
