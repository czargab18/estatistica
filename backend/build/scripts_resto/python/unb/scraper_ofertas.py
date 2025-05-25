import requests
from collections import defaultdict
from bs4 import BeautifulSoup
from core.sessions import URL, HEADERS, create_request_session, get_session_cookie, get_response
from core.functions import multiple_replace
import hashlib
import re
import json

def get_list_of_departments(response=get_response(create_request_session(), URL["oferta"])):
    """Obtem a lista de departamentos da UnB."""
    soup = BeautifulSoup(response.content, "html.parser")
    departments = soup.find("select", attrs={"id": "formTurma:inputDepto"})

    if departments is None:
        return None

    options_tag = departments.find_all("option")
    department_ids = []

    for option in options_tag:
        value = option["value"]

        if value != "0":
            department_ids.append(value)

    return department_ids

def get_department_names(response=get_response(create_request_session(), URL["oferta"])):
    """Obtem os nomes e IDs dos departamentos da UnB."""
    soup = BeautifulSoup(response.content, "html.parser")
    departments = soup.find("select", attrs={"id": "formTurma:inputDepto"})

    if departments is None:
        return None

    options_tag = departments.find_all("option")
    department_names = {}

    for option in options_tag:
        value = option["value"]
        text = option.text.strip()

        if value != "0":
            department_names[value] = text

    return department_names

