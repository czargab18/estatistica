# Backend
Este diretório é responsavel por funcionalidades de automação do repositório. Ele inclui scripts, dados estruturados e ferramentas utilitárias.

## Estrutura do Diretório

```{plaintext}
backend/              # Diretório principal do backend
├── .vscode/          # Configurações do Visual Studio Code
│   └── settings.json # Configurações do ambiente de desenvolvimento
├── backend.egg-info/ # Metadados do pacote Python
│   ├── PKG-INFO      # Informações sobre o pacote
│   ├── requires.txt  # Dependências do projeto
│   ├── SOURCES.txt   # Lista de arquivos incluídos no pacote
│   └── top_level.txt # Diretórios principais do pacote
├── build/            # Scripts e ferramentas de construção
│   ├── booksguide.py # Script para automação de books quarto
│   ├── ger_sitemap.py # Gera o arquivo `sitemap.xml`
│   ├── rename_links.py # Renomeia links em arquivos
│   └── ...           # Outros scripts de suporte
├── core/             # Scripts principais e utilitários
│   ├── books/        # Scripts relacionados a livros e materiais acadêmicos
│   │   └── functions.py # Funções para manipulação de livros
│   ├── dir/          # Scripts para manipulação de diretórios e arquivos
│   │   └── list_paths_folders.py # Lista caminhos e pastas
│   └── utils/        # Scripts utilitários gerais
│       └── ger_sitemap.py # Gera o arquivo `sitemap.xml`
├── data/             # Dados utilizados pelo backend
│   ├── avisos/       # Dados relacionados a avisos e eventos
│   │   └── avisos.json # Lista de avisos
│   ├── books/        # Dados sobre disciplinas e livros
│   │   └── disciplinas.json # Informações detalhadas sobre disciplinas acadêmicas
│   └── newsroom/     # Dados para o sistema de publicação
├── teste/            # Scripts de teste e experimentação
│   ├── t2.py         # Script de teste
│   └── __teste__.py  # Arquivo de experimentação
├── requirements.txt  # Dependências do projeto
├── setup.py          # Script de configuração do pacote
└── MANIFEST.in       # Arquivos incluídos no pacote
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
