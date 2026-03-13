from sqlalchemy import Column, String, DateTime, Text, Integer
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.db.database import Base
import uuid


class Post(Base):

    __tablename__ = "posts"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, nullable=False)

    content = Column(Text, nullable=False)
    image_url = Column(String)
    location = Column(String)

    likes_count = Column(Integer, default=0)
    comments_count = Column(Integer, default=0)
    saves_count = Column(Integer, default=0)
    
    likes = relationship("Like", cascade="all, delete", passive_deletes=True)
    comments = relationship("Comment", cascade="all, delete", passive_deletes=True)
    saves = relationship("SavedPost", cascade="all, delete", passive_deletes=True)

    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())