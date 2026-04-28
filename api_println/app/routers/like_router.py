from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.services.like_service import LikeService
from app.db.database import get_db
from app.core.security import get_current_user

router = APIRouter(
    prefix="/likes",
    tags=["Likes"]
)

service = LikeService()


@router.get("/user_likes")
def get_user_likes(
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    return service.get_user_likes(db, user_id)


@router.post("/{post_id}/like")
def like_post(
    post_id: str,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    return service.like_post(db, user_id, post_id)


@router.delete("/{post_id}/like")
def unlike_post(
    post_id: str,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    return service.unlike_post(db, user_id, post_id)