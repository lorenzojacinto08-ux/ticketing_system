@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0.."
echo ========================================
echo  Ticketing System - Windows setup
echo ========================================
echo.

where python >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Python was not found in PATH.
  echo.
  echo Install Python 3.10+ from: https://www.python.org/downloads/
  echo During setup, CHECK: "Add python.exe to PATH"
  echo Then open a NEW Command Prompt and run this script again.
  echo.
  pause
  exit /b 1
)

for /f "tokens=*" %%V in ('python -c "import sys; print(sys.version_info[0:2] >= (3, 10))" 2^>nul') do set OK=%%V
if /i not "!OK!"=="True" (
  echo [WARNING] Python 3.10 or newer is recommended.
  echo.
)

echo [1/3] Creating virtual environment in .\venv ...
python -m venv venv
if errorlevel 1 (
  echo [ERROR] Failed to create venv.
  pause
  exit /b 1
)

echo [2/3] Installing dependencies ...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
  echo [ERROR] pip install failed.
  pause
  exit /b 1
)

echo [3/3] Environment file ...
if not exist .env (
  if exist .env.example (
    copy /Y .env.example .env >nul
    echo Created .env from .env.example — edit it with your MySQL password and database name.
  ) else (
    echo No .env.example found — create a .env file manually.
  )
) else (
  echo .env already exists — not overwritten.
)

echo.
echo ========================================
echo  Setup finished.
echo ========================================
echo.
echo You still need:
echo   - MySQL Server or MariaDB installed and running
echo   - Database created and schema imported (see WINDOWS_SETUP.md)
echo   - .env updated with DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
echo.
echo Start the app: double-click scripts\start_ticketing_silent.bat
echo Or with a console window: scripts\start_ticketing.bat
echo.
pause
