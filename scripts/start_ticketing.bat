@echo off
REM Double-click this on Windows to start the app.
REM Close the window or Ctrl+C to stop the server.

cd /d "%~dp0.."
if exist "venv\Scripts\python.exe" (
  "venv\Scripts\python.exe" app.py
) else (
  python app.py
)
if errorlevel 1 pause
