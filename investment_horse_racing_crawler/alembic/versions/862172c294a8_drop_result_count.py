"""Drop result count

Revision ID: 862172c294a8
Revises: 1b1b73815bca
Create Date: 2020-05-17 01:42:28.233150

"""
from alembic import op


# revision identifiers, used by Alembic.
revision = '862172c294a8'
down_revision = '1b1b73815bca'
branch_labels = None
depends_on = None


def upgrade():
    op.drop_column("race_denma", "result_1_count_all_period")
    op.drop_column("race_denma", "result_2_count_all_period")
    op.drop_column("race_denma", "result_3_count_all_period")
    op.drop_column("race_denma", "result_4_count_all_period")
    op.drop_column("race_denma", "result_1_count_grade_race")
    op.drop_column("race_denma", "result_2_count_grade_race")
    op.drop_column("race_denma", "result_3_count_grade_race")
    op.drop_column("race_denma", "result_4_count_grade_race")


def downgrade():
    pass
