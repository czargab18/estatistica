## Juntando o Repositório

Este guia descreve como integrar o repositório `api` na pasta `api` do repositório `estatistica`, preservando o histórico de commits.

### Passos Detalhados

1. Clone o repositório `estatistica`:
    ```sh
    git clone https://github.com/cesargabrielphd/estatistica.git
    cd estatistica
    ```
    **Explicação:** Este comando cria uma cópia local do repositório `estatistica` e navega para a pasta clonada.

2. Adicione o repositório `api` como um remoto separado:
    ```sh
    git remote add api https://github.com/cesargabrielphd/api.git
    ```
    **Explicação:** Certifique-se de executar este comando dentro da pasta do repositório `estatistica` (ou seja, após o comando `cd estatistica`). Isso adiciona o repositório `api` como um remoto adicional chamado `api`.

3. Faça fetch do conteúdo do repositório `api`:
    ```sh
    git fetch api
    ```
    **Explicação:** Este comando baixa o histórico de commits e o conteúdo do repositório `api`, mas não os aplica ao repositório atual.

4. Crie uma nova branch para o merge e uma pasta `api` para o conteúdo:
    ```sh
    git checkout -b api-merge
    mkdir api
    ```
    **Explicação:** A nova branch `api-merge` é criada para isolar as mudanças. A pasta `api` será usada para armazenar o conteúdo do repositório `api`.

5. Faça o merge do conteúdo do repositório `api` na pasta `api`:
    ```sh
    git read-tree --prefix=api/ -u api/main
    ```
    **Explicação:** Este comando insere o conteúdo do repositório `api` na pasta `api` dentro do repositório `estatistica`, preservando o histórico de commits.

    **Nota:** Caso você deseje substituir as mudanças no repositório `api` sem remover o conteúdo existente, utilize o comando com a opção `--reset`:
    ```sh
    git read-tree --prefix=api/ -u --reset api/main
    ```
    **Explicação:** A opção `--reset` força a atualização do conteúdo na pasta `api`, sobrescrevendo os arquivos existentes com os do repositório `api`. Isso evita a necessidade de remover manualmente os arquivos conflitantes.

6. Faça commit das mudanças:
    ```sh
    git commit -m "Merge api repository into api folder while preserving history"
    ```
    **Explicação:** O commit salva as mudanças feitas na branch `api-merge`, incluindo o conteúdo do repositório `api`.

7. Volte para a branch principal:
    ```sh
    git checkout main
    ```
    **Explicação:** Este comando retorna para a branch principal (`main`) do repositório `estatistica`.

8. Integre as mudanças:
    ```sh
    git merge api-merge
    ```
    **Explicação:** O merge aplica as mudanças da branch `api-merge` na branch principal, integrando o conteúdo do repositório `api`.

9. Empurre as mudanças para o repositório remoto:
    ```sh
    git push origin main
    ```
    **Explicação:** Este comando envia as mudanças da branch principal para o repositório remoto `estatistica`.

10. Remova a branch temporária:
    ```sh
    git branch -d api-merge
    ```
    **Explicação:** Após o merge, a branch `api-merge` não é mais necessária e pode ser excluída para manter o repositório organizado.

11. Remova o remoto adicional:
    ```sh
    git remote remove api
    ```
    **Explicação:** O remoto `api` também não é mais necessário e pode ser removido para evitar confusão futura.

12. Pronto! O repositório `api` foi integrado na pasta `api` do repositório `estatistica`.

13. Se desejar, você pode excluir o repositório `api` clonado localmente:
    ```cmd
    rmdir /s /q api
    ```
    **Explicação:** Este comando remove a pasta `api` e todo o seu conteúdo de forma recursiva e silenciosa. Certifique-se de estar no diretório correto antes de executar este comando para evitar a exclusão acidental de outras pastas.

### Notas Adicionais

- Certifique-se de que a branch `main` do repositório `api` contém o conteúdo desejado antes de iniciar o processo.
- Caso o repositório `api` use uma branch principal com outro nome (por exemplo, `master`), substitua `api/main` pelo nome correto da branch.
- Para substituir mudanças no repositório `api` sem remover o conteúdo existente, utilize o comando `git read-tree` com a opção `--reset`.

### Ignorando Pastas ou Arquivos ao Juntar Repositórios

Se você deseja integrar dois repositórios, mas ignorar pastas ou arquivos específicos, siga os passos abaixo:

1. **Clone o repositório principal**:
   ```bash
   git clone <url-do-repositorio-principal>
   cd <nome-do-repositorio-principal>
   ```

2. **Adicione o repositório secundário como remoto**:
   ```bash
   git remote add repo-secundario <url-do-repositorio-secundario>
   ```

3. **Busque o conteúdo do repositório secundário**:
   ```bash
   git fetch repo-secundario
   ```

4. **Crie uma branch para integração**:
   ```bash
   git checkout -b integracao-repo-secundario repo-secundario/main
   ```

5. **Remova as pastas ou arquivos que deseja ignorar**:
   ```bash
   git rm -r --cached <caminho-da-pasta-ou-arquivo>
   ```

6. **Mescle a branch de integração na branch principal**:
   ```bash
   git checkout main
   git merge --allow-unrelated-histories integracao-repo-secundario
   ```

7. **Finalize o processo**:
   - Confirme as alterações.
   - Faça o commit final:
     ```bash
     git commit -m "Mesclando repositórios com exclusão de arquivos/pastas específicas"
     ```
   - Remova o remoto do repositório secundário, se necessário:
     ```bash
     git remote remove repo-secundario
     ```

Agora, o repositório principal conterá os arquivos do repositório secundário, exceto aqueles que foram ignorados.

**Nota:** Certifique-se de substituir `<url-do-repositorio-principal>`, `<url-do-repositorio-secundario>` e `<caminho-da-pasta-ou-arquivo>` pelos valores corretos.