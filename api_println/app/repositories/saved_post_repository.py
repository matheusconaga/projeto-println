from sqlalchemy.orm import Session
from app.models.saved_post import SavedPost
from app.models.post import Post


class SavedPostRepository:

    def get_saved(self, db: Session, user_id: str, post_id: str):

        return db.query(SavedPost).filter(
            SavedPost.user_id == user_id,
            SavedPost.post_id == post_id
        ).first()


    def save_post(self, db: Session, user_id: str, post_id: str):

        saved = SavedPost(
            user_id=user_id,
            post_id=post_id
        )

        db.add(saved)

        post = db.query(Post).filter(Post.id == post_id).first()
        post.saves_count += 1

        db.commit()

        return saved


    def remove_saved(self, db: Session, saved: SavedPost):

        post = db.query(Post).filter(Post.id == saved.post_id).first()
        post.saves_count -= 1

        db.delete(saved)
        db.commit()