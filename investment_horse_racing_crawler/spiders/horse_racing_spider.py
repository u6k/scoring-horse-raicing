import datetime
import re
import scrapy


from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem


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

        i = RaceInfoItem()
        race_id = response.url.split("/")[-2]
        i["race_id"] = race_id
        i["race_round"] = int(response.xpath("//td[@id='raceNo']/text()").get()[:-1])
        i["start_datetime"] = response.xpath("//p[@id='raceTitDay']/text()").get() + response.xpath("//p[@id='raceTitDay']/text()[3]").get()
        i["start_datetime"] = re.sub(r"^(\d+)年(\d+)月(\d+)日.+?(\d+):(\d+)発走$", r"\1-\2-\3 \4:\5", i["start_datetime"])
        i["start_datetime"] = datetime.datetime.strptime(i["start_datetime"], "%Y-%m-%d %H:%M")
        i["place_name"] = response.xpath("//p[@id='raceTitDay']/text()[2]").get().strip()
        i["race_name"] = response.xpath("//div[@id='raceTitName']/h1/text()").get().strip()
        i["course_type"] = response.xpath("//p[@id='raceTitMeta']/text()").get().strip()
        i["course_length"] = response.xpath("//p[@id='raceTitMeta']/text()").get().strip()
        i["weather"] = response.xpath("//p[@id='raceTitMeta']/img[1]/@alt").get()
        i["course_condition"] = response.xpath("//p[@id='raceTitMeta']/img[2]/@alt").get().strip()
        i["added_money"] = response.xpath("//p[@id='raceTitMeta']/text()[8]").get().strip()

        self.logger.debug("#parse_race_result: race info=%s" % i)
        yield i

        # Parse race payoff
        self.logger.debug("#parse_race_result: parse race payoff")

        payoff_type = None
        for tr in response.xpath("//table[contains(@class, 'resultYen')]/tr"):
            i = RacePayoffItem()
            i["race_id"] = race_id

            payoff_type_str = tr.xpath("th/text()").get()
            if payoff_type_str == "単勝":
                payoff_type = "win"
            elif payoff_type_str == "複勝":
                payoff_type = "place"
            elif payoff_type_str == "枠連":
                payoff_type = "bracket_quinella"
            elif payoff_type_str == "馬連":
                payoff_type = "quinella"
            elif payoff_type_str == "ワイド":
                payoff_type = "quinella_place"
            elif payoff_type_str == "馬単":
                payoff_type = "exacta"
            elif payoff_type_str == "3連複":
                payoff_type = "trio"
            elif payoff_type_str == "3連単":
                payoff_type = "trifecta"
            elif payoff_type_str is None:
                pass
            else:
                raise RuntimeError("Unknown payoff type str: %s" % payoff_type_str)
            i["payoff_type"] = payoff_type

            horse_number_strs = tr.xpath("td[1]/text()").get().split("－")
            if len(horse_number_strs) == 1:
                i["horse_number_1"] = int(horse_number_strs[0])
                i["horse_number_2"] = None
                i["horse_number_3"] = None
            elif len(horse_number_strs) == 2:
                i["horse_number_1"] = int(horse_number_strs[0])
                i["horse_number_2"] = int(horse_number_strs[1])
                i["horse_number_3"] = None
            elif len(horse_number_strs) == 3:
                i["horse_number_1"] = int(horse_number_strs[0])
                i["horse_number_2"] = int(horse_number_strs[1])
                i["horse_number_3"] = int(horse_number_strs[2])
            else:
                raise RuntimeError("Unknown horse number str: %s" % horse_number_strs)

            i["odds"] = int(tr.xpath("td[2]/text()").get().replace(",", "")[:-1]) / 100.0
            i["favorite_order"] = int(tr.xpath("td[3]/span/text()").get()[:-3])

            self.logger.debug("#parse_race_result: race payoff=%s" % i)
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
