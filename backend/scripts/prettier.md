# Tutorial para Configurar e Usar o Prettier no VS Code

## Passo 1: Instalar Node.js e npm

1. Baixe e instale o Node.js a partir do site oficial: https://nodejs.org/
2. Durante a instalação, certifique-se de que a opção para instalar o npm (Node Package Manager) está selecionada.
3. Após a instalação, abra um novo terminal e verifique se o Node.js e o npm foram instalados corretamente executando os seguintes comandos:
   ```{sh}
   node -v
   npm -v
   ```

## Passo 2: Instalar o Prettier
1. No terminal, instale o Prettier globalmente executando o comando:
   ```{sh}
   npm install -g prettier
   ```
## Passo 3: Configurar o Prettier no VS Code
1. Abra o VS Code.
2. Vá para a aba de extensões (ícone de quadrado no lado esquerdo ou ``Ctrl+Shift+X``).
3. Procure por "Prettier - Code formatter" e instale a extensão.
4. Abra as configurações do VS Code (``Ctrl+,``).
5. Procure por "Format On Save" e marque a opção "Editor: Format On Save".
6. Certifique-se de que o Prettier é o formatador padrão. Procure por "Default Formatter" e selecione "Prettier - Code formatter".

## Passo 4: Configuração adicional no ``settings.json`` (opcional)
1. Abra o arquivo de configurações JSON (``Ctrl+Shift+P`` e digite "Preferences: Open Settings (JSON)").
2. Adicione as seguintes configurações para garantir que o Prettier seja usado para formatação:
      ```{sh}
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

## Passo 5: Executar o Prettier manualmente
1. Abra o terminal integrado no VS Code (``Ctrl+`` ou`` View > Terminal``).
2. Navegue até o diretório do seu projeto.
3. Execute o comando Prettier para formatar os arquivos desejados. Por exemplo, para formatar todos os arquivos HTML no diretório:
      ```{sh}
      prettier --write "**/*.html"
      ```
Seguindo esses passos, você configurará o Prettier para formatar automaticamente seus arquivos ao salvar e também poderá executá-lo manualmente quando necessário.


# Referência:
- www.github.com/copilot/