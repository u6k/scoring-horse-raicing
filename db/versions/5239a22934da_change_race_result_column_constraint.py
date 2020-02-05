"""Change race_result column constraint

Revision ID: 5239a22934da
Revises: b03ed4210967
Create Date: 2020-02-05 02:35:36.353501

"""
from alembic import op


# revision identifiers, used by Alembic.
revision = '5239a22934da'
down_revision = 'b03ed4210967'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column("race_result", "result", nullable=True)
    op.alter_column("race_result", "horse_weight", nullable=True)
    op.alter_column("race_result", "horse_weight_diff", nullable=True)
    op.alter_column("race_result", "arrival_time", nullable=True)
    op.alter_column("race_result", "favorite_order", nullable=True)
    op.alter_column("race_result", "odds", nullable=True)


def downgrade():
    pass
