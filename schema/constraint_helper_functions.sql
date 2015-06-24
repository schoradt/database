/*
 * changelog from 29.05.2015
 * - constraint 63 added
 *
 * changelog from 06.05.2015
 * - function "uniquenss" enhanced for calls from update functions
 *
 * changelog from 06.05.2015
 * - new functions for multiplicity checks added, old removed
 *
 * changelog from 16.04.2015
 * - function for uniqueness added
 *
 * changelog from 31.03.2015
 * - functions refactored
 *
 * changelog from 18.03.2015
 * - fixed bug in function check
 * - constraint 54 and 12 updated
 *
 * changelog from 01.06.2015
 * - quote_ident schema in SET SEARCH PATH operations
 * - preliminary test for project schema in get_current_project_schema
 *
 */
/******************************************************************************/
/***************************** schema definition ******************************/
/******************************************************************************/
-- creates schema for constraints
CREATE SCHEMA IF NOT EXISTS "constraints";

-- set search path to created constraints schema
SET search_path TO "constraints", public;
SET CLIENT_ENCODING TO "UTF8";



/******************************************************************************/
/************************ functions for error output **************************/
/******************************************************************************/
/*
 * Creates an error message for violating a constraint by inserting into a
 * given table. Calling this function will end a running script. This function
 * was designed as trigger function.
 *
 * @state   stable
 * @input   varchar: table name for error message
 */
CREATE OR REPLACE FUNCTION insert_violation_on_trigger()
  RETURNS "trigger" AS $$
  BEGIN
    RAISE EXCEPTION
      'Integrity violation while inserting into table "%".', TG_ARGV[0];
    RETURN NULL;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Creates an error message for violating a constraint by updating a given
 * table. Calling this function will end a running script. This function was
 * designed as trigger function.
 *
 * @state   stable
 * @input   varchar: table name for error message
 */
CREATE OR REPLACE FUNCTION update_violation_on_trigger()
  RETURNS "trigger" AS $$
  BEGIN
    RAISE EXCEPTION
      'Integrity violation while updating table "%".', TG_ARGV[0];
    RETURN NULL;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Creates an error message for violating a constraint by deleting from a
 * given table. Calling this function will end a running script. This function
 * was designed as trigger function.
 *
 * @state   stable
 * @input   varchar: table name for error message
 */
CREATE OR REPLACE FUNCTION delete_violation_on_trigger()
  RETURNS "trigger" AS $$
  BEGIN
    RAISE EXCEPTION
      'Integrity violation while deleting a row in table "%"', TG_ARGV[0];
    RETURN NULL;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Creates an error message for violating a constraint by inserting into a
 * given table. Calling this function will end a running script. This function
 * was designed as rule function.
 *
 * @state   stable
 * @input   varchar: table name for error message
 */
CREATE OR REPLACE FUNCTION insert_violation_on_rule(varchar)
  RETURNS integer AS $$
  BEGIN
    RAISE EXCEPTION
      'Integrity violation while inserting into table "%"', $1;
    RETURN 0;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Creates an error message for violating a constraint by updating a given
 * table. Calling this function will end a running script. This function was
 * designed as rule function.
 *
 * @state   stable
 * @input   varchar: table name for error message
 */
CREATE OR REPLACE FUNCTION update_violation_on_rule(varchar)
  RETURNS integer AS $$
  BEGIN
    RAISE EXCEPTION
      'Integrity violation while updating table "%"', $1;
    RETURN 0;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Creates an error message for violating a constraint by deleting from a
 * given table. Calling this function will end a running script. This function
 * was designed as rule function.
 *
 * @state   stable
 * @input   varchar: table name for error message
 */
CREATE OR REPLACE FUNCTION delete_violation_on_rule(varchar)
  RETURNS integer AS $$
  BEGIN
    RAISE EXCEPTION
      'Integrity violation while deleting a row in table "%"', $1;
    RETURN 0;
  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/************************* functions for constraints **************************/
/******************************************************************************/
/*
 * This function throws an exception that represent the constraint message.
 * Depending on the passed integer value a message will be generated and thrown
 * as exception.
 *
 * @state   stable
 * @input   integer: constraint number
 */
