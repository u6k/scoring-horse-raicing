import scrapy


class ScheduleListSpider(scrapy.Spider):
    name = "schedule_list"

    def start_requests(self):
        url = 'https://keiba.yahoo.co.jp/schedule/list/'
        yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        for title in response.xpath("//title/text()"):
            yield {
                "title": title.get(),
            }
