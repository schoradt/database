REM This install script will export a project schema in a form that it can used 
REM for the installAll scripts.

@ECHO off

setlocal

REM set default variables
SET "host=localhost"
SET "port=5432"
SET "username=postgres"
SET "db=openinfra"
SET "password=postgres"
SET "database=openinfra"
REM do not change the schema name if you want to keep the compatibility to the
REM installAll scripts
SET "schema=project"
SET "basePath=data\trunk\"
SET "dir="


REM save name of the batch file and attach ending
SET "script=%~n0.bat"


REM loop through all parameters
:loop
IF NOT "%1"=="" (

  REM setting for help parameter
  IF "%1"=="-?" GOTO :help
  IF "%1"=="--help" GOTO :help
  
  REM setting for directory
  IF "%1"=="-d" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO failure
    )
    SET dir=%2
    SHIFT
  )
  IF "%1"=="-dir" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO failure
    )
    SET dir=%2
    SHIFT
  )
  SHIFT
)

GOTO :start

REM output for help option
:help
  ECHO OpenInfRA database backup script
  ECHO.
  ECHO Call:
  ECHO   %script% [[OPTION] ([ARGUMENT]) ...]
  ECHO.
  ECHO Global options:
  ECHO   -?, --help            show this help
  ECHO.
  ECHO Backup options:
  ECHO   -d, --dir             directory to backup the data
  GOTO end


REM error management for parameters
:failure
  ECHO option requires an argument: %paramf%
  ECHO Try "%script% -?" for further informations.
  GOTO end


REM start the backup process
:start
  
  REM check if the dir was set via parameter
  IF "%dir%"=="" (
    ECHO parameter missing 
    ECHO Try "%script% -?" for further informations.
    GOTO end
  )
  
  REM set the dir path
  SET "dir=%basePath%%dir%"
  
  REM remove the old dump
  ECHO.
  ECHO Clearing old dump files from %dir%
  ECHO =======================
  del /F /Q %dir%\*.*
  REM set the command
  SET "command=pg_dump -h %host% -p %port% -U %username% -d %database% -a -F d -n %schema% -f %dir%"

  
  REM run the dump process
  ECHO.
  ECHO Starting backup process
  ECHO =======================
  %command%  
  
:end
endlocal