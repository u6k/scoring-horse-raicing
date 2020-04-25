from flask import Flask, request

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


@app.route("/api/crawl", methods=["POST"])
def crawl():
    logger.info("#crawl: start")

    args = request.get_json()
    if not args:
        args = {}
    logger.info(f"#crawl: args={args}")

    start_url = args.get("start_url", "https://keiba.yahoo.co.jp/schedule/list/")
    recrawl_period = args.get("recrawl_period", "all")
    recrawl_race_id = args.get("recrawl_race_id", None)
    recache_race = args.get("recache_race", False)
    recache_horse = args.get("recache_horse", False)
    eta = args.get("eta", None)

    if not eta:
        tasks.crawl.delay(start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse)
    else:
        tasks.crawl.apply_async((start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse), eta=eta)

    return "ok"
