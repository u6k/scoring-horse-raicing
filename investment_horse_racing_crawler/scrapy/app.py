from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings
from billiard import Process


class CrawlerScript():
    def __init__(self):
        settings = get_project_settings()
        self.crawler = CrawlerProcess(settings, install_root_handler=False)

    def _crawl(self):
        self.crawler.crawl("horse_racing")
        self.crawler.start()
        self.crawler.stop()

    def crawl(self):
        process = Process(target=self._crawl)
        process.start()
        process.join()


crawler = CrawlerScript()
