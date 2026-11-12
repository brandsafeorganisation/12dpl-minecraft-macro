@echo off
rem Build cubeland.exe on Windows.
rem Needs Python 3 (python.org) and a MinGW-w64 g++ with cpp on the PATH,
rem for example w64devkit (github.com/skeeto/w64devkit) or MSYS2 (mingw64).
rem The result is build\cubeland.exe; worlds are saved next to it.
setlocal
cd /d "%~dp0"
if not exist build mkdir build

set PY=python
where %PY% >nul 2>nul || set PY=py
where %PY% >nul 2>nul || (echo Python 3 was not found. Install it from python.org. & goto :fail)
where g++ >nul 2>nul || (echo g++ was not found. Install w64devkit or MSYS2 mingw64 and add its bin folder to PATH. & goto :fail)

echo Translating the macro to C++ ...
%PY% ..\test_harness\translate.py ..\.. cubeland.4dm build\game.cpp || goto :fail

echo Compiling ...
g++ -O2 -std=c++17 -w -DCUBELAND_DESKTOP -I..\test_harness build\game.cpp desktop.cpp ^
    -o build\cubeland.exe -mwindows -static -lgdi32 -luser32 -lcomdlg32 || goto :fail

echo.
echo Built build\cubeland.exe - double-click it to play.
exit /b 0

:fail
echo.
echo Build failed.
exit /b 1
