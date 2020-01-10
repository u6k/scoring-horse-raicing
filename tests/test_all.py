from .context import investment_horse_racing_crawler

import unittest


class TestApp(unittest.TestCase):
    def test_hello(self):
        self.assertEqual("hello", investment_horse_racing_crawler.hello())


if __name__ == "__main__":
    unittest.main()
