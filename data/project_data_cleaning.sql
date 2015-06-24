SET search_path TO "project", "public";
SET CLIENT_ENCODING TO "UTF8";


-- (1) find all value_lists with duplicated UUID in name
--     (1.1) end if no duplicates were found
-- (2) save UUID from first value_list
-- (3) save UUID from second value_list
-- (4) save UUID from name of second value_list
-- (5) replace the second UUID with the first UUID in the following table.column
--     (5.1) value_list_value.belongs_to_value_list
--     (5.2) value_list_x_value_list.value_list_1
--     (5.3) value_list_x_value_list.value_list_2
--     (5.4) attribute_type.domain
-- (6) delete the value_list with the second UUID
-- (7) delete the entry in localized_character_string with the second UUID
-- (8) go back to (1)
-- (9) print some statistics


/*
 * Performs a duplicate elimniation on the passed table name. This function
 * will do a recursion to run until all duplicated entries are eliminated.
 *
 * @state   experimental
 * @input   varchar: name of the schema the table contains to
 *          varchar: name of the table a duplicate elimination should be
 *                   performed at
 *          varchar: name of the column that contains the duplicated value
 *          varchar: name of the column that contains the id
 * @output  boolean: determines if duplicated entries were found (true) or not
 *                   (false)
 */
CREATE OR REPLACE FUNCTION public.remove_duplicates(varchar, varchar, varchar, varchar)
  RETURNS boolean AS $$
  DECLARE
    _schema_name ALIAS FOR $1;
    _table_name ALIAS FOR $2;
    _column_name ALIAS FOR $3;
    _column_id ALIAS FOR $4;
    _table_exists int;
    _tmp_result record;
    _counter integer := 0;
    _ids varchar ARRAY;
    _duplicated_name uuid;
    _rpl_result boolean;
    _substitutions varchar[] := CAST ('{}' AS varchar[]);
    _sub_table varchar;
    _sub_column varchar;
    _sub varchar;
  BEGIN
  
    -- set search path
    EXECUTE 'SET search_path TO '|| _schema_name ||', pg_catalog, public';
    
    -- check if the table exists by reading informations from the postgresql
    -- information schema
    SELECT count("table_name") INTO _table_exists
      FROM "information_schema"."tables"
     WHERE "table_schema" = _schema_name
       AND "table_name" = _table_name;
    
    -- check if a table was found
    IF _table_exists != 1 THEN
      RAISE NOTICE '#### Table "%" not found in schema "%" ####', _table_name, _schema_name;
      RETURN false;
    END IF;

    -- run as long duplicated entries were found
    RAISE NOTICE '## Looking for duplicated entries in column "%" of table "%" ##', _column_name, _table_name;
    
    -- find all entries in the table with duplicated UUID in the given column
    BEGIN
      FOR _tmp_result IN
        EXECUTE 'SELECT '|| _column_id ||' "id", '|| _column_name ||' "name"
                   FROM '|| _table_name ||'
                  WHERE '|| _column_name ||' = (
                        SELECT '|| _column_name ||'
                          FROM '|| _table_name ||'
                      GROUP BY '|| _column_name ||'
                        HAVING (count('|| _column_name ||') > 1)
                        LIMIT 1
                        );'
        LOOP
          -- save our ids in an array
          _ids[_counter] := _tmp_result.id;
          -- save the name of the duplicated entry
          _duplicated_name := _tmp_result.name;
          -- increment the counter
          _counter := _counter + 1;
          -- exit the loop if we collected two entries, because we will only
          -- compare two of them
          EXIT WHEN _counter = 2;
        END LOOP;
    EXCEPTION
      -- TODO: needed anymore?
      -- if more than one row was returned
      WHEN cardinality_violation THEN
        RAISE NOTICE '#### REWORK: More than one row was returned ####';
        RETURN false;
    END;
      
    IF (_counter != 2) THEN
      RAISE NOTICE '#### No more duplicated entries found in "%" ####', _table_name;
      RETURN false;
    END IF;
    
    RAISE NOTICE '## Found 2 duplicated entries: %, % ##', _ids[0], _ids[1];

    -- call different cleaning functions depending on the passed table_name
    CASE _table_name
      WHEN 'value_list' THEN
        -- call the replace function for value_list
        EXECUTE 'SELECT public.clean_value_list(
                   '|| quote_literal(_schema_name) ||',
                   '|| quote_literal(_ids[0]) ||',
                   '|| quote_literal(_ids[1]) ||')'
                   INTO _rpl_result;
        
      WHEN 'attribute_type' THEN
        -- call the replace function for attribute_type
        EXECUTE 'SELECT public.clean_attribute_type(
                   '|| quote_literal(_schema_name) ||',
                   '|| quote_literal(_ids[0]) ||',
                   '|| quote_literal(_ids[1]) ||')'
                   INTO _rpl_result;
      ELSE
        RAISE NOTICE '#### Cleaning for table "%" is not implemented! ####', _table_name;
        RETURN false;
    END CASE;
    
    -- recursive function call
    EXECUTE 'SELECT public.remove_duplicates(
               '|| quote_literal(_schema_name) ||',
               '|| quote_literal(_table_name) ||',
               '|| quote_literal(_column_id) ||',
               '|| quote_literal(_column_name) ||')'
               INTO _rpl_result;
    
    RETURN _rpl_result;
    
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * This will perform a cleaning on the table "value_list" and all of it's
 * associated tables. There will be a cleaning performed on the following
 * tables:
 *   - value_list_values (column belongs_to_value_list)
 *   - value_list_x_value_list (column value_list_1)
 *   - value_list_x_value_list (column value_list_2)
 *   - attribute_type (column domain)
 *
 * @state   experimental
 * @input   varchar: name of the schema the table contains to
 *          uuid:    first uuid that should rebplace the second uuid
 *          uuid:    secound uuid that should replace the first uuid
 * @output  boolean: permanently returns true (until now)
 */
