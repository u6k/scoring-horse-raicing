import logging


from investment_horse_racing_crawler import flask, VERSION


class TestFlask:
    def setUp(self):
        logging.disable(logging.DEBUG)

        self.app = flask.app.test_client()

    def test_health(self):
        # Execute
        result = self.app.get("/api/health")

        # Check
        assert result.status_code == 200

        result_data = result.get_json()
        assert result_data["version"] == VERSION
        assert result_data["database"]
