# -*- coding: utf-8 -*-


from scrapy import Item, Field


class RaceInfoItem(Item):
    race_id = Field()
    race_round = Field()
    start_datetime = Field()
    place_name = Field()
    race_name = Field()
    course_type = Field()
    course_length = Field()
    weather = Field()
    course_condition = Field()
    added_money = Field()


class RacePayoffItem(Item):
    race_id = Field()

    # win
    # place
    # bracket_quinella
    # quinella
    # quinella_place
    # exacta
    # trio
    # trifecta
    payoff_type = Field()

    horse_number_1 = Field()
    horse_number_2 = Field()
    horse_number_3 = Field()

    odds = Field()

    favorite_order = Field()


class RaceResultItem(Item):
    race_id = Field()
    result = Field()
    bracket_number = Field()
    horse_number = Field()
    horse_id = Field()
    horse_name = Field()
    horse_gender = Field()
    horse_age = Field()
    horse_weight = Field()
    horse_weight_diff = Field()
    arrival_time = Field()
    jockey_id = Field()
    jockey_name = Field()
    jockey_weight = Field()
    favorite_order = Field()
    odds = Field()
    trainer_id = Field()
    trainer_name = Field()
