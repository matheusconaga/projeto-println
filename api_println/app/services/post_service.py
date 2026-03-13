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


    def get_feed(self, db: Session, page: int, limit: int):

        return self.repository.get_feed(db, page, limit)
    
    
    def edit_post(
        self,
        db: Session,
        post_id: str,
        user_id: str,
        content: str,
        location: str,
        image
    ):

        post = self.repository.get_by_id(db, post_id)

        if not post:
            return {"error": "Post não encontrado"}

        if post.user_id != user_id:
            return {"error": "Você não pode editar este post"}

        image_url = None

        if image and image.filename != "":
            image_url = upload_image(image.file)

        return self.repository.update(
            db,
            post,
            content,
            location,
            image_url
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