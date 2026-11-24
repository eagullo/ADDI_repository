:: This bat file generates a csv file listing all folders (subfolders) of the current directory.
:: Extracts Folder name, size, and date modified
:: This is used for creating HCI user reports

@echo off
setlocal enabledelayedexpansion

:: Set the folder to the current directory (where the batch file is)
set "FOLDER=%~dp0"
set "OUTPUT=%~dp0FolderSizes.csv"

:: Create CSV header
echo "Folder,Size (MB),Last Modified Date" > "%OUTPUT%"

:: Loop through all subfolders and calculate size using PowerShell
for /d /r "%FOLDER%" %%D in (*) do (
    set "FOLDERNAME=%%D"
    set "SIZE="
    set "MODIFIED_DATE="
    
    :: Get folder size using PowerShell
    for /f "tokens=*" %%S in ('powershell -command "(Get-ChildItem -Path '!FOLDERNAME!' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set "SIZE=%%S"
    
    :: Get the last modified date of the folder
    for /f "tokens=1,2,*" %%T in ('dir /t:w /a:d "!FOLDERNAME!" ^| findstr /i "%%~nxD"') do set "MODIFIED_DATE=%%T %%U %%V"

    :: Append folder size and date to CSV file
    echo "!FOLDERNAME!,!SIZE!,!MODIFIED_DATE!" >> "%OUTPUT%"
)

echo CSV file created at: %OUTPUT%

endlocal
pause
