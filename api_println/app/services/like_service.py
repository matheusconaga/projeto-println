from sqlalchemy.orm import Session
from app.repositories.like_repository import LikeRepository
from app.models.like import Like

class LikeService:

    def __init__(self):
        self.repository = LikeRepository()

    def get_user_likes(self, db: Session, user_id: str):
        likes = db.query(Like).filter(Like.user_id == user_id).all()
        return [like.post_id for like in likes]

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