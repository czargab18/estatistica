# Pacote utilitários

Instlar pacote utilitários
```{bash}
  cd ./utils
  pip install -e .
```

## Aplicativos para serem intalados 
```{sh}
  Git
  R
  Python
  TinyTeX
  Pandoc 
  Quarto 
  Vscode
  Node.js
  Warsaw # Aplicativo Autenticação Banco do Brasil
  Obsidian
  Figma
  HTTrack
  Z-Library
  Wintoys
  WhatsApp
```

# Utilitários
O repositório contém ``scripts úteis`` e ferramentas desenvolvidas em R e Python. É projetado para fornecer utilitários que facilitam diversas tarefas e automações.

## Linguagens Utilizadas
- **R**
- **Python**

## Estrutura do Repositório

- `docs/`: Documentação e arquivos auxiliares.
- `data/`: Conjunto de dados utilizados pelos scripts.
- `scripts/`: Contém ``scripts Python e R`` para automação e outras tarefas.

## Como usar?

1. Clone o repositório:
    ```{sh}
    git clone https://github.com/seu_usuario/utilitarios.git
    ```
2. Navegue até o diretório desejado:
    ```{sh}
    cd utilitarios/scripts
    ```
Usando scripts da Linguagem ``Python``:
   1. Use o ambiente virtual do python
       ```{py}
       python -m venv .venv
       ```
   2. Ative o ambiente virtual:
       ```{py}
       .venv\Scripts\activate
       ```
   3. Instale as dependências:
       ```{py}
       pip install -r requirements.txt
       ```
   4. Execute o script desejado:
       ```{py}
       python exemplo.py
       ```

Usando scripts da Linguagem ``R``:
   1. Instale ``languageserver`` do ``CRAN``
        ```{r}
        install.packages("languageserver")
        ```
   2. Instale o ``httpgd`` do CRAN
        ```{r}
        install.packages("httpgd")
        ```
   3. Instale a ``Extensão R``  do VSCode: [REditorSupport](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r)
   
   4.  Configure o ``settings.json`` do VSCode: ` "r.plot.useHttpgd": true,`
        ```{json}
          /* LINGUAGEM R */
            "r.bracketedPaste": true,
            "r.plot.useHttpgd": true,
            "r.alwaysUseActiveTerminal": false,
            "r.plot.defaults.plotPreviewLayout": "multirow",
            "r.plot.timing.refreshInterval": 10,
            "r.lsp.debug": true,
            "r.lsp.enabled": true,
            "r.rmarkdown.enableCodeLens": true,
            "r.rterm.windows": "C:\\Program Files\\R\\bin\\R.exe",
            "r.rpath.windows": "C:\\Program Files\\R\\bin\\R.exe",
            "r.libPaths": [
                "C:\\Program Files\\R\\bin\\R.exe",
                "C:\\Users\\seu_usuario\\AppData\\Local\\Programs\\R\\versão_R\\library\\"
            ],
            "r.helpPanel.previewLocalPackages": [
                "C:\\Program Files\\R\\bin\\R.exe",
                "C:\\Users\\seu_usuario\\AppData\\Local\\Programs\\R\\versão_R\\library\\"
            ],
            "r.rterm.option": [
                "--no-save",
                "--no-restore",
                "C:\\Program Files\\R\\bin\\R.exe",
                "--r-binary=C:\\Users\\seu_usuario\\AppData\\Local\\Programs\\R\\versão_R\\R.exe"
            ],
        ```

# Rmarkdown

Pandoc: https://pandoc.org/installing.html

baixar versão do https://github.com/jgm/pandoc/releases/tag/3.1.11

qual versão baixar: `pandoc-3.1.11-windows-x86_64.msi`
baixar o tipo .msi para facilitar a instalação.

verifique o local onde foi instalado. Normalmente fica na pasta
`C:\Users\czarg\AppData\Local\Pandoc`

Adicionar ao Path `C:\Users\czarg\AppData\Local\Pandoc`

# LaTeX no VSCode

instalar o TinyTeX **usando o R como Adimministrador**:
```
install.packages('tinytex')
dir.create("C:\\Program Files\\TinyTex", showWarnings = FALSE, recursive = TRUE)
tinytex::install_tinytex(dir = "C:\\Program Files\\TinyTex",force=TRUE)
```

Para desinstalar o TinyTeX, run:
`tinytex::uninstall_tinytex()`

Para compilar um documento LaTeX para PDF, chame uma destas funções (dependendo do mecanismo LaTeX que você deseja usar) em tinytex: pdflatex(), xelatex() e lualatex(). Quando essas funções detectam pacotes LaTeX necessários, mas não instalados no TinyTeX, elas instalarão automaticamente os pacotes ausentes por padrão.
`
 <!-- writeLines(c( -->
   <!-- '\\documentclass{article}', -->
   <!-- '\\begin{document}', 'Hello world!', '\\end{document}' -->
 <!-- ), 'test.tex') -->
tinytex::pdflatex('test.tex')

`

Adicionar ao Path `C:\Users\czarg\AppData\Roaming\TinyTeX\bin\windows\`

## Aplicativos para serem intalados 
```{sh}
  Git
  R
  Python
  TinyTeX
  Pandoc 
  Quarto 
  Vscode
  Node.js
  Warsaw # Aplicativo Autenticação Banco do Brasil
  Obsidian
  Figma
  HTTrack
  Z-Library
  Wintoys
  WhatsApp
```

## Variáveis de Ambiente que podem ser configuradas
```{sh}
  \Users\seu_usuario
  C:\Program Files\Quarto\bin;
  C:\Windows\system32;
  C:\Windows;
  C:\Windows\System32\Wbem;
  C:\Windows\System32\WindowsPowerShell\v1.0\;
  C:\Windows\System32\OpenSSH\;
  C:\Program Files\Pandoc\;
  C:\Program Files\Pandoc\pandoc;
  C:\Program Files\nodejs\;
  C:\Program Files\Git\cmd;
  C:\Program Files\Python\Scripts\;
  C:\Program Files\Python\;
  C:\Users\seu_usuario\AppData\Local\Programs\Python\Launcher\;
  C:\Users\seu_usuario\AppData\Local\Microsoft\WindowsApps;
  C:\Program Files\Visual Studio Code\bin;
  C:\Program Files\nodejs\node_modules\npm\;
  C:\Users\seu_usuario\AppData\Roaming\npm;
  C:\Program Files\Quarto\bin\;
  C:\Program Files\TinyTex\;
  C:\Program Files\TinyTex\texmf-dist\tex\latex\;
  C:\Program Files\TinyTex\bin\windows;
  C:\Users\seu_usuario\Documents\github\tcc\TinyTex\bin\windows;
  C:\Users\seu_usuario\Documents\github\tcc\tcc\TinyTex\bin\windows;
  C:\Users\seu_usuario\AppData\Roaming\TinyTeX\;
  C:\Program Files\Python\Scripts\pip.exe;
  C:\Program Files\Python\Scripts\pip3.exe;
  C:\Program Files\Python\Scripts\pip3.13.exe;
  C:\Program Files\WindowsPowerShell\Modules;
  C:\Windows\system32\WindowsPowerShell\v1.0\Modules
```

## Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença
Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](/utilitarios/.github/LICENSE) para mais detalhes.
Você pode ajustar conforme necessário para incluir mais detalhes específicos sobre os scripts e ferramentas disponíveis no repositório.