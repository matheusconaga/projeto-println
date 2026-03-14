import cloudinary
import cloudinary.uploader
from app.core.config import CLOUD_NAME, CLOUD_API_KEY, CLOUD_API_SECRET


cloudinary.config(
    cloud_name=CLOUD_NAME,
    api_key=CLOUD_API_KEY,
    api_secret=CLOUD_API_SECRET
)

def upload_image(file, folder="general"):

    result = cloudinary.uploader.upload(
        file,
        folder=folder
    )

    return result["secure_url"]