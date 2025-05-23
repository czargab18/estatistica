"""
Este script baixa vídeos de uma playlist do YouTube usando yt-dlp.
"""

import yt_dlp as yt

# URL da playlist
URL = "https://youtube.com/playlist?list=PLX-4skTGVrWUNh2VGFIyoWVGEVRQq3gkB&si=uCws3gRSujmWAHKd"

yt.ydl_opts = {
    "format": "best",
    "outtmpl": "videos/%(title)s.%(ext)s",
    "noplaylist": False,
    "playlist_items": "1-3,7,10",
    "nocheckcertificate": True,
}

# Baixar a playlist
with yt.YoutubeDL(yt.ydl_opts) as ydl:
    ydl.download([URL])
