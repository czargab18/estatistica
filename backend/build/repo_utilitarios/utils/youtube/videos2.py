import os
import yt_dlp

def video_already_downloaded(video_title, download_directory):
    # Verifica se o arquivo do vídeo já existe no diretório de downloads
    for file_name in os.listdir(download_directory):
        if file_name.startswith(video_title):
            return True
    return False

def download_playlist(playlist_url, download_directory):
    # Opções de configuração para o yt-dlp
    ydl_opts = {
        'format': 'best',  # baixa a melhor qualidade disponível
        'outtmpl': os.path.join(download_directory, '%(title)s.%(ext)s'),  # salva os vídeos com o título como nome do arquivo
        'noplaylist': False,  # garante que toda a playlist será baixada
        'skip_download': True,  # apenas obtém informações dos vídeos, sem baixar
    }

    # Obtém informações sobre a playlist
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        playlist_info = ydl.extract_info(playlist_url, download=False)

    # Itera sobre os vídeos da playlist
    for video in playlist_info['entries']:
        video_title = video['title']
        if video_already_downloaded(video_title, download_directory):
            print(f'Vídeo "{video_title}" já foi baixado. Pulando...')
        else:
            # Baixa o vídeo se ainda não foi baixado
            ydl_opts['skip_download'] = False
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                ydl.download([video['webpage_url']])
            print(f'Vídeo "{video_title}" baixado com sucesso.')

# URL da playlist
playlist_url = 'https://youtube.com/playlist?list=PLX-4skTGVrWUNh2VGFIyoWVGEVRQq3gkB&si=uCws3gRSujmWAHKd'
# Diretório onde os vídeos serão salvos
download_directory = './downloads'

# Cria o diretório de downloads se não existir
os.makedirs(download_directory, exist_ok=True)

# Baixa a playlist
download_playlist(playlist_url, download_directory)