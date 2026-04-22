from sqlalchemy.orm import Session, joinedload
from app.models.comment import Comment
from app.models.post import Post
from sqlalchemy.sql import func


class CommentRepository:

    def create_comment(self, db: Session, user_id: str, post_id: str, content: str):

        comment = Comment(
            user_id=user_id,
            post_id=post_id,
            content=content
        )

        db.add(comment)

        post = db.query(Post).filter(Post.id == post_id).first()
        post.comments_count += 1

        db.commit()

        return (
            db.query(Comment)
            .options(joinedload(Comment.user))
            .filter(Comment.id == comment.id)
            .first()
       )


    def get_comment(self, db: Session, comment_id: str):

        return db.query(Comment).filter(Comment.id == comment_id).first()


    def update_comment(self, db: Session, comment: Comment, content: str):

        comment.content = content
        comment.updated_at = func.now()

        db.commit()

        return (
            db.query(Comment)
            .options(joinedload(Comment.user))
            .filter(Comment.id == comment.id)
            .first()
        )


    def delete_comment(self, db: Session, comment: Comment):

        post = db.query(Post).filter(Post.id == comment.post_id).first()
        post.comments_count -= 1

        db.delete(comment)
        db.commit()