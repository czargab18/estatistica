# Script de Configuração para Sistema Apple Newsroom
# Instala Python, Pandoc e dependências necessárias
# Versão: 1.0

param(
    [switch]$Force,
    [switch]$SkipPython,
    [switch]$SkipPandoc,
    [switch]$Verbose
)

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        "INFO" { "Cyan" }
        default { "White" }
    }
    Write-Host "[$timestamp] ${Level}: $Message" -ForegroundColor $color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-Winget {
    Write-Log "Verificando WinGet..."
    try {
        $wingetVersion = & winget --version 2>$null
        Write-Log "WinGet encontrado: $wingetVersion" "SUCCESS"
        return $true
    } catch {
        Write-Log "WinGet não encontrado. Instalando..." "WARN"
        
        try {
            # Baixar e instalar WinGet
            $url = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
            $output = "$env:TEMP\WinGet.msixbundle"
            
            Write-Log "Baixando WinGet..."
            Invoke-WebRequest -Uri $url -OutFile $output
            
            Write-Log "Instalando WinGet..."
            Add-AppxPackage -Path $output
            
            Write-Log "WinGet instalado com sucesso!" "SUCCESS"
            return $true
        } catch {
            Write-Log "Erro ao instalar WinGet: $($_.Exception.Message)" "ERROR"
            return $false
        }
    }
}

