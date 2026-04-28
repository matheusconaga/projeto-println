from jose import jwt, JWTError
from fastapi import HTTPException, Depends
from fastapi.security import HTTPBearer

from app.core.config import SECRET_KEY, ALGORITHM

security = HTTPBearer()


def get_current_user(credentials=Depends(security)):
    token = credentials.credentials

    try:
        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )

        return {
            "uid": payload["sub"]
        }

    except JWTError:
        raise HTTPException(
            status_code=401,
            detail="Token inválido"
        )