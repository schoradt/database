/*
 * changelog from 21.12.2015
 * - constraint 54 added
 *
 * changelog from 05.12.2015
 * - fixed bugs in constraint 31 and 32
 *
 * changelog from 17.11.2015
 * - extended constraint 63 to avoid changing values of value 
 *   list vl_skos_relationship
 *
 * changelog from 05.08.2015
 * - constraint 10 added
 *
 * changelog from 29.05.2015
 * - constraint 63 added
 *
 * changelog from 11.05.2015
 * - constraint 59, 60, 61 and 62 extended by operation parameter
 *
 * changelog from 06.05.2015
 * - constraint 45 and 53 refactored
 * - constraint 54 removed
 *
 * changelog from 16.04.2015
 * - constraints 59, 60, 61 and 62 added
 *
 * changelog from 31.03.2015
 * - file created to hold functions for every single constraint
 */


-- set search path to created constraints schema
SET search_path TO "constraints", public;
SET CLIENT_ENCODING TO "UTF8";



/******************************************************************************/
/********************** functions for constraint checks ***********************/
/******************************************************************************/

/******************************************************************************/
/************************************ 1 ***************************************/
/******************************************************************************/
/*
 * The column "min_value" of the relation "multiplicity" must be greater equal 0.
 *
 * @state   stable
 * @input   integer: new min_value
 * @output  boolean: false if constraint is violated, else true
 */
CREATE OR REPLACE FUNCTION check_constraint_1(integer)
  RETURNS boolean AS $$
  DECLARE
    _new_min ALIAS FOR $1;
  BEGIN

    -- (1) Die Spalte "min_value" der Relation "multiplicity" muss >= 0 sein.
    IF (_new_min < 0) THEN
      PERFORM throw_constraint_message(1);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 2 ***************************************/
/******************************************************************************/
/*
 * The column "max_value" of the relation "multiplicity" must be greater 0.
 *
 * @state   stable
 * @input   integer: new max_value
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_2(integer)
  RETURNS boolean AS $$
  DECLARE
    _new_max ALIAS FOR $1;
  BEGIN

    -- (2) Die Spalte "max_value" der Relation "multiplicity" muss > 0 sein.
    IF (_new_max <= 0) THEN
      PERFORM throw_constraint_message(2);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 3 ***************************************/
/******************************************************************************/
/*
 * The column "max_value" of the relation "multiplicity" must be greater equal
 * "min_value".
 *
 * @state   stable
 * @input   integer: new min_value
 *          integer: new max_value
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_3(integer, integer)
  RETURNS boolean AS $$
  DECLARE
    _new_min ALIAS FOR $1;
    _new_max ALIAS FOR $2;
  BEGIN

    -- (3) Die Spalte "max_value" der Relation "multiplicity" muss >= dem
    --     "min_value" sein.
    IF (_new_min > _new_max) THEN
      PERFORM throw_constraint_message(3);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 4 ***************************************/
/******************************************************************************/
/*
 * The column "language_code" of the relation "language_code" must contain two
 * characters.
 *
 * @state   stable
 * @input   varchar: new language_code
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_4(varchar)
  RETURNS boolean AS $$
  DECLARE
    _new_language_code ALIAS FOR $1;
  BEGIN

    -- (4) Die Spalte "language_code" der Relation "language_code" muss genau
    --     2 Zeichen beinhalten.
    IF (char_length(_new_language_code) <> 2) THEN
      PERFORM throw_constraint_message(4);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 5 ***************************************/
/******************************************************************************/
/*
 * The column "country_code" of the relation "country_code" must contain two
 * characters.
 *
 * @state   stable
 * @input   varchar: new country_code
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_5(varchar)
  RETURNS boolean AS $$
  DECLARE
    _new_country_code ALIAS FOR $1;
  BEGIN

    -- (5) Die Spalte "country_code" der Relation "country_code" muss genau 2
    --     Zeichen beinhalten.
    IF (char_length(_new_country_code) <> 2) THEN
      PERFORM throw_constraint_message(5);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 6 ***************************************/
/******************************************************************************/
/*
 * The column "unit" of the relation "attribute_type" must only contain values
 * from "value_list_values" that belongs to the value list "vl_unit".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new unit_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_6(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_unit_id ALIAS FOR $2;
  BEGIN

    -- (6) Die Spalte "unit" der Relation "attribute_type" darf ausschließlich
    --     Werte aus "value_list_values" zugeordnet bekommen, welche sich in der
    --     Werteliste "vl_unit" befinden.
    IF (_new_unit_id IS NOT NULL AND NOT is_valid_unit(_schema, _new_unit_id)) THEN
      PERFORM throw_constraint_message(6);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 7 ***************************************/
/******************************************************************************/
/*
 * The column "data_type" of the relation "attribute_type" must be of the type
 * numeric or integer if "unit" is not null.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new unit_id
 *          uuid: new data_type_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_7(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_unit_id ALIAS FOR $2;
    _new_data_type_id ALIAS FOR $3;
  BEGIN

    -- (7) Die Spalte "data_type" der Relation "attribute_type" muss entweder
    --     Numeric oder Integer zugeordnet bekommen, insofern eine Einheit
    --     zugeordnet wurde.
    IF (_new_unit_id IS NOT NULL AND NOT is_valid_numeric_data_type(
                                             _schema, _new_data_type_id))
    THEN
      PERFORM throw_constraint_message(7);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 8 ***************************************/
/******************************************************************************/
/*
 * The column "data_type" of the relation "attribute_type" must only contain
 * values from "value_list_values" that belongs to the value list "vl_data_type".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new data_type_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_8(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_data_type_id ALIAS FOR $2;
  BEGIN

    -- (8) Die Spalte "data_type" der Relation "attribute_type" darf ausschließlich
    --     Werte aus "value_list_values" zugeordnet bekommen, welche sich in der
    --     Werteliste "vl_data_type" befinden.
    IF (is_valid_data_type(_schema, _new_data_type_id) IS FALSE) THEN
      PERFORM throw_constraint_message(8);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 9 ***************************************/
/******************************************************************************/
/*
 * The column "domain" of the relation "attribute_type" must only contain
 * values from "value_list" that are not equal to "vl_relationship_type",
 * "vl_data_type", "vl_unit", "vl_skos_relationship" or "vl_topic" and their
 * translations.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new domain_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_9(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_domain_id ALIAS FOR $2;
  BEGIN

    -- (9) Die Spalte "domain" der Relation "attribute_type" darf ausschließlich
    --     Werte aus "value_list" zugeordnet bekommen, welche nicht
    --     "vl_relationship_type", "vl_data_type", "vl_unit",
    --     "vl_skos_relationship" oder "vl_topic" entsprechen.
    IF (
      _new_domain_id IS NOT NULL AND _new_domain_id IN (
      SELECT
        "vl"."id"
      FROM
        "value_list" "vl",
        "localized_character_string" "lcs"
      WHERE
        "vl"."name" = "lcs"."pt_free_text_id" AND
        "lcs"."pt_locale_id" = get_pt_locale_id(_schema) AND
        ("lcs"."free_text" = 'vl_unit' OR
         "lcs"."free_text" = 'vl_data_type' OR
         "lcs"."free_text" = 'vl_topic' OR
         "lcs"."free_text" = 'vl_relationship_type' OR
         "lcs"."free_text" = 'vl_skos_relationship')
      )
    ) THEN
      PERFORM throw_constraint_message(9);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 10 **************************************/
/******************************************************************************/
/*
 * The column "object_id" of the relation "meta_data" may only have entries that
 * exists in the colum of "pk_column" and the table "table_name".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new object_id
 *          varchar: new table_name
 *          varchar: new pk_column
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_10(varchar, uuid, varchar, varchar)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_object_id ALIAS FOR $2;
    _new_table_name ALIAS FOR $3;
    _new_pk_column ALIAS FOR $4;
    _sql varchar;
    _result uuid;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (10) Die Spalte "object_id" der Relation "meta_data" darf nur Einträge 
    --      besitzen, die in der Spalte aus "pk_column" und der Tabelle aus
    --      "table_name" existieren.
    _sql := 'SELECT "id" FROM '|| quote_ident(_new_table_name) ||
            ' WHERE '|| quote_ident(_new_pk_column) ||' = 
            '|| quote_literal(_new_object_id);
    EXECUTE _sql INTO _result;
    
    IF _result IS NULL THEN
      PERFORM throw_constraint_message(10);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';
  

/******************************************************************************/
/************************************ 11 **************************************/
/******************************************************************************/
/*
 * The column "default_value" of the relation
 * "attribute_type_to_attribute_type_group" may only have an entry if the
 * attribute "domain" of the corresponding relation "attribute_type" also has
 * an entry. If both attributes are not NULL, then "default_value" must contain
 * a "value_list_value" entry from the "value_list" associated to "domain".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_id
 *          uuid: new default_value
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_11(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_id ALIAS FOR $2;
    _new_default_value ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (11) Die Spalte "default_value" der Relation
    --      "attribute_type_to_attribute_type_group" darf nur dann einen
    --      Eintrag besitzen, wenn das Attribut "domain" der zugehörigen
    --      Relation "attribute_type" ebenfalls einen Eintrag hat. Wenn beide
    --      Attribute nicht NULL sind, dann muss der "value_list_value“ von
    --      "default_value" aus der "domain" zugeordneten "value_list" stammen.
    IF (((SELECT "domain"
            FROM "attribute_type"
           WHERE "id" = _new_attribute_type_id)
      !=
      (SELECT "belongs_to_value_list"
         FROM "value_list_values"
        WHERE "id" = _new_default_value)
      OR
      (SELECT "domain"
         FROM "attribute_type"
        WHERE "id" = _new_attribute_type_id) IS NULL
      OR
      (SELECT "belongs_to_value_list"
         FROM "value_list_values"
        WHERE "id" = _new_default_value) IS NULL)
      AND _new_default_value IS NOT NULL) THEN
      PERFORM throw_constraint_message(11);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 12 **************************************/
