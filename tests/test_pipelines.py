from datetime import datetime
import os

from scrapy.crawler import Crawler
from scrapy.exceptions import DropItem

from investment_horse_racing_crawler.spiders.horse_racing_spider import HorseRacingSpider
from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem, RaceResultItem, RaceDenmaItem, HorseItem, TrainerItem, JockeyItem, OddsWinPlaceItem
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
        self.pipeline.db_cursor.execute("delete from race_payoff")
        self.pipeline.db_cursor.execute("delete from race_result")
        self.pipeline.db_cursor.execute("delete from race_denma")
        self.pipeline.db_cursor.execute("delete from horse")
        self.pipeline.db_cursor.execute("delete from trainer")
        self.pipeline.db_cursor.execute("delete from jockey")
        self.pipeline.db_cursor.execute("delete from odds_win")
        self.pipeline.db_cursor.execute("delete from odds_place")
        self.pipeline.db_conn.commit()

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

        # Execute (2)
        self.pipeline.process_item(item, None)

        # Check db (2)
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
        # Setup
        item = RacePayoffItem()
        item["race_id"] = ['2010010212']
        item["payoff_type"] = ['単勝']
        item["horse_number"] = ['4']
        item["odds"] = ['1,360円']
        item["favorite_order"] = ['7番人気']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_payoff")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '2010010212'
        assert new_item["payoff_type"] == "win"
        assert new_item["horse_number"] == 4
        assert new_item["odds"] == 13.6
        assert new_item["favorite_order"] == 7

        # Check db
        self.pipeline.db_cursor.execute("select * from race_payoff")

        race_payoffs = self.pipeline.db_cursor.fetchall()
        assert len(race_payoffs) == 1

        race_payoff = race_payoffs[0]
        assert race_payoff["race_payoff_id"] == '2010010212_win_4'
        assert race_payoff["race_id"] == '2010010212'
        assert race_payoff["payoff_type"] == "win"
        assert race_payoff["horse_number"] == 4
        assert race_payoff["odds"] == 13.6
        assert race_payoff["favorite_order"] == 7

        # Execute (2)
        self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_payoff")

        race_payoffs = self.pipeline.db_cursor.fetchall()
        assert len(race_payoffs) == 1

        race_payoff = race_payoffs[0]
        assert race_payoff["race_payoff_id"] == '2010010212_win_4'
        assert race_payoff["race_id"] == '2010010212'
        assert race_payoff["payoff_type"] == "win"
        assert race_payoff["horse_number"] == 4
        assert race_payoff["odds"] == 13.6
        assert race_payoff["favorite_order"] == 7

    def test_process_race_payoff_item_2(self):
        # Setup
        item = RacePayoffItem()
        item["race_id"] = ['2010010212']
        item["payoff_type"] = ['複勝']
        item["horse_number"] = ['7']
        item["odds"] = ['310円']
        item["favorite_order"] = ['6番人気']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_payoff")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '2010010212'
        assert new_item["payoff_type"] == "place"
        assert new_item["horse_number"] == 7
        assert new_item["odds"] == 3.1
        assert new_item["favorite_order"] == 6

        # Check db
        self.pipeline.db_cursor.execute("select * from race_payoff")

        race_payoffs = self.pipeline.db_cursor.fetchall()
        assert len(race_payoffs) == 1

        race_payoff = race_payoffs[0]
        assert race_payoff["race_payoff_id"] == '2010010212_place_7'
        assert race_payoff["race_id"] == '2010010212'
        assert race_payoff["payoff_type"] == "place"
        assert race_payoff["horse_number"] == 7
        assert race_payoff["odds"] == 3.1
        assert race_payoff["favorite_order"] == 6

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_payoff")

        race_payoffs = self.pipeline.db_cursor.fetchall()
        assert len(race_payoffs) == 1

        race_payoff = race_payoffs[0]
        assert race_payoff["race_payoff_id"] == '2010010212_place_7'
        assert race_payoff["race_id"] == '2010010212'
        assert race_payoff["payoff_type"] == "place"
        assert race_payoff["horse_number"] == 7
        assert race_payoff["odds"] == 3.1
        assert race_payoff["favorite_order"] == 6

    def test_process_race_payoff_item_3(self):
        # Setup
        item = RacePayoffItem()
        item["race_id"] = ['2010010212']
        item["payoff_type"] = ['枠連']
        item["horse_number"] = ['3－5']
        item["odds"] = ['1,950円']
        item["favorite_order"] = ['9番人気']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_payoff")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        try:
            self.pipeline.process_item(item, None)

            assert False
        except DropItem:
            pass

        # Check db
        self.pipeline.db_cursor.execute("select * from race_payoff")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

    def test_process_race_result_item_1(self):
        # Setup
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

        # Before check
        self.pipeline.db_cursor.execute("select * from race_result")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
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

        # Check db
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_result_id"] == "2010010212_4"
        assert race_result["race_id"] == "2010010212"
        assert race_result["result"] == 1
        assert race_result["bracket_number"] == 3
        assert race_result["horse_number"] == 4
        assert race_result["horse_id"] == "2015104408"
        assert race_result["horse_weight"] == 442.0
        assert race_result["horse_weight_diff"] == -6.0
        assert race_result["arrival_time"] == 163.6
        assert race_result["jockey_id"] == "01143"
        assert race_result["jockey_weight"] == 57.0
        assert race_result["favorite_order"] == 7
        assert race_result["odds"] == 13.6
        assert race_result["trainer_id"] == "01132"

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_result_id"] == "2010010212_4"
        assert race_result["race_id"] == "2010010212"
        assert race_result["result"] == 1
        assert race_result["bracket_number"] == 3
        assert race_result["horse_number"] == 4
        assert race_result["horse_id"] == "2015104408"
        assert race_result["horse_weight"] == 442.0
        assert race_result["horse_weight_diff"] == -6.0
        assert race_result["arrival_time"] == 163.6
        assert race_result["jockey_id"] == "01143"
        assert race_result["jockey_weight"] == 57.0
        assert race_result["favorite_order"] == 7
        assert race_result["odds"] == 13.6
        assert race_result["trainer_id"] == "01132"

    def test_process_race_result_item_2(self):
        # Setup
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

        # Before check
        self.pipeline.db_cursor.execute("select * from race_result")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
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

        # Check db
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == "2010010212"
        assert race_result["result"] == 4
        assert race_result["bracket_number"] == 8
        assert race_result["horse_number"] == 13
        assert race_result["horse_id"] == "2015106286"
        assert race_result["horse_weight"] == 478.0
        assert race_result["horse_weight_diff"] == 10.0
        assert race_result["arrival_time"] == 164.9
        assert race_result["jockey_id"] == "01154"
        assert race_result["jockey_weight"] == 57.0
        assert race_result["favorite_order"] == 3
        assert race_result["odds"] == 6.9
        assert race_result["trainer_id"] == "01082"

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == "2010010212"
        assert race_result["result"] == 4
        assert race_result["bracket_number"] == 8
        assert race_result["horse_number"] == 13
        assert race_result["horse_id"] == "2015106286"
        assert race_result["horse_weight"] == 478.0
        assert race_result["horse_weight_diff"] == 10.0
        assert race_result["arrival_time"] == 164.9
        assert race_result["jockey_id"] == "01154"
        assert race_result["jockey_weight"] == 57.0
        assert race_result["favorite_order"] == 3
        assert race_result["odds"] == 6.9
        assert race_result["trainer_id"] == "01082"

    def test_process_race_result_item_3(self):
        # Setup
        item = RaceResultItem()
        item["arrival_time"] = ['\n1.12.2']
        item["bracket_number"] = ['2']
        item["favorite_order"] = ['\n5    ']
        item["horse_gender_age"] = ['\n牡3/466(+2)/    ']
        item["horse_id"] = ['/directory/horse/2017104069/']
        item["horse_name"] = ['メモワールミノル']
        item["horse_number"] = ['\n3  ']
        item["horse_weight_and_diff"] = ['\n牡3/466(+2)/    ']
        item["jockey_id"] = ['/directory/jocky/01179/']
        item["jockey_name"] = ['菅原 明良']
        item["jockey_weight"] = ['△54.0']
        item["odds"] = ['(8.3)']
        item["race_id"] = ['2006010201']
        item["result"] = ['\n1  ']
        item["trainer_id"] = ['/directory/trainer/01153/']
        item["trainer_name"] = ['中舘 英二']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_result")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '2006010201'
        assert new_item["result"] == 1
        assert new_item["bracket_number"] == 2
        assert new_item["horse_number"] == 3
        assert new_item["horse_id"] == '2017104069'
        assert new_item["horse_name"] == 'メモワールミノル'
        assert new_item["horse_gender"] == '牡'
        assert new_item["horse_age"] == 3
        assert new_item["horse_weight"] == 466.0
        assert new_item["horse_weight_diff"] == 2.0
        assert new_item["arrival_time"] == 72.2
        assert new_item["jockey_id"] == '01179'
        assert new_item["jockey_name"] == '菅原 明良'
        assert new_item["jockey_weight"] == 54.0
        assert new_item["favorite_order"] == 5
        assert new_item["odds"] == 8.3
        assert new_item["trainer_id"] == '01153'
        assert new_item["trainer_name"] == '中舘 英二'

        # Check db
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == '2006010201'
        assert race_result["result"] == 1
        assert race_result["bracket_number"] == 2
        assert race_result["horse_number"] == 3
        assert race_result["horse_id"] == '2017104069'
        assert race_result["horse_weight"] == 466.0
        assert race_result["horse_weight_diff"] == 2.0
        assert race_result["arrival_time"] == 72.2
        assert race_result["jockey_id"] == '01179'
        assert race_result["jockey_weight"] == 54.0
        assert race_result["favorite_order"] == 5
        assert race_result["odds"] == 8.3
        assert race_result["trainer_id"] == '01153'

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == '2006010201'
        assert race_result["result"] == 1
        assert race_result["bracket_number"] == 2
        assert race_result["horse_number"] == 3
        assert race_result["horse_id"] == '2017104069'
        assert race_result["horse_weight"] == 466.0
        assert race_result["horse_weight_diff"] == 2.0
        assert race_result["arrival_time"] == 72.2
        assert race_result["jockey_id"] == '01179'
        assert race_result["jockey_weight"] == 54.0
        assert race_result["favorite_order"] == 5
        assert race_result["odds"] == 8.3
        assert race_result["trainer_id"] == '01153'

    def test_process_race_result_item_4(self):
        # Setup
        item = RaceResultItem()
        item["arrival_time"] = ['\n1.12.4']
        item["bracket_number"] = ['3']
        item["favorite_order"] = ['\n9    ']
        item["horse_gender_age"] = ['\n牡3/460(+6)/    ']
        item["horse_id"] = ['/directory/horse/2017101489/']
        item["horse_name"] = ['ドラゴンズバック']
        item["horse_number"] = ['\n6  ']
        item["horse_weight_and_diff"] = ['\n牡3/460(+6)/    ']
        item["jockey_id"] = ['/directory/jocky/01164/']
        item["jockey_name"] = ['藤田 菜七子']
        item["jockey_weight"] = ['▲53.0']
        item["odds"] = ['(21.8)']
        item["race_id"] = ['2006010201']
        item["result"] = ['\n2  ']
        item["trainer_id"] = ['/directory/trainer/01031/']
        item["trainer_name"] = ['伊藤 伸一']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_result")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '2006010201'
        assert new_item["result"] == 2
        assert new_item["bracket_number"] == 3
        assert new_item["horse_number"] == 6
        assert new_item["horse_id"] == '2017101489'
        assert new_item["horse_name"] == 'ドラゴンズバック'
        assert new_item["horse_gender"] == '牡'
        assert new_item["horse_age"] == 3
        assert new_item["horse_weight"] == 460.0
        assert new_item["horse_weight_diff"] == 6.0
        assert new_item["arrival_time"] == 72.4
        assert new_item["jockey_id"] == '01164'
        assert new_item["jockey_name"] == '藤田 菜七子'
        assert new_item["jockey_weight"] == 53.0
        assert new_item["favorite_order"] == 9
        assert new_item["odds"] == 21.8
        assert new_item["trainer_id"] == '01031'
        assert new_item["trainer_name"] == '伊藤 伸一'

        # Check db
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == '2006010201'
        assert race_result["result"] == 2
        assert race_result["bracket_number"] == 3
        assert race_result["horse_number"] == 6
        assert race_result["horse_id"] == '2017101489'
        assert race_result["horse_weight"] == 460.0
        assert race_result["horse_weight_diff"] == 6.0
        assert race_result["arrival_time"] == 72.4
        assert race_result["jockey_id"] == '01164'
        assert race_result["jockey_weight"] == 53.0
        assert race_result["favorite_order"] == 9
        assert race_result["odds"] == 21.8
        assert race_result["trainer_id"] == '01031'

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == '2006010201'
        assert race_result["result"] == 2
        assert race_result["bracket_number"] == 3
        assert race_result["horse_number"] == 6
        assert race_result["horse_id"] == '2017101489'
        assert race_result["horse_weight"] == 460.0
        assert race_result["horse_weight_diff"] == 6.0
        assert race_result["arrival_time"] == 72.4
        assert race_result["jockey_id"] == '01164'
        assert race_result["jockey_weight"] == 53.0
        assert race_result["favorite_order"] == 9
        assert race_result["odds"] == 21.8
        assert race_result["trainer_id"] == '01031'

    def test_process_race_result_item_5(self):
        # Setup
        item = RaceResultItem()
        item["arrival_time"] = ['\n']
        item["bracket_number"] = ['2']
        item["favorite_order"] = ['\n     ']
        item["horse_gender_age"] = ['\n牝5/ - ( - )/    ']
        item["horse_id"] = ['/directory/horse/2015102358/']
        item["horse_name"] = ['イチザティアラ']
        item["horse_number"] = ['\n2  ']
        item["horse_weight_and_diff"] = ['\n牝5/ - ( - )/    ']
        item["jockey_id"] = ['/directory/jocky/00894/']
        item["jockey_name"] = ['小牧 太']
        item["jockey_weight"] = ['55.0']
        item["odds"] = ['( - )']
        item["race_id"] = ['2008010104']
        item["result"] = ['\n', '  ']
        item["trainer_id"] = ['/directory/trainer/01040/']
        item["trainer_name"] = ['服部 利之']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_result")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '2008010104'
        assert new_item["result"] is None
        assert new_item["bracket_number"] == 2
        assert new_item["horse_number"] == 2
        assert new_item["horse_id"] == '2015102358'
        assert new_item["horse_name"] == 'イチザティアラ'
        assert new_item["horse_gender"] == '牝'
        assert new_item["horse_age"] == 5
        assert new_item["horse_weight"] is None
        assert new_item["horse_weight_diff"] is None
        assert new_item["arrival_time"] is None
        assert new_item["jockey_id"] == '00894'
        assert new_item["jockey_name"] == '小牧 太'
        assert new_item["jockey_weight"] == 55.0
        assert new_item["favorite_order"] is None
        assert new_item["odds"] is None
        assert new_item["trainer_id"] == '01040'
        assert new_item["trainer_name"] == '服部 利之'

        # Check db
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == '2008010104'
        assert race_result["result"] is None
        assert race_result["bracket_number"] == 2
        assert race_result["horse_number"] == 2
        assert race_result["horse_id"] == '2015102358'
        assert race_result["horse_weight"] is None
        assert race_result["horse_weight_diff"] is None
        assert race_result["arrival_time"] is None
        assert race_result["jockey_id"] == '00894'
        assert race_result["jockey_weight"] == 55.0
        assert race_result["favorite_order"] is None
        assert race_result["odds"] is None
        assert race_result["trainer_id"] == '01040'

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_result")

        race_results = self.pipeline.db_cursor.fetchall()
        assert len(race_results) == 1

        race_result = race_results[0]
        assert race_result["race_id"] == '2008010104'
        assert race_result["result"] is None
        assert race_result["bracket_number"] == 2
        assert race_result["horse_number"] == 2
        assert race_result["horse_id"] == '2015102358'
        assert race_result["horse_weight"] is None
        assert race_result["horse_weight_diff"] is None
        assert race_result["arrival_time"] is None
        assert race_result["jockey_id"] == '00894'
        assert race_result["jockey_weight"] == 55.0
        assert race_result["favorite_order"] is None
        assert race_result["odds"] is None
        assert race_result["trainer_id"] == '01040'

    def test_process_race_denma_item_1(self):
        # Setup
        item = RaceDenmaItem()
        item["bracket_number"] = ['1']
        item["horse_id"] = ['/directory/horse/2017100081/']
        item["horse_number"] = ['2']
        item["horse_weight_and_diff"] = ['\n488(+12)\n']
        item["jockey_id"] = ['/directory/jocky/01077/']
        item["jockey_weight"] = ['55.0 ']
        item["prize_total_money"] = ['\n280万']
        item["race_id"] = ['1906050201']
        item["result_count_all_period"] = ['\n0.1.0.0']
        item["result_count_grade_race"] = ['\n0.0.0.0']
        item["trainer_id"] = ['/directory/trainer/01106/']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_denma")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '1906050201'
        assert new_item["bracket_number"] == 1
        assert new_item["horse_number"] == 2
        assert new_item["horse_id"] == '2017100081'
        assert new_item["trainer_id"] == '01106'
        assert new_item["horse_weight"] == 488.0
        assert new_item["horse_weight_diff"] == 12.0
        assert new_item["jockey_id"] == '01077'
        assert new_item["jockey_weight"] == 55.0
        assert new_item["result_1_count_all_period"] == 0
        assert new_item["result_2_count_all_period"] == 1
        assert new_item["result_3_count_all_period"] == 0
        assert new_item["result_4_count_all_period"] == 0
        assert new_item["result_1_count_grade_race"] == 0
        assert new_item["result_2_count_grade_race"] == 0
        assert new_item["result_3_count_grade_race"] == 0
        assert new_item["result_4_count_grade_race"] == 0
        assert new_item["prize_total_money"] == 280

        # Check db
        self.pipeline.db_cursor.execute("select * from race_denma")

        race_denmas = self.pipeline.db_cursor.fetchall()
        assert len(race_denmas) == 1

        race_denma = race_denmas[0]
        assert race_denma["race_denma_id"] == '1906050201_2'
        assert race_denma["race_id"] == '1906050201'
        assert race_denma["bracket_number"] == 1
        assert race_denma["horse_number"] == 2
        assert race_denma["horse_id"] == '2017100081'
        assert race_denma["trainer_id"] == '01106'
        assert race_denma["horse_weight"] == 488.0
        assert race_denma["horse_weight_diff"] == 12.0
        assert race_denma["jockey_id"] == '01077'
        assert race_denma["jockey_weight"] == 55.0
        assert race_denma["result_1_count_all_period"] == 0
        assert race_denma["result_2_count_all_period"] == 1
        assert race_denma["result_3_count_all_period"] == 0
        assert race_denma["result_4_count_all_period"] == 0
        assert race_denma["result_1_count_grade_race"] == 0
        assert race_denma["result_2_count_grade_race"] == 0
        assert race_denma["result_3_count_grade_race"] == 0
        assert race_denma["result_4_count_grade_race"] == 0
        assert race_denma["prize_total_money"] == 280

        # Execute (2)
        self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_denma")

        race_denmas = self.pipeline.db_cursor.fetchall()
        assert len(race_denmas) == 1

        race_denma = race_denmas[0]
        assert race_denma["race_denma_id"] == '1906050201_2'
        assert race_denma["race_id"] == '1906050201'
        assert race_denma["bracket_number"] == 1
        assert race_denma["horse_number"] == 2
        assert race_denma["horse_id"] == '2017100081'
        assert race_denma["trainer_id"] == '01106'
        assert race_denma["horse_weight"] == 488.0
        assert race_denma["horse_weight_diff"] == 12.0
        assert race_denma["jockey_id"] == '01077'
        assert race_denma["jockey_weight"] == 55.0
        assert race_denma["result_1_count_all_period"] == 0
        assert race_denma["result_2_count_all_period"] == 1
        assert race_denma["result_3_count_all_period"] == 0
        assert race_denma["result_4_count_all_period"] == 0
        assert race_denma["result_1_count_grade_race"] == 0
        assert race_denma["result_2_count_grade_race"] == 0
        assert race_denma["result_3_count_grade_race"] == 0
        assert race_denma["result_4_count_grade_race"] == 0
        assert race_denma["prize_total_money"] == 280

    def test_process_race_denma_item_2(self):
        # Setup
        item = RaceDenmaItem()
        item["bracket_number"] = ['2']
        item["horse_id"] = ['/directory/horse/2017109094/']
        item["horse_number"] = ['3']
        item["horse_weight_and_diff"] = ['\n436(+12)\n']
        item["jockey_id"] = ['/directory/jocky/01179/']
        item["jockey_weight"] = ['51.0 ▲']
        item["prize_total_money"] = ['\n355万']
        item["race_id"] = ['1906050201']
        item["result_count_all_period"] = ['\n0.1.0.2']
        item["result_count_grade_race"] = ['\n0.0.0.0']
        item["trainer_id"] = ['/directory/trainer/01147/']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_denma")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '1906050201'
        assert new_item["bracket_number"] == 2
        assert new_item["horse_number"] == 3
        assert new_item["horse_id"] == '2017109094'
        assert new_item["trainer_id"] == '01147'
        assert new_item["horse_weight"] == 436.0
        assert new_item["horse_weight_diff"] == 12.0
        assert new_item["jockey_id"] == '01179'
        assert new_item["jockey_weight"] == 51.0
        assert new_item["result_1_count_all_period"] == 0
        assert new_item["result_2_count_all_period"] == 1
        assert new_item["result_3_count_all_period"] == 0
        assert new_item["result_4_count_all_period"] == 2
        assert new_item["result_1_count_grade_race"] == 0
        assert new_item["result_2_count_grade_race"] == 0
        assert new_item["result_3_count_grade_race"] == 0
        assert new_item["result_4_count_grade_race"] == 0
        assert new_item["prize_total_money"] == 355

        # Check db
        self.pipeline.db_cursor.execute("select * from race_denma")

        race_denmas = self.pipeline.db_cursor.fetchall()
        assert len(race_denmas) == 1

        race_denma = race_denmas[0]
        assert race_denma["race_denma_id"] == '1906050201_3'
        assert race_denma["race_id"] == '1906050201'
        assert race_denma["bracket_number"] == 2
        assert race_denma["horse_number"] == 3
        assert race_denma["horse_id"] == '2017109094'
        assert race_denma["trainer_id"] == '01147'
        assert race_denma["horse_weight"] == 436.0
        assert race_denma["horse_weight_diff"] == 12.0
        assert race_denma["jockey_id"] == '01179'
        assert race_denma["jockey_weight"] == 51.0
        assert race_denma["result_1_count_all_period"] == 0
        assert race_denma["result_2_count_all_period"] == 1
        assert race_denma["result_3_count_all_period"] == 0
        assert race_denma["result_4_count_all_period"] == 2
        assert race_denma["result_1_count_grade_race"] == 0
        assert race_denma["result_2_count_grade_race"] == 0
        assert race_denma["result_3_count_grade_race"] == 0
        assert race_denma["result_4_count_grade_race"] == 0
        assert race_denma["prize_total_money"] == 355

        # Execute (2)
        self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_denma")

        race_denmas = self.pipeline.db_cursor.fetchall()
        assert len(race_denmas) == 1

        race_denma = race_denmas[0]
        assert race_denma["race_denma_id"] == '1906050201_3'
        assert race_denma["race_id"] == '1906050201'
        assert race_denma["bracket_number"] == 2
        assert race_denma["horse_number"] == 3
        assert race_denma["horse_id"] == '2017109094'
        assert race_denma["trainer_id"] == '01147'
        assert race_denma["horse_weight"] == 436.0
        assert race_denma["horse_weight_diff"] == 12.0
        assert race_denma["jockey_id"] == '01179'
        assert race_denma["jockey_weight"] == 51.0
        assert race_denma["result_1_count_all_period"] == 0
        assert race_denma["result_2_count_all_period"] == 1
        assert race_denma["result_3_count_all_period"] == 0
        assert race_denma["result_4_count_all_period"] == 2
        assert race_denma["result_1_count_grade_race"] == 0
        assert race_denma["result_2_count_grade_race"] == 0
        assert race_denma["result_3_count_grade_race"] == 0
        assert race_denma["result_4_count_grade_race"] == 0
        assert race_denma["prize_total_money"] == 355

    def test_process_race_denma_item_3(self):
        # Setup
        item = RaceDenmaItem()
        item["bracket_number"] = ['3']
        item["horse_id"] = ['/directory/horse/2014106160/']
        item["horse_number"] = ['3']
        item["horse_weight_and_diff"] = ['\n482(+6)\n']
        item["jockey_id"] = ['/directory/jocky/00660/']
        item["jockey_weight"] = ['56.0 ']
        item["prize_total_money"] = ['\n2億4247万']
        item["race_id"] = ['2006010911']
        item["result_count_all_period"] = ['\n4.3.2.8']
        item["result_count_grade_race"] = ['\n2.3.1.7']
        item["trainer_id"] = ['/directory/trainer/01115/']

        # Before check
        self.pipeline.db_cursor.execute("select * from race_denma")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["race_id"] == '2006010911'
        assert new_item["bracket_number"] == 3
        assert new_item["horse_number"] == 3
        assert new_item["horse_id"] == '2014106160'
        assert new_item["trainer_id"] == '01115'
        assert new_item["horse_weight"] == 482.0
        assert new_item["horse_weight_diff"] == 6.0
        assert new_item["jockey_id"] == '00660'
        assert new_item["jockey_weight"] == 56.0
        assert new_item["result_1_count_all_period"] == 4
        assert new_item["result_2_count_all_period"] == 3
        assert new_item["result_3_count_all_period"] == 2
        assert new_item["result_4_count_all_period"] == 8
        assert new_item["result_1_count_grade_race"] == 2
        assert new_item["result_2_count_grade_race"] == 3
        assert new_item["result_3_count_grade_race"] == 1
        assert new_item["result_4_count_grade_race"] == 7
        assert new_item["prize_total_money"] == 24247

        # Check db
        self.pipeline.db_cursor.execute("select * from race_denma")

        race_denmas = self.pipeline.db_cursor.fetchall()
        assert len(race_denmas) == 1

        race_denma = race_denmas[0]
        assert race_denma["race_denma_id"] == '2006010911_3'
        assert race_denma["race_id"] == '2006010911'
        assert race_denma["bracket_number"] == 3
        assert race_denma["horse_number"] == 3
        assert race_denma["horse_id"] == '2014106160'
        assert race_denma["trainer_id"] == '01115'
        assert race_denma["horse_weight"] == 482.0
        assert race_denma["horse_weight_diff"] == 6.0
        assert race_denma["jockey_id"] == '00660'
        assert race_denma["jockey_weight"] == 56.0
        assert race_denma["result_1_count_all_period"] == 4
        assert race_denma["result_2_count_all_period"] == 3
        assert race_denma["result_3_count_all_period"] == 2
        assert race_denma["result_4_count_all_period"] == 8
        assert race_denma["result_1_count_grade_race"] == 2
        assert race_denma["result_2_count_grade_race"] == 3
        assert race_denma["result_3_count_grade_race"] == 1
        assert race_denma["result_4_count_grade_race"] == 7
        assert race_denma["prize_total_money"] == 24247

        # Execute (2)
        self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from race_denma")

        race_denmas = self.pipeline.db_cursor.fetchall()
        assert len(race_denmas) == 1

        race_denma = race_denmas[0]
        assert race_denma["race_denma_id"] == '2006010911_3'
        assert race_denma["race_id"] == '2006010911'
        assert race_denma["bracket_number"] == 3
        assert race_denma["horse_number"] == 3
        assert race_denma["horse_id"] == '2014106160'
        assert race_denma["trainer_id"] == '01115'
        assert race_denma["horse_weight"] == 482.0
        assert race_denma["horse_weight_diff"] == 6.0
        assert race_denma["jockey_id"] == '00660'
        assert race_denma["jockey_weight"] == 56.0
        assert race_denma["result_1_count_all_period"] == 4
        assert race_denma["result_2_count_all_period"] == 3
        assert race_denma["result_3_count_all_period"] == 2
        assert race_denma["result_4_count_all_period"] == 8
        assert race_denma["result_1_count_grade_race"] == 2
        assert race_denma["result_2_count_grade_race"] == 3
        assert race_denma["result_3_count_grade_race"] == 1
        assert race_denma["result_4_count_grade_race"] == 7
        assert race_denma["prize_total_money"] == 24247

    def test_process_horse_item_1(self):
        # Setup
        item = HorseItem()
        item["horse_id"] = ['2017101602']
        item["gender"] = [' 牡 | 登録抹消 ']
        item["name"] = ['エリンクロノス']
        item["birthday"] = ['2017年3月31日']
        item["coat_color"] = ['栗毛']
        item["trainer_id"] = ['/directory/trainer/01012/']
        item["owner"] = ['田頭 勇貴']
        item["breeder"] = ['大栄牧場']
        item["breeding_farm"] = ['新冠町']

        # Before check
        self.pipeline.db_cursor.execute("select * from horse")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["horse_id"] == "2017101602"
        assert new_item["gender"] == "牡"
        assert new_item["name"] == "エリンクロノス"
        assert new_item["birthday"] == datetime(2017, 3, 31, 0, 0, 0)
        assert new_item["coat_color"] == "栗毛"
        assert new_item["trainer_id"] == "01012"
        assert new_item["owner"] == "田頭 勇貴"
        assert new_item["breeder"] == "大栄牧場"
        assert new_item["breeding_farm"] == "新冠町"

        # Check db
        self.pipeline.db_cursor.execute("select * from horse")

        horses = self.pipeline.db_cursor.fetchall()
        assert len(horses) == 1

        horse = horses[0]
        assert horse["horse_id"] == "2017101602"
        assert horse["gender"] == "牡"
        assert horse["name"] == "エリンクロノス"
        assert horse["birthday"] == datetime(2017, 3, 31, 0, 0, 0)
        assert horse["coat_color"] == "栗毛"
        assert horse["trainer_id"] == "01012"
        assert horse["owner"] == "田頭 勇貴"
        assert horse["breeder"] == "大栄牧場"
        assert horse["breeding_farm"] == "新冠町"

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from horse")

        horses = self.pipeline.db_cursor.fetchall()
        assert len(horses) == 1

        horse = horses[0]
        assert horse["horse_id"] == "2017101602"
        assert horse["gender"] == "牡"
        assert horse["name"] == "エリンクロノス"
        assert horse["birthday"] == datetime(2017, 3, 31, 0, 0, 0)
        assert horse["coat_color"] == "栗毛"
        assert horse["trainer_id"] == "01012"
        assert horse["owner"] == "田頭 勇貴"
        assert horse["breeder"] == "大栄牧場"
        assert horse["breeding_farm"] == "新冠町"

    def test_process_horse_item_2(self):
        # Setup
        item = HorseItem()
        item["birthday"] = ['2015年2月24日']
        item["breeder"] = ['三嶋牧場']
        item["breeding_farm"] = ['浦河町']
        item["coat_color"] = ['鹿毛']
        item["gender"] = ['（地） | 牡 | 登録抹消 ']
        item["horse_id"] = ['2015103355']
        item["name"] = ['ネクストステップ']
        item["owner"] = ['吉澤 克己']
        item["trainer_id"] = ['/directory/trainer/01002/']

        # Before check
        self.pipeline.db_cursor.execute("select * from horse")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["horse_id"] == '2015103355'
        assert new_item["gender"] == '牡'
        assert new_item["name"] == 'ネクストステップ'
        assert new_item["birthday"] == datetime(2015, 2, 24, 0, 0, 0)
        assert new_item["coat_color"] == '鹿毛'
        assert new_item["trainer_id"] == '01002'
        assert new_item["owner"] == '吉澤 克己'
        assert new_item["breeder"] == '三嶋牧場'
        assert new_item["breeding_farm"] == '浦河町'

        # Check db
        self.pipeline.db_cursor.execute("select * from horse")

        horses = self.pipeline.db_cursor.fetchall()
        assert len(horses) == 1

        horse = horses[0]
        assert horse["horse_id"] == '2015103355'
        assert horse["gender"] == '牡'
        assert horse["name"] == 'ネクストステップ'
        assert horse["birthday"] == datetime(2015, 2, 24, 0, 0, 0)
        assert horse["coat_color"] == '鹿毛'
        assert horse["trainer_id"] == '01002'
        assert horse["owner"] == '吉澤 克己'
        assert horse["breeder"] == '三嶋牧場'
        assert horse["breeding_farm"] == '浦河町'

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from horse")

        horses = self.pipeline.db_cursor.fetchall()
        assert len(horses) == 1

        horse = horses[0]
        assert horse["horse_id"] == '2015103355'
        assert horse["gender"] == '牡'
        assert horse["name"] == 'ネクストステップ'
        assert horse["birthday"] == datetime(2015, 2, 24, 0, 0, 0)
        assert horse["coat_color"] == '鹿毛'
        assert horse["trainer_id"] == '01002'
        assert horse["owner"] == '吉澤 克己'
        assert horse["breeder"] == '三嶋牧場'
        assert horse["breeding_farm"] == '浦河町'

    def test_process_horse_item_3(self):
        # Setup
        item = HorseItem()
        item["birthday"] = ['2015年2月28日']
        item["breeder"] = ['Lansdowne Thoroughbreds, LLC']
        item["breeding_farm"] = ['米']
        item["coat_color"] = ['芦毛']
        item["gender"] = ['（外）（地） | 牝 | 登録抹消 ']
        item["horse_id"] = ['2015110026']
        item["name"] = ['マッチョベリー']
        item["owner"] = ['栗山 良子']
        item["trainer_id"] = ['/directory/trainer/01010/']

        # Before check
        self.pipeline.db_cursor.execute("select * from horse")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["horse_id"] == '2015110026'
        assert new_item["gender"] == '牝'
        assert new_item["name"] == 'マッチョベリー'
        assert new_item["birthday"] == datetime(2015, 2, 28, 0, 0, 0)
        assert new_item["coat_color"] == '芦毛'
        assert new_item["trainer_id"] == '01010'
        assert new_item["owner"] == '栗山 良子'
        assert new_item["breeder"] == 'Lansdowne Thoroughbreds, LLC'
        assert new_item["breeding_farm"] == '米'

        # Check db
        self.pipeline.db_cursor.execute("select * from horse")

        horses = self.pipeline.db_cursor.fetchall()
        assert len(horses) == 1

        horse = horses[0]
        assert horse["horse_id"] == '2015110026'
        assert horse["gender"] == '牝'
        assert horse["name"] == 'マッチョベリー'
        assert horse["birthday"] == datetime(2015, 2, 28, 0, 0, 0)
        assert horse["coat_color"] == '芦毛'
        assert horse["trainer_id"] == '01010'
        assert horse["owner"] == '栗山 良子'
        assert horse["breeder"] == 'Lansdowne Thoroughbreds, LLC'
        assert horse["breeding_farm"] == '米'

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from horse")

        horses = self.pipeline.db_cursor.fetchall()
        assert len(horses) == 1

        horse = horses[0]
        assert horse["horse_id"] == '2015110026'
        assert horse["gender"] == '牝'
        assert horse["name"] == 'マッチョベリー'
        assert horse["birthday"] == datetime(2015, 2, 28, 0, 0, 0)
        assert horse["coat_color"] == '芦毛'
        assert horse["trainer_id"] == '01010'
        assert horse["owner"] == '栗山 良子'
        assert horse["breeder"] == 'Lansdowne Thoroughbreds, LLC'
        assert horse["breeding_farm"] == '米'

    def test_process_trainer_item(self):
        # Setup
        item = TrainerItem()
        item["trainer_id"] = ['01012']
        item["name_kana"] = ['オオエハラ サトシ ']
        item["name"] = ['大江原 哲']
        item["birthday"] = ['1953年2月13日']
        item["belong_to"] = ['\n美浦']
        item["first_licensing_year"] = ['1996年']

        # Before check
        self.pipeline.db_cursor.execute("select * from trainer")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["trainer_id"] == "01012"
        assert new_item["name_kana"] == "オオエハラ サトシ"
        assert new_item["name"] == "大江原 哲"
        assert new_item["birthday"] == datetime(1953, 2, 13, 0, 0, 0)
        assert new_item["belong_to"] == "美浦"
        assert new_item["first_licensing_year"] == 1996

        # Check db
        self.pipeline.db_cursor.execute("select * from trainer")

        trainers = self.pipeline.db_cursor.fetchall()
        assert len(trainers) == 1

        trainer = trainers[0]
        assert trainer["trainer_id"] == "01012"
        assert trainer["name_kana"] == "オオエハラ サトシ"
        assert trainer["name"] == "大江原 哲"
        assert trainer["birthday"] == datetime(1953, 2, 13, 0, 0, 0)
        assert trainer["belong_to"] == "美浦"
        assert trainer["first_licensing_year"] == 1996

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from trainer")

        trainers = self.pipeline.db_cursor.fetchall()
        assert len(trainers) == 1

        trainer = trainers[0]
        assert trainer["trainer_id"] == "01012"
        assert trainer["name_kana"] == "オオエハラ サトシ"
        assert trainer["name"] == "大江原 哲"
        assert trainer["birthday"] == datetime(1953, 2, 13, 0, 0, 0)
        assert trainer["belong_to"] == "美浦"
        assert trainer["first_licensing_year"] == 1996

    def test_process_jockey_item(self):
        # Setup
        item = JockeyItem()
        item["jockey_id"] = ['01167']
        item["name_kana"] = ['コワタ イクヤ ']
        item["name"] = ['木幡 育也']
        item["birthday"] = ['1998年9月21日']
        item["belong_to"] = ['\n美浦(藤沢 和雄)']
        item["first_licensing_year"] = ['2017年（平地・障害）']

        # Before check
        self.pipeline.db_cursor.execute("select * from jockey")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check return
        assert new_item["jockey_id"] == "01167"
        assert new_item["name_kana"] == "コワタ イクヤ"
        assert new_item["name"] == "木幡 育也"
        assert new_item["birthday"] == datetime(1998, 9, 21, 0, 0, 0)
        assert new_item["belong_to"] == "美浦(藤沢 和雄)"
        assert new_item["first_licensing_year"] == 2017

        # Check db
        self.pipeline.db_cursor.execute("select * from jockey")

        jockeys = self.pipeline.db_cursor.fetchall()
        assert len(jockeys) == 1

        jockey = jockeys[0]
        assert jockey["jockey_id"] == "01167"
        assert jockey["name_kana"] == "コワタ イクヤ"
        assert jockey["name"] == "木幡 育也"
        assert jockey["birthday"] == datetime(1998, 9, 21, 0, 0, 0)
        assert jockey["belong_to"] == "美浦(藤沢 和雄)"
        assert jockey["first_licensing_year"] == 2017

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from jockey")

        jockeys = self.pipeline.db_cursor.fetchall()
        assert len(jockeys) == 1

        jockey = jockeys[0]
        assert jockey["jockey_id"] == "01167"
        assert jockey["name_kana"] == "コワタ イクヤ"
        assert jockey["name"] == "木幡 育也"
        assert jockey["birthday"] == datetime(1998, 9, 21, 0, 0, 0)
        assert jockey["belong_to"] == "美浦(藤沢 和雄)"
        assert jockey["first_licensing_year"] == 2017

    def test_process_odds_win_place_item_1(self):
        # Setup
        item = OddsWinPlaceItem()
        item["race_id"] = ['1906050201']
        item["horse_number"] = ['1']
        item["horse_id"] = ['/directory/horse/2017101602/']
        item["odds_win"] = ['161.2']
        item["odds_place_min"] = ['26.0']
        item["odds_place_max"] = ['43.8']

        # Before check
        self.pipeline.db_cursor.execute("select * from odds_win")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        self.pipeline.db_cursor.execute("select * from odds_place")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        new_item = self.pipeline.process_item(item, None)

        # Check result
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

        # Check db
        self.pipeline.db_cursor.execute("select * from odds_win")

        odds_wins = self.pipeline.db_cursor.fetchall()
        assert len(odds_wins) == 1

        odds_win = odds_wins[0]
        assert odds_win["odds_win_id"] == "1906050201_1"
        assert odds_win["race_id"] == "1906050201"
        assert odds_win["horse_number"] == 1
        assert odds_win["horse_id"] == "2017101602"
        assert odds_win["odds"] == 161.2

        self.pipeline.db_cursor.execute("select * from odds_place")

        odds_places = self.pipeline.db_cursor.fetchall()
        assert len(odds_places) == 1

        odds_place = odds_places[0]
        assert odds_place["odds_place_id"] == "1906050201_1"
        assert odds_place["race_id"] == "1906050201"
        assert odds_place["horse_number"] == 1
        assert odds_place["horse_id"] == "2017101602"
        assert odds_place["odds_min"] == 26.0
        assert odds_place["odds_max"] == 43.8

        # Execute (2)
        new_item = self.pipeline.process_item(item, None)

        # Check db (2)
        self.pipeline.db_cursor.execute("select * from odds_win")

        odds_wins = self.pipeline.db_cursor.fetchall()
        assert len(odds_wins) == 1

        odds_win = odds_wins[0]
        assert odds_win["odds_win_id"] == "1906050201_1"
        assert odds_win["race_id"] == "1906050201"
        assert odds_win["horse_number"] == 1
        assert odds_win["horse_id"] == "2017101602"
        assert odds_win["odds"] == 161.2

        self.pipeline.db_cursor.execute("select * from odds_place")

        odds_places = self.pipeline.db_cursor.fetchall()
        assert len(odds_places) == 1

        odds_place = odds_places[0]
        assert odds_place["odds_place_id"] == "1906050201_1"
        assert odds_place["race_id"] == "1906050201"
        assert odds_place["horse_number"] == 1
        assert odds_place["horse_id"] == "2017101602"
        assert odds_place["odds_min"] == 26.0
        assert odds_place["odds_max"] == 43.8

    def test_process_odds_win_place_item_2(self):
        # Setup
        item = OddsWinPlaceItem()
        item["horse_id"] = ['/directory/horse/2014105805/']
        item["horse_number"] = ['4']
        item["odds_place_max"] = ['****']
        item["odds_place_min"] = ['****']
        item["odds_win"] = ['****']
        item["race_id"] = ['2008010212']

        # Before check
        self.pipeline.db_cursor.execute("select * from odds_win")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        self.pipeline.db_cursor.execute("select * from odds_place")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        # Execute
        try:
            self.pipeline.process_item(item, None)

            assert False
        except DropItem:
            pass

        # Check db
        self.pipeline.db_cursor.execute("select * from odds_win")
        assert len(self.pipeline.db_cursor.fetchall()) == 0

        self.pipeline.db_cursor.execute("select * from odds_place")
        assert len(self.pipeline.db_cursor.fetchall()) == 0
