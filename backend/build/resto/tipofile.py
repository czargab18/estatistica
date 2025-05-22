"""Não é necessária mais"""

MIME_TIPOS = {
    "application/json": "json",
    "text/csv": "csv",
    "application/vnd.ms-excel": "excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "sheet",
    "text/plain": "text",
    "text/html": "html",
    "application/pdf": "pdf",
    "image/jpeg": "jpeg",
    "image/png": "png",
    "image/gif": "gif",
    "image/webp": "webp",
    "video/mp4": "mp4",
    "video/x-msvideo": "avi",
    "application/zip": "zip",
    "application/x-rar-compressed": "rar",
    "application/x-tar": "tar",
    "application/gzip": "gzip",
    "audio/mpeg": "mp3",
    "audio/wav": "wav",
    "audio/ogg": "ogg",
    "application/xml": "xml",
    "application/javascript": "javascript",
    "application/x-python-code": "python",
    "image/svg+xml": "svg",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "docx",
    "application/msword": "doc",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation": "pptx",
    "application/vnd.ms-powerpoint": "ppt",
}


def tipefile(path: str = None):
    """
    Detecta o tipo MIME de um arquivo ou de uma lista de arquivos.
    Args:
        path (str, opcional): Caminho para um único arquivo. 
            Se fornecido, detecta o tipo MIME deste arquivo.
    Returns:
        str: O tipo MIME correspondente ao arquivo com base no dicionário `MIME_TIPOS`.
             Se nenhum tipo MIME for reconhecido, retorna "unknown".
             Se nenhum caminho for fornecido, retorna `None`.
    Observações:
        - Utiliza a biblioteca `mimetypes` para determinar o tipo MIME com base na extensão do arquivo.
        - O mapeamento de tipos MIME para nomes curtos é definido no dicionário `MIME_TIPOS`.
    Exemplos:
        >>> CAMINHOS = ["file.csv", "file", "file2.xls", "path/to/file/file.csv"]
        >>> tipefile(path=CAMINHOS[0])
        'csv'
        >>> tipefile(path="./path/to/file/example.json")
        'json'
        >>> tipefile()
        None

    Comentário:
        - MIME (Multipurpose Internet Mail Extensions) é um padrão da Internet que define tipos de dados para facilitar a troca de informações entre sistemas.
        - Um tipo MIME é composto por duas partes principais: o tipo e o subtipo, separados por uma barra (/). Exemplos incluem:
            - text/html: Representa um arquivo HTML.
            - image/jpeg: Representa uma imagem no formato JPEG.
            - application/json: Representa um arquivo JSON.
        - Os tipos MIME ajudam sistemas e aplicativos a entenderem como processar ou exibir um arquivo, garantindo compatibilidade e funcionalidade adequada.
    """
    if path:
        tipo, _ = mimetypes.guess_type(path)
        return MIME_TIPOS.get(tipo, "unknown")
    else:
        return None
