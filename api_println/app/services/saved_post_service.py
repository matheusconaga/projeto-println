from sqlalchemy.orm import Session
from app.repositories.saved_post_repository import SavedPostRepository
from app.models.saved_post import SavedPost
from app.models.post import Post

class SavedPostService:

    def __init__(self):
        self.repository = SavedPostRepository()

    def get_user_saves(self, db: Session, user_id: str):
        saves = (
            db.query(SavedPost)
            .filter(SavedPost.user_id == user_id)
            .order_by(SavedPost.created_at.desc())
            .all()
        )

        post_ids = [save.post_id for save in saves]

        posts = db.query(Post).filter(Post.id.in_(post_ids)).all()

        posts_dict = {post.id: post for post in posts}
        ordered_posts = [posts_dict[post_id] for post_id in post_ids if post_id in posts_dict]

        result = []
        for post in ordered_posts:
            result.append({
                "id": post.id,
                "content": post.content,
                "image_url": post.image_url,
                "location": post.location,
                "likes_count": post.likes_count,
                "comments_count": post.comments_count,
                "saves_count": post.saves_count,
                "created_at": post.created_at,
                "updated_at": post.updated_at,
                "user": {
                    "id": post.user.id,
                    "username": post.user.username,
                    "photo": post.user.photo
                }
            })
        return result


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