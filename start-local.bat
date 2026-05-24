@echo off
setlocal

cd /d "%~dp0"

if not exist "node_modules\.bin\concurrently.cmd" (
  echo Dependencies are not installed.
  echo Run: npm install
  pause
  exit /b 1
)

echo Starting Waraxis locally...
echo Frontend: http://localhost:9000
echo Backend:  http://localhost:3000
echo.
echo Close this window or press Ctrl+C to stop both frontend and backend.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ports = 3000,3001,3002,9000; foreach ($port in $ports) { $listeners = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAct