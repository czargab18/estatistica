# Backend

Este diretório reúne as principais funcionalidades de automação, processamento de dados e suporte à publicação acadêmica do repositório.

---

## Visão Geral

O backend deste projeto foi desenvolvido para automatizar tarefas, processar dados acadêmicos e facilitar a publicação de materiais didáticos. Ele utiliza Python moderno, scripts utilitários e integrações para garantir produtividade e reprodutibilidade.

---

## Pré-requisitos

- **Python 3.8 ou superior**
- **Git** para clonar o repositório
- **Recomendado:** uso de ambiente virtual ou do gerenciador de pacotes [`uv`](https://docs.astral.sh/uv/getting-started/)

---

## Instalação e Configuração

### 1. Clone o repositório

```sh
git clone https://github.com/cesargabrielphd/estatistica.git
cd estatistica/backend
```

### 2. Instale as dependências

#### Opção A: Usando pip (tradicional)

- Instale o pacote no modo desenvolvimento:
  ```sh
  pip install -e .
  ```
- Ou apenas as dependências:
  ```sh
  pip install -r requirements.txt
  ```

#### Opção B: Usando o gerenciador de pacotes `uv` (recomendado)

O [`uv`](https://docs.astral.sh/uv/getting-started/) é um gerenciador de pacotes e ambientes Python extremamente rápido, escrito em Rust.

**Instalação do `uv`:**
- **Linux/macOS:**
  ```sh
  wget -qO- https://astral.sh/uv/install.sh | sh
  ```
- **Windows (PowerShell):**
  ```powershell
  powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```

Após instalar, adicione o diretório ao PATH, se necessário:
- **cmd:**
  ```cmd
  set Path=%USERPROFILE%\.local\bin;%Path%
  ```
- **PowerShell:**
  ```powershell
  $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
  ```

Verifique a instalação:
```sh
uv --version
```

**Inicializando o projeto com `uv`:**

1. Acesse o diretório do backend:
   ```sh
   cd backend
   ```
2. Inicialize o pacote da pasta `backend` (opcionalmente defina a versão do Python):
   ```sh
   uv init --package --python 3.13
   ```
   > O comando acima cria o arquivo `uv.lock` e prepara o ambiente.
3. Adicione [dependências](https://docs.astral.sh/uv/concepts/projects/dependencies/#platform-specific-dependencies):
   ```sh
   uv add numpy
   uv add requests
   # ...adicione outros pacotes conforme necessário
   ```
   ```sh
   uv add -r requirements.txt
   ```
   ou para remover as dependencias:
    ```sh
    uv remove requirements.txt
    ```
4. Para rodar um script Python com o ambiente do projeto:
   ```sh
   uv run src/test/renderbook.py
   ```

**Gerenciando versões do Python com `uv`:**
- Instalar uma versão específica do Python:
  ```sh
  uv python install 3.13
  ```
- Listar versões disponíveis:
  ```sh
  uv python list
  ```
- Fixar o projeto para uma versão específica:
  ```sh
  uv python pin 3.13
  ```

Mais informações: [Documentação oficial do uv](https://docs.astral.sh/uv/concepts/projects/)

---

## Estrutura do Diretório

```plaintext
backend/
├── build/               # Scripts e utilitários de build, pós-processamento e experimentação
├── src/
│   └── backend/
│       ├── core/        # Código-fonte principal e módulos centrais do backend
│       ├── data/        # Dados estáticos ou exemplos distribuídos com o pacote
│       └── __init__.py
├── tests/               # Testes automatizados (pytest/unittest)
├── tools/               # Scripts de automação e utilitários para tarefas recorrentes
├── vendor/              # Binários, softwares e dependências de terceiros (não versionados)
├── README.md            # Documentação principal deste diretório
├── requirements.txt     # Lista de dependências do projeto backend
├── setup.py             # Script de configuração para empacotamento via setuptools
├── pyproject.toml       # Configuração para build moderno do Python (PEP 517/518)
├── MANIFEST.in          # Instruções para inclusão de arquivos extras no pacote
├── .gitignore           # Arquivos e pastas ignorados pelo Git
```

### Descrição dos Subdiretórios

- **build/**: Scripts de construção, pós-processamento, integração ou experimentação relacionados ao projeto.
- **src/backend/**: Código-fonte principal do pacote Python, contendo módulos, funções e recursos essenciais.
- **src/backend/data/**: Dados estáticos, exemplos ou recursos acessíveis pelos módulos do pacote.
- **tests/**: Testes automatizados para garantir a integridade do código.
- **tools/**: Scripts utilitários e de automação para facilitar operações recorrentes.
- **vendor/**: Binários e softwares de terceiros utilizados pontualmente ou por automações (ignore no Git).

---

## Funcionalidades Principais

- **Geração de Sitemap**: Automatiza a criação de um arquivo `sitemap.xml` para organizar e indexar links do projeto.
- **Manipulação de Dados Acadêmicos**: Processamento e organização de informações sobre disciplinas, livros e materiais didáticos.
- **Publicação de Artigos**: Suporte à criação, processamento e gestão de artigos acadêmicos.
- **Automação de Tarefas**: Scripts para atualização de dados, manutenção rotineira e integração de sistemas.
- **Gerenciamento de Recursos**: Organização de imagens, scripts e estilos para publicações ou relatórios.

---

## Dicas e Boas Práticas

- Scripts de automação adicionais podem ser executados diretamente a partir do diretório `tools/`.
- Binários e softwares em `vendor/` **não são versionados**; recompile ou baixe-os conforme instruções internas.
- Para empacotar o backend para distribuição, utilize:
  ```sh
  python -m build
  ```
- Sempre utilize ambientes isolados (virtualenv, uv, etc) para evitar conflitos de dependências.
- Consulte a documentação dos scripts e módulos para entender parâmetros e exemplos de uso.

---

## Contato

Dúvidas, sugestões ou contribuições? Abra uma issue ou entre em contato pelo [perfil do mantenedor](https://github.com/cesargabrielphd).

---

# backend/tools/README.md
Destinado a adicionar scripts, executáveis, software e ferramentas de linha de comando úteis para o projeto.

## Exemplo
- Posso instalar o tinyTeX na pasta `tools` e adicionar o executável `tlmgr` ao meu task, para que eu possa usar o comando `tlmgr` em qualquer lugar do sistema.
