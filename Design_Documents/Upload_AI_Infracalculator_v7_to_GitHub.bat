@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================================
rem AI Infrastructure Calculator v7 - GitHub Upload Script
rem Uploads the contents of the configured local folder to the configured repo.
rem ============================================================================

set "PROJECT_DIR=C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline"
set "REPO_URL=https://github.com/MasyDeloitte/AI_infracalculator_v7.git"
set "BRANCH=main"
set "COMMIT_MESSAGE=Update AI infrastructure calculator v7"

color 0A
title Upload AI Infrastructure Calculator v7 to GitHub

echo.
echo ================================================================
echo   AI Infrastructure Calculator v7 - GitHub Upload
 echo ================================================================
echo.
echo Project folder:
echo   %PROJECT_DIR%
echo.
echo Repository:
echo   %REPO_URL%
echo.

rem Check project directory.
if not exist "%PROJECT_DIR%\" (
    color 0C
    echo ERROR: The project folder does not exist.
    echo Verify PROJECT_DIR at the top of this BAT file.
    goto :fail
)

rem Check Git installation.
where git >nul 2>&1
if errorlevel 1 (
    color 0C
    echo ERROR: Git is not installed or is not available in PATH.
    echo Install Git for Windows, reopen this script, and try again.
    goto :fail
)

cd /d "%PROJECT_DIR%"
if errorlevel 1 (
    color 0C
    echo ERROR: Could not open the project folder.
    goto :fail
)

echo Checking for files that are commonly sensitive...
set "SENSITIVE_FOUND=0"
for %%F in (.env .env.local .env.production id_rsa id_ed25519) do (
    if exist "%%F" (
        echo   WARNING: Found %%F
        set "SENSITIVE_FOUND=1"
    )
)
for %%P in (*.pem *.key *.pfx *.p12) do (
    if exist "%%P" (
        echo   WARNING: Found %%P
        set "SENSITIVE_FOUND=1"
    )
)

if "!SENSITIVE_FOUND!"=="1" (
    color 0E
    echo.
    echo WARNING: Potentially sensitive files were detected.
    echo Do not upload passwords, tokens, API keys, private certificates,
    echo customer data, confidential quotations, or production .env files.
    echo.
    choice /C YN /N /M "Continue only after checking .gitignore? [Y/N]: "
    if errorlevel 2 goto :cancelled
)

rem Initialize Git if required.
if not exist ".git\" (
    echo.
    echo Initializing Git repository...
    git init -b "%BRANCH%"
    if errorlevel 1 goto :git_fail
) else (
    echo Existing Git repository detected.
)

rem Ensure branch name.
git branch -M "%BRANCH%"
if errorlevel 1 goto :git_fail

rem Configure origin.
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo Adding GitHub remote...
    git remote add origin "%REPO_URL%"
    if errorlevel 1 goto :git_fail
) else (
    echo Updating GitHub remote URL...
    git remote set-url origin "%REPO_URL%"
    if errorlevel 1 goto :git_fail
)

rem Show files before staging.
echo.
echo Current repository status:
git status --short

echo.
echo IMPORTANT: Review the folder and .gitignore before continuing.
choice /C YN /N /M "Stage and upload all non-ignored files? [Y/N]: "
if errorlevel 2 goto :cancelled

rem Stage all additions, modifications, and deletions.
echo.
echo Staging files...
git add -A
if errorlevel 1 goto :git_fail

echo.
echo Staged changes:
git status --short

echo.
choice /C YN /N /M "Commit and push these staged changes? [Y/N]: "
if errorlevel 2 goto :cancelled

rem Commit only if staged changes exist.
git diff --cached --quiet
if errorlevel 1 (
    echo.
    echo Creating commit...
    git commit -m "%COMMIT_MESSAGE%"
    if errorlevel 1 goto :commit_fail
) else (
    echo.
    echo No new local changes need to be committed.
)

rem Fetch remote state. A missing/empty remote branch is allowed.
echo.
echo Checking remote repository...
git fetch origin
if errorlevel 1 (
    echo.
    echo NOTE: Fetch failed. Authentication may be required, or the remote
    echo repository may not yet contain a branch. The script will try to push.
)

rem If origin/main exists, integrate it without destructive force pushing.
git show-ref --verify --quiet "refs/remotes/origin/%BRANCH%"
if not errorlevel 1 (
    echo Remote branch origin/%BRANCH% exists. Integrating remote changes...
    git pull origin "%BRANCH%" --no-rebase --allow-unrelated-histories
    if errorlevel 1 (
        color 0E
        echo.
        echo MERGE CONFLICT OR PULL FAILURE.
        echo Resolve conflicts in the project folder, then run this script again.
        echo The script will not force-push or overwrite the remote history.
        goto :fail
    )
)

rem Push to GitHub.
echo.
echo Pushing to GitHub...
git push -u origin "%BRANCH%"
if errorlevel 1 goto :push_fail

color 0A
echo.
echo ================================================================
echo SUCCESS: Project files were pushed to GitHub.
echo Repository: https://github.com/MasyDeloitte/AI_infracalculator_v7
 echo ================================================================
echo.
git status
pause
exit /b 0

:commit_fail
color 0C
echo.
echo ERROR: Commit failed.
echo If Git requested an identity, run:
echo   git config --global user.name "MasyDeloitte"
echo   git config --global user.email "YOUR_GITHUB_EMAIL"
goto :fail

:push_fail
color 0C
echo.
echo ERROR: Push failed.
echo Sign in through Git Credential Manager or use a GitHub personal access
 echo token when prompted. Do not place a token inside this BAT file.
goto :fail

:git_fail
color 0C
echo.
echo ERROR: A Git command failed. Review the message shown above.
goto :fail

:cancelled
color 0E
echo.
echo Upload cancelled. No force push was performed.
pause
exit /b 2

:fail
echo.
echo Upload was not completed.
pause
exit /b 1