/******************************************************************************/
/*
 * By updating or deleting an entry in the relation
 * "attribute_type_group_to_topic_characteristic" no entry may be modified or
 * removed, where the "attribute_type" of the affected "attribute_type_group"
 * is used by an "attribute_value".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: old topic_characteristic_id
 *          uuid: old attribute_type_group_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_12(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_topic_characteristic_id ALIAS FOR $2;
    _old_attribute_type_group_id ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- only perform this, when the trigger was not fired from the system database
    IF (_schema != 'system') THEN
      -- (12) Durch das Aktualisieren oder Löschen eines Eintrages in der
      --      Relation "attribute_type_group_to_topic_characteristic", darf
      --      kein Eintrag geändert oder entfernt werden, dessen
      --      "attribute_type" der betroffenen "attribute_type_group" durch
      --      einen "attribute_value" verwendet wird.
      IF (SELECT (SELECT count("av"."id")
                    FROM "attribute_type_group_to_topic_characteristic" "att",
                         "attribute_type_to_attribute_type_group" "ata",
                         "attribute_value" "av"
                   WHERE "att"."topic_characteristic_id" = _old_topic_characteristic_id AND
                         "att"."attribute_type_group_id" = _old_attribute_type_group_id AND
                         "att"."id" = "ata"."attribute_type_group_to_topic_characteristic_id" AND
                         "ata"."id" = "av"."attribute_type_to_attribute_type_group_id"
                  ) != 0) THEN
        PERFORM throw_constraint_message(12);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 13 **************************************/
/******************************************************************************/
/*
 * The column "reference_to" of the relation "relationship_type" must only
 * contain values from "value_list_values" that belongs to the value
 * list "vl_topic".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new reference_to_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_13(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_reference_to_id ALIAS FOR $2;
  BEGIN

    -- (13) Die Spalte "reference_to" der Relation "relationship_type" darf
    --      ausschließlich Werte aus "value_list_values" zugeordnet bekommen,
    --      bei denen der zugehörige Wert aus "value_list" den Wert "vl_topic"
    --      hat.
    IF (NOT is_valid_topic(_schema, _new_reference_to_id)) THEN
      PERFORM throw_constraint_message(13);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 14 **************************************/
/******************************************************************************/
/*
 * The column "description" of the relation "relationship_type" must only
 * contain values from "value_list_values" that belongs to the value
 * list "vl_relationship_type".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new description_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_14(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_description_id ALIAS FOR $2;
  BEGIN

    -- (14) Die Spalte "description" der Relation "relationship_type" darf
    --      ausschließlich Werte aus "value_list_values" zugeordnet bekommen,
    --      welche sich in der Werteliste "vl_relationship_type" befinden.
    IF (NOT is_valid_relationship_type(_schema, _new_description_id)) THEN
      PERFORM throw_constraint_message(14);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 15 **************************************/
/******************************************************************************/
/*
 * The column "topic" of the relation "topic_characteristic" must only
 * contain values from "value_list_values" that belongs to the value
 * list "vl_relationship_type".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new topic_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_15(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_topic_id ALIAS FOR $2;
  BEGIN

    -- (15) Die Spalte "topic" der Relation "topic_characteristic" darf
    --      ausschließlich Werte aus "value_list_values" zugeordnet bekommen,
    --      welche sich in der Werteliste "vl_topic" befinden.
    IF NOT is_valid_topic(_schema, _new_topic_id) THEN
      PERFORM throw_constraint_message(15);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 16 **************************************/
/******************************************************************************/
/*
 * The column "relationship" of the relation "value_list_x_value_list"
 * must only contain values from "value_list_values" that belongs to the value
 * list "vl_skos_relationship".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_16(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_id ALIAS FOR $2;
  BEGIN

    -- (16) Die Spalte "relationship" der Relation "value_list_x_value_list"
    --      darf ausschließlich Werte aus "value_list_values" zugeordnet
    --      bekommen, welche sich in der Werteliste "vl_skos_relationship"
    --      befinden.
    IF (NOT is_valid_skos_relation(_schema, _new_relationship_id)) THEN
      PERFORM throw_constraint_message(16);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 17 **************************************/
/******************************************************************************/
/*
 * If a tuple of the relation "value_list_x_value_list" contains a hierarchical
 * relation ("skos:broader", "skos:narrower", "skos:broaderTransitive",
 * "skos:narrowerTransitive") in the column "relationship", an inverted
 * attribute type combination must not occur with the same relationship.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_id
 *          uuid: new value_list_1_id
 *          uuid: new value_list_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_17(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_id ALIAS FOR $2;
    _new_value_list_1_id ALIAS FOR $3;
    _new_value_list_2_id ALIAS FOR $4;
    _skos_type varchar;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- retrive the skos type
    SELECT get_value_from_value_list(_schema, _new_relationship_id,
                                     'vl_skos_relationship',
                                     get_pt_locale_id(_schema)) INTO _skos_type;

    IF (_skos_type = 'skos:broader' OR _skos_type = 'skos:narrower' OR
        _skos_type = 'skos:broaderTransitive' OR
        _skos_type = 'skos:narrowerTransitive') THEN
      -- (17) Wenn in der Relation "value_list_x_value_list" ein Tupel in der
      --      Spalte "relationship" eine hierarchische Beziehung ("skos:broader",
      --      "skos:narrower", "skos:broaderTransitive",
      --      "skos:narrowerTransitive") besitzt, darf dieselbe
      --      Attributtypenkombination nicht invertiert mit derselben
      --      Beziehungsart auftreten.
      IF (SELECT DISTINCT ROW(_new_value_list_2_id, _new_value_list_1_id) =
            ROW(
              "vlxvl"."value_list_1",
              "vlxvl"."value_list_2")
            FROM
              "value_list_values" "vlv",
              "value_list_x_value_list" "vlxvl",
              "localized_character_string" "lcs"
            WHERE
              "vlxvl"."relationship" = "vlv"."id" AND
              "vlv"."name" = "lcs"."pt_free_text_id" AND
              "lcs"."free_text" = (
                  SELECT get_value_from_value_list(
                             _schema, _new_relationship_id,
                             'vl_skos_relationship',
                             get_pt_locale_id(_schema)))
          ) THEN
        PERFORM throw_constraint_message(17);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 18 **************************************/
/******************************************************************************/
/*
 * If a tuple of the relation "value_list_x_value_list" contains a hierarchical
 * relation ("skos:broader", "skos:narrower", "skos:broaderTransitive",
 * "skos:narrowerTransitive") in the column "relationship", it must not create
 * a loop inside the relation over n entries.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_id
 *          uuid: new value_list_1_id
 *          uuid: new value_list_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_18(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_id ALIAS FOR $2;
    _new_value_list_1_id ALIAS FOR $3;
    _new_value_list_2_id ALIAS FOR $4;
    _skos_type varchar;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    IF (_skos_type = 'skos:broader' OR _skos_type = 'skos:narrower' OR
        _skos_type = 'skos:broaderTransitive' OR
        _skos_type = 'skos:narrowerTransitive') THEN
      -- (18) Wenn in der Relation "value_list_x_value_list" ein Tupel in der
      --      Spalte "relationship" eine hierarchische Beziehung ("skos:broader",
      --      "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive")
      --      besitzt, darf es keine Schleife über n Einträge geben.
      IF ((SELECT check_loop_x(_schema, _new_value_list_1_id,
                               _new_value_list_2_id, _new_relationship_id,
                               'value_list'))) THEN
        PERFORM throw_constraint_message(18);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 19 **************************************/
/******************************************************************************/
/*
 * The columns "value_list_1" and "value_list_2" of the relation
 * "value_list_x_value_list" must not have the same values in same tuple.
 *
 * @state   stable
 * @input   uuid: new value_list_1_id
 *          uuid: new value_list_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_19(uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_value_list_1_id ALIAS FOR $1;
    _new_value_list_2_id ALIAS FOR $2;
  BEGIN

    -- (19) Die Spalten "value_list_1" und "value_list_2" der Relation
    --      "value_list_x_value_list" dürfen in einem Tupel nicht denselben Wert
    --      besitzen.
    IF (_new_value_list_1_id = _new_value_list_2_id) THEN
      PERFORM throw_constraint_message(19);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 20 **************************************/
/******************************************************************************/
/*
 * The column "relationship" of the relation
 * "value_list_values_x_value_list_values" must only contain values from
 * "value_list_values" that belongs to the value list "vl_skos_relationship".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_20(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_id ALIAS FOR $2;
  BEGIN

    -- (20) Die Spalte "relationship" der Relation
    --      "value_list_values_x_value_list_values" darf ausschließlich Werte
    --      aus "value_list_values" zugeordnet bekommen, welche sich in der
    --      Werteliste "vl_skos_relationship" befinden.
    IF (NOT is_valid_skos_relation(_schema, _new_relationship_id)) THEN
      PERFORM throw_constraint_message(20);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 21 **************************************/
