import os
def generate_tree(root_dir, prefix=""):
    tree = []
    files = sorted(os.listdir(root_dir))
    for i, name in enumerate(files):
        path = os.path.join(root_dir, name)
        if os.path.isdir(path):
            tree.append(f"{prefix}├───{name}/")
            if i == len(files) - 1:
                tree.extend(generate_tree(path, prefix + "    "))
            else:
                tree.extend(generate_tree(path, prefix + "│   "))
        else:
            tree.append(f"{prefix}└───{name}")
    return tree
def save_tree_to_txt(tree, filename="tree_structure.txt"):
    with open(filename, "w", encoding="utf-8") as f:
        f.write("\n".join(tree))

root_directory = "." 
tree_structure = generate_tree(root_directory)
save_tree_to_txt(tree_structure)

print(f"Tree structure saved to {os.path.abspath('tree_structure.txt')}")

# Versão 2
import os


def generate_tree(root_dir, prefix="", ignore_dirs=None):
    if ignore_dirs is None:
        ignore_dirs = []
    ignore_dirs = [d.strip("/").strip() for d in ignore_dirs]
    tree = []
    files = sorted(os.listdir(root_dir))
    for i, name in enumerate(files):
        path = os.path.join(root_dir, name)
        if os.path.isdir(path):
            if name in ignore_dirs:
                continue
            tree.append(f"{prefix}├───{name}/")
            if i == len(files) - 1:
                tree.extend(generate_tree(path, prefix + "    ", ignore_dirs))
            else:
                tree.extend(generate_tree(path, prefix + "│   ", ignore_dirs))
        else:
            tree.append(f"{prefix}└───{name}")
    return tree


def save_tree_to_txt(tree, filename="tree_structure.txt"):
    with open(filename, "w", encoding="utf-8") as f:
        f.write("\n".join(tree))


if __name__ == "__main__":
    root_directory = "." 
    ignore_dirs = input(
        "Digite os nomes das pastas que deseja ignorar, separados por vírgulas: "
    ).split(",")
    ignore_dirs = [d.strip() for d in ignore_dirs]

    tree_structure = generate_tree(root_directory, ignore_dirs=ignore_dirs)
    save_tree_to_txt(tree_structure)

    print(f"Tree structure saved to {os.path.abspath('tree_structure.txt')}")
