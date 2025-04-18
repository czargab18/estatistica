import os

def createdir(structure: list = None):
    for path in structure:
        dir_path = os.path.dirname(path)
        os.makedirs(dir_path, exist_ok=True)
        with open(path, "w") as file:
            pass
