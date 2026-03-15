from fastapi import APIRouter, Depends, HTTPException, Form, UploadFile, File
from sqlalchemy.orm import Session


from app.schemas.user_schema import UserCreate, UserResponse
from app.services.user_service import UserService

from app.db.database import get_db
from app.services.cloudinary_service import upload_image

router = APIRouter(prefix="/users", tags=["Users"])

service = UserService()

# Teste para ver se o email existe ou nao 
@router.get("/email/{email}")
def check_email(email: str, db: Session = Depends(get_db)):

    user = service.get_by_email(db, email)

    if user:
        return {"exists": True}

    return {"exists": False}


@router.get("/firebase/{user_id}", response_model=UserResponse)
def get_user_by_firebase(user_id: str, db: Session = Depends(get_db)):
    user = service.repo.get_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# Para o cadastro do usuário 
@router.post("/register", response_model=UserResponse)
def register(data: UserCreate, db: Session = Depends(get_db)):

    return service.register_user(db, data)


@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: str, db: Session = Depends(get_db)):
    return service.repo.get_by_id(db, user_id)


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

@router.put("/update/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: str,
    username: str = Form(None),
    photo: UploadFile | None = File(None),
    remove_photo: bool = Form(False), 
    db: Session = Depends(get_db)
):

    photo_url = None

    if photo:
        photo_url = upload_image(photo.file)

    user = service.update_user(db, user_id, username, photo_url, remove_photo)

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return user