/******************************************************************************/
/*
 * If a tuple of the relation "value_list_values_x_value_list_values" contains a
 * hierarchical relation ("skos:broader", "skos:narrower",
 * "skos:broaderTransitive", "skos:narrowerTransitive") in the column
 * "relationship", an inverted attribute type combination must not occur with
 * the same relationship.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_id
 *          uuid: new value_list_values_1_id
 *          uuid: new value_list_values_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_21(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_value_list_values_1_id ALIAS FOR $2;
    _new_value_list_values_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
    _skos_type varchar;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- retrieve skos type of relation
    SELECT get_value_from_value_list(
               _schema, _new_relationship_id, 'vl_skos_relationship',
               get_pt_locale_id(_schema)) INTO _skos_type;

    -- check if one of the hierachical skos types was retrieved
    IF (_skos_type = 'skos:broader' OR _skos_type = 'skos:narrower' OR
        _skos_type = 'skos:broaderTransitive' OR
        _skos_type = 'skos:narrowerTransitive') THEN
      -- (21) Wenn in der Relation "value_list_values_x_value_list_values" ein
      --      Tupel in der Spalte "relationship" eine hierarchische Beziehung
      --      ("skos:broader", "skos:narrower", "skos:broaderTransitive",
      --      "skos:narrowerTransitive") besitzt, darf dieselbe
      --      Attributtypenkombination nicht invertiert mit derselben
      --      Beziehungsart auftreten.
      IF (SELECT DISTINCT ROW(_new_value_list_values_2_id,
                              _new_value_list_values_1_id) =
            ROW(
              "vlvxvlv"."value_list_values_1",
              "vlvxvlv"."value_list_values_2")
            FROM
              "value_list_values" "vlv",
              "value_list_values_x_value_list_values" "vlvxvlv",
              "localized_character_string" "lcs"
            WHERE
              "vlvxvlv"."relationship" = "vlv"."id" AND
              "vlv"."name" = "lcs"."pt_free_text_id" AND
              "lcs"."free_text" = (SELECT get_value_from_value_list(
                                              _schema, _new_relationship_id,
                                              'vl_skos_relationship',
                                              get_pt_locale_id(
                                                  _schema)))
            ) THEN
        PERFORM throw_constraint_message(21);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 22 **************************************/
/******************************************************************************/
/*
 * If a tuple of the relation "value_list_values_x_value_list_values" contains a
 * hierarchical relation ("skos:broader", "skos:narrower",
 * "skos:broaderTransitive", "skos:narrowerTransitive") in the column
 * "relationship", it must not create a loop inside the relation over n entries.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new value_list_values_1_id
 *          uuid: new value_list_values_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_22(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_value_list_values_1_id ALIAS FOR $2;
    _new_value_list_values_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
    _skos_type varchar;
  BEGIN

    -- retrieve skos type of relation
    SELECT get_value_from_value_list(
               _schema, _new_relationship_id, 'vl_skos_relationship',
               get_pt_locale_id(_schema)) INTO _skos_type;

    -- check if one of the hierachical skos types was retrieved
    IF (_skos_type = 'skos:broader' OR _skos_type = 'skos:narrower' OR
        _skos_type = 'skos:broaderTransitive' OR
        _skos_type = 'skos:narrowerTransitive') THEN

      -- (22) Wenn in der Relation "value_list_values_x_value_list_values" ein
      --      Tupel in der Spalte "relationship" eine hierarchische Beziehung
      --      ("skos:broader", "skos:narrower", "skos:broaderTransitive",
      --      "skos:narrowerTransitive") besitzt, darf es keine Schleife über
      --      n Einträge geben.
      IF (SELECT check_loop_x(_schema, _new_value_list_values_1_id,
                              _new_value_list_values_2_id,
                              _new_relationship_id, 'value_list_values')) THEN
        PERFORM throw_constraint_message(22);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 23 **************************************/
/******************************************************************************/
/*
 * The columns "value_list_values_1" and "value_list_values_2" of the relation
 * "value_list_values_x_value_list_values" must not have the same values in same
 * tuple.
 *
 * @state   stable
 * @input   uuid: new new value_list_values_1_id
 *          uuid: new new value_list_values_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_23(uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_value_list_values_1_id ALIAS FOR $1;
    _new_value_list_values_2_id ALIAS FOR $2;
  BEGIN

    -- (23) Die Spalten "value_list_values_1" und "value_list_values_2" der
    --      Relation "value_list_values_x_value_list_values" dürfen in einem
    --      Tupel nicht denselben Wert besitzen.
    IF (_new_value_list_values_1_id = _new_value_list_values_2_id) THEN
      PERFORM throw_constraint_message(23);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 24 **************************************/
/******************************************************************************/
/*
 * The column "relationship" of the relation "attribute_type_x_attribute_type"
 * must only contain values from "value_list_values" that belongs to the value
 * list "vl_skos_relationship".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_24(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_id ALIAS FOR $2;
  BEGIN

    -- (24) Die Spalte "relationship" der Relation
    --      "attribute_type_x_attribute_type" darf ausschließlich Werte aus
    --      "value_list_values" zugeordnet bekommen, welche sich in der
    --      Werteliste "vl_skos_relationship" befinden.
    IF (NOT is_valid_skos_relation(_schema, _new_relationship_id)) THEN
      PERFORM throw_constraint_message(24);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 25 **************************************/
/******************************************************************************/
/*
 * If a tuple of the relation "attribute_type_x_attribute_type" contains a
 * hierarchical relation ("skos:broader", "skos:narrower",
 * "skos:broaderTransitive", "skos:narrowerTransitive") in the column
 * "relationship", an inverted attribute type combination must not occur with
 * the same relationship.
 *
 * @state   experimental (not language independent)
 * @input   varchar: schema name
 *          uuid: new attribute_type_1_id
 *          uuid: new attribute_type_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_25(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_1_id ALIAS FOR $2;
    _new_attribute_type_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
    _skos_type varchar;
  BEGIN

    -- retrive the skos type
    SELECT get_value_from_value_list(_schema, _new_relationship_id,
                                     'vl_skos_relationship',
                                     get_pt_locale_id(_schema)) INTO _skos_type;

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- check for hierarchical skos relations
    IF (_skos_type = 'skos:broader' OR _skos_type = 'skos:narrower' OR
        _skos_type = 'skos:broaderTransitive' OR
        _skos_type = 'skos:narrowerTransitive') THEN
      -- (25) Wenn in der Relation "attribute_type_x_attribute_type" ein Tupel
      --      in der Spalte "relationship" eine hierarchische Beziehung
      --      ("skos:broader", "skos:narrower", "skos:broaderTransitive",
      --      "skos:narrowerTransitive") besitzt, darf dieselbe
      --      Attributtypenkombination nicht invertiert mit derselben
      --      Beziehungsart auftreten.
      IF (true IN (SELECT ROW(_new_attribute_type_2_id, _new_attribute_type_1_id) =
            ROW(
              "axa"."attribute_type_1",
              "axa"."attribute_type_2")
            FROM
              "value_list_values" "vlv",
              "attribute_type_x_attribute_type" "axa",
              "localized_character_string" "lcs"
            WHERE
              "axa"."relationship" = "vlv"."id" AND
              "vlv"."name" = "lcs"."pt_free_text_id" AND
              "lcs"."free_text" = (SELECT get_value_from_value_list(
                                       _schema, _new_relationship_id,
                                       'vl_skos_relationship', get_pt_locale_id(
                                           _schema)))
         )) THEN
        PERFORM throw_constraint_message(25);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 26 **************************************/
/******************************************************************************/
/*
 * If a tuple of the relation "attribute_type_x_attribute_type" contains a
 * hierarchical relation ("skos:broader", "skos:narrower",
 * "skos:broaderTransitive", "skos:narrowerTransitive") in the column
 * "relationship", it must not create a loop inside the relation over n entries.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_1_id
 *          uuid: new attribute_type_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_26(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_1_id ALIAS FOR $2;
    _new_attribute_type_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
    _skos_type varchar;
  BEGIN

    -- retrive the skos type
    SELECT get_value_from_value_list(_schema, _new_relationship_id,
                                     'vl_skos_relationship',
                                     get_pt_locale_id(_schema)) INTO _skos_type;

    -- check for hierarchical skos relations
    IF (_skos_type = 'skos:broader' OR _skos_type = 'skos:narrower' OR
        _skos_type = 'skos:broaderTransitive' OR
        _skos_type = 'skos:narrowerTransitive') THEN

      -- (26) Wenn in der Relation "attribute_type_x_attribute_type" ein Tupel
      --      in der Spalte "relationship" eine hierarchische Beziehung
      --      ("skos:broader", "skos:narrower", "skos:broaderTransitive",
      --      "skos:narrowerTransitive") besitzt, darf es keine Schleife über
      --      n Einträge geben.
      IF (SELECT check_loop_x(_schema, _new_attribute_type_1_id,
                              _new_attribute_type_2_id, _new_relationship_id,
                              'attribute_type')) THEN
        PERFORM throw_constraint_message(26);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 27 **************************************/
