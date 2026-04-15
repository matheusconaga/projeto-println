import firebase_admin
from firebase_admin import credentials
import os

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

cred_path = os.path.join(BASE_DIR, "core", "firebase_service_account.json")

if not firebase_admin._apps:

    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)