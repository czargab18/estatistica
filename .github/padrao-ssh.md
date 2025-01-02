## SSH por repositório:
- notebook ==> Hospedagem
- notebook ==> GitHub
- Autenticação (feito no painel da hostinger):
  - GitHub |==> Hospedagem (Solicitação)
  - GitHub <==| Hospedagem (Permição)
Observação: A chave **Auth privada** criada e salva como 
"estatistica-auth-github_hostinge" deve ser colocada no 
repositório do GitHub e a **Auth publica** no painel da Hostinger

## Nomenclatura

padrão de chave: `dominio-equipamento-local-serverof@serverto`
- **dominio**:  domínio do site que se refere.
- **equipamento**: tipo de equipamento (PC, Notebook, etc.).
- **local**: Localização (Casa, Trabalho, Faculdade, etc.).
- **serverof**: Servidor que solicita (Local-casa, Github, etc.).
- **serverto**: Servidor que autoriza (hospedagem).
Observação: Se a interação for entre Hospedagem e GitHub, então os parametros
`equipamento-local` para `auth`

### Exemplos
```{bash}
C:\~\.ssh> ssh-keygen -t rsa -b 4096 -C "estatistica-nb-home-local@hostinger"
```
Observação: renomear a chave para **``estatistica-nb-home-local_hostinger``**
```{bash}
C:\~\.ssh> ssh-keygen -t rsa -b 4096 -C "estatistica-auth-github@hostinger"
```
Observação: renomear a chave para **``estatistica-nb-home-github_hostinger``**

## Tipo de chave
- Notebook para a Hospedagem Hostinger
  ```{}
  ssh-keygen -t rsa -b 4096 -C "nb-home-local-estatistica@hostinger"
  ```
- Notebook para o GitHub
  ```{}
  ssh-keygen -t rsa -b 4096 -C "estatistica-nb-home-local@github"
  ```
- Auth entre Github e Hospedagem Hostinger
  ```{}
  ssh-keygen -m PEM -t rsa -b 4096 -C "nb-home-estatistica-local@hostinger"
  ```

## Referência
- YouTube [Código Fonte TV](https://www.youtube.com/watch?v=lfoYZ1tz33k&list=PLcX1VCeOd7Sz976bwnWOV-1cE9I6TAmd_&index=1&t=228s&pp=gAQBiAQB)