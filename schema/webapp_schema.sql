--------------------------------------------------------------------------------
-------------------------- extensions ------------------------------------------
--------------------------------------------------------------------------------
-- create necessary extensions if not exists
CREATE EXTENSION IF NOT EXISTS "plpgsql";
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


--------------------------------------------------------------------------------
-------------------------- schema defintion ------------------------------------
--------------------------------------------------------------------------------
-- drop the schema for WEBAPP if it exists and create it again
DROP SCHEMA IF EXISTS "webapp" CASCADE;
CREATE SCHEMA "webapp";

-- set standard search path to new created schema
SET search_path TO "webapp", "public";
SET CLIENT_ENCODING TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- table definition ------------------------------------
--------------------------------------------------------------------------------
CREATE TABLE "webapp" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "ident" varchar UNIQUE NOT NULL,
 "description" varchar,
 "data" varchar
);

CREATE TABLE "webapp_system" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "webapp_id" uuid NOT NULL REFERENCES "webapp" ("id"),
 "data" varchar,
 UNIQUE ("id", "webapp_id")
);

CREATE TABLE "webapp_project" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "webapp_id" uuid NOT NULL REFERENCES "webapp" ("id"),
 "project_id" uuid NOT NULL,
 "data" varchar,
 UNIQUE ("webapp_id", "project_id")
);

CREATE TABLE "webapp_subject" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "webapp_id" uuid NOT NULL REFERENCES "webapp" ("id"),
 "subject_id" uuid NOT NULL,
 "data" varchar,
 UNIQUE ("webapp_id", "subject_id")
);
