/*
 * changelog from 29.05.2015
 * - constraint 63 added
 *
 * changelog from 11.05.2015
 * - constraints 59, 60, 61 and 62 in update functions extended by operation
 *   parameter
 *
 * changelog from 06.05.2015
 * - constraint changes in attribute_type_group_to_topic_characteristic and
 *   attribute_type_to_attribute_type_group
 *
 * Änderungen vom 16.04.2015
 * - Constraint 59, 60, 61 und 62 Prüfungen hinzugefügt
 *
 * Änderungen vom 14.04.2015
 * - Fehlerbehebung bei Variablendefinition in check_attribute_value_value_u und
 *   check_attribute_value_domain_u
 *
 * Änderungen vom 31.03.2015
 * - komplette Überarbeitung der Aufteilung der Integritätsbedingungen
 *
 * Änderungen vom 18.03.2015
 * - Fehlerbehebung beim Aufruf von Funktion check
 * - Anpassung von Constraint 54 und 12 (noch nicht final)
 *
 * Änderungen vom 17.03.2015
 * - Fehlerbehebung in Constraint 46, wodurch DELETE beachtet wird
 *
 * Änderungen vom 16.03.2015
 * - Fehlerbehebung bei Constraint 37
 * - Prüfungsabfolge von Constraint 37 und 36 getauscht, somit wird 36
 *   überhaupt erreicht
 *
 * Änderungen vom 26.02.2015
 * - Lokalisierung von ISO 639-2 auf ISO 639-1 geändert und get_pt_locale_id mit
 *   Default-Werten versehen ('en', 'GB', 'UTF8'), so dass dies an zentraler
 *   Stelle geändert werden kann
 * - Integritätsbedingung 52, 53, 54, 55, 56 hinzugefügt
 * - Fehlerbehebung, Skript ist nun Ausführbar, aber nicht getestet, FEHLER
 *   sind SEHR WAHRSCHEINLICH!
 *
 * Änderungen vom 25.02.2015
 * - unzählbar viele Änderungen bzgl. Anpassung des Datenbankschemas
 *
 * Änderungen vom 16.02.2015
 * - Überarbeitung vieler Integritätsbedingungen bzgl. Anpassung des
 *   Datenbankschemas
 *
 * Änderungen vom 27.01.2015
 * - Fehlerbehebung
 *
 * Änderungen vom 26.01.2015
 * - Projekt- und System-Constraints in einem Skript zusammengefasst
 *
 * Änderungen vom 22.01.2015
 * - Überarbeitung sämtlicher Funktionen, hinzufügen von zusätzlichem Parameter
 *   für das Schema, Anpassung auf 80 Zeichen
 *
 * Änderungen vom 25.11.2014
 * - Sicherheitsprüfung in Constraint 48 und 49 angepasst, so dass die neuen und
 *   alten Werte von domain und unit verglichen werden
 *
 * Änderungen vom 24.11.2014
 * - zusätzliche Sicherheitsprüfung in Constraint 48 & 49
 *
 * Änderungen vom 14.11.2014
 * - Constraint 48 und 49 prüfen in check_attribute_type nun nur bei UPDATE
 *
 * Änderungen vom 13.11.2014
 * - Prüfung auf Constraint 48 und 49 in check_attribute_type hinzugefügt
 *
 * Änderungen vom 06.11.2014
 * - Abfangen von foreign_key_violation in update_pt_free_text
 *
 * Änderungen vom 03.11.2014
 * - Überarbeitung der Funktion check_project
 *
 * Änderungen vom: 29.10.2014
 * - Löschoperationen in check_multiplicity_for_attribute_value werden nicht
 *   mehr beachtet, da dies das Löschen von Themeninstanzen verhinderte
 *
 * Änderungen vom 21.10.2014
 * - Fehlerbehebung in der Funktion check_attribute_value_value,
 *   check_attribute_value_domain, check_attribute_value_geom und
 *   check_attribute_value_geomz
 *
 * Änderungen vom 10.10.2014
 * - Überarbeitung der Funtkion check_multiplicity_for_attribute_value
 * - Trigger für localized_character_string, so das Eintrag in pt_free_text
 *   automatisch synchron gehalten wird, UPDATE der pt_free_text_id in
 *   localized_character_string wird vollständig blockiert
 *
 * Änderungen vom 08.10.2014
 * - Trigger für neue Integritätsbedingung 46 hinzugefügt
 * - Bedingungskorrektur in check_attribute_type_x_attribute_type,
 *   check_value_list_x_value_list und
 *   check_value_list_values_x_value_list_values
 *
 * Änderungen vom 25.09.2014
 * - neue Funktion check_multiplicity_for_attribute_value eingefügt, die beim
 *   Einfügen in attribute_value_value, ..._domain, ..._geom und ..._geomz
 *   prüft
 * - Überarbeitung der Funktion check_topic_instance_x_topic_instance,
 *   Beachtung von Kardinalitäten beim löschen von Verknüpfungen
 *
 * Änderungen vom 24.09.2014
 * - SELECT in Kontrollfunktion check_topic_instance_x_topic_instance auf 1
 *   limitiert
 * - Kontrolle des Datentyps in Funktion compare_data_types für URL angepasst
 * - Ausgabe von Fehler Constraint 32 war nicht möglich, wurde mit Constraint
 *   31 verbunden
 *
 * Änderungen vom 23.09.2014
 * - Fehlerbehebung bei Variablennamen in Funktion check_attribute_value_geomz
 *
 * Änderungen vom 19.09.2014
 * - Funktion compare_data_types zur Prüfung des Datentyps URL erweitert
 *
 * Änderungen vom 13.08.2014
 * - Funktion free_text_in_use beachtet nun auch das mehrfache vorkommen einer
 *   UUID in derselben Spalte einer Tabelle
 *
 * Änderungen vom 29.07.2014
 * - zusätzliche Sicherheitsprüfung in check_loop eingefügt
 *
 * Änderungen vom 25.07.2014
 * - Fehlerbehebung in Funktion free_text_in_use
 *
 * Änderungen vom 23.07.2014
 * - Funktionen get_column_from_fk(text, text) und free_text_in_use(uuid) zur
 *   Erkennung von Mehrfachverwendung von pt_free_text_id hinzugefügt
 *
 * Änderungen vom 22.07.2014
 * - Fehlerbehebung in Constraint 35, sollte nun ordnungsgemäß funktionieren
 * - RAISE NOTICE zu RAISE EXCEPTION geändert
 *
 * Änderungen vom 18.07.2014
 * - alle Funktionsvariablen beginnen nun mit _
 * - Vereinheitlichung von Variablennamen in Join Tabellen die SKOS Beziehungen
 *   verwenden (value_list_x_value_list, value_list_values_x_value_list_values)
 *
 * Änderungen vom 15.07.2014
 *  - Fehlerbehebung in Constraint 12 (DELETE Trigger wurde bei UPDATE
 *    Operationen ausgelöst)
 *  - Nutzung falscher Werte in Constraint 35 (attribute_value_domain)
 *  - Hinzufügen eines Changelogs für Integritätsbedingungen
 *
 * Änderung vom 01.06.2015
 * - quote_ident Schemanamen in SET SEARCH PATH Operationen
 */


