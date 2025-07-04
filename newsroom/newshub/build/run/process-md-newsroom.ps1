# Script PowerShell para conversão avançada de Markdown para HTML com processamento de includes
# Versão: 2.0 - Apple Newsroom Style Template

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "",
    
    [Parameter(Mandatory=$false)]
    [string]$TemplateFile = "template.html",
    
    [Parameter(Mandatory=$false)]
    [string]$ComponentsDir = "components",
    
    [Parameter(Mandatory=$false)]
    [switch]$VerboseOutput
)

# Função para log com timestamp
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] ${Level}: $Message" -ForegroundColor $color
}

# Verificar se o arquivo de entrada existe
if (-not (Test-Path $InputFile)) {
    Write-Log "Arquivo de entrada não encontrado: $InputFile" "ERROR"
    exit 1
}

# Determinar arquivo de saída se não especificado
if ($OutputFile -eq "") {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
    $directory = [System.IO.Path]::GetDirectoryName($InputFile)
    if ($directory -eq "") {
        $directory = "."
    }
    $OutputFile = Join-Path $directory "$baseName.html"
}

# Verificar se o template existe
if (-not (Test-Path $TemplateFile)) {
    Write-Log "Template não encontrado: $TemplateFile" "ERROR"
    exit 1
}

Write-Log "Iniciando conversão de $InputFile para $OutputFile"

