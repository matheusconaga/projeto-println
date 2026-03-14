from fastapi import APIRouter, UploadFile, File, Form, Depends
from sqlalchemy.orm import Session

from app.services.cloudinary_service import upload_image
from app.services.post_service import PostService
from app.db.database import get_db
from app.core.security import get_current_user



router = APIRouter(prefix="/posts", tags=["Posts"])

service = PostService()


@router.post("/")
async def create_post(
    content: str = Form(...),
    location: str | None = Form(None),
    image: UploadFile | None = File(None),
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):

    user_id = current_user["uid"]

    image_url = None

    if image and image.filename != "":
        image_url = upload_image(image.file)

    post = service.create_post(
        db,
        user_id,
        content,
        image_url,
        location
    )

    return post


@router.get("/feed")
def get_feed(
    page: int = 1,
    limit: int = 10,
    db: Session = Depends(get_db)
):

    return service.get_feed(db, page, limit)

@router.put("/{post_id}")
async def edit_post(
    post_id: str,
    content: str = Form(...),
    location: str = Form(None),
    image: UploadFile | None = File(None),
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):

    user_id = current_user["uid"]

    image_url = None

    if image and image.filename != "":
        image_url = upload_image(image.file, "posts")

    return service.edit_post(
        db,
        post_id,
        user_id,
        content,
        location,
        image_url
    )
    
@router.get("/{post_id}")
def get_post_details(post_id: str, db: Session = Depends(get_db)):

    return service.get_post_details(db, post_id)

@router.delete("/{post_id}")
def delete_post(
    post_id: str,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):

    user_id = current_user["uid"]

    return service.delete_post(db, post_id, user_id)