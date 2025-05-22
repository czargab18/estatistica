import scrapy
from scrapy.crawler import CrawlerProcess
import json
from urllib.parse import urlparse, urljoin


class PathSpider(scrapy.Spider):
    name = "path_spider"
    start_urls = ["https://est.unb.br/"]
    allowed_domains = ["est.unb.br"]
    custom_settings = {
        'DOWNLOAD_DELAY': 2,  # Adiciona um atraso de 2 segundos entre as solicitações
        'RETRY_TIMES': 5,  # Aumenta o número de tentativas de retry
        'DOWNLOAD_TIMEOUT': 30,  # Aumenta o tempo de timeout para 30 segundos
        'HTTPPROXY_ENABLED': True,
        'HTTPPROXY_PROXY': 'socks5h://127.0.0.1:9050',  # Configura o proxy Tor
        # User-Agent para evitar bloqueio por bot
        'USER_AGENT': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
    }
    visited_urls = set()
    collected_paths = set()

    def parse(self, response):
        base_url = "https://est.unb.br"

        for link in response.css('a::attr(href)').getall():
            url = urljoin(base_url, link)
            parsed_url = urlparse(url)
            if parsed_url.netloc == "est.unb.br":
                path = parsed_url.path
                if path and url not in self.visited_urls:
                    self.visited_urls.add(url)
                    self.collected_paths.add(path)
                    yield scrapy.Request(url, callback=self.parse)

        self.save_to_json()

    def save_to_json(self):
        paths_list = list(self.collected_paths)
        with open('paths.json', 'w') as f:
            json.dump(paths_list, f, indent=4)
        self.log(f"Saved {len(paths_list)} paths to paths.json")


if __name__ == "__main__":
    process = CrawlerProcess(settings={
        "FEEDS": {
            "paths.json": {"format": "json"},
        },
    })

    process.crawl(PathSpider)
    process.start()
