# -*- coding: utf-8 -*-

BOT_NAME = 'investment_horse_racing_crawler'

SPIDER_MODULES = ['investment_horse_racing_crawler.spiders']
NEWSPIDER_MODULE = 'investment_horse_racing_crawler.spiders'


ROBOTSTXT_OBEY = True

DOWNLOAD_DELAY = 3

CONCURRENT_REQUESTS_PER_DOMAIN = 1
CONCURRENT_REQUESTS_PER_IP = 1

USER_AGENT = "horse_racing_crawler/1.0 (+https://github.com/u6k/investment-horse-racing-crawler)"
