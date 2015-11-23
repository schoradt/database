# database
This repository contains all necessary database scripts to initialize the database schema for OpenInfRA. It also contains a Test-Project.

# Installation
To install the databse for the [OpenInfRA core](https://github.com/OpenInfRA/core) it is necessary to provide an installation of [PostgreSQL 9.4](http://www.postgresql.org/) and [PostGIS 2.1](http://postgis.net/). To insert the necessary data schemas and data we provide two installation scripts and a bunch of SQL files that can be executed manually. 

## Automatic installation
To insert the necessary schemas and data we provide two installation scripts. The [first script is a Batch file for Windows systems](installAll.bat). It provides some configuration possibilities that can be passed via parameters. To view the possible parameters use `installAll.bat -?` or `installAll.bat --help`. The [second script is a bash script for Linux systems](installAll.sh). This script does not provide any configuration parameters. It will always install the whole OpenInfRA database.

## Manual installation
If you encounter problems with the automatic installation scripts a manual installation is also possible. At this point we will determine the order the scripts must be installed.

##### Install the database schema:
1. install the PostgreSQL extensions `plpgsql`, `postgis` and `uuid`
2. install [helper functions](schema/constraint_helper_functions.sql), [check functions](schema/constraint_check_functions.sql) and the [main constraints](schema/constraint_main.sql)
3. install [public functions](schema/public_functions.sql)
4. install the [meta schema](schema/meta_database_schema.sql)
5. install the [file schema](schema/file_schema.sql)
6. install the [webapp schema](schema/webapp_schema.sql)
7. install the [RBAC schema](schema/rbac_schema.sql)
8. install the [system schema](schema/system_schema.sql)
9. install the [trigger] (schema/system_trigger.sql) for the system schema
10. install the [project schema](schema/project_schema.sql)
11. install the [trigger] (schema/project_trigger.sql) for the project schema

##### Install the data:
1. install the [meta data](data/meta_data.sql)
2. install the [file data](data/file_data.sql)
3. install the [webapp data](data/webapp_data.sql)
4. install the [RBAC data](data/rbac_data.sql)
5. install the [static value lists for system database](data/system_static_valuelist.sql)
6. install the [initial topic framework](data/system_initial_topic_framework.sql)
7. install the [test project](data/test.sql)
8. rename the project schema by executing `SELECT public.rename_project_schema('Test');`

## Changing the schema
If it is required to change something in the file [project_schema.sql](schema/project_schema.sql) you must always adapt the [schema script](https://github.com/OpenInfRA/core/blob/master/openinfra_core/src/main/resources/de/btu/openinfra/backend/sql/project_schema.sql) in the core as well. The same must be done for the file [project_static_valuelist.sql](schema/project_static_valuelist.sql) that must be updated in the (schema script)(https://github.com/OpenInfRA/core/blob/master/openinfra_core/src/main/resources/de/btu/openinfra/backend/sql/project_static_valuelist.sql) in the core.
`
