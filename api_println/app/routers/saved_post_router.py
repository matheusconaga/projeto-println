from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.services.saved_post_service import SavedPostService
from app.db.database import get_db


router = APIRouter(prefix="/saves", tags=["Saved Posts"])

service = SavedPostService()

@router.get("/user_saves")
def get_user_saves(user_id: str, db: Session = Depends(get_db)):
    
    if not user_id:
        return []
    
    return service.get_user_saves(db, user_id)

@router.post("/{post_id}/save")
def save_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.save_post(db, user_id, post_id)


@router.delete("/{post_id}/save")
def unsave_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.unsave_post(db, user_id, post_id)