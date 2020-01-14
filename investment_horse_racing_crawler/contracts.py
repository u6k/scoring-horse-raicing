# -*- coding: utf-8 -*-

from datetime import datetime
import logging

from scrapy.contracts import Contract
from scrapy.exceptions import ContractFail
from scrapy.http import Request

from investment_horse_racing_crawler.items import RaceInfoItem, RacePayoffItem, RaceResultItem


logger = logging.getLogger(__name__)


class ScheduleListContract(Contract):
    name = "schedule_list"

    def post_process(self, output):
        logger.debug("ScheduleListContract#post_process: start")

        for request in [o for o in output if isinstance(o, Request)]:
            if request.url.startswith("https://keiba.yahoo.co.jp/schedule/list/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/race/list/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceListContract(Contract):
    name = "race_list"

    def post_process(self, output):
        logger.debug("RaceListContract#post_process: start")

        for request in [o for o in output if isinstance(o, Request)]:
            if request.url.startswith("https://keiba.yahoo.co.jp/race/result/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceResultContract(Contract):
    name = "race_result"

    def post_process(self, output):
        logger.debug("RaceResultContract#post_process: start")

        # Check requests
        requests = [o for o in output if isinstance(o, Request)]
        if len(requests) == 0:
            raise ContractFail("Empty requests")

        for request in requests:
            if request.url.startswith("https://keiba.yahoo.co.jp/race/denma/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/odds/tfw/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)

        # Check race info item
        items = [o for o in output if isinstance(o, RaceInfoItem)]
        if len(items) != 1:
            raise ContractFail("RaceInfoItem is not 1")

        item = items[0]

        if type(item["race_id"]) is not str or len(item["race_id"]) == 0:
            raise ContractFail("race_id is not str or empty")

        if type(item["race_round"]) is not int:
            raise ContractFail("race_round is not int")

        if type(item["start_datetime"]) is not datetime:
            raise ContractFail("start_datetime is not datetime")

        if type(item["place_name"]) is not str or len(item["place_name"]) == 0:
            raise ContractFail("place_name is not str or empty")

        if type(item["race_name"]) is not str or len(item["race_name"]) == 0:
            raise ContractFail("race_name is not str or empty")

        if type(item["course_type"]) is not str or len(item["course_type"]) == 0:
            raise ContractFail("course_type is not str or empty")

        if type(item["course_length"]) is not str or len(item["course_length"]) == 0:
            raise ContractFail("course_length is not str or empty")

        if type(item["weather"]) is not str or len(item["weather"]) == 0:
            raise ContractFail("weather is not str or empty")

        if type(item["course_condition"]) is not str or len(item["course_condition"]) == 0:
            raise ContractFail("course_condition is not str or empty")

        if type(item["added_money"]) is not str or len(item["added_money"]) == 0:
            raise ContractFail("added_money is not str or empty")

        # Check race payoff
        items = [o for o in output if isinstance(o, RacePayoffItem)]
        if len(items) == 0:
            raise ContractFail("RacePayoffItem is empty")

        for item in items:
            if type(item["race_id"]) is not str or len(item["race_id"]) == 0:
                raise ContractFail("race_id is not str or empty")

            if type(item["payoff_type"]) is not str or len(item["payoff_type"]) == 0:
                raise ContractFail("payoff_type is not str or empty")

            if type(item["horse_number_1"]) is not int:
                raise ContractFail("horse_number_1 is not int")

            if item["horse_number_2"] is not None and type(item["horse_number_2"]) is not int:
                raise ContractFail("horse_number_2 is not int and not None")

            if item["horse_number_3"] is not None and type(item["horse_number_3"]) is not int:
                raise ContractFail("horse_number_3 is not int and not None")

            if type(item["odds"]) is not float:
                raise ContractFail("odds is not float")

            if type(item["favorite_order"]) is not int:
                raise ContractFail("favorite_order is not int")

        # Check race result
        items = [o for o in output if isinstance(o, RaceResultItem)]
        if len(items) == 0:
            raise ContractFail("RaceResultItem is empty")

        for item in items:
            if type(item["race_id"]) is not str or len(item["race_id"]) == 0:
                raise ContractFail("race_id is not str or empty")

            if item["result"] is not None and type(item["result"]) is not int:
                raise ContractFail("result is not None and not int")

            if type(item["bracket_number"]) is not int:
                raise ContractFail("bracket_number is not int")

            if type(item["horse_number"]) is not int:
                raise ContractFail("horse_number is not int")

            if type(item["horse_id"]) is not str or len(item["horse_id"]) == 0:
                raise ContractFail("horse_id is not str or empty")

            if type(item["horse_name"]) is not str or len(item["horse_name"]) == 0:
                raise ContractFail("horse_name is not str or empty")

            if type(item["horse_gender"]) is not str or len(item["horse_gender"]) == 0:
                raise ContractFail("horse_gender is not str or empty")

            if type(item["horse_age"]) is not int:
                raise ContractFail("horse_age is not int")

            if type(item["horse_weight"]) is not int:
                raise ContractFail("horse_weight is not int")

            if type(item["horse_weight_diff"]) is not int:
                raise ContractFail("horse_weight_diff is not int")

            if item["arrival_time"] is not None and type(item["arrival_time"]) is not float:
                raise ContractFail("arrival_time is not None and not float")

            if type(item["jockey_id"]) is not str or len(item["jockey_id"]) == 0:
                raise ContractFail("jockey_id is not str or empty")

            if type(item["jockey_name"]) is not str or len(item["jockey_name"]) == 0:
                raise ContractFail("jockey_name is not str or empty")

            if type(item["jockey_weight"]) is not float:
                raise ContractFail("jockey_weight is not float")

            if type(item["favorite_order"]) is not int:
                raise ContractFail("favorite_order is not int")

            if type(item["odds"]) is not float:
                raise ContractFail("odds is not float")

            if type(item["trainer_id"]) is not str or len(item["trainer_id"]) == 0:
                raise ContractFail("trainer_id is not str or empty")

            if type(item["trainer_name"]) is not str or len(item["trainer_name"]) == 0:
                raise ContractFail("trainer_name is not str or empty")


class RaceDenmaContract(Contract):
    name = "race_denma"

    def post_process(self, output):
        logger.debug("RaceDenmaContract#post_process: start")

        # Check requests
        requests = [o for o in output if isinstance(o, Request)]
        if len(requests) == 0:
            raise ContractFail("Empty requests")

        for request in requests:
            if request.url.startswith("https://keiba.yahoo.co.jp/directory/horse/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/directory/trainer/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/directory/jocky/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)
