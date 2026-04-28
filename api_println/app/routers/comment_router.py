from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.services.comment_service import CommentService
from app.db.database import get_db
from app.core.security import get_current_user

router = APIRouter(
    prefix="/comments",
    tags=["Comments"]
)

service = CommentService()


@router.post("/")
def create_comment(
    post_id: str,
    content: str,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    return service.create_comment(
        db,
        user_id,
        post_id,
        content
    )


@router.put("/{comment_id}")
def edit_comment(
    comment_id: str,
    content: str,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    return service.edit_comment(
        db,
        comment_id,
        user_id,
        content
    )


@router.delete("/{comment_id}")
def delete_comment(
    comment_id: str,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    return service.delete_comment(
        db,
        comment_id,
        user_id
    )