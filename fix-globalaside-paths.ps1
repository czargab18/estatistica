# Script para corrigir caminhos CSS do globalaside
param(
    [string]$RootPath = "c:\Users\cesar.oliveira\github\estatistica"
)

Write-Host "Iniciando correcao dos caminhos CSS do globalaside..." -ForegroundColor Green

# Encontrar todos os arquivos HTML
$htmlFiles = Get-ChildItem -Path $RootPath -Filter "*.html" -Recurse

Write-Host "Encontrados $($htmlFiles.Count) arquivos HTML para processar..." -ForegroundColor Cyan

$updatedFiles = 0
$corrections = @{
    # CSS Corrections para globalaside
    '/ac/globalaside/1/pt_BR/styles/globalaside.css' = '/ac/globalheader/aside/1/pt_BR/styles/globalaside.css'
    'https://www.estatistica.pro/ac/globalaside/1/pt_BR/styles/globalaside.css' = '/ac/globalheader/aside/1/pt_BR/styles/globalaside.css'
}

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $fileChanged = $false
        
        foreach ($oldPath in $corrections.Keys) {
            $newPath = $corrections[$oldPath]
            if ($content.Contains($oldPath)) {
                $content = $content.Replace($oldPath, $newPath)
                $fileChanged = $true
                Write-Host "  Corrigido: $oldPath -> $newPath" -ForegroundColor Yellow
            }
        }
        
        if ($fileChanged) {
            $content | Set-Content $file.FullName -Encoding UTF8 -NoNewline
            $updatedFiles++
            Write-Host "Atualizado: $($file.FullName.Replace($RootPath, ''))" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "Erro em $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== RESUMO ===" -ForegroundColor Cyan
Write-Host "Arquivos processados: $($htmlFiles.Count)" -ForegroundColor White
Write-Host "Arquivos atualizados: $updatedFiles" -ForegroundColor Green
Write-Host "Correcao de caminhos globalaside concluida!" -ForegroundColor Green