/******************************************************************************/
/*
 * The columns "attribute_type_1" and "attribute_type_2" of the relation
 * "attribute_type_x_to_attribute_type" must not have the same values in same
 * tuple.
 *
 * @state   stable
 * @input   uuid: new attribute_type_1_id
 *          uuid: new attribute_type_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_27(uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_attribute_type_1_id ALIAS FOR $1;
    _new_attribute_type_2_id ALIAS FOR $2;
  BEGIN

    -- (27) Die Spalten "attribute_type_1" und "attribute_type_2" der Relation
    --      "attribute_type_x_attribute_type" dürfen in einem Tupel nicht
    --      denselben Wert besitzen.
    IF (_new_attribute_type_1_id = _new_attribute_type_2_id) THEN
      PERFORM throw_constraint_message(27);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 28 **************************************/
/******************************************************************************/
/*
 * The columns "topic_instance_1" and "topic_instance_2" of the relation
 * "topic_instance_x_to_topic_instance" must not have the same values in same
 * tuple.
 *
 * @state   stable
 * @input   uuid: new topic_instance_1_id
 *          uuid: new topic_instance_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_28(uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_topic_instance_1_id ALIAS FOR $1;
    _new_topic_instance_2_id ALIAS FOR $2;
  BEGIN

    -- (28) Die Spalten "topic_instance_1" und "topic_instance_2" der Relation
    --      "topic_instance_x_topic_instance" dürfen in einem Tupel nicht
    --      denselben Wert besitzen.
    IF (_new_topic_instance_1_id = _new_topic_instance_2_id) THEN
      PERFORM throw_constraint_message(28);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 29 **************************************/
/******************************************************************************/
/*
 * TODO: translation of constraint
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_type_id
 *          uuid: new topic_instance_1_id
 *          uuid: new topic_instance_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_29(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_type_id ALIAS FOR $2;
    _new_topic_instance_1_id ALIAS FOR $3;
    _new_topic_instance_2_id ALIAS FOR $4;
    _rt_description_id uuid;
    _multiplicity_id uuid;
    _topic_characteristic_1_id uuid;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (29) In der Relation "topic_instance" existieren zwei Tupel ti1 und ti2
    --      der "topic_characteristic" tc1 und tc2. In der Relation
    --      "topic_instance_x_topic_instance" kann ein Tupel ti1, ti2, rt nur
    --      dann eingetragen werden, wenn in der Relation
    --      "relationship_type_to_topic_characteristic" das Tupel tc1, rt und
    --      in der Relation "relationship_type" das Tupel rt, Thema von tc2
    --      existiert.
    -- retrieve the description of the relationship type
    SELECT "description" INTO _rt_description_id
      FROM "relationship_type"
     WHERE "id" = _new_relationship_type_id;

    -- retrieve the topic characteristic from topic instance 1
    SELECT "topic_characteristic_id" INTO _topic_characteristic_1_id
      FROM "topic_instance"
     WHERE "id" = _new_topic_instance_1_id;

    -- determine if relationship_type_to_topic_characteristic contrains a tuple
    -- topic characteristic 1 and relationship type
    IF ((SELECT "multiplicity"
           FROM "relationship_type_to_topic_characteristic"
          WHERE "topic_characteristic_id" = _topic_characteristic_1_id AND
                "relationship_type_id" = _new_relationship_type_id) IS NULL)
      THEN
      PERFORM throw_constraint_message(29);
      RETURN true;
    END IF;

    -- determine if relationship_type contains a tuple "topic of topic
    -- characteristic 2" and relationship type
    IF ((SELECT "rt"."id"
           FROM "topic_instance" "ti", "topic_characteristic" "tc",
                "relationship_type" "rt"
          WHERE "ti"."topic_characteristic_id" = "tc"."id" AND
                "ti"."id" = _new_topic_instance_2_id AND
                "rt"."description" = _rt_description_id AND
                "rt"."reference_to" = "tc"."topic"
          LIMIT 1
                )
      IS NULL) THEN
      PERFORM throw_constraint_message(29);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 30 **************************************/
/******************************************************************************/
/*
 * TODO: translation of constraint
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_30(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_topic_instance_id ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (30) Ein Tupel mit einer "topic_instance", welche der "topic_characteristic"
    --      tc und der "attribute_type_to_attribute_type_group" ata zugeordnet
    --      ist, kann in der Relation "attribute_value", bzw. in den erbenden
    --      Relationen, nur dann eingetragen werden, wenn in der Relation
    --      "attribute_type_group_to_topic_characteristic" ein Tupel tc, atg
    --      existiert, wobei atg Bestandteil von ata sein muss.
    IF (SELECT DISTINCT "att"."id"
          FROM "attribute_type_to_attribute_type_group" "ata",
               "attribute_type_group_to_topic_characteristic" "att",
               "topic_characteristic" "tc",
               "topic_instance" "ti"
         WHERE "ti"."topic_characteristic_id" = "tc"."id" AND
               "att"."topic_characteristic_id" = "tc"."id" AND
               "att"."id" = "ata"."attribute_type_group_to_topic_characteristic_id" AND
               "ata"."id" = _new_attribute_type_to_attribute_type_group_id AND
               "ti"."id" = _new_topic_instance_id) IS NULL THEN
      PERFORM throw_constraint_message(30);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 31 **************************************/
/******************************************************************************/
/*
 * The column "value" of the relation "attribute_value_value" must not contain
 * values with numeric seperators if the data type of the associated attribute
 * type is a numeric value (e.g. integer or numeric).
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new value
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_31(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_value ALIAS FOR $3;
    _attribute_type_id uuid;
    _data_type varchar;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    IF _new_value IS NOT NULL THEN

      -- retrieve attribute_type_id
      SELECT "attribute_type_id" INTO _attribute_type_id
        FROM "attribute_type_to_attribute_type_group"
       WHERE "id" = _new_attribute_type_to_attribute_type_group_id;

     -- retrieve the data type
     SELECT return_attribute_data_type(_schema, _attribute_type_id) INTO _data_type;
     
     IF (_data_type = 'numeric' OR _data_type = 'integer') THEN
        -- (31) Einträge in die Spalte "value" der Relation "attribute_value_value"
        --      dürfen keine tausender Trennzeichen besitzen, insofern der Datentyp
        --      des zugehörigen Attributtyps ein Zahlentyp (z. Bsp. Integer oder
        --      Numeric) ist.
        IF NOT compare_data_types(_schema, get_localized_character_string(
                   _schema, _new_value), _attribute_type_id) THEN
          PERFORM throw_constraint_message(31);
          RETURN true;
        END IF;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 32 **************************************/
/******************************************************************************/
/*
 * The content of the column "value" of the relation "attribute_value_value"
 * must be the same that was specified in the associated attribute type.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new value
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_32(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_value ALIAS FOR $3;
    _attribute_type_id uuid;
    _data_type varchar;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    IF _new_value IS NOT NULL THEN

      -- retrieve attribute_type_id
      SELECT "attribute_type_id" INTO _attribute_type_id
        FROM "attribute_type_to_attribute_type_group"
       WHERE "id" = _new_attribute_type_to_attribute_type_group_id;

      -- retrieve the data type
      SELECT return_attribute_data_type(_schema, _attribute_type_id) INTO _data_type;
     
      IF (_data_type != 'image' AND _data_type != 'file') THEN
        -- (32) Der Datentyp von "attribute_value_value" muss dem entsprechen,
        --      der im Attribut "data_type" des zugehörigen Attributtyps
        --      spezifiziert ist.
        IF NOT compare_data_types(_schema, get_localized_character_string(
                   _schema, _new_value), _attribute_type_id) THEN
          PERFORM throw_constraint_message(32);
          RETURN true;
        END IF;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 33 **************************************/
/******************************************************************************/
/*
 * The relation "attribute_value_geom" can only contain an entry, if the data
 * type of the associated "attribute_type" is "geometry(Geometry)".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          geometry(Geometry): new geometry
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_33(varchar, uuid,
                                               geometry(Geometry))
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_geometry ALIAS FOR $3;
    _attribute_type_id uuid;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- retrieve attribute_type_id
    SELECT "attribute_type_id" INTO _attribute_type_id
      FROM "attribute_type_to_attribute_type_group"
     WHERE "id" = _new_attribute_type_to_attribute_type_group_id;

    -- (33) Die Relation "attribute_value_geom" kann genau dann einen Eintrag
    --      bekommen, wenn der Datentyp des zugehörigen Attributtyps
    --      "geometry(Geometry)" ist.
    IF (_new_geometry IS NOT NULL) THEN
      IF NOT compare_data_types(_schema, CAST(_new_geometry AS text),
                                _attribute_type_id) THEN
        PERFORM throw_constraint_message(33);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 34 **************************************/
/******************************************************************************/
/*
 * The relation "attribute_value_geom" can only contain an entry, if the data
 * type of the associated "attribute_type" is "geometry(GeometryZ)".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new geometry
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_34(varchar, uuid,
                                               geometry(GeometryZ))
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_geometry ALIAS FOR $3;
    _attribute_type_id uuid;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- retrieve attribute_type_id
    SELECT "attribute_type_id" INTO _attribute_type_id
      FROM "attribute_type_to_attribute_type_group"
     WHERE "id" = _new_attribute_type_to_attribute_type_group_id;

    -- (34) Die Relation "attribute_value_geomz" kann genau dann einen Eintrag
    --      bekommen, wenn der Datentyp des zugehörigen Attributtyps
    --      "geometry(GeometryZ)" ist.
    IF (_new_geometry IS NOT NULL) THEN
      IF NOT compare_data_types(_schema, CAST(_new_geometry AS text),
                                _attribute_type_id) THEN
        PERFORM throw_constraint_message(34);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 35 **************************************/
