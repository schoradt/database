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
SET "projects=baalbek, palatin, test"
SET "p_database=0"
SET "p_baalbek=0"
SET "p_palatin=0"
SET "p_test=0"
SET "database=0"
SET "constraints=0"
SET "rbac=0"
SET "public=0"
SET "meta=0"
SET "system=0"
SET "project=0"

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
  
  REM setting for executing all install scripts
  IF "%1"=="-a" (
    SET "database=1"
    SET "constraints=1"
    SET "public=1"
    SET "meta=1"
    SET "rbac=1"
    SET "system=1"
    SET "project=1"
    SET "p_baalbek=0"
    SET "p_palatin=0"
    SET "p_test=1"
  )
  IF "%1"=="--all" (
    SET "database=1"
    SET "constraints=1"
    SET "public=1"
    SET "meta=1"
    SET "rbac=1"
    SET "system=1"
    SET "project=1"
    SET "p_baalbek=0"
    SET "p_palatin=0"
    SET "p_test=1"
  )
  
  REM setting for install constraints
  IF "%1"=="-c" SET "constraints=1"
  IF "%1"=="--constraints" SET "constraints=1"
  
  REM setting for install public functions
  IF "%1"=="-l" SET "public=1"
  IF "%1"=="--public" SET "public=1"
  
  REM setting for install schema for meta data
  IF "%1"=="-m" SET "meta=1"
  IF "%1"=="--meta" SET "meta=1"
  
  REM setting for install schema for role based access control
  IF "%1"=="-b" SET "rbac=1"
  IF "%1"=="--rbac" SET "rbac=1"
  
  REM setting for install schema for system data
  IF "%1"=="-s" SET "system=1"
  IF "%1"=="--system" SET "system=1"
  
  REM setting for install schema for project data
  IF "%1"=="-r" (
    IF NOT "%2%"=="" (
      SET "project=1"
      IF "%2"=="baalbek" ( SET "p_baalbek=0")
      IF "%2"=="palatin" ( SET "p_palatin=0")
      IF "%2"=="test" ( SET "p_test=1")
    ) ELSE (
      SET "project=1"
      SET "p_baalbek=0"
      SET "p_palatin=0"
      SET "p_test=1"
    )
    SHIFT
  )
  IF "%1"=="-project" (
    IF NOT "%2%"=="" (
      SET "project=1"
      IF "%2"=="baalbek" ( SET "p_baalbek=0")
      IF "%2"=="palatin" ( SET "p_palatin=0")
      IF "%2"=="test" ( SET "p_test=1")
    ) ELSE (
      SET "project=1"
      SET "p_baalbek=0"
      SET "p_palatin=0"
      SET "p_test=1"
    )
    SHIFT
  )
  SHIFT
  GOTO :loop
)


REM construct psql command
SET "command=psql -h %host% -p %port% -U %username%"

IF "%database%"=="1" (
  GOTO confirmation
)

GOTO install


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
  ECHO Install options:
  ECHO   -a, --all             install all scripts
  ECHO   -c, --constraints     install constraints
  ECHO   -l, --public          install public functions
  ECHO   -m, --meta            install schema for meta data
  ECHO   -b, --rbac            install schema for role based access control
  ECHO   -s, --system          install schema for system data
  ECHO   -r, --project ARG     install schema for project data (%projects%)
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
  
  
:installloop
  REM reinstall database
  IF "%database%"=="1" GOTO database
  
  REM attach database, transaction and file parameters to command
  SET "command=%command% -d %db% -1 "
  SET "commandFile=%command% -f "
  
  REM install the constraints
  IF "%constraints%"=="1" GOTO constraints
  
  REM install the public functions
  IF "%public%"=="1" GOTO public
  
  REM install the meta database
  IF "%meta%"=="1" GOTO meta
  
  REM install schema for role based access control
  IF "%rbac%"=="1" GOTO rbac
  
  REM install the system database
  IF "%system%"=="1" GOTO system
  
  REM install the project database
  IF "%project%"=="1" GOTO project
  
  REM end script if everything is installed
  GOTO end
  
  
REM install database
:database
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
  %command% -d %db% -c "CREATE EXTENSION IF NOT EXISTS plpgsql";
  %command% -d %db% -c "CREATE EXTENSION IF NOT EXISTS postgis";
  %command% -d %db% -c "CREATE EXTENSION IF NOT EXISTS ""uuid-ossp"";
  
  SET "database=0"
  GOTO installloop
  
  
REM install constraints
:constraints
  REM install contstraint schema and necessary functions
  ECHO.
  ECHO.
  ECHO Install constraint helper functions
  ECHO ===================================
  %commandFile% "schema\constraint_helper_functions.sql"
  
  ECHO.
  ECHO.
  ECHO Install constraint check functions
  ECHO ==================================
  %commandFile% "schema\constraint_check_functions.sql"
  
  ECHO.
  ECHO.
  ECHO Install constraints
  ECHO ===================
  %commandFile% "schema\constraint_main.sql"
  
  SET "constraints=0"
  GOTO installloop
  
  
