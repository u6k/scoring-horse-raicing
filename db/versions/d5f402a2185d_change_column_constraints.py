"""change column constraints

Revision ID: d5f402a2185d
Revises: 75bef99da15a
Create Date: 2020-02-10 07:46:42.045712

"""
from alembic import op


# revision identifiers, used by Alembic.
revision = 'd5f402a2185d'
down_revision = '75bef99da15a'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column("race_payoff", "favorite_order", nullable=True)


def downgrade():
    pass
