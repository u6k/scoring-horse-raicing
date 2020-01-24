# -*- coding: utf-8 -*-


from datetime import datetime
import logging
import psycopg2
import re
from scrapy.exceptions import DropItem

from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem, RaceResultItem, HorseItem, TrainerItem, JockeyItem, OddsWinPlaceItem


logger = logging.getLogger(__name__)


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
            logger.debug("#process_item: RaceResultItem")
        elif isinstance(item, HorseItem):
            logger.debug("#process_item: HorseItem")
        elif isinstance(item, TrainerItem):
            logger.debug("#process_item: TrainerItem")
        elif isinstance(item, JockeyItem):
            logger.debug("#process_item: JockeyItem")
        elif isinstance(item, OddsWinPlaceItem):
            logger.debug("#process_item: OddsWinPlaceItem")
        else:
            raise DropItem("Unknown item type")

        self.db_cursor.execute("select 1")
        results = self.db_cursor.fetchall()

        logger.debug("#process_item: database results=%s" % results)

        return new_item

    def process_race_info_item(self, item, spider):
        logger.debug("#process_race_info_item: start: item=%s" % item)

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

        return i

    def process_race_payoff_item(self, item, spider):
        logger.debug("#process_race_payoff_item: start: item=%s" % item)

        i = {}

        i["race_id"] = item["race_id"][0]

        if item["payoff_type"][0] == "単勝":
            i["payoff_type"] = "win"
        elif item["payoff_type"][0] == "複勝":
            i["payoff_type"] = "place"
        else:
            raise DropItem("Unknown payoff_type")

        i["horse_number"] = int(item["horse_number"][0])

        i["odds"] = int(item["odds"][0].replace("円", "").replace(",", ""))/100.0

        i["favorite_order"] = int(item["favorite_order"][0].replace("番人気", ""))

        return i
