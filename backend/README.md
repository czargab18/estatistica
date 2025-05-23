# Backend

Este diretório reúne as principais funcionalidades de automação, processamento de dados e suporte à publicação acadêmica do repositório.

## Gerenciador de pacotes e projetos Python: `uv`

O [`uv`](https://docs.astral.sh/uv/getting-started/) é um gerenciador de pacotes e ambientes Python extremamente rápido, escrito em Rust.

### Instalação do `uv`

**Linux/macOS:**
```sh
wget -qO- https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell):**
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

### Inicializando o projeto com `uv`

1. Acesse o diretório do backend:
   ```sh
   cd backend
   ```
2. Inicialize o projeto (opcionalmente defina a versão do Python):
   ```sh
   uv init --python 3.13
   ```
   > O comando acima cria o arquivo `uv.toml` e prepara o ambiente.

3. Adicione dependências:
   ```sh
   uv add numpy
   uv add requests
   # ...adicione outros pacotes conforme necessário
   ```

4. Para rodar um script Python com o ambiente do projeto:
   ```sh
   uv run src/test/renderbook.py
   # ou
   uv run main.py
   ```

### Gerenciando versões do Python com `uv`

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

## Sobre
Um gerenciador de pacotes e projetos Python extremamente rápido, escrito em Rust.


## Documentação para tornar `backend` como projeto `uv`

[link da documentação](https://docs.astral.sh/uv/concepts/projects/)

Os aplicativos são o destino padrão para , mas também podem ser especificados com o sinalizador.uv init--app
```
cd backend
uv init
```
Os arquivos Python podem ser executados com:uv run
```
uv run arquivo_a_ser_rodado.py

```

## como instalar?
```{cmd}
wget -qO- https://astral.sh/uv/install.sh | sh
```
ou via Powershell

```{Powershell}
powershell -c "irm https://astral.sh/uv/install.ps1 | more"
```
verifique se foi bem instalado
```{cmd}
PS:> uv
```

[Versões do Python](https://docs.astral.sh/uv/getting-started/features/#python-versions)
Instalando e gerenciando o próprio Python.

- uv python install: Instale as versões do Python.
- uv python list: Exibir as versões disponíveis do Python.
- uv python find: Encontre uma versão do Python instalada.
- uv python pin: Fixe o projeto atual para usar uma versão específica do Python.
- uv python uninstall: Desinstale uma versão do Python.


Consulte o [guia sobre como instalar o Python](https://docs.astral.sh/uv/guides/install-python/) para começar.


## tutorial Augusto Galego
```{}
PS C:\Users\cesargabriel> powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"            Downloading uv 0.7.7 (x86_64-pc-windows-msvc)                                                                           Installing to C:\Users\cesargabriel\.local\bin
  uv.exe
  uvx.exe
everything's installed!

To add C:\Users\cesargabriel\.local\bin to your PATH, either restart your shell or run:

    set Path=C:\Users\cesargabriel\.local\bin;%Path%   (cmd)
    $env:Path = "C:\Users\cesargabriel\.local\bin;$env:Path"   (powershell)
PS C:\Users\cesargabriel>

```

```{}
cd ~/.github/estatistica

# iniciar com python versão 3.13
uv init --pythpn 3.13

# pacote numpy
uv add numpy
```

```{}
# rodar arquivo main.py
uv run main.py
```

```{}

```




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

---

## Descrição dos Subdiretórios

- **build/**: Scripts de construção, pós-processamento, integração ou experimentação relacionados ao projeto.
- **src/backend/**: Código-fonte principal do pacote Python, contendo módulos, funções e recursos essenciais.
- **src/backend/data/**: Dados estáticos, exemplos ou recursos acessíveis pelos módulos do pacote.
- **tests/**: Testes automatizados para garantir a integridade do código.
- **tools/**: Scripts utilitários e de automação para facilitar operações recorrentes.
- **vendor/**: Binários e softwares de terceiros utilizados pontualmente ou por automações (ignore no Git).

---

## Funcionalidades

- **Geração de Sitemap**: Automatiza a criação de um arquivo `sitemap.xml` para organizar e indexar links do projeto.
- **Manipulação de Dados Acadêmicos**: Processamento e organização de informações sobre disciplinas, livros e materiais didáticos.
- **Publicação de Artigos**: Suporte à criação, processamento e gestão de artigos acadêmicos.
- **Automação de Tarefas**: Scripts para atualização de dados, manutenção rotineira e integração de sistemas.
- **Gerenciamento de Recursos**: Organização de imagens, scripts e estilos para publicações ou relatórios.

---

## Instalação e Configuração

> **Pré-requisitos:**  
> - Python 3.8 ou superior  
> - Recomenda-se o uso de um ambiente virtual para isolar dependências.

### 1. Clone o repositório

```bash
git clone https://github.com/cesargabrielphd/estatistica.git
```

### 2. Navegue até o diretório do backend

```bash
cd estatistica/backend
```

### 3. Instale o pacote `backend` no modo desenvolvimento

```bash
pip install -e .
```

### 4. (Alternativa) Instale apenas as dependências

```bash
pip install -r requirements.txt
```

---

## Observações

- Scripts de automação adicionais podem ser executados diretamente a partir do diretório `tools/`.
- Binários e softwares em `vendor/` **não são versionados**; recompile ou baixe-os conforme instruções internas.
- Para empacotar o backend para distribuição, utilize:
  ```bash
  python -m build
  ```

---

## Contato

Dúvidas, sugestões ou contribuições? Abra uma issue ou entre em contato pelo [perfil do mantenedor](https://github.com/cesargabrielphd).


# backend/tools/README.md
Destinado a adicionar scripts, executáveis, software e ferramentas de linha de comando úteis para o projeto.

## Exemplo
- Posso instalar o tinyTeX na pasta `tools` e adicionar o executável `tlmgr` ao meu task, para que eu possa usar o comando `tlmgr` em qualquer lugar do sistema.
