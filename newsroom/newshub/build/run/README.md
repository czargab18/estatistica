# 📁 ESTRUTURA FINAL DO PROJETO - newshub/build

## 🚀 COMO USAR O SISTEMA DE RENDERIZAÇÃO

### 📍 Comando Principal (rodar do diretório base do projeto):
```powershell
PS C:\Users\cesar.oliveira\github\estatistica> python newsroom\newshub\build\run\render.py newsroom\newshub\build\article\artigo.md
```

### 📄 Output do Comando:
```
[2025-07-04 10:41:53] INFO: Verificando dependências...
[2025-07-04 10:41:53] SUCCESS: ✓ Pandoc via pypandoc: 3.7.0.2
[2025-07-04 10:41:53] SUCCESS: ✓ Template encontrado: ...\modelos\template.html
[2025-07-04 10:41:53] INFO: ============================================================
[2025-07-04 10:41:53] INFO: RENDERIZAÇÃO MARKDOWN - APPLE NEWSROOM (Python)
[2025-07-04 10:41:53] INFO: ============================================================
[2025-07-04 10:41:53] INFO: Entrada: newsroom\newshub\build\article\artigo.md
[2025-07-04 10:41:53] INFO: Saída: ...\newsroom\newshub\build\run\output\index.html
[2025-07-04 10:41:53] INFO: Template: ...\newsroom\newshub\build\run\..\modelos\template.html
[2025-07-04 10:41:53] INFO: ============================================================
[2025-07-04 10:41:53] INFO: Arquivo markdown carregado
[2025-07-04 10:41:53] INFO: Frontmatter extraído: 23 campos
[2025-07-04 10:41:53] INFO: Executando pypandoc...
[2025-07-04 10:41:53] INFO: HTML básico gerado pelo pypandoc
[2025-07-04 10:41:53] INFO: Processando 3 includes...
[2025-07-04 10:41:53] INFO: Processando 2 imagens...
[2025-07-04 10:41:53] INFO: ✓ Imagem copiada: img1.png → src/img1.png
[2025-07-04 10:41:53] SUCCESS: ============================================================
[2025-07-04 10:41:53] SUCCESS: SUCESSO: Arquivo HTML gerado!
[2025-07-04 10:41:53] SUCCESS: ============================================================
[2025-07-04 10:41:53] SUCCESS: Arquivo: ...\newsroom\newshub\build\run\output\index.html
[2025-07-04 10:41:53] SUCCESS: Tamanho: Input 7359 bytes → Output 16446 bytes
[2025-07-04 10:41:53] SUCCESS: 🎉 Renderização concluída com sucesso!
```

## 🛠️ PARÂMETROS DO SCRIPT PYTHON (render.py)

### 📝 Sintaxe Completa:
```bash
python render.py <arquivo_entrada> [opções]
```

### 📋 Parâmetros Disponíveis:

#### **Obrigatório:**
- **`<arquivo_entrada>`** - Caminho para o arquivo Markdown (.md)
  - Exemplo: `artigo.md`, `../article/artigo.md`, `texto.md`

#### **Opcionais:**
- **`-o, --output <arquivo>`** - Especifica arquivo de saída personalizado
  ```bash
  python render.py artigo.md -o meu_artigo.html
  ```

- **`-b, --batch`** - Modo lote para processar diretório inteiro
  ```bash
  python render.py pasta_artigos/ --batch
  ```

- **`-v, --verbose`** - Output detalhado (debug)
  ```bash
  python render.py artigo.md --verbose
  ```

- **`--open`** - Abre o arquivo gerado no navegador automaticamente
  ```bash
  python render.py artigo.md --open
  ```

- **`--base-dir <pasta>`** - Diretório base do projeto personalizado
  ```bash
  python render.py artigo.md --base-dir /caminho/personalizado
  ```

### 🎯 Exemplos de Uso:

1. **Básico** (usa configurações padrão):
   ```bash
   python render.py artigo.md
   ```

2. **Com arquivo de saída personalizado**:
   ```bash
   python render.py artigo.md -o meu_artigo.html
   ```

3. **Com output verbose e abertura automática**:
   ```bash
   python render.py artigo.md --verbose --open
   ```

4. **Modo lote para processar pasta inteira**:
   ```bash
   python render.py pasta_artigos/ --batch --verbose
   ```

5. **Diretório base personalizado**:
   ```bash
   python render.py artigo.md --base-dir /meu/projeto
   ```

### ⚙️ Comportamento Inteligente:

- **📁 Output Local**: Se existe pasta `output/` junto ao arquivo `.md`, usa automaticamente
- **🔄 Nome Automático**: `artigo.md` → `index.html` (outros mantêm o nome)
- **🖼️ Imagens**: Copia e processa imagens automaticamente para pasta `src/`
- **🧩 Componentes**: Processa includes do frontmatter YAML
- **📊 Frontmatter**: Extrai metadados YAML para template HTML

## 📖 Help Completo do Comando:
```
PS> python render.py --help

usage: render.py [-h] [-o OUTPUT] [-b] [-v] [--open] [--base-dir BASE_DIR] input

Renderizador Apple Newsroom - Versão Python

positional arguments:
  input                Arquivo markdown ou diretório para processar

options:
  -h, --help           show this help message and exit
  -o, --output OUTPUT  Arquivo de saída (opcional)
  -b, --batch          Modo lote para processar diretório
  -v, --verbose        Saída detalhada
  --open               Abrir resultado no navegador
  --base-dir BASE_DIR  Diretório base do projeto

Exemplos de uso:
  python render.py artigo.md
  python render.py artigo.md -o meu_artigo.html
  python render.py . --batch
  python render.py artigo.md --open --verbose
```

