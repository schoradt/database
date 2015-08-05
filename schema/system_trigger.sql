/*
 * changelog from 05.08.2015
 * - added trigger for table meta_data
 *
 * changelog from 06.05.2015
 * - trigger parameter changed for new multiplicity checks
 *
 * changelog from 16.04.2015
 * - added parameters needed for constraints 59, 60, 61 and 62
 *
 * changelog from 02.04.2015
 * - trigger reworked to match constraint refactoring
 *
 * changelog from 26.01.2015
 * - trigger creation for system database outsourced in separate file
 */


-- set search path to created system and constraint schema
SET search_path TO "system", "constraints", public;
SET CLIENT_ENCODING TO "UTF8";



/******************************************************************************/
/******************************* attribute_type *******************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS attribute_type_insert ON "attribute_type";
DROP TRIGGER IF EXISTS attribute_type_update ON "attribute_type";

CREATE TRIGGER attribute_type_insert
BEFORE INSERT ON "attribute_type"
  FOR EACH ROW
    WHEN (check_attribute_type_i(
              "constraints".get_current_project_schema(), NEW."name",
              NEW."data_type", NEW."unit", NEW."domain"))
EXECUTE PROCEDURE insert_violation_on_trigger('attribute_type');

CREATE TRIGGER attribute_type_update
BEFORE UPDATE ON "attribute_type"
  FOR EACH ROW
    WHEN (check_attribute_type_u(
              "constraints".get_current_project_schema(), NEW."id", NEW."name",
              NEW."data_type", NEW."unit", NEW."domain", OLD."id", OLD."name",
              OLD."unit", OLD."domain"))
EXECUTE PROCEDURE update_violation_on_trigger('attribute_type');



/******************************************************************************/
/**************************** attribute_type_group ****************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS attribute_type_group_insert ON "attribute_type_group";
DROP TRIGGER IF EXISTS attribute_type_group_update ON "attribute_type_group";

CREATE TRIGGER attribute_type_group_insert
BEFORE INSERT ON "attribute_type_group"
  FOR EACH ROW
    WHEN (check_attribute_type_group_i(
              "constraints".get_current_project_schema(),
              NEW."id", NEW."subgroup_of"))
EXECUTE PROCEDURE insert_violation_on_trigger('attribute_type_group');

CREATE TRIGGER attribute_type_group_update
BEFORE UPDATE ON "attribute_type_group"
  FOR EACH ROW
    WHEN (check_attribute_type_group_u(
              "constraints".get_current_project_schema(),
              NEW."id", NEW."subgroup_of", OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('attribute_type_group');



/******************************************************************************/
/**************** attribute_type_group_to_topic_characteristic ****************/
/******************************************************************************/

DROP TRIGGER IF EXISTS attribute_type_group_to_topic_characteristic_insert ON
                      "attribute_type_group_to_topic_characteristic";
DROP TRIGGER IF EXISTS attribute_type_group_to_topic_characteristic_update ON
                      "attribute_type_group_to_topic_characteristic";
DROP TRIGGER IF EXISTS attribute_type_group_to_topic_characteristic_delete ON
                      "attribute_type_group_to_topic_characteristic";

CREATE TRIGGER attribute_type_group_to_topic_characteristic_insert
BEFORE INSERT ON "attribute_type_group_to_topic_characteristic"
  FOR EACH ROW
    WHEN (check_attribute_type_group_to_topic_characteristic_i(
              "constraints".get_current_project_schema(),
              NEW."topic_characteristic_id", NEW."attribute_type_group_id",
              NEW."multiplicity"))
EXECUTE PROCEDURE insert_violation_on_trigger(
                      'attribute_type_group_to_topic_characteristic');

CREATE TRIGGER attribute_type_group_to_topic_characteristic_update
BEFORE UPDATE ON "attribute_type_group_to_topic_characteristic"
  FOR EACH ROW
    WHEN (check_attribute_type_group_to_topic_characteristic_u(
              "constraints".get_current_project_schema(), NEW."id",
              NEW."topic_characteristic_id", NEW."attribute_type_group_id",
              NEW."multiplicity", OLD."id", OLD."topic_characteristic_id",
              OLD."attribute_type_group_id"))
