from datetime import datetime
import os

from nose.tools import raises
from scrapy.crawler import Crawler
from scrapy.exceptions import DropItem

from investment_horse_racing_crawler.spiders.horse_racing_spider import HorseRacingSpider
from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem
from investment_horse_racing_crawler.pipelines import PostgreSQLPipeline


class TestPostgreSQLPipeline:
    def setup(self):
        settings = {
            "DB_HOST": os.getenv("DB_HOST"),
            "DB_PORT": os.getenv("DB_PORT"),
            "DB_DATABASE": os.getenv("DB_DATABASE"),
            "DB_USERNAME": os.getenv("DB_USERNAME"),
            "DB_PASSWORD": os.getenv("DB_PASSWORD"),
        }
        crawler = Crawler(HorseRacingSpider, settings)
        self.pipeline = PostgreSQLPipeline.from_crawler(crawler)
        self.pipeline.open_spider(None)

    def teardown(self):
        self.pipeline.close_spider(None)

    def test_process_race_info_item(self):
        item = RaceInfoItem()
        item["race_id"] = ['2010010212']
        item["race_round"] = ['12R']
        item["start_date"] = ['2020年1月19日（日） ']
        item["start_time"] = [' 16:01発走']
        item["place_name"] = [' 1回小倉2日 ']
        item["race_name"] = ['\n呼子特別']
        item["course_type_length"] = ['芝・右 2600m ']
        item["weather"] = ['曇']
        item["course_condition"] = ['重']
        item["added_money"] = [' 本賞金：1060、420、270、160、106万円 ']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["race_id"] == "2010010212"
        assert new_item["race_round"] == 12
        assert new_item["start_datetime"] == datetime(2020, 1, 19, 16, 1, 0)
        assert new_item["place_name"] == "1回小倉2日"
        assert new_item["race_name"] == "呼子特別"
        assert new_item["course_type"] == "芝・右"
        assert new_item["course_length"] == 2600
        assert new_item["weather"] == "曇"
        assert new_item["course_condition"] == "重"
        assert new_item["added_money"] == "本賞金：1060、420、270、160、106万円"

    def test_process_race_payoff_item_1(self):
        item = RacePayoffItem()
        item["race_id"] = ['2010010212']
        item["payoff_type"] = ['単勝']
        item["horse_number"] = ['4']
        item["odds"] = ['1,360円']
        item["favorite_order"] = ['7番人気']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["race_id"] == '2010010212'
        assert new_item["payoff_type"] == "win"
        assert new_item["horse_number"] == 4
        assert new_item["odds"] == 13.6
        assert new_item["favorite_order"] == 7

    def test_process_race_payoff_item_2(self):
        item = RacePayoffItem()
        item["race_id"] = ['2010010212']
        item["payoff_type"] = ['複勝']
        item["horse_number"] = ['7']
        item["odds"] = ['310円']
        item["favorite_order"] = ['6番人気']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["race_id"] == '2010010212'
        assert new_item["payoff_type"] == "place"
        assert new_item["horse_number"] == 7
        assert new_item["odds"] == 3.1
        assert new_item["favorite_order"] == 6

    @raises(DropItem)
    def test_process_race_payoff_item_3(self):
        item = RacePayoffItem()
        item["race_id"] = ['2010010212']
        item["payoff_type"] = ['枠連']
        item["horse_number"] = ['3－5']
        item["odds"] = ['1,950円']
        item["favorite_order"] = ['9番人気']

        self.pipeline.process_item(item, None)
