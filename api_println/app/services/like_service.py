from sqlalchemy.orm import Session
from app.repositories.like_repository import LikeRepository


class LikeService:

    def __init__(self):
        self.repository = LikeRepository()


    def like_post(self, db: Session, user_id: str, post_id: str):
        like = self.repository.get_like(db, user_id, post_id)
        if like:
            return {"message": "Post já curtido"}

        self.repository.create_like(db, user_id, post_id)
        return {"liked": True}


    def unlike_post(self, db: Session, user_id: str, post_id: str):
        like = self.repository.get_like(db, user_id, post_id)
        if not like:
            return {"message": "Like não encontrado"}

        self.repository.remove_like(db, like)
        return {"liked": False}