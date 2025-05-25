import json
import requests
from bs4 import BeautifulSoup
from collections import defaultdict
from urllib.parse import urljoin
from core.sessions import URL, HEADERS, create_request_session, get_session_cookie

class CalendarioWebScraper:
    def __init__(self, url=URL["calendario"], session=None, cookie=None):
        self.periodos = defaultdict(list)
        self.matricula = []
        self.atividades = []
        self.verao = []
        self.url = url
        self.base_url = "https://saa.unb.br/"
        self.session = session or create_request_session()
        self.cookie = cookie or get_session_cookie(self.session, url)
        self.response = None

    def get_response_from_calendario_request(self):
        self.response = self.session.get(
            self.url, headers=HEADERS, cookies=self.cookie)
        print("Status Code:", self.response.status_code)
        if self.response.status_code == 200:
            print("Response Content:", self.response.content[:100])

    def make_periodos(self, rows, year):
        if rows is None or not len(rows):
            return None
        for row in rows:
            cols = row.find_all("td")
            if len(cols) == 3:
                periodo = cols[0].get_text().strip()
                inicio = cols[1].get_text().strip()
                fim = cols[2].get_text().strip()
                self.periodos[year].append({
                    "período": periodo,
                    "início": inicio,
                    "fim": fim
                })

    def retrieve_periodos_tables(self, response):
        soup = BeautifulSoup(response.content, "html.parser")
        tables = soup.find_all(
            "table", attrs={"style": "height: 114px; width: 580px;"})
        return tables

    def make_web_scraping_of_periodos(self, response):
        tables = self.retrieve_periodos_tables(response)
        if not tables:
            print("Nenhuma tabela encontrada.")
            return None
        for table in tables:
            year = table.find_previous('h2').get_text().strip().split()[-1]
            table_rows = table.find_all("tr")[1:]
            print(
                f"Linhas da Tabela Encontradas para {year}:", len(table_rows))
            self.make_periodos(table_rows, year)

    def get_periodos(self):
        if not self.response:
            self.get_response_from_calendario_request()
        self.make_web_scraping_of_periodos(self.response)
        return self.periodos

    def save_to_json(self, filename="calendario.json"):
        """Salva as informações do calendário em um arquivo JSON."""
        data = {
            "periodo": self.periodos,
            "matricula": self.matricula,
            "atividades": self.atividades,
            "verao": self.verao
        }
        with open(filename, 'w', encoding='utf-8') as file:
            json.dump(data, file, ensure_ascii=False, indent=4)
        print(f"Dados salvos em {filename}")

    def extract_links(self, response):
        soup = BeautifulSoup(response.content, "html.parser")
        links = soup.find_all('a', href=True)
        for link in links:
            href = link['href']
            if not href.endswith('.pdf'):
                continue
            full_url = urljoin(self.base_url, href)
            text = link.get_text().strip().lower()
            if "matrícula" in text or "matricula" in text:
                self.matricula.append(full_url)
            elif "atividades" in text:
                self.atividades.append(full_url)
            elif "verão" in text or "verao" in text:
                self.verao.append(full_url)

    def verify_links(self):
        for link in self.matricula:
            assert link.startswith(self.base_url), f"Link inválido: {link}"
        for link in self.atividades:
            assert link.startswith(self.base_url), f"Link inválido: {link}"
        for link in self.verao:
            assert link.startswith(self.base_url), f"Link inválido: {link}"

    def get_all_data(self):
        self.get_response_from_calendario_request()
        self.get_periodos()
        self.extract_links(self.response)
        self.verify_links()
        self.save_to_json()
