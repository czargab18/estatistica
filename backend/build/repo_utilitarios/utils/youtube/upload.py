import os
import json
import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.http

# Verificar se as variáveis de ambiente estão sendo carregadas corretamente
client_id = os.getenv("CLIENT_ID")
client_secret = os.getenv("CLIENT_SECRET")

if not client_id or not client_secret:
    raise ValueError(
        "CLIENT_ID ou CLIENT_SECRET não estão definidos nas variáveis de ambiente.")

print(f"CLIENT_ID: {client_id}")
print(f"CLIENT_SECRET: {client_secret}")

client_secret_data = {
    "installed": {
        "client_id": client_id,
        "project_id": "dynamic-moment-442015-m0",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_secret": client_secret,
        "redirect_uris": [
            "http://localhost"
        ]
    }
}

# Salvar o JSON em um arquivo temporário
with open('client_secret_temp.json', 'w', encoding='utf-8') as f:
    json.dump(client_secret_data, f)

# Diretório onde estão os vídeos
VIDEO_DIRECTORY = './videos'
# Arquivo de credenciais OAuth 2.0
CLIENT_SECRETS_FILE = 'client_secret_temp.json'

# Obtenha credenciais e crie um cliente da API
scopes = ["https://www.googleapis.com/auth/youtube.upload"]
API_SERVICE_NAME = "youtube"
API_VERSION = "v3"

# Realiza a autenticação e cria o cliente da API
flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
    CLIENT_SECRETS_FILE, scopes)
credentials = flow.run_local_server(port=0)
youtube = googleapiclient.discovery.build(
    API_SERVICE_NAME, API_VERSION, credentials=credentials)


def upload_video(youtube_client, video_path):
    """
    Faz o upload de um vídeo para o YouTube.

    Args:
        youtube_client: O cliente da API do YouTube.
        video_path: O caminho para o arquivo de vídeo a ser enviado.
    """
    # Extrai o título do vídeo a partir do nome do arquivo
    video_title = os.path.splitext(os.path.basename(video_path))[0]

    request_body = {
        'snippet': {
            'title': video_title,
            'description': 'Descrição do Vídeo',
            'tags': ['canaldeestatistica', 'estatistica', 'universitaria'],
            'categoryId': '27'
        },
        'status': {
            'privacyStatus': 'private'
        }
    }

    media_file = googleapiclient.http.MediaFileUpload(video_path)
    request = youtube_client.videos().insert(
        part='snippet,status',
        body=request_body,
        media_body=media_file
    )
    response = request.execute()
    print(f'Upload do vídeo "{
          video_path}" concluído. ID do vídeo: {response["id"]}')


# Percorre todos os arquivos de vídeo no diretório e faz o upload
for video_file in os.listdir(VIDEO_DIRECTORY):
    if video_file.endswith('.mp4'):  # Verifica se o arquivo é um vídeo MP4
        upload_video(youtube, os.path.join(VIDEO_DIRECTORY, video_file))
