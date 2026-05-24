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

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ports = 3000,3001,3002,9000; foreach ($port in $ports) { $listeners = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue; foreach ($listener in $listeners) { if ($listener.OwningProcess -gt 0) { Write-Host ('Stopping old process on port {0} (PID {1})...' -f $port, $listener.OwningProcess); Stop-Process -Id $listener.OwningProcess -Force -ErrorAction SilentlyContinue } } }"

call "node_modules\.bin\concurrently.cmd" ^
  --kill-others ^
  --names "back,front" ^
  --prefix-colors "magenta,cyan" ^
  "npm run start:server-dev" ^
  "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Write-Host 'Waiting for backend on http://localhost:3000...'; while ($true) { try { $c = [Net.Sockets.TcpClient]::new('127.0.0.1', 3000); $c.Close(); break } catch { Start-Sleep -Milliseconds 500 } }; npm run start:client"""

endlocal
