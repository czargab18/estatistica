import scrapy
import json
from urllib.parse import urlparse
from scrapy.linkextractors import LinkExtractor


class MyspiderSpider(scrapy.Spider):
    name = "myspider"
    allowed_domains = ["unb.br"]
    start_urls = ["https://unb.br"]
    subdomain_links = []

    def parse(self, response):
        link_extractor = LinkExtractor(allow_domains=self.allowed_domains)
        for link in link_extractor.extract_links(response):
            full_url = link.url
            parsed_url = urlparse(full_url)
            # Verificar se o link pertence a um subdomínio
            if parsed_url.hostname and parsed_url.hostname.endswith('.unb.br'):
                if full_url not in self.subdomain_links:
                    self.subdomain_links.append(full_url)
                    yield response.follow(link, self.parse)

        # Salvar os links em um arquivo JSON ao final do rastreamento
        with open('subdomain_links.json', 'w') as f:
            json.dump(self.subdomain_links, f, indent=4)
