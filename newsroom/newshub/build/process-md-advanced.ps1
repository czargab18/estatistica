# Script PowerShell avançado para processar includes e componentes
# Uso: .\process-md-advanced.ps1

$pandocPath = "$env:LOCALAPPDATA\Pandoc\pandoc.exe"
$inputFile = "artigo.md"
$outputFile = "artigo-processado.html"

Write-Host "🚀 Processando $inputFile com includes e componentes..." -ForegroundColor Green

# Função para ler e processar o frontmatter YAML
function Get-FrontMatter {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    if ($content -match '(?s)^---\s*\n(.*?)\n---\s*\n(.*)$') {
        $yamlContent = $matches[1]
        $markdownContent = $matches[2]
        
        # Simular parsing básico do YAML (versão simplificada)
        $metadata = @{}
        $yamlContent -split '\n' | ForEach-Object {
            if ($_ -match '^(\w+):\s*"([^"]*)"$') {
                $metadata[$matches[1]] = $matches[2]
            } elseif ($_ -match '^(\w+):\s*(.+)$') {
                $metadata[$matches[1]] = $matches[2].Trim()
            }
        }
        
        return @{
            Metadata = $metadata
            Content = $markdownContent
        }
    }
    return $null
}

# Função para processar variáveis em templates
function Process-Template {
    param([string]$TemplateContent, [hashtable]$Variables)
    
    $result = $TemplateContent
    foreach ($key in $Variables.Keys) {
        $pattern = "\{\{$key\}\}"
        $result = $result -replace $pattern, $Variables[$key]
    }
    return $result
}

# Ler o arquivo markdown
if (-not (Test-Path $inputFile)) {
    Write-Host "❌ Arquivo $inputFile não encontrado!" -ForegroundColor Red
    exit 1
}

$parsed = Get-FrontMatter $inputFile
if (-not $parsed) {
    Write-Host "❌ Não foi possível processar o frontmatter!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Frontmatter processado com sucesso!" -ForegroundColor Green
Write-Host "📋 Metadados encontrados:" -ForegroundColor Cyan
$parsed.Metadata.Keys | ForEach-Object {
    Write-Host "   $($_): $($parsed.Metadata[$_])" -ForegroundColor Gray
}

# Simular processamento de includes (versão básica)
$includesInfo = @"
<div class="includes-simulation" style="background: #e8f5e8; padding: 20px; margin: 20px 0; border-radius: 8px; border-left: 4px solid #4caf50;">
  <h3 style="color: #2e7d32; margin-top: 0;">🔧 Includes Configurados</h3>
  <div style="background: white; padding: 15px; border-radius: 4px; margin: 10px 0;">
    <strong>header_global</strong>: components/globalheader.html 
    <span style="background: #ff9800; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem;">P1</span>
    <span style="background: #4caf50; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; margin-left: 8px;">after_body_open</span>
  </div>
  <div style="background: white; padding: 15px; border-radius: 4px; margin: 10px 0;">
    <strong>local_nav</strong>: components/localnav.html 
    <span style="background: #ff9800; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem;">P2</span>
    <span style="background: #4caf50; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; margin-left: 8px;">after_globalheader</span>
  </div>
  <div style="background: white; padding: 15px; border-radius: 4px; margin: 10px 0;">
    <strong>article_header</strong>: components/article-header.html 
    <span style="background: #ff9800; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem;">P3</span>
    <span style="background: #4caf50; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; margin-left: 8px;">before_content</span>
  </div>
  <div style="background: white; padding: 15px; border-radius: 4px; margin: 10px 0;">
    <strong>footer_global</strong>: components/globalfooter.html 
    <span style="background: #ff9800; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem;">P1</span>
    <span style="background: #4caf50; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; margin-left: 8px;">before_body_close</span>
  </div>
  <p style="margin-bottom: 0; color: #666; font-size: 0.9rem;">
    💡 Em um processador real, estes componentes seriam carregados dos arquivos HTML correspondentes e inseridos nas posições especificadas.
  </p>
</div>
"@

# Criar arquivo temporário com o conteúdo processado
$tempContent = $includesInfo + "`n`n" + $parsed.Content
$tempFile = "temp-processed.md"
Set-Content $tempFile $tempContent -Encoding UTF8

try {
    # Converter com Pandoc
    $pandocArgs = @(
        $tempFile,
        "-o", $outputFile,
        "--from=markdown",
        "--to=html5",
        "--standalone",
        "--template=template.html",
        "--metadata", "title=$($parsed.Metadata['title'])",
        "--metadata", "description=$($parsed.Metadata['description'])",
        "--metadata", "date=$($parsed.Metadata['date'])",
        "--metadata", "site_name=$($parsed.Metadata['site_name'])",
        "--metadata", "type=$($parsed.Metadata['type'])",
        "--metadata", "lang=$($parsed.Metadata['lang'])"
    )
    
    & $pandocPath @pandocArgs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Conversão concluída! Arquivo gerado: $outputFile" -ForegroundColor Green
        
        # Limpar arquivo temporário
        Remove-Item $tempFile -ErrorAction SilentlyContinue
        
        # Verificar tamanho do arquivo
        $fileSize = (Get-Item $outputFile).Length
        Write-Host "📄 Tamanho: $([math]::Round($fileSize/1KB, 2)) KB" -ForegroundColor Cyan
        
        # Abrir no navegador
        Write-Host "🌐 Abrindo no navegador..." -ForegroundColor Yellow
        Start-Process $outputFile
    } else {
        Write-Host "❌ Erro na conversão!" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Limpar arquivo temporário
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}
