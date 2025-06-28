# Guia Completo do Projeto Estatística

Este documento unifica todos os guias e padrões específicos do projeto estatística, incluindo configurações SSH, formatação de código e procedimentos de merge de repositórios.

---

## 📋 Índice

1. [Padrões SSH](#padrões-ssh)
2. [Configuração Prettier](#configuração-prettier)
3. [Merge de Repositórios](#merge-de-repositórios)

---

## 🔐 Padrões SSH {#padrões-ssh}

### Visão Geral

- notebook ==> Hospedagem
- notebook ==> GitHub
- Autenticação (feito no painel da hostinger):
  - GitHub |==> Hospedagem (Solicitação)
  - GitHub <==| Hospedagem (Permissão)
  
**Observação:** A chave **Auth privada** criada e salva como 
"estatistica-auth-github_hostinge" deve ser colocada no 
repositório do GitHub e a **Auth publica** no painel da Hostinger

### Nomenclatura

**Padrão de chave:** `dominio-equipamento-local-serverof@serverto`

- **domínio**: domínio do site que se refere.
- **equipamento**: tipo de equipamento (PC, Notebook, etc.).
- **local**: Localização (Casa, Trabalho, Faculdade, etc.).
- **serverof**: Servidor que solicita (Local-casa, Github, etc.).
- **serverto**: Servidor que autoriza (hospedagem).

**Observação:** Se a interação for entre Hospedagem e GitHub, então os parâmetros
`equipamento-local` mudam para `auth`

### Exemplos de Comandos SSH

#### Comando Base
```bash
ssh-keygen -t rsa -b 4096 -C "estatistica-nb-home-local@hostinger"
```
**Observação:** renomear a chave para `estatistica-nb-home-local_hostinger`

```bash
ssh-keygen -t rsa -b 4096 -C "estatistica-auth-github@hostinger"
```
**Observação:** renomear a chave para `estatistica-nb-home-github_hostinger`

### Tipos de Chave

#### Notebook para a Hospedagem Hostinger
```bash
ssh-keygen -t rsa -b 4096 -C "nb-home-local-estatistica@hostinger"
```

#### Notebook para o GitHub
```bash
ssh-keygen -t rsa -b 4096 -C "estatistica-nb-home-local@github"
```

#### Auth entre Github e Hospedagem Hostinger
```bash
ssh-keygen -m PEM -t rsa -b 4096 -C "nb-home-estatistica-local@hostinger"
```

### Referências SSH
- YouTube [Código Fonte TV](https://www.youtube.com/watch?v=lfoYZ1tz33k&list=PLcX1VCeOd7Sz976bwnWOV-1cE9I6TAmd_&index=1&t=228s&pp=gAQBiAQB)

---

## 🎨 Configuração Prettier {#configuração-prettier}

### Passo 1: Instalar Node.js e npm

1. Baixe e instale o Node.js: https://nodejs.org/
2. Durante a instalação, certifique-se de que a opção para instalar o npm está selecionada.
3. Após a instalação, verifique se foram instalados corretamente:
   ```bash
   node -v
   npm -v
   ```

### Passo 2: Instalar o Prettier

No terminal, instale o Prettier globalmente:
```bash
npm install -g prettier
```

### Passo 3: Configurar o Prettier no VS Code

1. Abra o VS Code
2. Vá para a aba de extensões (`Ctrl+Shift+X`)
3. Procure por "Prettier - Code formatter" e instale a extensão
4. Abra as configurações do VS Code (`Ctrl+,`)
5. Procure por "Format On Save" e marque a opção "Editor: Format On Save"
6. Certifique-se de que o Prettier é o formatador padrão. Procure por "Default Formatter" e selecione "Prettier - Code formatter"

### Passo 4: Configuração adicional no settings.json (opcional)

1. Abra o arquivo de configurações JSON (`Ctrl+Shift+P` e digite "Preferences: Open Settings (JSON)")
2. Adicione as seguintes configurações:
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### Passo 5: Executar o Prettier manualmente

1. Abra o terminal integrado no VS Code (`Ctrl+`` ou `View > Terminal`)
2. Navegue até o diretório do seu projeto
3. Execute o comando Prettier para formatar os arquivos desejados:

```bash
# Formatar todos os arquivos HTML
prettier --write "**/*.html"

# Formatar múltiplos tipos de arquivo
prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,md}"
```

### Referências Prettier
- www.github.com/copilot/

---

## 🔀 Merge de Repositórios {#merge-de-repositórios}

Este guia descreve como mesclar o conteúdo do repositório `api` na pasta `backend` do repositório `estatistica`, preservando o histórico de commits e atualizando apenas os arquivos modificados.

### Passos Detalhados

#### 1. Clone o repositório `estatistica`
```bash
git clone https://github.com/cesargabrielphd/estatistica.git
cd estatistica
```
**Explicação:**
- `git clone`: Cria uma cópia local do repositório `estatistica`
- `cd estatistica`: Navega para a pasta clonada

#### 2. Adicione o repositório `api` como um remoto separado e faça o fetch
```bash
git remote add repo2 https://github.com/cesargabrielphd/api.git
git fetch repo2
```
**Explicação:**
- `git remote add repo2`: Adiciona o repositório `api` como um remoto adicional chamado `repo2`
- `git fetch repo2`: Baixa o histórico de commits e o conteúdo do repositório `repo2`, mas não os aplica ao repositório atual

#### 3. Crie uma nova branch para o merge
```bash
git checkout -b joinrepo
```
**Explicação:**
- `git checkout -b joinrepo`: Cria e troca para uma nova branch chamada `joinrepo` para isolar as mudanças

#### 4. Faça o merge dos arquivos modificados do `repo2` na pasta `backend` utilizando `git read-tree`
```bash
git read-tree --prefix=backend/ -u repo2/main
```
**Explicação:**
- `git read-tree --prefix=backend/ -u repo2/main`: Mescla o conteúdo do `repo2` na pasta `backend` do `repo1`, preservando o histórico de commits e atualizando apenas os arquivos modificados

#### 5. Faça commit das mudanças com o padrão especificado
```bash
git commit -m "repo(merge): atualizando pasta:repo2 com o repo:repo2"
```
**Explicação:**
- Faz commit das mudanças na branch `joinrepo`, preservando o histórico de commits e utilizando o padrão de mensagem especificado

#### 6. Volte para a branch principal e faça o merge
```bash
git checkout main
git merge joinrepo
```
**Explicação:**
- `git checkout main`: Troca para a branch principal (`main`) do repositório `estatistica`
- `git merge joinrepo`: Aplica as mudanças da branch `joinrepo` na branch principal, integrando o conteúdo do `repo2`

#### 6.1. Priorize as mudanças da branch `joinrepo` em caso de conflitos
```bash
git merge -X theirs joinrepo
```
**Explicação:**
- Inicia o merge com a branch `joinrepo` priorizando as mudanças dela
- Usa a estratégia de merge `theirs` para resolver automaticamente os conflitos, garantindo que as alterações da branch `joinrepo` prevaleçam

#### 7. Empurre as mudanças para o repositório remoto
```bash
git push origin main
```
**Explicação:**
- `git push origin main`: Envia as mudanças da branch principal para o repositório remoto `estatistica`

#### 8. Remova a branch temporária e o remoto adicional
```bash
git branch -d joinrepo
git remote remove repo2
```
**Explicação:**
- `git branch -d joinrepo`: Remove a branch temporária `joinrepo` após o merge
- `git remote remove repo2`: Remove o remoto `repo2`, que não é mais necessário, para evitar confusão futura

### Resumo dos Comandos

```bash
# Clone o repositório estatistica
git clone https://github.com/cesargabrielphd/estatistica.git
cd estatistica

# Adicione o repositório api e faça fetch
git remote add repo2 https://github.com/cesargabrielphd/api.git
git fetch repo2

# Crie uma nova branch para o merge
git checkout -b joinrepo

# Faça o merge dos arquivos modificados do repo2 na pasta backend utilizando git read-tree
git read-tree --prefix=backend/ -u repo2/main

# Faça commit das mudanças com o padrão especificado
git commit -m "repo(merge): atualizando pasta:repo2 com o repo:repo2"

# Volte para a branch principal e faça o merge
git checkout main
git merge joinrepo

# Priorize as mudanças da branch joinrepo em caso de conflitos
git merge -X theirs joinrepo

# Empurre as mudanças para o repositório remoto
git push origin main

# Remova a branch temporária e o remoto adicional
git branch -d joinrepo
git remote remove repo2
```

### Notas Adicionais

- Certifique-se de que a branch `main` do repositório `repo2` contém o conteúdo desejado antes de iniciar o processo
- Caso o repositório `repo2` use uma branch principal com outro nome (por exemplo, `master`), substitua `repo2/main` pelo nome correto da branch
- A opção `--reset` no comando `git read-tree` garante que os arquivos do repositório `repo2` sobrescrevam os arquivos existentes no repositório `repo1`

---

## 📝 Conclusão

Este guia unificado contém todas as informações necessárias para:

- ✅ Configurar e gerenciar chaves SSH seguindo padrões específicos
- ✅ Configurar formatação automática com Prettier
- ✅ Realizar merge de repositórios preservando histórico

Para mais informações sobre padrões de commit e desenvolvimento, consulte [.copilot-instructions.md](../copilot/.copilot-instructions.md).

---

> **Nota:** Este documento foi criado consolidando os guias individuais do projeto estatística. Mantenha-o atualizado conforme novos procedimentos sejam estabelecidos.
