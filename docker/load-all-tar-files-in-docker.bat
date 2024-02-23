@echo off 

For %%i in ("%~dp0/*.tar")do docker load -i "%%~i"

pause