# Pacote `backend`

## Tutorial: Ambiente virtual Python no Windows (com ou sem `uv`)

### 1. Instale o `uv` (opcional, recomendado)

No terminal, execute:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 2. Crie o ambiente virtual

No terminal PowerShell, dentro da pasta do projeto:

- Usando `uv` (recomendado):
    ```powershell
    uv venv .venv
    ```
### 3. Ative o ambiente virtual

```powershell
.venv\Scripts\Activate
```

Se aparecer erro de permissão (PSSecurityException), siga os passos abaixo para liberar scripts temporariamente:

1. No PowerShell, execute:
    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
    ```
2. Confirme com "S" se solicitado.
3. Tente ativar novamente:
    ```powershell
    .venv\Scripts\Activate
    ```
4. Ao terminar, restaure a restrição de scripts:
    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
    ```

### 4. Instale dependências

- Usando `uv`:
    ```powershell
    uv pip install -r requirements.txt
    ```
    ou
    ```powershell
    uv pip install <pacote>
    ```

### 5. Desative o ambiente virtual ao terminar

```powershell
deactivate
```

### Observações

- Se não puder alterar a política de execução, use o script `.venv\Scripts\activate.bat` no CMD (Prompt de Comando), ou ajuste as variáveis de ambiente manualmente no PowerShell:
    ```powershell
    $env:VIRTUAL_ENV="$PWD\.venv"
    $env:PATH="$env:VIRTUAL_ENV\Scripts;$env:PATH"
    ```
- Para mais detalhes, consulte: [about_Execution_Policies](https://go.microsoft.com/fwlink/?LinkID=135170)