/******************************************************************************/
/*
 * TODO: translation of constraint
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new domain_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_35(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_domain_id ALIAS FOR $3;
    _attribute_type_id uuid;
    _at_d uuid;
    _av_d uuid;
    _vlv_value uuid;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (35) Die Spalte "domain" (FK auf "value_list_values") in der Relation
    --      "attribute_value_domain" darf nur dann einen Eintrag haben, wenn das
    --      Attribut "domain" der zugehörigen Relation "attribute_type"
    --      ebenfalls einen Eintrag hat. Wenn beide Attribute nicht NULL sind,
    --      dann muss der Wert von "value_list", der den beiden Einträgen in
    --      "value_list_values" zugeordnet ist, identisch sein und der Datentyp
    --      des Attributtyps mit dem Datentyp von "value_list_value"
    --      übereinstimmen.
    IF _new_domain_id IS NOT NULL THEN

      -- retrieve the attribute_type_id
      SELECT "attribute_type_id" INTO _attribute_type_id
        FROM "attribute_type_to_attribute_type_group"
       WHERE "id" = _new_attribute_type_to_attribute_type_group_id;

      -- retrieve the value list from attribute value
      SELECT "belongs_to_value_list" INTO _av_d
        FROM "value_list_values"
       WHERE "id" = _new_domain_id;

      -- retrieve the value list from attribute type
      SELECT "domain" INTO _at_d
        FROM "attribute_type"
       WHERE "id" = _attribute_type_id;

      -- check if both value lists are the same and not NULL
      IF (_av_d IS NOT NULL AND _at_d IS NOT NULL AND _av_d = _at_d) THEN
        -- retrieve the name of the value list
        SELECT "name" INTO _vlv_value
          FROM "value_list_values"
         WHERE "id" = _new_domain_id;

        -- check if the data type of the value list and the data type of the
        -- attribute type is the same
        IF compare_data_types(_schema, get_localized_character_string(
               _schema, _vlv_value), _attribute_type_id) THEN
          RETURN false;
        END IF;
      END IF;

      -- the constraint is violated if neither the value lists are the same nor
      -- the data types match
      PERFORM throw_constraint_message(35);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 36 **************************************/
/******************************************************************************/
/*
 * Exact one tuple of the relation "project" must not have a relation to another
 * tuple of the relation "project".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new subproject_of_id
 *          uuid: old id - DEFAULT NULL
 *          uuid: old subproject_of - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_36(varchar, uuid, uuid DEFAULT NULL,
                                               uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_subproject_of_id ALIAS FOR $2;
    _old_id ALIAS FOR $3;
    _old_subproject_of_id ALIAS FOR $4;
    _count int;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- count numbers of main projects (subproject_of is null)
    SELECT count("id") INTO _count FROM "project" WHERE "subproject_of" IS NULL;

    -- (36) Es muss genau ein Tupel der Relation "project" keine Beziehung zu
    --      einem anderen Tupel der Relation "project" besitzen.
    -- new main project should be inserted but a main project already exists
    -- updating subproject of an existing project is not permitted under
    -- certain circumstances
    IF (((_count = 1) AND (_new_subproject_of_id IS NULL) AND (_old_id IS NULL)) OR
        ((_old_subproject_of_id IS NOT NULL) AND (_new_subproject_of_id IS NULL)) OR
        ((_new_subproject_of_id IS NOT NULL) AND (_old_subproject_of_id IS NULL) AND
         (_old_id IS NOT NULL))) THEN
      PERFORM throw_constraint_message(36);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 37 **************************************/
/******************************************************************************/
/*
 * A tuple of the relation "project" must have a relation to exact one other
 * tuple of the relation "project" in compilance of other project constraints.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new subproject_of_id
 *          uuid: old subproject_of_id - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_37(varchar, uuid, uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_subproject_of_id ALIAS FOR $2;
    _old_subproject_of_id ALIAS FOR $3;
    _count int;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

     -- count number of projects
    SELECT count("id") INTO _count FROM "project";

    -- if the main project will be updated, ignore the rest
    IF ((_new_subproject_of_id IS NULL) AND (_old_subproject_of_id IS NULL)) THEN
      RETURN false;
    END IF;

    -- (37) Ein Tupel der Relation "project" muss, unter Beachtung der
    --      vorangegangen Integritätsbedingung eine Beziehung zu genau einem
    --      anderen Relationstupel besitzen.
    -- projects already exists and a new one or an update should create a
    -- new project with no subproject
    IF ((_count > 0) AND (_new_subproject_of_id IS NULL)) THEN
      PERFORM throw_constraint_message(37);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 38 **************************************/
/******************************************************************************/
/*
 * A tuple of the relation "project" must not have a relation to itself.
 *
 * @state   stable
 * @input   uuid: new id
 *          uuid: new subproject_of_id
 *          uuid: old id - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_38(uuid, uuid, uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _new_subproject_of_id ALIAS FOR $2;
    _old_id ALIAS FOR $3;
  BEGIN

    -- (38) Ein Tupel der Relation "project" darf keine Beziehung zu sich
    --      selbst besitzen.
    -- check for self references in projects
    IF ((_new_subproject_of_id = _new_id) OR
        (_new_subproject_of_id = _old_id)) THEN
      PERFORM throw_constraint_message(38);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 39 **************************************/
/******************************************************************************/
/*
 * If two topic instances are related via "topic_instance_x_topic_instance", the
 * topic of "topic_instance_2" must be the same as the "reference_to" of the
 * relationship type.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_type_id
 *          uuid: new topic_instance_2_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_39(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_type_id ALIAS FOR $2;
    _new_topic_instance_2_id ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (39) Wenn zwei Themeninstanzen über "topic_instance_x_topic_instance" in
    --      Beziehung gesetzt werden, muss das Thema der "topic_instance_2" mit
    --      dem Thema des Beziehungstyps übereinstimmen.
    IF (
      (SELECT "reference_to"
         FROM "relationship_type"
        WHERE "id" = _new_relationship_type_id)
      !=
      (SELECT "topic"
         FROM "topic_characteristic"
        WHERE "id" = (SELECT "topic_characteristic_id"
                        FROM "topic_instance"
                       WHERE "id" = _new_topic_instance_2_id))
      ) THEN
      PERFORM throw_constraint_message(39);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 40 **************************************/
/******************************************************************************/
/*
 * To insert a value into the relation "attribute_value_value" the associated
 * "attribute_type" must not contain an entry in "domain".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_40(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (40) Wenn der Attributtyp einen Wertebereich besitzt, darf er nicht in
    --      "attribute_value_value" eingetragen werden.
    IF (SELECT "at"."domain"
          FROM "attribute_type" "at",
               "attribute_type_to_attribute_type_group" "ata"
         WHERE "ata"."id" = _new_attribute_type_to_attribute_type_group_id AND
               "ata"."attribute_type_id" = "at"."id") IS NOT NULL THEN
      PERFORM throw_constraint_message(40);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 41 **************************************/
/******************************************************************************/
/*
 * To insert a value into the relation "attribute_value_geom" the associated
 * "attribute_type" must not contain an entry in "domain".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_41(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (41) Wenn der Attributtyp einen Wertebereich besitzt, darf er nicht in
    --      "attribute_value_geom" eingetragen werden.
    IF (SELECT "at"."domain"
            FROM "attribute_type" "at",
                 "attribute_type_to_attribute_type_group" "ata"
           WHERE "ata"."id" = _new_attribute_type_to_attribute_type_group_id AND
                 "ata"."attribute_type_id" = "at"."id") IS NOT NULL THEN
      PERFORM throw_constraint_message(41);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 42 **************************************/
/******************************************************************************/
/*
 * To insert a value into the relation "attribute_value_domain" the associated
 * "attribute_type" must contain an entry in "domain".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_42(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (42) Der Attributtyp muss einen Wertebereich besitzen, damit er in
    --      "attribute_value_domain" eingetragen werden kann.
    IF (SELECT "at"."domain"
            FROM "attribute_type" "at",
                 "attribute_type_to_attribute_type_group" "ata"
           WHERE "ata"."id" = _new_attribute_type_to_attribute_type_group_id AND
                 "ata"."attribute_type_id" = "at"."id") IS NULL THEN
      PERFORM throw_constraint_message(42);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 43 **************************************/
