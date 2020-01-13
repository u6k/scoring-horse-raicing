import scrapy
from scrapy.loader import ItemLoader

from investment_horse_racing_crawler.items import ScheduleListItem


class HorseRacingSpider(scrapy.Spider):
    name = "horse_racing"

    start_urls = [
        'https://keiba.yahoo.co.jp/schedule/list/',
    ]

    def parse(self, response):
        self.logger.debug("#parse: start: url=%s" % response.url)

        for a in response.xpath("//div[@class='scheHeadNaviR fntSS']/a"):
            self.logger.debug("#parse: other schedule list page: href=%s" % a.xpath("@href").get())
            yield response.follow(a, callback=self.parse)

        for a in response.xpath("//table[@class='scheLs mgnBS']/tbody/tr/td[1][@rowspan='2']/a"):
            self.logger.debug("#parse: race list page: href=%s" % a.xpath("@href").get())
            yield response.follow(a, callback=self.parse_race_list)

        loader = ItemLoader(item=ScheduleListItem(), response=response)
        loader.add_xpath("title", "//title/text()")

        return loader.load_item()

    def parse_race_list(self, response):
        self.logger.debug("#parse_race_list: start: url=%s" % response.url)

        return {
            "title": response.xpath("//title/text()").get()
        }
