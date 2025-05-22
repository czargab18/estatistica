from utils.disciplinas.scraper_ofertas import DisciplineWebScraper, get_department_names
from core.sessions import get_current_year_and_period


def main():
    # Passo 1: Obter os nomes e IDs dos departamentos
    department_names = get_department_names()
    if department_names:
        print("Departamentos obtidos com sucesso:", department_names)
    else:
        print("Falha ao obter departamentos")
        return

    # Obter o ano e o período atual
    current_year, period = get_current_year_and_period()

    for department_id, department_name in department_names.items():
        # Passo 2: Criar uma instância da classe DisciplineWebScraper
        scraper = DisciplineWebScraper(department_id, current_year, period)

        # Passo 3: Obter as disciplinas
        disciplines = scraper.get_disciplines()

        if disciplines:
            print(
                f"Disciplinas obtidas com sucesso para o departamento {department_name} ({department_id}):")
            for code, info in disciplines.items():
                print(f"Código: {code}, Informações: {info}")

            # Passo 4: Salvar as disciplinas em um arquivo JSON
            scraper.save_to_json("./data/ofertas/ofertas.json")
        else:
            print(
                f"Falha ao obter disciplinas para o departamento {department_name} ({department_id})")

    print("Todas as disciplinas foram salvas em disciplines.json")


if __name__ == "__main__":
    main()