import logging
import scrapy

logger = logging.getLogger(__name__)


class ScheduleListSpider(scrapy.Spider):
    name = "schedule_list"

    start_urls = [
        'https://keiba.yahoo.co.jp/schedule/list/',
    ]

    def parse(self, response):
        logger.debug("#parse: start: url=%s" % response.url)

        for title in response.xpath("//title/text()"):
            yield {
                "title": title.get(),
            }
