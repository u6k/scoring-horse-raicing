"""Change race payoff

Revision ID: 1b1b73815bca
Revises: 7d6d51528c4b
Create Date: 2020-03-15 07:51:46.425266

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '1b1b73815bca'
down_revision = '7d6d51528c4b'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column("race_payoff", "horse_number", new_column_name="horse_number_1")
    op.add_column("race_payoff", sa.Column("horse_number_2", sa.Integer, nullable=True))
    op.add_column("race_payoff", sa.Column("horse_number_3", sa.Integer, nullable=True))


def downgrade():
    pass
