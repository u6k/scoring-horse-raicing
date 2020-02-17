"""2_7_0

Revision ID: 7d6d51528c4b
Revises: d5f402a2185d
Create Date: 2020-02-17 04:56:36.646379

"""
from alembic import op


# revision identifiers, used by Alembic.
revision = '7d6d51528c4b'
down_revision = 'd5f402a2185d'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column("race_denma", "bracket_number", nullable=True)
    op.alter_column("race_denma", "horse_number", nullable=True)


def downgrade():
    pass