function Install-Python {
    if ($SkipPython) {
        Write-Log "Instalação do Python ignorada (SkipPython)" "INFO"
        return $true
    }

    Write-Log "Verificando Python..."
    try {
        $pythonVersion = & python --version 2>$null
        if ($pythonVersion -and !$Force) {
            Write-Log "Python já instalado: $pythonVersion" "SUCCESS"
            return $true
        }
    } catch {
        Write-Log "Python não encontrado" "WARN"
    }

    Write-Log "Instalando Python via WinGet..."
    try {
        & winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements
        
        # Verificar instalação
        Start-Sleep -Seconds 5
        $pythonVersion = & python --version 2>$null
        if ($pythonVersion) {
            Write-Log "Python instalado: $pythonVersion" "SUCCESS"
            return $true
        } else {
            Write-Log "Erro: Python não foi instalado corretamente" "ERROR"
            return $false
        }
    } catch {
        Write-Log "Erro ao instalar Python: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-Pandoc {
    if ($SkipPandoc) {
        Write-Log "Instalação do Pandoc ignorada (SkipPandoc)" "INFO"
        return $true
    }

    Write-Log "Verificando Pandoc..."
    try {
        $pandocVersion = & pandoc --version 2>$null | Select-Object -First 1
        if ($pandocVersion -and !$Force) {
            Write-Log "Pandoc já instalado: $pandocVersion" "SUCCESS"
            return $true
        }
    } catch {
        Write-Log "Pandoc não encontrado" "WARN"
    }

    Write-Log "Instalando Pandoc via WinGet..."
    try {
        & winget install JohnMacFarlane.Pandoc --accept-package-agreements --accept-source-agreements
        
        # Verificar instalação
        Start-Sleep -Seconds 5
        $pandocVersion = & pandoc --version 2>$null | Select-Object -First 1
        if ($pandocVersion) {
            Write-Log "Pandoc instalado: $pandocVersion" "SUCCESS"
            return $true
        } else {
            Write-Log "Erro: Pandoc não foi instalado corretamente" "ERROR"
            return $false
        }
    } catch {
        Write-Log "Erro ao instalar Pandoc: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-PythonDependencies {
    Write-Log "Verificando dependências Python..."
    
    $requirementsFile = Join-Path $PSScriptRoot "requirements.txt"
    if (-not (Test-Path $requirementsFile)) {
        Write-Log "Criando arquivo requirements.txt..."
        $requirements = @"
pypandoc>=1.11
PyYAML>=6.0
pathlib2>=2.3.0; python_version < '3.4'
"@
        Set-Content -Path $requirementsFile -Value $requirements -Encoding UTF8
    }

    try {
        Write-Log "Instalando dependências Python..."
        & python -m pip install --upgrade pip
        & python -m pip install -r $requirementsFile
        
        Write-Log "Dependências Python instaladas!" "SUCCESS"
        return $true
    } catch {
        Write-Log "Erro ao instalar dependências Python: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Setup-ProjectStructure {
    Write-Log "Configurando estrutura do projeto..."
    
    $baseDir = Split-Path $PSScriptRoot -Parent
    $directories = @(
        "components",
        "output", 
        "modelos",
        "temp"
    )
    
    foreach ($dir in $directories) {
        $fullPath = Join-Path $baseDir $dir
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            Write-Log "Diretório criado: $dir"
        }
    }
    
    # Verificar se template existe
    $templatePath = Join-Path $baseDir "modelos\template.html"
    if (-not (Test-Path $templatePath)) {
        Write-Log "Template não encontrado em: $templatePath" "WARN"
        Write-Log "Copie o template.html para a pasta modelos/" "WARN"
    }
    
    Write-Log "Estrutura do projeto configurada!" "SUCCESS"
}

function Test-Installation {
    Write-Log "Testando instalação..."
    
    $allGood = $true
    
    # Testar Python
    try {
        $pythonVersion = & python --version 2>$null
        Write-Log "✓ Python: $pythonVersion" "SUCCESS"
    } catch {
        Write-Log "✗ Python: Não encontrado" "ERROR"
        $allGood = $false
    }
    
    # Testar Pandoc
    try {
        $pandocVersion = & pandoc --version 2>$null | Select-Object -First 1
        Write-Log "✓ Pandoc: $pandocVersion" "SUCCESS"
    } catch {
        Write-Log "✗ Pandoc: Não encontrado" "ERROR"
        $allGood = $false
    }
    
    # Testar pypandoc
    try {
        & python -c "import pypandoc; print('pypandoc:', pypandoc.__version__)" 2>$null
        Write-Log "✓ pypandoc: Disponível" "SUCCESS"
    } catch {
        Write-Log "✗ pypandoc: Não encontrado" "ERROR"
        $allGood = $false
    }
    
    # Testar PyYAML
    try {
        & python -c 'import yaml; print("PyYAML:", yaml.__version__)' 2>$null
        Write-Log "✓ PyYAML: Disponível" "SUCCESS"
    } catch {
        Write-Log "✗ PyYAML: Não encontrado" "ERROR"
        $allGood = $false
    }
    
    return $allGood
}

# Script principal
Write-Log "=== CONFIGURAÇÃO SISTEMA APPLE NEWSROOM ===" "INFO"
Write-Log "Iniciando configuração do ambiente..." "INFO"

if ($Verbose) {
    Write-Log "Modo verbose ativado" "INFO"
    Write-Log "Parâmetros: Force=$Force, SkipPython=$SkipPython, SkipPandoc=$SkipPandoc"
}

# Verificar se é administrador para algumas operações
if (-not (Test-Administrator)) {
    Write-Log "AVISO: Script não está executando como Administrador" "WARN"
    Write-Log "Algumas operações podem falhar" "WARN"
}

# Instalar WinGet se necessário
if (-not (Install-Winget)) {
    Write-Log "Falha ao configurar WinGet. Abortando." "ERROR"
    exit 1
}

# Instalar Python
if (-not (Install-Python)) {
    Write-Log "Falha ao instalar Python. Abortando." "ERROR"
    exit 1
}

# Instalar Pandoc
if (-not (Install-Pandoc)) {
    Write-Log "Falha ao instalar Pandoc. Abortando." "ERROR"
    exit 1
}

# Instalar dependências Python
if (-not (Install-PythonDependencies)) {
    Write-Log "Falha ao instalar dependências Python. Abortando." "ERROR"
    exit 1
}

# Configurar estrutura do projeto
Setup-ProjectStructure

# Testar tudo
Write-Log "Executando testes finais..." "INFO"
if (Test-Installation) {
    Write-Log "✅ CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!" "SUCCESS"
    Write-Log "" "INFO"
    Write-Log "Próximos passos:" "INFO"
    Write-Log "1. Use 'render.cmd' para renderização simples via CMD" "INFO"
    Write-Log "2. Use 'render.ps1' para renderização avançada via PowerShell" "INFO"
    Write-Log "3. Use 'render.py' para renderização usando Python/pypandoc" "INFO"
} else {
    Write-Log "❌ Alguns componentes falharam. Verifique os logs acima." "ERROR"
    exit 1
}
