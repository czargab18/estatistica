import os

def rename_files_to_lowercase(directory):
    for filename in os.listdir(directory):
        lowercase_filename = filename.lower()
        new_filename = rename_pattern(lowercase_filename)
        os.rename(
            os.path.join(directory, filename),
            os.path.join(directory, new_filename)
        )

def rename_pattern(filename):
    parts = filename.split('-')
    if len(parts) > 2:
        new_filename = '-'.join(parts[:3]) + '_' + '_'.join(parts[2:])
    else:
        new_filename = filename
    return new_filename

if __name__ == "__main__":
    # Diretório atual
    directory = "wss/fonts/SF-Pro-Text/v3/"
    rename_files_to_lowercase(directory)
