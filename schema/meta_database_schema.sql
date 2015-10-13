/*
 * changelog from 13.10.2015
 * - added new primary key to projects table
 *
 * changelog from 03.09.2015
 * - added unique constraints to several tables
 *
 * changelog from 06.08.2015
 * - normalized setting keys to own table
 * - settings will now reference to projects not the other way around
 * - changed timezone definition
 *
 * changelog from 30.06.2015
 * - added gt_pk_metadata_table for GeoServer metadata
 *
 * changelog from 08.05.2015
 * - protocol renamed to log
 *
 * changelog from 16.04.2015
 * - comments for tables added
 *
 * changelog from 15.04.2015
 * - logger and level from protocol normalized
 *
 * changelog from 13.04.2015
 * - initial schema creation
 */
--------------------------------------------------------------------------------
-------------------------- extensions ------------------------------------------
--------------------------------------------------------------------------------
-- create necessary extensions if not exists
CREATE EXTENSION IF NOT EXISTS "plpgsql";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--------------------------------------------------------------------------------
-------------------------- schema defintion ------------------------------------
--------------------------------------------------------------------------------
-- create schema for meta data database
CREATE SCHEMA "meta_data";

-- change search path to new created schema
SET search_path TO "meta_data", public;
SET CLIENT_ENCODING TO "UTF8";


--------------------------------------------------------------------------------
-------------------------- table definition ------------------------------------
--------------------------------------------------------------------------------
-- normalized table for the name of the log triggered class
CREATE TABLE "logger"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "logger" varchar NOT NULL UNIQUE
);

-- normalized table for the log level
CREATE TABLE "level"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "level" varchar NOT NULL UNIQUE
);

-- table for storing OpenInfRA log events
CREATE TABLE "log"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "user_id" uuid NOT NULL,
  "user_name" varchar NOT NULL,
  "created_on" timestamp NOT NULL,
  "logger" uuid NOT NULL REFERENCES "logger" ("id"),
  "level" uuid NOT NULL REFERENCES "level" ("id"),
  "message" text NOT NULL
);

-- normalized table for server names or ip addresses
CREATE TABLE "servers"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "server" varchar UNIQUE
);

-- normalized table for server ports
CREATE TABLE "ports"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "port" integer UNIQUE
);

-- normalized table for database names
CREATE TABLE "databases"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "database" varchar UNIQUE
);

-- normalized table for schema names
CREATE TABLE "schemas"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "schema" varchar UNIQUE
);

-- normalized table for connection credentials
CREATE TABLE "credentials"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "username" varchar NOT NULL,
  "password" varchar NOT NULL,
  UNIQUE ("username", "password")
);

-- table for storing database connections and their credentials (password as md5)
CREATE TABLE "database_connection"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "server" uuid NOT NULL REFERENCES "servers" ("id"),
  "port" uuid NOT NULL REFERENCES "ports" ("id"),
  "database" uuid NOT NULL REFERENCES "databases" ("id"),
  "schema" uuid NOT NULL REFERENCES "schemas" ("id"),
  "credentials" uuid NOT NULL REFERENCES "credentials" ("id")
);

-- table for storing all projects that exists in this OpenInfRA instance
CREATE TABLE "projects"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "project_id" uuid NOT NULL,
  "database_connection_id" uuid NOT NULL REFERENCES "database_connection" ("id"),
  "is_subproject" boolean NOT NULL DEFAULT 'false'
);

-- normalized table for the setting keys used in settings
CREATE TABLE "setting_keys"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "key" varchar NOT NULL UNIQUE
);

-- table for storing OpenInfRA settings
CREATE TABLE "settings"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "key" uuid NOT NULL REFERENCES "setting_keys" ("id"),
  "value" varchar NOT NULL,
  "updated_on" timestamp NOT NULL,
  "project" uuid REFERENCES "projects" ("id") -- can be NULL
);

-- Table for storing GeoServer relatated metadata for spatial tables and views.
-- TODO: Check if OpenInfRA may support init of plugin related database objects
--       instead of putting definitions into core files
CREATE TABLE gt_pk_metadata_table (
  "table_schema" varchar(64) NOT NULL,
  "table_name" varchar(64) NOT NULL,
  "pk_column" varchar(64) NOT NULL,
  "pk_column_idx" integer,
  "pk_policy" varchar(32),
  "pk_sequence" varchar(64),
  UNIQUE ("table_schema", "table_name", "pk_column"),
  CHECK ("pk_policy" IN ('sequence', 'assigned', 'autoincrement'))
);

/*
CREATE TABLE "tables"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "table" varchar
);


CREATE TABLE "columns"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "column" varchar
);


CREATE TABLE "resolver"
(
  "ooid" uuid PRIMARY KEY,
  "connection_id" uuid NOT NULL REFERENCES "database_connection" ("id"),
  "user_defined_id" varchar,
  "table" uuid REFERENCES "tables" ("id"),
  "column" uuid REFERENCES "columns" ("id")
);


CREATE TABLE "meta_data"
(
  "id" uuid PRIMARY KEY DEFAULT create_uuid(),
  "resolver_id" uuid NOT NULL REFERENCES "resolver" ("ooid"),
  "name" varchar NOT NULL,
  "value" text NOT NULL
);
*/
