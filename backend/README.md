# Documentação do Repositório

## Estrutura do Projeto

O repositório está organizado da seguinte forma:

```
_backend_/
├── data/
│   ├── avisos/
│   │   ├── avisos.json
│   │   ├── eventos.json
│   ├── books/
│   │   ├── disciplinas.json
│   ├── newsroom/
│       ├── article.json
├── newsroom/
│   ├── article/
│   │   ├── artigo.txt
│   ├── modelo/
│   │   ├── modelo.html
│   │   ├── src/
│   ├── iterativo.py
│   ├── manual.py
│   ├── resto_funcoes.py
├── repositorio/
│   ├── create_dir.py
│   ├── ger_sitemap.py
│   ├── rename_links.py
│   ├── requirements.txt
```

---

## Descrição das Pastas e Arquivos

### `_backend_/data/`
Contém os dados utilizados pelo sistema.

- **avisos/**: Contém arquivos JSON relacionados a avisos e eventos.
  - `avisos.json`: Lista de avisos.
  - `eventos.json`: Lista de eventos.
- **books/**: Contém informações sobre disciplinas.
  - `disciplinas.json`: Dados sobre disciplinas, incluindo código, nome, carga horária, e tipo.
- **newsroom/**: Contém dados relacionados a artigos.
  - `article.json`: Informações sobre artigos criados.

---

### `_backend_/newsroom/`
Contém scripts e templates para manipulação de artigos.

- **article/**:
  - `artigo.txt`: Modelo de conteúdo de um artigo.
- **modelo/**:
  - `modelo.html`: Template HTML para artigos.
  - `src/`: Diretório para arquivos auxiliares do modelo.
- **iterativo.py**: Script para interagir com o usuário e coletar informações sobre artigos.
- **manual.py**: Contém funções para manipulação de artigos, como salvar conteúdo em JSON, mover arquivos e gerar templates HTML.
- **resto_funcoes.py**: Funções auxiliares para manipulação de artigos, como geração de identificadores e atualização de caminhos.

---

### `_backend_/repositorio/`
Scripts utilitários para manutenção do repositório.

- **create_dir.py**: Cria a estrutura de diretórios e arquivos necessários.
- **ger_sitemap.py**: Gera um arquivo `sitemap.xml` para SEO.
- **rename_links.py**: Corrige e ajusta links em arquivos HTML, CSS e JS.
- **requirements.txt**: Lista de dependências do projeto.

---

## Funcionalidades Principais

1. **Manipulação de Artigos**:
   - Criação e edição de artigos utilizando templates.
   - Salvamento de artigos em formato JSON.
   - Geração de arquivos HTML para publicação.

2. **Manutenção do Repositório**:
   - Criação de diretórios e arquivos necessários.
   - Geração de `sitemap.xml` para SEO.
   - Ajuste de links para diferentes ambientes (local, hospedagem, GitHub Pages).

3. **Gerenciamento de Dados**:
   - Manipulação de dados de disciplinas, avisos e eventos.

---

## Como Executar

### Requisitos
Certifique-se de ter as dependências instaladas. Use o arquivo `requirements.txt` para instalar:

```bash
pip install -r _backend_/repositorio/requirements.txt
```

### Scripts Principais

- **Gerar Sitemap**:
  ```bash
  python _backend_/repositorio/ger_sitemap.py
  ```

- **Criar Estrutura de Diretórios**:
  ```bash
  python _backend_/repositorio/create_dir.py
  ```

- **Manipular Artigos**:
  Execute os scripts na pasta `_backend_/newsroom/` para criar, editar ou mover artigos.

---

## Contribuição

1. Faça um fork do repositório.
2. Crie uma branch para sua feature ou correção:
   ```bash
   git checkout -b minha-feature
   ```
3. Faça commit das suas alterações:
   ```bash
   git commit -m "Minha nova feature"
   ```
4. Envie para o repositório remoto:
   ```bash
   git push origin minha-feature
   ```
5. Abra um Pull Request.

---

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

## Referências
- [github.com/copilot](https://www.github.com/copilot)

