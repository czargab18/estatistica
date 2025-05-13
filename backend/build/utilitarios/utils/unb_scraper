pip install scrapy
scrapy startproject myproject
scrapy genspider myspider example.com
scrapy genspider myspider example.com

import scrapy
import json
from scrapy.linkextractors import LinkExtractor

class MySpider(scrapy.Spider):
    name = "myspider"
    allowed_domains = ["example.com"]
    start_urls = ["http://example.com"]
    links = []

    def parse(self, response):
        link_extractor = LinkExtractor(allow_domains=self.allowed_domains)
        for link in link_extractor.extract_links(response):
            full_url = link.url
            if full_url not in self.links:
                self.links.append(full_url)
                yield response.follow(link, self.parse)

        # Salvar os links em um arquivo JSON ao final do rastreamento
        with open('links.json', 'w') as f:
            json.dump(self.links, f, indent=4)


scrapy crawl myspider
