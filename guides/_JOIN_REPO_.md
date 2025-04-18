# Juntando o Repositório: documentação: Atualizando a Pasta `backend` com o Conteúdo do Repositório `api`

Este guia descreve como mesclar o conteúdo do repositório `api` na pasta `backend` do repositório `estatistica`, preservando o histórico de commits e atualizando apenas os arquivos modificados.

## Passos Detalhados

### 1. Clone o repositório `estatistica`
```sh
git clone https://github.com/cesargabrielphd/estatistica.git
cd estatistica
```
**Explicação:**
- `git clone https://github.com/cesargabrielphd/estatistica.git`: Este comando cria uma cópia local do repositório `estatistica`.
- `cd estatistica`: Navega para a pasta clonada.

### 2. Adicione o repositório `api` como um remoto separado e faça o fetch
```sh
git remote add repo2 https://github.com/cesargabrielphd/api.git
git fetch repo2
```
**Explicação:**
- `git remote add repo2 https://github.com/cesargabrielphd/api.git`: Adiciona o repositório `api` como um remoto adicional chamado `repo2`.
- `git fetch repo2`: Baixa o histórico de commits e o conteúdo do repositório `repo2`, mas não os aplica ao repositório atual.

### 3. Crie uma nova branch para o merge
```sh
git checkout -b joinrepo
```
**Explicação:**
- `git checkout -b joinrepo`: Cria e troca para uma nova branch chamada `joinrepo` para isolar as mudanças.

### 4. Faça o merge dos arquivos modificados do `repo2` na pasta `backend` utilizando `git read-tree`
```sh
git read-tree --prefix=backend/ -u repo2/main
```
**Explicação:**
- `git read-tree --prefix=backend/ -u repo2/main`: Este comando mescla o conteúdo do `repo2` na pasta `backend` do `repo1`, preservando o histórico de commits e atualizando apenas os arquivos modificados.

### 5. Faça commit das mudanças com o padrão especificado
```sh
git commit -m "repo(merge): atualizando pasta:repo2 com o repo:repo2"
```
**Explicação:**
- `git commit -m "repo(merge): atualizando pasta:repo2 com o repo:repo2"`: Faz commit das mudanças na branch `joinrepo`, preservando o histórico de commits e utilizando o padrão de mensagem especificado.

### 6. Volte para a branch principal e faça o merge
```sh
git checkout main
git merge joinrepo
```
**Explicação:**
- `git checkout main`: Troca para a branch principal (`main`) do repositório `estatistica`.
- `git merge joinrepo`: Aplica as mudanças da branch `joinrepo` na branch principal, integrando o conteúdo do `repo2`.

### 6.1. Priorize as mudanças da branch `joinrepo` em caso de conflitos
```sh
git merge -X theirs joinrepo
```
**Explicação:**
- Inicie o merge com a branch `joinrepo` priorizando as mudanças dela.
- Use a estratégia de merge `theirs` para resolver automaticamente os conflitos, garantindo que as alterações da branch `joinrepo` prevaleçam.

### 7. Empurre as mudanças para o repositório remoto
```sh
git push origin main
```
**Explicação:**
- `git push origin main`: Envia as mudanças da branch principal para o repositório remoto `estatistica`.

### 8. Remova a branch temporária e o remoto adicional
```sh
git branch -d joinrepo
git remote remove repo2
```
**Explicação:**
- `git branch -d joinrepo`: Remove a branch temporária `joinrepo` após o merge.
- `git remote remove repo2`: Remove o remoto `repo2`, que não é mais necessário, para evitar confusão futura.

## Resumo dos Comandos

```sh
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

- Certifique-se de que a branch `main` do repositório `repo2` contém o conteúdo desejado antes de iniciar o processo.
- Caso o repositório `repo2` use uma branch principal com outro nome (por exemplo, `master`), substitua `repo2/main` pelo nome correto da branch.
- A opção `--reset` no comando `git read-tree` garante que os arquivos do repositório `repo2` sobrescrevam os arquivos existentes no repositório `repo1`.