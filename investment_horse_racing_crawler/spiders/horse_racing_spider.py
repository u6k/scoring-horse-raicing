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

        for a in response.xpath("//a"):
            href = a.xpath("@href").get()

            if href.startswith("/schedule/list/"):
                self.logger.debug("#parse: other schedule list page: href=%s" % href)
                yield response.follow(a, callback=self.parse)

            if href.startswith("/race/list/"):
                self.logger.debug("#parse: race list page: href=%s" % href)
                yield response.follow(a, callback=self.parse_race_list)

    def parse_race_list(self, response):
        self.logger.debug("#parse_race_list: start: url=%s" % response.url)

        for a in response.xpath("//a"):
            href = a.xpath("@href").get()

            if href.startswith("/race/result/"):
                self.logger.debug("#parse_race_list: race result page: href=%s" % href)
                yield response.follow(a, callback=self.parse_race_result)

    def parse_race_result(self, response):
        self.logger.debug("#parse_race_result: start: url=%s" % response.url)

        for a in response.xpath("//a"):
            href = a.xpath("@href").get()

            if href.startswith("/race/denma/"):
                self.logger.debug("#parse_race_result: race denma page: href=%s" % href)
                yield response.follow(a, callback=self.parse_race_denma)

            if href.startswith("/odds/tfw/"):
                self.logger.debug("#parse_race_result: odds page: href=%s" % href)
                yield response.follow(a, callback=self.parse_odds)

    def parse_race_denma(self, response):
        self.logger.debug("#parse_race_denma: start: url=%s" % response.url)

        for a in response.xpath("//a"):
            href = a.xpath("@href").get()

            if href.startswith("/directory/horse/"):
                self.logger.debug("#parse_race_denma: horse page: href=%s" % href)
                yield response.follow(a, callback=self.parse_horse)

            if href.startswith("/directory/trainer/"):
                self.logger.debug("#parse_race_denma: trainer page: href=%s" % href)
                yield response.follow(a, callback=self.parse_trainer)

            if href.startswith("/directory/jocky/"):
                self.logger.debug("#parse_race_denma: jockey page: href=%s" % href)
                yield response.follow(a, callback=self.parse_jockey)

    def parse_horse(self, response):
        self.logger.debug("#parse_horse: start: url=%s" % response.url)

    def parse_trainer(self, response):
        self.logger.debug("#parse_trainer: start: url=%s" % response.url)

    def parse_jockey(self, response):
        self.logger.debug("#parse_jockey: start: url=%s" % response.url)

    def parse_odds(self, response):
        self.logger.debug("#parse_odds: start: url=%s" % response.url)