EXECUTE PROCEDURE update_violation_on_trigger(
                      'attribute_type_group_to_topic_characteristic');


CREATE TRIGGER attribute_type_group_to_topic_characteristic_delete
BEFORE DELETE ON "attribute_type_group_to_topic_characteristic"
  FOR EACH ROW
    WHEN (check_attribute_type_group_to_topic_characteristic_d(
              "constraints".get_current_project_schema(),
              OLD."topic_characteristic_id", OLD."attribute_type_group_id"))
EXECUTE PROCEDURE delete_violation_on_trigger(
                      'attribute_type_group_to_topic_characteristic');



/******************************************************************************/
/******************* attribute_type_to_attribute_type_group *******************/
/******************************************************************************/

DROP TRIGGER IF EXISTS attribute_type_to_attribute_type_group_insert ON
                      "attribute_type_to_attribute_type_group";
DROP TRIGGER IF EXISTS attribute_type_to_attribute_type_group_update ON
                      "attribute_type_to_attribute_type_group";
DROP TRIGGER IF EXISTS attribute_type_to_attribute_type_group_delete ON
                      "attribute_type_to_attribute_type_group";

CREATE TRIGGER attribute_type_to_attribute_type_group_insert
BEFORE INSERT ON "attribute_type_to_attribute_type_group"
  FOR EACH ROW
    WHEN (check_attribute_type_to_attribute_type_group_i(
              "constraints".get_current_project_schema(),
              NEW."attribute_type_id", NEW."attribute_type_group_id",
              NEW."attribute_type_group_to_topic_characteristic_id",
              NEW."default_value", NEW."multiplicity"))
EXECUTE PROCEDURE insert_violation_on_trigger(
                      'attribute_type_to_attribute_type_group');

CREATE TRIGGER attribute_type_to_attribute_type_group_update
BEFORE UPDATE ON "attribute_type_to_attribute_type_group"
  FOR EACH ROW
    WHEN (check_attribute_type_to_attribute_type_group_u(
              "constraints".get_current_project_schema(),
              NEW."id", NEW."attribute_type_id", NEW."attribute_type_group_id",
              NEW."attribute_type_group_to_topic_characteristic_id",
              NEW."default_value", NEW."multiplicity", OLD."id",
              OLD."attribute_type_group_to_topic_characteristic_id"))
EXECUTE PROCEDURE update_violation_on_trigger(
                      'attribute_type_to_attribute_type_group');



/******************************************************************************/
/********************** attribute_type_x_attribute_type ***********************/
/******************************************************************************/

DROP TRIGGER IF EXISTS attribute_type_x_attribute_type_insert ON
                      "attribute_type_x_attribute_type";
DROP TRIGGER IF EXISTS attribute_type_x_attribute_type_update ON
                      "attribute_type_x_attribute_type";

CREATE TRIGGER attribute_type_x_attribute_type_insert
BEFORE INSERT ON "attribute_type_x_attribute_type"
  FOR EACH ROW
    WHEN (check_attribute_type_x_attribute_type_i(
              "constraints".get_current_project_schema(),
              NEW."attribute_type_1", NEW."attribute_type_2", 
              NEW."relationship"))
EXECUTE PROCEDURE insert_violation_on_trigger('attribute_type_x_attribute_type');

CREATE TRIGGER attribute_type_x_attribute_type_update
BEFORE UPDATE ON "attribute_type_x_attribute_type"
  FOR EACH ROW
    WHEN (check_attribute_type_x_attribute_type_u(
              "constraints".get_current_project_schema(),
              NEW."attribute_type_1", NEW."attribute_type_2",
              NEW."relationship"))
EXECUTE PROCEDURE update_violation_on_trigger('attribute_type_x_attribute_type');



