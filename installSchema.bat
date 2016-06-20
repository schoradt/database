@ECHO off
REM This script installs the complete OpenInfRA database, including constraints,
REM public functions, system schema, system data, project schema and project
REM data.
REM WARNING: if the database already exists it will be dropped and recreated
REM without further prompt!

setlocal

REM script version
SET version=0.2

REM set default variables
SET "host=localhost"
SET "port=5432"
SET "username=postgres"
SET "db=openinfra"
SET "password=postgres"
SET "defaultpostgrespath=C:\Program Files\PostgreSQL\9.4\bin"
SET "postgrespath="

REM save name of the batch file and attach ending
SET "script=%~n0.bat"


REM loop through all parameters
:loop
IF NOT "%1"=="" (

  REM setting for help parameter
  IF "%1"=="-?" GOTO :help
  IF "%1"=="--help" GOTO :help
  
  REM setting for host
  IF "%1"=="-h" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET host=%2
    SHIFT
  )
  IF "%1"=="-host" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET host=%2
    SHIFT
  )
  
  REM setting for port
  IF "%1"=="-p" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET port=%2
    SHIFT
  )
  IF "%1"=="-port" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET port=%2
    SHIFT
  )
  
  REM setting for database name
  IF "%1"=="-d" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET db=%2
    SHIFT
  )
  IF "%1"=="-dbname" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET db=%2
    SHIFT
  )
  
  REM setting for username
  IF "%1"=="-u" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET user=%2
    SHIFT
  )
  IF "%1"=="-username" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET user=%2
    SHIFT
  )
  
  REM setting for password
  IF "%1"=="-w" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET password=%2
    SHIFT
  )
  IF "%1"=="-password" (
    IF "%2%"=="" (
      SET paramf=%1%
      GOTO :failure
    )
    SET password=%2
    SHIFT
  )
  
  REM setting for psql path
  IF "%1"=="-P" (
    IF NOT "%2%"=="" (
      SET postgrespath=%2%
    ) ELSE (
      SET postgrespath=%defaultpostgrespath%
    )
    SHIFT
  )
  IF "%1"=="-pslqpath" (
    IF NOT "%2%"=="" (
      SET postgrespath=%2%
    ) ELSE (
      SET postgrespath=%defaultpostgrespath%
    )
    SHIFT
  )
  GOTO :loop
)


REM construct psql command
SET "command=psql -h %host% -p %port% -U %username%"

GOTO confirmation

:confirmation
  
  REM print warning
  ECHO WARNING: This script will remove the database "%db%" and all of its content
  ECHO from the database server %host%. 
  SET /p choice=Do you know what you are doing? [y/n]: 
  
  REM run install
  IF "%choice%"=="y" (
    ECHO Let's go.
    GOTO install
  )
  
  REM abort install
  IF "%choice%"=="n" (
    ECHO Install process aborted.
    GOTO end
  )
  
  GOTO confirmation
  
  
REM output for help option
:help
  ECHO OpenInfRA database install script (version %version%)
  ECHO.
  ECHO Call:
  ECHO   %script% [[OPTION] ([ARGUMENT]) ...]
  ECHO.
  ECHO Global options:
  ECHO   -?, --help            show this help
  ECHO.
  ECHO Connection options:
  ECHO   -h, --host ARG        hostname of the database server (default: "%host%")
  ECHO   -p, --port ARG        port of the database server (default: "%port%")
  ECHO   -d, --dbname ARG      database name for installation (default: "%db%")
  ECHO   -u, --username ARG    username for database connection (default: "%username%")
  ECHO   -w, --password ARG    password for database connection (default: "%password%")
  ECHO   -P, --psqlpath ARG    path to postgresql bin directory, leave argument empty
  ECHO                         for using default path 
  ECHO                         "%defaultpostgrespath%"
  ECHO                         Skip use of this option if the postgresql path is part
  ECHO                         of your path variable.
  ECHO.
  ECHO Notice that the install scripts partly require each other. The requirements will
  ECHO not be installed automatically! For futher informations have a look into the
  ECHO detail concept of OpenInfRA.
  GOTO end
  
  
REM error management for parameters
:failure
  ECHO option requires an argument: %paramf%
  ECHO Try "%script% -?" for further informations.
  GOTO end
  
  
REM install process
:install
  
  REM set temporary path variable to postgres path if parameter was used
  IF NOT "%postgrespath%"=="" (
    SET PATH="%PATH%;%postgrespath%"
  )
  
  REM set postgres password
  SET PGPASSWORD=%password%
  
  REM create the database (drop if exists) and the necessary extensions
  ECHO.
  ECHO Removing database %db% from %host%
  ECHO ==========================================
  REM remove the databse if exists
  %command% -c "DROP DATABASE IF EXISTS %db%;"
  
  REM create the database
  ECHO.
  ECHO Creating database %db% on %host%
  ECHO ========================================
  %command% -c "CREATE DATABASE %db% ENCODING 'UTF8';"
  
  REM create necessary extensions
  ECHO.
  ECHO Creating necessary extensions
  ECHO =============================
  %command% -d %db% -f install.sql;
  
:end
endlocal