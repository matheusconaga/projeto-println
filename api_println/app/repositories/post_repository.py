from sqlalchemy.orm import Session,joinedload
from sqlalchemy import desc, func
from app.models.post import Post
from app.models.comment import Comment

class PostRepository:

    def create(self, db: Session, post: Post):

        db.add(post)
        db.commit()
        db.refresh(post)

        return post


    def get_all(self, db: Session):

        posts = db.query(Post).order_by(Post.created_at.desc()).all()

        feed = []

        for post in posts:

            preview_comment = (
            db.query(Comment)
            .filter(Comment.post_id == post.id)
            .order_by(Comment.created_at.desc())
            .first()
            )

            preview = None

            if preview_comment:
                preview = {
                    "user_id": preview_comment.user_id,
                    "content": preview_comment.content,
                    "created_at": preview_comment.created_at
                }

            feed.append({
                "id": post.id,
                "user_id": post.user_id,
                "content": post.content,
                "image_url": post.image_url,
                "location": post.location,
                "likes_count": post.likes_count,
                "comments_count": post.comments_count,
                "saves_count": post.saves_count,
                "created_at": post.created_at,
                "updated_at": post.updated_at,
                "preview_comment": preview
            })

        return feed
    
    def update(
        self,
        db: Session,
        post: Post,
        content: str,
        location: str,
        image_url: str | None,
        remove_image: bool
    ):

        post.content = content
        post.location = location

        if remove_image:
            post.image_url = None
        elif image_url is not None:
            post.image_url = image_url

        post.updated_at = func.now()

        db.commit()
        db.refresh(post)

        return post
    

    def get_by_id(self, db: Session, post_id: str):

        return db.query(Post).filter(Post.id == post_id).first()
    
    
    def get_feed(self, db: Session, page: int, limit: int):

        offset = (page - 1) * limit

        return (
            db.query(Post)
            .order_by(desc(Post.created_at))
            .limit(limit)
            .offset(offset)
            .all()
        )

    def get_post_with_comments(self, db: Session, post_id: str, limit_comments: int = 5):

        post = (
            db.query(Post)
            .options(
                joinedload(Post.user),
                joinedload(Post.comments).joinedload(Comment.user)
            )
            .filter(Post.id == post_id)
            .first()
        )

        if not post:
            return None

        comments = (
            db.query(Comment)
            .options(joinedload(Comment.user))
            .filter(Comment.post_id == post_id)
            .order_by(Comment.created_at.desc())
            .limit(limit_comments)
            .all()
        )

        comments_list = []

        for comment in comments:
            comments_list.append({
                "id": comment.id,
                "content": comment.content,
                "created_at": comment.created_at,
                "updated_at": comment.updated_at,
                "user": {
                    "id": comment.user.id,
                    "username": comment.user.username,
                    "photo": comment.user.photo
                }
            })

        return {
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
            },
            "comments_preview": comments_list
        }

    def delete(self, db: Session, post: Post):

        db.delete(post)
        db.commit()