## 🗂️ Estrutura Atual
```
newshub/build/
├── article/
│   ├── artigo.md (com imagem incorporada)
│   ├── img1.png 
│   └── output/
│       └── index.html ✅ (HTML gerado de artigo.md)
├── components/
│   ├── article-header.html
│   ├── globalfooter.html
│   ├── globalheader.html
│   └── localnav.html
├── modelos/
│   └── template.html
├── requirements.txt
└── run/
    ├── config/
    │   └── config.ps1
    ├── render.cmd
    ├── render.ps1
    └── render.py ✅ (funcionando)
```

## 🖼️ IMAGEM ADICIONADA COM SUCESSO

### ✅ No Markdown (artigo.md):
```markdown
![Estúdio de Gravação Apple Music](img1.png "Estúdio de gravação com equipamento Spatial Audio"){#studio-recording .image-fullwidth .component-image data-analytics="studio-tech-image"}
```

### ✅ No HTML Renderizado:
```html
<section id="tecnologia-de-ponta-para-criação-musical" class="level2">
  <h2><strong>Tecnologia de Ponta para Criação Musical</strong></h2>
  <figure id="studio-recording">
    <img src="img1.png" 
         title="Estúdio de gravação com equipamento Spatial Audio" 
         class="image-fullwidth component-image" 
         data-analytics="studio-tech-image" 
         alt="Estúdio de Gravação Apple Music" />
    <figcaption aria-hidden="true">Estúdio de Gravação Apple Music</figcaption>
  </figure>
  <p>O coração do novo estúdio é sua capacidade de <strong>Spatial Audio</strong>...</p>
</section>
```

## 🎯 CARACTERÍSTICAS IMPLEMENTADAS:

### ✅ Output Local Automático
- **Detecção inteligente**: Se existe `article/output/`, usa automaticamente
- **Paths relativos**: Imagens ficam no mesmo diretório
- **Organização**: Cada pasta article tem seu próprio output

### ✅ Imagem com Metadados Completos
- **ID único**: `#studio-recording`  
- **Classes CSS**: `.image-fullwidth .component-image`
- **Analytics**: `data-analytics="studio-tech-image"`
- **Título**: Para hover tooltip
- **Alt text**: Para acessibilidade

### ✅ Estrutura Semântica
- **Figure/figcaption**: Estrutura HTML5 correta
- **Section com ID**: Para navegação e âncoras
- **Headers estruturados**: H2 para seções

## 🚀 PRÓXIMOS PASSOS RECOMENDADOS:

1. **Adicionar mais imagens** com diferentes classes:
   ```markdown
   ![Descrição](imagem.jpg){.image-small .float-right #minha-img}
   ```

2. **Criar galeria de imagens**:
   ```markdown
   ![Img1](img1.jpg){.gallery-item}
   ![Img2](img2.jpg){.gallery-item}
   ![Img3](img3.jpg){.gallery-item}
   ```

3. **Usar imagens responsivas**:
   ```markdown
   ![Hero](hero.jpg){.image-hero .responsive data-src-mobile="hero-mobile.jpg"}
   ```

## ✅ FUNCIONAMENTO CONFIRMADO:
- ✅ Renderização Python funcionando
- ✅ Output local automático (/article/output/)
- ✅ Imagem com ID, classes e data attributes
- ✅ Template Pandoc processando corretamente
- ✅ Estrutura semântica HTML5

## 🔄 PROCESSO DE RENDERIZAÇÃO DETALHADO

### 📋 Etapas Executadas pelo Script:

1. **🔍 Verificação de Dependências**
   - Confirma se `pypandoc` está instalado e funcionando
   - Verifica se o template `modelos/template.html` existe

2. **📂 Determinação de Arquivos**
   - **Entrada**: Arquivo `.md` especificado
   - **Saída**: Automática com lógica inteligente:
     - Se `artigo.md` → `index.html`
     - Se existe pasta `output/` local → usa a local
     - Senão → usa `run/output/`

3. **📄 Processamento do Markdown**
   - Carrega o arquivo `.md`
   - Extrai **frontmatter YAML** (metadados)
   - Processa o conteúdo Markdown

4. **🏗️ Conversão HTML com Pandoc**
   - Usa `pypandoc` para converter MD → HTML
   - Aplica o template `modelos/template.html`
   - Mantém estrutura semântica (sections, headers, etc.)

5. **🧩 Processamento de Includes**
   - Lê seção `includes:` do frontmatter
   - Insere componentes HTML (header, footer, nav, etc.)
   - Aplica componentes baseados na configuração

6. **🖼️ Processamento de Imagens**
   - Identifica imagens no HTML gerado
   - Copia imagens para pasta `src/` no output
   - Atualiza caminhos das imagens no HTML

7. **💾 Salvamento Final**
   - Salva o HTML final processado
   - Exibe estatísticas (tamanhos, tempo, etc.)
   - Opcionalmente abre no navegador

### 🎯 Características Especiais:

- **🔄 Nome Inteligente**: `artigo.md` vira `index.html` automaticamente
- **📁 Output Local**: Detecta pasta `output/` junto ao arquivo fonte
- **🖼️ Gestão de Imagens**: Copia e organiza imagens automaticamente
- **📊 Frontmatter Rico**: Suporte completo a metadados YAML
- **🧩 Sistema de Componentes**: Includes dinâmicos baseados em configuração
