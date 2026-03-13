from fastapi import Header, HTTPException
from app.core.firebase import verify_token

def get_current_user(authorization: str = Header(...)):

    try:
        token = authorization.split(" ")[1]
        decoded = verify_token(token)
        return decoded

    except:
        raise HTTPException(status_code=401, detail="Token inválido")