from fastapi import APIRouter, Depends, HTTPException, Form, UploadFile, File
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.schemas.user_schema import UserCreate, UserResponse
from app.services.user_service import UserService
from app.db.database import get_db
from app.services.cloudinary_service import upload_image

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)

service = UserService()


@router.get("/email/{email}")
def check_email(
    email: str,
    db: Session = Depends(get_db)
):
    user = service.get_by_email(db, email)

    return {"exists": user is not None}


@router.get("/firebase/{user_id}", response_model=UserResponse)
def get_user_by_firebase(
    user_id: str,
    db: Session = Depends(get_db)
):
    user = service.repo.get_by_id(db, user_id)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return user


@router.post("/register", response_model=UserResponse)
def register(
    data: UserCreate,
    db: Session = Depends(get_db)
):
    return service.register_user(db, data)


@router.get("/me", response_model=UserResponse)
def get_me(
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    user = service.repo.get_by_id(db, user_id)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return user


@router.get("/{user_id}", response_model=UserResponse)
def get_user(
    user_id: str,
    db: Session = Depends(get_db)
):
    user = service.repo.get_by_id(db, user_id)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return user


@router.post("/register-form", response_model=UserResponse)
async def register_form(
    id: str = Form(...),
    email: str = Form(...),
    username: str = Form(...),
    photo: UploadFile | None = File(None),
    db: Session = Depends(get_db)
):
    photo_url = None

    if photo and photo.filename != "":
        photo_url = upload_image(photo.file, "users")

    data = UserCreate(
        firebase_uid=id,
        email=email,
        username=username,
        photo=photo_url
    )

    return service.register_user(db, data)


@router.put("/update", response_model=UserResponse)
async def update_user(
    username: str | None = Form(None),
    photo: UploadFile | None = File(None),
    remove_photo: bool = Form(False),
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    user_id = current_user["uid"]

    photo_url = None

    if photo and photo.filename != "":
        photo_url = upload_image(photo.file, "users")

    user = service.update_user(
        db,
        user_id,
        username,
        photo_url,
        remove_photo
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return user