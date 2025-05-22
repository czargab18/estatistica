import unittest
from utils.disciplinas.scraper_ementa_disciplina_ import OfertaWebScraper
import json

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

    def test_make_componentes(self):
        self.scraper.get_response_from_oferta_post_request()
        self.scraper.make_web_scraping_of_componentes(self.scraper.response)
        componentes = self.scraper.get_componentes()
        self.assertGreater(len(componentes), 0)
        for codigo, info in componentes.items():
            for componente in info:
                self.assertIn("nome", componente)
                self.assertIn("tipo", componente)
                self.assertIn("ch_total", componente)

    def test_save_to_json(self):
        self.scraper.get_response_from_oferta_post_request()
        self.scraper.make_web_scraping_of_componentes(self.scraper.response)
        self.scraper.save_to_json("./data/disciplinas/disciplinas.json")
        with open("./data/disciplinas/disciplinas.json", 'r', encoding='utf-8') as file:
            data = json.load(file)
            self.assertGreater(len(data), 0)

if __name__ == "__main__":
    unittest.main()