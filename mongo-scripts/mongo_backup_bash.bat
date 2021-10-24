@REM Script works only for windows batchecho off
REM move into the backups directory
@echo off 
:start
setlocal enableextensions 
CD C:\backup\mongo
REM list all databases
echo listing available databases
mongo --quiet --eval "db.getMongo().getDBNames()"
REM Requesting db names to backup 
:getdatabaesesnames
set /p dbnames="Enter the database(s) name(s) to backup (if many cases use $ to split): "
REM Create a file name for the database output which contains the date and time. Replace any characters which might cause an issue.
set filename=%dbnames% %date% %time%
set filename=%filename:/=-%
set filename=%filename: =__%
set filename=%filename:.=_%
set filename=%filename::=-%
echo Running backup "%filename%"
IF NOT x%dbnames:$=%==x%dbnames% (goto multipledatabases) else (goto singledatabase)


REM backup for multipe databases  
:multipledatabases
echo backing up multiple databases ...
for %%a in ("%dbnames:$=" "%") do (
   mongodump /out:%filename% /host:localhost /port:27017 /db:%%a
)
REM backup for single database  
:singledatabase
echo backing up %dbnames% ...
mongodump /out:%filename% /host:localhost /port:27017 /db:%dbnames%

REM ZIP the backup directory
REM echo Running backup "%filename%"
7z a -tzip "%filename%.zip" "%filename%"


REM Delete the backup directory (leave the ZIP file). The /q tag makes sure we don't get prompted for questions 
echo Deleting original backup directory "%filename%"
rmdir "%filename%" /s /q

REM echo BACKUP COMPLETE
goto start
cmd /k