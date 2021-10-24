REM Script works only for windows batch
REM move into the backups directory
@ECHO OFF
setlocal EnableDelayedExpansion
REM Need to create a folder for mongo backup
CD C:\backup\mongo
REM show what's insdie the dir 
dir
REM Request the name of the restore file 
:getfilename
set /p filename="Enter the file name to restore: "
IF NOT exist %filename% (echo Wrong filename & goto getfilename) 
IF NOT x%filename:.zip=%==x%filename% (
set newfilename=%filename:.zip=%
echo %newfilename%
)
REM Extracting ...
echo Extracting backup directory "%newfilename%"
7z e %newfilename%.zip
REM restoring the file 
mongorestore /host:localhost /port:27017 /drop %newfilename%
REM Delete the backup directory (leave the ZIP file). The /q tag makes sure we don't get prompted for questions 
echo Deleting original backup directory "%filename%"
rmdir "%filename%" /s /q



cmd /k