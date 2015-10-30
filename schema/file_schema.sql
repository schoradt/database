/*
 * changelog from 16.10.2015
 * - created file schema
 */
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
-- drop the schema for RBAC if it exists and create it again
DROP SCHEMA IF EXISTS "file" CASCADE;
CREATE SCHEMA "file";

-- set standard search path to new created schema
SET search_path TO "file", "public";
SET CLIENT_ENCODING TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- table definition ------------------------------------
--------------------------------------------------------------------------------
CREATE TABLE "files" (
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "subject" uuid NOT NULL,
  "origin_file_name" varchar NOT NULL,
  "mime_type" varchar NOT NULL,
  "thumbnail_dimension" varchar,
  "middle_dimension" varchar,
  "popup_dimension" varchar,
  "origin_dimension" varchar,
  "signature" varchar,
  "exif_data" varchar,
  "uploaded_on" timestamp NOT NULL,
  UNIQUE ("subject", "signature")
);

CREATE TABLE "files_projects" (
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "file_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  UNIQUE ("file_id", "project_id")
);

CREATE TABLE "supported_mime_types" (
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "mime_type" varchar NOT NULL,
  UNIQUE ("mime_type")
);

