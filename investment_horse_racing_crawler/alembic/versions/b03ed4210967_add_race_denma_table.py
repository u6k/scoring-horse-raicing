"""Add race denma table

Revision ID: b03ed4210967
Revises: d324ab632e61
Create Date: 2020-02-04 11:05:43.662670

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'b03ed4210967'
down_revision = 'd324ab632e61'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "race_denma",
        sa.Column("race_denma_id", sa.String(100), primary_key=True),
        sa.Column("race_id", sa.String(100), nullable=False),
        sa.Column("bracket_number", sa.Integer, nullable=False),
        sa.Column("horse_number", sa.Integer, nullable=False),
        sa.Column("horse_id", sa.String(100), nullable=False),
        sa.Column("trainer_id", sa.String(100), nullable=False),
        sa.Column("horse_weight", sa.Float, nullable=False),
        sa.Column("horse_weight_diff", sa.Float, nullable=False),
        sa.Column("jockey_id", sa.String(100), nullable=False),
        sa.Column("jockey_weight", sa.Float, nullable=False),
        sa.Column("result_1_count_all_period", sa.Integer, nullable=False),
        sa.Column("result_2_count_all_period", sa.Integer, nullable=False),
        sa.Column("result_3_count_all_period", sa.Integer, nullable=False),
        sa.Column("result_4_count_all_period", sa.Integer, nullable=False),
        sa.Column("result_1_count_grade_race", sa.Integer, nullable=False),
        sa.Column("result_2_count_grade_race", sa.Integer, nullable=False),
        sa.Column("result_3_count_grade_race", sa.Integer, nullable=False),
        sa.Column("result_4_count_grade_race", sa.Integer, nullable=False),
        sa.Column("prize_total_money", sa.Integer, nullable=False),
    )


def downgrade():
    pass
