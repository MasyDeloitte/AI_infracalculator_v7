from pathlib import Path

content = r'''@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================================
rem AI Infrastructure Calculator v7 - Windows Development Workspace Setup
rem
rem Purpose:
rem   1. Prepare the local Git workspace.
rem   2. Create the WebApp_Code folder and P00 directory structure.
rem   3. Check required development tools.
rem   4. Optionally install missing tools through Windows Package Manager.
rem   5. Configure the Git remote safely without committing or pushing anything.
rem
rem This script does NOT overwrite application files, commit files, or push files.
rem ============================================================================

set "REPO_ROOT=C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline"
set "WEBAPP_ROOT=%REPO_ROOT%\WebApp_Code"
set "REPO_URL=https://github.com/MasyDeloitte/AI_infracalculator_v7.git"
set "BRANCH=main"
set "LOG_FILE=%REPO_ROOT%\windows_setup.log"

color 0A
title AI Infrastructure Calculator v7 - Windows Setup

call :log "============================================================"
call :log "AI Infrastructure Calculator v7 - Windows Setup"
call :log "Repository root: %REPO_ROOT%"
call :log "Web application root: %WEBAPP_ROOT%"
call :log "Git remote: %REPO_URL%"
call :log "============================================================"

echo.
echo This script will prepare the following location:
echo.
echo   %WEBAPP_ROOT%
echo.
echo It will not delete, overwrite, commit, or push application code.
echo.
choice /C YN /N /M "Continue with setup? [Y/N]: "
if errorlevel 2 goto :cancelled

rem ---------------------------------------------------------------------------
rem 1. Create repository and WebApp_Code directories.
rem ---------------------------------------------------------------------------
if not exist "%REPO_ROOT%\" (
    echo.
    echo Creating repository root...
    mkdir "%REPO_ROOT%"
    if errorlevel 1 goto :folder_fail
)

if not exist "%WEBAPP_ROOT%\" (
    echo Creating WebApp_Code...
    mkdir "%WEBAPP_ROOT%"
    if errorlevel 1 goto :folder_fail
)

rem ---------------------------------------------------------------------------
rem 2. Create the approved P00 folder skeleton only when folders are absent.
rem ---------------------------------------------------------------------------
echo.
echo Creating the P00 directory structure...
for %%D in (
    "apps\web"
    "apps\api"
    "apps\worker-calculation"
    "apps\worker-import"
    "apps\worker-report"
    "apps\worker-scheduler"
    "modules\identity"
    "modules\planning"
    "modules\validation"
    "modules\calculation"
    "modules\recommendation"
    "modules\consolidation"
    "modules\commercial"
    "modules\catalog"
    "modules\governance"
    "modules\reporting"
    "modules\audit"
    "contracts\openapi"
    "contracts\schemas"
    "contracts\events"
    "contracts\jobs"
    "platform\database"
    "platform\messaging"
    "platform\object-storage"
    "platform\observability"
    "platform\security"
    "tests\unit"
    "tests\integration"
    "tests\contract"
    "tests\security"
    "tests\accessibility"
    "tests\end-to-end"
    "deploy\docker"
    "deploy\kubernetes"
    "docs\architecture"
    "docs\decisions"
    "docs\development"
    "scripts"
    ".github\workflows"
) do (
    if not exist "%WEBAPP_ROOT%\%%~D\" mkdir "%WEBAPP_ROOT%\%%~D"
)

rem Keep empty directories visible to Git without overwriting existing files.
for /D /R "%WEBAPP_ROOT%" %%D in (*) do (
    dir /B "%%D" 2>nul | findstr . >nul
    if errorlevel 1 (
        if not exist "%%D\.gitkeep" type nul > "%%D\.gitkeep"
    )
)

rem ---------------------------------------------------------------------------
rem 3. Check Windows Package Manager.
rem ---------------------------------------------------------------------------
set "HAS_WINGET=0"
where winget >nul 2>&1
if not errorlevel 1 set "HAS_WINGET=1"

rem ---------------------------------------------------------------------------
rem 4. Check and optionally install development prerequisites.
rem ---------------------------------------------------------------------------
echo.
echo Checking development prerequisites...
call :check_or_install "Git" "git" "Git.Git"
call :check_or_install "Node.js LTS" "node" "OpenJS.NodeJS.LTS"
call :check_or_install "Python" "python" "Python.Python.3.12"
call :check_or_install "Docker Desktop" "docker" "Docker.DockerDesktop"

rem Refresh PATH for common machine and user installation locations.
set "PATH=%PATH%;%ProgramFiles%\Git\cmd;%ProgramFiles%\nodejs;%LocalAppData%\Programs\Python\Python312;%LocalAppData%\Programs\Python\Python312\Scripts"

rem ---------------------------------------------------------------------------
rem 5. Verify tools and show versions.
rem ---------------------------------------------------------------------------
echo.
echo Tool verification:
call :show_version "Git" "git --version"
call :show_version "Node.js" "node --version"
call :show_version "npm" "npm --version"
call :show_version "Python" "python --version"
call :show_version "pip" "python -m pip --version"
call :show_version "Docker" "docker --version"
call :show_version "Docker Compose" "docker compose version"

rem ---------------------------------------------------------------------------
rem 6. Configure Git repository safely.
rem ---------------------------------------------------------------------------
where git >nul 2>&1
if errorlevel 1 (
    echo.
    echo WARNING: Git is unavailable. Git repository configuration was skipped.
    echo Close and reopen Windows after installation, then run this script again.
    goto :summary
)

cd /d "%REPO_ROOT%"
if errorlevel 1 goto :folder_fail

if not exist ".git\" (
    echo.
    echo Initializing the local Git repository...
    git init -b "%BRANCH%"
    if errorlevel 1 goto :git_fail
) else (
    echo.
    echo Existing local Git repository detected.
)

git branch -M "%BRANCH%" >nul 2>&1

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo Adding the GitHub origin remote...
    git remote add origin "%REPO_URL%"
    if errorlevel 1 goto :git_fail
) else (
    for /f "delims=" %%R in ('git remote get-url origin') do set "CURRENT_REMOTE=%%R"
    if /I not "!CURRENT_REMOTE!"=="%REPO_URL%" (
        echo Updating origin from !CURRENT_REMOTE! to %REPO_URL%...
        git remote set-url origin "%REPO_URL%"
        if errorlevel 1 goto :git_fail
    ) else (
        echo GitHub origin is already correct.
    )
)

rem ---------------------------------------------------------------------------
rem 7. Create a safe root .gitignore only if one does not already exist.
rem ---------------------------------------------------------------------------
if not exist "%REPO_ROOT%\.gitignore" (
    echo Creating a safe root .gitignore...
    > "%REPO_ROOT%\.gitignore" (
        echo # Secrets and local environment files
        echo .env
        echo .env.*
        echo !.env.example
        echo *.pem
        echo *.key
        echo *.pfx
        echo *.p12
        echo.
        echo # Node.js
        echo node_modules/
        echo dist/
        echo build/
        echo coverage/
        echo .next/
        echo.
        echo # Python
        echo __pycache__/
        echo *.py[cod]
        echo .venv/
        echo venv/
        echo .pytest_cache/
        echo .mypy_cache/
        echo .ruff_cache/
        echo.
        echo # IDE and operating system
        echo .vscode/
        echo .idea/
        echo .DS_Store
        echo Thumbs.db
        echo.
        echo # Logs, runtime files and local databases
        echo *.log
        echo tmp/
        echo temp/
        echo *.db
        echo *.sqlite
        echo *.sqlite3
        echo.
        echo # Generated artifacts
        echo reports/generated/
        echo test-results/
        echo playwright-report/
    )
) else (
    echo Existing .gitignore preserved.
)

rem ---------------------------------------------------------------------------
rem 8. Create workspace metadata files only if absent.
rem ---------------------------------------------------------------------------
if not exist "%WEBAPP_ROOT%\.env.example" (
    > "%WEBAPP_ROOT%\.env.example" (
        echo # Example configuration only. Do not place real secrets here.
        echo APP_ENV=development
        echo APP_HOST=localhost
        echo APP_PORT=8000
        echo WEB_PORT=5173
        echo POSTGRES_HOST=localhost
        echo POSTGRES_PORT=5432
        echo POSTGRES_DB=ai_sizing
        echo POSTGRES_USER=ai_sizing_app
        echo POSTGRES_PASSWORD=REPLACE_LOCALLY_DO_NOT_COMMIT_REAL_PASSWORD
    )
)

if not exist "%WEBAPP_ROOT%\README.md" (
    > "%WEBAPP_ROOT%\README.md" (
        echo # AI Infrastructure Sizing Platform
        echo.
        echo This directory contains the production web application source code.
        echo.
        echo The application is being generated from the controlled requirements,
        echo architecture, formula, catalog, UX, and verification specifications.
        echo.
        echo P00 currently prepares the workspace only. Authoritative calculation,
        echo model selection, infrastructure sizing, BOM, and financial logic must
        echo not be invented or hard-coded.
    )
)

:summary
call :log "Workspace setup completed."
echo.
echo ================================================================
echo SETUP COMPLETE
echo ================================================================
echo.
echo Local repository:
echo   %REPO_ROOT%
echo.
echo Application code location:
echo   %WEBAPP_ROOT%
echo.
echo GitHub repository:
echo   %REPO_URL%
echo.
echo Important:
echo   - The folder structure is ready.
echo   - No application code was committed or pushed.
echo   - Reopen Windows Terminal if a tool was newly installed.
echo   - Docker Desktop may need to be started manually.
echo   - Never commit real .env values, passwords, tokens, or private keys.
echo.
echo Current Git status:
if exist "%REPO_ROOT%\.git\" (
    cd /d "%REPO_ROOT%"
    git status --short
)
echo.
echo Setup log:
echo   %LOG_FILE%
echo.
pause
exit /b 0

rem ============================================================================
rem Functions
rem ============================================================================

:check_or_install
set "TOOL_NAME=%~1"
set "TOOL_COMMAND=%~2"
set "WINGET_ID=%~3"
where "%TOOL_COMMAND%" >nul 2>&1
if not errorlevel 1 (
    echo   [OK] %TOOL_NAME% is installed.
    exit /b 0
)

echo   [MISSING] %TOOL_NAME%
if "%HAS_WINGET%"=="0" (
    echo     Windows Package Manager is unavailable. Install %TOOL_NAME% manually.
    exit /b 0
)

choice /C YN /N /M "Install %TOOL_NAME% using winget? [Y/N]: "
if errorlevel 2 (
    echo     Installation skipped.
    exit /b 0
)

echo     Installing %TOOL_NAME%...
winget install --id "%WINGET_ID%" --exact --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    color 0E
    echo     WARNING: Installation failed or was cancelled.
    color 0A
) else (
    echo     Installation command completed.
)
exit /b 0

:show_version
set "VERSION_NAME=%~1"
set "VERSION_COMMAND=%~2"
for /f "tokens=1" %%C in ("%VERSION_COMMAND%") do set "BASE_COMMAND=%%C"
where "!BASE_COMMAND!" >nul 2>&1
if errorlevel 1 (
    echo   [NOT AVAILABLE] %VERSION_NAME%
) else (
    echo   [%VERSION_NAME%]
    %VERSION_COMMAND% 2>&1
)
exit /b 0

:log
if not exist "%REPO_ROOT%\" exit /b 0
>> "%LOG_FILE%" echo [%DATE% %TIME%] %~1
exit /b 0

:folder_fail
color 0C
echo.
echo ERROR: The required folder could not be created or opened.
echo Verify the path and Windows permissions.
goto :failed

:git_fail
color 0C
echo.
echo ERROR: Git repository configuration failed.
echo Review the Git error shown above. No push was attempted.
goto :failed

:cancelled
color 0E
echo.
echo Setup cancelled. No files were pushed to GitHub.
pause
exit /b 2

:failed
call :log "Workspace setup failed."
echo.
echo Setup was not completed. No files were pushed to GitHub.
pause
exit /b 1
'''

path = Path('/mnt/data/Setup_AI_Infracalculator_v7_Windows.bat')
path.write_text(content, encoding='utf-8', newline='\r\n')
print(path)
print(path.stat().st_size)

