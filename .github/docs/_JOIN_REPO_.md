## Juntando o Repositório

Este guia descreve como integrar o repositório `repo2` na pasta `repo2` do repositório `repo1`, sobrescrevendo os arquivos existentes e preservando o histórico de commits.

### Passos Detalhados

1. Clone o repositório principal (`repo1`):
    ```sh
    git clone https://github.com/usuario/repo1.git
    cd repo1
    ```
    **Explicação:** Este comando cria uma cópia local do repositório `repo1` e navega para a pasta clonada.

2. Adicione o repositório secundário (`repo2`) como um remoto separado:
    ```sh
    git remote add repo2 https://github.com/usuario/repo2.git
    ```
    **Explicação:** Certifique-se de executar este comando dentro da pasta do repositório `repo1`. Isso adiciona o repositório `repo2` como um remoto adicional chamado `repo2`.

3. Faça fetch do conteúdo do repositório `repo2`:
    ```sh
    git fetch repo2
    ```
    **Explicação:** Este comando baixa o histórico de commits e o conteúdo do repositório `repo2`, mas não os aplica ao repositório atual.

4. Crie uma nova branch para o merge e uma pasta `repo2` para o conteúdo:
    ```sh
    git checkout -b repo2-merge
    mkdir -p repo2
    ```
    **Explicação:** A nova branch `repo2-merge` é criada para isolar as mudanças. A pasta `repo2` será usada para armazenar o conteúdo do repositório `repo2`.

5. Faça o merge do conteúdo do repositório `repo2` na pasta `repo2`, sobrescrevendo os arquivos existentes:
    ```sh
    git read-tree --prefix=repo2/ -u --reset repo2/main
    ```
    **Explicação:** Este comando insere o conteúdo do repositório `repo2` na pasta `repo2` dentro do repositório `repo1`, sobrescrevendo os arquivos existentes e preservando o histórico de commits.

6. Faça commit das mudanças:
    ```sh
    git commit -m "Merge repo2 into repo2 folder while preserving history"
    ```
    **Explicação:** O commit salva as mudanças feitas na branch `repo2-merge`, incluindo o conteúdo do repositório `repo2`.

7. Volte para a branch principal:
    ```sh
    git checkout main
    ```
    **Explicação:** Este comando retorna para a branch principal (`main`) do repositório `repo1`.

8. Integre as mudanças:
    ```sh
    git merge repo2-merge
    ```
    **Explicação:** O merge aplica as mudanças da branch `repo2-merge` na branch principal, integrando o conteúdo do repositório `repo2`.

9. Empurre as mudanças para o repositório remoto:
    ```sh
    git push origin main
    ```
    **Explicação:** Este comando envia as mudanças da branch principal para o repositório remoto `repo1`.

10. Remova a branch temporária:
    ```sh
    git branch -d repo2-merge
    ```
    **Explicação:** Após o merge, a branch `repo2-merge` não é mais necessária e pode ser excluída para manter o repositório organizado.

11. Remova o remoto adicional:
    ```sh
    git remote remove repo2
    ```
    **Explicação:** O remoto `repo2` também não é mais necessário e pode ser removido para evitar confusão futura.

12. Pronto! O repositório `repo2` foi integrado na pasta `repo2` do repositório `repo1`, sobrescrevendo os arquivos existentes e preservando os históricos de commits.

### Notas Adicionais

- Certifique-se de que a branch `main` do repositório `repo2` contém o conteúdo desejado antes de iniciar o processo.
- Caso o repositório `repo2` use uma branch principal com outro nome (por exemplo, `master`), substitua `repo2/main` pelo nome correto da branch.
- A opção `--reset` no comando `git read-tree` garante que os arquivos do repositório `repo2` sobrescrevam os arquivos existentes no repositório `repo1`.