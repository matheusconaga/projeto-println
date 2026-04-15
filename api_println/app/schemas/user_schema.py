from pydantic import BaseModel, field_validator
from typing import Optional
from datetime import datetime

class UserCreate(BaseModel):

    firebase_uid: str
    email: str
    username: str
    photo: Optional[str]

    @field_validator("username")
    def validate_username(cls, v):

        if " " in v:
            raise ValueError("Username cannot contain spaces")

        return v.lower()


class UserResponse(BaseModel):

    id: str
    email: str
    username: Optional[str]
    photo: Optional[str]
    created_at: datetime

    class Config:
        from_attributes = True