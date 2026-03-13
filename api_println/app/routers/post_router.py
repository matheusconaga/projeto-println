from fastapi import APIRouter, UploadFile, File, Form, Depends
from sqlalchemy.orm import Session

from app.services.cloudinary_service import upload_image
from app.services.post_service import PostService
from app.db.database import get_db


router = APIRouter(prefix="/posts", tags=["Posts"])

service = PostService()


@router.post("/")
async def create_post(
    user_id: str = Form(...),
    content: str = Form(...),
    location: str = Form(None),
    image: UploadFile = File(None),
    db: Session = Depends(get_db)
):

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
    user_id: str = Form(...),
    content: str = Form(...),
    location: str = Form(None),
    image: UploadFile = File(None),
    db: Session = Depends(get_db)
):

    return service.edit_post(
        db,
        post_id,
        user_id,
        content,
        location,
        image
    )
    
@router.get("/{post_id}")
def get_post_details(post_id: str, db: Session = Depends(get_db)):

    return service.get_post_details(db, post_id)

@router.delete("/{post_id}")
def delete_post(post_id: str, user_id: str, db: Session = Depends(get_db)):

    return service.delete_post(db, post_id, user_id)