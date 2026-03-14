from sqlalchemy.orm import Session
from app.models.user import User
from app.repositories.user_repository import UserRepository

class UserService:

    def __init__(self):

        self.repo = UserRepository()


    def register_user(self, db: Session, data):

        user = self.repo.get_by_email(db, data.email)

        if user:
            return user

        # verificar username duplicado
        existing_username = db.query(User).filter(User.username == data.username).first()

        if existing_username:
            raise ValueError("Username already exists")

        new_user = User(
            id=data.firebase_uid,
            email=data.email,
            username=data.username.lower(),
            photo=data.photo
        )

        return self.repo.create(db, new_user)


    def get_by_email(self, db: Session, email: str):

        return self.repo.get_by_email(db, email)
    
    
    def update_user(self, db: Session, user_id: str, username: str = None, photo: str = None):

        user = self.repo.get_by_id(db, user_id)

        if not user:
            return None

        if username:

            if " " in username:
                raise ValueError("Username cannot contain spaces")

            exists = db.query(User).filter(User.username == username).first()

            if exists and exists.id != user_id:
                raise ValueError("Username already exists")

            user.username = username.lower()

        if photo:
            user.photo = photo

        db.commit()
        db.refresh(user)

        return user