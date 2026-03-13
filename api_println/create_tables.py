from app.db.database import Base, engine
from app.models.user import User
from app.models.post import Post
from app.models.like import Like
from app.models.saved_post import SavedPost
from app.models.comment import Comment

Base.metadata.create_all(bind=engine)

