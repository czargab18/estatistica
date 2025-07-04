# Script PowerShell para converter MD para HTML usando Pandoc
# Uso: .\convert-md.ps1

$pandocPath = "$env:LOCALAPPDATA\Pandoc\pandoc.exe"
$inputFile = "artigo.md"
$outputFile = "artigo-convertido.html"

Write-Host "🔧 Convertendo $inputFile para HTML..." -ForegroundColor Green

# Verificar se o arquivo de entrada existe
if (-not (Test-Path $inputFile)) {
    Write-Host "❌ Arquivo $inputFile não encontrado!" -ForegroundColor Red
    exit 1
}

# Comando Pandoc com opções personalizadas
$pandocArgs = @(
    $inputFile,
    "-o", $outputFile,
    "--from=markdown",
    "--to=html5",
    "--standalone",
    "--metadata-file=metadata.yaml",
    "--template=template.html",
    "--toc",
    "--toc-depth=3",
    "--section-divs",
    "--html-q-tags",
    "--wrap=none"
)

try {
    # Executar Pandoc
    & $pandocPath @pandocArgs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Conversão concluída! Arquivo gerado: $outputFile" -ForegroundColor Green
        
        # Verificar tamanho do arquivo gerado
        $fileSize = (Get-Item $outputFile).Length
        Write-Host "📄 Tamanho do arquivo: $([math]::Round($fileSize/1KB, 2)) KB" -ForegroundColor Cyan
        
        # Abrir o arquivo no navegador padrão
        Write-Host "🌐 Abrindo no navegador..." -ForegroundColor Yellow
        Start-Process $outputFile
    } else {
        Write-Host "❌ Erro na conversão!" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erro ao executar Pandoc: $($_.Exception.Message)" -ForegroundColor Red
}
