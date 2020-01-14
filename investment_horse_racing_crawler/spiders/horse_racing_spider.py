import scrapy


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
        @returns items 0
        @returns requests 2 2
        """
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
        """ Parse denma page.

        @url https://keiba.yahoo.co.jp/race/denma/1906050201/
        @returns items 0
        @returns requests 1
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
