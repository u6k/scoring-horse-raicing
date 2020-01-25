from datetime import datetime
import os

from nose.tools import raises
from scrapy.crawler import Crawler
from scrapy.exceptions import DropItem

from investment_horse_racing_crawler.spiders.horse_racing_spider import HorseRacingSpider
from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem, RaceResultItem, HorseItem, TrainerItem, JockeyItem, OddsWinPlaceItem
from investment_horse_racing_crawler.pipelines import PostgreSQLPipeline


class TestPostgreSQLPipeline:
    def setup(self):
        # Setting pipeline
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

        # Setting db
        self.pipeline.db_cursor.execute("delete from race_info")

    def teardown(self):
        self.pipeline.close_spider(None)

    def test_process_race_info_item(self):
        # Setup
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

        # Before check
        self.pipeline.db_cursor.execute("select * from race_info")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
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

        # Check db
        self.pipeline.db_cursor.execute("select * from race_info")

        race_infos = self.pipeline.db_cursor.fetchall()
        assert len(race_infos) == 1

        race_info = race_infos[0]
        assert race_info["race_id"] == "2010010212"
        assert race_info["race_round"] == 12
        assert race_info["start_datetime"] == datetime(2020, 1, 19, 16, 1, 0)
        assert race_info["place_name"] == "1回小倉2日"
        assert race_info["race_name"] == "呼子特別"
        assert race_info["course_type"] == "芝・右"
        assert race_info["course_length"] == 2600
        assert race_info["weather"] == "曇"
        assert race_info["course_condition"] == "重"
        assert race_info["added_money"] == "本賞金：1060、420、270、160、106万円"

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

    def test_process_race_result_item_1(self):
        item = RaceResultItem()
        item["race_id"] = ['2010010212']
        item["result"] = ['\n1  ']
        item["bracket_number"] = ['3']
        item["horse_number"] = ['\n4  ']
        item["horse_id"] = ['/directory/horse/2015104408/']
        item["horse_name"] = ['ワセダインブルー']
        item["horse_gender_age"] = ['\n牡5/442(-6)/    ']
        item["horse_weight_and_diff"] = ['\n牡5/442(-6)/    ']
        item["arrival_time"] = ['\n2.43.6']
        item["jockey_id"] = ['/directory/jocky/01143/']
        item["jockey_name"] = ['原田 和真']
        item["jockey_weight"] = ['57.0']
        item["favorite_order"] = ['\n7    ']
        item["odds"] = ['(13.6)']
        item["trainer_id"] = ['/directory/trainer/01132/']
        item["trainer_name"] = ['金成 貴史']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["race_id"] == "2010010212"
        assert new_item["result"] == 1
        assert new_item["bracket_number"] == 3
        assert new_item["horse_number"] == 4
        assert new_item["horse_id"] == "2015104408"
        assert new_item["horse_name"] == "ワセダインブルー"
        assert new_item["horse_gender"] == "牡"
        assert new_item["horse_age"] == 5
        assert new_item["horse_weight"] == 442.0
        assert new_item["horse_weight_diff"] == -6.0
        assert new_item["arrival_time"] == 163.6
        assert new_item["jockey_id"] == "01143"
        assert new_item["jockey_name"] == "原田 和真"
        assert new_item["jockey_weight"] == 57.0
        assert new_item["favorite_order"] == 7
        assert new_item["odds"] == 13.6
        assert new_item["trainer_id"] == "01132"
        assert new_item["trainer_name"] == "金成 貴史"

    def test_process_race_result_item_2(self):
        item = RaceResultItem()
        item["race_id"] = ['2010010212']
        item["result"] = ['\n4  ']
        item["bracket_number"] = ['8']
        item["horse_number"] = ['\n13  ']
        item["horse_id"] = ['/directory/horse/2015106286/']
        item["horse_name"] = ['サダムラピュタ']
        item["horse_gender_age"] = ['\nせん5/478(+10)/B    ']
        item["horse_weight_and_diff"] = ['\nせん5/478(+10)/B    ']
        item["arrival_time"] = ['\n2.44.9']
        item["jockey_id"] = ['/directory/jocky/01154/']
        item["jockey_name"] = ['松若 風馬']
        item["jockey_weight"] = ['57.0']
        item["favorite_order"] = ['\n3    ']
        item["odds"] = ['(6.9)']
        item["trainer_id"] = ['/directory/trainer/01082/']
        item["trainer_name"] = ['平田 修']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["race_id"] == "2010010212"
        assert new_item["result"] == 4
        assert new_item["bracket_number"] == 8
        assert new_item["horse_number"] == 13
        assert new_item["horse_id"] == "2015106286"
        assert new_item["horse_name"] == 'サダムラピュタ'
        assert new_item["horse_gender"] == "せん"
        assert new_item["horse_age"] == 5
        assert new_item["horse_weight"] == 478.0
        assert new_item["horse_weight_diff"] == 10.0
        assert new_item["arrival_time"] == 164.9
        assert new_item["jockey_id"] == "01154"
        assert new_item["jockey_name"] == "松若 風馬"
        assert new_item["jockey_weight"] == 57.0
        assert new_item["favorite_order"] == 3
        assert new_item["odds"] == 6.9
        assert new_item["trainer_id"] == "01082"
        assert new_item["trainer_name"] == "平田 修"

    def test_process_horse_item(self):
        item = HorseItem()
        item["horse_id"] = ['2017101602']
        item["gender"] = [' 牡 ']
        item["name"] = ['エリンクロノス']
        item["birthday"] = ['2017年3月31日']
        item["coat_color"] = ['栗毛']
        item["trainer_id"] = ['/directory/trainer/01012/']
        item["owner"] = ['田頭 勇貴']
        item["breeder"] = ['大栄牧場']
        item["breeding_farm"] = ['新冠町']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["horse_id"] == "2017101602"
        assert new_item["gender"] == "牡"
        assert new_item["name"] == "エリンクロノス"
        assert new_item["birthday"] == datetime(2017, 3, 31, 0, 0, 0)
        assert new_item["coat_color"] == "栗毛"
        assert new_item["trainer_id"] == "01012"
        assert new_item["owner"] == "田頭 勇貴"
        assert new_item["breeder"] == "大栄牧場"
        assert new_item["breeding_farm"] == "新冠町"

    def test_process_trainer_item(self):
        item = TrainerItem()
        item["trainer_id"] = ['01012']
        item["name_kana"] = ['オオエハラ サトシ ']
        item["name"] = ['大江原 哲']
        item["birthday"] = ['1953年2月13日']
        item["belong_to"] = ['\n美浦']
        item["first_licensing_year"] = ['1996年']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["trainer_id"] == "01012"
        assert new_item["name_kana"] == "オオエハラ サトシ"
        assert new_item["name"] == "大江原 哲"
        assert new_item["birthday"] == datetime(1953, 2, 13, 0, 0, 0)
        assert new_item["belong_to"] == "美浦"
        assert new_item["first_licensing_year"] == 1996

    def test_process_jockey_item(self):
        item = JockeyItem()
        item["jockey_id"] = ['01167']
        item["name_kana"] = ['コワタ イクヤ ']
        item["name"] = ['木幡 育也']
        item["birthday"] = ['1998年9月21日']
        item["belong_to"] = ['\n美浦(藤沢 和雄)']
        item["first_licensing_year"] = ['2017年（平地・障害）']

        new_item = self.pipeline.process_item(item, None)

        assert new_item["jockey_id"] == "01167"
        assert new_item["name_kana"] == "コワタ イクヤ"
        assert new_item["name"] == "木幡 育也"
        assert new_item["birthday"] == datetime(1998, 9, 21, 0, 0, 0)
        assert new_item["belong_to"] == "美浦(藤沢 和雄)"
        assert new_item["first_licensing_year"] == 2017

    def test_process_odds_win_place_item(self):
        item = OddsWinPlaceItem()
        item["race_id"] = ['1906050201']
        item["horse_number"] = ['1']
        item["horse_id"] = ['/directory/horse/2017101602/']
        item["odds_win"] = ['161.2']
        item["odds_place_min"] = ['26.0']
        item["odds_place_max"] = ['43.8']

        new_item = self.pipeline.process_item(item, None)

        odds_win_item = new_item["win"]
        assert odds_win_item["race_id"] == "1906050201"
        assert odds_win_item["horse_number"] == 1
        assert odds_win_item["horse_id"] == "2017101602"
        assert odds_win_item["odds"] == 161.2

        odds_place_item = new_item["place"]
        assert odds_place_item["race_id"] == "1906050201"
        assert odds_place_item["horse_number"] == 1
        assert odds_place_item["horse_id"] == "2017101602"
        assert odds_place_item["odds_min"] == 26.0
        assert odds_place_item["odds_max"] == 43.8