CREATE OR REPLACE FUNCTION throw_constraint_message(integer)
  RETURNS void AS $$
  DECLARE
    _constraint ALIAS FOR $1;
    _message varchar;
  BEGIN
    -- create the message for the passed contraint number
    CASE _constraint
      WHEN 1 THEN
        _message := 'Constraint 1 - Die Spalte "min_value" der Relation "multiplicity" muss >= 0 sein.';
      WHEN 2 THEN
        _message := 'Constraint 2 - Die Spalte "max_value" der Relation "multiplicity" muss > 0 sein.';
      WHEN 3 THEN
        _message := 'Constraint 3 - Die Spalte "max_value" der Relation "multiplicity" muss >= dem "Min-Wert" sein.';
      WHEN 4 THEN
        _message := 'Constraint 4 - Die Spalte "language_code" der Relation "language_code" muss genau 2 Zeichen beinhalten.';
      WHEN 5 THEN
        _message := 'Constraint 5 - Die Spalte "country_code" der Relation "country_code" muss genau 2 Zeichen beinhalten.';
      WHEN 6 THEN
        _message := 'Constraint 6 - Die Spalte "unit" der Relation "attribute_type" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_unit" befinden.';
      WHEN 7 THEN
        _message := 'Constraint 7 - Die Spalte "data_type" der Relation "attribute_type" muss entweder Numeric oder Integer zugeordnet bekommen, insofern eine Einheit zugeordnet wurde.';
      WHEN 8 THEN
        _message := 'Constraint 8 - Die Spalte "data_type" der Relation "attribute_type" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_data_type" befinden.';
      WHEN 9 THEN
        _message := 'Constraint 9 - Die Spalte "domain" der Relation "attribute_type" darf ausschließlich Werte aus "value_list" zugeordnet bekommen, welche nicht "vl_relationship_type", "vl_data_type", "vl_unit", "vl_skos_relationship" oder "vl_topic" entsprechen.';
      WHEN 11 THEN
        _message := 'Constraint 11 - Die Spalte "default_value" der Relation "attribute_type_to_attribute_type_group" darf nur dann einen Eintrag besitzen, wenn das Attribut "domain" der zugehörigen Relation "attribute_type" ebenfalls einen Eintrag hat. Wenn beide Attribute nicht NULL sind, dann muss der "value_list_value“ von "default_value" aus der "domain" zugeordneten "value_list" stammen.';
      WHEN 12 THEN
        _message := 'Constraint 12 - Durch das Aktualisieren oder Löschen eines Eintrages in der Relation "attribute_type_group_to_topic_characteristic", darf kein Eintrag geändert oder entfernt werden, dessen "attribute_type" der betroffenen "attribute_type_group" durch einen "attribute_value" verwendet wird.';
      WHEN 13 THEN
        _message := 'Constraint 13 - Die Spalte "reference_to" der Relation "relationship_type" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, bei denen der zugehörige Wert aus "value_list" den Wert "vl_topic" hat.';
      WHEN 14 THEN
        _message := 'Constraint 14 - Die Spalte "description" der Relation "relationship_type" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_relationship_type" befinden.';
      WHEN 15 THEN
        _message := 'Constraint 15 - Die Spalte "topic" der Relation "topic_characteristic" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_topic" befinden.';
      WHEN 16 THEN
        _message := 'Constraint 16 - Die Spalte "relationship" der Relation "value_list_x_value_list" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_skos_relationship" befinden.';
      WHEN 17 THEN
        _message := 'Constraint 17 - Wenn in der Relation "value_list_x_value_list" ein Tupel in der Spalte "relationship" eine hierarchische Beziehung ("skos:broader", "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive") besitzt, darf dieselbe Attributtypenkombination nicht invertiert mit derselben Beziehungsart auftreten.';
      WHEN 18 THEN
        _message := 'Constraint 18 - Wenn in der Relation "value_list_x_value_list" ein Tupel in der Spalte "relationship" eine hierarchische Beziehung ("skos:broader", "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive") besitzt, darf es keine Schleife über n Einträge geben.';
      WHEN 19 THEN
        _message := 'Constraint 19 - Die Spalten "value_list_1" und "value_list_2" der Relation "value_list_x_value_list" dürfen in einem Tupel nicht denselben Wert besitzen.';
      WHEN 20 THEN
        _message := 'Constraint 20 - Die Spalte "relationship" der Relation "value_list_values_x_value_list_values" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_skos_relationship" befinden.';
      WHEN 21 THEN
        _message := 'Constraint 21 - Wenn in der Relation "value_list_values_x_value_list_values" ein Tupel in der Spalte "relationship" eine hierarchische Beziehung ("skos:broader", "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive") besitzt, darf dieselbe Attributtypenkombination nicht invertiert mit derselben Beziehungsart auftreten.';
      WHEN 22 THEN
        _message := 'Constraint 22 - Wenn in der Relation "value_list_values_x_value_list_values" ein Tupel in der Spalte "relationship" eine hierarchische Beziehung ("skos:broader", "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive") besitzt, darf es keine Schleife über n Einträge geben.';
      WHEN 23 THEN
        _message := 'Constraint 23 - Die Spalten "value_list_values_1" und "value_list_values_2" der Relation "value_list_values_x_value_list_values" dürfen in einem Tupel nicht denselben Wert besitzen.';
      WHEN 24 THEN
        _message := 'Constraint 24 - Die Spalte "relationship" der Relation "attribute_type_x_attribute_type" darf ausschließlich Werte aus "value_list_values" zugeordnet bekommen, welche sich in der Werteliste "vl_skos_relationship" befinden.';
      WHEN 25 THEN
        _message := 'Constraint 25 - Wenn in der Relation "attribute_type_x_attribute_type" ein Tupel in der Spalte "relationship" eine hierarchische Beziehung ("skos:broader", "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive") besitzt, darf dieselbe Attributtypenkombination nicht invertiert mit dersekben Beziehungsart auftreten.';
      WHEN 26 THEN
        _message := 'Constraint 26 - Wenn in der Relation "attribute_type_x_attribute_type" ein Tupel in der Spalte "relationship" eine hierarchische Beziehung ("skos:broader", "skos:narrower", "skos:broaderTransitive", "skos:narrowerTransitive") besitzt, darf es keine Schleife über n Einträge geben.';
      WHEN 27 THEN
        _message := 'Constraint 27 - Die Spalten "attribute_type_1" und "attribute_type_2" der Relation "attribute_type_x_attribute_type" dürfen in einem Tupel nicht denselben Wert besitzen.';
      WHEN 28 THEN
        _message := 'Constraint 28 - Die Spalten "topic_instance_1" und "topic_instance_2" der Relation "topic_instance_x_topic_instance" dürfen in einem Tupel nicht denselben Wert besitzen.';
      WHEN 29 THEN
        _message := 'Constraint 29 - In der Relation "topic_instance" existieren zwei Tupel ti1 und ti2 der "topic_characteristic" tc1 und tc2. In der Relation "topic_instance_x_topic_instance" kann ein Tupel ti1, ti2, rt nur dann eingetragen werden, wenn in der Relation "relationship_type_to_topic_characteristic" das Tupel tc1, rt und in der Relation "relationship_type" das Tupel rt, Thema von tc2 existiert.';
      WHEN 30 THEN
        _message := 'Constraint 30 - Ein Tupel mit einer "topic_instance", welche der "topic_characteristic" tc und der "attribute_type_to_attribute_type_group" ata zugeordnet ist, kann in der Relation "attribute_value", bzw. in den erbenden Relationen, nur dann eingetragen werden, wenn in der Relation "attribute_type_group_to_topic_characteristic" ein Tupel tc, atg existiert, wobei atg Bestandteil von ata sein muss.';
      WHEN 31 THEN
        _message := 'Constraint 31 - Einträge in die Spalte "value" der Relation "attribute_value_value" dürfen keine tausender Trennzeichen besitzen, insofern der Datentyp des zugehörigen Attributtyps ein Zahlentyp (z. Bsp. Integer oder Numeric) ist.';
      WHEN 32 THEN
        _message := 'Constraint 32 - Der Datentyp von "attribute_value_value" muss dem entsprechen, der im Attribut "data_type" des zugehörigen Attributtyps spezifiziert ist.';
      WHEN 33 THEN
        _message := 'Constraint 33 - Die Relation "attribute_value_geom" kann genau dann einen Eintrag bekommen, wenn der Datentyp des zugehörigen Attributtyps "geometry" ist.';
      WHEN 34 THEN
        _message := 'Constraint 34 - Die Relation "attribute_value_geomz" kann genau dann einen Eintrag bekommen, wenn der Datentyp des zugehörigen Attributtyps "geometryz" ist.';
      WHEN 35 THEN
        _message := 'Constraint 35 - Die Spalte "domain" (FK auf "value_list_values") in der Relation "attribute_value_domain" darf nur dann einen Eintrag haben, wenn das Attribut "domain" der zugehörigen Relation "attribute_type" ebenfalls einen Eintrag hat. Wenn beide Attribute nicht NULL sind, dann muss der "value_list_value“ von "default_value" aus der "domain" zugeordneten "value_list" stammen und der Datentyp des Attributtyps mit dem Datentyp von "value_list_value" übereinstimmen.';
      WHEN 36 THEN
        _message := 'Constraint 36 - Es muss genau ein Tupel der Relation "project" keine Beziehung zu einem anderen Tupel der Relation "project" besitzen.';
      WHEN 37 THEN
        _message := 'Constraint 37 - Ein Tupel der Relation "project" muss, unter Beachtung der vorangegangen Integritätsbedingung eine Beziehung zu genau einem anderen Relationstupel besitzen.';
      WHEN 38 THEN
        _message := 'Constraint 38 - Ein Tupel der Relation "project" darf keine Beziehung zu sich selbst besitzen.';
      WHEN 39 THEN
        _message := 'Constraint 39 - Wenn zwei Themeninstanzen über "topic_instance_x_topic_instance" in Beziehung gesetzt werden, muss das Thema der "topic_instance_2" mit dem Thema in "related_to" des Beziehungstyps übereinstimmen.';
      WHEN 40 THEN
        _message := 'Constraint 40 - Wenn der Attributtyp einen Wertebereich besitzt, darf er nicht in "attribute_value_value" assoziert werden.';
      WHEN 41 THEN
        _message := 'Constraint 41 - Wenn der Attributtyp einen Wertebereich besitzt, darf er nicht in "attribute_value_geom" assoziert werden.';
      WHEN 42 THEN
        _message := 'Constraint 42 - Der Attributtyp muss einen Wertebereich besitzen, damit er in "attribute_value_domain" assoziert werden kann.';
      WHEN 43 THEN
        _message := 'Constraint 43 - Ein Tupel in der Relation "topic_instance_x_topic_instance" darf nur sooft auftreten, wie es in "relationship_type_to_topic_characteristic" durch "multiplicity" definiert ist. Dabei gelten folgende Kardinaltitäten: 0 – optional, Zahl – Wert der Zahl, NULL – beliebig.';
      WHEN 44 THEN
        _message := 'Constraint 44 - Die Zeichenkodierung in "character_code" muss mit der Zeichenkodierung der Datenbank übereinstimmen.';
      WHEN 45 THEN
        _message := 'Constraint 45 - Die maximale "multiplicity" von "attribute_type_to_attribute_type_group" multipliziert mit der "multiplicity" von "attribute_type_group_to_topic_characteristic", insofern nicht NULL, muss sich in der maximalen Anzahl der Spalten von "attribute_type_to_attribute_type_group" widerspiegeln. Dabei müssen die Werte für "attribute_type_id" und "attribute_type_group_id" in "attribute_type_to_attribute_type_group" immer dieselben sein.';
      WHEN 46 THEN
        _message := 'Constraint 46 - Die Standardwertelisten "vl_relationship_type", "vl_data_type", "vl_unit", "vl_skos_relationship" oder "vl_topic" dürfen nicht aus "value_list" gelöscht oder geändert (Name) werden.';
      WHEN 47 THEN
        _message := 'Constraint 47 - Wenn der Attributtyp einen Wertebereich besitzt, darf er nicht in "attribute_value_geomz" assoziert werden.';
      WHEN 48 THEN
        _message := 'Constraint 48 - Die Spalte "unit" in "attribute_type" darf nicht verändert werden, wenn ein Eintrag in "attribute_value" diesen Attributtyp verwendet.';
      WHEN 49 THEN
        _message := 'Constraint 49 - Die Spalte "domain" in "attribute_type" darf nicht verändert werden, wenn ein Eintrag in "attribute_type_to_attribute_type_group" diesen Attributtyp verwendet.';
      WHEN 50 THEN
        _message := 'Constraint 50 - Ein Tupel der Relation "attribute_type_group" darf keine Beziehung zu sich selbst besitzen.';
      WHEN 51 THEN
        _message := 'Constraint 51 - Wenn in der Relation "attribute_type_group" ein Tupel in der Spalte "subgroup_of" einen Eintrag besitzt, darf es keine Schleife über n Einträge geben.';
      WHEN 52 THEN
        _message := 'Constraint 52 - Die Spalten "language_code_id", "country_code_id" und "character_code_id" der Tabelle "pt_locale" müssen gemeinsam UNIQUE sein. Dabei muss der Wert NULL, der in "country_code_id" auftauchen kann, als eigenständiger Wert betrachtet.';
      WHEN 53 THEN
        _message := 'Constraint 53 - Die maximale "multiplicity" von "attribute_type_group_to_topic_characteristic" multipliziert mit der Summe der maximalen "multiplicity" von "attribute_type_to_attribute_type_group", insofern nicht NULL, muss sich in der maximalen Anzahl der Spalten von "attribute_type_group_to_topic_characteristic" widerspiegeln. Dabei müssen die Werte für "attribute_type_group_id" und "topic_characteristic_id" in "attribute_type_group_to_topic_characteristic" immer dieselben sein.';
      WHEN 55 THEN
        _message := 'Constraint 55 - Wenn in der Relation "project" ein Tupel in der Spalte "subproject_of" einen Eintrag besitzt, darf es keine Schleife über n Einträge geben.';
      WHEN 56 THEN
        _message := 'Constraint 56 - Wenn in der Tabelle "attribute_type_to_attribute_type_group" die Zuordnung einer "attribute_type_id“ zu einer anderen "attribute_type_group_id" geändert wird, muss sichergestellt werden, falls es einen "attribute_value" zu dem "attribute_type" gibt, dass die Zuordnung der neuen "attribute_type_group" zur selben "topic_characteristic" über "attribute_type_group_to_topic_characteristic" gehört, wie die alte "attribute_type_group". ';
      WHEN 57 THEN
        _message := 'Constraint 57 - Wenn ein Wert in "value_list_values" einer der Wertelisten "vl_relationship_type", "vl_data_type", "vl_unit", "vl_skos_relationship" oder "vl_topic" in "value_list" zugeordnet wird, darf dieser Wert nicht bereits in den Tabellen "attribute_type", "attribute_type_group_to_topic_characteristic", "value_list_x_value_list", "value_list_values_x_value_list_values", "relationship_type", "attribute_type_x_attribute_type" oder "topic_characteristic" referenziert werden.';
      WHEN 58 THEN
        _message := 'Constraint 58 - Es ist nicht möglich, die "pt_free_text_id" eines Eintrag in "localized_character_string" zu ändern.';
      WHEN 59 THEN
        _message := 'Constraint 59 - Der "free_text" von "localized_character_string" darf in der Spalte "name" der Tabelle "attribute_type" nicht bereits mit einer anderen "pt_free_text_id" verwendet werden.';
      WHEN 60 THEN
        _message := 'Constraint 60 - Der "free_text" von "localized_character_string" darf in der Spalte "name" der Tabelle "project" nicht bereits mit einer anderen "pt_free_text_id" verwendet werden.';
      WHEN 61 THEN
        _message := 'Constraint 61 - Der "free_text" von "localized_character_string" darf in der Spalte "description" der Tabelle "topic_characteristic" nicht bereits mit einer anderen "pt_free_text_id" verwendet werden.';
      WHEN 62 THEN
        _message := 'Constraint 62 - Der "free_text" von "localized_character_string" darf in der Spalte "name" der Tabelle "value_list" nicht bereits mit einer anderen "pt_free_text_id" verwendet werden.';
      WHEN 63 THEN
        _message := 'Constraint 63 - Die Werte der Werteliste "vl_data_type" dürfen nicht verändert oder gelöscht werden. Ebenso dürfen keine neuen Werte eingetragen werden.';

      ELSE
        _message := 'Constraint % is not implemented.', _constraint;
    END CASE;

    -- Throw the exception with the constraint message
    RAISE EXCEPTION '%', _message;

  END;
  $$ LANGUAGE 'plpgsql';

