from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.services.saved_post_service import SavedPostService
from app.db.database import get_db


router = APIRouter(prefix="/posts", tags=["Saved Posts"])

service = SavedPostService()



@router.post("/{post_id}/save")
def save_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.save_post(db, user_id, post_id)


@router.delete("/{post_id}/save")
def unsave_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.unsave_post(db, user_id, post_id)