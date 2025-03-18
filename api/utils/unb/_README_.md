## Documentação das Funções - Pasta utils/ofertas/

### Arquivo: functions.py

#### Funções:

##### `get_department_names()`
- **Descrição**: Obtém os nomes e IDs dos departamentos.
- **Retorno**: Um dicionário onde as chaves são os IDs dos departamentos e os valores são os nomes dos departamentos.

### Arquivo: sessions.py

#### Funções:

##### `get_current_year_and_period()`
- **Descrição**: Obtém o ano e o período atual.
- **Retorno**: Uma tupla contendo o ano atual e o período.

### Arquivo: web_scraping.py

#### Classes e Funções:

##### `DisciplineWebScraper`
- **Descrição**: Classe responsável por realizar o web scraping das disciplinas de um departamento específico.
- **Métodos**:
  - `__init__(self, department_id, year, period)`: Inicializa a instância com o ID do departamento, ano e período.
  - `get_disciplines(self)`: Obtém as disciplinas do departamento especificado.

##### `get_department_names()`
- **Descrição**: Obtém os nomes e IDs dos departamentos.
- **Retorno**: Um dicionário onde as chaves são os IDs dos departamentos e os valores são os nomes dos departamentos.