/******************************************************************************/
/*
 * TODO: translate constraint
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new relationship_type_id
 *          uuid: new topic_instance_1_id
 *          uuid: old relationship_type_id - DEFAULT NULL
 *          uuid: old topic_instance_1_id - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_43(varchar, uuid, uuid,
                                               uuid DEFAULT NULL,
                                               uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_relationship_type_id ALIAS FOR $2;
    _new_topic_instance_1_id ALIAS FOR $3;
    _old_relationship_type_id ALIAS FOR $4;
    _old_topic_instance_1_id ALIAS FOR $5;
    _topic_characteristic_1_id uuid;
    _multiplicity record;
    _multiplicity_id uuid;
    _min integer;
    _max integer;
    _count integer;
    _delete boolean;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- special treatment for delete because new values are NULL
    IF (_new_topic_instance_1_id IS NULL AND _new_relationship_type_id IS NULL)
      THEN
      _new_topic_instance_1_id := _old_topic_instance_1_id;
      _new_relationship_type_id := _old_relationship_type_id;
      _delete := true;
    END IF;

    -- retrieve the topic characteristic from topic instance 1
    SELECT "topic_characteristic_id" INTO _topic_characteristic_1_id
      FROM "topic_instance"
     WHERE "id" = _new_topic_instance_1_id;

    -- determine if relationship_type_to_topic_characteristic contrains a tuple
    -- topic characteristic 1 and relationship type
    SELECT "multiplicity" INTO _multiplicity_id
      FROM "relationship_type_to_topic_characteristic"
     WHERE "topic_characteristic_id" = _topic_characteristic_1_id AND
           "relationship_type_id" = _new_relationship_type_id;

    -- ermittle min_value und max_value für die
    -- relationship_type_to_topic_characteristic
    SELECT min_value, max_value INTO _multiplicity
      FROM "multiplicity"
     WHERE "id" = _multiplicity_id;
    _min := _multiplicity.min_value;
    _max := _multiplicity.max_value;

    -- zählen wieviel Verknüpfungen zwischen ti's vorhanden sind, die zur tc von
    -- ti1 gehören und rt_id besitzen
    SELECT count("tixti"."topic_instance_1")
      INTO _count
      FROM "topic_instance_x_topic_instance" "tixti", "topic_instance" "ti"
     WHERE "ti"."id" = "tixti"."topic_instance_1" AND
           "ti"."topic_characteristic_id" = _topic_characteristic_1_id AND
           "tixti"."relationship_type_id" = _new_relationship_type_id;

    -- (43) Ein Tupel in der Relation "topic_instance_x_topic_instance" darf nur
    --      sooft auftreten, wie es in "relationship_type_to_topic_characteristic"
    --      durch "multiplicity" definiert ist. Dabei gelten folgende
    --      Kardinaltitäten: 0 – optional, Zahl – Wert der Zahl, NULL – beliebig
    --      viele.
    -- wenn es sich um einen Aufruf aus einem Delete Trigger handelt, muss der
    -- min_value beachtet werden
    IF (_delete) THEN
      IF (_count-1 < _min) THEN
        PERFORM throw_constraint_message(43);
        RETURN true;
      END IF;
    END IF;

    -- es darf nur max_value Einträge geben, falls NULL dann unbeschränkt
    IF (_count+1 > _max) THEN
      PERFORM throw_constraint_message(43);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 44 **************************************/
/******************************************************************************/
/*
 * The character code in "character_code" must be the same as the character code
 * of the database.
 *
 * @state   stable
 * @input   varchar: new character code
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_44(varchar)
  RETURNS boolean AS $$
  DECLARE
    _new_character_code ALIAS FOR $1;
  BEGIN

    -- (44) Die Zeichenkodierung in "character_code" muss mit der
    --      Zeichenkodierung der Datenbank übereinstimmen.
    -- compare the character code of the database with the new character code
    IF ((SELECT pg_encoding_to_char(encoding)
           FROM pg_database
          WHERE datname = current_database()) != _new_character_code) THEN
      PERFORM throw_constraint_message(44);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 45 **************************************/
/******************************************************************************/
/*
 * The maximum multiplicity of "attribute_type_to_attribute_type_group"
 * multiplied with the multiplicity of
 * "attribute_type_group_to_topic_characteristic", if not NULL, must be reflected
 * in the colum count of "attribute_type_to_attribute_type_group". The values of
 * "attribute_type_id" and "attribute_type_group_id" must have
 * the same values in "attribute_type_to_attribute_type_group".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_id
 *          uuid: new attribute_type_group_id
 *          uuid: new attribute_type_group_to_topic_characteristic_id
 *          uuid: new multiplicity_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_45(varchar, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_id ALIAS FOR $2;
    _new_attribute_type_group_id ALIAS FOR $3;
    _new_attribute_type_group_to_topic_characteristic_id ALIAS FOR $4;
    _new_multiplicity_id ALIAS FOR $5;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (45) Die maximale "multiplicity" von "attribute_type_to_attribute_type_group"
    --      multipliziert mit der "multiplicity" von
    --      "attribute_type_group_to_topic_characteristic", insofern nicht NULL,
    --      muss sich in der maximalen Anzahl der Spalten von
    --      "attribute_type_to_attribute_type_group" widerspiegeln. Dabei müssen
    --      die Werte für "attribute_type_id" und "attribute_type_group_id" in
    --      "attribute_type_to_attribute_type_group" immer dieselben sein.
    IF check_multiplicity_for_ata (
         _schema, _new_attribute_type_id, _new_attribute_type_group_id,
         _new_attribute_type_group_to_topic_characteristic_id,
         _new_multiplicity_id) THEN
      PERFORM throw_constraint_message(45);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 46 **************************************/
/******************************************************************************/
/*
 * The name of the default value lists "vl_relationship_type", "vl_data_type",
 * "vl_unit", "vl_skos_relationship" or "vl_topic" must not be updated or
 * deleted from the relation "value_list"
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new name
 *          uuid: old name
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_46(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_name_id ALIAS FOR $2;
    _old_name_id ALIAS FOR $3;
    _name varchar;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (46) Die Standardwertelisten "vl_relationship_type", "vl_data_type",
    --      "vl_unit", "vl_skos_relationship" oder "vl_topic" dürfen nicht aus
    --      "value_list" gelöscht oder geändert (Name) werden.
    -- retrieve the english name of the value list
    SELECT get_localized_character_string(_schema, _old_name_id,
                                          get_pt_locale_id(_schema))
      INTO _name;

    -- compare the name with the default value lists
    CASE _name
      WHEN 'vl_relationship_type', 'vl_data_type',
           'vl_unit', 'vl_skos_relationship', 'vl_topic'THEN
        PERFORM throw_constraint_message(46);
        RETURN true;
      ELSE
        RETURN false;
    END CASE;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 47 **************************************/
/******************************************************************************/
/*
 * To insert a value into the relation "attribute_value_geomz" the associated
 * "attribute_type" must not contain an entry in "domain"
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_47(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (47) Wenn der Attributtyp einen Wertebereich besitzt, darf er nicht in
    --      "attribute_value_geomz" eingetragen werden.
    IF (SELECT "at"."domain"
            FROM "attribute_type" "at",
                 "attribute_type_to_attribute_type_group" "ata"
           WHERE "ata"."id" = _new_attribute_type_to_attribute_type_group_id AND
                 "ata"."attribute_type_id" = "at"."id") IS NOT NULL THEN
      PERFORM throw_constraint_message(47);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 48 **************************************/
/******************************************************************************/
/*
 * The column "unit" of the relation "attribute_type" must not be changed if an
 * entry from "attribute_value" uses this attribute type.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new unit_id
 *          uuid: old unit_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_48(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_unit_id ALIAS FOR $3;
    _old_unit_id ALIAS FOR $4;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (48) Die Spalte "unit" in "attribute_type" darf nicht verändert werden,
    --      wenn ein Eintrag in "attribute_value" diesen Attributtyp verwendet.
    IF ((_new_unit_id IS NOT NULL) AND (_new_unit_id != _old_unit_id) AND
        (SELECT
           "av"."id"
         FROM
           "attribute_value" "av",
           "attribute_type_to_attribute_type_group" "ata"
         WHERE
           "ata"."id" = "av"."attribute_type_to_attribute_type_group_id" AND
           "ata"."attribute_type_id" = _new_id LIMIT 1) IS NOT NULL) THEN
      PERFORM throw_constraint_message(48);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 49 **************************************/
/******************************************************************************/
/*
 * The column "domain" of the relation "attribute_type" must not be changed if an
 * entry from "attribute_type_to_attribute_type_group" uses this attribute type.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new domain_id
 *          uuid: old domain_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_49(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_domain_id ALIAS FOR $3;
    _old_domain_id ALIAS FOR $4;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (49) Die Spalte "domain" in "attribute_type" darf nicht verändert werden,
    --      wenn ein Eintrag in "attribute_type_to_attribute_type_group" diesen
    --      Attributtyp verwendet.
    IF ((_new_domain_id IS NOT NULL) AND (_new_domain_id != _old_domain_id) AND
        (SELECT "attribute_type_id" FROM "attribute_type_to_attribute_type_group"
          WHERE "attribute_type_id" = _new_id LIMIT 1) IS NOT NULL) THEN
      PERFORM throw_constraint_message(49);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 50 **************************************/
/******************************************************************************/
/*
 * A tuple from the relation "attribute_type_group" must not have a relation to
 * itself.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new subgroup_of_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_50(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_subgroup_of_id ALIAS FOR $3;
  BEGIN

    -- (50) Ein Tupel der Relation "attribute_type_group" darf keine Beziehung
    --      zu sich selbst besitzen.
    -- check for self references in attribute_type_group
    IF (_new_subgroup_of_id = _new_id) THEN
      PERFORM throw_constraint_message(50);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 51 **************************************/
/******************************************************************************/
/*
 * If their is a tuple with an entry in the column "subgroup_of" of the relation
 * "attribute_type_group" it must not create a loop inside the relation over
 * n entries.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new subgroup_of
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_51(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_subgroup_of ALIAS FOR $3;
  BEGIN

    -- (51) Wenn in der Relation "attribute_type_group" ein Tupel in der Spalte
    --      "subgroup_of" einen Eintrag besitzt, darf es keine Schleife über
    --      n Einträge geben.
    IF (SELECT check_loop_sub(_schema, _new_id, _new_subgroup_of,
                            'attribute_type_group', 'subgroup_of')) THEN
      PERFORM throw_constraint_message(51);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 52 **************************************/
