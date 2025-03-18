from requests import Session, Response, cookies
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from datetime import datetime
from typing import List

"""Este módulo contém funções necessárias para realizar uma requisição ao SIGAA corretamente."""

URL = {
    "oferta": "https://sigaa.unb.br/sigaa/public/turmas/listar.jsf",
    "ementa": "https://sigaa.unb.br/sigaa/public/componentes/busca_componentes.jsf?aba=p-ensino",
    "calendario": "https://saa.unb.br/graduacao/calendario-academico"
}
HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '3600',
    'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0'
}

"""Cria uma sessão de requisição e retorna um objeto Session."""

def create_request_session() -> Session:
    session = Session()
    retry = Retry(connect=3, backoff_factor=0.5)
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('https://', adapter)
    return session

"""Obtem a resposta da requisição ao SIGAA e retorna um objeto Response."""

def get_response(session: Session, url: str) -> Response:
    response = session.get(url=url, headers=HEADERS)
    return response

"""Obtem o cookie da sessão de requisição necessário para acessar a pagina de turmas e retorna um cookie jar."""

def get_session_cookie(session: Session, url: str) -> cookies.RequestsCookieJar:  # pragma: no cover
    response = get_response(session, url)
    cookie = response.cookies.get_dict()
    cookie_jar = cookies.RequestsCookieJar()
    cookie_jar.update(cookie)
    return cookie_jar

"""Obtem o ano e o período atual e retorna uma lista com esses valores."""

def get_current_year_and_period(date: datetime | None = datetime.now()) -> List[str | str]:
    if date is None:
        date = datetime.now()
    current_year = date.year
    period = "1"
    if datetime(current_year, 5, 2) <= date <= datetime(current_year + 1, 1, 1):
        period = "2"
    return [str(current_year), period]

"""Obtem o ano e o período seguinte e retorna uma lista com esses valores."""


def get_next_period(date: datetime | None = None) -> List[str | str]:
    date = get_current_year_and_period(date)
    if date[1] == "1":
        date[1] = "2"
        return date
    date[0] = str(int(date[0]) + 1)
    date[1] = "1"
    return date

def get_previous_period(date: datetime | None = None) -> List[str | str]:
    date = get_current_year_and_period(date)
    if date[1] == "2":
        date[1] = "1"
        return date
    date[0] = str(int(date[0]) - 1)
    date[1] = "2"
    return date
