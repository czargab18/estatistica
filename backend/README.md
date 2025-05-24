# Pacote `backend`

---

## Tutorial: Usando o `uv` package manager com venv Python

### 1. Instale o `uv`

No terminal, execute:

```powershell
pip install uv
```

### 2. Crie o ambiente virtual com o Python mais recente

No terminal PowerShell, dentro da pasta do projeto:

```powershell
uv venv .venv
```

### 3. Ative o ambiente virtual

```powershell
.venv\Scripts\Activate
```

Se aparecer erro de permissão (PSSecurityException), siga o tutorial abaixo para liberar scripts temporariamente.

### 4. Instale dependências usando o `uv`

```powershell
uv pip install -r requirements.txt
```

Ou instale pacotes normalmente:

```powershell
uv pip install <pacote>
```

### 5. Desative o ambiente virtual ao terminar

```powershell
deactivate
```

---

# Estatística

...existing code...

---

## Tutorial: Usando venv no Windows com restrição de scripts

### 1. Crie o ambiente virtual

No terminal PowerShell, dentro da pasta do projeto:

```powershell
python -m venv .venv
```

### 2. Tente ativar o ambiente virtual

```powershell
.venv\Scripts\activate
```

Se aparecer erro de permissão (PSSecurityException), siga para o próximo passo.

### 3. Libere temporariamente a execução de scripts

Como você não tem acesso de administrador, altere a política apenas para o usuário atual:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

Confirme com "S" se solicitado.

### 4. Ative o ambiente virtual normalmente

```powershell
.venv\Scripts\activate
```

Você verá o nome do ambiente no prompt, exemplo:
`(backend) PS C:\Users\cesargabriel\github\estatistica\backend>`

### 5. Trabalhe normalmente no seu projeto

Instale pacotes, rode scripts, etc.

### 6. Desative o ambiente virtual ao terminar

```powershell
deactivate
```

### 7. Restaure a restrição de scripts

Por segurança, volte a restringir a execução de scripts:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
```

---

### Observações

- Se não puder alterar a política de execução, use o script `.venv\Scripts\activate.bat` no CMD (Prompt de Comando), ou ajuste as variáveis de ambiente manualmente no PowerShell:
    ```powershell
    $env:VIRTUAL_ENV="$PWD\.venv"
    $env:PATH="$env:VIRTUAL_ENV\Scripts;$env:PATH"
    ```
- Para mais detalhes, consulte: [about_Execution_Policies](https://go.microsoft.com/fwlink/?LinkID=135170)

---
