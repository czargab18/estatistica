# Script PowerShell para renderização avançada de Markdown - Apple Newsroom
# Versão: 2.0 com processamento de includes e componentes dinâmicos

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false, Position=1)]
    [string]$OutputFile = "",
    
    [Parameter(Mandatory=$false)]
    [string]$TemplateFile = "",
    
    [Parameter(Mandatory=$false)]
    [string]$ComponentsDir = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$VerboseOutput,
    
    [Parameter(Mandatory=$false)]
    [switch]$OpenInBrowser
)

# Configurações
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
if ($TemplateFile -eq "") {
    $TemplateFile = Join-Path $ScriptDir "modelos\template.html"
}
if ($ComponentsDir -eq "") {
    $ComponentsDir = Join-Path $ScriptDir "components"
}
$OutputDir = Join-Path $ScriptDir "output"

# Função para log com timestamp
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

function Test-Dependencies {
    Write-Log "Verificando dependências..."
    
    # Verificar Pandoc
    try {
        $pandocVersion = & pandoc --version 2>$null | Select-Object -First 1
        Write-Log "✓ Pandoc: $pandocVersion" "SUCCESS"
    } catch {
        Write-Log "✗ Pandoc não encontrado. Execute config.ps1 primeiro." "ERROR"
        return $false
    }
    
    return $true
}

function Get-PandocPath {
    # Tentar encontrar pandoc no PATH primeiro
    try {
        $pandocPath = (Get-Command pandoc -ErrorAction SilentlyContinue).Source
        if ($pandocPath) {
            return $pandocPath
        }
    } catch {}
    
    # Tentar localização padrão do WinGet
    $wingetPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\JohnMacFarlane.Pandoc_Microsoft.Winget.Source_8wekyb3d8bbwe\pandoc.exe"
    if (Test-Path $wingetPath) {
        return $wingetPath
    }
    
    # Fallback para PATH
    return "pandoc"
}

