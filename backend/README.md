# Backend
Este diretório é responsavel por funcionalidades de automação do repositório. Ele inclui scripts, dados estruturados e ferramentas utilitárias.

## Estrutura do Diretório

```{plaintext}
backend/
├── build/               # Scripts e utilitários de build
├── src/
│   └── backend/
│       ├── core/
│       ├── data/
│       └── __init__.py
├── tests/               # Testes automatizados
├── tools/               # Scripts de automação
├── vendor/              # Binários e softwares de terceiros (não versionados)
├── README.md
├── requirements.txt
├── setup.py
├── pyproject.toml
├── MANIFEST.in
├── .gitignore
```

## Descrição dos Subdiretórios

- **.vscode/**: Contém configurações específicas do Visual Studio Code para facilitar o desenvolvimento.
- **backend.egg-info/**: Metadados do pacote Python, incluindo informações sobre dependências e arquivos incluídos.
- **build/**: Scripts e ferramentas para automação de tarefas, como geração de sitemaps e manipulação de links.
- **core/**: Scripts principais e utilitários que implementam a lógica do backend. Inclui funções para manipulação de livros e diretórios.
- **data/**: Contém dados estruturados utilizados pelo backend, como avisos, informações sobre disciplinas e dados para o sistema de publicação.
- **teste/**: Scripts de teste e experimentação, úteis para validar funcionalidades e testar novas implementações.

## Funcionalidades

- **Geração de Sitemap**: Criação de um arquivo `sitemap.xml` para organizar links do projeto.
- **Manipulação de Dados Acadêmicos**: Scripts para processar e organizar informações sobre disciplinas.
- **Publicação de Artigos**: Sistema integrado para criar e gerenciar artigos.
- **Automação de Tarefas**: Scripts para atualização de dados e manutenção do sistema.
- **Gerenciamento de Recursos**: Organização de imagens, scripts e estilos para publicações.


## Instalação e Configuração
Para utilizar o backend, é necessário ter o Python 3.8 ou superior instalado em seu sistema. Além disso, recomenda-se criar um ambiente virtual para evitar conflitos de dependências.

Para utilizar o backend, siga os passos abaixo:
1. Clone o repositório:
   ```{bash}
    git clone https://github.com/cesargabrielphd/estatistica.git
   ```

2. Navegue até o diretório do backend:
   ```{bash}
    cd backend
    ```
3. Instale o pacote `backend`:
   ```{bash}
   pip install -e backend
   ```
     - *observação*: ou instale as dependencias do diretorio `backend` diretamente com o comando:
         ```{bash}
         pip install -r backend/requirements.txt
         ```


- **Observações**: o diretório `backend` é projetado para ser modular e extensível. Novos serviços, scripts e dados podem ser adicionados conforme as necessidades do projeto evoluem.
