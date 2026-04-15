from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class PreviewComment(BaseModel):
    user_id: str
    content: str
    created_at: datetime


class FeedPost(BaseModel):

    id: str
    user_id: str
    content: str
    image_url: Optional[str]
    location: Optional[str]

    likes_count: int
    comments_count: int
    saves_count: int

    created_at: datetime
    updated_at: datetime

    preview_comment: Optional[PreviewComment]