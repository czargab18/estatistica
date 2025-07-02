#!/bin/bash
# Script simples para atualizar submódulos (compatível com bash/git bash)

echo "🔄 Atualizando submódulos..."

# Atualizar todos os submódulos
git submodule update --remote --merge

# Verificar se há mudanças para commit
if ! git diff --cached --quiet --exit-code || ! git diff --quiet --exit-code; then
    echo "📦 Adicionando mudanças dos submódulos..."
    git add .gitmodules api backend wss
    
    # Commit com timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "🔄 Atualizar submódulos - $timestamp"
    
    echo "✅ Submódulos atualizados e commit realizado!"
    
    # Push automático (remova esta linha se não quiser push automático)
    git push
    echo "🚀 Push realizado!"
else
    echo "ℹ️  Nenhuma atualização necessária"
fi

echo "🎉 Concluído!"
