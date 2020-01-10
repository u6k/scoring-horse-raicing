import scrapy


class ScheduleListSpider(scrapy.Spider):
    name = "schedule_list"

    start_urls = [
        'https://keiba.yahoo.co.jp/schedule/list/',
    ]

    def parse(self, response):
        for title in response.xpath("//title/text()"):
            yield {
                "title": title.get(),
            }
