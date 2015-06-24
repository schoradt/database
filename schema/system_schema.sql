/*
 * changelog from 06.05.2015
 * - added unique for columns in attribute_type_to_attribute_type_group
 * - removed unique constraints from attribute_type_to_attribute_type_group and
 *   attribute_type_group_to_topic_characteristic
 * - table for meta data added
 *
 * changelog from 16.04.2015
 * - function create_uuid removed
 * - changelog and comments translated
 * - infos removed
 *
 * changelog from 30.03.2015
 * - default value for pt_free_text_id in localized_character_string created
 *
 * changelog from 16.02.2015
 * - additional column project_id in relation topic_characteristic removed
 *   (odds from Delphi)
 *
 * changelog from 16.02.2015
 *  - UNIQUE constraints for value_list, attribute_type, project and
 *    topic_characteristic added
 *  - modifications concerning attribute type groups, further details in project
 *    meeting from 06.02.2015
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
-- create the schema for the system database
CREATE SCHEMA "system";

-- set standard search path to new created schema
SET search_path TO "system", public;
SET CLIENT_ENCODING TO "UTF8";


--------------------------------------------------------------------------------
-------------------------- table definition ------------------------------------
--------------------------------------------------------------------------------
-- multilingualism table - connects the translation table and the value tables
CREATE TABLE "pt_free_text"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid()
);


-- multilingualism table - contains language codings to ISO 639-1
CREATE TABLE "language_code"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "language_code" varchar NOT NULL UNIQUE
);


-- multilingualism table - contains country code to ISO 3166
CREATE TABLE "country_code"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "country_code" varchar NOT NULL UNIQUE
);


-- multilingualism table - contains character code to ISO 19115
CREATE TABLE "character_code"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "character_code" varchar NOT NULL UNIQUE
);


-- multilingualism table - merge language, country and character code to locale
-- properties
CREATE TABLE "pt_locale"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "language_code_id" uuid NOT NULL REFERENCES "language_code" ("id"),
  "country_code_id" uuid REFERENCES "country_code" ("id"),
  "character_code_id" uuid NOT NULL REFERENCES "character_code" ("id"),
  CONSTRAINT pt_locale_unique_key UNIQUE ("language_code_id", "country_code_id", "character_code_id")
);


-- multilingualism table - contains all texts and the connection to locale
-- properties
CREATE TABLE "localized_character_string"
(
  "pt_free_text_id" uuid NOT NULL REFERENCES "pt_free_text" ("id") DEFAULT create_uuid(),
  "pt_locale_id" uuid NOT NULL REFERENCES "pt_locale" ("id"),
  "free_text" text NOT NULL,
  PRIMARY KEY ("pt_free_text_id", "pt_locale_id")
);


-- contains value lists
CREATE TABLE "value_list"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "name" uuid NOT NULL UNIQUE REFERENCES "pt_free_text" ("id"),
  "description" uuid REFERENCES "pt_free_text" ("id")
);


-- contains the values and their connection to value lists
CREATE TABLE "value_list_values"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "name" uuid NOT NULL REFERENCES "pt_free_text" ("id"),
  "description" uuid REFERENCES "pt_free_text" ("id"),
  "visibility" boolean NOT NULL DEFAULT true,
  "belongs_to_value_list" uuid NOT NULL REFERENCES "value_list" ("id")
);


-- relation table for value lists, the direction of the relation is taken in
-- reading direction: value_list_1 relationship value_list_2
CREATE TABLE "value_list_x_value_list"
(
  "value_list_1" uuid NOT NULL REFERENCES "value_list" ("id"),
  "value_list_2" uuid NOT NULL REFERENCES "value_list" ("id"),
  "relationship" uuid NOT NULL REFERENCES "value_list_values" ("id"),
  PRIMARY KEY ("value_list_1", "value_list_2")
);


-- relation table for value lists values, the direction of the relation is taken
-- in reading direction: value_list_values_1 relationship value_list_values_2
CREATE TABLE "value_list_values_x_value_list_values"
(
  "value_list_values_1" uuid NOT NULL REFERENCES "value_list_values" ("id"),
  "value_list_values_2" uuid NOT NULL REFERENCES "value_list_values" ("id"),
  "relationship" uuid NOT NULL REFERENCES "value_list_values" ("id"),
  PRIMARY KEY ("value_list_values_1", "value_list_values_2")
);


-- contains the multiplicity
CREATE TABLE "multiplicity"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "min_value" integer NOT NULL,
  "max_value" integer -- NULL value marks a  ..* multiplicity
);


-- contains all properties of an attribute type
CREATE TABLE "attribute_type"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "name" uuid NOT NULL UNIQUE REFERENCES "pt_free_text" ("id"),
  "description" uuid REFERENCES "pt_free_text" ("id"),
  "data_type" uuid NOT NULL REFERENCES "value_list_values" ("id"),
  "unit" uuid REFERENCES "value_list_values" ("id"),
  "domain" uuid REFERENCES "value_list" ("id") -- value list values from the corresponding value list can be used as attribute value
);


-- contains all available relationship types
CREATE TABLE "relationship_type"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "reference_to" uuid NOT NULL REFERENCES "value_list_values"("id"),
  "description" uuid NOT NULL REFERENCES "value_list_values" ("id")
);


-- relation table for attribute types, the direction of the relation is taken
-- in reading direction: attribute_type_1 relationship attribute_type_2
CREATE TABLE "attribute_type_x_attribute_type"
(
  "attribute_type_1" uuid NOT NULL REFERENCES "attribute_type" ("id"),
  "attribute_type_2" uuid NOT NULL REFERENCES "attribute_type" ("id"),
  "relationship" uuid NOT NULL REFERENCES "value_list_values" ("id"),
  PRIMARY KEY ("attribute_type_1", "attribute_type_2")
);


-- contains attribute groups
CREATE TABLE "attribute_type_group"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "name" uuid NOT NULL REFERENCES "pt_free_text" ("id"),
  "description" uuid REFERENCES "pt_free_text" ("id"),
  "subgroup_of" uuid REFERENCES "attribute_type_group" ("id")
);


-- contains topic characteristics
CREATE TABLE "topic_characteristic"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "description" uuid NOT NULL UNIQUE REFERENCES "pt_free_text" ("id"),
  "topic" uuid NOT NULL REFERENCES "value_list_values" ("id")
);


-- contains the mapping of attribute type groups to topic characteristics
CREATE TABLE "attribute_type_group_to_topic_characteristic"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "attribute_type_group_id" uuid NOT NULL REFERENCES "attribute_type_group" ("id"),
  "topic_characteristic_id" uuid NOT NULL REFERENCES "topic_characteristic" ("id"),
  "multiplicity" uuid NOT NULL REFERENCES "multiplicity" ("id"),
  "order" integer
);


-- contains the mapping of attribute types to attribute type groups.
CREATE TABLE "attribute_type_to_attribute_type_group"
(
  "id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "attribute_type_id" uuid NOT NULL REFERENCES "attribute_type" ("id"),
  "attribute_type_group_id" uuid NOT NULL REFERENCES "attribute_type_group" ("id"),
  "attribute_type_group_to_topic_characteristic_id" uuid NOT NULL REFERENCES "attribute_type_group_to_topic_characteristic" ("id"),
  "multiplicity" uuid NOT NULL REFERENCES "multiplicity" ("id"),
  "default_value" uuid REFERENCES "value_list_values" ("id"),
  "order" integer
);


-- contains the mapping of relationship types to topic characteristics
CREATE TABLE "relationship_type_to_topic_characteristic"
(
  "topic_characteristic_id" uuid NOT NULL REFERENCES "topic_characteristic" ("id"),
  "relationship_type_id" uuid REFERENCES "relationship_type" ("id"),
  "multiplicity" uuid NOT NULL REFERENCES "multiplicity" ("id"),
  PRIMARY KEY ("relationship_type_id", "topic_characteristic_id")
);


CREATE TABLE "meta_data"
(
  "object_id" uuid NOT NULL PRIMARY KEY DEFAULT create_uuid(),
  "table_name" varchar NOT NULL CHECK ("public".table_exists("table_name")),
  "pk_column" varchar NOT NULL CHECK ("public".column_exists("pk_column", "table_name")),
  "data" jsonb NOT NULL,
  CONSTRAINT table_column_unique_key UNIQUE ("table_name", "pk_column")
)