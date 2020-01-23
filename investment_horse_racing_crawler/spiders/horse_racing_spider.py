import scrapy
from scrapy.loader import ItemLoader


from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem, RaceResultItem


class HorseRacingSpider(scrapy.Spider):
    name = "horse_racing"

    start_urls = [
        'https://keiba.yahoo.co.jp/schedule/list/',
    ]

    def parse(self, response):
        """ Parse schedule list page.

        @url https://keiba.yahoo.co.jp/schedule/list/2019/?month=12
        @returns items 0
        @returns requests 1
        @schedule_list
        """
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
        """ Parse race list page.

        @url https://keiba.yahoo.co.jp/race/list/19060502/
        @returns items 0
        @returns requests 1
        @race_list
        """
        self.logger.debug("#parse_race_list: start: url=%s" % response.url)

        for a in response.xpath("//a"):
            href = a.xpath("@href").get()

            if href.startswith("/race/result/"):
                self.logger.debug("#parse_race_list: race result page: href=%s" % href)
                yield response.follow(a, callback=self.parse_race_result)

    def parse_race_result(self, response):
        """ Parse race result page.

        @url https://keiba.yahoo.co.jp/race/result/1906050201/
        @returns items 1
        @returns requests 2 2
        @race_result
        """
        self.logger.debug("#parse_race_result: start: url=%s" % response.url)

        # Parse race info
        self.logger.debug("#parse_race_result: parse race info")

        loader = ItemLoader(item=RaceInfoItem(), response=response)
        race_id = response.url.split("/")[-2]
        loader.add_value("race_id", race_id)
        loader.add_xpath("race_round", "//td[@id='raceNo']/text()")
        loader.add_xpath("start_date", "//p[@id='raceTitDay']/text()[1]")
        loader.add_xpath("start_time", "//p[@id='raceTitDay']/text()[3]")
        loader.add_xpath("place_name", "//p[@id='raceTitDay']/text()[2]")
        loader.add_xpath("race_name", "//div[@id='raceTitName']/h1/text()")
        loader.add_xpath("course_type_length", "//p[@id='raceTitMeta']/text()[1]")
        loader.add_xpath("weather", "//p[@id='raceTitMeta']/img[1]/@alt")
        loader.add_xpath("course_condition", "//p[@id='raceTitMeta']/img[2]/@alt")
        loader.add_xpath("added_money", "//p[@id='raceTitMeta']/text()[8]")
        i = loader.load_item()

        self.logger.debug("#parse_race_result: race info=%s" % i)
        yield i

        # Parse race payoff
        self.logger.debug("#parse_race_result: parse race payoff")

        payoff_type = None
        for tr in response.xpath("//table[contains(@class, 'resultYen')]/tr"):
            payoff_type_str = tr.xpath("th/text()").get()
            if payoff_type_str is not None:
                payoff_type = payoff_type_str

            loader = ItemLoader(item=RacePayoffItem(), selector=tr)
            loader.add_value("race_id", race_id)
            loader.add_value("payoff_type", payoff_type)
            loader.add_xpath("horse_number", "td[1]/text()")
            loader.add_xpath("odds", "td[2]/text()")
            loader.add_xpath("favorite_order", "td[3]/span/text()")
            i = loader.load_item()

            self.logger.debug("#parse_race_result: race payoff=%s" % i)
            yield i

        # Parse race result
        self.logger.debug("#parse_race_result: parse race result")

        for tr in response.xpath("//table[@id='raceScore']/tbody/tr"):
            loader = ItemLoader(item=RaceResultItem(), selector=tr)
            loader.add_value("race_id", race_id)
            loader.add_xpath("result", "td[1]/text()")
            loader.add_xpath("bracket_number", "td[2]/span/text()")
            loader.add_xpath("horse_number", "td[3]/text()")
            loader.add_xpath("horse_id", "td[4]/a/@href")
            loader.add_xpath("horse_name", "td[4]/a/text()")
            loader.add_xpath("horse_gender_age", "td[4]/span/text()")
            loader.add_xpath("horse_weight_and_diff", "td[4]/span/text()")
            loader.add_xpath("arrival_time", "td[5]/text()[1]")
            loader.add_xpath("jockey_id", "td[7]/a/@href")
            loader.add_xpath("jockey_name", "td[7]/a/text()")
            loader.add_xpath("jockey_weight", "td[7]/span/text()")
            loader.add_xpath("favorite_order", "td[8]/text()[1]")
            loader.add_xpath("odds", "td[8]/span/text()")
            loader.add_xpath("trainer_id", "td[9]/a/@href")
            loader.add_xpath("trainer_name", "td[9]/a/text()")
            i = loader.load_item()

            self.logger.debug("#parse_race_result: race result=%s" % i)
            yield i

        # Parse link
        self.logger.debug("#parse_race_result: parse link")

        for a in response.xpath("//a"):
            href = a.xpath("@href").get()

            if href.startswith("/race/denma/"):
                self.logger.debug("#parse_race_result: race denma page: href=%s" % href)
                yield response.follow(a, callback=self.parse_race_denma)

            if href.startswith("/odds/tfw/"):
                self.logger.debug("#parse_race_result: odds page: href=%s" % href)
                yield response.follow(a, callback=self.parse_odds)

    def parse_race_denma(self, response):
        """ Parse denma page.

        @url https://keiba.yahoo.co.jp/race/denma/1906050201/
        @returns items 0
        @returns requests 1
        @race_denma
        """
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
        """ Parse horse page.

        @url https://keiba.yahoo.co.jp/directory/horse/2017101602/
        @returns items 0
        @returns requests 0 0
        """
        self.logger.debug("#parse_horse: start: url=%s" % response.url)

    def parse_trainer(self, response):
        """ Parse trainer page.

        @url https://keiba.yahoo.co.jp/directory/trainer/01012/
        @returns items 0
        @returns requests 0 0
        """
        self.logger.debug("#parse_trainer: start: url=%s" % response.url)

    def parse_jockey(self, response):
        """ Parse jockey page.

        @url https://keiba.yahoo.co.jp/directory/jocky/01167/
        @returns items 0
        @returns requests 0 0
        """
        self.logger.debug("#parse_jockey: start: url=%s" % response.url)

    def parse_odds(self, response):
        """ Parse odds page.

        @url https://keiba.yahoo.co.jp/odds/tfw/1906050201/
        @returns items 0
        @returns requests 0 0
        """
        self.logger.debug("#parse_odds: start: url=%s" % response.url)
