
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

psql -p $port -U $user -d $database -f install.sql 

export PGPASSWORD=