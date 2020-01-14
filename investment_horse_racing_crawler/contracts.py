# -*- coding: utf-8 -*-

import logging

from scrapy.contracts import Contract
from scrapy.exceptions import ContractFail


logger = logging.getLogger(__name__)


class ScheduleListContract(Contract):
    name = "schedule_list"

    def post_process(self, output):
        logger.debug("ScheduleListContract#post_process: start")

        for request in output:
            if request.url.startswith("https://keiba.yahoo.co.jp/schedule/list/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/race/list/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceListContract(Contract):
    name = "race_list"

    def post_process(self, output):
        logger.debug("RaceListContract#post_process: start")

        for request in output:
            if request.url.startswith("https://keiba.yahoo.co.jp/race/result/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceResultContract(Contract):
    name = "race_result"

    def post_process(self, output):
        logger.debug("RaceResultContract#post_process: start")

        for request in output:
            if request.url.startswith("https://keiba.yahoo.co.jp/race/denma/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/odds/tfw/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)


class RaceDenmaContract(Contract):
    name = "race_denma"

    def post_process(self, output):
        logger.debug("RaceDenmaContract#post_process: start")

        for request in output:
            if request.url.startswith("https://keiba.yahoo.co.jp/directory/horse/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/directory/trainer/"):
                continue

            if request.url.startswith("https://keiba.yahoo.co.jp/directory/jocky/"):
                continue

            raise ContractFail("Unknown request url: url=%s" % request.url)
