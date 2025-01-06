# Percorrer diretório, abrir arquivos e modificar um trecho de código

import os
import re
# Configurações
diretorio_base = "./"  # Substitua pelo caminho do diretório onde os arquivos estão
padrao_antigo = r"ac/"  # Expressão regular para corresponder ac/
substituicao = "ac/"  # Novo texto

# Função para processar os arquivos
def substituir_texto_em_arquivos(diretorio):
    for raiz, _, arquivos in os.walk(diretorio):
        for nome_arquivo in arquivos:
            caminho_arquivo = os.path.join(raiz, nome_arquivo)

            # Processa apenas arquivos de texto
            try:
                with open(caminho_arquivo, "r", encoding="utf-8") as arquivo:
                    conteudo = arquivo.read()

                # Substitui o padrão
                novo_conteudo = re.sub(padrao_antigo, substituicao, conteudo)

                # Apenas sobrescreve o arquivo se houve mudança
                if conteudo != novo_conteudo:
                    with open(caminho_arquivo, "w", encoding="utf-8") as arquivo:
                        arquivo.write(novo_conteudo)
                    print(f"Atualizado: {caminho_arquivo}")
            except Exception as e:
                print(f"Erro ao processar {caminho_arquivo}: {e}")

# Executa o script
substituir_texto_em_arquivos(diretorio_base)