try {
    # Ler o arquivo markdown
    $markdownContent = Get-Content $InputFile -Raw -Encoding UTF8
    
    # Extrair frontmatter YAML
    $frontmatterPattern = '^---\s*\n(.*?)\n---\s*\n(.*)'
    $match = [regex]::Match($markdownContent, $frontmatterPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    
    if ($match.Success) {
        $frontmatter = $match.Groups[1].Value
        $content = $match.Groups[2].Value
        Write-Log "Frontmatter YAML extraído com sucesso"
        
        if ($VerboseOutput) {
            Write-Log "Frontmatter encontrado:`n$frontmatter" "INFO"
        }
    } else {
        Write-Log "Nenhum frontmatter YAML encontrado" "WARN"
        $frontmatter = ""
        $content = $markdownContent
    }
    
    # Criar arquivo temporário para processamento
    $tempMdFile = [System.IO.Path]::GetTempFileName() + ".md"
    $tempHtmlFile = [System.IO.Path]::GetTempFileName() + ".html"
    
    # Recriar o arquivo markdown com frontmatter
    $reconstructedMd = if ($frontmatter -ne "") { "---`n$frontmatter`n---`n$content" } else { $content }
    Set-Content $tempMdFile $reconstructedMd -Encoding UTF8
    
    # Executar Pandoc
    $pandocArgs = @(
        $tempMdFile,
        "-o", $tempHtmlFile,
        "--template=$TemplateFile",
        "--standalone",
        "--from=markdown+yaml_metadata_block",
        "--to=html5",
        "--section-divs",
        "--wrap=none"
    )
    
    Write-Log "Executando Pandoc com template: $TemplateFile"
    
    if ($VerboseOutput) {
        Write-Log "Comando Pandoc: C:\Users\cesar.oliveira\AppData\Local\Microsoft\WinGet\Packages\JohnMacFarlane.Pandoc_Microsoft.Winget.Source_8wekyb3d8bbwe\pandoc.exe $($pandocArgs -join ' ')"
    }
    
    $process = Start-Process -FilePath "C:\Users\cesar.oliveira\AppData\Local\Microsoft\WinGet\Packages\JohnMacFarlane.Pandoc_Microsoft.Winget.Source_8wekyb3d8bbwe\pandoc.exe" -ArgumentList $pandocArgs -Wait -PassThru -NoNewWindow -RedirectStandardError $tempMdFile + ".err"
    
    if ($process.ExitCode -ne 0) {
        $errorOutput = Get-Content ($tempMdFile + ".err") -Raw
        Write-Log "Erro no Pandoc: $errorOutput" "ERROR"
        throw "Pandoc falhou com código $($process.ExitCode)"
    }
    
    # Ler o HTML gerado pelo Pandoc
    $htmlContent = Get-Content $tempHtmlFile -Raw -Encoding UTF8
    Write-Log "HTML básico gerado pelo Pandoc"
    
    # Processar includes do frontmatter se presentes
    if ($frontmatter -ne "") {
        Write-Log "Processando includes do frontmatter..."
        
        # Converter YAML para objeto PowerShell (simplificado)
        # Procurar por seção includes:
        $includesPattern = 'includes:\s*\n((?:\s+\w+:.*\n)*)'
        $includesMatch = [regex]::Match($frontmatter, $includesPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
        
        if ($includesMatch.Success) {
            $includesSection = $includesMatch.Groups[1].Value
            Write-Log "Seção includes encontrada no frontmatter"
            
            if ($VerboseOutput) {
                Write-Log "Includes section:`n$includesSection"
            }
            
            # Processar cada include
            $includePattern = '\s+(\w+):\s*\n\s+file:\s*"([^"]+)"\s*\n\s+position:\s*"([^"]+)"\s*\n(?:\s+priority:\s*(\d+)\s*\n)?'
            $includeMatches = [regex]::Matches($includesSection, $includePattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
            
            foreach ($includeMatch in $includeMatches) {
                $includeName = $includeMatch.Groups[1].Value
                $includeFile = $includeMatch.Groups[2].Value
                $includePosition = $includeMatch.Groups[3].Value
                $includePriority = if ($includeMatch.Groups[4].Success) { [int]$includeMatch.Groups[4].Value } else { 10 }
                
                $fullIncludePath = Join-Path (Join-Path (Split-Path $InputFile -Parent) $ComponentsDir) $includeFile
                
                if (Test-Path $fullIncludePath) {
                    $includeContent = Get-Content $fullIncludePath -Raw -Encoding UTF8
                    Write-Log "Processando include '$includeName' de $includeFile na posição '$includePosition'"
                    
                    # Inserir o conteúdo na posição apropriada
                    switch ($includePosition.ToLower()) {
                        "after_body_open" {
                            $htmlContent = $htmlContent -replace '(<body[^>]*>)', "`$1`n$includeContent"
                        }
                        "before_body_close" {
                            $htmlContent = $htmlContent -replace '(</body>)', "$includeContent`n`$1"
                        }
                        "after_globalheader" {
                            $htmlContent = $htmlContent -replace '(<div id="globalheader"[^>]*>)(.*?)(</div>)', "`$1`$2`$3`n$includeContent"
                        }
                        "before_content" {
                            $htmlContent = $htmlContent -replace '(<main[^>]*>)', "`$1`n$includeContent"
                        }
                        default {
                            Write-Log "Posição de include desconhecida: $includePosition" "WARN"
                        }
                    }
                } else {
                    Write-Log "Arquivo de component não encontrado: $fullIncludePath" "WARN"
                }
            }
        } else {
            Write-Log "Nenhuma seção 'includes' encontrada no frontmatter" "INFO"
        }
    }
    
    # Processar placeholders especiais para componentes
    # Substituir placeholders vazios dos componentes por conteúdo real se existirem
    $globalHeaderFile = Join-Path (Join-Path (Split-Path $InputFile -Parent) $ComponentsDir) "globalheader.html"
    if (Test-Path $globalHeaderFile) {
        $globalHeaderContent = Get-Content $globalHeaderFile -Raw -Encoding UTF8
        $htmlContent = $htmlContent -replace '(<div id="globalheader">)(.*?)(</div>)', "`$1$globalHeaderContent`$3"
        Write-Log "Global header inserido automaticamente"
    }
    
    $globalFooterFile = Join-Path (Join-Path (Split-Path $InputFile -Parent) $ComponentsDir) "globalfooter.html"
    if (Test-Path $globalFooterFile) {
        $globalFooterContent = Get-Content $globalFooterFile -Raw -Encoding UTF8
        $htmlContent = $htmlContent -replace '(<footer id="globalfooter"[^>]*>)(.*?)(</footer>)', "`$1$globalFooterContent`$3"
        Write-Log "Global footer inserido automaticamente"
    }
    
    # Salvar o arquivo final
    Set-Content $OutputFile $htmlContent -Encoding UTF8
    Write-Log "Arquivo HTML gerado com sucesso: $OutputFile" "SUCCESS"
    
    # Limpeza de arquivos temporários
    Remove-Item $tempMdFile -ErrorAction SilentlyContinue
    Remove-Item $tempHtmlFile -ErrorAction SilentlyContinue
    Remove-Item ($tempMdFile + ".err") -ErrorAction SilentlyContinue
    
    # Estatísticas finais
    $inputSize = (Get-Item $InputFile).Length
    $outputSize = (Get-Item $OutputFile).Length
    Write-Log "Conversão concluída - Input: $inputSize bytes, Output: $outputSize bytes" "SUCCESS"
    
} catch {
    Write-Log "Erro durante a conversão: $($_.Exception.Message)" "ERROR"
    exit 1
}
