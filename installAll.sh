
#!/bin/bash
# This script installs the complete OpenInfRA database, including constraints,
# public functions, system schema, system data, project schema and project
# data.
# WARNING: if the database already exists it will be dropped and recreated
# without further prompt!

# Exit on error
set -e

# set default variables
user=postgres
database=openinfra
password=postgres
port=5432

# parameter handling
while [ "$1" != "" ]; do
    case $1 in
        -db | --database )      shift
                                database=$1
                                ;;
        -u | --user )           shift
                                user=$1
                                ;;
        -p | --password )       shift
                                password=$1
                                ;;
        * )                     echo "Error"
                                exit 1
    esac
    shift
done

# set postgres password
export PGPASSWORD=$password

# create the database (drop if exists) and the necessary extensions
psql -p $port -U $user -d postgres -c "DROP DATABASE IF EXISTS $database;"
psql -p $port -U $user -d postgres -c "CREATE DATABASE $database;"
psql -p $port -U $user -d $database -c "CREATE EXTENSION postgis;" 
psql -p $port -U $user -d $database -c "CREATE EXTENSION \"uuid-ossp\";"


# install contstraint schema and necessary functions
echo -e "\ninstall constraint helper functions"
echo -e "================================="
psql -p $port -U $user -d $database -1 -f "schema/constraint_helper_functions.sql"


echo -e "\ninstall constraint check functions"
echo -e "================================"
psql -p $port -U $user -d $database -1 -f "schema/constraint_check_functions.sql"


echo -e "\ninstall constraints"
echo -e "================="
psql -p $port -U $user -d $database -1 -f "schema/constraint_main.sql"


# install public functions
echo -e "\n\ninstall public functions"
echo -e "========================"
psql -p $port -U $user -d $database -1 -f "schema/public_functions.sql"


# install meta database
echo -e "\n\ninstall schema for meta database"
echo -e "================================"
psql -p $port -U $user -d $database -1 -f "schema/meta_database_schema.sql"

echo -e "\n\ninstall data for meta database"
echo -e "=============================="
psql -p $port -U $user -d $database -1 -f "data/meta_data.sql" -q


#install file schema
echo -e "\n\ninstall schema for file service"
echo -e "==============================="
psql -p $port -U $user -d $database -1 -f "schema/file_schema.sql"

echo -e "\n\ninstall data for file service"
echo -e "============================="
psql -p $port -U $user -d $database -1 -f "data/file_data.sql" -q

#install webapp schema
echo -e "\n\ninstall schema for webapp service"
echo -e "================================="
psql -p $port -U $user -d $database -1 -f "schema/webapp_schema.sql"

echo -e "\n\ninstall data for webapp service"
echo -e "==============================="
psql -p $port -U $user -d $database -1 -f "data/webapp_data.sql" -q

# install schema for role based access control
echo -e "\n\ninstall schema for role based access control"
echo -e "============================================"
psql -p $port -U $user -d $database -1 -f "schema/rbac_schema.sql"

echo -e "\n\ninstall data for meta database"
echo -e "=============================="
psql -p $port -U $user -d $database -1 -f "data/rbac_data.sql" -q


# install system database and add content
echo -e "\n\ninstall schema for system database"
echo -e "=================================="
psql -p $port -U $user -d $database -1 -f "schema/system_schema.sql"

echo -e "\n\ninstall system trigger"
echo -e "======================"
psql -p $port -U $user -d $database -1 -f "schema/system_trigger.sql"

echo -e "\n\ninstall static value lists"
echo -e "=========================="
psql -p $port -U $user -d $database -q -1 -f "data/system_static_valuelist.sql" -q

echo -e "\n\ninstall initial topic framework"
echo -e "==============================="
psql -p $port -U $user -d $database -q -1 -f "data/system_initial_topic_framework.sql" -q


# install baalbek
#echo -e "\n\ninstall schema for project database"
#echo -e "==================================="
#psql -p $port -U $user -d $database -1 -f "schema/project_schema.sql"

#echo -e "\n\ninstall project trigger"
#echo -e "======================="
#psql -p $port -U $user -d $database -1 -f "schema/project_trigger.sql"

#echo -e "\n\ninstall baalbek geometry settings"
#echo -e "================================="
#psql -p $port -U $user -d $database -1 -f "data/project_baalbek_geom_settings.sql" -q

#echo -e "\n\ninstall baalbek data"
#echo -e "===================="
#pg_restore -p $port -U $user -d $database --disable-triggers "data/project_baalbek_dump"

#echo -e "\n\ninstall baalbek meta data"
#echo -e "========================="
#psql -p $port -U $user -d $database -1 -f "data/project_baalbek_meta_data.sql" -q

#echo -e "\n\nrename baalbek schema"
#echo -e "====================="
#psql -p $port -U $user -d $database -c "SELECT public.rename_project_schema('Baalbek');"

# TODO: make this more generic
#echo -e "\n\ninit baalbek geom views"
#echo -e "====================="
#psql -p $port -U $user -d $database -c "SELECT public.init_geom_views('project_fd27a347-4e33-4ed7-aebc-eeff6dbf1054')"

#echo -e "\n\ninit indices for baalbek test project"
#echo -e "========================="
#psql -p $port -U $user -d $database -1 -f "schema/project_indices.sql" -q

# install palatin
#echo -e "\n\ninstall schema for project database"
#echo -e "==================================="
#psql -p $port -U $user -d $database -1 -f "schema/project_schema.sql"

#echo -e "\n\ninstall project trigger"
#echo -e "======================="
#psql -p $port -U $user -d $database -1 -f "schema/project_trigger.sql"

#echo -e "\n\ninstall palatin data"
#echo -e "===================="
#pg_restore -p $port -U $user -d $database --disable-triggers "data/project_palatin_dump"

#echo -e "\n\nrename palatin schema"
#echo -e "====================="
#psql -p $port -U $user -d $database -c "SELECT public.rename_project_schema('Palatin');"


# install test
echo -e "\n\ninstall schema for project database"
echo -e "==================================="
psql -p $port -U $user -d $database -1 -f "schema/project_schema.sql"

echo -e "\n\ninstall project trigger"
echo -e "======================="
psql -p $port -U $user -d $database -1 -f "schema/project_trigger.sql"

echo -e "\n\ninstall test data"
echo -e "================="
psql -p $port -U $user -d $database -1 -f "data/project_static_valuelist.sql" -q
psql -p $port -U $user -d $database -1 -f "data/test.sql" -q

echo -e "\n\nrename test schema"
echo -e "=================="
psql -p $port -U $user -d $database -c "SELECT public.rename_project_schema('Test');"

export PGPASSWORD=