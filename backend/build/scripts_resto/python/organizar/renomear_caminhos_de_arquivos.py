# Percorrer diretório, abrir arquivos e modificar um trecho de código

import os
import re

#   Caminho do diretório onde os arquivos estão
diretorio_base = "./"


#  Função para substituir o padrão nos arquivos
def substituir_ac_global(diretorio):
    for root, _, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            caminho_arquivo = os.path.join(root, arquivo)

            # Verifica se o arquivo é de texto (ex.: .html, .css, .js)
            if caminho_arquivo.endswith((".html", ".css", ".js", ".txt")):
                try:
                    with open(caminho_arquivo, "r", encoding="utf-8") as file:
                        conteudo = file.read()

                    # Substitui o padrão usando regex
                    novo_conteudo = re.sub(r"ac/global\S*", "/ac/global", conteudo)

                    # Salva o arquivo novamente, se algo foi alterado
                    if conteudo != novo_conteudo:
                        with open(caminho_arquivo, "w", encoding="utf-8") as file:
                            file.write(novo_conteudo)
                        print(f"Atualizado: {caminho_arquivo}")
                except Exception as e:
                    print(f"Erro ao processar {caminho_arquivo}: {e}")


#  Executa a função
substituir_ac_global(diretorio_base)


#    Caminho do diretório onde os arquivos estão
diretorio_base = "./"


#  Função para substituir padrões no diretório
def corrigir_erros_ac(diretorio):
    for root, _, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            caminho_arquivo = os.path.join(root, arquivo)

            # Verifica se o arquivo é de texto (ex.: .html, .css, .js)
            if caminho_arquivo.endswith((".html", ".css", ".js", ".txt")):
                try:
                    with open(caminho_arquivo, "r", encoding="utf-8") as file:
                        conteudo = file.read()

                    #  Substitui "ac/global******" por "/ac/global"
                    conteudo_corrigido = re.sub(r"ac/global\S*", "/ac/global", conteudo)

                    #  Corrige "//ac/*" para "/ac/*"
                    conteudo_corrigido = re.sub(r"//ac/", "/ac/", conteudo_corrigido)

                    #   Salva o arquivo novamente, se algo foi alterado
                    if conteudo != conteudo_corrigido:
                        with open(caminho_arquivo, "w", encoding="utf-8") as file:
                            file.write(conteudo_corrigido)
                        print(f"Atualizado: {caminho_arquivo}")
                except Exception as e:
                    print(f"Erro ao processar {caminho_arquivo}: {e}")


# Executa a função
corrigir_erros_ac(diretorio_base)


# Configurações
diretorio_base = "./"  # Substitua pelo caminho do diretório onde os arquivosestão
padrao_antigo = r"/ac/global"  #  Expressão regular para corresponder /ac/global
substituicao = "/ac/global"  #    Novo texto


# Função para processar os arquivos
def substituir_texto_em_arquivos(diretorio):
    for raiz, _, arquivos in os.walk(diretorio):
        for nome_arquivo in arquivos:
            caminho_arquivo = os.path.join(raiz, nome_arquivo)

            #      Processa apenas arquivos de texto
            try:
                with open(caminho_arquivo, "r", encoding="utf-8") as arquivo:
                    conteudo = arquivo.read()

                #   Substitui o padrão
                novo_conteudo = re.sub(padrao_antigo, substituicao, conteudo)

                #  Apenas sobrescreve o arquivo se houve mudança
                if conteudo != novo_conteudo:
                    with open(caminho_arquivo, "w", encoding="utf-8") as arquivo:
                        arquivo.write(novo_conteudo)
                    print(f"Atualizado: {caminho_arquivo}")
            except Exception as e:
                print(f"Erro ao processar {caminho_arquivo}: {e}")


# Executa o script
substituir_texto_em_arquivos(diretorio_base)
