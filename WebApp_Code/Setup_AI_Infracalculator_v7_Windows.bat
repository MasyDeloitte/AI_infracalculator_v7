@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================================
rem AI Infrastructure Sizing Platform - Windows Development Setup
rem ============================================================================

set "REPO_ROOT=C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline"
set "APP_DIR=%REPO_ROOT%\WebApp_Code"
set "REPO_URL=https://github.com/MasyDeloitte/AI_infracalculator_v7.git"
set "BRANCH=main"

color 0A
title AI Infrastructure Sizing Platform - Windows Setup

echo.
echo ================================================================
echo   AI Infrastructure Sizing Platform - Windows Setup
 echo ================================================================
echo.
echo Repository root:
echo   %REPO_ROOT%
echo Application folder:
echo   %APP_DIR%
echo.

rem ---------------------------------------------------------------------------
rem 1. Create and validate local folders
rem ---------------------------------------------------------------------------
if not exist "%REPO_ROOT%\" (
    echo Creating repository root...
    mkdir "%REPO_ROOT%"
    if errorlevel 1 goto :folder_error
)

if not exist "%APP_DIR%\" (
    echo Creating WebApp_Code folder...
    mkdir "%APP_DIR%"
    if errorlevel 1 goto :folder_error
)

cd /d "%REPO_ROOT%"
if errorlevel 1 goto :folder_error

rem ---------------------------------------------------------------------------
rem 2. Check/install Git
rem ---------------------------------------------------------------------------
call :CheckCommand git "Git.Git" "Git"
if errorlevel 1 goto :failed

rem ---------------------------------------------------------------------------
rem 3. Configure local Git repository safely
rem ---------------------------------------------------------------------------
if not exist "%REPO_ROOT%\.git\" (
    echo.
    echo Git repository is not initialized locally.
    choice /C YN /N /M "Initialize this folder as the local Git repository? [Y/N]: "
    if errorlevel 2 goto :git_skipped

    git init -b "%BRANCH%"
    if errorlevel 1 goto :git_error
) else (
    echo Git repository already initialized.
)

git branch -M "%BRANCH%" >nul 2>&1

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
    if errorlevel 1 goto :git_error
) else (
    git remote set-url origin "%REPO_URL%"
    if errorlevel 1 goto :git_error
)

echo Git remote configured:
git remote -v

:git_skipped

rem ---------------------------------------------------------------------------
rem 4. Check/install development prerequisites
rem ---------------------------------------------------------------------------
call :CheckCommand python "Python.Python.3.12" "Python 3.12"
if errorlevel 1 goto :failed

call :CheckCommand node "OpenJS.NodeJS.LTS" "Node.js LTS"
if errorlevel 1 goto :failed

call :CheckCommand npm "OpenJS.NodeJS.LTS" "npm"
if errorlevel 1 goto :failed

call :CheckCommand docker "Docker.DockerDesktop" "Docker Desktop"
if errorlevel 1 (
    echo.
    echo Docker was not configured. Setup can continue, but containers will not run.
)

rem ---------------------------------------------------------------------------
rem 5. Display installed versions
rem ---------------------------------------------------------------------------
echo.
echo Installed tool versions:
echo ------------------------------------------------
git --version
python --version
node --version
npm --version
docker --version 2>nul

rem ---------------------------------------------------------------------------
rem 6. Create local environment file only when a template exists
rem ---------------------------------------------------------------------------
cd /d "%APP_DIR%"
if exist ".env.example" (
    if not exist ".env" (
        copy /Y ".env.example" ".env" >nul
        echo Created .env from .env.example.
        echo Review .env before starting the application.
    ) else (
        echo Existing .env preserved.
    )
) else (
    echo No .env.example exists yet. Environment setup skipped.
)

rem ---------------------------------------------------------------------------
rem 7. Set up Python backend if generated code exists
rem ---------------------------------------------------------------------------
set "PYTHON_PROJECT_FOUND=0"
if exist "requirements.txt" set "PYTHON_PROJECT_FOUND=1"
if exist "pyproject.toml" set "PYTHON_PROJECT_FOUND=1"
if exist "apps\api\requirements.txt" set "PYTHON_PROJECT_FOUND=1"
if exist "apps\api\pyproject.toml" set "PYTHON_PROJECT_FOUND=1"

if "!PYTHON_PROJECT_FOUND!"=="1" (
    echo.
    echo Python project detected.
    if not exist ".venv\Scripts\python.exe" (
        echo Creating Python virtual environment...
        python -m venv .venv
        if errorlevel 1 goto :python_error
    )

    call ".venv\Scripts\activate.bat"
    python -m pip install --upgrade pip
    if errorlevel 1 goto :python_error

    if exist "requirements.txt" (
        python -m pip install -r requirements.txt
        if errorlevel 1 goto :python_error
    )
    if exist "apps\api\requirements.txt" (
        python -m pip install -r "apps\api\requirements.txt"
        if errorlevel 1 goto :python_error
    )
    if exist "pyproject.toml" (
        python -m pip install -e .
        if errorlevel 1 goto :python_error
    )
    if exist "apps\api\pyproject.toml" (
        python -m pip install -e "apps\api"
        if errorlevel 1 goto :python_error
    )
    echo Python dependencies installed.
) else (
    echo No generated Python project detected yet. Python dependency setup skipped.
)

