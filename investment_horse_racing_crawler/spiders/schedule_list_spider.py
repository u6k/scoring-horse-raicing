import scrapy
from scrapy.loader import ItemLoader

from investment_horse_racing_crawler.items import ScheduleListItem


class ScheduleListSpider(scrapy.Spider):
    name = "schedule_list"

    start_urls = [
        'https://keiba.yahoo.co.jp/schedule/list/',
    ]

    def parse(self, response):
        self.logger.debug("#parse: start: url=%s" % response.url)

        loader = ItemLoader(item=ScheduleListItem(), response=response)
        loader.add_xpath("title", "//title/text()")

        return loader.load_item()
