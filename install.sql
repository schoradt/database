
\set QUIET

BEGIN TRANSACTION;

\echo  
\echo create extensions
\echo -----------------
\echo  

\echo * create postgis
CREATE EXTENSION postgis;

\echo * create uuid generator
CREATE EXTENSION "uuid-ossp";

\echo  
\echo create database objects
\echo -----------------------
\echo  

\echo * install constraint helper functions
\i schema/constraint_helper_functions.sql

\echo * install constraint check functions
\i schema/constraint_check_functions.sql

\echo * install constraints
\i schema/constraint_main.sql

\echo * install public functions
\i schema/public_functions.sql

\echo * meta database schema
\i schema/meta_database_schema.sql

\echo * file service schema
\i schema/file_schema.sql

\echo * webapp service schema
\i schema/webapp_schema.sql

\echo * role based access control schema
\i schema/rbac_schema.sql

\echo * system schema
\i schema/system_schema.sql

\echo * system trigger
\i schema/system_trigger.sql

\echo  
\echo insert base data
\echo ----------------
\echo  

\echo * meta data
\i data/meta_data.sql

\echo * file service data
\i data/file_data.sql

\echo * webapp service data
\i data/webapp_data.sql

\echo * role based access control data
\i data/rbac_data.sql

\echo * system  static value list data
\i data/system_static_valuelist.sql

\echo * system initial topic framework data
\i data/system_initial_topic_framework.sql

\echo  
\echo create projects
\echo ---------------
\echo  

\echo * create test project

\echo     * project template schema
\i schema/project_schema.sql

\echo     * project template trigger
\i schema/project_trigger.sql

\echo     * project value list data
\i data/project_static_valuelist.sql

\echo     * project data
\i data/test.sql

\echo     * rename project schema
SELECT public.rename_project_schema('Test');

COMMIT;
