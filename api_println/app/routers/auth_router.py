import requests
from requests.exceptions import (
    Timeout,
    ConnectionError,
    RequestException
)

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.core.jwt import create_access_token
from app.core.config import FIREBASE_API_KEY

router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)


class LoginSchema(BaseModel):
    email: str
    password: str


@router.post("/login")
def login(data: LoginSchema):

    url = (
        "https://identitytoolkit.googleapis.com/v1/"
        f"accounts:signInWithPassword?key={FIREBASE_API_KEY}"
    )

    payload = {
        "email": data.email,
        "password": data.password,
        "returnSecureToken": True
    }

    try:
        response = requests.post(
            url,
            json=payload,
            timeout=10
        )

    except Timeout:
        raise HTTPException(
            status_code=504,
            detail="Tempo de conexão excedido ao autenticar."
        )

    except ConnectionError:
        raise HTTPException(
            status_code=503,
            detail="Serviço de autenticação indisponível."
        )

    except RequestException:
        raise HTTPException(
            status_code=500,
            detail="Erro interno ao conectar no serviço de autenticação."
        )

    # sucesso
    if response.status_code == 200:
        firebase_user = response.json()

        firebase_uid = firebase_user["localId"]

        token = create_access_token({
            "sub": firebase_uid
        })

        return {
            "access_token": token,
            "token_type": "bearer"
        }

    # credenciais inválidas
    if response.status_code in [400, 401]:
        raise HTTPException(
            status_code=401,
            detail="E-mail ou senha inválidos."
        )

    # chave inválida / config errada
    if response.status_code == 403:
        raise HTTPException(
            status_code=500,
            detail="Erro de configuração do serviço de autenticação."
        )

    # firebase fora do ar
    if response.status_code >= 500:
        raise HTTPException(
            status_code=503,
            detail="Serviço de autenticação temporariamente indisponível."
        )

    # fallback
    raise HTTPException(
        status_code=500,
        detail="Erro inesperado ao autenticar."
    )