import os

def createdir(structure: list = None):
    for path in structure:
        dir_path = os.path.dirname(path)
        if not os.path.exists(dir_path):
            os.makedirs(dir_path, exist_ok=True)
        if not os.path.isdir(path):
            with open(path, "w") as file:
                pass
