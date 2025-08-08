# Lógica das actions de 'newshub'

O objetivo é a action é permitir a criação e edição de noticias e que elas possam ser renderizadas e publicadas no site [estatistica.pro/newshub/](https://estatistica.pro/newshub/).

Esta action é acionada quando um arquivo é editado no repositório, e ela executa os seguintes passos:

1. **Checkout do repositório**: A action faz o checkout do repositório para acessar os arquivos que foram editados.

2. **Instalação de dependências**: Instala as dependências necessárias para o projeto, garantindo que todas as bibliotecas e ferramentas necessárias estejam disponíveis.

3. **Renderização das noticias**: A action renderiza as noticias utilizando o `quarto`.

4. **Publicação das noticias**: Após a renderização, as noticias são publicadas em [czargab18.github.io/newshub/](https://czargab18.github.io/newshub/).

5. **Commit e push das alterações**: Se houver alterações nas noticias, a action faz um commit e push dessas alterações para o repositório remoto.

6. **Sincronização de arquivos**: o repositório `newshub` notifica, via API, o repositório `estatistica.pro` para que puxe as alterações do submodulo, sinconize os arquivos entre os repositórios e atualize apágina do site [estatistica.pro/newsroom/](https://estatistica.pro/newshub/).

As noticias renderizadas ficam em uma pasta `newsroom` dentro do repositório `newshub`.