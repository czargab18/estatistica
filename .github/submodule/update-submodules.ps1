# Script para atualizar todos os submódulos e fazer commit das mudanças
# Autor: César Gabriel
# Data: Julho 2025

Write-Host "🔄 Atualizando submódulos..." -ForegroundColor Yellow

# Atualizar todos os submódulos para a versão mais recente
git submodule update --remote --merge

# Verificar se houve mudanças
$changes = git diff --cached --quiet --exit-code
if ($LASTEXITCODE -ne 0) {
    Write-Host "📦 Mudanças detectadas nos submódulos" -ForegroundColor Green
    
    # Adicionar as mudanças dos submódulos
    git add .gitmodules
    git add api backend wss
    
    # Fazer commit das mudanças
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "🔄 Atualizar submódulos - $timestamp"
    
    Write-Host "✅ Submódulos atualizados e commit realizado!" -ForegroundColor Green
    
    # Perguntar se quer fazer push
    $push = Read-Host "Deseja fazer push das mudanças? (s/n)"
    if ($push -eq "s" -or $push -eq "S") {
        git push
        Write-Host "🚀 Push realizado com sucesso!" -ForegroundColor Green
    }
} else {
    Write-Host "ℹ️  Nenhuma atualização necessária nos submódulos" -ForegroundColor Blue
}

Write-Host "🎉 Processo concluído!" -ForegroundColor Magenta
