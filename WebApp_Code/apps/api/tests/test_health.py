from fastapi.testclient import TestClient
from app.main import app
def test_health(): assert TestClient(app).get('/api/v1/health').json()=={'status':'ok'}
