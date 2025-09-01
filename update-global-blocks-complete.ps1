# =========================================================================
# Script Completo para Atualização Global de Blocos HTML
# =========================================================================
# Este script:
# 1. Atualiza os blocos globalheader e globalfooter em todos os arquivos HTML
# 2. Corrige todos os links CSS/JS dos componentes globais
# 3. Reorganiza as estruturas de paths conforme a nova organização
#
# Autor: GitHub Copilot
# Data: 1 de setembro de 2025
# =========================================================================

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  SCRIPT DE ATUALIZAÇÃO GLOBAL COMPLETA" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Configuração de encoding
$OutputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

# Contadores
$totalFilesProcessed = 0
$totalFilesUpdated = 0
$headerUpdates = 0
$footerUpdates = 0
$pathCorrections = 0

# =========================================================================
# SEÇÃO 1: EXTRAÇÃO DOS BLOCOS DO ARQUIVO PRINCIPAL
# =========================================================================

Write-Host "1. EXTRAINDO BLOCOS DO ARQUIVO PRINCIPAL..." -ForegroundColor Yellow

$mainFile = "index.html"
if (-not (Test-Path $mainFile)) {
    Write-Host "   ERRO: Arquivo principal $mainFile não encontrado!" -ForegroundColor Red
    exit 1
}

$mainContent = Get-Content -Path $mainFile -Encoding UTF8 -Raw

# Extração do GlobalHeader
$headerStart = $mainContent.IndexOf('<div id="globalheader">')
$headerEnd = $mainContent.IndexOf('</div>', $mainContent.IndexOf('</nav>', $headerStart)) + 6
$newGlobalHeader = $mainContent.Substring($headerStart, $headerEnd - $headerStart)

# Extração do GlobalFooter  
$footerStart = $mainContent.IndexOf('<footer class="footer" id="globalfooter">')
$footerEnd = $mainContent.IndexOf('</footer>', $footerStart) + 9
$newGlobalFooter = $mainContent.Substring($footerStart, $footerEnd - $footerStart)

Write-Host "   ✓ GlobalHeader extraído ($($newGlobalHeader.Length) caracteres)" -ForegroundColor Green
Write-Host "   ✓ GlobalFooter extraído ($($newGlobalFooter.Length) caracteres)" -ForegroundColor Green

# =========================================================================
# SEÇÃO 2: MAPEAMENTO DE CORREÇÕES DE PATHS
# =========================================================================

Write-Host ""
Write-Host "2. CONFIGURANDO CORREÇÕES DE PATHS..." -ForegroundColor Yellow

# Mapeamento completo de correções de paths CSS/JS
$pathCorrections = @{
    # Correções GlobalNavbar
    '/ac/globalnavbar/1/pt_BR/styles/globalnavbar.css' = '/ac/globalheader/navbar/1/pt_BR/styles/globalnavbar.css'
    'https://www.estatistica.pro/ac/globalnavbar/1/pt_BR/styles/globalnavbar.css' = '/ac/globalheader/navbar/1/pt_BR/styles/globalnavbar.css'
    '/ac/globalnavbar/1/pt_BR/scripts/globalnavbar.build.js' = '/ac/globalheader/navbar/1/pt_BR/scripts/globalnavbar.build.js'
    'https://www.estatistica.pro/ac/globalnavbar/1/pt_BR/scripts/globalnavbar.build.js' = '/ac/globalheader/navbar/1/pt_BR/scripts/globalnavbar.build.js'
    
    # Correções GlobalRibbon
    '/ac/globalribbon/1/pt_BR/styles/globalribbon.css' = '/ac/globalheader/ribbon/1/pt_BR/styles/globalribbon.css'
    'https://www.estatistica.pro/ac/globalribbon/1/pt_BR/styles/globalribbon.css' = '/ac/globalheader/ribbon/1/pt_BR/styles/globalribbon.css'
    '/ac/globalribbon/1/pt_BR/scripts/globalribbon.js' = '/ac/globalheader/ribbon/1/pt_BR/scripts/globalribbon.js'
    'https://www.estatistica.pro/ac/globalribbon/1/pt_BR/scripts/globalribbon.js' = '/ac/globalheader/ribbon/1/pt_BR/scripts/globalribbon.js'
    
    # Correções GlobalAside
    '/ac/globalaside/1/pt_BR/styles/globalaside.css' = '/ac/globalheader/aside/1/pt_BR/styles/globalaside.css'
    'https://www.estatistica.pro/ac/globalaside/1/pt_BR/styles/globalaside.css' = '/ac/globalheader/aside/1/pt_BR/styles/globalaside.css'
    
    # Outras correções comuns
    'src="/utils/libs/js/navbar.js"' = 'defer="" src="/ac/globalheader/navbar/1/pt_BR/scripts/globalnavbar.build.js"'
}

Write-Host "   ✓ Configuradas $($pathCorrections.Count) correções de paths" -ForegroundColor Green

# =========================================================================
# SEÇÃO 3: BUSCA E PROCESSAMENTO DE ARQUIVOS HTML
# =========================================================================

Write-Host ""
Write-Host "3. LOCALIZANDO ARQUIVOS HTML..." -ForegroundColor Yellow

$htmlFiles = Get-ChildItem -Path "." -Recurse -Include "*.html" | Where-Object { 
    $_.FullName -notlike "*\.git\*" -and 
    $_.FullName -notlike "*\node_modules\*" -and
    $_.FullName -notlike "*\build\*" -and
    $_.FullName -notlike "*\_site\*"
}