/*
 * This function extracts the project schema name from the search path where it
 * is called. This will only work, if the project schema name starts with the
 * string "project" and does not contain a coma! If no project schema was found,
 * the returned string will be "system".
 *
 * @state   experimental
 * @output  varchar: project schema name, if null then system schema name
 */
CREATE OR REPLACE FUNCTION get_current_project_schema()
  RETURNS varchar AS $$
  DECLARE
    _schema varchar;
  BEGIN
    -- get the current search path
    EXECUTE 'SHOW search_path' INTO _schema;

    -- extract the project schema, containing the word "project" and any
    -- character until appearing of a coma
    _schema := regexp_matches(_schema, 'project.*?(?=,)');
    -- cut off interfering characters
    _schema := trim(both '{}' from _schema);
    _schema := trim(both '"' from _schema);
    _schema := trim(both '\\' from _schema);

    -- check if a project schema was found, if not return 'system'
    IF (_schema IS NULL) THEN
      _schema := 'system';
    END IF;

    RETURN _schema;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * Determines the pt_locale_id by language, country and character code. If the
 * country code is NULL, then the language code must be 'xx'.
 *
 * @state   stable
 * @input   varchar: schema name
 *          varchar: language_code - DEFAULT en
 *          varchar: country_code - DEFAULT GB
 *          varchar: character_code - DEFAULT UTF8
 * @output  uuid: pt_locale_id
 */
