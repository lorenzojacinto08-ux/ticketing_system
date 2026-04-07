@echo off
REM Double-click: starts the server in the background (no console) and opens the browser.
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_ticketing_silent.ps1"
if errorlevel 1 pause