/******************************************************************************/
/*
 * The columns "language_code", "country_code" and "character_code" from the
 * relation "pt_locale" must be joint unique. The value NULL, which can apear
 * in the column "country_code", must be considered as an independent value.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new language_code
 *          uuid: new country_code
 *          uuid: new character_code
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_52(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_language_code_id ALIAS FOR $2;
    _new_country_code_id ALIAS FOR $3;
    _new_character_code_id ALIAS FOR $4;
    _result record;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (52) Die Spalten "language_code_id", "country_code_id" und
    --      "character_code_id" der Tabelle "pt_locale" müssen gemeinsam UNIQUE
    --      sein. Dabei muss der Wert NULL, der in "country_code_id" auftauchen
    --      kann, als eigenständiger Wert betrachtet.
    -- retrieve country_code and count of results based on the language_code_id
    -- and character_code_id
    SELECT "country_code_id" AS "country_code", count("id") AS "count" INTO _result
      FROM "pt_locale"
     WHERE "language_code_id" = _new_language_code_id AND
           "character_code_id" = _new_character_code_id
           GROUP BY "id";

    -- check if an entry was found
    IF ((_result.count IS NOT NULL)) THEN

      -- if the retrieved country code and the new country code is the same
      -- OR if the retrieved country code IS NULL and the new country code IS NULL
      IF (_result.country_code = _new_country_code_id) OR
         ((_result.country_code IS NULL) AND (_new_country_code_id IS NULL)) THEN
        PERFORM throw_constraint_message(52);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 53 **************************************/
/******************************************************************************/
/*
 * The maximum multiplicity of "attribute_type_group_to_topic_characteristic"
 * multiplied with sum of the multiplicity of
 * "attribute_type_to_attribute_type_group", if not NULL, must be reflected in
 * the colum count of "attribute_type_group_to_topic_characteristic". The
 * values of "attribute_type_group_id" and "topic_characteristic_id" must have
 * the same values in "attribute_type_group_to_topic_characteristic".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_group_id
 *          uuid: new topic_characteristic_id
 *          uuid: new multiplicity
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_53(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_group_id ALIAS FOR $2;
    _new_topic_characteristic_id ALIAS FOR $3;
    _new_multiplicity ALIAS FOR $4;
    _result record;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (53) Die maximale "multiplicity" von
    --      "attribute_type_group_to_topic_characteristic" multipliziert mit der
    --      Summe der maximalen "multiplicity" von
    --      "attribute_type_to_attribute_type_group", insofern nicht NULL,
    --      muss sich in der maximalen Anzahl der Spalten von
    --      "attribute_type_group_to_topic_characteristic" widerspiegeln. Dabei
    --      müssen die Werte für "attribute_type_group_id" und
    --      "topic_characteristic_id" in
    --      "attribute_type_group_to_topic_characteristic" immer dieselben sein.
    IF check_multiplicity_for_att(
         _schema, _new_attribute_type_group_id, _new_topic_characteristic_id,
         _new_multiplicity) THEN
      PERFORM throw_constraint_message(53);
      RETURN true;
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************************ 54 **************************************/
/******************************************************************************/
/*
 * TODO: translate constraint
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_value_id
 *          uuid: new attribute_type_group_id
 *          uuid: old attribute_value_id - DEFAULT NULL
 *          uuid: old attribute_type_group_id - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_54(varchar, uuid, uuid,
                                               uuid DEFAULT NULL,
                                               uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_topic_instance_id ALIAS FOR $3;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $4;
    _old_topic_instance_id ALIAS FOR $5;
    _topic_characteristic_id uuid;
    _multiplicity record;
    _multiplicity_id uuid;
    _min integer;
    _max integer;
    _count integer;
    _delete boolean := false;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- special treatment for delete because new values are NULL
    IF (_new_attribute_type_to_attribute_type_group_id IS NULL 
        AND _new_topic_instance_id IS NULL)
      THEN
      _new_attribute_type_to_attribute_type_group_id := 
            _old_attribute_type_to_attribute_type_group_id;
      _new_topic_instance_id := _old_topic_instance_id;
      _delete := true;
    END IF;

    -- retrieve the topic characteristic from topic instance
    SELECT "topic_characteristic_id" INTO _topic_characteristic_id
      FROM "topic_instance"
     WHERE "id" = _new_topic_instance_id;
     
    -- retrieve the multiplicity from attribute_type_to_attribute_type_group
    SELECT "multiplicity" INTO _multiplicity_id
      FROM "attribute_type_to_attribute_type_group"
     WHERE "id" = _new_attribute_type_to_attribute_type_group_id;

    -- retrieve the min_value and max_value from the multiplicity
    SELECT min_value, max_value INTO _multiplicity
      FROM "multiplicity"
     WHERE "id" = _multiplicity_id;
    _min := _multiplicity.min_value;
    _max := _multiplicity.max_value;

    -- count numbers of attribute values that already exists for the specified
    -- attribute_type_to_attribute_type_group
    SELECT count("id")
      INTO _count
      FROM "attribute_value"
     WHERE "attribute_type_to_attribute_type_group_id" = _new_attribute_type_to_attribute_type_group_id 
       AND "topic_instance_id" = _new_topic_instance_id;

    -- (54) Ein Tupel in der Relation "attribute_value" darf nur sooft 
    --      auftreten, wie es in "attribute_type_to_attribute_type_group" durch
    --      "multiplicity" definiert ist. Dabei gelten folgende Kardinaltitäten:
    --      0 – optional, Zahl – Wert der Zahl, NULL – beliebig.
    -- respect the min_value if we come from a delete trigger
    IF (_delete) THEN
      IF (_count-1 < _min) THEN
        PERFORM throw_constraint_message(54);
        RETURN true;
      END IF;
    END IF;

    -- there must be only max_value entries or unlimited if max_value is null
    IF (_count+1 > _max) THEN
      PERFORM throw_constraint_message(54);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************************ 55 **************************************/
/******************************************************************************/
/*
 * If their is a tuple with an entry in the column "subproject_of" of the
 * relation "project" it must not create a loop inside the relation over
 * n entries.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new subproject_of_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_55(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_subproject_of_id ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (55) Wenn in der Relation "project" ein Tupel in der Spalte
    --      "subproject_of" einen Eintrag besitzt, darf es keine Schleife über
    --      n Einträge geben.
    IF (SELECT check_loop_sub(_schema, _new_id, _new_subproject_of_id,
                              'project', 'subproject_of')) THEN
      PERFORM throw_constraint_message(55);
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 56 **************************************/
/******************************************************************************/
/*
 * If the assignment of an "attribute_type_id", used by an "attribute_value",
 * to an "attribute_type_group_id" in the relation
 * "attribute_type_to_attribute_type_group" is changed, it must be ensured that
 * the new "attribute_type_group" is associated to the same
 * "topic_characteristic" as the old "attribute_type_group, via
 * "attribute_type_group_to_topic_characteristic".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new attribute_type_group_to_topic_characteristic_id
 *          uuid: old id
 *          uuid: old attribute_type_group_to_topic_characteristic_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_56(varchar, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_attribute_type_group_to_topic_characteristic_id ALIAS FOR $3;
    _old_id ALIAS FOR $4;
    _old_attribute_type_group_to_topic_characteristic_id ALIAS FOR $5;
    _new_topic_characteristic_id uuid;
    _old_topic_characteristic_id uuid;
  BEGIN
    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (56) Wenn in der Tabelle "attribute_type_to_attribute_type_group" die
    --      Zuordnung einer "attribute_type_id“ zu einer anderen
    --      "attribute_type_group_id" geändert wird, muss sichergestellt
    --      werden, falls es einen "attribute_value" zu dem "attribute_type"
    --      gibt, dass die Zuordnung der neuen "attribute_type_group" zur
    --      selben "topic_characteristic" über
    --      "attribute_type_group_to_topic_characteristic" gehört, wie die
    --      alte "attribute_type_group".
    -- check if there is a attribute_value for the old
    -- attribute_type_to_attribute_type_group combination
    IF ((SELECT "id"
          FROM "attribute_value"
         WHERE "attribute_type_to_attribute_type_group_id" = _old_id)
         IS NOT NULL
       ) THEN

      -- retrieve the topic_characteristic of the old combination
      SELECT "topic_characteristic_id"
        INTO _old_topic_characteristic_id
        FROM "attribute_type_group_to_topic_characteristic"
       WHERE "id" = _old_attribute_type_group_to_topic_characteristic_id;

      -- retrieve the topic_characteristic of the new combination
      SELECT "topic_characteristic_id"
        INTO _new_topic_characteristic_id
        FROM "attribute_type_group_to_topic_characteristic"
       WHERE "id" = _new_attribute_type_group_to_topic_characteristic_id;

      -- compare both topic_characteristic_ids
      IF (_new_topic_characteristic_id != _old_topic_characteristic_id) THEN
        PERFORM throw_constraint_message(56);
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 57 **************************************/
/******************************************************************************/
/*
 *
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new belongs_to_value_list_id
 *          uuid: old belongs_to_value_list_id
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_57(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_belongs_to_value_list_id ALIAS FOR $2;
    _old_belongs_to_value_list_id ALIAS FOR $3;
  BEGIN

    -- check if the belongs_to_value_list_id has changed
    IF (_new_belongs_to_value_list_id = _old_belongs_to_value_list_id) THEN
      RETURN false;
    END IF;

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- (57) Wenn ein Wert in "value_list_values" einer der Wertelisten
    --      "vl_relationship_type", "vl_data_type", "vl_unit",
    --      "vl_skos_relationship" oder "vl_topic" in "value_list" zugeordnet
    --      wird, darf dieser Wert nicht bereits in anderen Tabellen
    --      referenziert werden.
    -- check if the new belongs_to_value_list_id belongs to a default value list
    IF (_new_belongs_to_value_list_id IN (
      SELECT
        "vl"."id"
      FROM
        "value_list" "vl",
        "localized_character_string" "lcs"
      WHERE
        "vl"."name" = "lcs"."pt_free_text_id" AND
        "lcs"."pt_locale_id" = get_pt_locale_id(_schema) AND
        ("lcs"."free_text" = 'vl_unit' OR
         "lcs"."free_text" = 'vl_data_type' OR
         "lcs"."free_text" = 'vl_topic' OR
         "lcs"."free_text" = 'vl_relationship_type' OR
         "lcs"."free_text" = 'vl_skos_relationship')
      )
    ) THEN
      -- check if the id is used in other tables
      IF (SELECT "at"."id"
            FROM "attribute_type" "at",
                 "attribute_type_to_attribute_type_group" "ata",
                 "attribute_type_x_attribute_type" "axa",
                 "attribute_value_domain" "avd",
                 "relationship_type" "rt",
                 "topic_characteristic" "tc",
                 "value_list_values_x_value_list_values" "vlvxvlv",
                 "value_list_x_value_list" "vlxvl"
           WHERE "at"."data_type" = _new_belongs_to_value_list_id OR
                 "at"."unit" = _new_belongs_to_value_list_id OR
                 "ata"."default_value" = _new_belongs_to_value_list_id OR
                 "axa"."relationship" = _new_belongs_to_value_list_id OR
                 "avd"."domain" = _new_belongs_to_value_list_id OR
                 "rt"."description" = _new_belongs_to_value_list_id OR
                 "rt"."reference_to" = _new_belongs_to_value_list_id OR
                 "tc"."topic" = _new_belongs_to_value_list_id OR
                 "vlvxvlv"."relationship" = _new_belongs_to_value_list_id OR
                 "vlvxvlv"."value_list_values_1" = _new_belongs_to_value_list_id OR
                 "vlvxvlv"."value_list_values_2" = _new_belongs_to_value_list_id OR
                 "vlxvl"."relationship" = _new_belongs_to_value_list_id
           LIMIT 1) IS NOT NULL THEN
        PERFORM throw_constraint_message(57);
        RETURN true;
      END IF;

    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 58 **************************************/
