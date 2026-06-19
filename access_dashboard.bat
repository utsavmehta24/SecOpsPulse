@echo off
echo ================================
echo   SecOpsPulse Dashboard Access
echo ================================
echo.

REM Get WSL2 IP address
for /f %%i in ('wsl -d Ubuntu-22.04 bash -c "hostname -I | tr -d ' '"') do set WSL_IP=%%i

echo WSL2 IP Address: %WSL_IP%
echo.
echo Dashboard URLs:
echo   Main Dashboard: http://%WSL_IP%/
echo   Backup Report:  http://%WSL_IP%/security_report.html (if copied)
echo.
echo Opening dashboard in your default browser...
start http://%WSL_IP%/

echo.
echo Press any key to exit...
pause >nul