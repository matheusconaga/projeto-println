from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.services.like_service import LikeService
from app.db.database import get_db


router = APIRouter(prefix="/posts", tags=["Likes"])

service = LikeService()


@router.post("/{post_id}/like")
def like_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.like_post(db, user_id, post_id)


@router.delete("/{post_id}/like")
def unlike_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.unlike_post(db, user_id, post_id)