-- set search path to created constraints schema
SET search_path TO "constraints", public;
SET CLIENT_ENCODING TO "UTF8";



/******************************************************************************/
/******************************* attribute_type *******************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table attribute_type.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new name_id
 *          uuid: new data_type_id
 *          uuid: new unit_id
 *          uuid: new domain_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_i(varchar, uuid, uuid, uuid,
                                                  uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_name_id ALIAS FOR $2;
    _new_data_type_id ALIAS FOR $3;
    _new_unit_id ALIAS FOR $4;
    _new_domain_id ALIAS FOR $5;
  BEGIN

    -- check constraint 6
    IF (check_constraint_6(_schema, _new_unit_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 7
    IF (check_constraint_7(_schema, _new_unit_id, _new_data_type_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 8
    IF (check_constraint_8(_schema, _new_data_type_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 9
    IF (check_constraint_9(_schema, _new_domain_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 59
    IF (check_constraint_59(_schema, _new_name_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table attribute_type.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: id
 *          uuid: new name_id
 *          uuid: new data_type_id
 *          uuid: new unit_id
 *          uuid: new domain_id
 *          uuid: old id
 *          uuid: old name_id
 *          uuid: old unit_id
 *          uuid: old domain_id
 * @output  boolean: true if a constraint is violated
 */
CREATE OR REPLACE FUNCTION check_attribute_type_u(varchar, uuid, uuid, uuid, uuid,
                                                  uuid, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_name_id ALIAS FOR $3;
    _new_data_type_id ALIAS FOR $4;
    _new_unit_id ALIAS FOR $5;
    _new_domain_id ALIAS FOR $6;
    _old_id ALIAS FOR $7;
    _old_name_id ALIAS FOR $8;
    _old_unit_id ALIAS FOR $9;
    _old_domain_id ALIAS FOR $10;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- only perform this, when the trigger was not fired from the system database
    IF (_schema != 'system') THEN
      -- check constraint 48
      IF (check_constraint_48(_schema, _new_id, _new_unit_id, _old_unit_id)) THEN
        RETURN true;
      END IF;
    END IF;

    -- check constraint 49
    IF (check_constraint_49(_schema, _new_id, _new_domain_id, _old_domain_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 6
    IF (check_constraint_6(_schema, _new_unit_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 7
    IF (check_constraint_7(_schema, _new_unit_id, _new_data_type_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 8
    IF (check_constraint_8(_schema, _new_data_type_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 9
    IF (check_constraint_9(_schema, _new_domain_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 59
    IF (_new_name_id != _old_name_id) THEN
      IF (check_constraint_59(_schema, _new_name_id, true)) THEN
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/**************************** attribute_type_group ****************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_type_group.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new subgroup_of_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_group_i(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_subgroup_of_id ALIAS FOR $3;
  BEGIN

    -- check constraint 50
    IF (check_constraint_50(_schema, _new_id, _new_subgroup_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 51
    IF (check_constraint_51(_schema, _new_id, _new_subgroup_of_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_type_group.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new subgroup_of_id
 *          uuid: old id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_group_u(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_subgroup_of_id ALIAS FOR $3;
    _old_id ALIAS FOR $4;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 50
    IF (check_constraint_50(_schema, _new_id, _new_subgroup_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 51
    IF (check_constraint_51(_schema, _new_id, _new_subgroup_of_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/**************** attribute_type_group_to_topic_characteristic ****************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_type_group_to_topic_characteristic.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new topic_characteristic_id
 *          uuid: new attribute_type_group_id
 *          integer: new multiplicity_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_group_to_topic_characteristic_i(
                               varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_topic_characteristic_id ALIAS FOR $2;
    _new_attribute_type_group_id ALIAS FOR $3;
    _new_multiplicity_id ALIAS FOR $4;
  BEGIN

    -- check constraint 53
    IF (check_constraint_53(_schema, _new_topic_characteristic_id,
                            _new_attribute_type_group_id,
                            _new_multiplicity_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_type_group_to_topic_characteristic.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new topic_characteristic_id
 *          uuid: new attribute_type_group_id
 *          integer: new multiplicity_id
 *          uuid: old id
 *          uuid: old topic_characteristic_id
 *          uuid: old attribute_type_group_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_group_to_topic_characteristic_u(
                               varchar, uuid, uuid, uuid, uuid, uuid, uuid,
                               uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_topic_characteristic_id ALIAS FOR $3;
    _new_attribute_type_group_id ALIAS FOR $4;
    _new_multiplicity_id ALIAS FOR $5;
    _old_id ALIAS FOR $6;
    _old_topic_characteristic_id ALIAS FOR $7;
    _old_attribute_type_group_id ALIAS FOR $8;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 53
    IF (check_constraint_53(_schema, _new_topic_characteristic_id,
                            _new_attribute_type_group_id,
                            _new_multiplicity_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 12
    IF (check_constraint_12(_schema, _old_topic_characteristic_id,
                            _old_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * attribute_type_group_to_topic_characteristic.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: old topic_characteristic_id
 *          uuid: old attribute_type_group_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_group_to_topic_characteristic_d(
                               varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_topic_characteristic_id ALIAS FOR $2;
    _old_attribute_type_group_id ALIAS FOR $3;
  BEGIN

    -- check constraint 12
    IF (check_constraint_12(_schema, _old_topic_characteristic_id,
                            _old_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************* attribute_type_to_attribute_type_group *******************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_type_to_attribute_type_group.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new attribute_type_id
 *          uuid: new attribute_type_group_id
 *          uuid: new attribute_type_group_to_topic_characteristic_id
 *          uuid: new default_value_id
 *          integer: new multiplicity_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_to_attribute_type_group_i(
                               varchar, uuid, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_id ALIAS FOR $2;
    _new_attribute_type_group_id ALIAS FOR $3;
    _new_attribute_type_group_to_topic_characteristic_id ALIAS FOR $4;
    _new_default_value_id ALIAS FOR $5;
    _new_multiplicity_id ALIAS FOR $6;
  BEGIN

    -- check constraint 11
    IF (check_constraint_11(_schema, _new_attribute_type_id,
                            _new_default_value_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 45
    IF (check_constraint_45(_schema, _new_attribute_type_id,
                            _new_attribute_type_group_id,
                            _new_attribute_type_group_to_topic_characteristic_id,
                            _new_multiplicity_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_type_to_attribute_type_group.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new attribute_type_id
 *          uuid: new attribute_type_group_id
 *          uuid: new attribute_type_group_to_topic_characteristic_id
 *          uuid: new default_value_id
 *          integer: new order
 *          uuid: old id
 *          uuid: old attribute_type_group_to_topic_characteristic_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_to_attribute_type_group_u(
                               varchar, uuid, uuid, uuid, uuid, uuid, uuid,
                               uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_attribute_type_id ALIAS FOR $3;
    _new_attribute_type_group_id ALIAS FOR $4;
    _new_attribute_type_group_to_topic_characteristic_id ALIAS FOR $5;
    _new_default_value_id ALIAS FOR $6;
    _new_order ALIAS FOR $7;
    _old_id ALIAS FOR $8;
    _old_attribute_type_group_to_topic_characteristic_id ALIAS FOR $9;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 11
    IF (check_constraint_11(_schema, _new_attribute_type_id,
                            _new_default_value_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 45
    IF (check_constraint_45(_schema, _new_attribute_type_id,
                            _new_attribute_type_group_id,
                            _new_attribute_type_group_to_topic_characteristic_id,
                            _new_multiplicity_id)) THEN
      RETURN true;
    END IF;

    -- only perform this, when the trigger was not fired from the system database
    IF (_schema != 'system') THEN
      -- check constraint 56
      IF (check_constraint_56(_schema, _new_id,
                              _new_attribute_type_group_to_topic_characteristic_id,
                              _old_id,
                              _old_attribute_type_group_to_topic_characteristic_id
                              )) THEN
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/********************** attribute_type_x_attribute_type ***********************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_type_x_attribute_type.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new attribute_type_1_id
 *          uuid: new attribute_type_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_x_attribute_type_i(varchar, uuid,
                                                                   uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_1_id ALIAS FOR $2;
    _new_attribute_type_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
  BEGIN

    -- check constraint 24
    IF (check_constraint_24(_schema, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 25
    IF (check_constraint_25(_schema, _new_attribute_type_1_id,
                            _new_attribute_type_2_id, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 26
    IF (check_constraint_26(_schema, _new_attribute_type_1_id,
                            _new_attribute_type_2_id, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 27
    IF (check_constraint_27(_new_attribute_type_1_id,
                            _new_attribute_type_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_type_x_attribute_type.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new attribute_type_1_id
 *          uuid: new attribute_type_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_type_x_attribute_type_u(varchar, uuid,
                                                                   uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_1_id ALIAS FOR $2;
    _new_attribute_type_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
  BEGIN

    -- check constraint 24
    IF (check_constraint_24(_schema, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 25
    IF (check_constraint_25(_schema, _new_attribute_type_1_id,
                            _new_attribute_type_2_id, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 26
    IF (check_constraint_26(_schema, _new_attribute_type_1_id,
                            _new_attribute_type_2_id, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 27
    IF (check_constraint_27(_schema, _new_attribute_type_1_id,
                            _new_attribute_type_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/*************************** attribute_value_domain ***************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_value_domain.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          uuid: new domain_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_domain_i(varchar, uuid, uuid,
                                                          uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_topic_instance_id ALIAS FOR $3;
    _new_domain_id ALIAS FOR $4;
  BEGIN

    -- check constraint 42
    IF (check_constraint_42(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 35
    IF (check_constraint_35(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_domain_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_value_domain.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          uuid: new domain_id
 *          uuid: old id
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_domain_u(varchar, uuid, uuid,
                                                          uuid, uuid, uuid,
                                                          uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $3;
    _new_topic_instance_id ALIAS FOR $4;
    _new_domain_id ALIAS FOR $5;
    _old_id ALIAS FOR $6;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $7;
    _old_topic_instance_id ALIAS FOR $8;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 42
    IF (check_constraint_42(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 35
    IF (check_constraint_35(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_domain_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * attribute_value_domain.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_domain_d(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _old_topic_instance_id ALIAS FOR $3;
  BEGIN

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/**************************** attribute_value_geom ****************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_value_geom.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          geometry(Geometry): new geometry
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_geom_i(varchar, uuid, uuid,
                                                        geometry(Geometry))
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_topic_instance_id ALIAS FOR $3;
    _new_geometry ALIAS FOR $4;
  BEGIN

    -- check constraint 41
    IF (check_constraint_41(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 33
    IF (check_constraint_33(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_geometry)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
$$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_value_geom.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          geometry(Geometry): new geometry
 *          uuid: old id
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_geom_u(varchar, uuid, uuid, uuid,
                                                        geometry(Geometry),
                                                        uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $3;
    _new_topic_instance_id ALIAS FOR $4;
    _new_geometry ALIAS FOR $5;
    _old_id ALIAS FOR $6;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $7;
    _old_topic_instance_id ALIAS FOR $8;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 41
    IF (check_constraint_41(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 33
    IF (check_constraint_33(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_geometry)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
$$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * attribute_value_geom.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_geom_d(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _old_topic_instance_id ALIAS FOR $3;
  BEGIN

    RETURN false;
  END;
$$ LANGUAGE 'plpgsql';


/******************************************************************************/
/*************************** attribute_value_geomz ****************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_value_geomz.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          geometry(GeometryZ): new geometry
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_geomz_i(varchar, uuid, uuid,
                                                         geometry(GeometryZ))
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_topic_instance_id ALIAS FOR $3;
    _new_geometry ALIAS FOR $4;
  BEGIN

    -- check constraint 47
    IF (check_constraint_47(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 34
    IF (check_constraint_34(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_geometry)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
$$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_value_geomz.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          geometry(GeometryZ): new geometry
 *          uuid: old id
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_geomz_u(varchar, uuid, uuid, uuid,
                                                         geometry(GeometryZ),
                                                         uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $3;
    _new_topic_instance_id ALIAS FOR $4;
    _new_geometry ALIAS FOR $5;
    _old_id ALIAS FOR $6;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $7;
    _old_topic_instance_id ALIAS FOR $8;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 47
    IF (check_constraint_47(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 34
    IF (check_constraint_34(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_geometry)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
$$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * attribute_value_geomz.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_geomz_d(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _old_topic_instance_id ALIAS FOR $3;
  BEGIN

    RETURN false;
  END;
$$ LANGUAGE 'plpgsql';


/******************************************************************************/
/*************************** attribute_value_value ****************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * attribute_value_value.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          uuid: new value
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_value_i(varchar, uuid,
                                                         uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _new_topic_instance_id ALIAS FOR $3;
    _new_value ALIAS FOR $4;
  BEGIN

    -- check constraint 40
    IF (check_constraint_40(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 31
    IF (check_constraint_31(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_value)) THEN
      RETURN true;
    END IF;

    -- check constraint 32
    IF (check_constraint_32(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_value)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * attribute_value_value.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new attribute_type_to_attribute_type_group_id
 *          uuid: new topic_instance_id
 *          uuid: new value
 *          uuid: old id
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_value_u(varchar, uuid, uuid,
                                                         uuid, uuid, uuid, uuid,
                                                         uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_attribute_type_to_attribute_type_group_id ALIAS FOR $3;
    _new_topic_instance_id ALIAS FOR $4;
    _new_value ALIAS FOR $5;
    _old_id ALIAS FOR $6;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $7;
    _old_topic_instance_id ALIAS FOR $8;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 40
    IF (check_constraint_40(_schema,
                            _new_attribute_type_to_attribute_type_group_id)) THEN
      RETURN true;
    END IF;

    -- TODO: reicht Constraint in "attribute_value" aus?
    -- check constraint 30
    IF (check_constraint_30(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_topic_instance_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 31
    IF (check_constraint_31(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_value)) THEN
      RETURN true;
    END IF;

    -- check constraint 32
    IF (check_constraint_32(_schema,
                            _new_attribute_type_to_attribute_type_group_id,
                            _new_value)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * attribute_value_value.
 *
 * @state   experimental
 * @input   varchar: schema name
 *          uuid: old attribute_type_to_attribute_type_group_id
 *          uuid: old topic_instance_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_attribute_value_value_d(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_attribute_type_to_attribute_type_group_id ALIAS FOR $2;
    _old_topic_instance_id ALIAS FOR $3;
  BEGIN

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************************* character_code *******************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * character_code.
 *
 * @state   stable
 * @input   varchar: new character_code
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_character_code_i(varchar)
  RETURNS boolean AS $$
  DECLARE
    _new_character_code ALIAS FOR $1;
  BEGIN

    -- check constraint 44
    IF (check_constraint_44(_new_character_code)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * character_code.
 *
 * @state   stable
 * @input   uuid: new id
 *          varchar: new character_code
 *          uuid: old id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_character_code_u(uuid, varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _new_character_code ALIAS FOR $2;
    _old_id ALIAS FOR $3;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 44
    IF (check_constraint_44(_new_character_code)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************************** country_code ********************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table country_code.
 *
 * @state   stable
 * @input   varchar: new country_code
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_country_code_i(varchar)
  RETURNS boolean AS $$
  DECLARE
    _new_country_code ALIAS FOR $1;
  BEGIN

    -- check constraint 5
    IF (check_constraint_5(_new_country_code)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table country_code.
 *
 * @state   stable
 * @input   uuid: new id
 *          varchar: new country_code
 *          uuid: old id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_country_code_u(uuid, varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _new_country_code ALIAS FOR $2;
    _old_id ALIAS FOR $3;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 5
    IF (check_constraint_5(_new_country_code)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************************** language_code *******************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table language_code.
 *
 * @state   stable
 * @input   varchar: new language_code
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_language_code_i(varchar)
  RETURNS boolean AS $$
  DECLARE
    _new_language_code ALIAS FOR $1;
  BEGIN

    -- check constraint 4
    IF (check_constraint_4(_new_language_code)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table language_code.
 *
 * @state   stable
 * @input   uuid: new id
 *          varchar: new language_code
 *          uuid: old id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_language_code_u(uuid, varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _new_language_code ALIAS FOR $2;
    _old_id ALIAS FOR $3;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 4
    IF (check_constraint_4(_new_language_code)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************* localized_character_string *************************/
/******************************************************************************/
/*
 * If entries in localized_character_string are added, we must add an entry in
 * pt_free_text.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new pt_free_text_id
 *          uuid: new free_text
 *          uuid: old pt_free_text_id - DEFAULT NULL
 *          uuid: old free_text - DEFAULT NULL
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION localized_character_string_i(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_pt_free_text_id ALIAS FOR $2;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- only insert the uuid into pt_free_text if no entry exists (saving a 
    -- string with different pt_locale)
    IF ((SELECT count("id")
           FROM "pt_free_text"
          WHERE "id" = _new_pt_free_text_id) = 0) THEN
      INSERT INTO "pt_free_text" VALUES (_new_pt_free_text_id);
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * localized_character_string.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new pt_free_text_id
 *          uuid: old pt_free_text_id - DEFAULT NULL
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION localized_character_string_u(varchar, uuid,
                                                        uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_pt_free_text_id ALIAS FOR $2;
    _old_pt_free_text_id ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- check constraint 46
    IF (check_constraint_46(_schema, _new_pt_free_text_id, _old_pt_free_text_id)) THEN
      RETURN true;
    END IF;
    
    -- check constraint 58
    IF (check_constraint_58(_new_pt_free_text_id, _old_pt_free_text_id)) THEN
      RETURN true;
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';


/*
 * If entries in localized_character_string are deleted, we must delete the
 * entry in pt_free_text as well. Additional the integrity checks for delete
 * statements on the table localized_character_string are performed.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new pt_free_text_id
 *          uuid: old pt_free_text_id - DEFAULT NULL
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION localized_character_string_d(varchar, uuid,
                                                        uuid DEFAULT NULL)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_pt_free_text_id ALIAS FOR $2;
    _old_pt_free_text_id ALIAS FOR $3;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- delete the entry in pt_free_text if it exists
    IF ((SELECT count("id")
           FROM "pt_free_text"
          WHERE "id" = _new_pt_free_text_id) = 0) THEN
      DELETE FROM "pt_free_text" WHERE "id" = _old_pt_free_text_id;
    END IF;

    -- check constraint 46
    IF (check_constraint_46(_new_pt_free_text_id, _old_pt_free_text_id)) THEN
      RETURN true;
    END IF;

    RETURN false;

    -- ignore delete in pt_free_text if their are further entries in
    -- localized_character_string that reference on the same pt_free_text_id
    EXCEPTION
        WHEN foreign_key_violation THEN
        RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************************** multiplicity ********************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table multiplicity.
 *
 * @state   stable
 * @input   integer: new min_value
 *          integer: new max_value
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_multiplicity_i(integer, integer)
  RETURNS boolean AS $$
  DECLARE
    _new_min ALIAS FOR $1;
    _new_max ALIAS FOR $2;
  BEGIN

    -- check constraint 1
    IF (check_constraint_1(_new_min)) THEN
      RETURN true;
    END IF;

    -- check constraint 2
    IF (check_constraint_2(_new_max)) THEN
      RETURN true;
    END IF;

    -- check constraint 3
    IF (check_constraint_3(_new_min, _new_max)) THEN
      RETURN true;
    END IF;

    return false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table multiplicity.
 *
 * @state   stable
 * @input   uuid: new id
 *          integer: new min_value
 *          integer: new max_value
 *          uuid: old id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_multiplicity_u(uuid, integer, integer, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _new_min ALIAS FOR $2;
    _new_max ALIAS FOR $3;
    _old_id ALIAS FOR $4;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 1
    IF (check_constraint_1(_new_min)) THEN
      RETURN true;
    END IF;

    -- check constraint 2
    IF (check_constraint_2(_new_max)) THEN
      RETURN true;
    END IF;

    -- check constraint 3
    IF (check_constraint_3(_new_min, _new_max)) THEN
      RETURN true;
    END IF;

    return false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/********************************** project ***********************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table project.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new name_id
 *          uuid: new subproject_of_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_project_i(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_name_id ALIAS FOR $3;
    _new_subproject_of_id ALIAS FOR $4;
  BEGIN

    -- check constraint 36
    IF (check_constraint_36(_schema, _new_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 37
    IF (check_constraint_37(_schema, _new_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 38
    IF (check_constraint_38(_new_id, _new_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 55
    IF (check_constraint_55(_schema, _new_id, _new_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 60
    IF (check_constraint_60(_schema, _new_name_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table project.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new name_id
 *          uuid: new subproject_of_id
 *          uuid: old id
 *          uuid: old name_id
 *          uuid: old subproject_of_id
 * @output  boolean: true if a constraint is violated, else false
 */
CREATE OR REPLACE FUNCTION check_project_u(varchar, uuid, uuid, uuid, uuid,
                                           uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_name_id ALIAS FOR $3;
    _new_subproject_of_id ALIAS FOR $4;
    _old_id ALIAS FOR $5;
    _old_name_id ALIAS FOR $6;
    _old_subproject_of_id ALIAS FOR $7;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 36
    IF (check_constraint_36(_schema, _new_subproject_of_id, _old_id,
                            _old_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 37
    IF (check_constraint_37(_schema, _new_subproject_of_id,
                            _old_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 38
    IF (check_constraint_38(_new_id, _new_subproject_of_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 55
    IF (check_constraint_55(_schema, _new_id, _new_subproject_of_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 60
    IF (_new_name_id != _old_name_id) THEN
      IF (check_constraint_60(_schema, _new_name_id, true)) THEN
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/********************************** pt_locale *********************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table pt_locale.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new language_code_id
 *          uuid: new country_code_id
 *          uuid: new character_code_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_pt_locale_i(varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_language_code_id ALIAS FOR $2;
    _new_country_code_id ALIAS FOR $3;
    _new_character_code_id ALIAS FOR $4;
  BEGIN

    -- check constraint 52
    IF (check_constraint_52(_schema, _new_language_code_id,
                            _new_country_code_id, _new_character_code_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table pt_locale.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new language_code_id
 *          uuid: new country_code_id
 *          uuid: new character_code_id
 *          uuid: old id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_pt_locale_u(varchar, uuid, uuid, uuid, uuid,
                                             uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_language_code_id ALIAS FOR $3;
    _new_country_code_id ALIAS FOR $4;
    _new_character_code_id ALIAS FOR $5;
    _old_id ALIAS FOR $6;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 52
    IF (check_constraint_52(_schema, _new_language_code_id,
                            _new_country_code_id, _new_character_code_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/***************************** relationship_type ******************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * relationship_type.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new reference_to_id
 *          uuid: new description_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_relationship_type_i(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_reference_to_id ALIAS FOR $2;
    _new_description_id ALIAS FOR $3;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- check constraint 13
    IF (check_constraint_13(_schema, _new_reference_to_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 14
    IF (check_constraint_14(_schema, _new_description_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * relationship_type.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new reference_to_id
 *          uuid: new description_id
 *          uuid: old id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_relationship_type_u(varchar, uuid, uuid, uuid,
                                                     uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_reference_to_id ALIAS FOR $3;
    _new_description_id ALIAS FOR $4;
    _old_id ALIAS FOR $5;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- check constraint 13
    IF (check_constraint_13(_schema, _new_reference_to_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 14
    IF (check_constraint_14(_schema, _new_description_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/**************************** topic_characteristic ****************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * topic_characteristic.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new description_id
 *          uuid: new topic_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_topic_characteristic_i(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_description_id ALIAS FOR $2;
    _new_topic_id ALIAS FOR $3;
  BEGIN

    -- check constraint 15
    IF (check_constraint_15(_schema, _new_topic_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 61
    IF (check_constraint_61(_schema, _new_description_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * topic_characteristic.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new description_id
 *          uuid: new topic_id
 *          uuid: old id
 *          uuid: old description_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_topic_characteristic_u(varchar, uuid, uuid,
                                                        uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_description_id ALIAS FOR $3;
    _new_topic_id ALIAS FOR $4;
    _old_id ALIAS FOR $5;
    _old_description_id ALIAS FOR $6;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 15
    IF (check_constraint_15(_schema, _new_topic_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 61
    IF (_new_description_id != _old_description_id) THEN
      IF (check_constraint_61(_schema, _new_description_id, true)) THEN
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************************* topic_instance *******************************/
/******************************************************************************/
/*
 * Perform the integrity check for update statements on the table
 * topic_instance.
 *
 * @state   stable
 * @input   uuid: new id
 *          uuid: old id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_topic_instance_u(uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _new_id ALIAS FOR $1;
    _old_id ALIAS FOR $2;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/********************** topic_instance_x_topic_instance ***********************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * topic_instance_x_topic_instance.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new topic_instance_1_id
 *          uuid: new topic_instance_2_id
 *          uuid: new relationship_type_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_topic_instance_x_topic_instance_i(
                               varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_topic_instance_1_id ALIAS FOR $2;
    _new_topic_instance_2_id ALIAS FOR $3;
    _new_relationship_type_id ALIAS FOR $4;
  BEGIN

    -- check constraint 28
    IF (check_constraint_28(_new_topic_instance_1_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 39
    IF (check_constraint_39(_schema, _new_relationship_type_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 29
    IF (check_constraint_29(_schema, _new_relationship_type_id,
                            _new_topic_instance_1_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 43
    IF (check_constraint_43(_schema, _new_relationship_type_id,
                            _new_topic_instance_1_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    /*
    -- (29) In der Relation "topic_instance" existieren zwei Tupel ti1 und ti2
    --      der "topic_characteristic" tc1 und tc2. In der Relation
    --      "topic_instance_x_topic_instance" kann ein Tupel ti1, ti2, rt nur
    --      dann eingetragen werden, wenn in der Relation
    --      "relationship_type_to_topic_characteristic" das Tupel tc1, rt und
    --      in der Relation "relationship_type" das Tupel rt, Thema von tc2
    --      existiert.
    -- ermittle die Beschreibung des Beziehungstyps
    SELECT "description" INTO _rt_description_id
      FROM "relationship_type"
     WHERE "id" = _relationship_type_id;

    -- speichere tc1 von ti1
    SELECT "topic_characteristic_id" INTO _topic_characteristic_1_id
      FROM "topic_instance"
     WHERE "id" = _topic_instance_1;

    -- speichere die multiplicity von tc1 und rt in
    -- relationship_type_to_topic_characteristic
    SELECT "multiplicity" INTO _multiplicity_id
      FROM "relationship_type_to_topic_characteristic"
     WHERE "topic_characteristic_id" = _topic_characteristic_1_id AND
           "relationship_type_id" = _relationship_type_id;

    -- prüfe, ob in relationship_type_to_topic_characteristic ein Tupel tc1 und
    -- rt enthalten ist
    -- Anm: Prüfung anhand von mutliplicity, da es später nochmals verwendet
    -- wird (spart doppelte Abfrage)
    IF _multiplicity_id IS NULL THEN
      _string := 'wrong input in relationship_type_to_topic_characteristic';
      RAISE EXCEPTION '%', _string;
      _string := 'Constraint 29 - In der Relation "topic_instance" existieren '||
                 'zwei Tupel ti1 und ti2 der "topic_characteristic" tc1 und '||
                 'tc2. In der Relation "topic_instance_x_topic_instance" kann '||
                 'ein Tupel ti1, ti2, rt nur dann eingetragen werden, wenn in '||
                 'der Relation "relationship_type_to_topic_characteristic" '||
                 'das Tupel tc1, rt und in der Relation "relationship_type" '||
                 'das Tupel rt, Thema von tc2 existiert.';
      RAISE EXCEPTION '%', _string;
      RETURN true;
    END IF;

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
           "tixti"."relationship_type_id" = _relationship_type_id;

    -- wenn es sich um einen Aufruf aus einem Delete Trigger handelt, muss der
    -- min_value beachtet werden
    IF _delete THEN
      IF (_count-1 < _min) THEN
        _string := 'Constraint 43 - Ein Tupel in der Relation '||
                   '"topic_instance_x_topic_instance" darf nur sooft auftreten, '||
                   'wie es in "relationship_type_to_topic_characteristic" '||
                   'durch "multiplicity" definiert ist. Dabei gelten folgende '||
                   'Kardinaltitäten: 0 – optional, Zahl – Wert der Zahl, '||
                   'NULL – beliebig viele.';
        RAISE EXCEPTION '%', _string;
        RETURN true;
      END IF;
      -- kann an dieser Stelle beendet werden, da nachfolgende Funktionen nur
      -- für INSERT oder UPDATE relevant sind
      RETURN false;
    END IF;

    -- prüfe, ob in relationship_type ein Tupel Thema von tc2, rt existiert
    IF ((SELECT "rt"."id"
           FROM "topic_instance" "ti", "topic_characteristic" "tc",
                "relationship_type" "rt"
          WHERE "ti"."topic_characteristic_id" = "tc"."id" AND
                "ti"."id" = _topic_instance_2 AND
                "rt"."description" = _rt_description_id AND
                "rt"."reference_to" = "tc"."topic"
          LIMIT 1
                )
      IS NULL) THEN
      _string := 'wrong input in relationship_type';
      RAISE EXCEPTION '%', _string;
      _string := 'Constraint 29 - In der Relation "topic_instance" '||
                 'existieren zwei Tupel ti1 und ti2 der '||
                 '"topic_characteristic" tc1 und tc2. In der Relation '||
                 '"topic_instance_x_topic_instance" kann ein Tupel ti1, ti2, '||
                 'rt nur dann eingetragen werden, wenn in der Relation '||
                 '"relationship_type_to_topic_characteristic" das Tupel tc1, '||
                 'rt und in der Relation "relationship_type" das Tupel rt, '||
                 'Thema von tc2 existiert.';
      RAISE EXCEPTION '%', _string;
      RETURN true;
    END IF;

    -- wenn max_value NULL ist, kann bereits hier abgebrochen werden
    IF (_max IS NULL) THEN
      RETURN false;
    END IF;

    -- (43) Ein Tupel in der Relation "topic_instance_x_topic_instance" darf nur
    --      sooft auftreten, wie es in "relationship_type_to_topic_characteristic"
    --      durch "multiplicity" definiert ist. Dabei gelten folgende
    --      Kardinaltitäten: 0 – optional, Zahl – Wert der Zahl, NULL – beliebig
    --      viele.
    -- es darf nur max_value Einträge geben, falls NULL dann unbeschränkt
    IF (_count+1 > _max) THEN
      _string := 'Constraint 43 - Ein Tupel in der Relation '||
                 '"topic_instance_x_topic_instance" darf nur sooft auftreten, '||
                 'wie es in "relationship_type_to_topic_characteristic" durch '||
                 '"multiplicity" definiert ist. Dabei gelten folgende '||
                 'Kardinaltitäten: 0 – optional, Zahl – Wert der Zahl, '||
                 'NULL – beliebig. viele';
      RAISE EXCEPTION '%', _string;
      RETURN true;
    END IF;
*/
    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for insert statements on the table
 * topic_instance_x_topic_instance.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new topic_instance_1_id
 *          uuid: new topic_instance_2_id
 *          uuid: new relationship_type_id
 *          uuid: old id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_topic_instance_x_topic_instance_u(
                               varchar, uuid, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_topic_instance_1_id ALIAS FOR $3;
    _new_topic_instance_2_id ALIAS FOR $4;
    _new_relationship_type_id ALIAS FOR $5;
    _old_id ALIAS FOR $6;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 28
    IF (check_constraint_28(_new_topic_instance_1_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 39
    IF (check_constraint_39(_schema, _new_relationship_type_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 29
    IF (check_constraint_29(_schema, _new_relationship_type_id,
                            _new_topic_instance_1_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 43
    IF (check_constraint_43(_schema, _new_relationship_type_id,
                            _new_topic_instance_1_id,
                            _new_topic_instance_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * topic_instance_x_topic_instance.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: old topic_instance_1_id
 *          uuid: old relationship_type_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_topic_instance_x_topic_instance_d(
                               varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_topic_instance_1_id ALIAS FOR $2;
    _old_relationship_type_id ALIAS FOR $3;
  BEGIN

    -- check constraint 43
    IF (check_constraint_43(_schema, NULL, NULL,
                            _old_relationship_type_id,
                            _old_topic_instance_1_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/********************************* value_list *********************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table value_list.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new name_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_i(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_name_id ALIAS FOR $2;
  BEGIN

    -- check constraint 62
    IF (check_constraint_62(_schema, _new_name_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table value_list.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new name_id
 *          uuid: old id
 *          uuid: old name_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_u(varchar, uuid, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_name_id ALIAS FOR $3;
    _old_id ALIAS FOR $4;
    _old_name_id ALIAS FOR $5;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    IF (_new_name_id != _old_name_id) THEN
      -- check constraint 46
      IF (check_constraint_46(_schema, _new_name_id, _old_name_id)) THEN
        RETURN true;
      END IF;

      -- check constraint 62
      IF (check_constraint_62(_schema, _new_name_id, true)) THEN
        RETURN true;
      END IF;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table value_list.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: old name_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_d(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_name_id ALIAS FOR $2;
  BEGIN

    -- check constraint 46
    IF (check_constraint_46(_schema, NULL, _old_name_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/****************************** value_list_values *****************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * value_list_values.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new belongs_to_value_list_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_values_i(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_belongs_to_value_list_id ALIAS FOR $2;
  BEGIN

    -- check constraint 63
    IF (check_constraint_63(_schema, _new_belongs_to_value_list_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * value_list_values.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: new id
 *          uuid: new belongs_to_value_list_id
 *          uuid: old id
 *          uuid: old belongs_to_value_list_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_values_u(varchar, uuid, uuid, uuid,
                                                     uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_id ALIAS FOR $2;
    _new_belongs_to_value_list_id ALIAS FOR $3;
    _old_id ALIAS FOR $4;
    _old_belongs_to_value_list_id ALIAS FOR $5;
  BEGIN

    -- check if the primary key has changed
    IF (compare_ids(_new_id, _old_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 57
    IF (check_constraint_57(_schema, _new_belongs_to_value_list_id,
                            _old_belongs_to_value_list_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 63
    IF (check_constraint_63(_schema, _new_belongs_to_value_list_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for delete statements on the table
 * value_list_values.
 *
 * @state   stable
 * @input   varchar: schema name
 *          uuid: old belongs_to_value_list_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_values_d(varchar, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _old_belongs_to_value_list_id ALIAS FOR $2;
  BEGIN

    -- check constraint 63
    IF (check_constraint_63(_schema, _old_belongs_to_value_list_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/******************* value_list_values_x_value_list_values ********************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * value_list_values_x_value_list_values.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new value_list_values_1_id
 *          uuid: new value_list_values_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_values_x_value_list_values_i(
                               varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_value_list_values_1_id ALIAS FOR $2;
    _new_value_list_values_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
  BEGIN

    -- check constraint 20
    IF (check_constraint_20(_schema, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 21
    IF (check_constraint_21(_schema, _new_relationship_id,
                            _new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 22
    IF (check_constraint_22(_schema, _new_relationship_id,
                            _new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 23
    IF (check_constraint_23(_new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * value_list_values_x_value_list_values.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new value_list_values_1_id
 *          uuid: new value_list_values_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_values_x_value_list_values_u(
                               varchar, uuid, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_value_list_values_1_id ALIAS FOR $2;
    _new_value_list_values_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
  BEGIN

    -- check constraint 20
    IF (check_constraint_20(_schema, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 21
    IF (check_constraint_21(_schema, _new_relationship_id,
                            _new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 22
    IF (check_constraint_22(_schema, _new_relationship_id,
                            _new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 23
    IF (check_constraint_23(_new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/******************************************************************************/
/************************** value_list_x_value_list ***************************/
/******************************************************************************/
/*
 * Perform the integrity check for insert statements on the table
 * value_list_x_value_list.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new value_list_1_id
 *          uuid: new value_list_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_x_value_list_i(varchar, uuid, uuid,
                                                           uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_value_list_1_id ALIAS FOR $2;
    _new_value_list_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
  BEGIN

    -- check constraint 16
    IF (check_constraint_16(_schema, _new_relationship_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 17
    IF (check_constraint_17(_schema, _new_relationship_id,
                            _new_value_list_1_id,
                            _new_value_list_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 18
    IF (check_constraint_18(_schema, _new_relationship_id,
                            _new_value_list_1_id,
                            _new_value_list_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 19
    IF (check_constraint_19(_new_value_list_1_id,
                            _new_value_list_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Perform the integrity check for update statements on the table
 * value_list_x_value_list.
 *
 * @state   experimental (keine Flexibilität hinsichtlich der Lokalisierung)
 * @input   varchar: schema name
 *          uuid: new value_list_1_id
 *          uuid: new value_list_2_id
 *          uuid: new relationship_id
 * @output  boolean: true if a condition is violated, else false
 */
CREATE OR REPLACE FUNCTION check_value_list_x_value_list_u(varchar, uuid, uuid,
                                                           uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _new_value_list_1_id ALIAS FOR $2;
    _new_value_list_2_id ALIAS FOR $3;
    _new_relationship_id ALIAS FOR $4;
  BEGIN

    -- check constraint 16
    IF (check_constraint_16(_new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 17
    IF (check_constraint_17(_new_relationship_id,
                            _new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 18
    IF (check_constraint_18(_new_relationship_id,
                            _new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    -- check constraint 19
    IF (check_constraint_19(_new_value_list_values_1_id,
                            _new_value_list_values_2_id)) THEN
      RETURN true;
    END IF;

    RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';
