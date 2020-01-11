# -*- coding: utf-8 -*-

# Define here the models for your spider middleware
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/spider-middleware.html

import logging
import os
from scrapy import signals
from scrapy.utils.request import request_fingerprint


logger = logging.getLogger(__name__)


class InvestmentHorseRacingCrawlerSpiderMiddleware(object):
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the spider middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_spider_input(self, response, spider):
        # Called for each response that goes through the spider
        # middleware and into the spider.

        # Should return None or raise an exception.
        return None

    def process_spider_output(self, response, result, spider):
        # Called with the results returned from the Spider, after
        # it has processed the response.

        # Must return an iterable of Request, dict or Item objects.
        for i in result:
            yield i

    def process_spider_exception(self, response, exception, spider):
        # Called when a spider or process_spider_input() method
        # (from other spider middleware) raises an exception.

        # Should return either None or an iterable of Request, dict
        # or Item objects.
        pass

    def process_start_requests(self, start_requests, spider):
        # Called with the start requests of the spider, and works
        # similarly to the process_spider_output() method, except
        # that it doesn’t have a response associated.

        # Must return only requests (not items).
        for r in start_requests:
            yield r

    def spider_opened(self, spider):
        spider.logger.info('Spider opened: %s' % spider.name)


class InvestmentHorseRacingCrawlerDownloaderMiddleware(object):
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the downloader middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_request(self, request, spider):
        # Called for each request that goes through the downloader
        # middleware.

        # Must either:
        # - return None: continue processing this request
        # - or return a Response object
        # - or return a Request object
        # - or raise IgnoreRequest: process_exception() methods of
        #   installed downloader middleware will be called
        return None

    def process_response(self, request, response, spider):
        # Called with the response returned from the downloader.

        # Must either;
        # - return a Response object
        # - return a Request object
        # - or raise IgnoreRequest
        return response

    def process_exception(self, request, exception, spider):
        # Called when a download handler or a process_request()
        # (from other downloader middleware) raises an exception.

        # Must either:
        # - return None: continue processing this exception
        # - return a Response object: stops process_exception() chain
        # - return a Request object: stops process_exception() chain
        pass

    def spider_opened(self, spider):
        spider.logger.info('Spider opened: %s' % spider.name)


class S3CacheStorage(object):

    def __init__(self, settings):
        self.s3_endpoint = settings["S3_ENDPOINT"]
        self.s3_region = settings["S3_REGION"]
        self.s3_access_key = settings["S3_ACCESS_KEY"]
        self.s3_secret_key = settings["S3_SECRET_KEY"]
        self.s3_bucket = settings["S3_BUCKET"]
        self.s3_folder = settings["S3_FOLDER"]

    def open_spider(self, spider):
        logger.debug("*** Using s3 cache storage. spider=%s" % spider)

    def close_spider(self, spider):
        logger.debug("*** Close spider")

    def retrieve_response(self, spider, request):
        logger.debug("*** Retrieve response")

        rpath = self._get_request_path(spider, request)
        logger.debug("*** rpath=%s" % rpath)

        metadata = self._read_meta(spider, request)
        if metadata is None:
            return  # not cached

        return

    def store_response(self, spider, request, response):
        logger.debug("*** Store response")

        rpath = self._get_request_path(spider, request)
        logger.debug("*** rpath=%s" % rpath)

    def _get_request_path(self, spider, request):
        key = request_fingerprint(request)
        return os.path.join("s3://", self.s3_bucket, self.s3_folder, key[0:2], key)

    def _read_meta(self, spider, request):
        rpath = self._get_request_path(spider, request)
        logger.debug("*** rpath=%s" % rpath)

        return
