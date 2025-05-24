# Pacote `backend`

Este diretório reúne as principais funcionalidades de automação, processamento de dados e suporte à publicação acadêmica do repositório.
O backend deste projeto foi desenvolvido para automatizar tarefas, processar dados acadêmicos e facilitar a publicação de materiais didáticos. Ele utiliza Python moderno, scripts utilitários e integrações para garantir produtividade e reprodutibilidade.


## Pré-requisitos

- **Python 3.8 ou superior**
- **Git** para clonar o repositório
- **Recomendado:** uso de ambiente virtual ou do gerenciador de pacotes [`uv`](https://docs.astral.sh/uv/getting-started/)
- **Recomendado:** editor de código com suporte a Python, como [Visual Studio Code](https://code.visualstudio.com/) ou [PyCharm](https://www.jetbrains.com/pycharm/)
- **Recomendado:** terminal com suporte a scripts, como [Windows Terminal](https://aka.ms/terminal) ou [PowerShell](https://docs.microsoft.com/powershell/)

## Tutorial: Ambiente virtual Python no Windows (com ou sem `uv`)

### 1. Instale o `uv` (opcional, recomendado)

No terminal, execute:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 2. Crie o ambiente virtual

No terminal PowerShell, dentro da pasta do projeto:

- Usando `uv` (recomendado):
    ```powershell
    uv venv .venv
    ```
### 3. Ative o ambiente virtual

```powershell
.venv\Scripts\Activate
```

Se aparecer erro de permissão (PSSecurityException), siga os passos abaixo para liberar scripts temporariamente:

1. No PowerShell, execute:
    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
    ```
2. Confirme com "S" se solicitado.
3. Tente ativar novamente:
    ```powershell
    .venv\Scripts\Activate
    ```
4. Se ativar com sucesso, você verá o nome do ambiente virtual no prompt.
5. Rodar um script Python com o ambiente do projeto:
    ```powershell
    uv run src/test/renderbook.py
    ```
   ou
    ```powershell
    python src/test/renderbook.py
    ```
   > O comando `uv` é uma alternativa ao `python`, mas ambos funcionam.

5. Para desativar o ambiente virtual, use:
    ```powershell
    deactivate
    ```
6. Ao terminar, restaure a restrição de scripts:
    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
    ```

### 4. Instale dependências

- Usando `uv`:
    ```powershell
    uv pip install -r requirements.txt
    ```
    ou
    ```powershell
    uv pip install <pacote>
    ```

### 5. Desative o ambiente virtual ao terminar

```powershell
deactivate
```

### Observações

- Se não puder alterar a política de execução, use o script `.venv\Scripts\activate.bat` no CMD (Prompt de Comando), ou ajuste as variáveis de ambiente manualmente no PowerShell:
    ```powershell
    $env:VIRTUAL_ENV="$PWD\.venv"
    $env:PATH="$env:VIRTUAL_ENV\Scripts;$env:PATH"
    ```
- Para mais detalhes, consulte: [about_Execution_Policies](https://go.microsoft.com/fwlink/?LinkID=135170)


## Instalação e Configuração

### 1. Clone o repositório

```sh
git clone https://github.com/cesargabrielphd/estatistica.git
cd estatistica/backend
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

---

## Como iniciar o projeto com `uv` após criar o ambiente

Após ativar o ambiente virtual, siga estes passos para iniciar o gerenciamento do projeto com o `uv`:

1. **Inicialize o projeto com `uv`**
   No diretório do backend, execute:
   ```powershell
   uv init --package . --python 3.13.3
   ```
   Isso criará o arquivo `pyproject.toml` e configurará o ambiente para o Python 3.13.3.

2. **Se já existir um `pyproject.toml`**
   Caso o projeto já tenha sido inicializado anteriormente, você verá um erro informando que o arquivo existe.
   Para reinicializar, remova o arquivo:
   ```powershell
   del pyproject.toml
   ```
   Em seguida, repita o comando de inicialização.

3. **Sobre o parâmetro `--package`**
   - Use `--package .` para inicializar no diretório atual.
   - Use `--package backend` para criar a estrutura dentro de uma subpasta `backend/backend`.

4. **Exemplo de sequência de comandos:**
   ```powershell
   uv init
   uv init --package --python 3.13.3
   del py*.toml
   uv init --package --python 3.13.3
   del py*.toml
   uv init --package backend --python 3.13.3
   uv init --package . --python 3.13.3
   ```

> **Dica:** Sempre verifique se está no diretório correto antes de inicializar o projeto com `uv`.

---

## Observações sobre o uso do `uv init`

Durante a inicialização do projeto com o `uv`, podem ocorrer situações como:

```powershell
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> uv init
Initialized project `backend`
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> uv init --package --python 3.13.3
error: Project is already initialized in `C:\Users\cesargabriel\github\estatistica\backend` (`pyproject.toml` file exists)
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> del py*.toml
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> uv init --package --python 3.13.3
Initialized project `backend`
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> del py*.toml
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> uv init --package backend --python 3.13.3
Initialized project `backend` at `C:\Users\cesargabriel\github\estatistica\backend\backend`
(.venv) PS C:\Users\cesargabriel\github\estatistica\backend> uv init --package . --python 3.13.3
Initialized project `backend` at `C:\Users\cesargabriel\github\estatistica\backend`
```

**Notas importantes:**
- O comando `uv init` só pode ser executado em um diretório que ainda não possua o arquivo `pyproject.toml`. Caso contrário, será exibido um erro informando que o projeto já está inicializado.
- Para reinicializar, é possível remover o arquivo `pyproject.toml` e executar novamente o comando.
- O parâmetro `--package` pode receber o nome do pacote, um caminho (`.` para o diretório atual) ou um subdiretório.
- Se você passar `--package backend`, o projeto será inicializado dentro da pasta `backend/backend`.
- Para inicializar no diretório atual, utilize `--package .`.

Esses comandos são úteis para configurar corretamente o ambiente do projeto e evitar duplicidade de arquivos de configuração.
