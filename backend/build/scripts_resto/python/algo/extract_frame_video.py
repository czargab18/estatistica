import cv2
import os

def extract_frames(video_path, output_folder, num_frames, quality=95):
    """
    Extrai um número específico de frames de um vídeo.

    :param video_path: Caminho para o arquivo de vídeo.
    :param output_folder: Pasta onde os frames serão salvos.
    :param num_frames: Número de frames a serem extraídos.
    :param quality: Qualidade dos frames salvos (1-100, padrão 95).
    """
    # Carrega o vídeo
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise ValueError(f"Não foi possível abrir o vídeo: {video_path}")

    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    frame_interval = max(1, total_frames // num_frames)

    frame_count = 0
    extracted_count = 0

    while cap.isOpened() and extracted_count < num_frames:
        ret, frame = cap.read()
        if not ret:
            break

        if frame_count % frame_interval == 0:
            frame_filename = f"{output_folder}/frame_{extracted_count:04d}.jpg"
            # Salva o frame com a qualidade especificada
            cv2.imwrite(frame_filename, frame, [cv2.IMWRITE_JPEG_QUALITY, quality])
            extracted_count += 1

        frame_count += 1

    cap.release()
    print(f"{extracted_count} frames extraídos para {output_folder}.")

if __name__ == "__main__":
    path = "path\\to\\video"
    pathsave = "path\\to\\save\\frames\\video"
    nframes = 34 * 4
    quality = 100 
    if not os.path.exists(pathsave):
        os.makedirs(pathsave)
    extract_frames(path, pathsave, nframes, quality)
