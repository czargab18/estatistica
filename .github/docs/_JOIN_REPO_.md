Para juntar dois repositórios git e manter os commits de ambos, você pode seguir os seguintes passos:

1. Clone o primeiro repositório:
    ```{bash}
    git clone <URL_do_primeiro_repo>
    cd <nome_do_primeiro_repo>
    ```
2. Adicione o segundo repositório como um remoto:
    ```{bash}
    git remote add segundo-repo <URL_do_segundo_repo>
    ```
3. Busque os dados do segundo repositório:
    ```{bash}
    git fetch segundo-repo
    ```
4. Mescle o segundo repositório no primeiro:
    ```{bash}
    git merge segundo-repo/main --allow-unrelated-histories
    ```
     - Nota: Substitua main pelo nome da branch principal do segundo repositório, se necessário.

5. Resolva quaisquer conflitos que possam surgir durante a mesclagem.

6. Faça commit das mudanças, se necessário:
    ```{bash}
    git commit -m "Mesclagem do segundo repositório"
    ```
1. Por fim, você pode empurrar as mudanças para o repositório remoto:
    ```{bash}
    git push origin main
    ```

Esses passos irão juntar dois repositórios git e manter os commits de ambos. Se precisar de mais informações ou ajuda com um passo específico, sinta-se à vontade para perguntar!

# Refer~encias

- [**copilot**](https://github.com/copilot/)