# -*- coding: utf-8 -*-


from datetime import datetime
import psycopg2
from psycopg2.extras import DictCursor
import re
from scrapy.exceptions import DropItem

from investment_horse_racing_crawler.app_logging import get_logger
from investment_horse_racing_crawler.scrapy.items import RaceInfoItem, RacePayoffItem, RaceResultItem, RaceDenmaItem, HorseItem, TrainerItem, JockeyItem, OddsWinPlaceItem


logger = get_logger(__name__)


class PostgreSQLPipeline(object):
    def __init__(self, db_host, db_port, db_database, db_username, db_password):
        logger.debug("#init: start: db_host=%s, db_port=%s, db_database=%s, db_username=%s" % (db_host, db_port, db_database, db_username))

        self.db_host = db_host
        self.db_port = db_port
        self.db_database = db_database
        self.db_username = db_username
        self.db_password = db_password

    @classmethod
    def from_crawler(cls, crawler):
        logger.debug("#from_crawler")

        return cls(
            db_host=crawler.settings.get("DB_HOST"),
            db_port=crawler.settings.get("DB_PORT"),
            db_database=crawler.settings.get("DB_DATABASE"),
            db_username=crawler.settings.get("DB_USERNAME"),
            db_password=crawler.settings.get("DB_PASSWORD")
        )

    def open_spider(self, spider):
        logger.debug("#open_spider: start: spider=%s" % spider)

        self.db_conn = psycopg2.connect(
            host=self.db_host,
            port=self.db_port,
            dbname=self.db_database,
            user=self.db_username,
            password=self.db_password
        )
        self.db_conn.autocommit = False
        self.db_conn.set_client_encoding("utf-8")
        self.db_conn.cursor_factory = DictCursor
        self.db_cursor = self.db_conn.cursor()

        logger.debug("#open_spider: database connected")

    def close_spider(self, spider):
        logger.debug("#close_spider: start")

        self.db_cursor.close()
        self.db_conn.close()

        logger.debug("#close_spider: database disconnected")

    def process_item(self, item, spider):
        logger.debug("#process_item: start: item=%s" % item)

        if isinstance(item, RaceInfoItem):
            new_item = self.process_race_info_item(item, spider)
        elif isinstance(item, RacePayoffItem):
            new_item = self.process_race_payoff_item(item, spider)
        elif isinstance(item, RaceResultItem):
            new_item = self.process_race_result_item(item, spider)
        elif isinstance(item, RaceDenmaItem):
            new_item = self.process_race_denma_item(item, spider)
        elif isinstance(item, HorseItem):
            new_item = self.process_horse_item(item, spider)
        elif isinstance(item, TrainerItem):
            new_item = self.process_trainer_item(item, spider)
        elif isinstance(item, JockeyItem):
            new_item = self.process_jockey_item(item, spider)
        elif isinstance(item, OddsWinPlaceItem):
            new_item = self.process_odds_item(item, spider)
        else:
            raise DropItem("Unknown item type")

        self.db_cursor.execute("select 1")
        results = self.db_cursor.fetchall()

        logger.debug("#process_item: database results=%s" % results)

        return new_item

    def process_race_info_item(self, item, spider):
        logger.debug("#process_race_info_item: start: item=%s" % item)

        # Build item
        i = {}

        i["race_id"] = item["race_id"][0]

        race_round_reg = re.match("^([0-9]+)R$", item["race_round"][0].strip())
        if race_round_reg:
            i["race_round"] = int(race_round_reg.group(1))
        else:
            raise DropItem("Unknown pattern race_round")

        start_date_reg = re.match("^([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日", item["start_date"][0].strip())
        start_time_reg = re.match("^([0-9]+):([0-9]+)発走$", item["start_time"][0].strip())
        if start_date_reg and start_time_reg:
            i["start_datetime"] = datetime(int(start_date_reg.group(1)), int(start_date_reg.group(2)), int(start_date_reg.group(3)), int(start_time_reg.group(1)), int(start_time_reg.group(2)), 0)
        else:
            raise DropItem("Unknown pattern start_date, start_time")

        i["place_name"] = item["place_name"][0].strip()

        i["race_name"] = item["race_name"][0].strip()

        course_type_length_reg = re.match("^(.+?) ([0-9]+)m$", item["course_type_length"][0].strip())
        if course_type_length_reg:
            i["course_type"] = course_type_length_reg.group(1)
            i["course_length"] = int(course_type_length_reg.group(2))
        else:
            raise DropItem("Unknown pattern course_type_length")

        i["weather"] = item["weather"][0].strip()

        i["course_condition"] = item["course_condition"][0].strip()

        i["added_money"] = item["added_money"][0].strip()

        # Insert db
        self.db_cursor.execute("delete from race_info where race_id=%s", (i["race_id"],))
        self.db_cursor.execute("insert into race_info (race_id, race_round, start_datetime, place_name, race_name, course_type, course_length, weather, course_condition, added_money) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (i["race_id"], i["race_round"], i["start_datetime"], i["place_name"], i["race_name"], i["course_type"], i["course_length"], i["weather"], i["course_condition"], i["added_money"]))
        self.db_conn.commit()

        return i

    def process_race_payoff_item(self, item, spider):
        logger.debug("#process_race_payoff_item: start: item=%s" % item)

        # Build item
        i = {}

        i["race_id"] = item["race_id"][0]

        if item["payoff_type"][0] == "単勝":
            i["payoff_type"] = "win"
        elif item["payoff_type"][0] == "複勝":
            i["payoff_type"] = "place"
        elif item["payoff_type"][0] == "枠連":
            i["payoff_type"] = "bracket_quinella"
        elif item["payoff_type"][0] == "馬連":
            i["payoff_type"] = "quinella"
        elif item["payoff_type"][0] == "ワイド":
            i["payoff_type"] = "quinella_place"
        elif item["payoff_type"][0] == "馬単":
            i["payoff_type"] = "exacta"
        elif item["payoff_type"][0] == "3連複":
            i["payoff_type"] = "trio"
        elif item["payoff_type"][0] == "3連単":
            i["payoff_type"] = "trifecta"
        else:
            raise DropItem("Unknown payoff_type")

        if "horse_number" in item:
            horse_number_parts = item["horse_number"][0].split("－")

            if len(horse_number_parts) == 1:
                i["horse_number_1"] = int(horse_number_parts[0])
                i["horse_number_2"] = None
                i["horse_number_3"] = None
            elif len(horse_number_parts) == 2:
                i["horse_number_1"] = int(horse_number_parts[0])
                i["horse_number_2"] = int(horse_number_parts[1])
                i["horse_number_3"] = None
            elif len(horse_number_parts) == 3:
                i["horse_number_1"] = int(horse_number_parts[0])
                i["horse_number_2"] = int(horse_number_parts[1])
                i["horse_number_3"] = int(horse_number_parts[2])
            else:
                raise DropItem("Unknown horse_number")
        else:
            raise DropItem("Empty race payoff record")

        i["odds"] = int(item["odds"][0].replace("円", "").replace(",", ""))/100.0

        favorite_order_str = item["favorite_order"][0].replace("番人気", "").strip()
        if favorite_order_str != "-":
            i["favorite_order"] = int(favorite_order_str)
        else:
            i["favorite_order"] = None

        # Insert db
        if i["horse_number_3"] is not None:
            race_payoff_id = "{}_{}_{}_{}_{}".format(i["race_id"], i["payoff_type"], i["horse_number_1"], i["horse_number_2"], i["horse_number_3"])
        elif i["horse_number_2"] is not None:
            race_payoff_id = "{}_{}_{}_{}".format(i["race_id"], i["payoff_type"], i["horse_number_1"], i["horse_number_2"])
        else:
            race_payoff_id = "{}_{}_{}".format(i["race_id"], i["payoff_type"], i["horse_number_1"])

        self.db_cursor.execute("delete from race_payoff where race_payoff_id=%s", (race_payoff_id,))
        self.db_cursor.execute("insert into race_payoff (race_payoff_id, race_id, payoff_type, horse_number_1, horse_number_2, horse_number_3, odds, favorite_order) values (%s, %s, %s, %s, %s, %s, %s, %s)", (race_payoff_id, i["race_id"], i["payoff_type"], i["horse_number_1"], i["horse_number_2"], i["horse_number_3"], i["odds"], i["favorite_order"]))
        self.db_conn.commit()

        return i

    def process_race_result_item(self, item, spider):
        logger.debug("#process_race_result_item: start: item=%s" % item)

        # Build item
        i = {}

        i["race_id"] = item["race_id"][0]

        result_str = item["result"][0].strip()
        if len(result_str) > 0:
            i["result"] = int(result_str)
        else:
            i["result"] = None

        i["bracket_number"] = int(item["bracket_number"][0].strip())

        i["horse_number"] = int(item["horse_number"][0].strip())

        i["horse_id"] = item["horse_id"][0].split("/")[-2]

        i["horse_name"] = item["horse_name"][0].strip()

        horse_gender_age_reg = re.match("^([^0-9]+)([0-9]+)$", item["horse_gender_age"][0].strip().split("/")[0])
        if horse_gender_age_reg:
            i["horse_gender"] = horse_gender_age_reg.group(1)
            i["horse_age"] = int(horse_gender_age_reg.group(2))
        else:
            raise DropItem("Unknown horse_gender_age")

        horse_weight_and_diff_reg = re.match("^([\\- 0-9]+)\\(([\\+\\- 0-9]+)\\)$", item["horse_weight_and_diff"][0].strip().split("/")[1])
        if horse_weight_and_diff_reg:
            horse_weight_str = horse_weight_and_diff_reg.group(1).strip()
            if horse_weight_str != "-":
                i["horse_weight"] = float(horse_weight_str)
            else:
                i["horse_weight"] = None

            horse_weight_diff_str = horse_weight_and_diff_reg.group(2).strip()
            if horse_weight_diff_str != "-":
                i["horse_weight_diff"] = float(horse_weight_diff_str)
            else:
                i["horse_weight_diff"] = None
        else:
            raise DropItem("Unknown horse_weight_and_diff")

        arrival_time_str = item["arrival_time"][0].strip()
        if len(arrival_time_str) > 0:
            arrival_time_parts = arrival_time_str.split(".")
            if len(arrival_time_parts) == 2:
                i["arrival_time"] = int(arrival_time_parts[0]) + int(arrival_time_parts[1]) * 0.1
            else:
                i["arrival_time"] = int(arrival_time_parts[0]) * 60.0 + int(arrival_time_parts[1]) + int(arrival_time_parts[2]) * 0.1
        else:
            i["arrival_time"] = None

        i["jockey_id"] = item["jockey_id"][0].split("/")[-2]

        i["jockey_name"] = item["jockey_name"][0].strip()

        jockey_weight_reg = re.match("^[^0-9]?([\\.0-9]+)$", item["jockey_weight"][0].strip())
        if jockey_weight_reg:
            i["jockey_weight"] = float(jockey_weight_reg.group(1))
        else:
            raise DropItem("Unknown jockey_weight pattern")

        favorite_order_str = item["favorite_order"][0].strip()
        if len(favorite_order_str) > 0:
            i["favorite_order"] = int(favorite_order_str)
        else:
            i["favorite_order"] = None

        if "odds" in item:
            odds_reg = re.match("^\\(([\\.\\- 0-9]+)\\)$", item["odds"][0].strip())
            if odds_reg:
                odds_str = odds_reg.group(1).strip()
                if odds_str != "-":
                    i["odds"] = float(odds_str)
                else:
                    i["odds"] = None
            else:
                raise DropItem("Unknown odds pattern")
        else:
            i["odds"] = None

        i["trainer_id"] = item["trainer_id"][0].split("/")[-2]

        i["trainer_name"] = item["trainer_name"][0].strip()

        # Insert db
        race_result_id = "{}_{}".format(i["race_id"], i["horse_number"])

        self.db_cursor.execute("delete from race_result where race_result_id=%s", (race_result_id,))
        self.db_cursor.execute("insert into race_result (race_result_id, race_id, result, bracket_number, horse_number, horse_id, horse_weight, horse_weight_diff, arrival_time, jockey_id, jockey_weight, favorite_order, odds, trainer_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (race_result_id, i["race_id"], i["result"], i["bracket_number"], i["horse_number"], i["horse_id"], i["horse_weight"], i["horse_weight_diff"], i["arrival_time"], i["jockey_id"], i["jockey_weight"], i["favorite_order"], i["odds"], i["trainer_id"]))
        self.db_conn.commit()

        return i

    def process_race_denma_item(self, item, spider):
        logger.debug("#process_race_denma_item: start: item=%s" % item)

        # Build item
        i = {}

        i["race_id"] = item["race_id"][0]

        bracket_number_str = item["bracket_number"][0].strip()
        if bracket_number_str != "-":
            i["bracket_number"] = int(bracket_number_str)
        else:
            i["bracket_number"] = None

        horse_number_str = item["horse_number"][0].strip()
        if horse_number_str != "-":
            i["horse_number"] = int(horse_number_str)
        else:
            i["horse_number"] = None

        i["horse_id"] = item["horse_id"][0].split("/")[-2]

        if "trainer_id" in item:
            i["trainer_id"] = item["trainer_id"][0].split("/")[-2]
        else:
            i["trainer_id"] = None

        horse_weight_and_diff_reg = re.match("^([\\- 0-9]+)\\(([\\+\\- 0-9]+)\\)$", item["horse_weight_and_diff"][0].strip())
        if horse_weight_and_diff_reg:
            horse_weight_str = horse_weight_and_diff_reg.group(1).strip()
            if horse_weight_str != "-":
                i["horse_weight"] = float(horse_weight_str)
            else:
                i["horse_weight"] = None

            horse_weight_diff_str = horse_weight_and_diff_reg.group(2).strip()
            if horse_weight_diff_str != "-":
                i["horse_weight_diff"] = float(horse_weight_diff_str)
            else:
                i["horse_weight_diff"] = None
        else:
            raise DropItem("Unknown horse_weight_and_diff")

        i["jockey_id"] = item["jockey_id"][0].split("/")[-2]

        jockey_weight_reg = re.match("^([\\.0-9]+)[^0-9]*$", item["jockey_weight"][0].strip())
        if jockey_weight_reg:
            i["jockey_weight"] = float(jockey_weight_reg.group(1))
        else:
            raise DropItem("Unknown jockey_weight pattern")

        result_count_all_period_parts = item["result_count_all_period"][0].strip().split(".")
        i["result_1_count_all_period"] = int(result_count_all_period_parts[0])
        i["result_2_count_all_period"] = int(result_count_all_period_parts[1])
        i["result_3_count_all_period"] = int(result_count_all_period_parts[2])
        i["result_4_count_all_period"] = int(result_count_all_period_parts[3])

        result_count_grade_race_parts = item["result_count_grade_race"][0].strip().split(".")
        i["result_1_count_grade_race"] = int(result_count_grade_race_parts[0])
        i["result_2_count_grade_race"] = int(result_count_grade_race_parts[1])
        i["result_3_count_grade_race"] = int(result_count_grade_race_parts[2])
        i["result_4_count_grade_race"] = int(result_count_grade_race_parts[3])

        i["prize_total_money"] = float(item["prize_total_money"][0].strip().replace("億", "").replace("万", ""))

        # Insert db
        race_denma_id = "{}_{}".format(i["race_id"], i["horse_id"])

        self.db_cursor.execute("delete from race_denma where race_denma_id=%s", (race_denma_id,))
        self.db_cursor.execute("insert into race_denma (race_denma_id, race_id, bracket_number, horse_number, horse_id, trainer_id, horse_weight, horse_weight_diff, jockey_id, jockey_weight, result_1_count_all_period, result_2_count_all_period, result_3_count_all_period, result_4_count_all_period, result_1_count_grade_race, result_2_count_grade_race, result_3_count_grade_race, result_4_count_grade_race, prize_total_money) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (race_denma_id, i["race_id"], i["bracket_number"], i["horse_number"], i["horse_id"], i["trainer_id"], i["horse_weight"], i["horse_weight_diff"], i["jockey_id"], i["jockey_weight"], i["result_1_count_all_period"], i["result_2_count_all_period"], i["result_3_count_all_period"], i["result_4_count_all_period"], i["result_1_count_grade_race"], i["result_2_count_grade_race"], i["result_3_count_grade_race"], i["result_4_count_grade_race"], i["prize_total_money"]))
        self.db_conn.commit()

        return i

    def process_horse_item(self, item, spider):
        logger.debug("#process_horse_item: start: item=%s" % item)

        # Build item
        i = {}

        i["horse_id"] = item["horse_id"][0]

        i["gender"] = item["gender"][0].split("|")[-2].strip()

        i["name"] = item["name"][0].strip()

        birthday_reg = re.match("^([0-9]+)年([0-9]+)月([0-9]+)日$", item["birthday"][0].strip())
        if birthday_reg:
            i["birthday"] = datetime(int(birthday_reg.group(1)), int(birthday_reg.group(2)), int(birthday_reg.group(3)), 0, 0, 0)
        else:
            raise DropItem("Unknown birthday pattern")

        i["coat_color"] = item["coat_color"][0].strip()

        i["trainer_id"] = item["trainer_id"][0].strip().split("/")[-2]

        i["owner"] = item["owner"][0].strip()

        if "breeder" in item:
            i["breeder"] = item["breeder"][0].strip()
        else:
            i["breeder"] = None

        i["breeding_farm"] = item["breeding_farm"][0].strip()

        # Insert db
        self.db_cursor.execute("delete from horse where horse_id=%s", (i["horse_id"],))
        self.db_cursor.execute("insert into horse (horse_id, gender, name, birthday, coat_color, trainer_id, owner, breeder, breeding_farm) values(%s, %s, %s, %s, %s, %s, %s, %s, %s)", (i["horse_id"], i["gender"], i["name"], i["birthday"], i["coat_color"], i["trainer_id"], i["owner"], i["breeder"], i["breeding_farm"]))
        self.db_conn.commit()

        return i

    def process_trainer_item(self, item, spider):
        logger.debug("#process_trainer_item: start: item=%s" % item)

        # Build item
        i = {}

        i["trainer_id"] = item["trainer_id"][0]

        i["name_kana"] = item["name_kana"][0].strip()

        i["name"] = item["name"][0].strip()

        birthday_reg = re.match("^([0-9]+)年([0-9]+)月([0-9]+)日$", item["birthday"][0].strip())
        if birthday_reg:
            i["birthday"] = datetime(int(birthday_reg.group(1)), int(birthday_reg.group(2)), int(birthday_reg.group(3)), 0, 0, 0)
        else:
            raise DropItem("Unknown birthday pattern")

        i["belong_to"] = item["belong_to"][0].strip()

        first_licensing_year_reg = re.match("^([0-9]+)年$", item["first_licensing_year"][0].strip())
        if first_licensing_year_reg:
            i["first_licensing_year"] = int(first_licensing_year_reg.group(1))
        else:
            raise DropItem("Unknown first_licensing_year pattern")

        # Insert db
        self.db_cursor.execute("delete from trainer where trainer_id=%s", (i["trainer_id"],))
        self.db_cursor.execute("insert into trainer (trainer_id, name_kana, name, birthday, belong_to, first_licensing_year) values (%s, %s, %s, %s, %s, %s)", (i["trainer_id"], i["name_kana"], i["name"], i["birthday"], i["belong_to"], i["first_licensing_year"]))
        self.db_conn.commit()

        return i

    def process_jockey_item(self, item, spider):
        logger.debug("#process_jockey_item: start: item=%s" % item)

        # Build item
        i = {}

        i["jockey_id"] = item["jockey_id"][0]

        name_kana_str = item["name_kana"][0].strip()
        if len(name_kana_str) > 0:
            i["name_kana"] = name_kana_str
        else:
            i["name_kana"] = None

        i["name"] = item["name"][0].strip()

        if "birthday" in item:
            birthday_reg = re.match("^([0-9]+)年([0-9]+)月([0-9]+)日$", item["birthday"][0].strip())
            if birthday_reg:
                i["birthday"] = datetime(int(birthday_reg.group(1)), int(birthday_reg.group(2)), int(birthday_reg.group(3)), 0, 0, 0)
            else:
                raise DropItem("Unknown birthday pattern")
        else:
            i["birthday"] = None

        i["belong_to"] = item["belong_to"][0].strip()

        first_licensing_year_reg = re.match("^([0-9]+)年.*$", item["first_licensing_year"][0].strip())
        if first_licensing_year_reg:
            first_licensing_year_int = int(first_licensing_year_reg.group(1))
            if first_licensing_year_int > 0:
                i["first_licensing_year"] = first_licensing_year_int
            else:
                i["first_licensing_year"] = None
        else:
            raise DropItem("Unknown first_licensing_year pattern")

        # Insert db
        self.db_cursor.execute("delete from jockey where jockey_id=%s", (i["jockey_id"],))
        self.db_cursor.execute("insert into jockey (jockey_id, name_kana, name, birthday, belong_to, first_licensing_year) values (%s, %s, %s, %s, %s, %s)", (i["jockey_id"], i["name_kana"], i["name"], i["birthday"], i["belong_to"], i["first_licensing_year"]))
        self.db_conn.commit()

        return i

    def process_odds_item(self, item, spider):
        logger.debug("#process_odds_item: start: item=%s" % item)

        # Build item
        i = {"win": {}, "place": {}}

        i["win"]["race_id"] = item["race_id"][0]
        i["win"]["horse_number"] = int(item["horse_number"][0])
        i["win"]["horse_id"] = item["horse_id"][0].split("/")[-2]

        if "odds_win" in item:
            odds_win_str = item["odds_win"][0].strip()
            if odds_win_str != "****":
                i["win"]["odds"] = float(odds_win_str)
            else:
                i["win"]["odds"] = None
        else:
            i["win"]["odds"] = None

        i["place"]["race_id"] = i["win"]["race_id"]
        i["place"]["horse_number"] = i["win"]["horse_number"]
        i["place"]["horse_id"] = i["win"]["horse_id"]

        if "odds_place_min" in item:
            odds_place_min_str = item["odds_place_min"][0].strip()
            if odds_place_min_str != "****":
                i["place"]["odds_min"] = float(odds_place_min_str)
            else:
                i["place"]["odds_min"] = None
        else:
            i["place"]["odds_min"] = None

        if "odds_place_max" in item:
            odds_place_max_str = item["odds_place_max"][0].strip()
            if odds_place_max_str != "****":
                i["place"]["odds_max"] = float(odds_place_max_str)
            else:
                i["place"]["odds_max"] = None
        else:
            i["place"]["odds_max"] = None

        # Insert db
        odds_win_id = "{}_{}".format(i["win"]["race_id"], i["win"]["horse_number"])
        odds_place_id = "{}_{}".format(i["place"]["race_id"], i["place"]["horse_number"])

        self.db_cursor.execute("delete from odds_win where odds_win_id=%s", (odds_win_id,))
        self.db_cursor.execute("insert into odds_win (odds_win_id, race_id, horse_number, horse_id, odds) values (%s, %s, %s, %s, %s)", (odds_win_id, i["win"]["race_id"], i["win"]["horse_number"], i["win"]["horse_id"], i["win"]["odds"]))

        self.db_cursor.execute("delete from odds_place where odds_place_id=%s", (odds_place_id,))
        self.db_cursor.execute("insert into odds_place (odds_place_id, race_id, horse_number, horse_id, odds_min, odds_max) values (%s, %s, %s, %s, %s, %s)", (odds_place_id, i["place"]["race_id"], i["place"]["horse_number"], i["place"]["horse_id"], i["place"]["odds_min"], i["place"]["odds_max"]))

        self.db_conn.commit()

        return i
