from sqlalchemy import Column, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class Comment(Base):

    __tablename__ = "comments"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))

    post_id = Column(String, ForeignKey("posts.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(String, ForeignKey("users.id"), nullable=False)

    content = Column(Text, nullable=False)

    user = relationship("User")

    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime)