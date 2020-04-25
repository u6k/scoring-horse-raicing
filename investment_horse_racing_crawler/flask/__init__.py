from flask import Flask

from investment_horse_racing_crawler.app_logging import get_logger
from investment_horse_racing_crawler.celery import tasks


logger = get_logger(__name__)


app = Flask(__name__)


@app.route("/api/health")
def health():
    logger.info("#health: start")

    result = tasks.health.delay()
    logger.info(f"celery.result={result.get()}")

    return "ok"
