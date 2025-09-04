#!/usr/bin/env python3
"""
Script simples para testar breadcrumbs em um arquivo específico
"""

import re
from pathlib import Path

def test_breadcrumbs():
    """Testa a adição de breadcrumbs no arquivo boasvindas/index.html"""
    
    file_path = Path("boasvindas/index.html")
    
    if not file_path.exists():
        print(f"❌ Arquivo não encontrado: {file_path}")
        return
    
    # Ler arquivo
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Verificar se já tem breadcrumbs
    if 'ac-gf-breadcrumbs' in content:
        print(f"⚠️  Arquivo já possui breadcrumbs")
        return
    
    # HTML dos breadcrumbs para boasvindas
    breadcrumbs_html = '''
      <nav class="ac-gf-breadcrumbs" aria-label="Breadcrumbs" role="navigation">
        <a href="/" class="ac-gf-breadcrumbs-home" target="_self">
          <span class="ac-gf-breadcrumbs-home-icon" aria-hidden="true"></span>
          <span class="ac-gf-breadcrumbs-home-label">Estatística UnB</span>
        </a>
        <div class="ac-gf-breadcrumbs-path">
          <ol class="ac-gf-breadcrumbs-list" vocab="http://schema.org/" typeof="BreadcrumbList">
            <li class="ac-gf-breadcrumbs-item" property="itemListElement" typeof="ListItem">
              <span property="name">Boas-vindas</span>
              <meta property="position" content="1">
            </li>
          </ol>
        </div>
      </nav>'''
    
    # Encontrar onde inserir (antes do nav.ac-gf-directory)
    pattern = r'(\s*)<nav class="ac-gf-directory[^"]*"[^>]*id="globalfooter-navgation"[^>]*>'
    match = re.search(pattern, content)
    
    if not match:
        print(f"❌ Não encontrou nav.ac-gf-directory")
        return
    
    # Inserir breadcrumbs
    new_content = content[:match.start()] + breadcrumbs_html + '\n' + content[match.start():]
    
    # Salvar arquivo
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"✅ Breadcrumbs adicionados com sucesso em {file_path}")

if __name__ == '__main__':
    test_breadcrumbs()
