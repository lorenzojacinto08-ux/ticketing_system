@echo off
REM Stops the background server started by start_ticketing_silent.bat / PowerShell launcher.
cd /d "%~dp0.."
set PIDFILE=.ticketing_server.pid

if exist "%PIDFILE%" (
  for /f "usebackq tokens=*" %%A in ("%PIDFILE%") do (
    taskkill /PID %%A /F >nul 2>nul
    if not errorlevel 1 (
      del "%PIDFILE%"
      echo Stopped server PID %%A.
      goto :done
    )
  )
  del "%PIDFILE%" 2>nul
)

echo Trying to free port 5000 ...
for /f "tokens=5" %%P in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
  taskkill /PID %%P /F >nul 2>nul && echo Stopped process on port 5000. && goto :done
)

echo No running server found (port 5000 or pid file).
:done
pause
