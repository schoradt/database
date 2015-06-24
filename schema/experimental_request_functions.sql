/*-----------------------------------------------------------------------------
## Übersicht über Funktionstypen:
## add      fügt etwas in die Datenbank ein
## get      ruft Informationen zu einer bestimmten Tabelle aus der Datenbank ab
## show_all zeigt alle Einträge zu einem bestimmten Bereich der Datenbank
## return   ruft zusammengesetzte Informationen aus der Datenbank ab
## create   erzeugt einen Wert, ohne Hinzugabe von Eingabewerten
## check    prüft Eingabewerte nach bestimmten Regeln
-----------------------------------------------------------------------------*/

SET search_path TO "project", "public";
SET CLIENT_ENCODING TO "UTF8";

/*****************************************************************************/
/**************************** Spezielle Funktionen ***************************/
/*****************************************************************************/
/*
 * Erzeugt eine UUID v4.
 *
 * @state   stable
 * @output  uuid: erzeugte UUID
 */
CREATE OR REPLACE FUNCTION public.create_uuid()
  RETURNS uuid AS $$
    SELECT public.uuid_generate_v4();
  $$ LANGUAGE 'sql';


/*
 * Modifziert die Schreibweise bestimmter Datentypen.
 *
 * @state   stable
 * @input   varchar: String des Datentyps
 * @output  varchar: Modifizierter String des Datentyps
 */
CREATE OR REPLACE FUNCTION change_data_type(varchar)
  RETURNS varchar AS $$
  BEGIN
    CASE
      WHEN $1 LIKE 'character varying%' THEN RETURN 'varchar';
      WHEN $1 = 'text' THEN RETURN 'varchar'; -- warum eigentlich?
      WHEN $1 = 'bool' THEN RETURN 'boolean';
      ELSE RETURN $1;
    END CASE;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Prüft den übergebenen Wert, ob er vom übergebenen Datentyp ist.
 *
 * @state   stable
 * @input   text: Wert der auf NULL geprüft werden soll
 *          varchar: Datentyp auf den
 * @output  varchar: erster Wert falls dieser nicht NULL ist, sonst zweiten Wert
 */
CREATE OR REPLACE FUNCTION verify_data_type(text, varchar)
  RETURNS boolean AS $$
  DECLARE 
    test text;
    retval text;
  BEGIN
    test := format('SELECT CAST(%L AS %s)::text', $1, $2);
    EXECUTE test INTO retval;
    RETURN true;
     EXCEPTION
      WHEN invalid_text_representation THEN
        RETURN false;
  END;
$$ LANGUAGE plpgsql;



/*****************************************************************************/
/***************************** SELECT Funktionen *****************************/
/*****************************************************************************/
/*
 * Prüft ob der Erste der beiden übergebenen Werte NULL ist und gibt im Falle
 * den zweiten Wert zurück sonst den ersten Wert.
 *
 * @state   stable
 * @input   uuid: Wert der auf NULL geprüft werden soll
 *          uuid: Rückgabewert, falls erster Wert NULL ist
 * @output  uuid: erster Wert falls dieser nicht NULL ist, sonst zweiten Wert
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
 * Prüft ob der Erste der beiden übergebenen Werte NULL ist und gibt im Falle
 * den zweiten Wert zurück sonst den ersten Wert. Sollte kein zweiter Wert
 * übergeben werden, wird der String NULL zurückgeliefert.
 *
 * @state   stable
 * @input   varchar: Wert der auf NULL geprüft werden soll
 *          varchar: Rückgabewert, falls erster Wert NULL ist - DEFAULT 'NULL'
 * @output  varchar: erster Wert falls dieser nicht NULL ist, sonst zweiten Wert
 */
CREATE OR REPLACE FUNCTION check_for_null(varchar, varchar DEFAULT 'NULL')
  RETURNS varchar AS $$
  BEGIN
    IF quote_nullable($1) = 'NULL' THEN
      RETURN $2;
    ELSE
      RETURN $1;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Ermittelt den Datentyp eines Textelementes und vergleicht diese mit dem
 * Datentyp eines Attributtyps.
 *
 * @state   stable
 * @input   uuid: Textwert dessen Datentyp verglichen werden soll
 *          uuid: Attributtyp Id dessen Datentyp als Vergleich her hält
 * @output  boolean: wahr wenn beide Datentypen übereinstimmen
 */
CREATE OR REPLACE FUNCTION compare_data_types(uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    value_id ALIAS FOR $1;
    at_id ALIAS FOR $2;
    data_type varchar;
  BEGIN
    SELECT return_attribute_data_type(at_id) INTO data_type;
    EXECUTE 'SELECT CAST(' || quote_literal(get_localized_character_string(value_id)) || ' AS ' || data_type || ');';
    
    RETURN true;
    
    EXCEPTION
      WHEN invalid_datetime_format THEN
        return false;
      WHEN invalid_text_representation THEN
        return false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Liefert anhand einer übergebenen Attributwert Id den zugehörigen
 * Attributwert zurück.
 *
 * @state   experimental (es wird keine Sprache berücksichtigt)
 * @input   uuid: Id des Attributwerts
 * @output  varchar: Attributwert
 */
CREATE OR REPLACE FUNCTION return_attribute_value(uuid)
  RETURNS varchar AS $$
  DECLARE
    av_id ALIAS FOR $1;
    value_table_list varchar[];
    value varchar;
  BEGIN
    SELECT "lcs"."free_text" INTO value
      FROM "attribute_value_value" "avv", "localized_character_string" "lcs"
     WHERE "avv"."value" = "lcs"."pt_free_text_id" AND
           "avv"."id" = av_id;
    RETURN check_for_null(value);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Liefert anhand einer übergebenen Attributwert Id den zugehörigen
 * Wertebereich zurück.
 *
 * @state   experimental (es wird keine Sprache berücksichtigt)
 * @input   uuid: Id des Attributwerts
 * @output  varchar: Wertebereich
 */
CREATE OR REPLACE FUNCTION return_attribute_domain(uuid)
  RETURNS varchar AS $$
  DECLARE
    av_id ALIAS FOR $1;
    value varchar;
  BEGIN
    SELECT "lcs"."free_text" INTO value 
      FROM "attribute_value_domain" "avd",
           "localized_character_string" "lcs",
           "value_list_values" "vlv"
     WHERE "avd"."domain" = "vlv"."id" AND
           "vlv"."name" = "lcs"."pt_free_text_id" AND
           "avd"."id" = av_id;
    RETURN check_for_null(value);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Liefert anhand einer übergebenen Attributwert Id die zugehörigen
 * 2D Geometriedaten als String zurück.
 *
 * @state   stable
 * @input   uuid: Id des Attributwerts
 * @output  varchar: String der 2D Geometriedaten
 */
CREATE OR REPLACE FUNCTION return_attribute_geom(uuid)
  RETURNS varchar AS $$
  DECLARE
    av_id ALIAS FOR $1;
    value varchar;
  BEGIN
    SELECT "geom" INTO value
      FROM "attribute_value_geom"
     WHERE "id" = av_id;
    RETURN check_for_null(value);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Liefert anhand einer übergebenen Attributwert Id die zugehörigen
 * 3D Geometriedaten als String zurück.
 *
 * @state   stable
 * @input   uuid: Id des Attributwerts
 * @output  varchar: String der 3D Geometriedaten
 */
CREATE OR REPLACE FUNCTION return_attribute_geomz(uuid)
  RETURNS varchar AS $$
  DECLARE
    av_id ALIAS FOR $1;
    value varchar;
  BEGIN
    SELECT "geom" INTO value
      FROM "attribute_value_geomz"
     WHERE "id" = av_id;
    RETURN check_for_null(value);
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Liefert anhand einer übergebenen Attributwert Id die zugehörige Einheit
 * zurück.
 *
 * @state   stable
 * @input   uuid: Id des Attributwerts
 * @output  varchar: Einheit
 */
CREATE OR REPLACE FUNCTION return_attribute_unit(uuid)
  RETURNS varchar AS $$
  DECLARE
    av_id ALIAS FOR $1;
    value varchar;
  BEGIN
    SELECT "lcs"."free_text" INTO value
      FROM "attribute_value" "av",
           "attribute_type" "at",
           "localized_character_string" "lcs",
           "value_list" "vl"
     WHERE "av"."attribute_type_id" = "at"."id" AND
           "at"."unit" = "vl"."id" AND
           "vl"."name" = "lcs"."pt_free_text_id" AND
           "av"."id" = av_id;
    RETURN check_for_null(value);
  END;
  $$ LANGUAGE 'plpgsql';
  

/*
 * Liefert anhand einer übergebenen Attributwert Id den Attributwert inklusive
 * zusätzlicher Informationen in Form einer Tabelle.
 *
 * @state   experimental (es wird keine Sprache berücksichtigt)
 * @input   uuid: Id des Attributwerts
 * @output  table: Attributtyp, Attributtypbeschreibung, Wert, Wertebereich,
 *                 2D Geometrie, 3D Geometrie, Einheit, Datentyp, Themenausprägung, Thema
 */
CREATE OR REPLACE FUNCTION return_attributes(uuid)
  RETURNS table(r1 text, r2 text, r3 text, r4 text, r5 text, r6 text, r7 text, r8 text, r9 text, r10 text) AS $$
  SELECT
    "lcs_at_name"."free_text" "attribute type",
    "lcs_at_description"."free_text" "attribute type description",
    return_attribute_value($1) "value",
    return_attribute_domain($1) "domain",
    return_attribute_geom($1) "2D geometry",
    return_attribute_geomz($1) "3D geometry",
    return_attribute_unit($1) "unit",
    "lcs_at_data_type"."free_text" "data type",
    "lcs_ta_description"."free_text" "topic characteristic",
    "lcs_topic"."free_text" "topic"
  FROM
    "attribute_value" "av",
    "attribute_type" "at",
    "topic_instance" "ti",
    "topic_characteristic" "tc",
    "value_list" "vl_at_data_type",
    "value_list" "vl_topic",
    "localized_character_string" "lcs_at_name",
    "localized_character_string" "lcs_at_description",
    "localized_character_string" "lcs_at_data_type",
    "localized_character_string" "lcs_topic",
    "localized_character_string" "lcs_ta_description"
  WHERE
    -- Joins
    "av"."attribute_type_id" = "at"."id" AND
    "av"."topic_instance_id" = "ti"."id" AND
    "at"."data_type" = "vl_at_data_type"."id" AND
    "ti"."topic_characteristic_id" = "tc"."id" AND
    "tc"."topic" = "vl_topic"."id" AND
    -- FreeText transformation
    "vl_at_data_type"."name" = "lcs_at_data_type"."pt_free_text_id" AND
    "vl_topic"."name" = "lcs_topic"."pt_free_text_id" AND
    "at"."name" = "lcs_at_name"."pt_free_text_id" AND
    "tc"."description" = "lcs_ta_description"."pt_free_text_id" AND
    "at"."description" = "lcs_at_description"."pt_free_text_id" AND
    -- where condition
    "av"."id" = $1;
$$ LANGUAGE 'sql';

/*
 * Ermittelt den Datentyp eines Attributtyps anhand einer Attributtyp Id oder
 * einer Datentyp Id.
 *
 * @state   experimental (es wird keine Sprache berücksichtigt)
 * @input   uuid: Id des Attributtypen
 *          uuid: Id des Datentypen - DEFAULT NULL
 * @output  varchar: String eines Datentyps
 */
CREATE OR REPLACE FUNCTION return_attribute_data_type(uuid, uuid DEFAULT NULL)
  RETURNS varchar AS $$
  DECLARE
    at_id ALIAS FOR $1;
    dt_id ALIAS FOR $2;
    value varchar;
  BEGIN
    IF (at_id IS NULL AND dt_id IS NOT NULL) THEN
      SELECT get_localized_character_string("vlv"."name", get_pt_locale_id('zxx', NULL, 'UTF8')) INTO value
      FROM
        "value_list_values" "vlv"
      WHERE
        "vlv"."id" = dt_id;
    ELSE
      SELECT get_localized_character_string("vlv"."name", get_pt_locale_id('zxx', NULL, 'UTF8')) INTO value
      FROM
        "attribute_type" "at",
        "value_list_values" "vlv"
      WHERE
        "at"."data_type" = "vlv"."id" AND
        "at"."id" = at_id;
    END IF;
    RETURN check_for_null(value);
  END;
  $$ LANGUAGE 'plpgsql';

  

/* ------------------------------- pt_locale ------------------------------- */
/*
 * Ermittelt die pt_locale_id anhand von Angaben zur Sprachkodierung, der
 * Landkodierung und der Zeichenkodierung.
 *
 * @state   stable
 * @input   varchar: Sprachkodierung (deu)
 *          varchar: Landkodierung (DE - wenn NULL, wird Sprachparameter 'zxx'
 *                   verwendet)
 *          varchar: Zeichenkodierung (UTF8)
 * @output  uuid: pt_locale_id
 */
CREATE OR REPLACE FUNCTION get_pt_locale_id(varchar, varchar, varchar)
  RETURNS uuid AS $$
  DECLARE
    lang ALIAS FOR $1;
    country ALIAS FOR $2;
    char_code ALIAS FOR $3;
    pt_locale uuid;
  BEGIN
    -- Einträge die keiner Sprache zugeordnet werden können, müssen bei der Anfrage separat behandelt werden
    IF country IS NULL AND lang = 'zxx' THEN
      SELECT "pt"."id" INTO pt_locale FROM "pt_locale" "pt", "language_code" "s", "character_code" "z" WHERE
             "pt"."language_code_id" = "s"."id" AND "pt"."character_code_id" = "z"."id" AND
             "s"."language_code" = lang AND "z"."character_code" = char_code;
    ELSE
      SELECT "pt"."id" INTO pt_locale FROM "pt_locale" "pt", "language_code" "s", "country_code" "l", "character_code" "z" WHERE
             "pt"."language_code_id" = "s"."id" AND "pt"."country_code_id" = "l"."id" AND "pt"."character_code_id" = "z"."id" AND
             "s"."language_code" = lang AND "l"."country_code" = country AND "z"."character_code" = char_code;
    END IF;
    RETURN pt_locale;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Ermittelt die Sprachkodierung, die Landkodierung und die Zeichenkodierung zu
 * einer pt_local_id.
 *
 * @state   experimental (liefert keinen Wert wenn Landkodierung NULL ist)
 * @input   uuid: pt_local_id der Ausgabe
 * @output  table: Sprachkodierung, Landkodierung, Zeichenkodierung
 */
CREATE OR REPLACE FUNCTION get_pt_locale_value(uuid)
  RETURNS table(r1 text, r2 text, r3 text) AS $$
    SELECT "s"."language_code", "l"."country_code", "z"."character_code"
    FROM "pt_locale" "pt", "language_code" "s", "country_code" "l", "character_code" "z"
    WHERE "pt"."language_code_id" = "s"."id" AND "pt"."country_code_id" = "l"."id" AND "pt"."character_code_id" = "z"."id" AND "pt"."id" = $1;
  $$ LANGUAGE 'sql';


/* ------------------------------ pt_free_text ----------------------------- */
/*
 * Ermittelt die pt_free_text_id zu einem Freitext und einer pt_local_id.
 *
 * @state   stable
 * @input   text: Freitext
 *          uuid: pt_local_id des Freitextes
 * @output  uuid: pt_free_text_id des Freitextes
 */
CREATE OR REPLACE FUNCTION get_pt_free_text_id(text, uuid)
  RETURNS uuid AS $$
    SELECT "pt_free_text_id" FROM "localized_character_string" WHERE "pt_locale_id" = $2 AND "free_text" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt den Freitext zu einer pt_free_text_id und einer pt_local_id.
 *
 * @state   experimental (Rückgabe bei pt_free_text_id mit 2 Locales ohne Angabe
 *                       von pt_local_id unklar)
 * @input   uuid: pt_free_text_id für den Freitext
 *          uuid: pt_local_id der Ausgabe - DEFAULT NULL
 * @output  text: Freitext
 */
CREATE OR REPLACE FUNCTION get_localized_character_string(uuid, uuid DEFAULT NULL)
  RETURNS text AS $$
  DECLARE
    sql text;
    ret text;
  BEGIN
    IF $1 IS NULL THEN
      RETURN NULL;
    END IF;
    
    sql := 'SELECT "free_text" FROM "localized_character_string" WHERE "pt_free_text_id" = '|| quote_literal($1);
    IF $2 IS NOT NULL THEN
      sql := sql ||' AND "pt_locale_id" = '|| quote_literal($2);
    END IF;
    
    EXECUTE sql INTO ret;
    
    RETURN ret;
  END;
  $$ LANGUAGE 'plpgsql';


/* --------------------------- value_list_values --------------------------- */

/*
 * Ermittelt alle Wertelistenwerte einer spezifische Werteliste.
 *
 * @state   stable
 * @input   varchar: Name der Werteliste
 *          uuid: pt_locale_id für den Namen der Werteliste
 *          uuid: pt_locale_id der Ausgabe - DEFAULT NULL
 * @output  table: Wertelistenwerte der Werteliste
 */
CREATE OR REPLACE FUNCTION get_values_from_value_list(varchar, uuid, uuid DEFAULT NULL)
  RETURNS table(name text) AS $$
    SELECT
      "lcs2"."free_text"
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs1", -- Werteliste
      "localized_character_string" "lcs2"  -- WertelistenWert
    WHERE
      "vl"."name" = "lcs1"."pt_free_text_id" AND
      "lcs1"."pt_locale_id" = $2 AND
      "vlv"."name" = "lcs2"."pt_free_text_id" AND
      "lcs2"."pt_locale_id" = check_for_null($3, $2) AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs1"."free_text" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt den Wertelistenwert zu einer bestimmten Id für eine spezifische
 * Werteliste.
 *
 * @state   stable
 * @input   uuid: Id des Wertelistenwertes
 *          varchar: Name der Werteliste
 *          uuid: pt_locale_id für den Namen der Werteliste
 *          uuid: pt_locale_id der Ausgabe - DEFAULT NULL
 * @output  varchar: Wertelistenwert
 */
CREATE OR REPLACE FUNCTION get_value_from_value_list(uuid, varchar, uuid, uuid DEFAULT NULL)
  RETURNS varchar AS $$
    SELECT
      "lcs2"."free_text"
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs1", -- Werteliste
      "localized_character_string" "lcs2"  -- WertelistenWert
    WHERE
      "vl"."name" = "lcs1"."pt_free_text_id" AND
      "lcs1"."pt_locale_id" = $3 AND
      "vlv"."name" = "lcs2"."pt_free_text_id" AND
      "lcs2"."pt_locale_id" = check_for_null($4, $3) AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs1"."free_text" = $2 AND
      "vlv"."id" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die Id eines Wertelistenwertes für eine spezifische Werteliste.
 *
 * @state   experimental (Einfluss von Sprachen unklar)
 * @input   varchar: Name des Wertelistenwert
 *          varchar: Name der Werteliste
 * @output  uuid: Id eines Wertelistenwertes
 */
CREATE OR REPLACE FUNCTION get_value_id_from_value_list(varchar, varchar)
  RETURNS uuid AS $$
    SELECT
      "vlv"."id"
    FROM
      "value_list" "vl",
      "value_list_values" "vlv",
      "localized_character_string" "lcs1", -- Werteliste
      "localized_character_string" "lcs2"  -- WertelistenWert
    WHERE
      "vl"."name" = "lcs1"."pt_free_text_id" AND
      "vlv"."name" = "lcs2"."pt_free_text_id" AND
      "vlv"."belongs_to_value_list" = "vl"."id" AND
      "lcs1"."free_text" = $2 AND
      "lcs2"."free_text" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die Id eines Wertelistenwertes für eine bestimmte pt_locale_id.
 *
 * @state   stable
 * @input   varchar: Name des Wertelistenwertes
 *          uuid: pt_locale_id für den Namen des Wertelistenwertes
 * @output  uuid: Id des Wertelistenwertes
 */
CREATE OR REPLACE FUNCTION get_value_id(varchar, uuid)
  RETURNS uuid AS $$
    SELECT
      "vlv"."id"
    FROM
      "value_list_values" "vlv",
      "localized_character_string" "lcs" -- WertelistenWert
    WHERE
      "vlv"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $2 AND
      "lcs"."free_text" = $1
  $$ LANGUAGE 'sql';


/*
 * Ermittelt den Namen eines Wertelistenwertes zu einer Wertelistenwerte Id und
 * einer bestimmten pt_locale_id.
 *
 * @state   stable
 * @input   uuid: Id des Wertelistenwertes
 *          uuid: pt_locale_id für den Namen des Wertelistenwertes
 * @output  varchar: Name des Wertelistenwertes
 */
CREATE OR REPLACE FUNCTION get_Value(uuid, uuid)
  RETURNS varchar AS $$
    SELECT
      "lcs"."free_text"
    FROM
      "value_list_values" "vlv",
      "localized_character_string" "lcs" -- WertelistenWert
    WHERE
      "vlv"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $2 AND
      "vlv"."id" = $1
  $$ LANGUAGE 'sql';


/* ------------------------------- value_list ------------------------------ */

/*
 * Ermittelt die Id einer Werteliste für eine bestimmte pt_locale_id.
 *
 * @state   stable
 * @input   varchar: Name der Werteliste
 *          uuid: pt_locale_id für den Namen der Werteliste
 * @output  uuid: Id der Werteliste
 */
CREATE OR REPLACE FUNCTION get_value_list_id(varchar, uuid)
  RETURNS uuid AS $$
    SELECT
      "vl"."id"
    FROM
      "value_list" "vl",
      "localized_character_string" "lcs" -- Werteliste
    WHERE
      "vl"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $2 AND
      "lcs"."free_text" = $1
  $$ LANGUAGE 'sql';


/*
 * Ermittelt den Namen einer Werteliste zu einer Wertelisten Id und einer
 * bestimmten pt_locale_id.
 *
 * @state   stable
 * @input   uuid: Id der Werteliste
 *          uuid: pt_locale_id für den Namen der Werteliste
 * @output  varchar: Name der Werteliste
 */
CREATE OR REPLACE FUNCTION get_value_list(uuid, uuid)
  RETURNS varchar AS $$
    SELECT
      "lcs"."free_text"
    FROM
      "value_list" "vl",
      "localized_character_string" "lcs" -- Werteliste
    WHERE
      "vl"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $2 AND
      "vl"."id" = $1
  $$ LANGUAGE 'sql';


/* -------------------------------- project -------------------------------- */

/*
 * Ermittelt die Id zu einem Projektnamen.
 *
 * @state   stable
 * @input   varchar: Name des Projekts
 *          uuid: pt_locale_id für den Projektnamen
 * @output  uuid: Id des Projektes
 */
CREATE OR REPLACE FUNCTION get_project_id(varchar, uuid)
  RETURNS uuid AS $$
    SELECT
      "p"."id"
    FROM
      "project" "p",
      "localized_character_string" "lcs" -- Name
    WHERE
      "p"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $2 AND
      "lcs"."free_text" = $1
  $$ LANGUAGE 'sql';


/*
 * Ermittelt den Namen eines Projektes zu einer Projekt Id und einer bestimmten
 * pt_locale_id.
 *
 * @state   stable
 * @input   uuid: Id eines Projektes
 *          uuid: pt_locale_id für den Projektnamen
 * @output  varchar: Name des Projektes
 */
CREATE OR REPLACE FUNCTION get_project(uuid, uuid)
  RETURNS varchar AS $$
    SELECT
      "lcs"."free_text"
    FROM
      "project" "p",
      "localized_character_string" "lcs" -- Name
    WHERE
      "p"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $2 AND
      "p"."id" = $1
  $$ LANGUAGE 'sql';


/* ------------------------- topic_characteristic -------------------------- */

/*
 * Ermittelt die Id einer Themenausprägung unter Angabe der Beschreibung der
 * Themenausprägung, dem zugehörigen Thema, dem zugehörigen Projekt und der
 * pt_locale_id der genannten Eingabeparameter.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   varchar: Beschreibung der Themenausprägung
 *          varchar: Thema zur Themenausprägung
 *          varchar: Projekt zur Themenausprägung
 *          uuid: pt_locale_id der Eingabe
 * @output  uuid: Id der Themenausprägung
 */
CREATE OR REPLACE FUNCTION get_topic_characteristic_id(varchar, varchar, varchar, uuid)
  RETURNS uuid AS $$
    SELECT 
      "id"
    FROM
      "topic_characteristic"
    WHERE
      "description" = get_pt_free_text_id($1, $4) AND
      "topic" = get_value_id_from_value_list($2, 'vl_topic') AND
      "project_id" = get_project_id($3, $4)
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die Beschreibung, das Thema und das Projekt einer Themenausprägungs
 * Id zu einer bestimmten pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   uuid: Id der Themenausprägung
 *          uuid: pt_locale_id der Ausgabe
 * @output  table: Beschreibung, Thema, Projekt
 */
CREATE OR REPLACE FUNCTION get_topic_characteristic(uuid, uuid)
  RETURNS table(r1 text, r2 text, r3 text) AS $$
    SELECT
      get_localized_character_string("description", $2) "description",
      get_value_from_value_list("topic", 'WL_Thema', get_pt_locale_id('deu', 'DE', 'UTF8'), $2) "topic",
      get_project("project_id", $2) "project"
    FROM
      "topic_characteristic"
    WHERE
      "id" = $1
  $$ LANGUAGE 'sql';


/* ----------------------------- attribute_type ---------------------------- */

/*
 * Ermittelt die Id eines Attributtyps für einen Namen und Datentyp zu einer
 * pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   varchar: Name
 *          varchar: Datentyp
 *          uuid: pt_locale_id der Eingabe
 * @output  uuid: Id des Attributtyps
 */
CREATE OR REPLACE FUNCTION get_attribute_type_id(varchar, varchar, uuid)
  RETURNS uuid AS $$
    SELECT
      "at"."id"
    FROM
      "localized_character_string" "lcs1", -- Name
      "localized_character_string" "lcs2", -- WertelistenWert
      "localized_character_string" "lcs3", -- Werteliste
      "attribute_type" "at",
      "value_list" "vl",
      "value_list_values" "vlv"
    WHERE
      "at"."name" = "lcs1"."pt_free_text_id" AND
      "at"."data_type" = "vlv"."id" AND
      "lcs1"."free_text" = $1 AND
      "lcs1"."pt_locale_id" = $3 AND
      "lcs2"."free_text" = $2 AND
      "lcs2"."pt_locale_id" = get_pt_locale_id('zxx', NULL, 'UTF8') AND
      "lcs3"."free_text" = 'vl_data_type' AND
      "lcs3"."pt_locale_id" = get_pt_locale_id('eng', 'GB', 'UTF8') AND
      "lcs2"."pt_free_text_id" = "vlv"."name" AND
      "lcs3"."pt_free_text_id" = "vl"."name"
  $$ LANGUAGE 'sql';


/*
 * Ermittelt den Namen, die Beschreibung, den Datentyp, die Einheit und den
 * Wertebereich eines Attributtyps für eine Attributtyp Id zu einer bestimmten
 * pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   uuid: Id eines Attributtyps
 *          uuid: pt_locale_id der Ausgabe
 * @output  table: Name, Beschreibung, Datentyp, Einheit, Wertebereich
 */
-- Ermittelt alle Werte zu einem Attributtyp anhand einer Id zu einer bestimmten pt_locale_id
-- Parameter: Attributtyp Id, pt_locale_id
CREATE OR REPLACE FUNCTION get_attribute_type(uuid, uuid)
  RETURNS table(r1 varchar, r2 text, r3 varchar, r4 varchar, r5 varchar) AS $$
    SELECT
	  get_localized_character_string("name", $2),
	  get_localized_character_string("description", $2),
	  get_value_from_value_list("data_type", 'WL_Datentyp', get_pt_locale_id('deu', 'DE', 'UTF8'), get_pt_locale_id('zxx', NULL, 'UTF8')),
	  get_value_from_value_list("unit", 'WL_Einheit', get_pt_locale_id('deu', 'DE', 'UTF8'), get_pt_locale_id('zxx', NULL, 'UTF8')),
	  get_value_list("domain", $2) FROM "attribute_type"
     WHERE "id" = $1;
  $$ LANGUAGE 'sql';


/* -------------------------------- geometry ------------------------------- */

/*
 * Ermittelt die Geometrie Id zu einer 2D Geometrie.
 *
 * @state   stable
 * @input   geometry(geometry, 4326): 2D Geometrie
 * @output  uuid: Id der Geometrie
 */
CREATE OR REPLACE FUNCTION get_geom_id(geometry(geometry, 4326))
  RETURNS uuid AS $$
    SELECT "id" FROM "attribute_value_geom" WHERE "geom" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die 2D Geometrie zu einer Geometrie Id.
 *
 * @state   stable
 * @input   uuid: Id der Geometrie
 * @output  geometry(geometry, 4326): 2D Geometrie
 */
CREATE OR REPLACE FUNCTION get_geom(uuid)
  RETURNS geometry(geometry, 4326) AS $$
    SELECT "geom" FROM "attribute_value_geom" WHERE "id" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die Geometrie Id zu einer 3D Geometrie.
 *
 * @state   stable
 * @input   geometry(geometryz, 4326): 3D Geometrie
 * @output  uuid: Id der Geometrie
 */
CREATE OR REPLACE FUNCTION get_geomz_id(geometry(geometryz, 4326))
  RETURNS uuid AS $$
    SELECT "id" FROM "attribute_value_geomz" WHERE "geom" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die 3D Geometrie zu einer Geometrie Id.
 *
 * @state   stable
 * @input   uuid: Id der Geometrie
 * @output  geometry(geometryz, 4326): 3D Geometrie
 */
CREATE OR REPLACE FUNCTION get_geomz(uuid)
  RETURNS geometry(geometryz, 4326) AS $$
    SELECT "geom" FROM "attribute_value_geomz" WHERE "id" = $1;
  $$ LANGUAGE 'sql';


/* ----------------- attribute_type_to_topic_characteristic ---------------- */

/*
 * Ermittelt alle Attributtypen, die einem bestimmten Thema über eine
 * Themenausprägung zugeordnet sind. Die Attributtypen sind alphabetisch und
 * nach den Themenausprägungen sortiert.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   varchar: Name des Themas
 *          uuid: pt_locale_id für Ein- und Ausgabe
 * @output  SETOF varchar: Liste von Attributtypen
 */
CREATE OR REPLACE FUNCTION get_attribute_types_from_topic_characteristic(varchar, uuid)
  RETURNS SETOF varchar AS $$
    SELECT
      get_localized_character_string("at"."name", $2)
    FROM
      "topic_characteristic" "tc",
      "attribute_type_to_topic_characteristic" "att",
      "attribute_type" "at"
    WHERE
      "att"."topic_characteristic_id" = "tc"."id" AND
      "att"."attribute_type_id" = "at"."id" AND
      get_value_from_value_list("tc"."topic", 'WL_Thema', $2) = $1
    ORDER BY get_localized_character_string("at"."name", $2), "tc"."id"
  $$ LANGUAGE 'sql';


/*
 * Ermittelt alle Themenausprägungsbeschreibungen und die zugehörigen Themen,
 * die einen bestimmten Attributtyp zugeordnet haben. Die Beschreibungen und
 * Themen sind alphabetisch sortiert.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   varchar: Name des Attributtyps
 *          uuid: pt_locale_id für Ein- und Ausgabe
 * @output  SETOF text[]: Beschreibung der Themenausprägung, Thema
 */
CREATE OR REPLACE FUNCTION get_topic_characteristics_from_attribute_type(varchar, uuid)
  RETURNS SETOF text[] AS $$
    SELECT ARRAY[
      get_localized_character_string("tc"."description", $2),
      get_value_from_value_list("tc"."topic", 'WL_Thema', $2)]
    FROM
      "topic_characteristic" "tc",
      "attribute_type_to_topic_characteristic" "att",
      "attribute_type" "at"
    WHERE
      "att"."topic_characteristic_id" = "tc"."id" AND
      "att"."attribute_type_id" = "at"."id" AND
      get_localized_character_string("at"."name", $2) = $1
    ORDER BY get_value_from_value_list("tc"."topic", 'WL_Thema', $2), "tc"."id"
  $$ LANGUAGE 'sql';


/* ------------------------------ multiplicity ----------------------------- */

/*
 * Ermittelt die Id für einen Min und Max Wert einer Multiplizität.
 *
 * @state   stable
 * @input   integer: Min Wert
 *          integer: Max Wert - DEFAULT NULL
 * @output  uuid: Id der Multiplizität
 */
CREATE OR REPLACE FUNCTION get_multiplicity(integer, integer DEFAULT NULL)
  RETURNS uuid AS $$
  DECLARE
    result uuid;
  BEGIN
    IF ($2 IS NULL) THEN
      SELECT "id" INTO result FROM "multiplicity" WHERE "min_value" = $1;
    ELSE
      SELECT "id" INTO result FROM "multiplicity" WHERE "min_value" = $1 AND "max_value" = $2;
    END IF;
    RETURN result;
  END;
  $$ LANGUAGE 'plpgsql';


/* ---------------------------- attribute_value ---------------------------- */

/* ----------------------------- topic_instance ---------------------------- */

/* --------------------------- relationship_type --------------------------- */

/*
 * Ermittelt für eine bestimmten Beziehungstyp Id zu einer pt_locale_id den
 * Beziehungstyp und das Thema, auf das sich der Beziehungstyp bezieht.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   uuid: Id des Beziehungstyps
 *          uuid: pt_locale_id der Ausgabe
 * @output  table: Beschreibung, Thema auf das referenziert wird
 */
CREATE OR REPLACE FUNCTION get_relationship_type(uuid, uuid)
  RETURNS table(r1 varchar, r2 varchar) AS $$
    SELECT get_value_from_value_list("description",'WL_Beziehungstyp', $2, $2), get_value_from_value_list("reference_to", 'WL_Thema', $2) FROM "relationship_type" WHERE "id" = $1;
  $$ LANGUAGE 'sql';


/*
 * Ermittelt die Id eines Beziehungstyps für eine Beschreibung und einem Thema zu
 * einer pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   varchar: Beschreibung des Beziehungstyps
 *          varchar: referenziertes Thema
 *          uuid: pt_locale_id der Eingabe
 * @output  uuid: Id des Beziehungstyps
 */
CREATE OR REPLACE FUNCTION get_relationship_type_id(varchar, varchar, uuid)
  RETURNS uuid AS $$
    SELECT "id" FROM "relationship_type" WHERE "description" = (get_value_id_from_value_list($1, 'vl_relationship_type')) AND "reference_to" = (get_value_id_from_value_list($2, 'vl_topic'));
  $$ LANGUAGE 'sql';


/* --------------------------- Show All Funkionen -------------------------- */

/*
 * Liefert alle Attributtypen mit allen zugehörigen Eigenschaften bzgl. der
 * angegebeben pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Id, Name, Beschreibung, Datentyp, Einheit, Wertebereich
 */
CREATE OR REPLACE FUNCTION show_all_attribute_types(uuid)
  RETURNS SETOF text[] AS $$
    SELECT ARRAY[
      "id"::text,
      get_localized_character_string("name", $1),
      get_localized_character_string("description", $1),
      get_value_from_value_list("data_type", 'WL_Datentyp', get_pt_locale_id('deu', 'DE', 'UTF8'), get_pt_locale_id('zxx', NULL, 'UTF8')),
      get_value_from_value_list("unit", 'WL_Einheit', get_pt_locale_id('deu', 'DE', 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8')),
      get_value_list("domain", $1)]
    FROM "attribute_type";
  $$ LANGUAGE 'sql';


/*
 * Liefert alle Projekte mit allen zugehörigen Eigenschaften bzgl. der
 * angegebenen pt_locale_id.
 *
 * @state   stable
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Id, Name, Beschreibung, Teilprojekt von
 */
CREATE OR REPLACE FUNCTION show_all_projects(uuid)
  RETURNS SETOF text[] AS $$
    SELECT ARRAY[
      "id"::text,
      get_localized_character_string("name", $1),
      get_localized_character_string("description", $1),
      get_project("subproject_of", $1)]
    FROM "project";
  $$ LANGUAGE 'sql';


/*
 * Liefert alle Themenausprägungen mit allen zugehörigen Eigenschaften bzgl.
 * der angegebenen pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Id, Beschreibung, Thema, Projekt Id
 */
CREATE OR REPLACE FUNCTION show_all_topic_characteristics(uuid)
  RETURNS SETOF text[] AS $$
    SELECT ARRAY[
      "id"::text,
      get_localized_character_string("description", $1),
      get_value_from_value_list("topic", 'WL_Thema', $1),
      get_project("project_id", $1)]
    FROM "topic_characteristic";
  $$ LANGUAGE 'sql';


/*
 * Liefert alle Attributtypen mit allen zugehörigen Eigenschaften bzgl. der
 * angegebenen pt_locale_id.
 *
 * @state   ???
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Id, Name, Themeninstanz Id, Wertebereich, 2D Geometrie,
 *          3D Geometrie, Wert
 */
--CREATE OR REPLACE FUNCTION show_all_attribute_values(uuid)
--  RETURNS SETOF text[] AS $$
--    SELECT ARRAY[
--      "aw"."id"::text,
--      get_localized_character_string("at"."name", $1),
--      "aw"."topic_instance_id"::text,
--      get_Value("aw"."Wertebereich_Id", $1)::text,
--      get_Geometry("aw"."Geometrie_Id")::text,
--      get_localized_character_string("aw"."Wert", $1)]
--    FROM
--      "Attributwert" "aw",
--      "Attributtyp" "at"
--    WHERE
--      "aw"."Attributtyp_Id" = "at"."Id";
--  $$ LANGUAGE 'sql';


/*
 * Liefert alle Beziehungstypen mit allen zugehörigen Eigenschaften bzgl. der
 * angegebenen pt_locale_id.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Beschreibung des Beziehungstyps, referenziertes Thema
 */
CREATE OR REPLACE FUNCTION show_all_relationship_types(uuid)
  RETURNS SETOF text[] AS $$
    SELECT ARRAY[
      get_value_from_value_list("description", 'WL_Beziehungstyp', $1)::text,
      get_value_from_value_list("reference_to", 'WL_Thema', $1)::text]
    FROM "relationship_type";
  $$ LANGUAGE 'sql';


/*
 * Liefert alle Attributtypen zu Themenausprägungen mit dem zugehörigen Thema
 * bzgl. der angegebenen pt_locale_id, sortiert nach Themen.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Name des Themas, Name des Attributtyps
 */
CREATE OR REPLACE FUNCTION show_all_attribute_types_to_topic_characteristics(uuid)
  RETURNS SETOF text[] AS $$
    SELECT ARRAY[
      get_value_from_value_list("tc"."topic", 'WL_Thema', $1)::text,
      get_localized_character_string("at"."name", $1)::text]
    FROM
      "topic_characteristic" "tc",
      "attribute_type_to_topic_characteristic" "att",
      "attribute_type" "at"
    WHERE
      "att"."topic_characteristic_id" = "tc"."id" AND
      "att"."attribute_type_id" = "at"."id" ORDER BY get_value_from_value_list("tc"."topic", 'WL_Thema', $1)
  $$ LANGUAGE 'sql';


/*
 * Liefert alle Beziehungstypen zu Themenausprägungen mit den zugehörigen
 * Themen, Projekten und Beschreibungen bzgl. der angegebenen pt_locale_id,
 * sortiert nach Themenausprägungen.
 *
 * @state   experimental (feste Angabe von Wertelisten)
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Projekt der Themenausprägung, Thema der Themenausprägung,
 *                        Beschreibung des Beziehungstyps, Thema des Beziehungstyps
 */
CREATE OR REPLACE FUNCTION show_all_relationships_to_topic_characteristics(uuid)
  RETURNS SETOF text[] AS $$
SELECT ARRAY[
      get_project("tc"."project_id", $1)::text, -- Projekt der Themenausprägung
      get_value_from_value_list("tc"."topic", 'WL_Thema', $1)::text, -- Thema der Themenausprägung
      get_value_from_value_list("rt"."description", 'WL_Beziehungstyp', $1)::text, -- Beschreibung des Beziehungstyp
      get_value_from_value_list("rt"."reference_to", 'WL_Thema', $1)::text]-- Thema des Beziehungstyps
    FROM
      "topic_characteristic" "tc",
      "relationship_type_to_topic_characteristic" "rtt",
      "relationship_type" "rt"
    WHERE
      "rtt"."topic_characteristic_id" = "tc"."id" AND
      "rtt"."relationship_type_id" = "rt"."id" ORDER BY get_value_from_value_list("tc"."topic", 'WL_Thema', $1)
      $$ LANGUAGE 'sql';


/*
 * Liefert alle Themeninstanzen mit allen Attributtypen und deren Attributwerte
 * bzgl. der angegebenen pt_locale_id.
 *
 * @state   stable
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text[]: Id der Themeninstanz, Attributtypen, Attributwerte
 */
CREATE OR REPLACE FUNCTION show_all_topic_instances(uuid)
  RETURNS SETOF text[] AS $$
  DECLARE
    pt_locale ALIAS FOR $1;
    ti record;
    values record;
    valueAgg text;
  BEGIN
    -- laufe durch jede Themeninstanz
    FOR ti IN EXECUTE 'SELECT "id" FROM "topic_instance"'
    LOOP
      -- für jede Themeninstanz muss die Zeichenkette für Attributtypen und Attributwerte initial leer sein
      valueAgg := '';
      -- ermittle alle Attributtypen und die zugehörigen Attributwerte zu der Themeninstanz Id
      FOR values IN EXECUTE 'SELECT get_localized_character_string("at"."name", '|| quote_literal(pt_locale) ||') "at", get_localized_character_string("av"."value", '|| quote_literal(pt_locale) ||') "av" FROM "attribute_value_value" "av", "attribute_type" "at" WHERE "av"."attribute_type_id" = "at"."id" AND "av"."topic_instance_id" = ' || quote_literal(ti."id")
      LOOP
        -- füge alle Attributtypen und Attributwerte als Text aneinander
        valueAgg := valueAgg || ', ' || values."at" || ' = ' || values."av";
      END LOOP;
      -- gebe alles zurück, entferne dabei das Komma am Beginn der Attributtyp / Attributwert Zeichenkette
      RETURN NEXT ARRAY[ti."id"::text, ltrim(valueAgg, ', ')];
      
    END LOOP;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Liefert alle Wertelisten bzgl. der angegebenen pt_locale_id.
 *
 * @state   stable
 * @input   uuid: pt_locale_id der Ausgabe
 * @output  SETOF text: Namen der Wertelisten
 */
CREATE OR REPLACE FUNCTION show_all_value_lists(uuid)
  RETURNS SETOF text AS $$
    SELECT
      "lcs"."free_text"
    FROM
      "value_list" "vl",
      "localized_character_string" "lcs"
    WHERE
      "vl"."name" = "lcs"."pt_free_text_id" AND
      "lcs"."pt_locale_id" = $1;
  $$ LANGUAGE 'sql';


/*****************************************/
/*********** INSERT Funktionen ***********/
/*****************************************/

/*
 * Fügt in localized_character_string einen neuen Eintrag ein. Dabei wird ein
 * entsprechender Locale Eintrag erstellt, falls er noch nicht vorhanden ist.
 * Werte können auch in Bezug zu anderen Sprachwerten eingefügt werden
 * (Übersetzungen). Dabei stellen die optionalen Parameter den Bezug auf den
 * Eintrag dar, zu dem eine Übersetzug eingefügt werden soll. Dieser Eintrag
 * muss bereits existieren. Diese Funktion arbeitet Case Sensitive!
 *
 * @state   stable
 * @input   text: Freitext
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 *          text: gehört zu Freittext - DEFAULT NULL
 *          varchar: gehört zu Sprachkodierung - DEFAULT NULL
 *          varchar: gehört zu Landkodierung - DEFAULT NULL
 *          varchar: gehört zu Zeichenkodierung - DEFAULT NULL
 */
CREATE OR REPLACE FUNCTION add_localized_character_string(text, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8', text DEFAULT NULL, varchar DEFAULT NULL, varchar DEFAULT NULL, varchar DEFAULT NULL)
  RETURNS VOID AS $$
  DECLARE
    text ALIAS FOR $1;
    lang ALIAS FOR $2;
    country ALIAS FOR $3;
    char_code ALIAS FOR $4;
    belongs_to_text ALIAS FOR $5;
    belongs_to_lang ALIAS FOR $6;
    belongs_to_country ALIAS FOR $7;
    belongs_to_char_code ALIAS FOR $8;
    next_pt_free_text_id uuid;
    pt_locale uuid;
    lang_id uuid;
    country_id uuid;
    char_code_id uuid;
    belongs_to_lang_id uuid;
    belongs_to_country_id uuid;
    belongs_to_char_code_id uuid;
  BEGIN
    -- Prüfe ob es für pt_locale bereits einen passenden Eintrag gibt
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;
    
    -- falls kein entsprechender Eintrag vorhanden sein sollte ...
    IF pt_locale IS NULL THEN
      -- hole Ids der entsprechenden Kodierungen
      SELECT "id" INTO lang_id FROM "language_code" WHERE "language_code" = lang;
      SELECT "id" INTO country_id FROM "country_code" WHERE "country_code" = country;
      SELECT "id" INTO char_code_id FROM "character_code" WHERE "character_code" = char_code;
      
      -- prüfe ob Sprachkodierung vorhanden ist, wenn nicht füge diese ein und speichere die Id
      IF lang_id IS NULL THEN
        INSERT INTO "language_code" ("language_code") VALUES (lang);
        SELECT "id" INTO lang_id FROM "language_code" WHERE "language_code" = lang;
      END IF;
      
      -- prüfe ob Landkodierung vorhanden ist, wenn nicht füge diese ein und speichere die Id
      IF country_id IS NULL THEN
        INSERT INTO "country_code" ("country_code") VALUES (country);
        SELECT "id" INTO country_id FROM "country_code" WHERE "country_code" = country;
      END IF;
      
      -- prüfe ob Zeichenkodierung vorhanden ist, wenn nicht füge diese ein und speichere die Id
      IF char_code_id IS NULL THEN
        INSERT INTO "character_code" ("character_code") VALUES (char_code);
        SELECT "id" INTO char_code_id FROM "character_code" WHERE "character_code" = char_code;
      END IF;
      
      -- füge einen neuen Eintrag für pt_locale ein und speichere die Id
      INSERT INTO "pt_locale" ("language_code_id", "country_code_id", "character_code_id") VALUES (lang_id, country_id, char_code_id);
      SELECT "id" INTO pt_locale FROM "pt_locale" WHERE "language_code_id" = lang_id AND "country_code_id" = country_id AND "character_code_id" = char_code_id;
    END IF;
    
    -- prüfe ob der String mit der entsprechenden Lokalisierung bereits in localized_character_string vorhanden ist
    IF (SELECT "pt_locale_id" FROM "localized_character_string" WHERE "pt_locale_id" = pt_locale AND "free_text" = text) IS NULL
    THEN
      -- prüfe ob die belongs_to Werte existieren und ermittele die passende pt_free_text_id
      SELECT get_pt_free_text_id(belongs_to_text, get_pt_locale_id(belongs_to_lang, belongs_to_country, belongs_to_char_code)) INTO next_pt_free_text_id;
      
      IF next_pt_free_text_id IS NULL THEN
        -- pt_free_text_id erzeugen und einfügen
        next_pt_free_text_id := create_uuid();
        INSERT INTO "pt_free_text" ("id") VALUES (next_pt_free_text_id);
      END IF;
      
      -- füge Eintrag in localized_character_string ein
      INSERT INTO "localized_character_string" ("pt_free_text_id", "pt_locale_id", "free_text") VALUES (next_pt_free_text_id, pt_locale, text);
    ELSE
      RAISE NOTICE 'Es existiert bereits ein Eintrag für "%" in localized_character_string.', text;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Werteliste (value_list) ein. Die Werte werden bzgl. der
 * angegebenen Lokalisierung gespeichert. Sollte eine Werteliste hinzugefügt
 * werden, der bereits vorhanden ist und dessen Beschreibung NULL ist, so wird
 * die angegebene Beschreibung aktualisiert.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   stable
 * @input   varchar: Name
 *          text: Beschreibung - DEFAULT NULL
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_value_list(varchar, text DEFAULT NULL, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    _name ALIAS FOR $1;
    _description ALIAS FOR $2;
    lang ALIAS FOR $3;
    country ALIAS FOR $4;
    char_code ALIAS FOR $5;
    pt_locale uuid;
    name_id uuid;
    description_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Fehlermeldung, falls kein passender Eintrag in PT_Locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für den Namen aus localized_character_string und prüfe ob der Name vorhanden ist, sonst Fehler
      SELECT get_pt_free_text_id(_name, pt_locale) INTO name_id;
      IF name_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden!', _name;
      END IF;
      
      -- Hole die Id für die Beschreibung aus localized_character_string und prüfe ob die Beschreibung vorhanden ist
      SELECT get_pt_free_text_id(_description, pt_locale) INTO description_id;
      IF description_id IS NULL AND _description IS NOT NULL THEN
        RAISE NOTICE 'Kein Eintrag für "%" in localized_character_string vorhanden! Beschreibung wird NULL gesetzt.', _description;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "id" FROM "value_list" WHERE "name" = name_id) IS NULL THEN
        -- Füge neuen Eintrag in value_list ein
        INSERT INTO "value_list" ("name", "description") VALUES (name_id, description_id);
        
      -- falls die Beschreibung im bereits vorhandenen Eintrag NULL ist und im neuen Eintrag nicht, dann übernehme nur die Beschreibung
      ELSIF (SELECT "description" FROM "value_list" WHERE "name" = name_id) IS NULL THEN
        IF _description IS NOT NULL THEN
          UPDATE "value_list" SET "description" = description_id WHERE "name" = name_id;
          RAISE NOTICE 'Die Beschreibung für die Werteliste "%" wurde aktualisiert.', _name;
        END IF;
      END IF;
      
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt einen neuen Wert (value_list_values) in eine Werteliste ein. Die Werte
 * werden bzgl. der angegebenen Lokalisierung gespeichert. Die erste
 * Lokalisierung bezieht sich auf die neuen Werte. Die zweite Lokalisierung
 * bezieht sich auf die Werteliste, in welche die Werte eingefügt werden sollen.
 * Sollte ein Wert in einer Werteliste hinzugefügt werden, der bereits vorhanden
 * ist und dessen Beschreibung NULL ist, so wird die angegebene Beschreibung
 * aktualisiert.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   stable
 * @input   varchar: Name
 *          text: Beschreibung
 *          boolean: Sichtbarkeit
 *          varchar: Werteliste
 *          varchar: Sprachkodierung der Werte - DEFAULT 'deu'
 *          varchar: Landkodierung der Werte - DEFAULT 'DE'
 *          varchar: Zeichenkodierung der Werte - DEFAULT 'UTF8'
 *          varchar: Sprachkodierung der Werteliste - DEFAULT 'deu'
 *          varchar: Landkodierung der Werteliste - DEFAULT 'DE'
 *          varchar: Zeichenkodierung der Werteliste - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_value_list_value(varchar, text, boolean, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8', varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    _name ALIAS FOR $1;
    _description ALIAS FOR $2;
    visibility ALIAS FOR $3;
    value_list ALIAS FOR $4;
    lang ALIAS FOR $5;
    country ALIAS FOR $6;
    char_code ALIAS FOR $7;
    lang_for_vl ALIAS FOR $8;
    country_for_vl ALIAS FOR $9;
    char_code_for_vl ALIAS FOR $10;
    pt_locale uuid;
    pt_locale_for_vl uuid;
    name_id uuid;
    description_id uuid;
    value_list_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;
    
    -- prüfe ob ein passender Eintrag in pt_locale vorhanden ist, sonst mit Fehler beenden
    IF pt_locale IS NULL THEN
      -- prüfe ob der Eintrag keiner Sprache zugeordnet ist
      IF (SELECT get_pt_locale_id(lang, NULL, char_code) INTO pt_locale) IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
      END IF;
    ELSE
      -- Hole die Id für den Namen aus localized_character_string und prüfe ob der Name vorhanden ist, sonst Fehler
      SELECT get_pt_free_text_id(_name, pt_locale) INTO name_id;
      IF name_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden! %', _name, pt_locale;
      END IF;
      
      -- Hole die Id für die Beschreibung aus localized_character_string und prüfe ob die Beschreibung vorhanden ist
      SELECT get_pt_free_text_id(_description, pt_locale) INTO description_id;
      IF description_id IS NULL AND _description IS NOT NULL THEN
        RAISE NOTICE 'Kein Eintrag für "%" in localized_character_string vorhanden! Beschreibung wird NULL gesetzt.', _description;
      END IF;
      
      -- Sprache der Werteliste prüfen
      IF lang_for_vl IS NULL THEN
	-- Hole die Id der Werteliste
        SELECT get_value_list_id(value_list, pt_locale) INTO value_list_id;
      ELSE
        -- Ermittle die pt_locale_id für die Sprachangabe der Werteliste
        SELECT get_pt_locale_id(lang_for_vl, country_for_vl, char_code_for_vl) INTO pt_locale_for_vl;
        -- prüfe ob ein passender Eintrag in pt_locale vorhanden ist, sonst mit Fehler beenden
        IF pt_locale_for_vl IS NOT NULL THEN
	  -- Hole die Id der Werteliste
	  SELECT get_value_list_id(value_list, pt_locale_for_vl) INTO value_list_id;
	ELSE
	  RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang_for_vl, country_for_vl, char_code_for_vl;
	END IF;
      END IF;
      
      -- prüfe ob die Werteliste vorhanden ist, sonst mit Fehler beenden
      IF value_list_id IS NULL THEN
        RAISE EXCEPTION 'Keine Werteliste mit dem Namen "%" vorhanden!', value_list;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "id" FROM "value_list_values" WHERE "name" = name_id AND "belongs_to_value_list" = value_list_id) IS NULL THEN
        -- Füge den Eintrag in value_list_values ein
        INSERT INTO "value_list_values" ("name", "description", "visibility", "belongs_to_value_list") VALUES (name_id, description_id, visibility, value_list_id);
      -- falls die Beschreibung im bereits vorhandenen Eintrag NULL ist und im neuen Eintrag nicht, dann übernehme nur die Beschreibung
      ELSIF (SELECT "description" FROM "value_list_values" WHERE "name" = name_id AND "belongs_to_value_list" = value_list_id) IS NULL THEN
        IF _description IS NOT NULL THEN
          UPDATE "value_list_values" SET "description" = description_id WHERE "name" = name_id;
          RAISE NOTICE 'Die Beschreibung für den WertelistenWert "%" wurde aktualisiert.', _name;
        END IF;
      END IF;
      
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt einen neuen Attributtyp ein. Die Werte werden bzgl. der angegebenen
 * Lokalisierung gespeichert. Die erste Lokalisierung bezieht sich auf den
 * neuen Attributtyp. Die zweite Lokalisierung bezieht sich auf den
 * Wertebereich. Sollte ein Attributtyp hinzugefügt werden, der bereits
 * vorhanden ist und dessen Beschreibung, Einheit oder Wertebereich NULL ist,
 * so wird die angegebene Beschreibung, Einheit oder Wertebereich aktualisiert.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   varchar: Name
 *          text: Beschreibung
 *          varchar: Datentyp (WL_Datentyp)
 *          varchar: Einheit (WL_Einheit)
 *          varchar: Wertebereich (keine statische Werteliste)
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 *          varchar: Sprachkodierung für Wertebereich - DEFAULT NULL
 *          varchar: Landkodierung für Wertebereich - DEFAULT NULL
 *          varchar: Zeichenkodierung für Wertebereich - DEFAULT NULL
 */
CREATE OR REPLACE FUNCTION add_attribute_type(varchar, text, varchar, varchar, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8', varchar DEFAULT NULL, varchar DEFAULT NULL, varchar DEFAULT NULL)
  RETURNS VOID AS $$
  DECLARE
    _name ALIAS FOR $1;
    _description ALIAS FOR $2;
    data_type ALIAS FOR $3;
    unit ALIAS FOR $4;
    domain ALIAS FOR $5;
    lang ALIAS FOR $6;
    country ALIAS FOR $7;
    char_code ALIAS FOR $8;
    lang_domain ALIAS FOR $9;
    country_domain ALIAS FOR $10;
    char_code_domain ALIAS FOR $11;
    pt_locale uuid;
    pt_locale_domain uuid;
    pt_locale_fixed uuid;
    pt_locale_undef uuid;
    name_id uuid;
    description_id uuid;
    data_type_id uuid;
    unit_id uuid;
    domain_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Ermittle die pt_locale_id für sprachneutrale Werte
    SELECT get_pt_locale_id('zxx', NULL, 'UTF8') INTO pt_locale_undef;
    
    -- Ermittle die pt_locale_id für die Sprachangabe des Wertebereiches
    IF lang_domain IS NOT NULL AND char_code_domain IS NOT NULL THEN
      SELECT get_pt_locale_id(lang_domain, country_domain, char_code_domain) INTO pt_locale_domain;
    ELSE
      pt_locale_domain = pt_locale;
    END IF;

    -- Ermittle die pt_locale_id für die Deutsche Sprache (für statische Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;

    -- Fehlermeldung, falls kein passender Eintrag in pt_locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für den Namen aus localized_character_string und prüfe ob der Name vorhanden ist, sonst Fehler
      SELECT get_pt_free_text_id(_name, pt_locale) INTO name_id;
      IF name_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden!', _name;
      END IF;
      
      -- Hole die Id für den Datentyp aus der Werteliste WL_Datentyp und prüfe ob der Datentyp vorhanden ist, sonst Fehler
      SELECT get_value_id_from_value_list(data_type, 'WL_Datentyp') INTO data_type_id;
      IF data_type_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden!', data_type;
      END IF;
      
      -- Hole die Id für die Beschreibung aus localized_character_string und prüfe ob die Beschreibung vorhanden ist
      SELECT get_pt_free_text_id(_description, pt_locale) INTO description_id;
      IF description_id IS NULL AND _description IS NOT NULL THEN
        RAISE NOTICE 'Kein Eintrag für "%" in localized_character_string vorhanden! Beschreibung wird NULL gesetzt.', _description;
        _description = NULL;
      END IF;
      
      -- Hole die Id für die Einheit aus der Werteliste WL_Einheit und prüfe ob die Einheit vorhanden ist
      SELECT get_value_id_from_value_list(unit, 'WL_Einheit') INTO unit_id;
      IF unit_id IS NULL AND unit IS NOT NULL THEN
        RAISE NOTICE 'Kein Eintrag für "%" in localized_character_string vorhanden! Einheit wird NULL gesetzt.', unit;
        unit = NULL;
      END IF;

      -- Hole die Werteliste für den Wertebereich
      SELECT get_value_list_id(domain, pt_locale_domain) INTO domain_id;
      IF domain_id IS NULL AND domain IS NOT NULL THEN
        RAISE NOTICE 'Keine Werteliste mit dem Namen "%" vorhanden!', domain;
      END IF;
      
      -- prüfe ob nicht bereits ein Eintrag mit selben Namen und Datentyp vorhanden ist
      IF (SELECT "id" FROM "attribute_type" WHERE "name" = name_id AND "data_type" = data_type_id) IS NULL THEN
        -- Füge neuen Eintrag in Attributtyp ein
        INSERT INTO "attribute_type" ("name", "description", "data_type", "unit", "domain") VALUES (name_id, description_id, data_type_id, unit_id, domain_id);

      ELSE
        -- falls die Beschreibung im bereits vorhandenen Eintrag NULL ist und im neuen Eintrag nicht, dann übernehme nur die Beschreibung
        IF (SELECT "description" FROM "attribute_type" WHERE "name" = name_id AND "data_type" = data_type_id) IS NULL THEN
          IF _description IS NOT NULL THEN
            UPDATE "attribute_type" SET "description" = description_id WHERE "name" = name_id;
            RAISE NOTICE 'Die Beschreibung für den Attributtyp "%" wurde aktualisiert.', _name;
          END IF;
        END IF;
      
        -- falls die Einheit im bereits vorhandenen Eintrag NULL ist und im neuen Eintrag nicht, dann übernehme nur die Einheit
        IF (SELECT "unit" FROM "attribute_type" WHERE "name" = name_id AND "data_type" = data_type_id) IS NULL THEN
          IF unit IS NOT NULL THEN
            UPDATE "attribute_type" SET "unit" = unit_id WHERE "name" = name_id;
            RAISE NOTICE 'Die Einheit für den Attributtyp "%" wurde aktualisiert.', _name;
          END IF;
        END IF;
      
        -- falls der Wertebereich im bereits vorhandenen Eintrag NULL ist und im neuen Eintrag nicht, dann übernehme nur den Wertebereich
        IF (SELECT "domain" FROM "attribute_type" WHERE "name" = name_id AND "data_type" = data_type_id) IS NULL THEN
          IF domain IS NOT NULL THEN
            UPDATE "attribute_type" SET "domain" = domain_id WHERE "name" = name_id;
            RAISE NOTICE 'Der Wertebereich für den Attributtyp "%" wurde aktualisiert.', _name;
          END IF;
        END IF;
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt ein neues Projekt ein. Die Werte werden bzgl. der angegebenen
 * Lokalisierung gespeichert. Sollte ein Projekt hinzugefügt werden, das
 * bereits vorhanden ist und dessen Beschreibung NULL ist, so wird die
 * angegebene Beschreibung aktualisiert.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   stable
 * @input   varchar: Name
 *          text: Beschreibung
 *          varchar: Teilprojekt von - DEFAULT NULL
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_project(varchar, text, varchar DEFAULT NULL, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    _name ALIAS FOR $1;
    _description ALIAS FOR $2;
    subproject ALIAS FOR $3;
    lang ALIAS FOR $4;
    country ALIAS FOR $5;
    char_code ALIAS FOR $6;
    pt_locale uuid;
    name_id uuid;
    description_id uuid;
    subproject_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Fehlermeldung, falls kein passender Eintrag in pt_locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für den Namen aus localized_character_string und prüfe ob der Name vorhanden ist, sonst Fehler
      SELECT get_pt_free_text_id(_name, pt_locale) INTO name_id;
      IF name_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden!', _name;
      END IF;

      -- Hole die Id für die Beschreibung aus localized_character_string und prüfe ob die Beschreibung vorhanden ist
      SELECT get_pt_free_text_id(_description, pt_locale) INTO description_id;
      IF description_id IS NULL THEN
        RAISE NOTICE 'Kein Eintrag für "%" in localized_character_string vorhanden! Beschreibung wird NULL gesetzt.', _description;
      END IF;

      -- wenn Teilprojekt nicht NULL ist, prüfe ob es in der localized_character_string ist und in Projekt ist
      IF subproject IS NOT NULL THEN
        -- Hole die Id für das Teilprojekt aus localized_character_string und prüfe ob das Teilprojekt vorhanden ist, sonst mit Fehler beenden
        SELECT get_project_id(subproject, pt_locale) INTO subproject_id;
        IF subproject_id IS NULL THEN
	  RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden!', subproject;
        END IF;
        
        -- prüfe ob das Teilprojekt in den Projekten existiert
        IF (SELECT "id" FROM "project" WHERE "id" = subproject_id) IS NULL THEN
	  RAISE EXCEPTION 'Kein Projekt mit dem Namen "%" vorhanden!', subproject;
        END IF;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "id" FROM "project" WHERE "name" = name_id) IS NULL THEN
        -- Füge neuen Eintrag in value_list ein
        INSERT INTO "project" ("name", "description", "subproject_of") VALUES (name_id, description_id, subproject_id);
        
        -- falls die Beschreibung im bereits vorhandenen Eintrag NULL ist und im neuen Eintrag nicht, dann übernehme nur die Beschreibung
        ELSIF (SELECT "description" FROM "project" WHERE "name" = name_id) IS NULL THEN
        IF _description IS NOT NULL THEN
          UPDATE "project" SET "description" = description_id WHERE "name" = name_id;
          RAISE NOTICE 'Die Beschreibung für das Projekt "%" wurde aktualisiert.', _name;
        END IF;
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt einen neuen Beziehungstyp ein. Die Werte werden bzgl. der angegebenen
 * Lokalisierung gespeichert.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   varchar: Referenz auf (WL_Thema)
 *          text: Beschreibung (WL_Beziehungstyp)
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_relationship_type(varchar, text, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    reference_to ALIAS FOR $1;
    _description ALIAS FOR $2;
    lang ALIAS FOR $3;
    country ALIAS FOR $4;
    char_code ALIAS FOR $5;
    pt_locale uuid;
    pt_locale_fixed uuid;
    reference_id uuid;
    description_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;
  
    -- Ermittle die pt_locale_id für die Deutsche Sprache (für festen Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;

    -- Fehlermeldung, falls kein passender Eintrag in PT_Locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in PT_Locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für das Referenz Thema aus der Werteliste WL_Thema, sonst Fehler
      SELECT get_value_id_from_value_list(reference_to, 'WL_Thema') INTO reference_id;
      IF reference_id IS NULL THEN
        RAISE EXCEPTION 'Die Werteliste "WL_Thema" enthält kein Thema mit dem Namen "%"', reference_to;
      END IF;

      -- Hole die Id für den Beziehungstyp (Beschreibung) aus der Werteliste WL_Beziehungstyp, sonst Fehler
      SELECT get_value_id_from_value_list(_description, 'WL_Beziehungstyp') INTO description_id;
      IF reference_id IS NULL THEN
        RAISE EXCEPTION 'Die Werteliste "WL_Beziehungstyp" enthält keinen Eintrag mit dem Namen "%"', _description;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "id" FROM "relationship_type" WHERE "reference_to" = reference_id AND "description" = description_id) IS NULL THEN
        -- Füge neuen Eintrag in WL_Werteliste ein
        INSERT INTO "relationship_type" ("reference_to", "description") VALUES (reference_id, description_id);
      END IF;
      
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Beziehung zwischen Wertelistenwerten
 * (value_list_values_x_value_list_values) ein. Die angegebene Lokalisierung
 * bezieht sich auf die Namen der Wertelistenwerte und die Beziehungsart.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   varchar: erster Wertelistenwert
 *          varchar: zweiter Wertelistenwert
 *          varchar: Beziehungsart
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_value_list_value_relation(varchar, varchar, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    value_list_values_1 ALIAS FOR $1;
    value_list_values_2 ALIAS FOR $2;
    relationship ALIAS FOR $3;
    lang ALIAS FOR $4;
    country ALIAS FOR $5;
    char_code ALIAS FOR $6;
    pt_locale uuid;
    pt_locale_fixed uuid;
    value_list_values_1_id uuid;
    value_list_values_2_id uuid;
    relationship_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Ermittle die pt_locale_id für die Deutsche Sprache (für festen Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;
    
    -- Fehlermeldung, falls kein passender Eintrag in pt_locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für value_list_values_1, sonst Fehler
      SELECT get_value_id(value_list_values_1, pt_locale) INTO value_list_values_1_id;
      IF value_list_values_1_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in value_list_values vorhanden !', value_list_values_1;
      END IF;
      
      -- Hole die Id für value_list_values_2, sonst Fehler
      SELECT get_value_id(value_list_values_2, pt_locale) INTO value_list_values_2_id;
      IF value_list_values_2_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in value_list_values vorhanden !', value_list_values_2;
      END IF;

      -- Hole die Id für den Beziehungstyp aus der Werteliste WL_Beziehungstyp, sonst Fehler
      SELECT get_value_id_from_value_list(relationship, 'WL_Beziehungstyp') INTO relationship_id;
      IF relationship_id IS NULL THEN
        RAISE EXCEPTION 'Die Werteliste "WL_Beziehungstyp" enthält keinen Eintrag mit dem Namen "%"', relationship;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "value_list_values_1" FROM "value_list_values_x_value_list_values" WHERE "value_list_values_1" = value_list_values_1_id AND "value_list_values_2" = value_list_values_2_id AND "relationship" = relationship_id) IS NULL THEN
        -- Füge neuen Eintrag in value_list_values_x_value_list_values ein
        INSERT INTO "value_list_values_x_value_list_values" ("value_list_values_1", "value_list_values_2", "relationship") VALUES (value_list_values_1_id, value_list_values_2_id, relationship_id);
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Themenausprägung ein. Die Werte werden bzgl. der angegebenen
 * Lokalisierung gespeichert.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   text: Beschreibung
 *          varchar: Thema (WL_Thema)
 *          varchar: Projekt
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_topic_characteristic(text, varchar, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    _description ALIAS FOR $1;
    topic ALIAS FOR $2;
    project ALIAS FOR $3;
    lang ALIAS FOR $4;
    country ALIAS FOR $5;
    char_code ALIAS FOR $6;
    pt_locale uuid;
    pt_locale_fixed uuid;
    description_id uuid;
    topic_id uuid;
    project_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Ermittle die pt_locale_id für die Deutsche Sprache (für festen Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;
    
    -- Fehlermeldung, falls kein passender Eintrag in pt_locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für die Beschreibung aus localized_character_string und prüfe ob die Beschreibung vorhanden ist, sonst Fehler
      SELECT get_pt_free_text_id(_description, pt_locale) INTO description_id;
      IF description_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in localized_character_string vorhanden!', _description;
      END IF;
      
      -- Hole die Id für das Thema aus der Werteliste WL_Thema, sonst Fehler
      SELECT get_value_id_from_value_list(topic, 'WL_Thema') INTO topic_id;
      IF topic_id IS NULL THEN
        RAISE EXCEPTION 'Die Werteliste "WL_Thema" enthält kein Thema mit dem Namen "%"', topic;
      END IF;
      
      -- prüfe ob ein Projekt für mit dem übergebenen Projektnamen existiert, sonst Fehler
      SELECT "id" INTO project_id  FROM "project" WHERE "name" = get_pt_free_text_id(project, pt_locale);
      IF project_id IS NULL THEN
	RAISE EXCEPTION 'Kein Projekt mit dem Namen "%" vorhanden!', project;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "id" FROM "topic_characteristic" WHERE "description" = description_id AND "topic" = topic_id AND "project_id" = project_id) IS NULL THEN
        -- Füge neuen Eintrag in Themenauspraegung ein
        INSERT INTO "topic_characteristic" ("description", "topic", "project_id") VALUES (description_id, topic_id, project_id);
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Themeninstanz ein. Die zugehörige Themenausprägung wird durch
 * die konkrete Angabe einer Id für eine Themenausprägung identifiziert.
 * Zusätzlich wird die Id der erzeugten Themeninstanz zurück geliefert.
 *
 * @state   stable
 * @input   uuid: Id der Themenausprägung
 * @output  uuid: Id der erzeugten Themeninstanz
 */
CREATE OR REPLACE FUNCTION add_topic_instance(uuid)
  RETURNS uuid AS $$
  DECLARE
    topic_characteristic_id ALIAS FOR $1;
    id uuid;
  BEGIN
    -- prüfe ob die angegebene Id zur Themenausprägung existiert
    IF (SELECT "id" FROM "topic_characteristic" WHERE "id" = topic_characteristic_id) IS NULL THEN
      RAISE EXCEPTION 'Keine Themenausprägung mit der Id "%" vorhanden!', topic_characteristic_id;
    ELSE
      id := create_uuid();
      -- Füge neuen Eintrag in Themeninstanz ein
      INSERT INTO "topic_instance" ("id", "topic_characteristic_id") VALUES (id, topic_characteristic_id);
    END IF;
    RETURN id;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt einen neue Attributwert ein. Die Werte werden bzgl. der angegebenen
 * Lokalisierung gespeichert. Der zugehörige Attributtyp und Themeninstanz
 * werden durch eine konkrete Id angegeben.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   highly experimental (absolut ungetestet)
 * @input   uuid: Id des Attributtyps
 *          uuid: Id der Themeninstanz
 *          varchar: Wert - DEFAULT NULL
 *          varchar: Wertebereich (keine statische Werteliste) - DEFAULT NULL
 *          geometry: 2D Geometrie - DEFAULT NULL
 *          geometry: 3D Geometrie - DEFAULT NULL
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */

CREATE OR REPLACE FUNCTION add_attribute_value_value(uuid, uuid, varchar DEFAULT NULL, varchar DEFAULT NULL, geometry(geometry, 4326) DEFAULT NULL, geometry(geometry, 4326) DEFAULT NULL, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    attribute_type_id ALIAS FOR $1;
    topic_instance_id ALIAS FOR $2;
    value ALIAS FOR $3;
    domain ALIAS FOR $4;
    geom ALIAS FOR $5;
    geomz ALIAS FOR $6;
    lang ALIAS FOR $7;
    country ALIAS FOR $8;
    char_code ALIAS FOR $9;
    pt_locale uuid;
    domain_id uuid;
    geom_id uuid;
    value_id uuid;
    insert_choice varchar;
    value_choice uuid;
    exists uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in PT_Locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Prüfe ob ein Attributtyp mit der angegebenen Id existiert
      IF (SELECT "id" FROM "attribute_type" WHERE "id" = attribute_type_id) IS NULL THEN
        RAISE EXCEPTION 'Kein Attributtyp mit der Id "%" gefunden!', attribute_type_id;
      END IF;

      -- Prüfe ob eine Themeninstanz mit der angegebenen Id existiert
      IF (SELECT "id" FROM "topic_instance" WHERE "id" = topic_instance_id) IS NULL THEN
        RAISE EXCEPTION 'Keine Themeninstanz mit der Id "%" gefunden!', topic_instance_id;
      END IF;

      -- trage einen Attributwert mit einem Wertebereich ein
      IF (domain IS NOT NULL AND value IS NULL AND geom IS NULL AND geomz IS NULL) THEN
        -- Prüfe ob der angegebene Wertebereich vorhanden ist
        SELECT get_value_id(domain, pt_locale) INTO domain_id;
        IF domain_id IS NULL THEN
          RAISE NOTICE 'Der Wertebereich "%" ist als nicht als Wert in einer Werteliste vorhanden!', domain;
        END IF;
        -- Prüfe ob der Wert aus dem Wertebereich des angegebenen Attributtyps stammt
        IF (SELECT "at"."id" FROM "attribute_type" "at", "value_list_values" "wlww", "value_list" "wlw"
             WHERE "at"."domain" = "wlw"."id" AND "wlww"."belongs_to_value_list" = "wlw"."id" AND
                   "wlww"."name" = get_pt_free_text_id(domain, pt_locale) AND "at"."id" = attribute_type_id) IS NULL THEN
          RAISE EXCEPTION 'Der Wert "%" des Wertebereiches passt nicht zum Wertebereich des Attributtyps!', domain;
        END IF;
        insert_choice = 'domain';
        value_choice = domain;
      
      -- trage einen Attributwert mit einem Wert ein
      ELSIF (domain IS NULL AND value IS NOT NULL AND geom IS NULL AND geomz IS NULL) THEN
        -- Prüfe ob der angegebene Wert vorhanden ist
        SELECT get_PTFreeTextId(value, pt_locale) INTO value_id;
        IF value_id IS NULL THEN
          RAISE NOTICE 'Der Wert "%" ist nicht in localized_character_string verfügbar!', value;
        END IF;
        insert_choice = 'value';
        value_choice = value;
      
      -- trage einen Attributwert mit einer 2D Geometrie ein
      ELSIF (domain IS NULL AND value IS NULL AND geom IS NOT NULL AND geomz IS NULL) THEN
        -- Prüfe ob die angegebene Geometrie vorhanden ist
        SELECT get_geom_id(geom) INTO geom_id;
        IF geom_id IS NULL THEN
          RAISE NOTICE 'Die 2D Geometrie mit dem Wert "%" ist nicht vorhanden!', geom;
        END IF;
        insert_choice = 'geom';
        value_choice = geom;
      
      -- trage einen Attributwert mit einer 3D Geometrie ein
      ELSIF (domain IS NULL AND value IS NULL AND geom IS NULL AND geomz IS NOT NULL) THEN
        -- Prüfe ob die angegebene Geometrie vorhanden ist
        SELECT get_geom_id(geom) INTO geom_id;
        IF geom_id IS NULL THEN
          RAISE NOTICE 'Die 3D Geometrie mit dem Wert "%" ist nicht vorhanden!', geom;
        END IF;
      END IF;
      insert_choice = 'geomz';
      value_choice = geomz;
        
      -- Prüfe ob ein entsprechender Eintrag nicht bereits vorhanden ist
      -- TODO: es muss noch eine Ausnahmereglung geschaffen werden, damit bei der Tabelle attribute_value_geomz auch die Spalte geom und nicht geomz angesprochen wird (eventuell gibt es dafür noch eine kleine Änderung am Schema)
      EXECUTE 'SELECT "id" FROM "attribute_value_' || insert_choice || '" WHERE "' || insert_choice || '" = "attribute_type_id" = ' || attribute_type_id || ' AND "topic_instance_id" = ' || topic_instance_id || ' AND "' || insert_choice || '" = ' || value_choice || ';' INTO exists;
      
      IF (exists) IS NULL THEN
        -- Füge neuen Eintrag in Attributwert ein
        --EXECUTE 'INSERT INTO "attribute_value_' || insert_choice || '" ("attribute_type_id", "topic_instance_id", "' || insert_choice || '") VALUES (' || attribute_type_id ||',' || topic_instance_id || ','  ');';
        --RAISE NOTICE 'DEBUG';
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Beziehung zwischen Wertelisten (value_list_x_value_list)
 * ein. Die angegebene Lokalisierung bezieht sich auf die Namen der Wertelisten
 * und die Beziehungsart.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   varchar: erste Werteliste
 *          varchar: zweite Werteliste
 *          varchar: Beziehungsart
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_value_list_relation(varchar, varchar, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    value_list_1 ALIAS FOR $1;
    value_list_2 ALIAS FOR $2;
    relationship ALIAS FOR $3;
    lang ALIAS FOR $4;
    country ALIAS FOR $5;
    char_code ALIAS FOR $6;
    pt_locale uuid;
    pt_locale_fixed uuid;
    value_list_1_id uuid;
    value_list_2_id uuid;
    relationship_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Ermittle die pt_locale_id für die Deutsche Sprache (für festen Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;
    
    -- Fehlermeldung, falls kein passender Eintrag in pt_locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für value_list_1, sonst Fehler
      SELECT get_value_listId(value_list_1, pt_locale) INTO value_list_1_id;
      IF value_list_1_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in value_list vorhanden !', value_list_1;
      END IF;
      
      -- Hole die Id für value_list_2, sonst Fehler
      SELECT get_value_id(value_list_2, pt_locale) INTO value_list_2_id;
      IF value_list_2_id IS NULL THEN
        RAISE EXCEPTION 'Kein Eintrag für "%" in value_list vorhanden !', value_list_2;
      END IF;

      -- Hole die Id für den Beziehungstyp aus der Werteliste WL_Beziehungstyp, sonst Fehler
      SELECT get_value_id_from_value_list(relationship, 'WL_Beziehungstyp') INTO relationship_id;
      IF relationship_id IS NULL THEN
        RAISE EXCEPTION 'Die Werteliste "WL_Beziehungstyp" enthält keinen Eintrag mit dem Namen "%"', relationship;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "value_list_1" FROM "value_list_x_value_list" WHERE "value_list_1" = value_list_1_id AND "value_list_2" = value_list_2_id AND "relationship" = relationship_id) IS NULL THEN
        -- Füge neuen Eintrag in value_list_x_value_list ein
        INSERT INTO "value_list_x_value_list" ("value_list_1", "value_list_2", "relationship") VALUES (value_list_1_id, value_list_2_id, relationship_id);
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Beziehung zwischen Themeninstanzen
 * (Themeninstanz_x_Themeninstanz) ein. Die angegebene Lokalisierung bezieht
 * sich auf die Beziehungsart.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   uuid: Id der ersten Themeninstanz
 *          uuid: Id der zweiten Themeninstanz
 *          varchar: Beziehungsart
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_topic_instance_x_topic_instance(uuid, uuid, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    topic_instance_1_id ALIAS FOR $1;
    topic_instance_2_id ALIAS FOR $2;
    relationship ALIAS FOR $3;
    lang ALIAS FOR $4;
    country ALIAS FOR $5;
    char_code ALIAS FOR $6;
    pt_locale uuid;
    pt_locale_fixed uuid;
    relationship_id uuid;
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;

    -- Ermittle die pt_locale_id für die Deutsche Sprache (für festen Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;
    
    -- Fehlermeldung, falls kein passender Eintrag in PT_Locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in PT_Locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Prüfe ob die Themeninstanz1 existiert, sonst Fehler
      IF (SELECT "id" FROM "topic_instance" WHERE "id" = topic_instance_1_id ) IS NULL THEN
        RAISE EXCEPTION 'Keine Themeninstanz mit der Id "%" vorhanden !', topic_instance_1_id;
      END IF;
      
      -- Prüfe ob die Themeninstanz2 existiert, sonst Fehler
      IF (SELECT "id" FROM "topic_instance" WHERE "id" = topic_instance_2_id ) IS NULL THEN
        RAISE EXCEPTION 'Keine Themeninstanz mit der Id "%" vorhanden !', topic_instance_2_id;
      END IF;
      
      -- Hole die Id für den Beziehungstyp aus der Werteliste WL_Beziehungstyp, sonst Fehler
      SELECT get_value_id_from_value_list(relationship, 'WL_Beziehungstyp') INTO relationship_id;
      IF relationship_id IS NULL THEN
        RAISE EXCEPTION 'Die Werteliste "WL_Beziehungstyp" enthält keinen Eintrag mit dem Namen "%"', relationship;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      IF (SELECT "topic_instance_1" FROM "topic_instance_x_topic_instance" WHERE "topic_instance_1" = topic_instance_1_id AND "topic_instance_2" = topic_instance_2_id AND "relationship" = relationship_id) IS NULL THEN
        -- Füge neuen Eintrag in topic_instance_x_topic_instance ein
        INSERT INTO "topic_instance_x_topic_instance" ("topic_instance_1", "topic_instance_2", "relationship") VALUES (topic_instance_1_id, topic_instance_2_id, relationship_id);
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';
  

/*
 * Fügt eine neue Verknüpfung zwischen Attributtypen und Themenausprägungen ein.
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen,
 *          Prüfung auf Standardwert fehlt)
 * @input   uuid: Id der Themenausprägung
 *          uuid: Id des Attributtypen
 *          uuid: Id der Multiplizität
 *          uuid: Id des Standardwertes - DEFAULT NULL
 */
CREATE OR REPLACE FUNCTION add_attribute_type_to_topic_characteristic(uuid, uuid, uuid, uuid DEFAULT NULL)
  RETURNS VOID AS $$
  DECLARE
    topic_characteristic_id ALIAS FOR $1;
    attribute_type_id ALIAS FOR $2;
    multiplicity_id ALIAS FOR $3;
    default_value_id ALIAS FOR $4;
  BEGIN
    -- Prüfe ob eine Themenauspraegung mit der entsprechenden Id vorhanden ist
    IF (SELECT "id" FROM "topic_characteristic" WHERE "id" = topic_characteristic_id) IS NULL THEN
      RAISE EXCEPTION 'Keine Themenausprägung mit der Id "%" vorhanden!', topic_characteristic_id;
    END IF;
    
    -- Prüfe ob ein Attributtyp mit der entsprechenden Id vorhanden ist
    IF (SELECT "id" FROM "attribute_type" WHERE "id" = attribute_type_id) IS NULL THEN
      RAISE EXCEPTION 'Kein Attributtyp mit der Id "%" vorhanden!', attribute_type_id;
    END IF;
    
   -- Prüfe ob eine Multiplizität mit der entsprechenden Id vorhanden ist
    IF (SELECT "id" FROM "multiplicity" WHERE "id" = multiplicity_id) IS NULL THEN
      RAISE EXCEPTION 'Keine Multiplizität mit der Id "%" vorhanden!', multiplicity_id;
    END IF;
    
    -- Prüfe ob für den Standardwert ein Wertebereich des zugehörigen Attributtyps existiert und dieser zur selben Werteliste gehört
    -- TODO
    
    -- prüfe ob der Eintrag nicht bereits vorhanden ist
    IF (SELECT "topic_characteristic_id" FROM "attribute_type_to_topic_characteristic" WHERE "attribute_type_id" = attribute_type_id AND "topic_characteristic_id" = topic_characteristic_id AND "multiplicity" = multiplicity_id) IS NULL THEN
      -- Füge neuen Eintrag in attribute_type_to_topic_characteristic ein
      INSERT INTO "attribute_type_to_topic_characteristic" ("attribute_type_id", "topic_characteristic_id", "multiplicity", "default_value") VALUES (attribute_type_id, topic_characteristic_id, multiplicity_id, default_value_id);
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Multiplizität ein. Enthält teilweise Kontrolle von
 * Integritätsbedinungen.
 *
 * @state   stable
 * @input   integer: minimaler Wert
 *          integer: maximaler Wert - DEFAULT NULL
 */
CREATE OR REPLACE FUNCTION add_multiplicity(integer, integer DEFAULT NULL)
  RETURNS VOID AS $$
  DECLARE
    min_value ALIAS FOR $1;
    max_value ALIAS FOR $2;
    sql_max_part text;
    exists uuid;
  BEGIN
    -- erzeugt Teil der "vorhandensein-Abfrage" falls der Max-Wert NULL ist
    sql_max_part := 'IS NULL';
    
    -- prüfe ob min_value nicht NULL ist
    IF (min_value IS NULL) THEN
      RAISE EXCEPTION 'Der Min-Wert darf nicht NULL sein!';
    END IF;
    
    -- prüfe ob max_value NULL ist
    IF (max_value IS NOT NULL) THEN
      -- erzeugt Teil der "vorhandensein-Abfrage" falls max_value nicht NULL ist
      sql_max_part := '= ' || max_value;
      
      -- prüfe ob max_value größer / gleich min_value ist
      IF (min_value > max_value) THEN
        RAISE EXCEPTION 'Der Max-Wert muss größer / gleich dem Min-Wert sein!';
      END IF;
    END IF;
    
    -- prüfe ob der Eintrag nicht bereits vorhanden ist
    EXECUTE 'SELECT "id" FROM "multiplicity" WHERE "min_value" = ' || min_value || ' AND "max_value" ' || sql_max_part || ';' INTO exists;
    IF (exists) IS NULL THEN
      -- Füge neuen Eintrag in Multiplizitaet ein
      INSERT INTO "multiplicity" ("min_value", "max_value") VALUES (min_value, max_value);
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt einen neuen Beziehungstyp ein. Die angegebene Lokalisierung bezieht
 * sich auf die Beschreibung und das Thema.
 *
 * Alle verwendeten Zeichenketten müssen in localized_character_string vorhanden
 * sein!
 *
 * @state   experimental (feste Angabe von Wertelisten und Lokalisierungen)
 * @input   varchar: Beschreibung
 *          varchar: Name des referenzierten Themas
 *          varchar: Sprachkodierung - DEFAULT 'deu'
 *          varchar: Landkodierung - DEFAULT 'DE'
 *          varchar: Zeichenkodierung - DEFAULT 'UTF8'
 */
CREATE OR REPLACE FUNCTION add_relationship_type(varchar, varchar, varchar DEFAULT 'deu', varchar DEFAULT 'DE', varchar DEFAULT 'UTF8')
  RETURNS VOID AS $$
  DECLARE
    _description ALIAS FOR $1;
    ref_topic ALIAS FOR $2;
    lang ALIAS FOR $3;
    country ALIAS FOR $4;
    char_code ALIAS FOR $5;
    pt_locale uuid;
    pt_locale_fixed uuid;
    exists uuid;
    ref_topic_id uuid;
    description_id uuid;
    
  BEGIN
    -- Ermittle die pt_locale_id für die Sprachangabe
    SELECT get_pt_locale_id(lang, country, char_code) INTO pt_locale;
    
    -- Ermittle die pt_locale_id für die Deutsche Sprache (für feste Wertelisten; WL_...)
    SELECT get_pt_locale_id('deu', 'DE', 'UTF8') INTO pt_locale_fixed;
    
    -- Fehlermeldung, falls kein passender Eintrag in pt_locale gefunden wurde
    IF pt_locale IS NULL THEN
      RAISE EXCEPTION 'Kein Eintrag in pt_locale für (%, %, %) vorhanden!', lang, country, char_code;
    ELSE
      -- Hole die Id für die Beschreibung aus WL_Beziehungstyp und prüfe ob die Beschreibung vorhanden ist, sonst Fehler
      SELECT get_value_id_from_value_list(_description, 'WL_Beziehungstyp') INTO description_id;
      IF description_id IS NULL THEN
        RAISE EXCEPTION 'Kein Beziehungstyp mit dem Namen "%" vorhanden!', _description;
      END IF;
      
      -- prüfe ob das Thema vorhanden ist
      SELECT get_value_id_from_value_list(ref_topic, 'WL_Thema') INTO ref_topic_id;
      IF ref_topic_id IS NULL THEN
        RAISE EXCEPTION 'Kein Thema mit dem Namen "%" vorhanden!', ref_topic;
      END IF;
      
      -- prüfe ob der Eintrag nicht bereits vorhanden ist
      EXECUTE 'SELECT "id" FROM "relationship_type" WHERE "reference_to" = ' || quote_literal(ref_topic_id) || ' AND "description" = ' || quote_literal(description_id) || ';' INTO exists;
      IF (exists) IS NULL THEN
        -- Füge neuen Eintrag in Beziehungstyp ein
        INSERT INTO "relationship_type" ("reference_to", "description") VALUES (ref_topic_id, description_id);
      END IF;
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Fügt eine neue Verknüpfung zwischen Beziehungstypen und Themenausprägungen
 * ein.
 *
 * @state   stable
 * @input   uuid: Id der Themenausprägung
 *          uuid: Id des Beziehungstyps
 *          uuid: Id der Multiplizität
 */
CREATE OR REPLACE FUNCTION add_relationship_type_to_topic_characteristic(uuid, uuid, uuid)
  RETURNS VOID AS $$
  DECLARE
    topic_characteristic_id ALIAS FOR $1;
    relationship_id ALIAS FOR $2;
    multiplicity_id ALIAS FOR $3;
  BEGIN
    -- Prüfe ob eine Themenauspraegung mit der entsprechenden Id vorhanden ist
    IF (SELECT "id" FROM "topic_characteristic" WHERE "id" = topic_characteristic_id) IS NULL THEN
      RAISE EXCEPTION 'Keine Themenausprägung mit der Id "%" vorhanden!', topic_characteristic_id;
    END IF;
    
    -- Prüfe ob ein Beziehungstyp mit der entsprechenden Id vorhanden ist
    IF (SELECT "id" FROM "relationship_type" WHERE "id" = relationship_id) IS NULL THEN
      RAISE EXCEPTION 'Kein Beziehungstyp mit der Id "%" vorhanden!', relationship_id;
    END IF;
      
   -- Prüfe ob eine Multiplizität mit der entsprechenden Id vorhanden ist
    IF (SELECT "id" FROM "multiplicity" WHERE "id" = multiplicity_id) IS NULL THEN
      RAISE EXCEPTION 'Keine Multiplizität mit der Id "%" vorhanden!', multiplicity_id;
    END IF;
    
    -- prüfe ob der Eintrag nicht bereits vorhanden ist
    IF (SELECT "topic_characteristic_id" FROM "relationship_type_to_topic_characteristic" WHERE "relationship_type_id" = relationship_id AND "topic_characteristic_id" = topic_characteristic_id AND "multiplicity" = multiplicity_id) IS NULL THEN
      -- Füge neuen Eintrag in relationship_type_to_topic_characteristic ein
      INSERT INTO "relationship_type_to_topic_characteristic" ("relationship_type_id", "topic_characteristic_id", "multiplicity") VALUES (relationship_id, topic_characteristic_id, multiplicity_id);
    END IF;
  END;
  $$ LANGUAGE 'plpgsql';
  
  
/*
 * Uses the extension dblink to connect to another database. From this database
 * the whole content of the table localized_character_string will be copied to
 * a temporary table.
 *
 * @return boolean - false if an error occurred otherwise true
 */
CREATE OR REPLACE FUNCTION create_temp_lcs_table()
RETURNS boolean AS $$
  DECLARE
    remove_dblink boolean;
    error text;
  BEGIN

    remove_dblink := false;

    -- create dblink extension if necessary 
    IF (SELECT extname FROM pg_extension WHERE extname = 'dblink') IS NULL THEN
      CREATE EXTENSION dblink;
      -- set flag for removing dblink extension
      remove_dblink := true;
    END IF;

    -- create unnamed connection
    PERFORM dblink_connect('hostaddr=127.0.0.1 port=5432 dbname=openinfra-system user=postgres password=postgres');

    INSERT INTO pdb_baalbek.localized_character_string SELECT * FROM dblink('SELECT pt_free_text_id, pt_locale_id, free_text
                     FROM sytem.localized_character_string
                    ') AS t1 (id uuid, locale uuid, text text);

    -- end unnamed connection
    PERFORM dblink_disconnect();

    -- remove dblink extension in necessary
    IF (remove_dblink = true) THEN
      DROP EXTENSION IF EXISTS dblink;
    END IF;

    -- exception handling
    EXCEPTION
      WHEN unique_violation THEN
        -- get error message from stack
        GET STACKED DIAGNOSTICS error = PG_EXCEPTION_DETAIL;
        -- write error message to console
        RAISE NOTICE '%', error;
        -- return with failure
        return false;

    -- no error occurred
    return true;
END;
$$ LANGUAGE plpgsql;