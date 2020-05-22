from datetime import datetime
import os
import requests
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

    with get_db().cursor() as db_cursor:
        db_cursor.execute("select 1")

        result["database"] = True

    return result


@app.route("/api/crawl", methods=["POST"])
def crawl():
    logger.info("#crawl: start")

    args = request.get_json()
    if not args:
        args = {}
    logger.debug(f"#crawl: args={args}")

    start_url = args.get("start_url", "https://keiba.yahoo.co.jp/schedule/list/")
    start_date = args.get("start_date", "1900-01-01")
    end_date = args.get("end_date", "2100-01-01")
    recache_race = args.get("recache_race", False)
    recache_horse = args.get("recache_horse", False)

    if start_date is not None:
        start_date = datetime.strptime(start_date, "%Y-%m-%d")

    if end_date is not None:
        end_date = datetime.strptime(end_date, "%Y-%m-%d")

    _crawl(start_url, start_date, end_date, recache_race, recache_horse)

    return {"result": True}


@app.route("/api/race_info")
def find_race_info():
    logger.info(f"#find_race_info: start: args={request.args}")

    target_date = request.args.get("target_date", None)
    race_id = request.args.get("race_id", None)

    if target_date is not None:
        target_date = datetime.strptime(target_date, "%Y-%m-%d")

        with get_db().cursor() as db_cursor:
            db_cursor.execute("select * from race_info where date(start_datetime)=%s order by start_datetime, race_id", (target_date,))
            race_infos = db_cursor.fetchall()

    elif race_id is not None:
        with get_db().cursor() as db_cursor:
            db_cursor.execute("select * from race_info where race_id=%s order by start_datetime, race_id", (race_id,))
            race_infos = db_cursor.fetchall()

    else:
        raise RuntimeError("Invalid args")

    result = {"race_info": []}
    for race_info in race_infos:
        result["race_info"].append({
            "race_id": race_info["race_id"],
            "race_round": race_info["race_round"],
            "start_datetime": race_info["start_datetime"].strftime("%Y-%m-%d %H:%M:%S"),
            "place_name": race_info["place_name"],
            "race_name": race_info["race_name"],
        })

    logger.debug(f"#find_race_info: len(race_info)={len(result['race_info'])}")
    logger.debug(f"#find_race_info: result={result}")
    return result


def get_db():
    db = psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_DATABASE"),
        user=os.getenv("DB_USERNAME"),
        password=os.getenv("DB_PASSWORD")
    )
    db.autocommit = False
    db.set_client_encoding("utf-8")
    db.cursor_factory = DictCursor

    return db


def _get_db():
    if "db" not in g:
        g.db = get_db()

    return g.db


@app.teardown_appcontext
def _teardown_db(exc):
    db = g.pop("db", None)
    if db is not None:
        db.close()


def _crawl(start_url, start_date, end_date, recache_race, recache_horse):
    logger.debug(f"#_crawl: start: start_url={start_url}, start_date={start_date}, end_date={end_date}, recache_race={recache_race}, recache_horse={recache_horse}")

    crawler.crawl(start_url, start_date, end_date, recache_race, recache_horse)


def _schedule_vote_close(start_date, end_date):
    logger.debug(f"#_schedule_vote_close: start_date={start_date}, end_date={end_date}")

    scheduled_races = {"races": []}
    with _get_db().cursor() as db_cursor:
        db_cursor.execute("select race_id, start_datetime, place_name, race_name from race_info where start_datetime >= %s and start_datetime < %s order by start_datetime, race_id", (start_date, end_date))
        for idx, row in enumerate(db_cursor.fetchall()):
            logger.debug(f"#_schedule_vote_close: idx={idx}, row={row}")

            url = os.getenv("API_SCHEDULE_VOTE_CLOSE_URL")
            headers = {
                "Content-Type": "application/json",
                "X-Rundeck-Auth-Token": os.getenv("API_RUNDECK_AUTH_TOKEN")
            }
            params = {
                "options": {
                    "RACE_ID": row["race_id"],
                    "START_DATETIME": row["start_datetime"].strftime("%Y-%m-%d %H:%M:%S"),
                }
            }
            logger.debug(f"#_schedule_vote_close: url={url}, params={params}")

            resp = requests.post(url=url, headers=headers, json=params)
            logger.debug(f"#_schedule_vote_close: status_code={resp.status_code}, body={resp.text}")

            scheduled_race = {
                "race_id": params["options"]["RACE_ID"],
                "start_datetime": params["options"]["START_DATETIME"],
            }
            scheduled_races["races"].append(scheduled_race)

    return scheduled_races
