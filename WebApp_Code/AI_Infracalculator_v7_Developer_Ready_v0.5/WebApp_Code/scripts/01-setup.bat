@echo off
setlocal
cd /d "%~dp0.."
where node >nul 2>&1 || (echo [ERROR] Install Node.js 20.19 or later.& pause& exit /b 1)
where python >nul 2>&1 || (echo [ERROR] Install Python 3.12.& pause& exit /b 1)
echo Installing web dependencies...
call npm install || exit /b 1
if not exist apps\api\.venv python -m venv apps\api\.venv
call apps\api\.venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r apps\api\requirements.txt || exit /b 1
if not exist .env copy .env.example .env >nul
echo [OK] Setup complete. Run scripts\02-run-local.bat
pause
