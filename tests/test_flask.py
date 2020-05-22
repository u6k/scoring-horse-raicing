import logging


from investment_horse_racing_crawler import flask, VERSION


class TestFlask:
    def setUp(self):
        #logging.disable(logging.DEBUG)

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

            db_cursor.execute("select * from race_denma")
            race_denmas = db_cursor.fetchall()

            assert len(race_denmas) == 470

            db_cursor.execute("select * from race_payoff")
            race_payoffs = db_cursor.fetchall()

            assert len(race_payoffs) == 430

            db_cursor.execute("select * from race_result")
            race_results = db_cursor.fetchall()

            assert len(race_results) == 470

            db_cursor.execute("select * from odds_win")
            odds_wins = db_cursor.fetchall()

            assert len(odds_wins) == 470

            db_cursor.execute("select * from odds_place")
            odds_places = db_cursor.fetchall()

            assert len(odds_places) == 470

            db_cursor.execute("select * from horse")
            horses = db_cursor.fetchall()

            assert len(horses) == 470

            db_cursor.execute("select * from jockey")
            jockeys = db_cursor.fetchall()

            assert len(jockeys) == 115

            db_cursor.execute("select * from trainer")
            trainers = db_cursor.fetchall()

            assert len(trainers) == 172

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

            db_cursor.execute("select * from race_denma")
            race_denmas = db_cursor.fetchall()

            assert len(race_denmas) == 15

            db_cursor.execute("select * from race_payoff")
            race_payoffs = db_cursor.fetchall()

            assert len(race_payoffs) == 12

            db_cursor.execute("select * from race_result")
            race_results = db_cursor.fetchall()

            assert len(race_results) == 15

            db_cursor.execute("select * from odds_win")
            odds_wins = db_cursor.fetchall()

            assert len(odds_wins) == 15

            db_cursor.execute("select * from odds_place")
            odds_places = db_cursor.fetchall()

            assert len(odds_places) == 15

            db_cursor.execute("select * from horse")
            horses = db_cursor.fetchall()

            assert len(horses) == 15

            db_cursor.execute("select * from jockey")
            jockeys = db_cursor.fetchall()

            assert len(jockeys) == 15

            db_cursor.execute("select * from trainer")
            trainers = db_cursor.fetchall()

            assert len(trainers) == 14

    def test_schedule_vote_close(self):
        # Setup
        with flask.get_db() as db_conn:
            with db_conn.cursor() as db_cursor:
                with open("tests/data/db/race_info.tsv") as f:
                    db_cursor.copy_from(f, "race_info", null="")
                with open("tests/data/db/race_denma.tsv") as f:
                    db_cursor.copy_from(f, "race_denma", null="")
                with open("tests/data/db/race_payoff.tsv") as f:
                    db_cursor.copy_from(f, "race_payoff", null="")
                with open("tests/data/db/race_result.tsv") as f:
                    db_cursor.copy_from(f, "race_result", null="")
                with open("tests/data/db/odds_win.tsv") as f:
                    db_cursor.copy_from(f, "odds_win", null="")
                with open("tests/data/db/odds_place.tsv") as f:
                    db_cursor.copy_from(f, "odds_place", null="")
                with open("tests/data/db/horse.tsv") as f:
                    db_cursor.copy_from(f, "horse", null="")
                with open("tests/data/db/jockey.tsv") as f:
                    db_cursor.copy_from(f, "jockey", null="")
                with open("tests/data/db/trainer.tsv") as f:
                    db_cursor.copy_from(f, "trainer", null="")

            db_conn.commit()

        req_data = {
            "target_date": "2020-02-01",
        }

        # Execute
        result = self.app.post("/api/schedule_vote_close", json=req_data)

        # Check
        assert result.status_code == 200

        result_data = result.get_json()
        races = result_data["races"]
        assert len(races) == 36

        assert races[0]["race_id"] == "2010010501"
        assert races[0]["start_datetime"] == "2020-02-01 09:50:00"

        assert races[1]["race_id"] == "2008020101"
        assert races[1]["start_datetime"] == "2020-02-01 10:01:00"

        assert races[2]["race_id"] == "2005010101"
        assert races[2]["start_datetime"] == "2020-02-01 10:10:00"

        assert races[3]["race_id"] == "2010010502"
        assert races[3]["start_datetime"] == "2020-02-01 10:20:00"

        assert races[4]["race_id"] == "2008020102"
        assert races[4]["start_datetime"] == "2020-02-01 10:30:00"

        assert races[5]["race_id"] == "2005010102"
        assert races[5]["start_datetime"] == "2020-02-01 10:40:00"

        assert races[6]["race_id"] == "2010010503"
        assert races[6]["start_datetime"] == "2020-02-01 10:50:00"

        assert races[7]["race_id"] == "2008020103"
        assert races[7]["start_datetime"] == "2020-02-01 11:00:00"

        assert races[8]["race_id"] == "2005010103"
        assert races[8]["start_datetime"] == "2020-02-01 11:10:00"

        assert races[9]["race_id"] == "2010010504"
        assert races[9]["start_datetime"] == "2020-02-01 11:20:00"

        assert races[10]["race_id"] == "2008020104"
        assert races[10]["start_datetime"] == "2020-02-01 11:30:00"

        assert races[11]["race_id"] == "2005010104"
        assert races[11]["start_datetime"] == "2020-02-01 11:40:00"

        assert races[12]["race_id"] == "2010010505"
        assert races[12]["start_datetime"] == "2020-02-01 12:10:00"

        assert races[13]["race_id"] == "2008020105"
        assert races[13]["start_datetime"] == "2020-02-01 12:20:00"

        assert races[14]["race_id"] == "2005010105"
        assert races[14]["start_datetime"] == "2020-02-01 12:30:00"

        assert races[15]["race_id"] == "2010010506"
        assert races[15]["start_datetime"] == "2020-02-01 12:40:00"

        assert races[16]["race_id"] == "2008020106"
        assert races[16]["start_datetime"] == "2020-02-01 12:50:00"

        assert races[17]["race_id"] == "2005010106"
        assert races[17]["start_datetime"] == "2020-02-01 13:00:00"

        assert races[18]["race_id"] == "2010010507"
        assert races[18]["start_datetime"] == "2020-02-01 13:10:00"

        assert races[19]["race_id"] == "2008020107"
        assert races[19]["start_datetime"] == "2020-02-01 13:20:00"

        assert races[20]["race_id"] == "2005010107"
        assert races[20]["start_datetime"] == "2020-02-01 13:30:00"

        assert races[21]["race_id"] == "2010010508"
        assert races[21]["start_datetime"] == "2020-02-01 13:40:00"

        assert races[22]["race_id"] == "2008020108"
        assert races[22]["start_datetime"] == "2020-02-01 13:50:00"

        assert races[23]["race_id"] == "2005010108"
        assert races[23]["start_datetime"] == "2020-02-01 14:01:00"

        assert races[24]["race_id"] == "2010010509"
        assert races[24]["start_datetime"] == "2020-02-01 14:15:00"

        assert races[25]["race_id"] == "2008020109"
        assert races[25]["start_datetime"] == "2020-02-01 14:25:00"

        assert races[26]["race_id"] == "2005010109"
        assert races[26]["start_datetime"] == "2020-02-01 14:35:00"

        assert races[27]["race_id"] == "2010010510"
        assert races[27]["start_datetime"] == "2020-02-01 14:50:00"

        assert races[28]["race_id"] == "2008020110"
        assert races[28]["start_datetime"] == "2020-02-01 15:01:00"

        assert races[29]["race_id"] == "2005010110"
        assert races[29]["start_datetime"] == "2020-02-01 15:10:00"

        assert races[30]["race_id"] == "2010010511"
        assert races[30]["start_datetime"] == "2020-02-01 15:25:00"

        assert races[31]["race_id"] == "2008020111"
        assert races[31]["start_datetime"] == "2020-02-01 15:35:00"

        assert races[32]["race_id"] == "2005010111"
        assert races[32]["start_datetime"] == "2020-02-01 15:45:00"

        assert races[33]["race_id"] == "2010010512"
        assert races[33]["start_datetime"] == "2020-02-01 16:01:00"

        assert races[34]["race_id"] == "2008020112"
        assert races[34]["start_datetime"] == "2020-02-01 16:10:00"

        assert races[35]["race_id"] == "2005010112"
        assert races[35]["start_datetime"] == "2020-02-01 16:25:00"
