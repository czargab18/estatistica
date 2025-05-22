import unittest
import json
from utils.unb.scraper_calendario import CalendarioWebScraper

class TestCalendarioWebScraper(unittest.TestCase):
    def setUp(self):
        self.scraper = CalendarioWebScraper()

    def test_get_response_from_calendario_request(self):
        self.scraper.get_response_from_calendario_request()
        self.assertIsNotNone(self.scraper.response)
        self.assertEqual(self.scraper.response.status_code, 200)

    def test_make_periodos(self):
        self.scraper.get_response_from_calendario_request()
        self.scraper.make_web_scraping_of_periodos(self.scraper.response)
        periodos = self.scraper.get_periodos()
        self.assertGreater(len(periodos), 0)
        for year, data in periodos.items():
            for periodo in data:
                self.assertIn("período", periodo)
                self.assertIn("início", periodo)
                self.assertIn("fim", periodo)

    def test_save_to_json(self):
        self.scraper.get_response_from_calendario_request()
        self.scraper.make_web_scraping_of_periodos(self.scraper.response)
        self.scraper.extract_links(self.scraper.response)
        self.scraper.verify_links()
        self.scraper.save_to_json("./data/calendario/calendario.json")
        with open("./data/calendario/calendario.json", 'r', encoding='utf-8') as file:
            data = json.load(file)
            self.assertGreater(len(data["periodo"]), 0)
            for year, periodos in data["periodo"].items():
                for periodo in periodos:
                    self.assertIn("período", periodo)
                    self.assertIn("início", periodo)
                    self.assertIn("fim", periodo)
            self.assertGreater(len(data["matricula"]), 0)
            self.assertGreater(len(data["atividades"]), 0)
            self.assertGreater(len(data["verao"]), 0)


if __name__ == "__main__":
    unittest.main()