class DisciplineWebScraper:
    def __init__(self, department, year, period, url=URL["oferta"], session=None, cookie=None):
        self.disciplines = defaultdict(list)
        self.department = department
        self.period = period
        self.year = year
        self.url = url
        self.data = {
            "formTurma": "formTurma",
            "formTurma:inputNivel": "",
            "formTurma:inputDepto": self.department,
            "formTurma:inputAno": self.year,
            "formTurma:inputPeriodo": self.period,
            "formTurma:j_id_jsp_1370969402_11": "Buscar",
            "javax.faces.ViewState": "j_id1"
        }
        self.session = session or create_request_session()
        self.cookie = cookie or get_session_cookie(self.session, url)
        self.response = None

    def get_response_from_disciplines_post_request(self):
        self.response = self.session.post(
            self.url, headers=HEADERS, cookies=self.cookie, data=self.data)
        print("Status Code:", self.response.status_code)
        if self.response.status_code == 200:
            print("Response Content:", self.response.content[:100])

    def get_teachers(self, data):
        teachers = []
        for teacher in data:
            teacher = teacher.replace("\n", "").replace(
                "\r", "").replace("\t", "")
            content = teacher.split('(')
            if len(content) < 2:
                continue
            teachers.append(content[0].strip())
        if not teachers:
            teachers.append("A definir")
        return teachers

    def get_schedules_and_intervals(self, data):
        regex = r"\d+[MTN]\d+"
        occurrences = re.finditer(regex, data)
        values = [[], []]
        for value in occurrences:
            values[0].append(value.group())
            values[1].append((value.start(), value.end()))
        return values

    def check_start(self, *args, **kwargs):
        start_index = kwargs.get("start_index")
        last_included = kwargs.get("last_included")
        end_interval = kwargs.get("interval")[1]
        already_included = kwargs["index"] + 1 > last_included
        value_start_check = kwargs.get("value").start() > end_interval
        return start_index is None and value_start_check and already_included

    def check_end(self, *args, **kwargs):
        start_interval = kwargs.get("interval")[0]
        value_start_check = kwargs.get("value").start() < start_interval
        return value_start_check

    def get_start_index(self, intervals, last_included, value):
        start_index = None
        for index, interval in enumerate(intervals):
            if self.check_start(start_index=start_index, last_included=last_included, interval=interval, index=index, value=value):
                start_index = index + 1
        return start_index

    def get_end_index(self, intervals, value):
        for index, interval in enumerate(intervals):
            if self.check_end(interval=interval, index=index, value=value):
                return index
        return len(intervals)

    def get_start_and_end(self, value, intervals, last_included):
        start_index = self.get_start_index(intervals, last_included, value)
        end_index = self.get_end_index(intervals, value)
        return start_index, end_index

    def get_values_from_special_dates(self, occurrences, intervals):
        last_included = -1
        values = []
        for value in occurrences:
            date = value.group()
            start, end = self.get_start_and_end(
                value, intervals, last_included)
            last_included = end
            values.append([date, start, end])
        return values

    def get_special_dates(self, data, intervals):
        date_format = r"\d{2}\/\d{2}\/\d{4}"
        regex = fr"{date_format}\s-\s{date_format}"
        occurrences = re.finditer(regex, data)
        values = self.get_values_from_special_dates(occurrences, intervals)
        return values

    def get_week_days(self, data):
        hours_format = r"\d+:\d+"
        regex = fr"[A-Z]\w?[a-z|ç]+-?[a-z]*\s{hours_format}\sàs\s{hours_format}"
        occurrences = re.findall(regex, data)
        return occurrences

    def make_disciplines(self, rows):
        if rows is None or not len(rows):
            return None

        aux_title_and_code = ""

        for discipline in rows:
            if discipline.find("span", attrs={"class": "tituloDisciplina"}) is not None:
                title = discipline.find(
                    "span", attrs={"class": "tituloDisciplina"})
                aux_title_and_code = title.get_text().strip('-')
            elif "linhaPar" in discipline.get("class", []) or "linhaImpar" in discipline.get("class", []):
                code, name = aux_title_and_code.split(' - ', 1)
                tables_data = discipline.find_all("td")

                teachers_with_workload = discipline.find(
                    "td", attrs={"class": "nome"}).get_text().strip().strip().split(')')
                schedule_context = tables_data[3].get_text().strip()

                class_code = tables_data[0].get_text().strip()
                classroom = tables_data[7].get_text().strip()
                schedules_and_intervals = self.get_schedules_and_intervals(
                    schedule_context)
                special_dates = self.get_special_dates(
                    schedule_context, schedules_and_intervals[1])
                days = self.get_week_days(schedule_context)
                teachers = self.get_teachers(teachers_with_workload)

                self.disciplines[code].append({
                    "name": name,
                    "class_code": class_code,
                    "teachers": teachers,
                    "classroom": classroom,
                    "schedule": " ".join(schedules_and_intervals[0]),
                    "special_dates": special_dates,
                    "days": days
                })

    def retrieve_classes_tables(self, response):
        soup = BeautifulSoup(response.content, "html.parser")
        tables = soup.find("table", attrs={"class": "listagem"})
        return tables

    def create_page_fingerprint(self):
        if not self.response:
            self.get_response_from_disciplines_post_request()
        tables = self.retrieve_classes_tables(self.response)
        if not tables:
            return "not_content"
        treated_tables = multiple_replace(tables.get_text(), replacement={
                                          '\n': '', '\t': '', '\r': '', ' ': ''}).strip()
        return hashlib.sha256(treated_tables.encode('utf-8')).hexdigest()

    def make_web_scraping_of_disciplines(self, response):
        tables = self.retrieve_classes_tables(response)
        if not tables:
            print("Nenhuma tabela encontrada.")
            return None

        table_rows = tables.find_all("tr")
        print("Linhas da Tabela Encontradas:", len(table_rows))
        self.make_disciplines(table_rows)

    def get_disciplines(self):
        if not self.response:
            self.get_response_from_disciplines_post_request()
        self.make_web_scraping_of_disciplines(self.response)
        return self.disciplines

    def save_to_json(self, filename="disciplines.json"):
        """Salva as informações das disciplinas em um arquivo JSON."""
        try:
            with open(filename, 'r', encoding='utf-8') as file:
                existing_data = json.load(file)
        except FileNotFoundError:
            existing_data = {}

        for code, info in self.disciplines.items():
            for course in info:
                department_name = course.get(
                    'department_name', 'Unknown Department')
                if department_name not in existing_data:
                    existing_data[department_name] = {}
                existing_data[department_name][code] = {
                    "código": code,
                    "nome": course.get("name"),
                    "class_code": course.get("class_code"),
                    "teachers": course.get("teachers"),
                    "classroom": course.get("classroom"),
                    "schedule": course.get("schedule"),
                    "special_dates": course.get("special_dates"),
                    "days": course.get("days")
                }

        with open(filename, 'w', encoding='utf-8') as file:
            json.dump(existing_data, file, ensure_ascii=False, indent=4)

        print(f"Dados salvos em {filename}")
