# Juntando os repositórios
Fundindo os repositórios `backend` e `estatisitca`.

## Usando o Comando merge
1. Adicione o repositório ``backend`` como um remoto:
    ```{bash}
      cd estatistica
      git remote add backend https://github.com/cesargabrielphd/backend.git
    ```
2. Fetch o repositório "backend":
    ```{bash}
      git fetch backend
    ```
3. Faça o merge dos dois repositórios:
    ```{bash}
      git merge backend/main --allow-unrelated-histories
    ```

## Considerações
- **Preservar histórico de commits**: Se precisar manter o histórico de commits de ambos os repositórios, a técnica de merge é preferível.