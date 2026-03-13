from sqlalchemy.orm import Session
from app.repositories.saved_post_repository import SavedPostRepository


class SavedPostService:

    def __init__(self):
        self.repository = SavedPostRepository()


    def save_post(self, db: Session, user_id: str, post_id: str):

        saved = self.repository.get_saved(db, user_id, post_id)
        if saved:
            return {"message": "Post já salvo"}

        self.repository.save_post(db, user_id, post_id)
        return {"saved": True}


    def unsave_post(self, db: Session, user_id: str, post_id: str):

        saved = self.repository.get_saved(db, user_id, post_id)
        if not saved:
            return {"message": "Post não está salvo"}

        self.repository.remove_saved(db, saved)
        return {"saved": False}