/******************************************************************************/
/*
 * It is not possible to change the internal id of an entry in
 * localized_character_string.
 *
 * @state   stable
 * @input   uuid: new pt_free_text_id
 *          uuid: old pt_free_text_id - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_58(uuid, uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _new_pt_free_text_id ALIAS FOR $1;
    _old_pt_free_text_id ALIAS FOR $2;
  BEGIN

    -- if the UPDATE trigger was fired
    IF (_new_pt_free_text_id IS NOT NULL AND
        _old_pt_free_text_id IS NOT NULL) THEN
      -- (58) Es ist nicht möglich, die "pt_free_text_id" eines Eintrag in
      --      "localized_character_string" zu ändern.
      IF (_new_pt_free_text_id != _old_pt_free_text_id) THEN
        PERFORM throw_constraint_message(58);
        RETURN true;
      END IF;
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************************ 59 **************************************/
/******************************************************************************/
/*
 * The "free_text" from the relation "localized_character_string" must not be
 * used in the column "name" of the relation "attribute_type" by another
 * "pt_free_text_id".
 *
 * @state   stable
 * @input   varchar: schema
 *          uuid: pt_free_text_id of the free text
 *          boolean: update operation - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_59(varchar, uuid,
                                               boolean DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _pt_free_text_id ALIAS FOR $2;
    _update_operation ALIAS FOR $3;
    _free_text record;
  BEGIN

    -- retrieve the text from the pt_free_text_id in all languages
    FOR _free_text IN SELECT "free_text" FROM "localized_character_string"
                      WHERE "pt_free_text_id" = _pt_free_text_id
    LOOP
      -- check the free text in every language for uniqueness
      -- (59) Der "free_text" von "localized_character_string" darf in der
      --      Spalte "name" der Tabelle "attribute_type" nicht bereits mit einer
      --      anderen "pt_free_text_id" verwendet werden.
      IF (uniqueness(_schema, 'attribute_type', 'name', _free_text."free_text",
                     _update_operation)) THEN
        PERFORM throw_constraint_message(59);
        RETURN true;
      END IF;
    END LOOP;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************************ 60 **************************************/
/******************************************************************************/
/*
 * The "free_text" from the relation "localized_character_string" must not be
 * used in the column "name" of the relation "project" by another
 * "pt_free_text_id".
 *
 * @state   stable
 * @input   varchar: schema
 *          uuid: pt_free_text_id of the free text
 *          boolean: update operation - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_60(varchar, uuid,
                                               boolean DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _pt_free_text_id ALIAS FOR $2;
    _update_operation ALIAS FOR $3;
    _free_text record;
  BEGIN

    -- retrieve the text from the pt_free_text_id in all languages
    FOR _free_text IN SELECT "free_text" FROM "localized_character_string"
                      WHERE "pt_free_text_id" = _pt_free_text_id
    LOOP
      -- check the free text in every language for uniqueness
      -- (60) Der "free_text" von "localized_character_string" darf in der
      --      Spalte "name" der Tabelle "project" nicht bereits mit einer
      --      anderen "pt_free_text_id" verwendet werden.
      IF (uniqueness(_schema, 'project', 'name', _free_text."free_text",
                     _update_operation)) THEN
        PERFORM throw_constraint_message(60);
        RETURN true;
      END IF;
    END LOOP;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************************ 61 **************************************/
/******************************************************************************/
/*
 * The "free_text" from the relation "localized_character_string" must not be
 * used in the column "description" of the relation "topic_characteristic" by
 * another "pt_free_text_id".
 *
 * @state   stable
 * @input   varchar: schema
 *          uuid: pt_free_text_id of the free text
 *          boolean: update operation - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_61(varchar, uuid,
                                               boolean DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _pt_free_text_id ALIAS FOR $2;
    _update_operation ALIAS FOR $3;
    _free_text record;
  BEGIN

    -- retrieve the text from the pt_free_text_id in all languages
    FOR _free_text IN SELECT "free_text" FROM "localized_character_string"
                      WHERE "pt_free_text_id" = _pt_free_text_id
    LOOP
      -- check the free text in every language for uniqueness
      -- (61) Der "free_text" von "localized_character_string" darf in der
      --      Spalte "description" der Tabelle "topic_characteristic" nicht
      --      bereits mit einer anderen "pt_free_text_id" verwendet werden.
      IF (uniqueness(_schema, 'topic_characteristic', 'description',
                     _free_text."free_text", _update_operation)) THEN
        PERFORM throw_constraint_message(61);
        RETURN true;
      END IF;
    END LOOP;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************************ 62 **************************************/
/******************************************************************************/
/*
 * The "free_text" from the relation "localized_character_string" must not be
 * used in the column "name" of the relation "value_list" by another
 * "pt_free_text_id".
 *
 * @state   stable
 * @input   varchar: schema
 *          uuid: pt_free_text_id of the free text
 *          boolean: update operation - DEFAULT NULL
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_62(varchar, uuid,
                                               boolean DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _pt_free_text_id ALIAS FOR $2;
    _update_operation ALIAS FOR $3;
    _free_text record;
  BEGIN

    -- retrieve the text from the pt_free_text_id in all languages
    FOR _free_text IN SELECT "free_text" FROM "localized_character_string"
                      WHERE "pt_free_text_id" = _pt_free_text_id
    LOOP
      -- check the free text in every language for uniqueness
      -- (62) Der "free_text" von "localized_character_string" darf in der
      --      Spalte "name" der Tabelle "value_list" nicht bereits mit einer
      --      anderen "pt_free_text_id" verwendet werden.
      IF (uniqueness(_schema, 'value_list', 'name', _free_text."free_text",
                     _update_operation)) THEN
        PERFORM throw_constraint_message(62);
        RETURN true;
      END IF;
    END LOOP;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************************ 63 **************************************/
/******************************************************************************/
/*
 * Values of the value list "vl_data_type" and "vl_skos_relationship" must not
 * be updated or deleted. Also inserts are inhibit.
 *
 * @state   stable
 * @input   varchar: schema
 *          uuid: belongs_to_value_list
 * @output  boolean: true if constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_constraint_63(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _belongs_to_value_list ALIAS FOR $2;
    _tmp varchar;
  BEGIN

    -- get the name of the value list the value should belong to
    SELECT get_localized_character_string(_schema, "name", get_pt_locale_id(_schema))
      FROM "value_list"
     WHERE "id" = _belongs_to_value_list INTO _tmp;

    -- if the value list is vl_data_type
    -- (63) Die Werte der Werteliste "vl_data_type" und "vl_skos_relationship"
    --      dürfen nicht verändert oder gelöscht werden. Ebenso dürfen keine
    --      neuen Werte eingetragen werden.
    IF (_tmp = 'vl_data_type' OR _tmp = 'vl_skos_relationship') THEN
      PERFORM throw_constraint_message(63);
      RETURN true;
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';
