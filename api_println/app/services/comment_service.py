from sqlalchemy.orm import Session
from app.repositories.comment_repository import CommentRepository

class CommentService:

    def __init__(self):
        self.repository = CommentRepository()


    def create_comment(self, db: Session, user_id: str, post_id: str, content: str):

        return self.repository.create_comment(db, user_id, post_id, content)


    def edit_comment(self, db: Session, comment_id: str, user_id: str, content: str):

        comment = self.repository.get_comment(db, comment_id)

        if not comment:
            return {"error": "Comentário não encontrado"}

        if comment.user_id != user_id:
            return {"error": "Você não pode editar este comentário"}

        return self.repository.update_comment(db, comment, content)


    def delete_comment(self, db: Session, comment_id: str, user_id: str):

        comment = self.repository.get_comment(db, comment_id)

        if not comment:
            return {"error": "Comentário não encontrado"}

        if comment.user_id != user_id:
            return {"error": "Você não pode excluir este comentário"}

        self.repository.delete_comment(db, comment)

        return {"message": "Comentário removido"}