import re
import json
import requests
import hashlib
from bs4 import BeautifulSoup
from collections import defaultdict
from core.sessions import URL, HEADERS, create_request_session, get_session_cookie, get_response
from core.functions import multiple_replace


class OfertaWebScraper:
    def __init__(self, nivel, tipo, unidade, url=URL["ementa"], session=None, cookie=None):
        self.componentes = defaultdict(list)
        self.nivel = nivel
        self.tipo = tipo
        self.unidade = unidade
        self.url = url
        self.data = {
            "form": "form",
            "form:nivel": self.nivel,
            "form:checkTipo": "on",
            "form:tipo": self.tipo,
            "form:checkCodigo": "",
            "form:j_id_jsp_190531263_11": "",
            "form:checkNome": "",
            "form:j_id_jsp_190531263_13": "",
            "form:checkUnidade": "on",
            "form:unidades": self.unidade,
            "form:btnBuscarComponentes": "Buscar Componentes",
            "javax.faces.ViewState": "j_id1"
        }
        self.session = session or create_request_session()
        self.cookie = cookie or get_session_cookie(self.session, url)
        self.response = None
        self.unidades = self.extract_unidades()

    # Adicionando funções solicitadas
    def extract_unidades(self):
        """Extrai a lista de unidades acadêmicas do formulário."""
        response = self.session.get(
            self.url, headers=HEADERS, cookies=self.cookie)
        soup = BeautifulSoup(response.content, "html.parser")
        unidades = {}
        select = soup.find("select", {"id": "form:unidades"})
        if select:
            options = select.find_all("option")
            for option in options:
                value = option.get("value")
                text = option.get_text().strip()
                if value and value != "0":
                    unidades[value] = text
        return unidades

    def get_response_from_oferta_post_request(self):
        self.response = self.session.post(
            self.url, headers=HEADERS, cookies=self.cookie, data=self.data)
        print("Status Code:", self.response.status_code)
        if self.response.status_code == 200:
            print("Response Content:", self.response.content[:100])

    def make_componentes(self, rows):
        if rows is None or not len(rows):
            return None

        unidade_nome = self.unidades.get(self.unidade, "Unknown Unidade")
        for componente in rows:
            if "linhaPar" in componente.get("class", []) or "linhaImpar" in componente.get("class", []):
                tables_data = componente.find_all("td")

                codigo = tables_data[0].get_text().strip()
                nome = tables_data[1].get_text().strip()
                tipo = tables_data[2].get_text().strip()
                ch_total = tables_data[3].get_text().strip()

                self.componentes[unidade_nome].append({
                    "código": codigo,
                    "nome": nome,
                    "tipo": tipo,
                    "ch_total": ch_total
                })

    def retrieve_componentes_tables(self, response):
        soup = BeautifulSoup(response.content, "html.parser")
        tables = soup.find("table", attrs={"class": "listagem"})
        return tables

    def create_page_fingerprint(self):
        if not self.response:
            self.get_response_from_oferta_post_request()
        tables = self.retrieve_componentes_tables(self.response)
        if not tables:
            return "not_content"
        treated_tables = multiple_replace(tables.get_text(), replacement={
                                          '\n': '', '\t': '', '\r': '', ' ': ''}).strip()
        return hashlib.sha256(treated_tables.encode('utf-8')).hexdigest()

    def make_web_scraping_of_componentes(self, response):
        tables = self.retrieve_componentes_tables(response)
        if not tables:
            print("Nenhuma tabela encontrada.")
            return None

        table_rows = tables.find_all("tr")
        print("Linhas da Tabela Encontradas:", len(table_rows))
        self.make_componentes(table_rows)

    def get_componentes(self):
        if not self.response:
            self.get_response_from_oferta_post_request()
        self.make_web_scraping_of_componentes(self.response)
        return self.componentes

    def save_to_json(self, filename="componentes.json"):
        """Salva as informações dos componentes em um arquivo JSON."""
        try:
            with open(filename, 'r', encoding='utf-8') as file:
                existing_data = json.load(file)
        except FileNotFoundError:
            existing_data = {}

        for unidade, info in self.componentes.items():
            departamento = unidade if unidade in self.unidades.values() else "Unknown Departamento"
            if departamento not in existing_data:
                existing_data[departamento] = {}
            for componente in info:
                existing_data[departamento][componente["código"]] = {
                    "código": componente["código"],
                    "nome": componente["nome"],
                    "tipo": componente["tipo"],
                    "ch_total": componente["ch_total"]
                }

        with open(filename, 'w', encoding='utf-8') as file:
            json.dump(existing_data, file, ensure_ascii=False, indent=4)

        print(f"Dados salvos em {filename}")

    def save_unidades_to_json(self, unidades, filename="unidades.json"):
        """Salva a lista de unidades acadêmicas em um arquivo JSON."""
        with open(filename, 'w', encoding='utf-8') as file:
            json.dump(unidades, file, ensure_ascii=False, indent=4)
        print(f"Unidades acadêmicas salvas em {filename}")