/******************************************************************************/
/******************************* character_code *******************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS character_code_insert ON "character_code";
DROP TRIGGER IF EXISTS character_code_update ON "character_code";

CREATE TRIGGER character_code_insert
BEFORE INSERT ON "character_code"
  FOR EACH ROW
    WHEN (check_character_code_i(NEW."character_code"))
EXECUTE PROCEDURE insert_violation_on_trigger('character_code');

CREATE TRIGGER character_code_update
BEFORE UPDATE ON "character_code"
  FOR EACH ROW
    WHEN (check_character_code_u(NEW."id", NEW."character_code", OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('character_code');



/******************************************************************************/
/******************************** country_code ********************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS country_code_insert ON "country_code";
DROP TRIGGER IF EXISTS country_code_update ON "country_code";

CREATE TRIGGER country_code_insert
BEFORE INSERT ON "country_code"
  FOR EACH ROW
    WHEN (check_country_code_i(NEW."country_code"))
EXECUTE PROCEDURE insert_violation_on_trigger('country_code');

CREATE TRIGGER country_code_update
BEFORE UPDATE ON "country_code"
  FOR EACH ROW
    WHEN (check_country_code_u(NEW."id", NEW."country_code", OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('country_code');



/******************************************************************************/
/******************************** language_code *******************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS language_code_insert ON "language_code";
DROP TRIGGER IF EXISTS language_code_update ON "language_code";

CREATE TRIGGER language_code_insert
BEFORE INSERT ON "language_code"
  FOR EACH ROW
    WHEN (check_language_code_i(NEW."language_code"))
EXECUTE PROCEDURE insert_violation_on_trigger('language_code');

CREATE TRIGGER language_code_update
BEFORE UPDATE ON "language_code"
  FOR EACH ROW
    WHEN (check_language_code_u(NEW."id", NEW."language_code", OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('language_code');



/******************************************************************************/
/************************* localized_character_string *************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS localized_character_string_insert ON
                      "localized_character_string";
DROP TRIGGER IF EXISTS localized_character_string_update ON
                      "localized_character_string";
DROP TRIGGER IF EXISTS localized_character_string_delete ON
                      "localized_character_string";

CREATE TRIGGER localized_character_string_insert
BEFORE INSERT ON "localized_character_string"
  FOR EACH ROW
    WHEN (localized_character_string_i(
                "constraints".get_current_project_schema(),
                NEW."pt_free_text_id"))
EXECUTE PROCEDURE insert_violation_on_trigger('localized_character_string');

CREATE TRIGGER localized_character_string_update
AFTER UPDATE ON "localized_character_string"
  FOR EACH ROW
    WHEN (localized_character_string_u(
                "constraints".get_current_project_schema(),
                NEW."pt_free_text_id", OLD."pt_free_text_id"))
EXECUTE PROCEDURE update_violation_on_trigger('localized_character_string');

CREATE TRIGGER localized_character_string_delete
AFTER DELETE ON "localized_character_string"
  FOR EACH ROW
    WHEN (localized_character_string_d(
                "constraints".get_current_project_schema(),
                NULL, OLD."pt_free_text_id"))
EXECUTE PROCEDURE delete_violation_on_trigger('localized_character_string');



/******************************************************************************/
/********************************* meta_data **********************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS meta_data_insert ON "meta_data";
DROP TRIGGER IF EXISTS meta_data_update ON "meta_data";

CREATE TRIGGER meta_data_insert
BEFORE INSERT ON "meta_data"
  FOR EACH ROW
    WHEN (check_meta_data_i("constraints".get_current_project_schema(),
                NEW."object_id", NEW."table_name", NEW."pk_column"))
EXECUTE PROCEDURE insert_violation_on_trigger('meta_data');

CREATE TRIGGER meta_data_update
BEFORE UPDATE ON "meta_data"
  FOR EACH ROW
    WHEN (check_meta_data_u("constraints".get_current_project_schema(),
                NEW."id", NEW."object_id", NEW."table_name", NEW."pk_column",
                OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('meta_data');



/******************************************************************************/
/******************************** multiplicity ********************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS multiplicity_insert ON "multiplicity";
DROP TRIGGER IF EXISTS multiplicity_update ON "multiplicity";

CREATE TRIGGER multiplicity_insert
BEFORE INSERT ON "multiplicity"
  FOR EACH ROW
    WHEN (check_multiplicity_i(NEW."min_value", NEW."max_value"))
EXECUTE PROCEDURE insert_violation_on_trigger('multiplicity');

CREATE TRIGGER multiplicity_update
BEFORE UPDATE ON "multiplicity"
  FOR EACH ROW
    WHEN (check_multiplicity_u(NEW."id", NEW."min_value", NEW."max_value",
                               OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('multiplicity');



/******************************************************************************/
/********************************* pt_locale **********************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS pt_locale_insert ON
                      "pt_locale";
DROP TRIGGER IF EXISTS pt_locale_update ON
                      "pt_locale";

CREATE TRIGGER pt_locale_insert
BEFORE INSERT ON "pt_locale"
  FOR EACH ROW
    WHEN (check_pt_locale_i("constraints".get_current_project_schema(),
                            NEW.language_code_id, NEW.country_code_id,
                            NEW.character_code_id))
EXECUTE PROCEDURE insert_violation_on_trigger('pt_locale');

CREATE TRIGGER pt_locale_update
AFTER UPDATE ON "pt_locale"
  FOR EACH ROW
    WHEN (check_pt_locale_u("constraints".get_current_project_schema(),
                            NEW."id", NEW.language_code_id, NEW.country_code_id,
                            NEW.character_code_id, OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('pt_locale');



/******************************************************************************/
/***************************** relationship_type ******************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS relationship_type_insert ON "relationship_type";
DROP TRIGGER IF EXISTS relationship_type_update ON "relationship_type";

CREATE TRIGGER relationship_type_insert
BEFORE INSERT ON "relationship_type"
  FOR EACH ROW
    WHEN (check_relationship_type_i(
              "constraints".get_current_project_schema(),
              NEW."reference_to", NEW."description"))
EXECUTE PROCEDURE insert_violation_on_trigger('relationship_type');

CREATE TRIGGER relationship_type_update
BEFORE UPDATE ON "relationship_type"
  FOR EACH ROW
    WHEN (check_relationship_type_u(
              "constraints".get_current_project_schema(), NEW."id",
              NEW."reference_to", NEW."description", OLD."id"))
EXECUTE PROCEDURE update_violation_on_trigger('relationship_type');



/******************************************************************************/
/**************************** topic_characteristic ****************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS topic_characteristic_insert ON "topic_characteristic";
DROP TRIGGER IF EXISTS topic_characteristic_update ON "topic_characteristic";

CREATE TRIGGER topic_characteristic_insert
BEFORE INSERT ON "topic_characteristic"
  FOR EACH ROW
    WHEN (check_topic_characteristic_i(
              "constraints".get_current_project_schema(), NEW."description",
              NEW."topic"))
EXECUTE PROCEDURE insert_violation_on_trigger('topic_characteristic');

CREATE TRIGGER topic_characteristic_update
BEFORE UPDATE ON "topic_characteristic"
  FOR EACH ROW
    WHEN (check_topic_characteristic_u(
              "constraints".get_current_project_schema(), NEW."id",
              NEW."description", NEW."topic", OLD."id", OLD."description"))
EXECUTE PROCEDURE update_violation_on_trigger('topic_characteristic');



/******************************************************************************/
/********************************* value_list *********************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS value_list_insert ON "value_list";
DROP TRIGGER IF EXISTS value_list_update ON "value_list";
DROP TRIGGER IF EXISTS value_list_delete ON "value_list";

CREATE TRIGGER value_list_insert
BEFORE UPDATE ON "value_list"
  FOR EACH ROW
    WHEN (check_value_list_i("constraints".get_current_project_schema(), 
                             NEW."name"))
EXECUTE PROCEDURE insert_violation_on_trigger('value_list');

CREATE TRIGGER value_list_update
BEFORE UPDATE ON "value_list"
  FOR EACH ROW
    WHEN (check_value_list_u("constraints".get_current_project_schema(),
                             NEW."id", NEW."name", OLD."id", OLD."name"))
EXECUTE PROCEDURE update_violation_on_trigger('value_list');

CREATE TRIGGER value_list_delete
BEFORE DELETE ON "value_list"
  FOR EACH ROW
    WHEN (check_value_list_d("constraints".get_current_project_schema(), 
                             OLD."name"))
EXECUTE PROCEDURE delete_violation_on_trigger('value_list');



/******************************************************************************/
/***************************** value_list_values ******************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS value_list_values_insert ON "value_list_values";
DROP TRIGGER IF EXISTS value_list_values_update ON "value_list_values";
DROP TRIGGER IF EXISTS value_list_values_delete ON "value_list_values";

CREATE TRIGGER value_list_values_insert
BEFORE INSERT ON "value_list_values"
  FOR EACH ROW
    WHEN (check_value_list_values_i(
              "constraints".get_current_project_schema(),
              NEW."belongs_to_value_list"))
EXECUTE PROCEDURE insert_violation_on_trigger('value_list_values');

CREATE TRIGGER value_list_values_update
BEFORE UPDATE ON "value_list_values"
  FOR EACH ROW
    WHEN (check_value_list_values_u(
              "constraints".get_current_project_schema(),
              NEW."id", NEW."belongs_to_value_list", OLD."id",
              OLD."belongs_to_value_list"))
EXECUTE PROCEDURE update_violation_on_trigger('value_list_values');

CREATE TRIGGER value_list_values_delete
BEFORE DELETE ON "value_list_values"
  FOR EACH ROW
    WHEN (check_value_list_values_d(
              "constraints".get_current_project_schema(),
              OLD."belongs_to_value_list"))
EXECUTE PROCEDURE delete_violation_on_trigger('value_list_values');



/******************************************************************************/
/******************* value_list_values_x_value_list_values ********************/
/******************************************************************************/

