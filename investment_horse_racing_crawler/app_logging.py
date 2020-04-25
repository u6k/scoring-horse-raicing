import logging


logging.config.dictConfig({
    "version": 1,

    "formatters": {
        "investment_horse_racing_crawler.logging.format": {
            "format": "%(asctime)s - %(levelname)-5s [%(name)s] %(message)s",
        },
    },

    "handlers": {
        "investment_horse_racing_crawler.logging.handler": {
            "class": "logging.StreamHandler",
            "formatter": "investment_horse_racing_crawler.logging.format",
            "level": logging.DEBUG,
        },
    },

    "loggers": {
        "investment_horse_racing_crawler": {
            "handlers": ["investment_horse_racing_crawler.logging.handler"],
            "level": logging.DEBUG,
            "propagate": 0,
        },
    },
})


def get_logger(name):
    return logging.getLogger(name)