CREATE OR REPLACE FUNCTION get_pt_locale_id(varchar, varchar DEFAULT 'en',
                                            varchar DEFAULT 'GB',
                                            varchar DEFAULT 'UTF8')
  RETURNS uuid AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _lang ALIAS FOR $2;
    _country ALIAS FOR $3;
    _char_code ALIAS FOR $4;
    _pt_locale uuid;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- language code 'xx' must be treated separated
    IF _country IS NULL AND _lang = 'xx' THEN
      SELECT "pt"."id" INTO _pt_locale
        FROM "pt_locale" "pt", "language_code" "s",
             "character_code" "z"
       WHERE "pt"."language_code_id" = "s"."id"
         AND "pt"."character_code_id" = "z"."id"
         AND "s"."language_code" = _lang
         AND "z"."character_code" = _char_code;
    ELSE
      SELECT "pt"."id" INTO _pt_locale
        FROM "pt_locale" "pt", "language_code" "s", "country_code" "l",
             "character_code" "z"
       WHERE "pt"."language_code_id" = "s"."id"
         AND "pt"."country_code_id" = "l"."id"
         AND "pt"."character_code_id" = "z"."id"
         AND "s"."language_code" = _lang
         AND "l"."country_code" = _country
         AND "z"."character_code" = _char_code;
    END IF;
    RETURN _pt_locale;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines the free text for a pt_free_text_id and a pt_locale_id. If a
 * pt_free_text_id has n locales and no pt_locale_id is passed, then only
 * the first entry will be returned.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: pt_free_text_id of the free text
 *          uuid: pt_locale_id for the return - DEFAULT NULL
 * @output  text: free text
 */
CREATE OR REPLACE FUNCTION get_localized_character_string(varchar, uuid,
                                                          uuid DEFAULT NULL)
  RETURNS text AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _pt_free_text_id ALIAS FOR $2;
    _pt_locale_id ALIAS FOR $3;
    _sql text;
    _ret text;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    IF _pt_free_text_id IS NULL THEN
      RETURN NULL;
    END IF;

    _sql := 'SELECT "free_text" FROM "localized_character_string"
              WHERE "pt_free_text_id" = '|| quote_literal(_pt_free_text_id);
    IF _pt_locale_id IS NOT NULL THEN
      _sql := _sql ||' AND "pt_locale_id" = '|| quote_literal(_pt_locale_id);
    END IF;

    EXECUTE _sql INTO _ret;

    RETURN _ret;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines the id of a value list value for a specific value list. The
 * language of the value list doesn't matter. The influence of the language of
 * the value is ambiguous.
 *
 * @state   experimental
 * @input   varchar: name of the value list value
 *          varchar: name of the value list
 * @output  uuid: id of the value list value
 */
CREATE OR REPLACE FUNCTION get_value_id_from_value_list(varchar, varchar,
                                                        varchar)
  RETURNS uuid AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_list_value ALIAS FOR $2;
    _value_list ALIAS FOR $3;
    _return varchar;
  BEGIN
    -- TODO: Funktion prüfen, wurde von sql auf plpgsql geändert
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    SELECT
      "vlv"."id"
    INTO
      _return
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs1", -- value list
      "localized_character_string" "lcs2"  -- value list value
    WHERE
      "vl"."name" = "lcs1"."pt_free_text_id" AND
      "vlv"."name" = "lcs2"."pt_free_text_id" AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs1"."free_text" = _value_list AND
      "lcs2"."free_text" = _value_list_value;

    RETURN _return;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Returns the second passed uuid instead of the first passed uuid if
 * the first one is NULL.
 *
 * @state   stable
 * @input   uuid: uuid that should be checked for NULL
 *          uuid: uuid that will be returned if the first uuid is NULL
 * @output  uuid: first uuid if its not NULL, else second uuid
 */
CREATE OR REPLACE FUNCTION check_for_null(uuid, uuid)
  RETURNS uuid AS $$
  BEGIN
    IF $1 IS NULL THEN
      RETURN $2;
    ELSE
      RETURN $1;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Returns the second passed value instead of the first passed value if
 * the first one is NULL. If there is no second passed value or it is NULL,
 * then the string 'NULL' will be returned.
 *
 * @state   stable
 * @input   varchar: value that should be checked for NULL
 *          varchar: value that will be returned if the first value is NULL
 *                   - DEFAULT NULL
 * @output  varchar: first value if its not NULL, else second value or 'NULL'
 *                   as string
 */
CREATE OR REPLACE FUNCTION check_for_null(varchar, varchar DEFAULT 'NULL')
  RETURNS varchar AS $$
  BEGIN
    IF quote_nullable($1) = 'NULL' AND quote_nullable($2) = 'NULL' THEN
      RETURN 'NULL';
    ELSE
      IF quote_nullable($1) = 'NULL' THEN
        RETURN $2;
      ELSE
        RETURN $1;
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid entry in
 * the passed value list.
 *
 * @state   stable
 * @input   varchar: schema name
 *          varchar: name of the value list
 *          uuid: id of the value that should be found in the value list
 * @output  boolean: true if the value was found in the value list
 */
