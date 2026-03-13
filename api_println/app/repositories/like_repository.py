from sqlalchemy.orm import Session
from app.models.like import Like
from app.models.post import Post


class LikeRepository:

    def get_like(self, db: Session, user_id: str, post_id: str):
        return db.query(Like).filter(
            Like.user_id == user_id,
            Like.post_id == post_id
        ).first()


    def create_like(self, db: Session, user_id: str, post_id: str):

        like = Like(
            user_id=user_id,
            post_id=post_id
        )

        db.add(like)

        post = db.query(Post).filter(Post.id == post_id).first()
        post.likes_count += 1

        db.commit()

        return like


    def remove_like(self, db: Session, like: Like):

        post = db.query(Post).filter(Post.id == like.post_id).first()
        post.likes_count -= 1

        db.delete(like)
        db.commit()