function Extract-Frontmatter {
    param([string]$Content)
    
    $frontmatterPattern = '^---\s*\n(.*?)\n---\s*\n(.*)'
    $match = [regex]::Match($Content, $frontmatterPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    
    if ($match.Success) {
        return @{
            Frontmatter = $match.Groups[1].Value
            Content = $match.Groups[2].Value
        }
    } else {
        return @{
            Frontmatter = ""
            Content = $Content
        }
    }
}

function Process-Includes {
    param(
        [string]$HtmlContent,
        [string]$Frontmatter,
        [string]$ComponentsDir
    )
    
    if ($Frontmatter -eq "") {
        return $HtmlContent
    }
    
    # Procurar por seção includes
    $includesPattern = 'includes:\s*\n((?:\s+\w+:.*\n)*)'
    $includesMatch = [regex]::Match($Frontmatter, $includesPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
    
    if (-not $includesMatch.Success) {
        Write-Log "Nenhuma seção 'includes' encontrada"
        return $HtmlContent
    }
    
    $includesSection = $includesMatch.Groups[1].Value
    Write-Log "Processando includes..."
    
    if ($VerboseOutput) {
        Write-Log "Includes encontrados:`n$includesSection"
    }
    
    # Processar includes simples (true/false)
    $simpleIncludePattern = '\s+(\w+):\s*(true|false)'
    $simpleMatches = [regex]::Matches($includesSection, $simpleIncludePattern)
    
    foreach ($match in $simpleMatches) {
        $includeName = $match.Groups[1].Value
        $includeEnabled = $match.Groups[2].Value -eq "true"
        
        if ($includeEnabled) {
            $componentFile = Join-Path $ComponentsDir "$includeName.html"
            if (Test-Path $componentFile) {
                $componentContent = Get-Content $componentFile -Raw -Encoding UTF8
                Write-Log "Inserindo componente: $includeName"
                
                # Inserir baseado no nome do componente
                switch ($includeName) {
                    "header_global" {
                        $HtmlContent = $HtmlContent -replace '(<div id="globalheader">)(.*?)(</div>)', "`$1$componentContent`$3"
                    }
                    "footer_global" {
                        $HtmlContent = $HtmlContent -replace '(<footer id="globalfooter"[^>]*>)(.*?)(</footer>)', "`$1$componentContent`$3"
                    }
                    "local_nav" {
                        $HtmlContent = $HtmlContent -replace '(<nav class="localnav"[^>]*>)(.*?)(</nav>)', "`$1$componentContent`$3"
                    }
                    "article_header" {
                        $HtmlContent = $HtmlContent -replace '(<div class="article-header-extended">)(.*?)(</div>)', "`$1$componentContent`$3"
                    }
                    default {
                        Write-Log "Posição de include desconhecida: $includeName" "WARN"
                    }
                }
            } else {
                Write-Log "Componente não encontrado: $componentFile" "WARN"
            }
        }
    }
    
    return $HtmlContent
}

# Verificar argumentos
if (-not (Test-Path $InputFile)) {
    Write-Log "Arquivo de entrada não encontrado: $InputFile" "ERROR"
    exit 1
}

# Determinar arquivo de saída
if ($OutputFile -eq "") {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
    $inputDir = Split-Path $InputFile -Parent
    $localOutputDir = Join-Path $inputDir "output"
    
    # Verificar se o arquivo de entrada é artigo.md e definir como index.html
    if ($baseName -eq "artigo") {
        $fileName = "index"
    } else {
        $fileName = $baseName
    }
    
    # Verificar se existe pasta output local junto com o arquivo de entrada
    if (Test-Path $localOutputDir) {
        $OutputFile = Join-Path $localOutputDir "$fileName.html"
        Write-Log "Usando diretório de output local: $localOutputDir" "INFO"
    } else {
        $OutputFile = Join-Path $OutputDir "$fileName.html"
    }
}

# Verificar template
if (-not (Test-Path $TemplateFile)) {
    Write-Log "Template não encontrado: $TemplateFile" "ERROR"
    Write-Log "Certifique-se de que o template.html está na pasta modelos/" "ERROR"
    exit 1
}

# Criar diretório de saída
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Verificar dependências
if (-not (Test-Dependencies)) {
    exit 1
}

Write-Log "=====================================================" "INFO"
Write-Log "RENDERIZAÇÃO MARKDOWN - APPLE NEWSROOM (PowerShell)" "INFO"
Write-Log "=====================================================" "INFO"
Write-Log "Entrada: $InputFile" "INFO"
Write-Log "Saída: $OutputFile" "INFO"
Write-Log "Template: $TemplateFile" "INFO"
Write-Log "=====================================================" "INFO"

try {
    # Ler arquivo markdown
    $markdownContent = Get-Content $InputFile -Raw -Encoding UTF8
    Write-Log "Arquivo markdown carregado"
    
    # Extrair frontmatter
    $parsed = Extract-Frontmatter $markdownContent
    
    if ($parsed.Frontmatter -ne "") {
        Write-Log "Frontmatter YAML extraído"
        if ($VerboseOutput) {
            Write-Log "Frontmatter:`n$($parsed.Frontmatter)"
        }
    }
    
    # Criar arquivo temporário
    $tempMdFile = [System.IO.Path]::GetTempFileName() + ".md"
    $tempMdContent = if ($parsed.Frontmatter -ne "") { "---`n$($parsed.Frontmatter)`n---`n$($parsed.Content)" } else { $parsed.Content }
    Set-Content $tempMdFile $tempMdContent -Encoding UTF8
    
    # Preparar argumentos do Pandoc
    $pandocPath = Get-PandocPath
    $pandocArgs = @(
        $tempMdFile,
        "--output", $OutputFile,
        "--template", $TemplateFile,
        "--standalone",
        "--from=markdown+yaml_metadata_block",
        "--to=html5",
        "--section-divs",
        "--wrap=none"
    )
    
    Write-Log "Executando Pandoc..."
    
    if ($VerboseOutput) {
        Write-Log "Comando: $pandocPath $($pandocArgs -join ' ')"
    }
    
    # Executar Pandoc
    $process = Start-Process -FilePath $pandocPath -ArgumentList $pandocArgs -Wait -PassThru -NoNewWindow -RedirectStandardError "$tempMdFile.err"
    
    if ($process.ExitCode -ne 0) {
        $errorOutput = Get-Content "$tempMdFile.err" -Raw -ErrorAction SilentlyContinue
        Write-Log "Erro no Pandoc: $errorOutput" "ERROR"
        throw "Pandoc falhou com código $($process.ExitCode)"
    }
    
    # Ler HTML gerado
    $htmlContent = Get-Content $OutputFile -Raw -Encoding UTF8
    Write-Log "HTML básico gerado pelo Pandoc"
    
    # Processar includes se há frontmatter
    if ($parsed.Frontmatter -ne "") {
        $htmlContent = Process-Includes $htmlContent $parsed.Frontmatter $ComponentsDir
    }
    
    # Salvar HTML final
    Set-Content $OutputFile $htmlContent -Encoding UTF8
    
    # Limpeza
    Remove-Item $tempMdFile -ErrorAction SilentlyContinue
    Remove-Item "$tempMdFile.err" -ErrorAction SilentlyContinue
    
    # Estatísticas
    $inputSize = (Get-Item $InputFile).Length
    $outputSize = (Get-Item $OutputFile).Length
    
    Write-Log "=====================================================" "SUCCESS"
    Write-Log "SUCESSO: Arquivo HTML gerado!" "SUCCESS"
    Write-Log "=====================================================" "SUCCESS"
    Write-Log "Arquivo: $OutputFile" "SUCCESS"
    Write-Log "Tamanho: Input $inputSize bytes -> Output $outputSize bytes" "SUCCESS"
    
    # Abrir no navegador se solicitado
    if ($OpenInBrowser) {
        Write-Log "Abrindo no navegador..." "INFO"
        Start-Process $OutputFile
    }
    
} catch {
    Write-Log "Erro durante conversao: $($_.Exception.Message)" "ERROR"
    exit 1
}
