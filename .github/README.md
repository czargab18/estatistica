# Estatística

Este projeto é muitas coisas e nada ao mesmo tempo. Algumas coisas são apenas para desenvolver habilidades, como o design do projeto é para a criatividade ou os **books** para a escrita. Outras para criar problemas e suas devidas soluções, mesmo que tenha que ter `n` soluções para cada problema. Buscarei nos tempos livres da graduação dedicar-me ao projeto.

## Qual o ponto de ignição?
Primeiro, um ponto de ignição é um ponto que antecede o caminho. O começo de tudo.
Inicialmente, encantei-me pelo design e programação web. Tentei desenvolver essas habilidades ao redesenhar e construir o site do Departamento de Estatística da Universidade de Brasília.

## Caminho

Muitas coisas foram incorporadas a este repositório. **books** é o meu desejo de construir livros sobre estatistica com base em minhas notas de aulas e exercícios resolvidos, da maneira que eu desejar. Sujeito a escrever e reescrever quantas vezes eu desejar até ficar do meu agrado.

## Bom, para quem é este projeto?
Eu o desenvolverei principalmente e exclusivamente para mim. Assim como no vídeo intitulado "O Diário de Henry Jones", veja (AKITA, 2025), buscarei o mesmo mas para a área de Estatística. A ideia de possuir algo que contenha tudo o que estudei ou estudarei me parece essencial para meu progresso na área, além de um bom ponto de partida para referências bibliográficas.

## Por que a demora??
A principal razão é falta de dedicação exclusiva ao projeto. O projeto é algo que não me trará retorno financeiro, mas sim um retorno intelectual. O que me faz dedicar-me a ele em momentos livres, como férias ou finais de semana. Além disso, o projeto é algo que não tem um fim.

A segunda razão é a constante reestruturação do projeto ou de partes dele. O que pode levar tempo, mas é necessário para o bom funcionamento. Além disso, a reestruturação é algo que pode ser feito em paralelo com o desenvolvimento.

Como não há um fim, não haverá pressa para concluir o projeto.

## 📁 Estrutura do Projeto

```
estatistica/
├── books/           # Livros digitais em Quarto
│   ├── EST0033/     # Estatística Básica
│   ├── CIC0007/     # Fundamentos de Programação
│   ├── MAT0075/     # Matemática para Estatística
│   └── TAS0000/     # Tópicos Avançados
├── pages/           # Páginas do site
│   ├── apps/        # Aplicações (IRA, etc)
│   ├── docente/     # Páginas docentes
│   ├── newsroom/    # Sistema de artigos
│   └── boasvindas/  # Página de boas-vindas
├── ac/              # Componentes globais (navbar, footer, etc)
└── sd/              # Assets e recursos (imagens, ícones, etc)
```

## Pastas em desenvolvimento

### 📚 **books**
Livros em desenvolvimento. O objetivo é criar livros sobre estatística com base em minhas notas de aulas e exercícios resolvidos, da maneira que eu desejar. Sujeito a escrever e reescrever quantas vezes eu desejar até ficar do meu agrado. 

### 🛠️ **apps** 
Aplicativos em desenvolvimento para facilitar a vida acadêmica e profissional. Recursos como calculadoras, simuladores, geradores de gráficos e tabelas.

- **ira**: Aplicativo para calcular o Índice de Rendimento Acadêmico (IRA) da Universidade de Brasília. Interface simples e intuitiva onde o usuário informa notas e créditos das disciplinas cursadas. Calcula o IRA automaticamente e permite salvar os dados em CSV para consultas futuras.
- **notas para mestrado**: Calculadora para análise de notas necessárias para ingresso em programas de pós-graduação.
- **simuladores estatísticos**: Ferramentas interativas para demonstração de conceitos estatísticos.

### 👨‍🏫 **docentes**
Seção dedicada a informações sobre docentes do Departamento de Estatística, incluindo:
- Perfis acadêmicos e profissionais
- Áreas de pesquisa e especialização
- Publicações e contribuições
- Informações de contato

### 📰 **newsroom**
Sistema para escrita e publicação de artigos acadêmicos usando Quarto. Organizado por idioma, ano e mês para facilitar a navegação e arquivo histórico.

### 🎉 **boasvindas**
Página de apresentação e boas-vindas ao projeto, explicando:
- Objetivos e missão do projeto
- Como navegar pelos recursos
- Guias para novos usuários
- Links para seções principais

### 📊 **appsShiny**
Aplicações interativas desenvolvidas em R Shiny para:
- Visualização de dados em tempo real
- Análises estatísticas interativas
- Dashboards educacionais
- Ferramentas de demonstração para aulas


### Renderizar Livros
```bash
# Navegar para um livro específico
cd books/EST0033

# Renderizar o livro
quarto render

# Visualizar localmente
quarto preview
```

## 🤝 Contribuindo

Consulte [.github/copilot/.copilot-instructions.md](.github/copilot/.copilot-instructions.md) para padrões de commit e desenvolvimento.

## 👨‍🏫 Autor

**César Gabriel**  
Departamento de Estatística - UnB

---

> 💡 **Nota**: Este é um projeto pessoal desenvolvido para fins educacionais e de aprendizado contínuo. Como não há um fim definido, não há pressa para sua conclusão - o foco está no processo de aprendizado e desenvolvimento de habilidades.