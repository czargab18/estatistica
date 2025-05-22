import os

def rename_files(directory):
    for filename in os.listdir(directory):
        new_filename = filename.replace('_display_', '_')
        if new_filename != filename:
            os.rename(os.path.join(directory, filename), os.path.join(directory, new_filename))
            print(f'Renamed: {filename} to {new_filename}')

if __name__ == "__main__":
    directories = [
        'wss/fonts/SF-Pro-Text/v3/',
        'wss/fonts/SF-Pro-Display/v3'
    ]
    for directory in directories:
        rename_files(directory) 


# versão passo a passoimport os

def rename_files(directory):
    for filename in os.listdir(directory):
        new_filename = filename.replace('_display_', '_')
        if new_filename != filename:
            os.rename(os.path.join(directory, filename), os.path.join(directory, new_filename))
            print(f'Renamed: {filename} to {new_filename}')

if __name__ == "__main__":
    directory = 'wss/fonts/SF-Pro-Text/v3/'
    rename_files(directory)

if __name__ == "__main__":
    directory = 'wss/fonts/SF-Pro-Display/v3'
    rename_files(directory)
