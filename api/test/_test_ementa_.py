import unittest
import json
from utils.disciplinas.scraper_ementa import OfertaWebScraper


class TestOfertaWebScraper(unittest.TestCase):
    def setUp(self):
        self.scraper = OfertaWebScraper(
            nivel="G",
            tipo="2",
            unidade="518"
        )

    def test_get_response_from_oferta_post_request(self):
        self.scraper.get_response_from_oferta_post_request()
        self.assertIsNotNone(self.scraper.response)
        self.assertEqual(self.scraper.response.status_code, 200)

    def test_extract_unidades(self):
        unidades = self.scraper.extract_unidades()
        self.assertGreater(len(unidades), 0)
        self.scraper.save_unidades_to_json(
            unidades, "./data/unidades/unidades.json")
        with open("./data/unidades/unidades.json", 'r', encoding='utf-8') as file:
            data = json.load(file)
            self.assertGreater(len(data), 0)

    def test_make_componentes(self):
        unidades = self.scraper.extract_unidades()
        self.scraper.save_unidades_to_json(
            unidades, "./data/unidades/unidades.json")

        # Seleciona a primeira unidade encontrada
        self.scraper.unidade = list(unidades.keys())[0]
        self.scraper.get_response_from_oferta_post_request()
        self.scraper.make_web_scraping_of_componentes(self.scraper.response)
        componentes = self.scraper.get_componentes()
        if len(componentes) == 0:
            print("Response Content:", self.scraper.response.content.decode(
                'utf-8'))  # Imprimir o conteúdo completo da resposta
        self.assertGreater(len(componentes), 0)
        unidade_texto = unidades[self.scraper.unidade]
        for unidade, info in componentes.items():
            self.assertEqual(unidade, unidade_texto)
            for componente in info:
                self.assertIn("nome", componente)
                self.assertIn("tipo", componente)
                self.assertIn("ch_total", componente)

    def test_save_to_json(self):
        unidades = self.scraper.extract_unidades()
        self.scraper.save_unidades_to_json(
            unidades, "./data/unidades/unidades.json")

        # Seleciona a primeira unidade encontrada
        self.scraper.unidade = list(unidades.keys())[0]
        self.scraper.get_response_from_oferta_post_request()
        self.scraper.make_web_scraping_of_componentes(self.scraper.response)
        self.scraper.save_to_json("test_componentes.json")
        with open("test_componentes.json", 'r', encoding='utf-8') as file:
            data = json.load(file)
            if len(data) == 0:
                print("Response Content:", self.scraper.response.content.decode(
                    'utf-8'))  # Imprimir o conteúdo completo da resposta
            self.assertGreater(len(data), 0)
            departamento = unidades[self.scraper.unidade]
            self.assertIn(departamento, data)
            for codigo, componente in data[departamento].items():
                self.assertIn("código", componente)
                self.assertIn("nome", componente)
                self.assertIn("tipo", componente)
                self.assertIn("ch_total", componente)


if __name__ == "__main__":
    unittest.main()
