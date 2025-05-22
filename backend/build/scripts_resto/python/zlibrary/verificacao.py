import os
from ftplib import FTP, error_perm

# Configurações do servidor FTP
ftp_host = '95.217.88.17'
ftp_user = 'collection8152'
ftp_password = '91bd48a7ca'
ftp_port = 21

# Caminho da pasta local que contém os arquivos PDF
local_folder_path = 'pdf/'  # Substitua pelo caminho da sua pasta

# Função para listar arquivos no servidor FTP
def listar_arquivos_ftp():
    try:
        # Conectar ao servidor FTP
        ftp = FTP()
        ftp.connect(ftp_host, ftp_port)
        ftp.login(ftp_user, ftp_password)
        print(f'Conectado ao servidor FTP {ftp_host} na porta {ftp_port}.')
        
        # Listar arquivos no diretório remoto
        arquivos_remotos = ftp.nlst()  # Obtém uma lista de arquivos e diretórios no diretório atual
        return arquivos_remotos

    except error_perm as e:
        print(f'Erro de permissão: {e}')
    except Exception as e:
        print(f'Erro: {e}')
    finally:
        # Fechar a conexão com o servidor FTP
        ftp.quit()
    
    return []

# Função para verificar se os arquivos estão presentes no servidor
def verificar_arquivos_no_servidor():
    arquivos_pdf = [f for f in os.listdir(local_folder_path) if f.endswith('.pdf')]
    if not arquivos_pdf:
        print("Nenhum arquivo PDF encontrado na pasta local.")
        return
    
    arquivos_remotos = listar_arquivos_ftp()
    if not arquivos_remotos:
        print("Não foi possível listar arquivos no servidor FTP.")
        return

    arquivos_local_set = set(arquivos_pdf)
    arquivos_remoto_set = set(arquivos_remotos)

    # Verificar o status dos arquivos
    resultados = []
    for arquivo in arquivos_pdf:
        status = 'Enviado e encontrado no servidor' if arquivo in arquivos_remotos else 'Não encontrado no servidor'
        resultados.append((arquivo, status))

    # Imprimir resultados
    print("Resultados da verificação:")
    for arquivo, status in resultados:
        print(f'{arquivo}: {status}')

# Chamar a função para verificar a presença dos arquivos no servidor FTP
verificar_arquivos_no_servidor()
