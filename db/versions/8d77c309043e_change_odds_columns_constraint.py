"""Change odds columns constraint

Revision ID: 8d77c309043e
Revises: 5239a22934da
Create Date: 2020-02-05 06:49:47.434023

"""
from alembic import op


# revision identifiers, used by Alembic.
revision = '8d77c309043e'
down_revision = '5239a22934da'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column("odds_win", "odds", nullable=True)
    op.alter_column("odds_place", "odds_min", nullable=True)
    op.alter_column("odds_place", "odds_max", nullable=True)


def downgrade():
    pass
