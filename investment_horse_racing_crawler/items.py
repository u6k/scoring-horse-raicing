# -*- coding: utf-8 -*-


from scrapy import Item, Field


class RaceInfoItem(Item):
    race_id = Field()
    race_round = Field()
    start_date = Field()
    start_time = Field()
    place_name = Field()
    race_name = Field()
    course_type_length = Field()
    weather = Field()
    course_condition = Field()
    added_money = Field()


class RacePayoffItem(Item):
    race_id = Field()
    payoff_type = Field()
    horse_number = Field()
    odds = Field()
    favorite_order = Field()


class RaceResultItem(Item):
    race_id = Field()
    result = Field()
    bracket_number = Field()
    horse_number = Field()
    horse_id = Field()
    horse_name = Field()
    horse_gender_age = Field()
    horse_weight_and_diff = Field()
    arrival_time = Field()
    jockey_id = Field()
    jockey_name = Field()
    jockey_weight = Field()
    favorite_order = Field()
    odds = Field()
    trainer_id = Field()
    trainer_name = Field()


class HorseItem(Item):
    horse_id = Field()
    gender = Field()
    name = Field()
    birthday = Field()
    coat_color = Field()
    trainer_id = Field()
    owner = Field()
    breeder = Field()
    breeding_farm = Field()
