from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.services.comment_service import CommentService
from app.db.database import get_db


router = APIRouter(prefix="/comments", tags=["Comments"])

service = CommentService()


@router.post("/")
def create_comment(
    user_id: str,
    post_id: str,
    content: str,
    db: Session = Depends(get_db)
):

    return service.create_comment(db, user_id, post_id, content)


@router.put("/{comment_id}")
def edit_comment(
    comment_id: str,
    user_id: str,
    content: str,
    db: Session = Depends(get_db)
):

    return service.edit_comment(db, comment_id, user_id, content)


@router.delete("/{comment_id}")
def delete_comment(
    comment_id: str,
    user_id: str,
    db: Session = Depends(get_db)
):

    return service.delete_comment(db, comment_id, user_id)