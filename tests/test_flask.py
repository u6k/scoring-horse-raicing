import logging


from investment_horse_racing_crawler import flask, VERSION


class TestFlask:
    def setUp(self):
        logging.disable(logging.DEBUG)

        self.app = flask.app.test_client()

        with flask.get_db() as db_conn:
            with db_conn.cursor() as db_cursor:
                db_cursor.execute("delete from race_info")
                db_cursor.execute("delete from race_denma")
                db_cursor.execute("delete from race_payoff")
                db_cursor.execute("delete from race_result")
                db_cursor.execute("delete from odds_win")
                db_cursor.execute("delete from odds_place")
                db_cursor.execute("delete from horse")
                db_cursor.execute("delete from jockey")
                db_cursor.execute("delete from trainer")

                db_conn.commit()

    def test_health(self):
        # Execute
        result = self.app.get("/api/health")

        # Check
        assert result.status_code == 200

        result_data = result.get_json()
        assert result_data["version"] == VERSION
        assert result_data["database"]

    def test_crawl_1(self):
        # Setup
        req_data = {
            "start_url": "https://keiba.yahoo.co.jp/schedule/list/2020/?month=2",
            "start_date": "2020-02-01",
            "end_date": "2020-02-02",
            "recache_race": False,
            "recache_horse": False,
        }

        # Execute
        result = self.app.post("/api/crawl", json=req_data)

        # Check
        assert result.status_code == 200

        result_data = result.get_json()
        assert result_data["result"]

        with flask.get_db().cursor() as db_cursor:
            db_cursor.execute("select race_id, start_datetime from race_info order by start_datetime, race_id")
            race_infos = db_cursor.fetchall()

        assert len(race_infos) == 36
        assert race_infos[0]["race_id"] == "2010010501"
        assert race_infos[1]["race_id"] == "2008020101"
        assert race_infos[2]["race_id"] == "2005010101"
        assert race_infos[3]["race_id"] == "2010010502"
        assert race_infos[4]["race_id"] == "2008020102"
        assert race_infos[5]["race_id"] == "2005010102"
        assert race_infos[6]["race_id"] == "2010010503"
        assert race_infos[7]["race_id"] == "2008020103"
        assert race_infos[8]["race_id"] == "2005010103"
        assert race_infos[9]["race_id"] == "2010010504"
        assert race_infos[10]["race_id"] == "2008020104"
        assert race_infos[11]["race_id"] == "2005010104"
        assert race_infos[12]["race_id"] == "2010010505"
        assert race_infos[13]["race_id"] == "2008020105"
        assert race_infos[14]["race_id"] == "2005010105"
        assert race_infos[15]["race_id"] == "2010010506"
        assert race_infos[16]["race_id"] == "2008020106"
        assert race_infos[17]["race_id"] == "2005010106"
        assert race_infos[18]["race_id"] == "2010010507"
        assert race_infos[19]["race_id"] == "2008020107"
        assert race_infos[20]["race_id"] == "2005010107"
        assert race_infos[21]["race_id"] == "2010010508"
        assert race_infos[22]["race_id"] == "2008020108"
        assert race_infos[23]["race_id"] == "2005010108"
        assert race_infos[24]["race_id"] == "2010010509"
        assert race_infos[25]["race_id"] == "2008020109"
        assert race_infos[26]["race_id"] == "2005010109"
        assert race_infos[27]["race_id"] == "2010010510"
        assert race_infos[28]["race_id"] == "2008020110"
        assert race_infos[29]["race_id"] == "2005010110"
        assert race_infos[30]["race_id"] == "2010010511"
        assert race_infos[31]["race_id"] == "2008020111"
        assert race_infos[32]["race_id"] == "2005010111"
        assert race_infos[33]["race_id"] == "2010010512"
        assert race_infos[34]["race_id"] == "2008020112"
        assert race_infos[35]["race_id"] == "2005010112"

    def test_crawl_2(self):
        # Setup
        req_data = {
            "start_url": "https://keiba.yahoo.co.jp/race/denma/2005010101/",
            "recache_race": True,
            "recache_horse": False,
        }

        # Execute
        result = self.app.post("/api/crawl", json=req_data)

        # Check
        assert result.status_code == 200

        result_data = result.get_json()
        assert result_data["result"]

        with flask.get_db().cursor() as db_cursor:
            db_cursor.execute("select race_id, start_datetime from race_info order by start_datetime, race_id")
            race_infos = db_cursor.fetchall()

        assert len(race_infos) == 1
        assert race_infos[0]["race_id"] == "2005010101"