DROP TRIGGER IF EXISTS value_list_values_x_value_list_values_insert ON
                      "value_list_values_x_value_list_values";
DROP TRIGGER IF EXISTS value_list_values_x_value_list_values_update ON
                      "value_list_values_x_value_list_values";

CREATE TRIGGER value_list_values_x_value_list_values_insert
BEFORE INSERT ON "value_list_values_x_value_list_values"
  FOR EACH ROW
    WHEN (check_value_list_values_x_value_list_values_i(
              "constraints".get_current_project_schema(),
              NEW."value_list_values_1", NEW."value_list_values_2",
              NEW."relationship"))
EXECUTE PROCEDURE insert_violation_on_trigger(
                      'value_list_values_x_value_list_values');

CREATE TRIGGER value_list_values_x_value_list_values_update
BEFORE UPDATE ON "value_list_values_x_value_list_values"
  FOR EACH ROW
    WHEN (check_value_list_values_x_value_list_values_u(
              "constraints".get_current_project_schema(),
              NEW."value_list_values_1", NEW."value_list_values_2",
              NEW."relationship"))
EXECUTE PROCEDURE update_violation_on_trigger(
                      'value_list_values_x_value_list_values');



/******************************************************************************/
/************************** value_list_x_value_list ***************************/
/******************************************************************************/

DROP TRIGGER IF EXISTS value_list_x_value_list_insert ON
                      "value_list_x_value_list";
DROP TRIGGER IF EXISTS value_list_x_value_list_update ON
                      "value_list_x_value_list";

CREATE TRIGGER value_list_x_value_list_insert
BEFORE INSERT ON "value_list_x_value_list"
  FOR EACH ROW
    WHEN (check_value_list_x_value_list_i(
              "constraints".get_current_project_schema(),
              NEW."value_list_1", NEW."value_list_2", NEW."relationship"))
EXECUTE PROCEDURE insert_violation_on_trigger('value_list_x_value_list');

CREATE TRIGGER value_list_x_value_list_update
BEFORE UPDATE ON "value_list_x_value_list"
  FOR EACH ROW
    WHEN (check_value_list_x_value_list_u(
              "constraints".get_current_project_schema(),
              NEW."value_list_1", NEW."value_list_2", NEW."relationship"))
EXECUTE PROCEDURE update_violation_on_trigger('value_list_x_value_list');
