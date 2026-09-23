@echo off
setlocal
cd /d "%~dp0.."
if exist node_modules rmdir /s /q node_modules
if exist apps\web\dist rmdir /s /q apps\web\dist
for /d /r %%d in (__pycache__) do @if exist "%%d" rmdir /s /q "%%d"
echo Cleaned generated files. Source code was not deleted.
pause