Write-Host "   ✓ Encontrados $($htmlFiles.Count) arquivos HTML para processar" -ForegroundColor Green

# =========================================================================
# SEÇÃO 4: PROCESSAMENTO DOS ARQUIVOS
# =========================================================================

Write-Host ""
Write-Host "4. PROCESSANDO ARQUIVOS..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $htmlFiles) {
    $totalFilesProcessed++
    $fileUpdated = $false
    $currentFileUpdates = 0
    
    try {
        $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
        $originalContent = $content
        
        Write-Host "   Processando: $($file.Name)" -ForegroundColor White
        
        # =====================================================================
        # ATUALIZAÇÃO DO GLOBALHEADER
        # =====================================================================
        if ($content -match '<div id="globalheader">.*?</div>(?=\s*<nav|</nav>)') {
            $oldHeaderPattern = '<div id="globalheader">[\s\S]*?</div>(?=\s*<nav)'
            if ($content -match $oldHeaderPattern) {
                $content = $content -replace $oldHeaderPattern, $newGlobalHeader
                $headerUpdates++
                $currentFileUpdates++
                Write-Host "     ✓ GlobalHeader atualizado" -ForegroundColor Green
            }
        }
        
        # =====================================================================
        # ATUALIZAÇÃO DO GLOBALFOOTER
        # =====================================================================
        if ($content -match '<footer class="footer" id="globalfooter">') {
            $oldFooterPattern = '<footer class="footer" id="globalfooter">[\s\S]*?</footer>'
            if ($content -match $oldFooterPattern) {
                $content = $content -replace $oldFooterPattern, $newGlobalFooter
                $footerUpdates++
                $currentFileUpdates++
                Write-Host "     ✓ GlobalFooter atualizado" -ForegroundColor Green
            }
        }
        
        # =====================================================================
        # CORREÇÃO DE PATHS CSS/JS
        # =====================================================================
        $pathChanges = 0
        foreach ($oldPath in $pathCorrections.Keys) {
            $newPath = $pathCorrections[$oldPath]
            if ($content.Contains($oldPath)) {
                $content = $content.Replace($oldPath, $newPath)
                $pathChanges++
            }
        }
        
        if ($pathChanges -gt 0) {
            $pathCorrections += $pathChanges
            $currentFileUpdates += $pathChanges
            Write-Host "     ✓ $pathChanges correções de paths aplicadas" -ForegroundColor Green
        }
        
        # =====================================================================
        # SALVAMENTO SE HOUVE ALTERAÇÕES
        # =====================================================================
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            $totalFilesUpdated++
            $fileUpdated = $true
            Write-Host "     → Arquivo salvo com $currentFileUpdates alterações" -ForegroundColor Cyan
        } else {
            Write-Host "     - Nenhuma alteração necessária" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "     ✗ ERRO: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

# =========================================================================
# SEÇÃO 5: RELATÓRIO FINAL
# =========================================================================

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "           RELATÓRIO FINAL" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📊 ESTATÍSTICAS DE PROCESSAMENTO:" -ForegroundColor White
Write-Host "   • Arquivos processados: $totalFilesProcessed" -ForegroundColor White
Write-Host "   • Arquivos atualizados: $totalFilesUpdated" -ForegroundColor Green
Write-Host "   • Blocos GlobalHeader atualizados: $headerUpdates" -ForegroundColor Green  
Write-Host "   • Blocos GlobalFooter atualizados: $footerUpdates" -ForegroundColor Green
Write-Host "   • Correções de paths aplicadas: $pathCorrections" -ForegroundColor Green
Write-Host ""

# Taxa de sucesso
$successRate = if ($totalFilesProcessed -gt 0) { [math]::Round(($totalFilesUpdated / $totalFilesProcessed) * 100, 2) } else { 0 }
Write-Host "📈 TAXA DE ATUALIZAÇÃO: $successRate%" -ForegroundColor $(if($successRate -gt 50) { 'Green' } else { 'Yellow' })
Write-Host ""

# Resumo por tipo de alteração
Write-Host "🔧 TIPOS DE ALTERAÇÕES:" -ForegroundColor White
if ($headerUpdates -gt 0) { Write-Host "   ✓ Atualização de GlobalHeaders" -ForegroundColor Green }
if ($footerUpdates -gt 0) { Write-Host "   ✓ Atualização de GlobalFooters" -ForegroundColor Green }
if ($pathCorrections -gt 0) { Write-Host "   ✓ Correção de Paths CSS/JS" -ForegroundColor Green }
Write-Host ""

# Verificação final
Write-Host "🔍 VERIFICAÇÃO FINAL:" -ForegroundColor White
$remainingIssues = @()

# Verifica paths antigos restantes
$oldPaths = @('/ac/globalnavbar/', '/ac/globalribbon/', '/ac/globalaside/')
foreach ($oldPath in $oldPaths) {
    $remaining = (Get-ChildItem -Path "." -Recurse -Include "*.html" | Select-String -Pattern $oldPath -SimpleMatch).Count
    if ($remaining -gt 0) {
        $remainingIssues += "$remaining arquivos ainda contêm '$oldPath'"
    }
}

if ($remainingIssues.Count -eq 0) {
    Write-Host "   ✅ Todas as correções foram aplicadas com sucesso!" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Issues pendentes:" -ForegroundColor Yellow
    foreach ($issue in $remainingIssues) {
        Write-Host "      - $issue" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "         PROCESSAMENTO CONCLUÍDO" -ForegroundColor Cyan  
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Log de timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "⏰ Concluído em: $timestamp" -ForegroundColor Gray