rem ---------------------------------------------------------------------------
rem 8. Set up frontend if generated code exists
rem ---------------------------------------------------------------------------
if exist "package.json" (
    echo.
    echo Root Node.js project detected. Installing dependencies...
    call npm install
    if errorlevel 1 goto :node_error
) else if exist "apps\web\package.json" (
    echo.
    echo Frontend project detected. Installing dependencies...
    pushd "apps\web"
    call npm install
    if errorlevel 1 (
        popd
        goto :node_error
    )
    popd
) else (
    echo No generated frontend project detected yet. npm setup skipped.
)

rem ---------------------------------------------------------------------------
rem 9. Run available quality checks
rem ---------------------------------------------------------------------------
echo.
echo Checking for available validation commands...

if exist "package.json" (
    call npm run lint --if-present
    if errorlevel 1 echo WARNING: Root lint command reported an issue.
    call npm test --if-present -- --run
    if errorlevel 1 echo WARNING: Root test command reported an issue.
)

if exist "apps\web\package.json" (
    pushd "apps\web"
    call npm run lint --if-present
    if errorlevel 1 echo WARNING: Frontend lint command reported an issue.
    call npm test --if-present -- --run
    if errorlevel 1 echo WARNING: Frontend test command reported an issue.
    popd
)

if exist ".venv\Scripts\python.exe" (
    if exist "tests\" (
        ".venv\Scripts\python.exe" -m pytest -q
        if errorlevel 1 echo WARNING: Python tests reported an issue.
    )
)

rem ---------------------------------------------------------------------------
rem 10. Optionally start Docker services
rem ---------------------------------------------------------------------------
if exist "docker-compose.yml" goto :offer_docker
if exist "compose.yml" goto :offer_docker
if exist "compose.yaml" goto :offer_docker
goto :complete

:offer_docker
echo.
choice /C YN /N /M "Start the application containers now? [Y/N]: "
if errorlevel 2 goto :complete

docker info >nul 2>&1
if errorlevel 1 (
    color 0E
    echo Docker Desktop is installed but is not running.
    echo Start Docker Desktop, then run this setup script again.
    goto :complete
)

docker compose up -d --build
if errorlevel 1 goto :docker_error

echo Docker services started.
docker compose ps

:complete
color 0A
echo.
echo ================================================================
echo SETUP COMPLETE
echo.
echo Application folder:
echo   %APP_DIR%
echo.
echo GitHub destination:
echo   https://github.com/MasyDeloitte/AI_infracalculator_v7/tree/main/WebApp_Code
echo.
echo The script installed/configured only the components that were available.
echo When generated source code is copied into WebApp_Code, run this script again.
echo ================================================================
echo.
pause
exit /b 0

rem ---------------------------------------------------------------------------
rem Helper: Check command and optionally install with winget
rem ---------------------------------------------------------------------------
:CheckCommand
set "COMMAND_NAME=%~1"
set "WINGET_ID=%~2"
set "DISPLAY_NAME=%~3"

where "%COMMAND_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo [OK] %DISPLAY_NAME% detected.
    exit /b 0
)

echo.
echo %DISPLAY_NAME% is not installed or is not available in PATH.
where winget >nul 2>&1
if errorlevel 1 (
    color 0C
    echo ERROR: winget is unavailable. Install %DISPLAY_NAME% manually and rerun.
    exit /b 1
)

choice /C YN /N /M "Install %DISPLAY_NAME% using winget? [Y/N]: "
if errorlevel 2 (
    echo %DISPLAY_NAME% installation skipped.
    exit /b 1
)

winget install --id "%WINGET_ID%" --exact --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    color 0C
    echo ERROR: Installation of %DISPLAY_NAME% failed.
    exit /b 1
)

echo.
echo %DISPLAY_NAME% was installed.
echo Close and rerun this script so Windows can refresh PATH.
pause
exit /b 1

:folder_error
color 0C
echo ERROR: The local project folders could not be created or opened.
goto :failed

:git_error
color 0C
echo ERROR: Git repository configuration failed.
goto :failed

:python_error
color 0C
echo ERROR: Python environment or dependency setup failed.
goto :failed

:node_error
color 0C
echo ERROR: Node.js dependency setup failed.
goto :failed

:docker_error
color 0C
echo ERROR: Docker services failed to start.
goto :failed

:failed
echo.
echo SETUP DID NOT COMPLETE.
echo Review the error above, correct it, and run this script again.
echo No force push or destructive Git operation was performed.
echo.
pause
exit /b 1
