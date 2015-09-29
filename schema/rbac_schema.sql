/*
 * changelog from 17.08.2015
 * - added schema definition for RBAC (Role-based access control 
 *   (https://en.wikipedia.org/wiki/Role-based_access_control))
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
DROP SCHEMA IF EXISTS "rbac" CASCADE;
CREATE SCHEMA "rbac";

-- set standard search path to new created schema
SET search_path TO "rbac", "public";
SET CLIENT_ENCODING TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- table definition ------------------------------------
--------------------------------------------------------------------------------
CREATE TABLE "role" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "name" varchar UNIQUE NOT NULL,
 "description" varchar
);

CREATE TABLE "permission" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "description" varchar,
 "permission" varchar UNIQUE NOT NULL
);

CREATE TABLE "role_permissions" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "role" uuid NOT NULL REFERENCES "role" ("id"),
 "permission" uuid NOT NULL REFERENCES "permission" ("id"),
 UNIQUE ("role", "permission")
);

-- This table must not be named 'user' since this is already a specific
-- postgres table which might lead to an exception. Thus, this is renamed
-- to subject which is used by shiro to name a user.
CREATE TABLE "subject"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "login" varchar UNIQUE NOT NULL,
  "password" varchar NOT NULL,
  "password_created_on" timestamp NOT NULL,
  "salt" uuid NOT NULL,
  "mail" varchar,
  "name" varchar NOT NULL,
  "description" varchar,
  "status" integer NOT NULL,
  "default_language" varchar NOT NULL,
  "created_on" timestamp NOT NULL,
  "updated_on" timestamp,
  "last_login_on" timestamp
);

CREATE TABLE "subject_roles" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "subject" uuid NOT NULL REFERENCES "subject" ("id"),
 "role" uuid NOT NULL REFERENCES "role" ("id"),
 UNIQUE ("subject", "role")
);

CREATE TABLE "project_related_roles" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "name" varchar,
 "description" varchar
);

CREATE TABLE "subject_projects" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "subject" uuid NOT NULL REFERENCES "subject" ("id"),
 "project_related_role" uuid NOT NULL REFERENCES "project_related_roles" ("id"),
 "project_id" uuid NOT NULL,
 UNIQUE ("subject", "project_related_role", "project_id")
);

CREATE TABLE "openinfra_objects" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "name" varchar,
 "description" varchar
);

CREATE TABLE "subject_objects" (
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "subject" uuid NOT NULL REFERENCES "subject" ("id"),
 "openinfra_objects" uuid NOT NULL REFERENCES "openinfra_objects" ("id"),
 "project_id" uuid NOT NULL,
 UNIQUE ("subject", "openinfra_objects", "project_id")
);

CREATE TABLE "password_blacklist"
(
 "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
 "password" varchar UNIQUE NOT NULL
);
