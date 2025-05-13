import os
from ftplib import FTP, error_perm
import threading
import time

# Configurações do servidor FTP
ftp_host = '95.217.88.17'
ftp_user = 'collection8152'  
ftp_password = '91bd48a7ca'  
ftp_port = 21

# Caminho da pasta local que contém os arquivos PDF
local_folder_path = 'pdf/'  # Substitua pelo caminho da sua pasta

# Função para listar arquivos PDF na pasta local
def listar_arquivos_pdf(pasta):
    arquivos_pdf = [f for f in os.listdir(pasta) if f.endswith('.pdf')]
    return arquivos_pdf

# Função para upload do arquivo
def upload_file(local_file_path, remote_file_path):
    try:
        # Conectar ao servidor FTP
        ftp = FTP()
        ftp.connect(ftp_host, ftp_port)
        print(f'Conectado ao servidor FTP {ftp_host} na porta {ftp_port}.')
        ftp.login(ftp_user, ftp_password)
        print('Login bem-sucedido.')
        
        # Abrir o arquivo local em modo binário
        with open(local_file_path, 'rb') as file:
            # Enviar o arquivo
            ftp.storbinary(f'STOR {remote_file_path}', file)
        
        print(f'Arquivo {local_file_path} enviado com sucesso para {remote_file_path} no servidor FTP.')
    
    except error_perm as e:
        print(f'Erro de permissão: {e}')
    except Exception as e:
        print(f'Erro: {e}')
    finally:
        # Fechar a conexão com o servidor FTP
        ftp.quit()

# Função para aguardar a resposta do usuário
def obter_resposta_usuario():
    resposta = input("Deseja prosseguir com o upload? (s/n): ").strip().lower()
    if resposta in ['s', 'sim']:
        return True
    return False

# Função para realizar a operação de upload com confirmação do usuário
def realizar_upload_com_confirmacao(pasta):
    arquivos_pdf = listar_arquivos_pdf(pasta)
    if not arquivos_pdf:
        print("Nenhum arquivo PDF encontrado na pasta.")
        return
    
    print("Arquivos PDF encontrados:")
    for arquivo in arquivos_pdf:
        print(arquivo)
    
    resposta = [None]
    
    def perguntar_usuario():
        resposta[0] = obter_resposta_usuario()
    
    # Criar uma thread para aguardar a resposta do usuário
    thread_pergunta = threading.Thread(target=perguntar_usuario)
    thread_pergunta.start()
    
    # Esperar por 15 segundos
    thread_pergunta.join(timeout=15)
    
    if resposta[0] is None:
        print("Tempo esgotado. Prosseguindo com o upload.")
        resposta[0] = True
    
    if resposta[0]:
        for arquivo in arquivos_pdf:
            local_file_path = os.path.join(pasta, arquivo)
            remote_file_path = arquivo  # Manter o mesmo nome no servidor FTP
            upload_file(local_file_path, remote_file_path)

# Chamar a função para realizar o upload com confirmação do usuário
realizar_upload_com_confirmacao(local_folder_path)