REM install public functions
:public
  ECHO.
  ECHO.
  ECHO Install public functions
  ECHO ========================
  %commandFile% "schema\public_functions.sql"
  
  SET "public=0"
  GOTO installloop
  
  
REM install meta database
:meta
  ECHO.
  ECHO.
  ECHO Install schema for meta database
  ECHO ================================
  %commandFile% "schema\meta_database_schema.sql"
  
  ECHO.
  ECHO.
  ECHO Install data for meta database
  ECHO ==============================
  %commandFile% "data\meta_data.sql" -q
  
  SET "meta=0"
  GOTO installloop
  
  
REM install schema for role based access control
:rbac
  ECHO.
  ECHO.
  ECHO Install schema for role based access control
  ECHO ============================================
  %commandFile% "schema\rbac_schema.sql"
  
  ECHO.
  ECHO.
  ECHO Install data for role based access control
  ECHO ==========================================
  %commandFile% "data\rbac_data.sql" -q
  
  SET "rbac=0"
  GOTO installloop


REM install system database
:system
  ECHO.
  ECHO.
  ECHO Install schema for system database
  ECHO ==================================
  %commandFile% "schema\system_schema.sql"
  
  ECHO.
  ECHO.
  ECHO Install system trigger
  ECHO ======================
  %commandFile% "schema\system_trigger.sql"
  
  ECHO.
  ECHO.
  ECHO Install static value lists
  ECHO ==========================
  %commandFile% "data\system_static_valuelist.sql" -q
  
  ECHO.
  ECHO.
  ECHO Install initial topic framework
  ECHO ===============================
  %commandFile% "data\system_initial_topic_framework.sql" -q
  
  SET "system=0"
  GOTO installloop
  
  
REM install project database and trigger
:project
  IF "%p_baalbek%"=="1" ( SET "p_database=1" )
  IF "%p_palatin%"=="1" ( SET "p_database=1" )
  IF "%p_test%"=="1" ( SET "p_database=1" )

  IF "%p_database%"=="1" (
    ECHO.
    ECHO.
    ECHO Install schema for project database
    ECHO ===================================
    %commandFile% "schema\project_schema.sql"
  
    ECHO.
    ECHO.
    ECHO Install project trigger
    ECHO =======================
    %commandFile% "schema\project_trigger.sql"
    
    SET "p_database=0"
  )
  
  IF "%p_baalbek%"=="1" (
    GOTO install_baalbek
  )
  
  IF "%p_palatin%"=="1" (
    GOTO install_palatin
  )
  
  IF "%p_test%"=="1" (
    GOTO install_test
  )
  
  SET "project=0"
  GOTO installloop
  
  
:install_baalbek
  REM install project data for baalbek
  ECHO.
  ECHO.
  ECHO Install Baalbek geometry settings
  ECHO =================================
  %commandFile% "data\project_baalbek_geom_settings.sql" -q
  
  ECHO.
  ECHO.
  ECHO Install Baalbek data
  ECHO ====================
  pg_restore -h %host% -p %port% -U %username% -d %db% --disable-triggers data\project_baalbek_dump
  
  ECHO.
  ECHO.
  ECHO Install Baalbek meta data
  ECHO =========================
  %commandFile% "data\project_baalbek_meta_data.sql" -q
  
  ECHO.
  ECHO.
  ECHO Rename project schema
  ECHO =====================
  %command% -c "SELECT public.rename_project_schema('Baalbek');"
  
  REM TODO: make this more generic
  ECHO.
  ECHO.
  ECHO Init baalbek geom views
  ECHO =======================
  %command% -c "SELECT public.init_geom_views('project_fd27a347-4e33-4ed7-aebc-eeff6dbf1054')"

  ECHO Init indices for baalbek project
  ECHO ================================
  %commandFile% "schema\project_indices.sql" -q
  
  SET "p_baalbek=0"
  GOTO install
  
  
:install_palatin
  REM install project data for palatin
  ECHO.
  ECHO.
  ECHO Install Palatin data
  ECHO ====================
  pg_restore -h %host% -p %port% -U %username% -d %db% --disable-triggers data\project_palatin_dump
  
  ECHO.
  ECHO.
  ECHO Rename project schema
  ECHO =====================
  %command% -c "SELECT public.rename_project_schema('Palatin');"
  
  SET "p_palatin=0"
  GOTO install

  
:install_test
  REM install project data for test
  ECHO.
  ECHO.
  ECHO Install Test data
  ECHO =================
  %commandFile% "data\project_static_valuelist.sql" -q
  %commandFile% "data\test.sql" -q
  
  ECHO.
  ECHO.
  ECHO Rename project schema
  ECHO =====================
  %command% -c "SELECT public.rename_project_schema('Test');"
  
  SET "p_test=0"  
  GOTO install
  
:end
endlocal