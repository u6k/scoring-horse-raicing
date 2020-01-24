from datetime import datetime
import os

from scrapy.crawler import Crawler

from investment_horse_racing_crawler.spiders.horse_racing_spider import HorseRacingSpider
from investment_horse_racing_crawler.items import RaceInfoItem
from investment_horse_racing_crawler.pipelines import PostgreSQLPipeline


def test_process_race_info_item():
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

    settings = {
        "DB_HOST": os.getenv("DB_HOST"),
        "DB_PORT": os.getenv("DB_PORT"),
        "DB_DATABASE": os.getenv("DB_DATABASE"),
        "DB_USERNAME": os.getenv("DB_USERNAME"),
        "DB_PASSWORD": os.getenv("DB_PASSWORD"),
    }
    crawler = Crawler(HorseRacingSpider, settings)
    pipeline = PostgreSQLPipeline.from_crawler(crawler)
    pipeline.open_spider(None)

    new_item = pipeline.process_item(item, None)

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

    pipeline.close_spider(None)
