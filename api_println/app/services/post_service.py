from sqlalchemy.orm import Session
from app.models.post import Post
from app.repositories.post_repository import PostRepository
from app.services.cloudinary_service import upload_image

class PostService:

    def __init__(self):
        self.repository = PostRepository()


    def create_post(self, db: Session, user_id, content, image_url, location):

        post = Post(
            user_id=user_id,
            content=content,
            image_url=image_url,
            location=location
        )

        return self.repository.create(db, post)


    def get_feed(self, db, page, limit):

        offset = (page - 1) * limit

        posts = (
            db.query(Post)
            .order_by(Post.created_at.desc())
            .offset(offset)
            .limit(limit)
            .all()
        )

        result = []

        for post in posts:

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
    
    
    def edit_post(
        self,
        db: Session,
        post_id: str,
        user_id: str,
        content: str,
        location: str,
        image_url: str | None,
        remove_image: bool
    ):

        post = self.repository.get_by_id(db, post_id)

        if not post:
            return {"error": "Post não encontrado"}

        if post.user_id != user_id:
            return {"error": "Você não pode editar este post"}

        return self.repository.update(
            db,
            post,
            content,
            location,
            image_url,
            remove_image
        )
        
    def get_post_details(self, db: Session, post_id: str):

        post = self.repository.get_post_with_comments(db, post_id)

        if not post:
            return {"error": "Post não encontrado"}

        return post


    def delete_post(self, db: Session, post_id: str, user_id: str):

        post = self.repository.get_by_id(db, post_id)

        if not post:
            raise Exception("Post não encontrado")

        if post.user_id != user_id:
            raise Exception("Você não pode deletar este post")

        self.repository.delete(db, post)

        return {"message": "Post deletado"}