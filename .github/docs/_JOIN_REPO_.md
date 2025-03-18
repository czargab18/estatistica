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

    **Nota:** Caso você receba o erro `Entry 'api/README.md' overlaps with 'api/README.md'. Cannot bind.`, isso significa que já existem arquivos na pasta `api` que conflitam com os arquivos do repositório `api`. Para resolver:

    1. Remova ou mova os arquivos conflitantes da pasta `api` antes de executar o comando:
        ```sh
        rm -rf api/*
        ```
        **Explicação:** Este comando remove todos os arquivos existentes na pasta `api`. Certifique-se de fazer backup dos arquivos, se necessário.

    2. Execute novamente o comando `git read-tree`:
        ```sh
        git read-tree --prefix=api/ -u api/main
        ```

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

13. Se desejar, você pode excluir o repositório `api` clonado localmente.

### Notas Adicionais

- Certifique-se de que a branch `main` do repositório `api` contém o conteúdo desejado antes de iniciar o processo.
- Caso o repositório `api` use uma branch principal com outro nome (por exemplo, `master`), substitua `api/main` pelo nome correto da branch.
- Se você precisar preservar os arquivos existentes na pasta `api`, mova-os para outro local antes de executar o comando `git read-tree`.