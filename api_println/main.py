from fastapi import FastAPI
from app.routers.post_router import router as post_router
from app.routers.like_router import router as like_router
from app.routers.saved_post_router import router as saved_post_router
from app.routers.comment_router import router as comment_router
from app.routers.user_router import router as user_router


app = FastAPI(
    title="API do PrintLN",
    description="API da rede social",
    version="1.0.0"
)

app.include_router(user_router)
app.include_router(post_router)
app.include_router(like_router)
app.include_router(saved_post_router)
app.include_router(comment_router)