from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings
from billiard import Process

from investment_horse_racing_crawler.app_logging import get_logger


logger = get_logger(__name__)


class CrawlerScript():
    def __init__(self):
        settings = get_project_settings()
        self.crawler = CrawlerProcess(settings, install_root_handler=False)

    def _crawl(self, start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse):
        self.crawler.crawl("horse_racing", start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse)
        self.crawler.start()
        self.crawler.stop()

    def crawl(self, start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse):
        process = Process(target=self._crawl, kwargs={"start_url": start_url, "recrawl_period": recrawl_period, "recrawl_race_id": recrawl_race_id, "recache_race": recache_race, "recache_horse": recache_horse})
        process.start()
        process.join()


def crawl(start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse):
    logger.info(f"#crawl: start: start_url={start_url}, recrawl_period={recrawl_period}, recrawl_race_id={recrawl_race_id}, recache_race={recache_race}, recache_horse={recache_horse}")

    crawler = CrawlerScript()
    crawler.crawl(start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse)
