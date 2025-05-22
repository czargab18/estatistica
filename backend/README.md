# Backend

Este diretório reúne as principais funcionalidades de automação, processamento de dados e suporte à publicação acadêmica do repositório.

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
