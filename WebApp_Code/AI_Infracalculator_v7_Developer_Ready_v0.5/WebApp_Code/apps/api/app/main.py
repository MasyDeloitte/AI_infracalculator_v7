from fastapi import FastAPI
from .api.v1.health import router as health_router
from .core.config import settings
app=FastAPI(title=settings.app_name, version='0.3.0')
app.include_router(health_router,prefix='/api/v1')
