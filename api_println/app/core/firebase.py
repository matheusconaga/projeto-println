import os
import json
import firebase_admin
from firebase_admin import credentials
from app.core.config import FIREBASE_CREDENTIALS_JSON

if not firebase_admin._apps:
    cred_dict = json.loads(FIREBASE_CREDENTIALS_JSON)
    cred = credentials.Certificate(cred_dict)
    firebase_admin.initialize_app(cred)