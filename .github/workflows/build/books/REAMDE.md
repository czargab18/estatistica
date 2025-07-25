# Lógica das actions de 'books'

O objetivo desta action é permitir a edição dos livros e eles possam ser renderizados e publicados no site [estatistica.pro/book/](https://estatistica.pro/book/).

Esta action é acionada quando um arquivo é editado no repositório, e ela executa os seguintes passos:
1. **Checkout do repositório**: A action faz o checkout do repositório para acessar os arquivos que foram editados.

2. **Instalação de dependências**: Instala as dependências necessárias para o projeto, garantindo que todas as bibliotecas e ferramentas necessárias estejam disponíveis.

3. **Renderização dos livros**: A action renderiza os livros utilizando o `quarto`. 

4. **Publicação dos livros**: Após a renderização, os livros são publicados em em [czargab18.github.io/books/](https://czargab18.github.io/books/)

5. **Commit e push das alterações**: Se houver alterações nos livros, a action faz um commit e push dessas alterações para o repositório remoto.

6. **Sincronização de arquivos**: o repositório `books` notifica, via API, o repositório `estatistica.pro` para que puxe as alterações do submodulo, sinconize os arquivos entre os repositórios e atualize apágina do site [estatistica.pro/book/](https://estatistica.pro/book/).

Os livros renderizados ficaram em uma pasta `book` dentro do repositório `books`.