from sqlalchemy import Column, String, ForeignKey, UniqueConstraint
from app.db.database import Base
import uuid


class SavedPost(Base):

    __tablename__ = "saved_posts"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))

    user_id = Column(String, nullable=False)
    post_id = Column(String, ForeignKey("posts.id", ondelete="CASCADE"), nullable=False)
    
    __table_args__ = (
        UniqueConstraint("user_id", "post_id", name="unique_saved_post"),
    )