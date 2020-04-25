import os
import time
from celery import Celery

from investment_horse_racing_crawler.app_logging import get_logger
from investment_horse_racing_crawler.scrapy.app import crawl as scrapy_crawl


logger = get_logger(__name__)


app = Celery("tasks")
app.conf.update(
    enable_utc=False,
    timezone=os.getenv("TZ"),
    broker_url=os.getenv("CELERY_REDIS_URL"),
    result_backend=os.getenv("CELERY_REDIS_URL"),
    worker_concurrency=1,
)


@app.task
def health():
    logger.info("#health: start")

    time.sleep(5)

    return "ok"


@app.task
def crawl():
    logger.info("#crawl: start")

    scrapy_crawl()

    return "ok"
