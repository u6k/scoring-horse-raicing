# -*- coding: utf-8 -*-

import os


BOT_NAME = 'investment_horse_racing_crawler'

SPIDER_MODULES = ['investment_horse_racing_crawler.spiders']
NEWSPIDER_MODULE = 'investment_horse_racing_crawler.spiders'

ITEM_PIPELINES = {
    "investment_horse_racing_crawler.pipelines.PostgreSQLPipeline": 300,
}

SPIDER_CONTRACTS = {
    "investment_horse_racing_crawler.contracts.ScheduleListContract": 10,
    "investment_horse_racing_crawler.contracts.RaceListContract": 10,
    "investment_horse_racing_crawler.contracts.RaceResultContract": 10,
    "investment_horse_racing_crawler.contracts.RaceDenmaContract": 10,
    "investment_horse_racing_crawler.contracts.HorseContract": 10,
    "investment_horse_racing_crawler.contracts.TrainerContract": 10,
    "investment_horse_racing_crawler.contracts.JockeyContract": 10,
    "investment_horse_racing_crawler.contracts.OddsWinPlaceContract": 10,
}

ROBOTSTXT_OBEY = True

DOWNLOAD_DELAY = 3

HTTPCACHE_ENABLED = True
HTTPCACHE_STORAGE = "investment_horse_racing_crawler.middlewares.S3CacheStorage"

CONCURRENT_REQUESTS_PER_DOMAIN = 1
CONCURRENT_REQUESTS_PER_IP = 1

USER_AGENT = "horse_racing_crawler/1.0 (+https://github.com/u6k/investment-horse-racing-crawler)"

S3_ENDPOINT = os.environ["S3_ENDPOINT"]
S3_REGION = os.environ["S3_REGION"]
S3_ACCESS_KEY = os.environ["S3_ACCESS_KEY"]
S3_SECRET_KEY = os.environ["S3_SECRET_KEY"]
S3_BUCKET = os.environ["S3_BUCKET"]
S3_FOLDER = os.environ["S3_FOLDER"]

DB_HOST = os.environ["DB_HOST"]
DB_PORT = os.environ["DB_PORT"]
DB_DATABASE = os.environ["DB_DATABASE"]
DB_USERNAME = os.environ["DB_USERNAME"]
DB_PASSWORD = os.environ["DB_PASSWORD"]
