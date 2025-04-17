# Backend

O diretório `backend` é o núcleo do projeto, responsável por gerenciar dados, executar processos automatizados e fornecer suporte para diversas funcionalidades relacionadas à Estatística e ao ambiente acadêmico. Ele inclui scripts, dados estruturados e ferramentas utilitárias que suportam tanto o frontend quanto a API.

---

## Estrutura do Diretório

```plaintext
.vscode/              # Configurações específicas do Visual Studio Code
backend.egg-info/     # Metadados do pacote Python
core/                 # Scripts principais e utilitários
data/                 # Dados utilizados pelo backend
newsroom/             # Sistema de publicação de artigos
teste/                # Scripts de teste e experimentação
```

---

## Descrição dos Subdiretórios

### `.vscode/`
- Contém configurações específicas para o editor Visual Studio Code.
- **Arquivos importantes**:
  - `settings.json`: Configurações do ambiente de desenvolvimento.

### `backend.egg-info/`
- Metadados do pacote Python gerados durante a instalação ou desenvolvimento.
- **Arquivos importantes**:
  - `PKG-INFO`: Informações sobre o pacote.
  - `requires.txt`: Dependências do projeto.

### `core/`
- Contém scripts utilitários e funções principais para o backend.
- **Subdiretórios**:
  - `books/`: Scripts relacionados a livros e materiais acadêmicos.
  - `dir/`: Scripts para manipulação de diretórios e arquivos.
  - `utils/`: Scripts utilitários gerais.
- **Arquivos importantes**:
  - `books/functions.py`: Funções para manipulação de livros.
  - `dir/list_paths_folders.py`: Lista caminhos e pastas.
  - `utils/ger_sitemap.py`: Gera o arquivo `sitemap.xml`.

### `data/`
- Armazena dados estruturados e arquivos de suporte.
- **Subdiretórios**:
  - `avisos/`: Dados relacionados a avisos e eventos.
  - `books/`: Dados sobre disciplinas e livros.
  - `newsroom/`: Dados para o sistema de publicação.
- **Arquivos importantes**:
  - `books/disciplinas.json`: Informações detalhadas sobre disciplinas acadêmicas.
  - `avisos/avisos.json`: Lista de avisos.

### `newsroom/`
- Sistema de publicação de artigos e gerenciamento de conteúdo.
- **Subdiretórios**:
  - `articles/`: Artigos publicados.
  - `assets/`: Recursos estáticos como scripts e estilos.
  - `images/`: Imagens utilizadas nos artigos.
  - `newshub/`: Modelos e conteúdo gerado.
- **Arquivos importantes**:
  - `index.html`: Página inicial do sistema de publicação.
  - `NEWSROOM.md`: Documentação do sistema.

### `teste/`
- Scripts de teste e experimentação.
- **Arquivos importantes**:
  - `t2.py`: Script de teste.
  - `__teste__.py`: Arquivo de experimentação.

---

## Funcionalidades

- **Geração de Sitemap**: Criação de um arquivo `sitemap.xml` para organizar links do projeto.
- **Manipulação de Dados Acadêmicos**: Scripts para processar e organizar informações sobre disciplinas.
- **Publicação de Artigos**: Sistema integrado para criar e gerenciar artigos.
- **Automação de Tarefas**: Scripts para atualização de dados e manutenção do sistema.
- **Gerenciamento de Recursos**: Organização de imagens, scripts e estilos para publicações.

---

## Como Utilizar

1. Certifique-se de que todas as dependências estão instaladas.
2. Execute os scripts no diretório conforme necessário:
   - Para gerar o sitemap: `python core/utils/ger_sitemap.py`.
   - Para processar livros: `python core/books/functions.py`.
   - Para publicar artigos: Utilize os recursos do diretório `newsroom/`.

---

## Observações

O diretório `backend` é projetado para ser modular e extensível. Novos serviços, scripts e dados podem ser adicionados conforme as necessidades do projeto evoluem.
