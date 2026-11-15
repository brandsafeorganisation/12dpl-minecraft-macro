@echo off
rem Build cubeland.exe (the game) and cubeland_test.exe (the test build) on Windows.
rem Needs Python 3 (python.org) and a MinGW-w64 g++ with cpp on the PATH,
rem for example w64devkit (github.com/skeeto/w64devkit) or MSYS2 (mingw64).
rem The results are in build\; worlds and test reports are saved next to them.
setlocal
cd /d "%~dp0"
if not exist build mkdir build

rem "python3" and "python" can be the Microsoft Store shortcut, which only
rem prints "Python was not found", so each is tried by running it.
set PY=
for %%P in (python py python3) do (
  if not defined PY (
    %%P -c "import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)" >nul 2>nul && set PY=%%P
  )
)
if not defined PY (echo Python 3 was not found. Install it from python.org. & goto :fail)
where g++ >nul 2>nul || (echo g++ was not found. Install w64devkit or MSYS2 mingw64 and add its bin folder to PATH. & goto :fail)

echo Translating the macro to C++ ...
%PY% ..\test_harness\translate.py ..\.. cubeland.4dm build\game.cpp || goto :fail

echo Compiling ...
g++ -O2 -std=c++17 -w -DCUBELAND_DESKTOP -I..\test_harness build\game.cpp desktop.cpp ^
    -o build\cubeland.exe -mwindows -static -lgdi32 -luser32 -lcomdlg32 -lshell32 || goto :fail

echo Translating the test build to C++ ...
%PY% ..\test_harness\translate.py ..\.. test\cubeland_test.4dm build\cubeland_test.cpp || goto :fail

echo Compiling the test build ...
g++ -O2 -std=c++17 -w -DCUBELAND_DESKTOP -I..\test_harness build\cubeland_test.cpp desktop.cpp ^
    -o build\cubeland_test.exe -mwindows -static -lgdi32 -luser32 -lcomdlg32 -lshell32 || goto :fail

echo.
echo Built build\cubeland.exe - double-click it to play.
echo Built build\cubeland_test.exe - double-click it to run the tests.
exit /b 0

:fail
echo.
echo Build failed.
exit /b 1
