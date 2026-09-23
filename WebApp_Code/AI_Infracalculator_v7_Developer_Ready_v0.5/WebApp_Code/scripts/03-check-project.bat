@echo off
setlocal
cd /d "%~dp0.."
echo Running frontend checks...
call npm run check || exit /b 1
echo Running backend tests...
call apps\api\.venv\Scripts\activate.bat
cd apps\api
pytest || exit /b 1
echo [PASS] All available checks passed.
pause
