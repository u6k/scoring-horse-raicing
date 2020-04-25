from flask import Flask

from investment_horse_racing_crawler.scrapy.app import crawler


app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello, world!"


@app.route("/api/crawl", methods=["POST"])
def crawl():
    crawler.crawl()
