@echo off
call setEnv.bat
"C:\Program Files\MATLAB\R2021b\toolbox\shared\coder\ninja\win64\ninja.exe" -t compdb cc cxx cudac > compile_commands.json
"C:\Program Files\MATLAB\R2021b\toolbox\shared\coder\ninja\win64\ninja.exe" -v %*
