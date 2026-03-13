import uuid
from sqlalchemy import Column, String, DateTime
from sqlalchemy.sql import func
from app.db.database import Base

class User(Base):

    __tablename__ = "users"

    # Aqui recebe o mesmo uid do firebase
    id = Column(String, primary_key=True)
    email = Column(String, unique=True, nullable=False)
    username = Column(String, unique=True, nullable=False)
    photo = Column(String)

    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())