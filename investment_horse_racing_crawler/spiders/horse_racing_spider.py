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

    def parse_race_list(self, response):
        self.logger.debug("#parse_race_list: start: url=%s" % response.url)

        for a in response.xpath("//table[@class='scheLs']/tbody/tr/td[@class='wsLB']/a"):
            self.logger.debug("#parse_race_list: race result page: href=%s" % a.xpath("@href").get())
            yield response.follow(a, callback=self.parse_race_result)

    def parse_race_result(self, response):
        self.logger.debug("#parse_race_result: start: url=%s" % response.url)
