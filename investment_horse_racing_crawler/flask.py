import os
from flask import Flask, request, g
import psycopg2
from psycopg2.extras import DictCursor

from investment_horse_racing_crawler import VERSION
from investment_horse_racing_crawler.app_logging import get_logger
from investment_horse_racing_crawler.scrapy import crawler


logger = get_logger(__name__)


app = Flask(__name__)


@app.route("/api/health")
def health():
    logger.info("#health: start")

    result = {"version": VERSION}

    return result


@app.route("/api/crawl", methods=["POST"])
def crawl():
    logger.info("#crawl: start")

    args = request.get_json()
    if not args:
        args = {}
    logger.debug(f"#crawl: args={args}")

    start_url = args.get("start_url", "https://keiba.yahoo.co.jp/schedule/list/")
    recrawl_period = args.get("recrawl_period", "all")
    recrawl_race_id = args.get("recrawl_race_id", None)
    recache_race = args.get("recache_race", False)
    recache_horse = args.get("recache_horse", False)

    _crawl(start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse)

    return "ok"


def _get_db():
    if "db" not in g:
        g.db = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT"),
            dbname=os.getenv("DB_DATABASE"),
            user=os.getenv("DB_USERNAME"),
            password=os.getenv("DB_PASSWORD")
        )
        g.db.autocommit = False
        g.db.set_client_encoding("utf-8")
        g.db.cursor_factory = DictCursor

    return g.db


@app.teardown_appcontext
def _teardown_db(exc):
    db = g.pop("db", None)
    if db is not None:
        db.close()


def _crawl(start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse):
    logger.debug(f"#_crawl: start: start_url={start_url}, recrawl_period={recrawl_period}, recrawl_race_id={recrawl_race_id}, recache_race={recache_race}, recache_horse={recache_horse}")

    crawler.crawl(start_url, recrawl_period, recrawl_race_id, recache_race, recache_horse)
