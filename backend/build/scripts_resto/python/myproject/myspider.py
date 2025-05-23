import scrapy


class MyspiderSpider(scrapy.Spider):
    name = "myspider"
    allowed_domains = ["unb.br"]
    start_urls = ["https://unb.br"]

    def parse(self, response):
        pass
