import os
from ftplib import FTP, error_perm, error_temp

# Configurações do servidor FTP
ftp_host = '95.217.88.17'
ftp_user = 'collection8152'
ftp_password = '91bd48a7ca'
ftp_port = 21

# Função para conectar e obter informações do servidor FTP
def verificar_status_ftp():
    try:
        # Conectar ao servidor FTP
        ftp = FTP()
        ftp.connect(ftp_host, ftp_port, timeout=10)
        ftp.login(ftp_user, ftp_password)
        print(f'Conectado ao servidor FTP {ftp_host} na porta {ftp_port}.')
        
        # Obter informações básicas
        print("Informações do servidor:")
        print(f"Diretório atual: {ftp.pwd()}")
        
        # Listar arquivos e diretórios no diretório atual
        arquivos = ftp.nlst()
        print("Arquivos e diretórios no diretório atual:")
        for arquivo in arquivos:
            print(f"- {arquivo}")

        # Verificar espaço disponível, se possível
        try:
            ftp.sendcmd('SITE STATS')  # Tentativa de obter estatísticas
        except error_perm:
            print("O comando 'SITE STATS' não é suportado pelo servidor.")
        except error_temp as e:
            print(f"Erro temporário ao tentar obter estatísticas: {e}")

    except error_perm as e:
        print(f'Erro de permissão: {e}')
    except Exception as e:
        print(f'Erro: {e}')
    finally:
        # Fechar a conexão com o servidor FTP
        ftp.quit()

# Chamar a função para verificar o status do servidor FTP
verificar_status_ftp()