CREATE OR REPLACE FUNCTION is_valid_global(varchar, varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_list ALIAS FOR $2;
    _value_id ALIAS FOR $3;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    IF (
    SELECT
      "vlv"."id"
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs"
    WHERE
      "vl"."name" = "lcs"."pt_free_text_id" AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs"."free_text" = _value_list AND
      "vlv"."id" = _value_id
      )
    IS NULL THEN
      RETURN false;
    ELSE
      RETURN true;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid unit from the
 * value list "vl_unit".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value that should be an unit
 * @output  boolean: true if the value is a value from the value list "vl_unit"
 */
CREATE OR REPLACE FUNCTION is_valid_unit(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    RETURN is_valid_global(_schema, 'vl_unit', _value_id);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid data type
 * from the value list "vl_data_type".
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value that should be a data type
 * @output  boolean: true if the value is a value from the value list
 *                   "vl_data_type"
 */
CREATE OR REPLACE FUNCTION is_valid_data_type(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    RETURN is_valid_global(_schema, 'vl_data_type', _value_id);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid numeric data
 * type.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: id of the value that should be a numeric data type
 * @output  boolean: true if the value is a value from the value list
 *                   "vl_data_type" and is an integer or numeric value
 */
CREATE OR REPLACE FUNCTION is_valid_numeric_data_type(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    IF (
    SELECT
      "vlv"."id"
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs1",
      "localized_character_string" "lcs2"
    WHERE
      "vl"."name" = "lcs1"."pt_free_text_id" AND
      "vlv"."name" = "lcs2"."pt_free_text_id" AND
      "lcs1"."pt_locale_id" = get_pt_locale_id(_schema) AND
      "lcs2"."pt_locale_id" = get_pt_locale_id(_schema, 'xx', NULL, 'UTF8') AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs1"."free_text" = 'vl_data_type' AND
      ("lcs2"."free_text" = 'integer' OR
      "lcs2"."free_text" = 'numeric') AND
      "vlv"."id" = _value_id
      )
    IS NULL THEN
      RETURN false;
    ELSE
      RETURN true;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid attribute
 * type group.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value that should be a attribute type group
 * @output  boolean: true if the value is a value from the value list
 *                   "vl_attribute_type_group"
 */
CREATE OR REPLACE FUNCTION is_valid_attribute_type_group(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    RETURN is_valid_global(_schema, 'vl_attribute_type_group', _value_id);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid topic.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value that should be a topic
 * @output  boolean: true if the value is a value from the value list
 *                   "vl_topic"
 */
CREATE OR REPLACE FUNCTION is_valid_topic(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    RETURN is_valid_global(_schema, 'vl_topic', _value_id);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid relationship
 * type.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value that should be a relationship type
 * @output  boolean: true if the value is a value from the value list
 *                   "vl_relationship_type"
 */
CREATE OR REPLACE FUNCTION is_valid_relationship_type(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    RETURN is_valid_global(_schema, 'vl_relationship_type', _value_id);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines whether the value behind the passed uuid is a valid SKOS
 * relationship type.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value that should be a skos relationship type
 * @output  boolean: true if the value is a value from the value list
 *                   "vl_skos_relationship"
 */
CREATE OR REPLACE FUNCTION is_valid_skos_relation(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_id ALIAS FOR $2;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    RETURN is_valid_global(_schema, 'vl_skos_relationship', _value_id);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * This function checks recursively if inserting value 1 in list 1 and value 2
 * in list 2 will create a loop over the two lists. The lists will be compared
 * as shown in the figure, following the schema 1 & 2, 2 & 7, 7 & 4.
 *
 *      l1      l2
 *    #####    #####
 *    # 1 #    # 2 #
 *    # 2 #    # 7 #
 *    # 7 #    # 4 #
 *    #####    #####
 *
 * @state   experimental
 * @input   uuid: first value that should be inserted
 *          uuid: second value that should be inserted
 *          uuid[]: first list for the first value
 *          uuid[]: second list for the second value
 * @output  boolean: true if no loop was created, when the values where
 *                   inserted into the lists
 */
CREATE OR REPLACE FUNCTION check_loop_recursive(uuid, uuid, uuid[], uuid[])
  RETURNS boolean AS $$
  DECLARE
    _l_start ALIAS FOR $1; -- start value for a potential loop
    _l_end ALIAS FOR $2;   -- end value for a potential loop
    _list1 ALIAS FOR $3;
    _list2 ALIAS FOR $4;
    _swap1 uuid[];
    _swap2 uuid[];
  BEGIN

    -- check if the lists are empty
    IF ((array_length(_list1, 1) IS NULL) OR
        (array_length(_list2, 1) IS NULL)) THEN
      RETURN false;
    END IF;

    -- run through the first list (array doesn't start at index 0)
    FOR i IN 1..array_length(_list1, 1) LOOP
      -- look for the end value in the first list for a potential loop
      IF (_l_end = _list1[i]) THEN
        -- a loop was found if the start value of a potential loop correlates
        -- the value in the second list
        IF (_list2[i] = _l_start) THEN
          RETURN true;
        END IF;

        -- save the new end value of a potential loop
        _l_end := _list2[i];

        -- remove the controlled values from both lists
        FOR x IN 1..array_length(_list1, 1) LOOP
          -- if the passed values are not the same as the values in the lists
          IF ((_list1[i] != _list1[x]) OR (_list2[i] != _list2[x])) THEN
            -- add them to temporary lists
            _swap1 := array_append(_swap1, _list1[x]);
            _swap2 := array_append(_swap2, _list2[x]);
          END IF;
        END LOOP;

        -- write the temporary lists into the original lists
        _list1 := _swap1;
        _list2 := _swap2;

        -- recursive call and abort condition
        IF (check_loop_recursive(_l_start, _l_end, _list1, _list2) = true) THEN
          RETURN true;
        ELSE
          RETURN false;
        END IF;
      END IF;
    END LOOP;
    -- there were no entries found -> no loop
    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Checks whether inserting or updating of 2 uuids creates a loop in the passed
 * table. This is necessary if the passed skos relationship is "skos:broader",
 * "skos:narrower", skos:"broaderTransitive" or "skos:narrowerTransitive".
 *
 * @state   experimental
 * @input   varchar: _schema
 *          uuid: first value that should be inserted
 *          uuid: second value that should be inserted
 *          uuid: SKOSRelationship
 *          varchar: name of the table (for "attribute_type_x_attribute_type"
 *                   -> only "attribute_type" must be passed)
 *          uuid: first value that should be updated - DEFAULT NULL
 *          uuid: second value that should be updated - DEFAULT NULL
 * @output  boolean: true if inserting or updating of the values will create a
 *                   loop in the passed table
 */
CREATE OR REPLACE FUNCTION check_loop_x(varchar, uuid, uuid, uuid, varchar,
                                      uuid DEFAULT NULL, uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _l_start ALIAS FOR $2;
    _l_end ALIAS FOR $3;
    _relation ALIAS FOR $4;
    _x_column ALIAS FOR $5;
    _u_start ALIAS FOR $6;
    _u_end ALIAS FOR $7;
    _x_table varchar;
    _relation_id uuid;
    _list1 uuid[];
    _list2 uuid[];
    _swap1 uuid[];
    _swap2 uuid[];
    _string varchar;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- create _x_ table
    _x_table := _x_column || '_x_' || _x_column;

    -- check if the passed relationship is one of "skos:broader",
    -- "skos:narrower", "skos:broaderTransitive" or "skos:narrowerTransitive"
    SELECT get_value_id_from_value_list(_schema, 'skos:broader',
                                        'vl_skos_relationship')
      INTO _relation_id;
    IF (_relation_id != _relation) THEN
      SELECT get_value_id_from_value_list(_schema, 'skos:narrower',
                                          'vl_skos_relationship')
        INTO _relation_id;
      IF (_relation_id != _relation) THEN
        SELECT get_value_id_from_value_list(_schema, 'skos:broaderTransitive',
                                            'vl_skos_relationship')
          INTO _relation_id;
        IF (_relation_id != _relation) THEN
          SELECT get_value_id_from_value_list(_schema, 'skos:narrowerTransitive',
                                              'vl_skos_relationship')
            INTO _relation_id;
          IF (_relation_id != _relation) THEN
            RETURN false;
          END IF;
        END IF;
      END IF;
    END IF;

    -- check if _relation_id is NULL to avoid NULL exceptions in the EXECUTE
    -- statement
    IF (_relation_id IS NULL) THEN
      _string := 'No SKOS relationships found in vl_skos_relationship. Are '||
                 'the static values installed?';
      RAISE EXCEPTION '%', _string;

    END IF;

    -- save entries that should be compared in a list sorted by the same value
    EXECUTE 'SELECT array(SELECT ' || quote_ident(_x_column || '_1') || '
             FROM ' || quote_ident(_x_table) || '
             WHERE "relationship" = ' || quote_literal(_relation_id) || '
             ORDER BY ' || quote_ident(_x_column || '_1') || ');' INTO _list1;
    EXECUTE 'SELECT array(SELECT ' || quote_ident(_x_column || '_2') || '
             FROM ' || quote_ident(_x_table) || '
             WHERE "relationship" = ' || quote_literal(_relation_id) || '
             ORDER BY ' || quote_ident(_x_column || '_1') || ');' INTO _list2;

    -- check for UPDATE
    IF ((_u_start IS NOT NULL) AND (_u_end IS NOT NULL)) THEN
      -- remove entries from the lists, that should be updated
      FOR x IN 1..array_length(_list1, 1) LOOP
        -- if the passed values are not the same as the values in the lists ...
        IF ((_u_start != _list1[x]) OR (_u_end != _list2[x])) THEN
          -- ... add them to temporary lists
          _swap1 := array_append(_swap1, _list1[x]);
          _swap2 := array_append(_swap2, _list2[x]);
        END IF;
      END LOOP;

      -- write the temporary lists into the original lists
      _list1 := _swap1;
      _list2 := _swap2;
    END IF;

    -- call the recursive function and check for loops
    IF (check_loop_recursive(_l_start, _l_end, _list1, _list2) = false)
      THEN
      -- no loops found
      RETURN false;
    ELSE
      -- loops found
      RETURN true;
    END IF;

  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Checks whether inserting an uuid into the passed column in the passed table
 * will create a loop. This is necessary if the table has a self reference.
 *
 * @state   experimental
 * @input   varchar: _schema
 *          uuid: first value that should be inserted
 *          uuid: second value that should be inserted
 *          varchar: name of the table
 *          varchar: name of the column
 *          uuid: first value that should be updated - DEFAULT NULL
 *          uuid: second value that should be updated - DEFAULT NULL
 * @output  boolean: true if inserting or updating of the values will create a
 *                   loop in the passed table
 */
CREATE OR REPLACE FUNCTION check_loop_sub(varchar, uuid, uuid, varchar, varchar,
                                      uuid DEFAULT NULL, uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _l_start ALIAS FOR $2;
    _l_end ALIAS FOR $3;
    _table ALIAS FOR $4;
    _column ALIAS FOR $5;
    _u_start ALIAS FOR $6;
    _u_end ALIAS FOR $7;
    _list1 uuid[];
    _list2 uuid[];
    _swap1 uuid[];
    _swap2 uuid[];
    _string varchar;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- save entries that should be compared in a list sorted by the same value
    EXECUTE 'SELECT array(SELECT id' || '
             FROM ' || quote_ident(_table) || '
             ORDER BY id);' INTO _list1;
    EXECUTE 'SELECT array(SELECT ' || quote_ident(_column) || '
             FROM ' || quote_ident(_table) || '
             ORDER BY id);' INTO _list2;

    -- check for UPDATE
    IF ((_u_start IS NOT NULL) AND (_u_end IS NOT NULL)) THEN
      -- remove entries from the lists, that should be updated
      FOR x IN 1..array_length(_list1, 1) LOOP
        -- if the passed values are not the same as the values in the lists ...
        IF ((_u_start != _list1[x]) OR (_u_end != _list2[x])) THEN
          -- ... add them to temporary lists
          _swap1 := array_append(_swap1, _list1[x]);
          _swap2 := array_append(_swap2, _list2[x]);
        END IF;
      END LOOP;

      -- write the temporary lists into the original lists
      _list1 := _swap1;
      _list2 := _swap2;
    END IF;

    -- call the recursive function and check for loops
    IF (check_loop_recursive(_l_start, _l_end, _list1, _list2) = false)
      THEN
      -- no loops found
      RETURN false;
    ELSE
      -- loops found
      RETURN true;
    END IF;

  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Checks if the passed list contains more than 1 entry.
 *
 * @state   stable
 * @input   uuid[]: list that should be checked
 * @output  boolean: true if there is more than one entry in the list
 */
CREATE OR REPLACE FUNCTION check_for_multiple(uuid[])
  RETURNS boolean AS $$
  DECLARE
    _array ALIAS FOR $1;
    _counter int;
  BEGIN
    _counter := 0;
    FOR x IN 1..array_length(_array, 1) LOOP
      IF (_array[x] IS NOT NULL) THEN
        _counter := _counter + 1;
      END IF;
    END LOOP;

    IF (_counter <= 1) THEN
      RETURN false;
    ELSE
      RETURN true;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines the data type of a text element and compares it with the data
 * type of a attribute type. The comparison is based on the PostgreSQL CAST
 * function. PostgreSQL doesn't support an url data type so at this point the
 * comparison is realized with a regular expression.
 *
 * @state   stable
 * @input   varchar: schema name
 *          text: text value whose data type should be compared
 *          uuid: attribute type id whose data type should be compared
 * @output  boolean: true if both data types match
 */
CREATE OR REPLACE FUNCTION compare_data_types(varchar, text, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value ALIAS FOR $2;
    _at_id ALIAS FOR $3;
    _data_type varchar;
    _url_pattern varchar;
    _is_url boolean;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- regular expression for checking an url (considers top-level domains
    -- with 2 till 10 positions)
    _url_pattern :='^((http|https)\://)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,10}(/\S*)?$';

    -- determines the data type of the attribute type
    SELECT return_attribute_data_type(_schema, _at_id) INTO _data_type;

    -- checks if the value is an url (RegExp)
    SELECT _value ~ _url_pattern INTO _is_url;

    -- if the value and the data type is an url return true
    IF ((_is_url = true) AND (_data_type = 'url')) THEN
	  RETURN true;
    END IF;

    -- if the value is not but the data type is an url return false
    IF ((_is_url = false) AND (_data_type = 'url')) THEN
	  RETURN false;
    END IF;

    -- use the PostgreSQL CAST function to prove the compatibility of the value
    -- and the data type
    EXECUTE 'SELECT CAST(' || quote_literal(_value) || ' AS ' || _data_type || ');';

    RETURN true;

    -- the CAST function can throw some exceptions that will be caught
    EXCEPTION
      WHEN invalid_datetime_format THEN
        return false;
      WHEN invalid_text_representation THEN
        return false;
      WHEN syntax_error THEN
        return false;
      WHEN invalid_parameter_value THEN
        return false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines the data type of an attribute type by means of an attribute type
 * id or a data type id.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: id of the attribute type
 *          uuid: id of the data type - DEFAULT NULL
 * @output  varchar: string of a data type
 */
CREATE OR REPLACE FUNCTION return_attribute_data_type(varchar, uuid,
                                                      uuid DEFAULT NULL)
  RETURNS varchar AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _at_id ALIAS FOR $2;
    _dt_id ALIAS FOR $3;
    _value varchar;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- if no data type id was passed
    IF ((_at_id IS NULL) AND (_dt_id IS NOT NULL)) THEN
      SELECT get_localized_character_string(_schema, "vlv"."name",
               get_pt_locale_id(_schema, 'xx', NULL, 'UTF8')) INTO _value
      FROM
        "value_list_values" "vlv"
      WHERE
        "vlv"."id" = _dt_id;
    -- if a data type id was passed
    ELSE
      SELECT get_localized_character_string(_schema, "vlv"."name",
               get_pt_locale_id(_schema, 'xx', NULL, 'UTF8')) INTO _value
      FROM
        "attribute_type" "at",
        "value_list_values" "vlv"
      WHERE
        "at"."data_type" = "vlv"."id" AND
        "at"."id" = _at_id;
    END IF;

    -- if no data type was found NULL will be returned as string
    RETURN check_for_null(_value);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines the value list value for a uuid from a specific value list.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id of the value list value
 *          varchar: name of the value list
 *          uuid: pt_locale_id for the name of the value list
 *          uuid: pt_locale_id for the returned value list value - DEFAULT NULL
 * @output  varchar: value list value
 */
CREATE OR REPLACE FUNCTION get_value_from_value_list(varchar, uuid, varchar,
                                                     uuid, uuid DEFAULT NULL)
  RETURNS varchar AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _value_list_value_id ALIAS FOR $2;
    _value_list_name ALIAS FOR $3;
    _pt_locale_id_value_list_name ALIAS FOR $4;
    _pt_locale_id_return ALIAS FOR $5;
    _return varchar;
  BEGIN
    -- TODO: Funktion prüfen, da sie von sql auf plpgsql geändert wurde
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    SELECT
      "lcs2"."free_text"
    INTO
      _return
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs1", -- value list
      "localized_character_string" "lcs2"  -- value list value
    WHERE
      "vl"."name" = "lcs1"."pt_free_text_id" AND
      "lcs1"."pt_locale_id" = _pt_locale_id_value_list_name AND
      "vlv"."name" = "lcs2"."pt_free_text_id" AND
      "lcs2"."pt_locale_id" = check_for_null(_pt_locale_id_return,
                                             _pt_locale_id_value_list_name) AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs1"."free_text" = _value_list_name AND
      "vlv"."id" = _value_list_value_id;

    RETURN _return;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Determines on the base of the name of a foreign key the column name the key
 * belongs to. This will only work if the key has the following syntax:
 * [table_name]_[column_name]_fkey
 *
 * @state   experimental
 * @input   text: name of the foreign key
 *          text: name of the table the foreign key belongs to
 * @output  text: name of the column the foreign key belongs to
 */
CREATE OR REPLACE FUNCTION get_column_from_fk(text, text)
  RETURNS text AS $$
  DECLARE
    _ref_key ALIAS FOR $1;
    _table ALIAS FOR $2;
    _column text;
    _tmp text;
  BEGIN
    -- remove '_fkey'
    _tmp = trim(trailing 'fkey' FROM _ref_key);
    _tmp = trim(trailing '_' FROM _tmp);

    -- determine the column on the base of the total length - length of the
    -- table - 1 (for the underline between table and column)
    _column = right(_tmp, length(_tmp) - length(_table) - 1);

    RETURN _column;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * Determines whether a passed uuid references on the table pt_free_text from
 * any table except localized_character_string. Will return the number of
 * occurrences.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: id that should be found
 * @output  integer: number of matches for the passed uuid
 */
CREATE OR REPLACE FUNCTION free_text_in_use(varchar, uuid)
  RETURNS integer AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _uuid ALIAS FOR $2;
    _result RECORD;
    _entry integer;
    _counter integer := 0;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- abort if the passed uuid is NULL
    IF (_uuid IS NULL) THEN
      RETURN NULL;
    END IF;

    -- find all tables that reference to pt_free_text (except
    -- localized_character_string)
    FOR _result IN
      SELECT
        "cl2"."relname" AS "table",
        get_column_from_fk("co"."conname", "cl2"."relname") AS "column"
      FROM
        "pg_class" "cl1",
        "pg_class" "cl2",
        "pg_constraint" "co",
        "pg_namespace" "ns"
      WHERE
        "cl1"."relnamespace" = "ns"."oid" AND
        "cl1"."oid" = "co"."confrelid" AND
        "cl2"."oid" = "co"."conrelid" AND
        "cl1"."relname" = 'pt_free_text' AND
        "ns"."nspname" = trim(both '"' from _schema) AND
        "cl2"."relname" != 'localized_character_string'
      LOOP
        -- browse all columns for the passed uuid and count there occurrence
        EXECUTE 'SELECT count(' || quote_ident(_result.column) || ')
                 FROM ' || quote_ident(_result.table) || '
                 WHERE ' || quote_ident(_result.column) || '
                 = ' || quote_literal(_uuid) INTO _entry;

        -- raise the counter by the number of entries found above
        IF (_entry > 0) THEN
          _counter = _counter + _entry;
        END IF;

      END LOOP;

    RETURN _counter;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This function checks for the given parameters of the relation
 * attribute_type_to_attribute_type_group if another entry in this table
 * violates the multiplicity. The multiplicity will be calculated by the
 * product of the max multiplicity of the entries in
 * attribute_type_to_attribute_type_group and the max multiplicity of
 * attribute_type_group_to_topic_characteristic.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new attribute_type_id
 *          uuid: new attribute_type_group_id
 *          uuid: new attribute_type_group_to_topic_characteristic_id
 *          uuid: new multiplicity
 * @output  boolean: false if more entries are possible, else if multiplicity limit is reached
 */
CREATE OR REPLACE FUNCTION check_multiplicity_for_ata
                             (varchar, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_id ALIAS FOR $2;
    _new_attribute_type_group_id ALIAS FOR $3;
    _new_attribute_type_group_to_topic_characteristic_id ALIAS FOR $4;
    _new_multiplicity ALIAS FOR $5;
    _ata_multiplicity integer := 0;
    _att_multiplicity integer := 0;
    _used_counter integer := 0;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- retrieve the max multiplicity value
    SELECT "max_value" INTO _ata_multiplicity FROM "multiplicity" WHERE "id" = _new_multiplicity;

    -- if max multiplicity is NULL then abort with false
    IF (_ata_multiplicity IS NULL) THEN
      RETURN false;
    END IF;

    -- retrieve the multiplicity of the entry in att that is used in ata by entries with the passed attribute_type_id and attribute_type_group_id
    SELECT "max_value" INTO _att_multiplicity FROM "multiplicity" WHERE "id" =
    (
      SELECT "multiplicity" FROM "attribute_type_group_to_topic_characteristic" WHERE "id" =
      (
        SELECT "attribute_type_group_to_topic_characteristic_id"
          FROM "attribute_type_to_attribute_type_group"
         WHERE "attribute_type_id" = _new_attribute_type_id AND
               "attribute_type_group_id" = _new_attribute_type_group_id
         LIMIT 1
      )
    );

    -- if max multiplicity is NULL then abort with false
    IF (_att_multiplicity IS NULL) THEN
      RETURN false;
    END IF;

    -- check how often the attribute_type_id / attribute_type_group_id combination is used in ata
    SELECT count("id") INTO _used_counter FROM "attribute_type_to_attribute_type_group" WHERE "attribute_type_id" = _new_attribute_type_id AND "attribute_type_group_id" = _new_attribute_type_group_id;

    -- multiplie the calculated multiplicities from ata with the multiplicity of att to gain the maximum count of possible entries in ata
    --RAISE NOTICE '% of % in use', _used_counter, _ata_multiplicity * _att_multiplicity;

    -- if used counter is 0 than this is the first entry
    IF (_used_counter = 0) THEN
      RETURN false;
    END IF;

    -- check if the limit is not reached and return false
    IF (_used_counter < _ata_multiplicity * _att_multiplicity) THEN
      RETURN false;
    END IF;

    RETURN true;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This function checks for the given parameters of the relation
 * attribute_type_group_to_topic_characteristic if another entry in this table
 * violates the multiplicity. The multiplicity will be calculated by the sum of
 * the max multiplicity of the entries in attribute_type_to_attribute_type_group
 * multiplied with the max multiplicity of
 * attribute_type_group_to_topic_characteristic.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new attribute_type_group_id
 *          uuid: new topic_characteristic_id
 *          uuid: new multiplicity
 * @output  boolean: false if more entries are possible, else if multiplicity limit is reached
 */
CREATE OR REPLACE FUNCTION check_multiplicity_for_att
                             (varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_group_id ALIAS FOR $2;
    _new_topic_characteristic_id ALIAS FOR $3;
    _new_multiplicity ALIAS FOR $4;
    _att_pk_record record;
    _ata_record record;
    _at_ag_array jsonb;
    _att_multiplicity integer := 0;
    _ata_multiplicity integer := 0;
    _at_m integer := 0;
    _used_counter integer := 0;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- retrieve the max multiplicity value
    SELECT "max_value" INTO _att_multiplicity FROM "multiplicity" WHERE "id" = _new_multiplicity;

    -- if max multiplicity is NULL then abort with false
    IF (_att_multiplicity IS NULL) THEN
      RETURN false;
    END IF;

    -- suche in att alle primary keys, welche dieselben Werte in attribute_type_group_id und topic_characteristic_id haben
    FOR _att_pk_record IN SELECT "id" FROM "attribute_type_group_to_topic_characteristic" WHERE "attribute_type_group_id" = _new_attribute_type_group_id AND "topic_characteristic_id" = _new_topic_characteristic_id
    LOOP
      -- suche diese primary keys in attribute_type_to_attribute_type_group in der Spalte attribute_type_group_to_topic_characteristic_id
      SELECT * INTO _ata_record FROM "attribute_type_to_attribute_type_group" WHERE "attribute_type_group_to_topic_characteristic_id" = _att_pk_record."id";

      -- increment the count of used multiplicities
      _used_counter := _used_counter +1;

      -- ermittle von jeder attribute_type_id / attribute_type_group_id Kombination (keine Dopplungen) jeweils den max multiplicity Wert
      IF ((_at_ag_array->_ata_record."attribute_type_id"::varchar) IS NULL) THEN
        -- add type and group to control array
        _at_ag_array := '{'|| quote_ident(_ata_record."attribute_type_id"::varchar) ||' : '|| quote_ident(_ata_record."attribute_type_group_id"::varchar) ||'}';

        -- retrieve the max multiplicity value
        SELECT "max_value" INTO _at_m FROM "multiplicity" WHERE "id" = _ata_record."multiplicity";

        -- if max multiplicity is NULL then abort with false
        IF (_at_m IS NULL) THEN
          RETURN false;
        END IF;

        -- and add id to the previously retireved values
        _ata_multiplicity := _ata_multiplicity + _at_m;
      END IF;

    END LOOP;

    -- multiplie the calculated multiplicities from ata with the multiplicity of att to gain the maximum count of possible entries in att
    --RAISE NOTICE '% of % in use', _used_counter, _ata_multiplicity * _att_multiplicity;

    -- if used counter is 0 than this is the first entry
    IF (_used_counter = 0) THEN
      RETURN false;
    END IF;

    -- check if the limit is not reached and return false
    IF (_used_counter < _ata_multiplicity * _att_multiplicity) THEN
      RETURN false;
    END IF;

    RETURN true;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * Compare the passed ids for equality. If the second id is NULL, than false
 * will be returned.
 *
 * @state   experimental
 * @input   uuid: new id
 *          uuid: old id - DEFAULT NULL
 * @output  boolean: false if both ids are the same, else false
 */
CREATE OR REPLACE FUNCTION compare_ids (uuid, uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _old_id ALIAS FOR $2;
  BEGIN
    -- if the new id or the old id is NULL, than a comparision is not necessary
    -- (new id = NULL -> DELETE; old id = NULL -> INSERT)
    IF (_new_id IS NULL OR _old_id IS NULL) THEN
      RETURN false;
    END IF;

    -- if the new and the old ids are not the same raise an exception
    IF (_new_id != _old_id) THEN
      RAISE EXCEPTION 'It is not allowed to change primary keys';
      RETURN true;
    END IF;

    -- ids are equal
    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This function checks if the passed column of the passed table contains the
 * passed free text.
 *
 * @state   stable
 * @input   varchar: schema name
 *          varchar: table that contains the column
 *          varchar: column that should be checked
 *          text: free text that should be unique
 *          boolean: update operation - DEFAULT false
 * @output  boolean: true if the free text is already contained, else false
 */
CREATE OR REPLACE FUNCTION uniqueness(varchar, varchar, varchar, text,
                                      boolean DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _table ALIAS FOR $2;
    _column ALIAS FOR $3;
    _text ALIAS FOR $4;
    _update_operation ALIAS FOR $5;
    _update_tolerance boolean := true;
    _pt_free_text_id record;
    _uuid uuid;
    _tmp varchar := '';
    _tmp2 varchar;
  BEGIN
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- check if localized_character_string contains the free text and save the
    -- pt_free_text_ids
    FOR _pt_free_text_id IN (SELECT "pt_free_text_id"
                               FROM "localized_character_string"
                              WHERE "free_text" = _text)
    LOOP
      -- check if table.column contains the uuid
      EXECUTE 'SELECT "id" FROM '|| quote_ident(_table) ||'
               WHERE '|| quote_ident(_column) ||'
               = '|| quote_literal(_pt_free_text_id."pt_free_text_id")
         INTO _uuid;

      -- if the id was found, end with true, else loop again
      IF (_uuid IS NOT NULL) THEN
        -- already existing entry must be regarded for update operations
        IF (_update_operation AND _update_tolerance) THEN
          _update_tolerance := false;
        ELSE
          RETURN true;
        END IF;
      END IF;

    END LOOP;

    -- the free text was not found in the table.column
    RETURN false;
  END
  $$ LANGUAGE 'plpgsql';



/* created by Delphi, maybe needed later?
-- Helper functions --
CREATE OR REPLACE FUNCTION get_localized_value_name(uuid, uuid DEFAULT NULL::uuid)
	RETURNS text AS $BODY$
	DECLARE
    _value_id ALIAS FOR $1;
    _pt_locale_id ALIAS FOR $2;
    _sql text;
    _ret text;
	BEGIN
    IF _value_id IS NULL THEN
        RETURN NULL;
    END IF;
    IF _pt_locale_id IS NOT NULL THEN
        _sql := 'SELECT get_localized_character_string(name, ' || _pt_locale_id || ') FROM value_list_values WHERE id = ' || quote_literal(_value_id);
    ELSE
        _sql := 'SELECT get_localized_character_string(name) FROM value_list_values WHERE id = ' || quote_literal(_value_id);
    END IF;
    EXECUTE _sql INTO _ret;
    RETURN _ret;
	END;
	$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_localized_value_list_name(uuid, uuid DEFAULT NULL::uuid)
	RETURNS text AS $BODY$
	DECLARE
    _value_list_id ALIAS FOR $1;
    _pt_locale_id ALIAS FOR $2;
    _sql text;
    _ret text;
	BEGIN
    IF _value_list_id IS NULL THEN
        RETURN NULL;
    END IF;
    IF _pt_locale_id IS NOT NULL THEN
        _sql := 'SELECT get_localized_character_string(name, ' || _pt_locale_id || ') FROM value_list WHERE id = ' || quote_literal(_value_list_id);
    ELSE
        _sql := 'SELECT get_localized_character_string(name) FROM value_list WHERE id = ' || quote_literal(_value_list_id);
    END IF;
    EXECUTE _sql INTO _ret;
    RETURN _ret;
	END;
	$BODY$ LANGUAGE plpgsql;

-- End helperfunctions --
*/
