# -*- coding: utf-8 -*-

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

        requests = [o for o in output if isinstance(o, Request)]
        if len(requests) < 1:
            raise ContractFail("Empty requests")

        for request in requests:
            if request.url.startswith("https://keiba.yahoo.co.jp/schedule/list/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/race/list/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceListContract(Contract):
    name = "race_list"

    def post_process(self, output):
        logger.debug("RaceListContract#post_process: start")

        requests = [o for o in output if isinstance(o, Request)]
        if len(requests) < 1:
            raise ContractFail("Empty requests")

        for request in requests:
            if request.url.startswith("https://keiba.yahoo.co.jp/race/result/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceResultContract(Contract):
    name = "race_result"

    def post_process(self, output):
        logger.debug("RaceResultContract#post_process: start")

        # Check requests
        requests = [o for o in output if isinstance(o, Request)]
        if len(requests) < 1:
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

        # Check race payoff
        items = [o for o in output if isinstance(o, RacePayoffItem)]
        if len(items) < 1:
            raise ContractFail("RacePayoffItem is empty")

        # Check race result
        items = [o for o in output if isinstance(o, RaceResultItem)]
        if len(items) < 1:
            raise ContractFail("RaceResultItem is empty")


class RaceDenmaContract(Contract):
    name = "race_denma"

    def post_process(self, output):
        logger.debug("RaceDenmaContract#post_process: start")

        # Check requests
        requests = [o for o in output if isinstance(o, Request)]
        if len(requests) < 1:
            raise ContractFail("Empty requests")

        for request in requests:
            if request.url.startswith("https://keiba.yahoo.co.jp/directory/horse/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/directory/trainer/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/directory/jocky/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)
