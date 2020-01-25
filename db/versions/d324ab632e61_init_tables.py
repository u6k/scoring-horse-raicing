"""Init tables

Revision ID: d324ab632e61
Revises:
Create Date: 2020-01-24 03:35:45.011606

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'd324ab632e61'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "race_info",
        sa.Column("race_id", sa.String(100), primary_key=True),
        sa.Column("race_round", sa.Integer, nullable=False),
        sa.Column("start_datetime", sa.DateTime, nullable=False),
        sa.Column("place_name", sa.String(255), nullable=False),
        sa.Column("race_name", sa.String(255), nullable=False),
        sa.Column("course_type", sa.String(255), nullable=False),
        sa.Column("course_length", sa.Integer, nullable=False),
        sa.Column("weather", sa.String(255), nullable=False),
        sa.Column("course_condition", sa.String(255), nullable=False),
        sa.Column("added_money", sa.String(255), nullable=False),
    )

    op.create_table(
        "race_payoff",
        sa.Column("race_payoff_id", sa.String(100), primary_key=True),
        sa.Column("race_id", sa.String(100), nullable=False),
        sa.Column("payoff_type", sa.String(255), nullable=False),
        sa.Column("horse_number", sa.Integer, nullable=False),
        sa.Column("odds", sa.Float, nullable=False),
        sa.Column("favorite_order", sa.Integer, nullable=False),
    )

    op.create_table(
        "race_result",
        sa.Column("race_result_id", sa.String(100), primary_key=True),
        sa.Column("race_id", sa.String(100), nullable=False),
        sa.Column("result", sa.Integer, nullable=True),
        sa.Column("bracket_number", sa.Integer, nullable=False),
        sa.Column("horse_number", sa.Integer, nullable=False),
        sa.Column("horse_id", sa.String(100), nullable=False),
        sa.Column("horse_weight", sa.Float, nullable=False),
        sa.Column("horse_weight_diff", sa.Float, nullable=False),
        sa.Column("arrival_time", sa.Float, nullable=False),
        sa.Column("jockey_id", sa.String(100), nullable=False),
        sa.Column("jockey_weight", sa.Float, nullable=False),
        sa.Column("favorite_order", sa.Integer, nullable=False),
        sa.Column("odds", sa.Float, nullable=False),
        sa.Column("trainer_id", sa.String(100), nullable=False),
    )

    op.create_table(
        "horse",
        sa.Column("horse_id", sa.String(100), primary_key=True),
        sa.Column("gender", sa.String(255), nullable=False),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("birthday", sa.DateTime, nullable=False),
        sa.Column("coat_color", sa.String(255), nullable=False),
        sa.Column("trainer_id", sa.String(100), nullable=False),
        sa.Column("owner", sa.String(255), nullable=False),
        sa.Column("breeder", sa.String(255), nullable=False),
        sa.Column("breeding_farm", sa.String(255), nullable=False),
    )

    op.create_table(
        "trainer",
        sa.Column("trainer_id", sa.String(100), primary_key=True),
        sa.Column("name_kana", sa.String(255), nullable=False),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("birthday", sa.DateTime, nullable=False),
        sa.Column("belong_to", sa.String(255), nullable=False),
        sa.Column("first_licensing_year", sa.Integer, nullable=False),
    ),

    op.create_table(
        "jockey",
        sa.Column("jockey_id", sa.String(100), primary_key=True),
        sa.Column("name_kana", sa.String(255), nullable=False),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("birthday", sa.DateTime, nullable=False),
        sa.Column("belong_to", sa.String(255), nullable=False),
        sa.Column("first_licensing_year", sa.Integer, nullable=False),
    )

    op.create_table(
        "odds_win",
        sa.Column("odds_win_id", sa.String(100), primary_key=True),
        sa.Column("race_id", sa.String(100), nullable=False),
        sa.Column("horse_number", sa.Integer, nullable=False),
        sa.Column("horse_id", sa.String(100), nullable=False),
        sa.Column("odds", sa.Float, nullable=False),
    )

    op.create_table(
        "odds_place",
        sa.Column("odds_place_id", sa.String(100), primary_key=True),
        sa.Column("race_id", sa.String(100), nullable=False),
        sa.Column("horse_number", sa.Integer, nullable=False),
        sa.Column("horse_id", sa.String(100), nullable=False),
        sa.Column("odds_min", sa.Float, nullable=False),
        sa.Column("odds_max", sa.Float, nullable=False),
    )


def downgrade():
    pass
