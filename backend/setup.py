from setuptools import setup, find_packages

setup(
    name="backend",
    version="0.1.0",
    description="Pacote backend é destinado a automações do repositório de estatistica",
    author="César Gabriel",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    install_requires=[
        "beautifulsoup4 >= 4.13.4",
        # Liste aqui as dependências do seu pacote (ou use requirements.txt)
    ],
    include_package_data=True,
    python_requires=">=3.13",
)