CREATE OR REPLACE FUNCTION public.clean_value_list(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema_name ALIAS FOR $1;
    _id1 ALIAS FOR $2;
    _id2 ALIAS FOR $3;
    tmp varchar;
  BEGIN
    
    -- replace in value_list_values.belongs_to_value_list
    RAISE NOTICE '## Removing duplicated entries from column "belongs_to_value_list" in table "value_list_values" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "value_list_values"
                SET "belongs_to_value_list" = '|| quote_literal(_id1) ||'
              WHERE "belongs_to_value_list" = '|| quote_literal(_id2) ||';';
    
    -- replace in value_list_x_value_list.value_list_1
    RAISE NOTICE '## Removing duplicated entries from column "value_list_1" in table "value_list_x_value_list" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "value_list_x_value_list"
                SET "value_list_1" = '|| quote_literal(_id1) ||'
              WHERE "value_list_1" = '|| quote_literal(_id2) ||';';
    
    -- replace in value_list_x_value_list.value_list_2
    RAISE NOTICE '## Removing duplicated entries from column "value_list_2" in table "value_list_x_value_list" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "value_list_x_value_list"
                SET "value_list_2" = '|| quote_literal(_id1) ||'
              WHERE "value_list_2" = '|| quote_literal(_id2) ||';';
    
    -- disable constraint 49
    -- should raise no problems, because the new value_list will contain all the elements, that could possibly be part of the effected attribute_value
    ALTER TABLE "attribute_type" DISABLE TRIGGER "attribute_type_update";
    
    -- replace in attribute_type.domain
    RAISE NOTICE '## Removing duplicated entries from column "domain" in table "attribute_type" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "attribute_type"
                SET "domain" = '|| quote_literal(_id1) ||'
              WHERE "domain" = '|| quote_literal(_id2) ||';';

    -- enable constraint 49
    ALTER TABLE "attribute_type" ENABLE TRIGGER "attribute_type_update";
    
    -- delete from value_list
    RAISE NOTICE '## Delete entry from table "value_list" with the id "%" ##', _id2;
    EXECUTE 'DELETE FROM "value_list" WHERE "id" = '|| quote_literal(_id2) ||';';

    RAISE NOTICE '## Substitution of "%" with "%" for "value_list" completed ##', _id2, _id1;
    RETURN true;
    
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This will perform a cleaning on the table "attribute_type" and all of it's
 * associated tables. There will be a cleaning performed on the following
 * tables:
 *   - attribute_type_x_attribute_type (column attribute_type_1)
 *   - attribute_type_x_attribute_type (column attribute_type_2)
 *   - attribute_type_group (column attribute_type_id)
 *   - attribute_type_to_topic_characteristic (column attribute_type_id)
 *   - attribute_value (column attribute_type_id)
 *
 * @state   experimental
 * @input   varchar: name of the schema the table contains to
 *          uuid:    first uuid that should rebplace the second uuid
 *          uuid:    secound uuid that should replace the first uuid
 * @output  boolean: permanently returns true (until now)
 */
CREATE OR REPLACE FUNCTION public.clean_attribute_type(varchar, uuid, uuid)
  RETURNS boolean AS $$
  DECLARE
    _schema_name ALIAS FOR $1;
    _id1 ALIAS FOR $2;
    _id2 ALIAS FOR $3;
    _data_type_control boolean;
    tmp varchar;
  BEGIN

    -- check if the data types of both attribute types are the same
    IF (('SELECT "data_type" FROM "attribute_type" WHERE "id" = '|| quote_literal(_id1) ||';') !=
        ('SELECT "data_type" FROM "attribute_type" WHERE "id" = '|| quote_literal(_id2) ||';')) THEN
      RAISE NOTICE '#### Aborting! The data type of attribute_type "%" is different to the data type of attribute_type "%" ####', _id1, _id2;
      RETURN false;
    ELSE
      -- disable constraint 31 & 32
      ALTER TABLE "attribute_value" DISABLE TRIGGER "attribute_value_value_update";
    END IF;

    -- replace in attribute_value.attribute_type_id
    RAISE NOTICE '## Removing duplicated entries from column "attribute_type_id" in table "attribute_value" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "attribute_value"
                SET "attribute_type_id" = '|| quote_literal(_id1) ||'
              WHERE "attribute_type_id" = '|| quote_literal(_id2) ||';';

    -- enable constraint 31 & 32
    ALTER TABLE "attribute_value" ENABLE TRIGGER "attribute_value_value_update";
    
    -- replace in attribute_type_x_attribute_type.attribute_type_1
    RAISE NOTICE '## Removing duplicated entries from column "attribute_type_1" in table "attribute_type_x_attribute_type" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "attribute_type_x_attribute_type"
                SET "attribute_type_1" = '|| quote_literal(_id1) ||'
              WHERE "attribute_type_1" = '|| quote_literal(_id2) ||';';
    
    -- replace in attribute_type_x_attribute_type.attribute_type_2
    RAISE NOTICE '## Removing duplicated entries from column "attribute_type_2" in table "attribute_type_x_attribute_type" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "attribute_type_x_attribute_type"
                SET "attribute_type_2" = '|| quote_literal(_id1) ||'
              WHERE "attribute_type_2" = '|| quote_literal(_id2) ||';';
    
    -- replace in attribute_type_group.attribute_type_id
    RAISE NOTICE '## Removing duplicated entries from column "attribute_type_id" in table "attribute_type_group" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "attribute_type_group"
                SET "attribute_type_id" = '|| quote_literal(_id1) ||'
              WHERE "attribute_type_id" = '|| quote_literal(_id2) ||';';

    -- disable constraint 12
    -- should raise no problems, because the new value_list will contain all the elements, that could possibly be part of the effected attribute_value
    ALTER TABLE "attribute_type_to_topic_characteristic" DISABLE TRIGGER "attribute_type_to_topic_characteristic_update";
    
    -- replace in attribute_type_to_topic_characteristic.attribute_type_id
    RAISE NOTICE '## Removing duplicated entries from column "attribute_type_id" in table "attribute_type_to_topic_characteristic" by replacing "%" with "%" ##', _id2, _id1;
    EXECUTE 'UPDATE "attribute_type_to_topic_characteristic"
                SET "attribute_type_id" = '|| quote_literal(_id1) ||'
              WHERE "attribute_type_id" = '|| quote_literal(_id2) ||';';

    -- enable constraint 12
    ALTER TABLE "attribute_type_to_topic_characteristic" ENABLE TRIGGER "attribute_type_to_topic_characteristic_update";

    -- delete from attribute_type
    RAISE NOTICE '## Delete entry from table "attribute_type" with the id "%" ##', _id2;
    EXECUTE 'DELETE FROM "attribute_type" WHERE "id" = '|| quote_literal(_id2) ||';';
    
    RAISE NOTICE '## Substitution of "%" with "%" for "attribute_type" completed ##', _id2, _id1;
    RETURN true;
    
  END;
  $$ LANGUAGE 'plpgsql';

-- perform cleaning on value_list.name
SELECT public.remove_duplicates('project', 'value_list', 'name', 'id');

-- perform cleaning on attribute_type.name
SELECT public.remove_duplicates('project', 'attribute_type', 'name', 'id');
-- perform cleaning on topic_characteristc.description
-- perform cleaning on project.name

-- perform cleaning on localized_character_string

/*
SELECT "id", "name"
  FROM "attribute_type"
 WHERE "name" = (
                        SELECT "name"
                          FROM "attribute_type"
                      GROUP BY "name"
                        HAVING (count("name") > 1)
                        LIMIT 1
                        );
*/

--SELECT "data_type" FROM "attribute_type" WHERE "id" = '06974fbc-0be5-4ffa-8022-d8618121fda0' OR "id" = '3325c797-2352-42ed-b9a1-ce5a6a94367d';
--SELECT * FROM "value_list_values" WHERE "id" = 'c10ddb22-babd-437d-a04a-f44f068ff62b' OR "id" = '1fe822b7-c020-4adb-b400-a2401189b585';
--SELECT * FROM "localized_character_string" WHERE "pt_free_text_id" = 'af460423-307d-4279-a28e-39095e1d62e3' OR "pt_free_text_id" = 'd6ea0e09-3ea2-4ad7-8982-7115e67c77f4';
--SELECT "free_text" FROM "localized_character_string" WHERE "pt_free_text_id" = 'af460423-307d-4279-a28e-39095e1d62e3' OR "pt_free_text_id" = 'd6ea0e09-3ea2-4ad7-8982-7115e67c77f4';
--SELECT * FROM "localized_character_string" WHERE "pt_free_text_id" = '7fbf12dd-4cda-47af-8b9c-5258a49d71cc';

ROLLBACK;