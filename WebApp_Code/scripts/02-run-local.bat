@echo off
setlocal
cd /d "%~dp0.."
start "AI Sizing API" cmd /k "cd /d %cd%\apps\api && call .venv\Scripts\activate.bat && python -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000"
start "AI Sizing Web" cmd /k "cd /d %cd% && npm run dev"
timeout /t 4 >nul
start http://127.0.0.1:5173
