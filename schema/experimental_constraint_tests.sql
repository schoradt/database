SET search_path TO "project_fd27a347-4e33-4ed7-aebc-eeff6dbf1054", "constraints", "public";
SET CLIENT_ENCODING TO "UTF8";
SET CLIENT_MIN_MESSAGES TO notice;


/******************************************************************************/
/*********************** functions for constraint tests ***********************/
/******************************************************************************/
/*
BEGIN;

DROP TABLE IF EXISTS testresults;

CREATE TABLE testresults(
  result text
);

COMMIT;

BEGIN;
*/
/*
 * Prints the passed text.
 *
 * @state   experimental
 * @input   text: message that should be printed
 */
CREATE OR REPLACE FUNCTION print(text)
  RETURNS void AS $$
  DECLARE
    _text ALIAS FOR $1;
  BEGIN
    RAISE NOTICE '%', _text;

  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Executes the passed SQL statement and raises a notice about the result. If
 * the statement passes the constraints true will be returned, otherwise false.
 * The second passed parameter will be used to print the expected test result.
 *
 * @state   experimental
 * @input   text: SQL statement
 *          boolean: expected test result
 * @return  boolean: true if statement performed successful, otherwise false
 */
CREATE OR REPLACE FUNCTION check_integrity(text, boolean)
  RETURNS boolean AS $$
  DECLARE
    _stmt ALIAS FOR $1;
    _exp ALIAS FOR $2;
    _errormsg text;
    _expectation text;
  BEGIN
    IF (_exp) THEN
      _expectation := 'expected OK';
    ELSE
      _expectation := 'expected Fail';
    END IF;

    -- check for an empty statement
    IF ((_stmt IS NULL) OR (_stmt = '')) THEN
      -- return error message if statement is empty
      --PERFORM print ('SQL Statement is empty');
      RAISE EXCEPTION 'SQL Statement is empty';
      RETURN NULL;
    ELSE
      -- execute the statement
      EXECUTE _stmt;
      --PERFORM print('OK ('|| _expectation ||')   >> '|| _stmt ||' <<');
      RAISE NOTICE 'OK (%)   >> % <<', _expectation, _stmt;
      RETURN true;
    END IF;
    EXCEPTION
      WHEN not_null_violation OR
           raise_exception OR
           invalid_text_representation OR
           unique_violation THEN
        GET STACKED DIAGNOSTICS _errormsg = MESSAGE_TEXT;
        --PERFORM print('Fail ('|| _expectation ||') >> '|| _errormsg ||' ['|| _stmt ||']');
        RAISE NOTICE 'Fail (%) >> % [%]', _expectation, _errormsg, _stmt;
        RETURN false;
  END;
  $$ LANGUAGE 'plpgsql';


/*
 * Runs the test on the constraints. This function will expect an array of
 * strings. The first part of the array has to be an boolean that determine if
 * the following statement passes (true) or fails (false) the constraints. This
 * will be necessary for calculating the test result.
 *
 * @state   experimental
 * @input   text: SQL statement
 */
CREATE OR REPLACE FUNCTION execute_tests(text[])
  RETURNS void AS $$
  DECLARE
    _array ALIAS FOR $1;
    _it text;
    _exp boolean;
    _stmt_exec boolean;
    _result boolean;
    _debug boolean := false;
    _counter integer := 0;
    _tests integer := 0;
    _fails integer := 0;
    _msg text;
  BEGIN

    -- get counter from last test runs
    --SELECT count(test) INTO _counter FROM testresults;

    FOREACH _it IN ARRAY _array
    LOOP
      BEGIN
        -- save the expected status
        _exp := CAST(_it AS boolean);

      EXCEPTION
        -- if the cast fails, we will have our statement in the array
        WHEN invalid_text_representation THEN

          -- set debug variable for test irrelevant statements
          IF (_it = 'debug') THEN
            _debug := true;
          ELSE
            -- ignore test result calculation for debug statements
            IF (_debug = true) THEN
              PERFORM check_integrity(_it, _exp);
              _debug := false;
            ELSE
              -- increment the counter for test runs
              _tests := _tests + 1;
              _counter := _counter +1;

              _stmt_exec := check_integrity(_it, _exp);

              -- save test run
              --INSERT INTO "testresults" VALUES (_counter, _it, _stmt_exec);

              -- execute the statement and compare to expected status
              IF (SELECT _stmt_exec != _exp) THEN
                -- increment fail counter
                _fails := _fails + 1;
                --PERFORM print('     >> Test failed');
                RAISE NOTICE '     >> Test failed';
              END IF;
            END IF;
          END IF;
      END;
    END LOOP;

    -- print result
    IF (_tests > 0) THEN
      --PERFORM print(E'\n---------------------------------------------\n## Tests executed: '|| _tests ||' ## Tests failed: '|| _fails ||' ##\n---------------------------------------------');
      RAISE NOTICE E'\n---------------------------------------------\n## Tests executed: % ## Tests failed: % ##\n---------------------------------------------', _tests, _fails;
    END IF;


  END;
  $$ LANGUAGE 'plpgsql';



/******************************************************************************/
/****************************** constraints tests *****************************/
/******************************************************************************/
-- multiplicity constraint tests 1, 2, 3
SELECT execute_tests ('{
  {false, INSERT INTO multiplicity VALUES (''7c5652b2-bf65-493f-b83c-57071bf211b3''\, ''-1''\, ''1'')},
  {false, INSERT INTO multiplicity VALUES (''3d0c1092-b56d-48df-9b2a-db0d45e5b9fd''\, ''0''\, ''0'')},
  {false, INSERT INTO multiplicity VALUES (''ae50f638-ea29-4a67-a680-c41ffee29325''\, ''2''\, ''1'')},
  {true, INSERT INTO multiplicity VALUES (''76e1fb24-529f-4c72-b335-de075f48c3db''\, ''0''\, ''1'')},
  {true, INSERT INTO multiplicity VALUES (''0078c69b-44be-4551-b036-930111017cde''\, ''1''\, ''2'')},
  {true, INSERT INTO multiplicity VALUES (''b599526e-7cdc-4f3e-8325-4283e43e6c9f''\, ''0''\, NULL)},
  {false, UPDATE multiplicity SET min_value = -1 WHERE id = ''76e1fb24-529f-4c72-b335-de075f48c3db''},
  {false, UPDATE multiplicity SET max_value = 0 WHERE id = ''76e1fb24-529f-4c72-b335-de075f48c3db''},
  {false, UPDATE multiplicity SET min_value = 2 WHERE id = ''76e1fb24-529f-4c72-b335-de075f48c3db''}
}');

-- localization constraint tests 4, 5, 44, 52
SELECT execute_tests ('{
  {false, INSERT INTO language_code VALUES (''06d10fb8-4665-4e2a-82d5-a0b6a4862f28''\, ''d'')},
  {false, UPDATE language_code SET language_code = ''d'' WHERE id = ''06d10fb8-4665-4e2a-82d5-a0b6a4862f28''},
  {false, INSERT INTO language_code VALUES (''06d10fb8-4665-4e2a-82d5-a0b6a4862f28''\, ''deu'')},
  {false, UPDATE language_code SET language_code = ''deu'' WHERE id = ''06d10fb8-4665-4e2a-82d5-a0b6a4862f28''},

  {false, INSERT INTO country_code VALUES (''036cf8ee-a2c0-45f3-89e4-1f2a32739a6d''\, ''D'')},
  {false, UPDATE country_code SET country_code = ''D'' WHERE id = ''036cf8ee-a2c0-45f3-89e4-1f2a32739a6d''},
  {false, INSERT INTO country_code VALUES (''036cf8ee-a2c0-45f3-89e4-1f2a32739a6d''\, ''DEU'')},
  {false, UPDATE country_code SET country_code = ''DEU'' WHERE id = ''036cf8ee-a2c0-45f3-89e4-1f2a32739a6d''},

  {false, INSERT INTO character_code VALUES(''c4d53f98-04af-4d04-9073-4f040a60c64b''\, ''UTF16'')},
  {false, UPDATE character_code SET character_code = ''UTF16'' WHERE id = ''c4d53f98-04af-4d04-9073-4f040a60c64b''},

  {false, INSERT INTO pt_locale VALUES (''c0d76ff3-a711-42af-920d-09132a287015''\, ''06d10fb8-4665-4e2a-82d5-a0b6a4862f28''\, ''036cf8ee-a2c0-45f3-89e4-1f2a32739a6d''\, ''c4d53f98-04af-4d04-9073-4f040a60c64b'')},
  {false, UPDATE pt_locale SET language_code_id = ''06d10fb8-4665-4e2a-82d5-a0b6a4862f28''\, country_code_id = ''036cf8ee-a2c0-45f3-89e4-1f2a32739a6d'' WHERE id = ''b36320a4-0c74-484e-8c5b-402693deee0f''}
}');

-- value_list constraint tests 46
SELECT execute_tests ('{
  {false, DELETE FROM value_list WHERE id = ''d145bf95-f6ea-4405-832b-55da75e825e5''},
  {false, UPDATE value_list SET name = ''6c9ea9b2-21ed-4aea-8603-ba72155ce9ba'' WHERE id = ''d145bf95-f6ea-4405-832b-55da75e825e5''}
}');

-- necessary test data
SELECT execute_tests ('{
  {debug, INSERT INTO localized_character_string VALUES (''7275c85b-1ea8-464e-9b08-4d2fe5928569''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''project1'')},
  {true, INSERT INTO localized_character_string VALUES (''7275c85b-1ea8-464e-9b08-4d2fe5928569''\, ''b36320a4-0c74-484e-8c5b-402693deee0f''\, ''project12'')},
  {false, UPDATE localized_character_string SET pt_free_text_id = ''18d89dfc-409d-4585-b858-d76fed5a5ac0'' WHERE pt_free_text_id = ''7275c85b-1ea8-464e-9b08-4d2fe5928569''},
  {debug, INSERT INTO localized_character_string VALUES (''d10249c7-0413-4cbc-9933-70989e6a2d29''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''project2'')},
  {debug, INSERT INTO localized_character_string VALUES (''cb45d075-a3b7-4443-9c46-a1d5d94c61e2''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''project3'')},
  {debug, INSERT INTO localized_character_string VALUES (''48e5cb7e-d251-44ae-8250-cd2eb5136751''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''name'')},
  {debug, INSERT INTO localized_character_string VALUES (''8cbd6610-09a5-42a9-a9e3-e5d332659f19''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''description'')},
  {debug, INSERT INTO localized_character_string VALUES (''3c281d89-5263-4bf2-9a79-9bec07d03fb5''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_text'')},
  {debug, INSERT INTO localized_character_string VALUES (''59aac854-a79f-4fb2-9471-d20b39989c8a''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_int'')},
  {debug, INSERT INTO localized_character_string VALUES (''2656f5e1-d644-4941-9dd2-4fd2a4e98b54''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_float'')},
  {debug, INSERT INTO localized_character_string VALUES (''b531644f-9cc6-4914-8f10-540fd8208a38''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_boolean'')},
  {debug, INSERT INTO localized_character_string VALUES (''fdbc8bf7-cbb1-4d2e-b575-af94589284e4''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_date'')},
  {debug, INSERT INTO localized_character_string VALUES (''8eb4c26b-55fe-4c14-9f16-66c4ad76b886''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_geom'')},
  {debug, INSERT INTO localized_character_string VALUES (''8695f1e4-d1e1-4b12-a1a0-ce7792d70752''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_value_geomz'')},
  {debug, INSERT INTO localized_character_string VALUES (''e24078d1-0c9d-41bb-933b-46053a0c1934''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_domain'')},
  {debug, INSERT INTO localized_character_string VALUES (''ac975303-df98-4879-8ebd-1262d79bba27''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_geom'')},
  {debug, INSERT INTO localized_character_string VALUES (''7d8d3bd6-0899-4a53-8e81-5f8dc487910f''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''at_geomz'')},
  {debug, INSERT INTO localized_character_string VALUES (''f9161a6e-e493-4d3d-a173-398669cb5ead''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''value_list'')},
  {debug, INSERT INTO localized_character_string VALUES (''e3f01556-bc0d-4393-bd95-7dace875330a''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''belongs to'')},
  {debug, INSERT INTO localized_character_string VALUES (''d1dbd47e-b5b6-4acf-a309-9c78059a8627''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''ta1'')},
  {debug, INSERT INTO localized_character_string VALUES (''7cec3b36-9175-4944-beb7-d632955b6c4b''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''ta2'')},
  {debug, INSERT INTO localized_character_string VALUES (''40cdfe36-f376-46ef-bb52-5d1106b3a9a6''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''ta3'')},
  {debug, INSERT INTO localized_character_string VALUES (''c070ee30-2baf-489a-bae3-48c2e76413c3''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''ta4'')},
  {debug, INSERT INTO localized_character_string VALUES (''ccad0097-3f8d-4c62-b196-ada57722d07b''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''topic1'')},
  {debug, INSERT INTO localized_character_string VALUES (''6c9ea9b2-21ed-4aea-8603-ba72155ce9ba''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''topic2'')},
  {debug, INSERT INTO localized_character_string VALUES (''014e73ad-de55-460e-98a3-6e6551af6757''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''topic3'')},
  {debug, INSERT INTO localized_character_string VALUES (''b38d6d50-8a9a-4115-83a1-d0ce7abc14bd''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''topic4'')},
  {debug, INSERT INTO localized_character_string VALUES (''3fa0e8a1-d0d4-4d4e-af18-6c7e6ff05e71''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''attributeTypeGroup1'')},
  {debug, INSERT INTO localized_character_string VALUES (''364e2cf2-3445-48f3-bc83-fe73f56353b4''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''attributeTypeGroup2'')},
  {debug, INSERT INTO localized_character_string VALUES (''bdb75f13-6252-4b94-a469-20be6de772c9''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''attributeTypeGroup3'')},
  {debug, INSERT INTO localized_character_string VALUES (''73688f87-7f1a-42fb-91e2-30a296c30cdc''\, ''c0d76ff3-a711-42af-920d-09132a287015''\, ''testvalue'')},
  {debug, INSERT INTO value_list VALUES (''6fbdf4c6-8c77-465b-8341-94494618355a''\, ''f9161a6e-e493-4d3d-a173-398669cb5ead''\, NULL)},
  {debug, INSERT INTO value_list_values VALUES (''08dd7610-b88b-44a6-9e3f-37119134ceb5''\, ''ccad0097-3f8d-4c62-b196-ada57722d07b''\, NULL\, true\, ''d145bf95-f6ea-4405-832b-55da75e825e5'')},
  {debug, INSERT INTO value_list_values VALUES (''0f1cfb04-1dc0-4c98-a561-3438239b37e3''\, ''6c9ea9b2-21ed-4aea-8603-ba72155ce9ba''\, NULL\, true\, ''d145bf95-f6ea-4405-832b-55da75e825e5'')},
  {debug, INSERT INTO value_list_values VALUES (''6c308cf9-638a-4b66-8f5e-40df943db0d8''\, ''014e73ad-de55-460e-98a3-6e6551af6757''\, NULL\, true\, ''d145bf95-f6ea-4405-832b-55da75e825e5'')},
  {debug, INSERT INTO value_list_values VALUES (''c7fa0633-452c-4e14-a483-3e916b5b08a5''\, ''b38d6d50-8a9a-4115-83a1-d0ce7abc14bd''\, NULL\, true\, ''d145bf95-f6ea-4405-832b-55da75e825e5'')},
  {debug, INSERT INTO value_list_values VALUES (''d96f2c47-2016-498d-a5ba-5bfbb63861bf''\, ''e3f01556-bc0d-4393-bd95-7dace875330a''\, NULL\, true\, ''85bc27a7-dfa5-4a79-adaf-1e8886053b2e'')}
}');

-- value_list constraint tests 46
SELECT execute_tests ('{
  {true, UPDATE value_list SET name = ''6c9ea9b2-21ed-4aea-8603-ba72155ce9ba'' WHERE id = ''6fbdf4c6-8c77-465b-8341-94494618355a''},
  {true, DELETE FROM value_list WHERE id = ''6fbdf4c6-8c77-465b-8341-94494618355a''},
  {debug, INSERT INTO value_list VALUES (''6fbdf4c6-8c77-465b-8341-94494618355a''\, ''f9161a6e-e493-4d3d-a173-398669cb5ead''\, NULL)}
}');

-- project constraint tests 36, 37, 38, 55
SELECT execute_tests ('{
  {true, INSERT INTO project VALUES (''7151517b-5553-44a7-9684-25d3ad1ba9aa''\, ''7275c85b-1ea8-464e-9b08-4d2fe5928569''\, ''8cbd6610-09a5-42a9-a9e3-e5d332659f19''\, NULL)},
  {false, INSERT INTO project VALUES (''9168ac12-17a1-4f69-8552-e65b6f78f0d5''\, ''d10249c7-0413-4cbc-9933-70989e6a2d29''\, ''8cbd6610-09a5-42a9-a9e3-e5d332659f19''\, NULL)},
  {true, INSERT INTO project VALUES (''9168ac12-17a1-4f69-8552-e65b6f78f0d5''\, ''d10249c7-0413-4cbc-9933-70989e6a2d29''\, ''8cbd6610-09a5-42a9-a9e3-e5d332659f19''\, ''7151517b-5553-44a7-9684-25d3ad1ba9aa'')},
  {false, INSERT INTO project VALUES (''894fa9ef-f8d7-40a5-9c4c-295f10b4d083''\, ''cb45d075-a3b7-4443-9c46-a1d5d94c61e2''\, ''8cbd6610-09a5-42a9-a9e3-e5d332659f19''\, ''894fa9ef-f8d7-40a5-9c4c-295f10b4d083'')},
  {false, UPDATE project SET subproject_of = NULL WHERE id = ''9168ac12-17a1-4f69-8552-e65b6f78f0d5''},
  {true, INSERT INTO project VALUES (''67eef998-09ab-47f6-b1e5-e55cb1397bd4''\, ''cb45d075-a3b7-4443-9c46-a1d5d94c61e2''\, ''8cbd6610-09a5-42a9-a9e3-e5d332659f19''\, ''9168ac12-17a1-4f69-8552-e65b6f78f0d5'')},
  {false, UPDATE project SET subproject_of = ''67eef998-09ab-47f6-b1e5-e55cb1397bd4'' WHERE id = ''9168ac12-17a1-4f69-8552-e65b6f78f0d5''},
  {false, UPDATE project SET subproject_of = ''9168ac12-17a1-4f69-8552-e65b6f78f0d5'' WHERE id = ''9168ac12-17a1-4f69-8552-e65b6f78f0d5''}
}');

-- attribute_type constraint tests 6, 7, 8, 9
SELECT execute_tests ('{
  {false, INSERT INTO attribute_type VALUES (''7c1a0125-3ab3-4ac3-b639-92743d3f2579''\, ''8695f1e4-d1e1-4b12-a1a0-ce7792d70752''\, NULL\, ''eaef7daa-8301-4dc1-a763-4edd3ae03b90''\, ''7ea709cf-d31d-4c40-bc7a-4e700ae3cb69''\, NULL)},
  {false, INSERT INTO attribute_type VALUES (''7c1a0125-3ab3-4ac3-b639-92743d3f2579''\, ''8695f1e4-d1e1-4b12-a1a0-ce7792d70752''\, NULL\, ''eaef7daa-8301-4dc1-a763-4edd3ae03b90''\, ''b5a32b37-4459-4050-bda0-fbe8d0d4a020''\, NULL)},
  {false, INSERT INTO attribute_type VALUES (''c2233a1d-9597-4b05-a311-30e0973727c5''\, ''3c281d89-5263-4bf2-9a79-9bec07d03fb5''\, NULL\, ''e04b99e5-b082-475a-96c5-780d0245593c''\, NULL\, NULL)},
  {false, INSERT INTO attribute_type VALUES (''c2233a1d-9597-4b05-a311-30e0973727c5''\, ''3c281d89-5263-4bf2-9a79-9bec07d03fb5''\, NULL\, ''7ea709cf-d31d-4c40-bc7a-4e700ae3cb69''\, NULL\, ''b3056afa-160f-45f2-803f-69e276496a56'')},
  {true, INSERT INTO attribute_type VALUES (''c2233a1d-9597-4b05-a311-30e0973727c5''\, ''3c281d89-5263-4bf2-9a79-9bec07d03fb5''\, NULL\, ''7ea709cf-d31d-4c40-bc7a-4e700ae3cb69''\, NULL\, NULL)},
  {true, INSERT INTO attribute_type VALUES (''2b2a2de3-d4a6-4e57-ada8-c51d8089fe2d''\, ''59aac854-a79f-4fb2-9471-d20b39989c8a''\, NULL\, ''c10ddb22-babd-437d-a04a-f44f068ff62b''\, ''b5a32b37-4459-4050-bda0-fbe8d0d4a020''\, NULL)},
  {true, INSERT INTO attribute_type VALUES (''ad82f6d0-5072-4b4b-a46d-201351785dfb''\, ''2656f5e1-d644-4941-9dd2-4fd2a4e98b54''\, NULL\, ''f5a22fd3-1b19-408c-8b6a-94f5d090d89f''\, ''b5a32b37-4459-4050-bda0-fbe8d0d4a020''\, NULL)},
  {true, INSERT INTO attribute_type VALUES (''6608a4ed-251d-4aa9-802d-ab33c43b6b29''\, ''b531644f-9cc6-4914-8f10-540fd8208a38''\, NULL\, ''e2545e48-b07e-4295-85b5-e68b7f82a0e8''\, NULL\, NULL)},
  {true, INSERT INTO attribute_type VALUES (''e4218529-5d1f-4a91-9854-ab38630847e5''\, ''fdbc8bf7-cbb1-4d2e-b575-af94589284e4''\, NULL\, ''1453be24-2b0c-4b40-a648-ecccf0f382a3''\, NULL\, NULL)},
  {true, INSERT INTO attribute_type VALUES (''7bbcc59a-9056-4d75-b2dc-a1bde36350dd''\, ''8eb4c26b-55fe-4c14-9f16-66c4ad76b886''\, NULL\, ''7c043561-8e6f-41a8-9290-fc81a2582037''\, NULL\, NULL)},
  {true, INSERT INTO attribute_type VALUES (''7c1a0125-3ab3-4ac3-b639-92743d3f2579''\, ''8695f1e4-d1e1-4b12-a1a0-ce7792d70752''\, NULL\, ''eaef7daa-8301-4dc1-a763-4edd3ae03b90''\, NULL\, NULL)},
  {false, UPDATE attribute_type SET unit = ''7ea709cf-d31d-4c40-bc7a-4e700ae3cb69'' WHERE id = ''7c1a0125-3ab3-4ac3-b639-92743d3f2579''},
  {false, UPDATE attribute_type SET unit = ''b5a32b37-4459-4050-bda0-fbe8d0d4a020'' WHERE id = ''7c1a0125-3ab3-4ac3-b639-92743d3f2579''},
  {false, UPDATE attribute_type SET data_type = ''e04b99e5-b082-475a-96c5-780d0245593c'' WHERE id = ''c2233a1d-9597-4b05-a311-30e0973727c5''},
  {false, UPDATE attribute_type SET domain = ''b3056afa-160f-45f2-803f-69e276496a56'' WHERE id = ''c2233a1d-9597-4b05-a311-30e0973727c5''}
}');

-- topic_characteristic constraint tests 15
SELECT execute_tests ('{
  {false, INSERT INTO topic_characteristic VALUES (''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''d1dbd47e-b5b6-4acf-a309-9c78059a8627''\, ''b5a32b37-4459-4050-bda0-fbe8d0d4a020''\, ''7151517b-5553-44a7-9684-25d3ad1ba9aa'')},
  {true, INSERT INTO topic_characteristic VALUES (''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''d1dbd47e-b5b6-4acf-a309-9c78059a8627''\, ''08dd7610-b88b-44a6-9e3f-37119134ceb5''\, ''7151517b-5553-44a7-9684-25d3ad1ba9aa'')},
  {true, INSERT INTO topic_characteristic VALUES (''4f720d76-df60-41e5-9548-9fec988a05ca''\, ''7cec3b36-9175-4944-beb7-d632955b6c4b''\, ''0f1cfb04-1dc0-4c98-a561-3438239b37e3''\, ''7151517b-5553-44a7-9684-25d3ad1ba9aa'')},
  {true, INSERT INTO topic_characteristic VALUES (''767f7e0b-c861-42b1-93b3-a4f5468ef068''\, ''40cdfe36-f376-46ef-bb52-5d1106b3a9a6''\, ''6c308cf9-638a-4b66-8f5e-40df943db0d8''\, ''7151517b-5553-44a7-9684-25d3ad1ba9aa'')},
  {true, INSERT INTO topic_characteristic VALUES (''a05b9683-0b3b-4e93-b9e2-e6686f89ecba''\, ''c070ee30-2baf-489a-bae3-48c2e76413c3''\, ''c7fa0633-452c-4e14-a483-3e916b5b08a5''\, ''7151517b-5553-44a7-9684-25d3ad1ba9aa'')},
  {false, UPDATE topic_characteristic SET topic = ''b5a32b37-4459-4050-bda0-fbe8d0d4a020'' WHERE id = ''ad8f7708-e861-4d64-a600-bc21959f2d54''}
}');

-- attribut_type_group constraint tests 50, 51
SELECT execute_tests ('{
  {false, INSERT INTO attribute_type_group VALUES (''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''3fa0e8a1-d0d4-4d4e-af18-6c7e6ff05e71''\, NULL\, ''eb5e8714-0b62-4076-b227-9c90a7c64933'')},
  {true, INSERT INTO attribute_type_group VALUES (''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''3fa0e8a1-d0d4-4d4e-af18-6c7e6ff05e71''\, NULL\, NULL)},
  {true, INSERT INTO attribute_type_group VALUES (''6ebc61d9-8aeb-4e17-84f0-84911a006bcf''\, ''364e2cf2-3445-48f3-bc83-fe73f56353b4''\, NULL\, ''eb5e8714-0b62-4076-b227-9c90a7c64933'')},
  {false, UPDATE attribute_type_group SET subgroup_of = ''6ebc61d9-8aeb-4e17-84f0-84911a006bcf'' WHERE id = ''eb5e8714-0b62-4076-b227-9c90a7c64933''},
  {false, UPDATE attribute_type_group SET subgroup_of = ''eb5e8714-0b62-4076-b227-9c90a7c64933'' WHERE id = ''eb5e8714-0b62-4076-b227-9c90a7c64933''}
}');

-- relationship_type constraint tests 13, 14
SELECT execute_tests ('{
  {false, INSERT INTO relationship_type VALUES (''aa5b71af-7409-41b0-89e5-65fdfaaa66b2''\, ''d96f2c47-2016-498d-a5ba-5bfbb63861bf''\, ''d96f2c47-2016-498d-a5ba-5bfbb63861bf'')},
  {false, INSERT INTO relationship_type VALUES (''aa5b71af-7409-41b0-89e5-65fdfaaa66b2''\, ''08dd7610-b88b-44a6-9e3f-37119134ceb5''\, ''08dd7610-b88b-44a6-9e3f-37119134ceb5'')},
  {true, INSERT INTO relationship_type VALUES (''aa5b71af-7409-41b0-89e5-65fdfaaa66b2''\, ''08dd7610-b88b-44a6-9e3f-37119134ceb5''\, ''d96f2c47-2016-498d-a5ba-5bfbb63861bf'')},
  {false, UPDATE relationship_type SET reference_to = ''d96f2c47-2016-498d-a5ba-5bfbb63861bf'' WHERE id = ''aa5b71af-7409-41b0-89e5-65fdfaaa66b2''},
  {false, UPDATE relationship_type SET description = ''08dd7610-b88b-44a6-9e3f-37119134ceb5'' WHERE id = ''aa5b71af-7409-41b0-89e5-65fdfaaa66b2''}
}');

-- attribute_type_group_to_topic_characteristic constraint tests 54
SELECT execute_tests ('{
  {true, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''62675c36-d7eb-4256-856f-01dc08a19676''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL)},
  {false, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''96252651-b17f-4c85-98f5-bc74a29d1573''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL)},
  {false, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''2d4ea364-849d-484d-bbb5-84d82cf0acf4''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL)},
  {true, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''f7460003-45c9-4d2b-b66e-710209cdce70''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, 1)},
  {false, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''cb9a27c3-c753-4e7e-8f4d-8db0680c1573''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, 1)},
  {false, UPDATE attribute_type_group_to_topic_characteristic SET \"order\" = NULL WHERE id = ''f7460003-45c9-4d2b-b66e-710209cdce70''},
  {false, UPDATE attribute_type_group_to_topic_characteristic SET \"order\" = 1 WHERE id = ''62675c36-d7eb-4256-856f-01dc08a19676''},
  {true, UPDATE attribute_type_group_to_topic_characteristic SET \"order\" = 1\, topic_characteristic_id = ''4f720d76-df60-41e5-9548-9fec988a05ca'' WHERE id = ''f7460003-45c9-4d2b-b66e-710209cdce70''}
}');

-- attribute_type_to_attribute_type_group constraint tests 11, 53
/*
SELECT execute_tests ('{
  {true, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''62675c36-d7eb-4256-856f-01dc08a19676''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL)},
  {false, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''96252651-b17f-4c85-98f5-bc74a29d1573''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL)},
  {false, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''2d4ea364-849d-484d-bbb5-84d82cf0acf4''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL)},
  {true, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''f7460003-45c9-4d2b-b66e-710209cdce70''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, 1)},
  {false, INSERT INTO attribute_type_group_to_topic_characteristic VALUES (''cb9a27c3-c753-4e7e-8f4d-8db0680c1573''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''0078c69b-44be-4551-b036-930111017cde''\, 1)},
  {false, UPDATE attribute_type_group_to_topic_characteristic SET \"order\" = NULL WHERE id = ''f7460003-45c9-4d2b-b66e-710209cdce70''},
  {false, UPDATE attribute_type_group_to_topic_characteristic SET \"order\" = 1 WHERE id = ''62675c36-d7eb-4256-856f-01dc08a19676''},
  {true, UPDATE attribute_type_group_to_topic_characteristic SET \"order\" = 1\, topic_characteristic_id = ''4f720d76-df60-41e5-9548-9fec988a05ca'' WHERE id = ''f7460003-45c9-4d2b-b66e-710209cdce70''}
}');
*/
-- DEBUG
/*
SELECT execute_tests ('{
  {debug, INSERT INTO attribute_type_to_attribute_type_group VALUES (''92fcaa7f-ccc9-4a88-aa07-f9a6c29e8ef4''\, ''c2233a1d-9597-4b05-a311-30e0973727c5''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, ''62675c36-d7eb-4256-856f-01dc08a19676''\, ''0078c69b-44be-4551-b036-930111017cde''\, NULL\, NULL)},
  {debug, INSERT INTO topic_instance VALUES (''b18d0b71-b601-43b1-b93e-307cfbfce4f5''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54'')},
  {true, INSERT INTO attribute_value_value VALUES (''bb754008-3038-4b9d-8fc2-cb6f074282d5''\, ''92fcaa7f-ccc9-4a88-aa07-f9a6c29e8ef4''\, ''b18d0b71-b601-43b1-b93e-307cfbfce4f5''\, ''73688f87-7f1a-42fb-91e2-30a296c30cdc'')}
}');
*/
-- attribute_type_to_attribute_type_group constraint tests 11
/*
SELECT execute_tests ('{
  {true, INSERT INTO attribute_type_to_attribute_type_group VALUES (''6f19657a-8590-4d91-9762-7e713052bfd5''\, ''ad8f7708-e861-4d64-a600-bc21959f2d54''\, ''eb5e8714-0b62-4076-b227-9c90a7c64933''\, )}
}');
*/

--SELECT * FROM "testresults";




-- correct insert
--SELECT check_integrity ('INSERT INTO character_code VALUES ('|| quote_literal('c4d53f98-04af-4d04-9073-4f040a60c64b') ||', '|| quote_literal('UTF8') ||')');


--SELECT check_integrity ('INSERT INTO "language_code" ("language_code") VALUES ('|| quote_literal('xx') ||')');

-- (32) Der Datentyp von "attribute_value_value" muss dem entsprechen, der im Attribut "data_type" des zugehörigen Attributtyps spezifiziert ist.

-- (35) Die Spalte "domain" (FK auf "value_list_values") in der Relation "attribute_value_domain" darf nur dann einen Eintrag haben, wenn das Attribut "domain" der zugehörigen Relation "attribute_type" ebenfalls einen Eintrag hat. Wenn beide Attribute nicht NULL sind, dann muss der Wert von "value_list", der den beiden Einträgen in "value_list_values" zugeordnet ist, identisch sein und der Datentyp des Attributtyps mit dem Datentyp von "value_list_value" übereinstimmen.


----------------------
-- Korrekte INSERTs --
----------------------
/*
INSERT INTO "multiplicity" VALUES (create_uuid(), 5, 10);
INSERT INTO "multiplicity" VALUES (create_uuid(), 0, 1);
-- Diese Werte dienen als Standardlokalisierung
INSERT INTO "language_code" VALUES (create_uuid(), 'zxx');
INSERT INTO "language_code" VALUES (create_uuid(), 'deu');
INSERT INTO "country_code" ("country_code") VALUES ('DE');
INSERT INTO "character_code" ("character_code") VALUES ('UTF8');
-- Sprach-, Land- und Zeichenkodierungen zu pt_locale zusammenführen
INSERT INTO "pt_locale" SELECT create_uuid(), "sk"."id", NULL, "zk"."id" FROM "language_code" "sk", "character_code" "zk" WHERE "sk"."language_code" = 'zxx' AND "zk"."character_code" = 'UTF8';
INSERT INTO "pt_locale" SELECT create_uuid(), "sk"."id", "lk"."id", "zk"."id" FROM "language_code" "sk", "country_code" "lk", "character_code" "zk" WHERE "sk"."language_code" = 'deu' AND "lk"."country_code" = 'DE' AND "zk"."character_code" = 'UTF8';
-- Namen der Wertelisten in LocalizedCharacterString einfügen
SELECT add_localized_character_string('WL_Thema');
SELECT add_localized_character_string('vl_topic', 'eng', 'GB', 'UTF8', 'WL_Thema', 'deu', 'DE', 'UTF8');
SELECT add_localized_character_string('WL_Einheit');
SELECT add_localized_character_string('vl_unit', 'eng', 'GB', 'UTF8', 'WL_Einheit', 'deu', 'DE', 'UTF8');
SELECT add_localized_character_string('WL_Datentyp');
SELECT add_localized_character_string('vl_data_type', 'eng', 'GB', 'UTF8', 'WL_Datentyp', 'deu', 'DE', 'UTF8');
SELECT add_localized_character_string('WL_Beziehungstyp');
SELECT add_localized_character_string('vl_relationship_type', 'eng', 'GB', 'UTF8', 'WL_Beziehungstyp', 'deu', 'DE', 'UTF8');
SELECT add_localized_character_string('WL_AttributtypGruppe');
SELECT add_localized_character_string('vl_attribute_type_group', 'eng', 'GB', 'UTF8', 'WL_AttributtypGruppe', 'deu', 'DE', 'UTF8');
SELECT add_localized_character_string('WL_SKOSBeziehungsart');
SELECT add_localized_character_string('vl_skos_relationship', 'eng', 'GB', 'UTF8', 'WL_SKOSBeziehungsart', 'deu', 'DE', 'UTF8');
-- Wertelisten erstellen
SELECT add_value_list('vl_topic', NULL, 'eng', 'GB', 'UTF8');
SELECT add_value_list('vl_unit', NULL, 'eng', 'GB', 'UTF8');
SELECT add_value_list('vl_data_type', NULL, 'eng', 'GB', 'UTF8');
SELECT add_value_list('vl_relationship_type', NULL, 'eng', 'GB', 'UTF8');
SELECT add_value_list('vl_attribute_type_group', NULL, 'eng', 'GB', 'UTF8');
SELECT add_value_list('vl_skos_relationship', NULL, 'eng', 'GB', 'UTF8');
-- Namen für WertelistenWerte in LocalizedCharacterString einfügen
SELECT add_localized_character_string('km', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('km²', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('m', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('m²', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('cm', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('cm²', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('mm', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('mm²', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('mg', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('g', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('kg', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('t', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('ml', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('cl', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('l', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('varchar', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('integer', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('date', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('geometry(Geometry,4326)', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('boolean', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('float', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('text', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('true', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('false', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('hat Teil');
SELECT add_localized_character_string('ist Teil von');
SELECT add_localized_character_string('skos:semanticRelation', 'eng', 'GB', 'UTF8');
SELECT add_localized_character_string('skos:broader', 'eng', 'GB', 'UTF8');
SELECT add_localized_character_string('skos:narrower', 'eng', 'GB', 'UTF8');
SELECT add_localized_character_string('skos:related', 'eng', 'GB', 'UTF8');
SELECT add_localized_character_string('skos:broaderTransitive', 'eng', 'GB', 'UTF8');
SELECT add_localized_character_string('skos:narrowerTransitive', 'eng', 'GB', 'UTF8');
-- WertelistenWerte hinfzufügen und den entsprechenden Wertelisten zuordnen
SELECT add_value_list_value('km', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('km²', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('m', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('m²', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('cm', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('cm²', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('mm', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('mm²', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('mg', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('g', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('kg', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('t', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('ml', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('cl', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('l', NULL, TRUE, 'vl_unit', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('varchar', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('integer', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('date', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('geometry(Geometry,4326)', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('boolean', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('float', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('text', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('true', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('false', NULL, TRUE, 'vl_data_type', 'zxx', NULL, 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('hat Teil', NULL, TRUE, 'vl_relationship_type', 'deu', 'DE', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('ist Teil von', NULL, TRUE, 'vl_relationship_type', 'deu', 'DE', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('skos:semanticRelation', NULL, TRUE, 'vl_skos_relationship', 'eng', 'GB', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('skos:broader', NULL, TRUE, 'vl_skos_relationship', 'eng', 'GB', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('skos:narrower', NULL, TRUE, 'vl_skos_relationship', 'eng', 'GB', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('skos:related', NULL, TRUE, 'vl_skos_relationship', 'eng', 'GB', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('skos:broaderTransitive', NULL, TRUE, 'vl_skos_relationship', 'eng', 'GB', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('skos:narrowerTransitive', NULL, TRUE, 'vl_skos_relationship', 'eng', 'GB', 'UTF8', 'eng', 'GB', 'UTF8');

-- Testwerte
SELECT add_localized_character_string('Name');
SELECT add_localized_character_string('Beschreibung');
SELECT add_localized_character_string('Kampagne');
SELECT add_localized_character_string('Anzahl');
SELECT add_localized_character_string('Breite');
SELECT add_localized_character_string('vollständig erfasst');
SELECT add_localized_character_string('erfasst am');
SELECT add_localized_character_string('Geometrie');
SELECT add_localized_character_string('Metadaten');
SELECT add_localized_character_string('Bauwerk');
SELECT add_localized_character_string('Bauwerksteil');
SELECT add_localized_character_string('Baalbek');
SELECT add_localized_character_string('Rotes Haus');
SELECT add_localized_character_string('Bauwerk in Baalbek');
SELECT add_localized_character_string('Bauwerksteil in Baalbek');
SELECT add_localized_character_string('Intervall');
SELECT add_localized_character_string('Farben');
SELECT add_localized_character_string('Wahrheitswerte');
SELECT add_localized_character_string('Materialien');
SELECT add_localized_character_string('Rot');
SELECT add_localized_character_string('Blau');
SELECT add_localized_character_string('Gelb');
SELECT add_localized_character_string('Holz');
SELECT add_localized_character_string('Stein');
SELECT add_localized_character_string('Eisen');
SELECT add_localized_character_string('2003', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('Herbst 2003');
SELECT add_localized_character_string('100', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('200', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('300', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('1.000', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('1,000', 'zxx', NULL, 'UTF8');
SELECT add_localized_character_string('2012-12-01', 'zxx', NULL, 'UTF8');
-- WL Thema
SELECT add_value_list_value('Bauwerk', NULL, TRUE, 'vl_topic', 'deu', 'DE', 'UTF8', 'eng', 'GB', 'UTF8');
SELECT add_value_list_value('Bauwerksteil', NULL, TRUE, 'vl_topic', 'deu', 'DE', 'UTF8', 'eng', 'GB', 'UTF8');
-- WL_Werteliste
SELECT add_value_list('Intervall');
SELECT add_value_list('Farben');
SELECT add_value_list('Wahrheitswerte');
SELECT add_value_list('Materialien');
-- WL_Werteliste_x_WL_Werteliste
INSERT INTO "value_list_x_value_list" VALUES (get_value_list_id('Wahrheitswerte', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_list_id('Intervall', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_x_value_list" VALUES (get_value_list_id('Wahrheitswerte', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_list_id('Materialien', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_x_value_list" VALUES (get_value_list_id('Materialien', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_list_id('Farben', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_x_value_list" VALUES (get_value_list_id('Intervall', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_list_id('Materialien', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_x_value_list" VALUES (get_value_list_id('Farben', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_list_id('Wahrheitswerte', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('skos:related', 'vl_skos_relationship'));
INSERT INTO "value_list_x_value_list" VALUES (get_value_list_id('Wahrheitswerte', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_list_id('Farben', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('skos:related', 'vl_skos_relationship'));
-- WL_WertelistenWerte
SELECT add_value_list_value('100', NULL, TRUE, 'Intervall', 'zxx', NULL, 'UTF8');
SELECT add_value_list_value('200', NULL, TRUE, 'Intervall', 'zxx', NULL, 'UTF8');
SELECT add_value_list_value('300', NULL, TRUE, 'Intervall', 'zxx', NULL, 'UTF8');
SELECT add_value_list_value('Rot', NULL, TRUE, 'Farben');
SELECT add_value_list_value('Blau', NULL, TRUE, 'Farben');
SELECT add_value_list_value('Gelb', NULL, TRUE, 'Farben');
SELECT add_value_list_value('true', NULL, TRUE, 'Wahrheitswerte', 'zxx', NULL, 'UTF8');
SELECT add_value_list_value('false', NULL, TRUE, 'Wahrheitswerte', 'zxx', NULL, 'UTF8');
SELECT add_value_list_value('Holz', NULL, TRUE, 'Materialien');
SELECT add_value_list_value('Stein', NULL, TRUE, 'Materialien');
SELECT add_value_list_value('Eisen', NULL, TRUE, 'Materialien');
-- WL_WertelistenWerte_x_WL_WertelistenWerte
INSERT INTO "value_list_values_x_value_list_values" VALUES (get_value_id_from_value_list('100', 'Intervall'), get_value_id_from_value_list('Rot', 'Farben'), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_values_x_value_list_values" VALUES (get_value_id_from_value_list('Rot', 'Farben'), get_value_id_from_value_list('Blau', 'Farben'), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_values_x_value_list_values" VALUES (get_value_id_from_value_list('Blau', 'Farben'), get_value_id_from_value_list('200', 'Intervall'), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_values_x_value_list_values" VALUES (get_value_id_from_value_list('100', 'Intervall'), get_value_id_from_value_list('Blau', 'Farben'), get_value_id_from_value_list('skos:broader', 'vl_skos_relationship'));
INSERT INTO "value_list_values_x_value_list_values" VALUES (get_value_id_from_value_list('200', 'Intervall'), get_value_id_from_value_list('Rot', 'Farben'), get_value_id_from_value_list('skos:related', 'vl_skos_relationship'));
INSERT INTO "value_list_values_x_value_list_values" VALUES (get_value_id_from_value_list('Rot', 'Farben'), get_value_id_from_value_list('200', 'Intervall'), get_value_id_from_value_list('skos:related', 'vl_skos_relationship'));
-- Attributtyp
INSERT INTO "attribute_type" VALUES (create_uuid(), get_pt_free_text_id('Kampagne', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('varchar', 'vl_data_type'), NULL, NULL);
INSERT INTO "attribute_type" VALUES (create_uuid(), get_pt_free_text_id('Anzahl', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('integer', 'vl_data_type'), NULL, get_value_list_id('Intervall', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "attribute_type" VALUES (create_uuid(), get_pt_free_text_id('Breite', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('float', 'vl_data_type'), NULL, NULL);
INSERT INTO "attribute_type" VALUES (create_uuid(), get_pt_free_text_id('vollständig erfasst', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('boolean', 'vl_data_type'), NULL, get_value_list_id('Wahrheitswerte', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "attribute_type" VALUES (create_uuid(), get_pt_free_text_id('erfasst am', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('date', 'vl_data_type'), NULL, NULL);
INSERT INTO "attribute_type" VALUES (create_uuid(), get_pt_free_text_id('Geometrie', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('geometry(Geometry,4326)', 'vl_data_type'), NULL, NULL);
-- Attributtypgruppe
SELECT add_value_list_value('Metadaten', NULL, TRUE, 'vl_attribute_type_group', 'deu', 'DE', 'UTF8', 'eng', 'GB', 'UTF8');
-- Attributtypen gruppieren
-- TODO
-- Projekt
INSERT INTO "project" VALUES (create_uuid(), get_pt_free_text_id('Baalbek', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), NULL);
INSERT INTO "project" VALUES (create_uuid(), get_pt_free_text_id('Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_pt_free_text_id('Beschreibung', get_pt_locale_id('deu', 'DE', 'UTF8')), get_project_id('Baalbek', get_pt_locale_id('deu', 'DE', 'UTF8')));
-- Themenausprägung
INSERT INTO "topic_characteristic" VALUES (create_uuid(), get_pt_free_text_id('Bauwerk in Baalbek', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('Bauwerk', 'vl_topic'), get_project_id('Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_characteristic" VALUES (create_uuid(), get_pt_free_text_id('Bauwerksteil in Baalbek', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('Bauwerksteil', 'vl_topic'), get_project_id('Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')));
-- Attributtypen_zur_Themenauspraegung
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('vollständig erfasst', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), get_value_id_from_value_list('false', 'Wahrheitswerte'));
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('erfasst am', 'date', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Anzahl', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), get_value_id_from_value_list('100', 'Intervall'));
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Geometrie', 'geometry(Geometry,4326)', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerksteil in Baalbek', 'Bauwerksteil', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Kampagne', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerksteil in Baalbek', 'Bauwerksteil', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Anzahl', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), get_value_id_from_value_list('200', 'Intervall'));
INSERT INTO "attribute_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerksteil in Baalbek', 'Bauwerksteil', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Breite', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(5, 10), NULL);
-- Themeninstanz
INSERT INTO "topic_instance" VALUES (create_uuid(), get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_instance" VALUES (create_uuid(), get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_instance" VALUES (create_uuid(), get_topic_characteristic_id('Bauwerksteil in Baalbek', 'Bauwerksteil', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_instance" VALUES (create_uuid(), get_topic_characteristic_id('Bauwerksteil in Baalbek', 'Bauwerksteil', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')));
-- Beziehungstyp
INSERT INTO "relationship_type" VALUES (create_uuid(), get_value_id_from_value_list('Bauwerk', 'vl_topic'), get_value_id_from_value_list('hat Teil', 'vl_relationship_type'));
INSERT INTO "relationship_type" VALUES (create_uuid(), get_value_id_from_value_list('Bauwerk', 'vl_topic'), get_value_id_from_value_list('ist Teil von', 'vl_relationship_type'));
INSERT INTO "relationship_type" VALUES (create_uuid(), get_value_id_from_value_list('Bauwerksteil', 'vl_topic'), get_value_id_from_value_list('hat Teil', 'vl_relationship_type'));
-- Beziehungstypen_zur_Themenauspraegung
INSERT INTO "relationship_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_relationship_type_id('hat Teil', 'Bauwerk', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(0, 1));
INSERT INTO "relationship_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_relationship_type_id('ist Teil von', 'Bauwerk', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(0, 1));
INSERT INTO "relationship_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerksteil in Baalbek', 'Bauwerksteil', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_relationship_type_id('ist Teil von', 'Bauwerk', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(0, 1));
INSERT INTO "relationship_type_to_topic_characteristic" VALUES (get_topic_characteristic_id('Bauwerk in Baalbek', 'Bauwerk', 'Rotes Haus', get_pt_locale_id('deu', 'DE', 'UTF8')), get_relationship_type_id('hat Teil', 'Bauwerksteil', get_pt_locale_id('deu', 'DE', 'UTF8')), get_multiplicity(0, 1));
-- Themeninstanz_x_Themeninstanz (Offset 0 und 1 (Bauwerk) / 2 und 3 (Bauwerksteil) gehören jeweils zur selben Themenausprägung)
INSERT INTO "topic_instance_x_topic_instance" VALUES (create_uuid(), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 1), get_relationship_type_id('hat Teil', 'Bauwerk', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_instance_x_topic_instance" VALUES (create_uuid(), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 1), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), get_relationship_type_id('ist Teil von', 'Bauwerk', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_instance_x_topic_instance" VALUES (create_uuid(), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 2), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), get_relationship_type_id('ist Teil von', 'Bauwerk', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "topic_instance_x_topic_instance" VALUES (create_uuid(), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 3), get_relationship_type_id('hat Teil', 'Bauwerksteil', get_pt_locale_id('deu', 'DE', 'UTF8')));
-- Attributwerte
INSERT INTO "attribute_value_value" VALUES (create_uuid(), get_attribute_type_id('Kampagne', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 2), get_pt_free_text_id('2003', get_pt_locale_id('zxx', NULL, 'UTF8')));
INSERT INTO "attribute_value_value" VALUES (create_uuid(), get_attribute_type_id('Kampagne', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 3), get_pt_free_text_id('Herbst 2003', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "attribute_value_value" VALUES (create_uuid(), get_attribute_type_id('Breite', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 2), get_pt_free_text_id('1.000', get_pt_locale_id('zxx', NULL, 'UTF8')));
INSERT INTO "attribute_value_value" VALUES (create_uuid(), get_attribute_type_id('erfasst am', 'date', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), get_pt_free_text_id('2012-12-01', get_pt_locale_id('zxx', NULL, 'UTF8')));
INSERT INTO "attribute_value_geom" VALUES (create_uuid(), get_attribute_type_id('Geometrie', 'geometry(Geometry,4326)', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), 'SRID=4326;POINT(-44.3 60.1)');
INSERT INTO "attribute_value_domain" VALUES (create_uuid(), get_attribute_type_id('Anzahl', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 2), get_value_id_from_value_list('300', 'Intervall'));
INSERT INTO "attribute_value_domain" VALUES (create_uuid(), get_attribute_type_id('vollständig erfasst', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), get_value_id_from_value_list('true', 'Wahrheitswerte'));
INSERT INTO "attribute_value_domain" VALUES (create_uuid(), get_attribute_type_id('vollständig erfasst', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8')), (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), get_value_id_from_value_list('100', 'Intervall'));
*/
/*
-- AttributtypGruppe --> ab hier weiter einfügen !!!
INSERT INTO "Attributtyp_x_Attributtyp_Gruppe" VALUES (get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "Attributtyp_x_Attributtyp_Gruppe" VALUES (get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8')));
INSERT INTO "Attributtyp_x_Attributtyp_Gruppe" VALUES (get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8')));
-- Attributtyp_x_Attributtyp
INSERT INTO "Attributtyp_x_Attributtyp" VALUES (get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('parent to', 'vl_skos_relationship'));
INSERT INTO "Attributtyp_x_Attributtyp" VALUES (get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('parent to', 'vl_skos_relationship'));
INSERT INTO "Attributtyp_x_Attributtyp" VALUES (get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('parent to', 'vl_skos_relationship'));
INSERT INTO "Attributtyp_x_Attributtyp" VALUES (get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('parent to', 'vl_skos_relationship'));
INSERT INTO "Attributtyp_x_Attributtyp" VALUES (get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('equal to', 'vl_skos_relationship'));
INSERT INTO "Attributtyp_x_Attributtyp" VALUES (get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8')), get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8')), get_value_id_from_value_list('equal to', 'vl_skos_relationship'));
-- vl_relationship_type
SELECT add_value_list_value('TestBeziehungstyp', NULL, TRUE, 'vl_relationship_type');
*/



/*
SELECT get_value_id_from_value_list('related to', 'vl_skos_relationship')
SELECT get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))


SELECT
  "lcs2"."Freitext" "Werteliste",
  "lcs1"."Freitext" "WertelistenWert"
FROM
  "LocalizedCharacterString" "lcs1",
  "LocalizedCharacterString" "lcs2",
  "WL_WertelistenWerte" "wlww",
  "WL_Werteliste" "wlw"
WHERE
  --"lcs1"."Freitext" = 'integer' AND
  "wlww"."Name" = "lcs1"."PT_FreeText_Id" AND
  "wlw"."Name" = "lcs2"."PT_FreeText_Id" AND
  "wlww"."gehoert_zu_Werteliste" = "wlw"."id"
*/

---------------------------------
-- Integritätsbedingnungstests --
---------------------------------
/*
-- (1) Der "Min-Wert" der Relation "Multiplizitaet" muss >= 0 sein.
SELECT check_Integrity('INSERT INTO "Multiplizitaet" VALUES (create_uuid(), -1, 10)');

-- (2) Der "Max-Wert" der Relation "Multiplizitaet" muss > 0 sein.
SELECT check_Integrity('INSERT INTO "Multiplizitaet" VALUES (create_uuid(), 0, 0)');
SELECT check_Integrity('UPDATE "Multiplizitaet" SET "Max-Wert" = 0 WHERE "Min-Wert" = 5');
SELECT check_Integrity('UPDATE "Multiplizitaet" SET "Max-Wert" = -1 WHERE "Min-Wert" = 5');

-- (3) Der "Max-Wert" der Relation "Multiplizitaet" muss >= dem "Min-Wert" sein.
SELECT check_Integrity('INSERT INTO "Multiplizitaet" VALUES (create_uuid(), 5, 2)');
SELECT check_Integrity('UPDATE "Multiplizitaet" SET "Max-Wert" = 2 WHERE "Min-Wert" = 5');


-- (4) Die Spalte "Sprachkodierung" der Relation "Sprachkodierung" muss genau 3 Zeichen beinhalten.
SELECT check_Integrity('INSERT INTO "Sprachkodierung" VALUES (create_uuid(), '|| quote_literal('xy') ||')');
SELECT check_Integrity('INSERT INTO "Sprachkodierung" VALUES (create_uuid(), '|| quote_literal('vxyz') ||')');
SELECT check_Integrity('UPDATE "Sprachkodierung" SET "Sprachkodierung" = '|| quote_literal('xy') ||' WHERE "Sprachkodierung" = '|| quote_literal('deu'));
SELECT check_Integrity('UPDATE "Sprachkodierung" SET "Sprachkodierung" = '|| quote_literal('vxyz') ||' WHERE "Sprachkodierung" = '|| quote_literal('deu'));


-- (5) Die Spalte "Landkodierung" der Relation "Landkodierung" muss genau 2 Zeichen beinhalten.
SELECT check_Integrity('INSERT INTO "Landkodierung" VALUES (create_uuid(), '|| quote_literal('X') ||')');
SELECT check_Integrity('INSERT INTO "Landkodierung" VALUES (create_uuid(), '|| quote_literal('XYZ') ||')');
SELECT check_Integrity('UPDATE "Landkodierung" SET "Landkodierung" = '|| quote_literal('X') ||' WHERE "Landkodierung" = '|| quote_literal('DE'));
SELECT check_Integrity('UPDATE "Landkodierung" SET "Landkodierung" = '|| quote_literal('XYZ') ||' WHERE "Landkodierung" = '|| quote_literal('DE'));


-- (6) Die Spalte "Einheit" der Relation "Attributtyp" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_unit" befinden.
SELECT check_Integrity ('INSERT INTO "Attributtyp" VALUES (create_uuid(),
                          '|| quote_literal(get_PTFreeTextId('Testname', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_value_id_from_value_list('integer', 'vl_data_type', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_value_id_from_value_list('varchar', 'vl_data_type', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          NULL);');

-- (7) Die Spalte "Datentyp" der Relation "Attributtyp" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_data_type" befinden.
SELECT check_Integrity ('INSERT INTO "Attributtyp" VALUES (create_uuid(),
                          '|| quote_literal(get_PTFreeTextId('Testname', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_value_id_from_value_list('m', 'vl_unit', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          NULL,
                          NULL);');

-- (8) Die Spalte "Datentyp" der Relation "Attributtyp" muss entweder Float oder Integer zugeordnet bekommen, insofern eine Einheit vorhanden ist.
SELECT check_Integrity ('INSERT INTO "Attributtyp" VALUES (create_uuid(),
                          '|| quote_literal(get_PTFreeTextId('Testname', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_value_id_from_value_list('varchar', 'vl_data_type', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_value_id_from_value_list('m', 'vl_unit', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          NULL);');

-- (9) Die Spalte "Wertebereich" der Relation "Attributtyp" darf ausschließlich Werte aus "WL_Werteliste" zugeordnet bekommen, welche nicht "vl_attribute_type_group", "vl_relationship_type", "vl_data_type", "vl_unit", "vl_skos_relationship" oder "vl_topic" entsprechen.
SELECT check_Integrity ('INSERT INTO "Attributtyp" VALUES (create_uuid(),
                          '|| quote_literal(get_PTFreeTextId('Testname', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          '|| quote_literal(get_value_id_from_value_list('varchar', 'vl_data_type', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||',
                          NULL,
                          '|| quote_literal(get_value_list_id('vl_data_type', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||'
                          );');


-- (10) Die Spalte "Attributtyp_Gruppe" der Relation "Attributtyp_x_Attributtyp_Gruppe" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_attribute_type_group" befinden
SELECT check_Integrity ('INSERT INTO "Attributtyp_x_Attributtyp_Gruppe" VALUES ('|| quote_literal(get_attribute_type_id('Testname', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('varchar', 'vl_data_type', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' );');
SELECT check_Integrity ('UPDATE "Attributtyp_x_Attributtyp_Gruppe" SET "Attributtyp_Gruppe" = '|| quote_literal(get_value_id_from_value_list('varchar', 'vl_data_type', get_pt_locale_id('zxx', NULL, 'UTF8'), get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_Id" = '|| quote_literal(get_attribute_type_id('Testname', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))));


-- (11) Die Spalte "Standardwert" der Relation "Attributtypen_zur_Themenauspraegung" darf nur dann einen Eintrag besitzen, wenn das Attribut "Wertebereich" der zugehörigen Relation "Attributtyp" ebenfalls einen Eintrag hat. Wenn beide Attribute nicht NULL sind, dann muss der Wert von "WL_Werteliste", der den beiden Einträgen in "WL_WertelistenWerte" zugeordnet ist, identisch sein.
SELECT check_Integrity('INSERT INTO "Attributtypen_zur_Themenauspraegung" VALUES ('|| quote_literal(get_topic_characteristic_id('Themenausprägung1', 'Thema1', 'TestProjekt', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_multiplicity(5, 10)) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert5', 'TestWerteliste3')) ||')');
SELECT check_Integrity('UPDATE "Attributtypen_zur_Themenauspraegung" SET "Attributtyp_Id" = '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Standardwert" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert5', 'TestWerteliste3')));
SELECT check_Integrity('UPDATE "Attributtypen_zur_Themenauspraegung" SET "Standardwert" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||' WHERE "Standardwert" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert5', 'TestWerteliste3')));

-- (12) Durch das aktualisieren oder löschen eines Eintrages in der Relation  "Attributtypen_zur_Themenauspraegung", darf kein Eintrag entfernt werden, auf den sich ein Eintrag in "Attributwert" bezieht.
SELECT check_integrity ('DELETE FROM "attribute_type_to_topic_characteristic" WHERE "attribute_type_id" = '|| quote_literal(get_attribute_type_id('Breite', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))));
SELECT check_integrity ('UPDATE "attribute_type_to_topic_characteristic" SET "attribute_type_id" = '|| quote_literal(get_attribute_type_id('Breite', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "attribute_type_id" = '|| quote_literal(get_attribute_type_id('Anzahl', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (13) Die Spalte "Referenz_auf" der Relation "Beziehungstyp" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_topic" befinden.
SELECT check_Integrity ('INSERT INTO "Beziehungstyp" VALUES (create_uuid(), '|| quote_literal(get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('TestBeziehungstyp', 'vl_relationship_type', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||');');
SELECT check_Integrity ('UPDATE "Beziehungstyp" SET "Referenz_auf" = '|| quote_literal(get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Referenz_auf" = '|| quote_literal(get_value_id_from_value_list('Thema1', 'vl_topic', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (14) Die Spalte "Beschreibung" der Relation "Beziehungstyp" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_relationship_type" befinden.
SELECT check_Integrity ('INSERT INTO "Beziehungstyp" VALUES (create_uuid(), '|| quote_literal(get_value_id_from_value_list('Thema1', 'vl_topic', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||');');
SELECT check_Integrity ('UPDATE "Beziehungstyp" SET "Beschreibung" = '|| quote_literal(get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Referenz_auf" = '|| quote_literal(get_value_id_from_value_list('Thema1', 'vl_topic', get_pt_locale_id('deu', 'DE', 'UTF8'))));


-- (15) Die Spalte "Thema" der Relation "Themenauspraegung" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_topic" befinden.
SELECT check_integrity ('INSERT INTO "Themenauspraegung" VALUES (create_uuid(), '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('TestAttributtypGruppe', 'vl_attribute_type_group', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_project_id('TestProjekt', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||')');
SELECT check_integrity ('UPDATE "Themenauspraegung" SET "Thema" = '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Beschreibung" = '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))));


-- (16) Die Spalte "Beziehungsart" der Relation "WL_Werteliste_x_WL_Werteliste" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_skos_relationship" befinden.
SELECT check_integrity ('INSERT INTO "WL_Werteliste_x_WL_Werteliste" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('integer', 'vl_data_type')) ||');');
SELECT check_integrity ('UPDATE "WL_Werteliste_x_WL_Werteliste" SET "Beziehungsart" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "WL_Werteliste_2" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (17) Wenn in der Relation "WL_Werteliste_x_WL_Werteliste" ein Tupel den Wert "parent to" in der Spalte "Beziehungsart" besitzt, darf dieselbe Attributtypenkombination nicht invertiert mit der "Beziehungsart" "parent_to" auftreten.
SELECT check_integrity ('INSERT INTO "WL_Werteliste_x_WL_Werteliste" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||');');
SELECT check_integrity ('UPDATE "WL_Werteliste_x_WL_Werteliste" SET "WL_Werteliste_1" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "WL_Werteliste_2" = '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "WL_Werteliste_1" = '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (18) Wenn in der Relation "WL_Werteliste_x_WL_Werteliste" ein Tupel den Wert "parent_to" in der Spalte "Beziehungsart" besitzt, darf es keine Schleife über n Einträge geben.
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste4', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste4', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste4', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "value_list_x_value_list" SET "value_list_1" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "value_list_1" = '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) || ' AND "value_list_2" = '|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))));
SELECT check_integrity ('UPDATE "value_list_x_value_list" SET "value_list_2" = '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "value_list_1" = '|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))) || ' AND "value_list_2" = '|| quote_literal(get_value_list_id('TestWerteliste4', get_pt_locale_id('deu', 'DE', 'UTF8'))));
SELECT check_integrity ('UPDATE "value_list_x_value_list" SET "value_list_1" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "value_list_2" = '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "value_list_1" = '|| quote_literal(get_value_list_id('TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) || ' AND "value_list_2" = '|| quote_literal(get_value_list_id('TestWerteliste4', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (19) Die Spalten "WL_Werteliste_1" und "WL_Werteliste_2" der Relation "WL_Werteliste_x_WL_Werteliste" dürfen in einem Tupel nicht denselben Wert besitzen.
SELECT check_integrity ('INSERT INTO "value_list_x_value_list" VALUES ('|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_list_id('TestWerteliste3', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "value_list_x_value_list" SET "WL_Werteliste_1" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "WL_Werteliste_2" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))));


-- (20) Die Spalte "Beziehungsart" der Relation "WL_WertelistenWerte_x_WL_WertelistenWerte" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_skos_relationship" befinden.
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('integer', 'vl_data_type')) ||');');
SELECT check_integrity ('UPDATE "WL_WertelistenWerte_x_WL_WertelistenWerte" SET "Beziehungsart" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (21) Wenn in der Relation "WL_WertelistenWerte_x_WL_WertelistenWerte" ein Tupel den Wert "parent to" in der Spalte "Beziehungsart" besitzt, darf dieselbe Attributtypenkombination nicht invertiert mit der "Beziehungsart" "parent to" auftreten.
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "WL_WertelistenWerte_x_WL_WertelistenWerte" SET "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')));

-- (22) Wenn in der Relation "WL_WertelistenWerte_x_WL_WertelistenWerte" ein Tupel den Wert "parent to" in der Spalte "Beziehungsart" besitzt, darf es keine Schleife über n Einträge geben.
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert4', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert4', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert4', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1')) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "WL_WertelistenWerte_x_WL_WertelistenWerte" SET "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1')) ||' WHERE "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||' AND "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1')));
SELECT check_integrity ('UPDATE "WL_WertelistenWerte_x_WL_WertelistenWerte" SET "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||' WHERE "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1')) ||' AND "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert4', 'TestWerteliste1')));
SELECT check_integrity ('UPDATE "WL_WertelistenWerte_x_WL_WertelistenWerte" SET "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert2', 'TestWerteliste1')) ||', "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||' WHERE "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')));

-- (23) Die Spalten "WL_WertelistenWerte_1" und "WL_WertelistenWerte_2" der Relation "WL_WertelistenWerte_x_WL_WertelistenWerte" dürfen in einem Tupel nicht denselben Wert besitzen.
SELECT check_integrity ('INSERT INTO "WL_WertelistenWerte_x_WL_WertelistenWerte" VALUES ('|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "WL_WertelistenWerte_x_WL_WertelistenWerte" SET "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "WL_WertelistenWerte_2" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert3', 'TestWerteliste1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "WL_WertelistenWerte_1" = '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')));


-- (24) Die Spalte "Beziehungsart" der Relation "Attributtyp_x_Attributtyp" darf ausschließlich Werte aus "WL_WertelistenWerte" zugeordnet bekommen, welche sich in der Werteliste "vl_skos_relationship" befinden.
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('integer', 'vl_data_type')) ||');');
SELECT check_integrity ('UPDATE "Attributtyp_x_Attributtyp" SET "Beziehungsart" = '|| quote_literal(get_value_list_id('TestWerteliste2', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (25) Wenn in der Relation "Attributtyp_x_Attributtyp" ein Tupel den Wert "parent to" in der Spalte "Beziehungsart" besitzt, darf dieselbe Attributtypenkombination nicht invertiert mit der "Beziehungsart" "parent to" auftreten.
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "Attributtyp_x_Attributtyp" SET "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "Attributtyp_2" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (26) Wenn in der Relation "Attributtyp_x_Attributtyp" ein Tupel den Wert "parent to" in der Spalte "Beziehungsart" besitzt, darf es keine Schleife über n Einträge geben.
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
--SELECT check_integrity ('UPDATE "Attributtyp_x_Attributtyp" SET "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' AND "Attributtyp_2" = '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' AND "Beziehungsart" = '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')));
SELECT check_integrity ('UPDATE "Attributtyp_x_Attributtyp" SET "Attributtyp_2" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' AND "Attributtyp_2" = '|| quote_literal(get_attribute_type_id('Testattribut4', 'boolean', get_pt_locale_id('deu', 'DE', 'UTF8'))));
SELECT check_integrity ('UPDATE "Attributtyp_x_Attributtyp" SET "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "Attributtyp_2" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))));

-- (27) Die Spalten "Attributtyp_1" und "Attributtyp_2" der Relation "Attributtyp_x_Attributtyp" dürfen in einem Tupel nicht denselben Wert besitzen.
SELECT check_integrity ('INSERT INTO "Attributtyp_x_Attributtyp" VALUES ('|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_value_id_from_value_list('parent to', 'vl_skos_relationship')) ||');');
SELECT check_integrity ('UPDATE "Attributtyp_x_Attributtyp" SET "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', "Attributtyp_2" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Attributtyp_1" = '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))));


-- (28) Die Spalten "Themeninstanz_1" und "Themeninstanz_2" der Relation "Themeninstanz_x_Themeninstanz" dürfen in einem Tupel nicht denselben Wert besitzen.
SELECT check_integrity ('INSERT INTO "Themeninstanz_x_Themeninstanz" VALUES (create_uuid(), (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1), (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1), '|| quote_literal(get_relationship_type_id('TestBeziehungstyp', 'Thema1', get_pt_locale_id('deu', 'DE', 'UTF8'))) || ');');
SELECT check_integrity ('UPDATE "Themeninstanz_x_Themeninstanz" SET "Themeninstanz_1" = (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1) WHERE "Themeninstanz_2" = (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1)');

-- (29) In der Relation "Themeninstanz" existieren zwei Tupel ti1 und ti2 der "Themenausprägungen" ta1 und ta2. In der Relation "Themeninstanz_x_Themeninstanz" kann ein Tupel ti1, ti2, bt nur dann eingetragen werden, wenn in der Relation "Beziehungstypen_zur_Themenauspraegung" die Tupel ta1, bt und ta2, bt existieren.
SELECT check_integrity('INSERT INTO "Themeninstanz_x_Themeninstanz" VALUES (create_uuid(), '|| quote_literal('69a579df-392f-4ee0-a523-292511c421ee') ||', '|| quote_literal('d205a1b4-d37f-4d27-a845-32bca00bfead') ||', '|| quote_literal(get_relationship_type_id('gehört zu', 'Thema1', get_pt_locale_id('deu', 'DE', 'UTF8')))||')');
SELECT check_integrity('INSERT INTO "Themeninstanz_x_Themeninstanz" VALUES (create_uuid(), '|| quote_literal('0e62de5e-86f3-4fa9-8a7e-f22c268a8043') ||', '|| quote_literal('d205a1b4-d37f-4d27-a845-32bca00bfead') ||', '|| quote_literal(get_relationship_type_id('gehört zu', 'Thema1', get_pt_locale_id('deu', 'DE', 'UTF8')))||')');


-- (30) Ein Tupel mit einer Themeninstanz, welche der Themenausprägung ta zugeordnet ist, und dem Attributtyp at kann in der Relation "attribute_value", bzw. in den erbenden Relationen, nur dann eingetragen werden, wenn in der Relation "attribute_value_to_topic_characteristic" ein Tupel ta, at existiert.
SELECT check_integrity ('INSERT INTO "attribute_value_value" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 1), '|| quote_literal(get_pt_free_text_id('1.000', get_pt_locale_id('zxx', NULL, 'UTF8'))) ||');'); ROLLBACK;


SELECT check_integrity ('INSERT INTO "Attributwert" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1), NULL, NULL, '|| quote_literal(get_PTFreeTextId('1,000', get_pt_locale_id('zxx', NULL, 'UTF8'))) ||');');
SELECT check_integrity ('INSERT INTO "Attributwert" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Testattribut3', 'float', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1), NULL, NULL, '|| quote_literal(get_PTFreeTextId('1,000', get_pt_locale_id('zxx', NULL, 'UTF8'))) ||');');

-- (31) Einträge in die Spalte "value" der Relation "attribute_value_value" dürfen keine tausender Trennzeichen besitzen, insofern der Datentyp des zugehörigen Attributtyps ein Zahlentyp (z. Bsp. Integer oder Float) ist.
SELECT check_integrity ('INSERT INTO "attribute_value_value" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Testattribut2', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), '|| quote_literal(get_pt_free_text_id('1.000', get_pt_locale_id('zxx', NULL, 'UTF8'))) ||');');

-- (32) Der Datentyp von "attribute_value_value", bzw. den erbenden Relationen, muss dem entsprechen, der im Attribut "data_type" des zugehörigen Attributtyps spezifiziert ist.
SELECT check_integrity ('INSERT INTO "Attributwert" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Testattribut5', 'date', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 0), NULL, '|| quote_literal(get_geometryId(ST_MakePoint(2,4,6))) ||', NULL);');
SELECT check_integrity ('UPDATE "Attributwert" SET "Geometrie_Id" = NULL, "Wert" = ' || quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Geometrie_Id" = ' || quote_literal(get_geometryId(ST_MakePoint(2,4,6))));
*/
-- (33) Die Relation "attribute_value_geom" kann genau dann einen Eintrag bekommen, wenn der Datentyp des zugehörigen Attributtyps "geometry" ist.
--SELECT check_integrity ('INSERT INTO "Attributwert" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Testattribut1', 'varchar', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "Themeninstanz" LIMIT 1 OFFSET 1), '|| quote_literal(get_value_id_from_value_list('TestWertelistenWert1', 'TestWerteliste1')) ||', NULL, '|| quote_literal(get_PTFreeTextId('Testname', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||');');
--SELECT check_integrity ('UPDATE "Attributwert" SET "Wert" = NULL WHERE "Wert" = ' || quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))));
/*
-- (34) Die Relation "attribute_value_geomz" kann genau dann einen Eintrag bekommen, wenn der Datentyp des zugehörigen Attributtyps "geometryz" ist.

*/
-- (35) Die Spalte "domain" (FK auf "value_list_values") in der Relation "attribute_value_domain" darf nur dann einen Eintrag haben, wenn das Attribut "domain" der zugehörigen Relation "attribute_type" ebenfalls einen Eintrag hat. Wenn beide Attribute nicht NULL sind, dann muss der Wert von "value_list", der den beiden Einträgen in "value_list_values" zugeordnet ist, identisch sein und der Datentyp des Attributtyps mit dem Datentyp von "value_list_value" übereinstimmen.
--SELECT check_integrity ('INSERT INTO "attribute_value_domain" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Anzahl', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), '|| quote_literal(get_value_id_from_value_list('Warheitswerte', 'fal')) ||');');
--SELECT check_integrity ('INSERT INTO "attribute_value_domain" VALUES (create_uuid(), '|| quote_literal(get_attribute_type_id('Anzahl', 'integer', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', (SELECT "id" FROM "topic_instance" LIMIT 1 OFFSET 0), '|| quote_literal(get_value_id_from_value_list('Intervall', '100')) ||');');
/*

-- (36) Es muss genau ein Tupel der Relation "Projekt" keine Beziehung zu einem anderen Tupel der Relation "Projekt" besitzen.
-- & (37) Ein Tupel der Relation "Projekt" muss, unter Beachtung der vorangegangen Integritätsbedingung eine Beziehung zu genau einem anderen Relationstupel besitzen.
SELECT check_integrity ('INSERT INTO "Projekt" VALUES (create_uuid(), '|| quote_literal(get_PTFreeTextId('TestProjekt1', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', '|| quote_literal(get_PTFreeTextId('Testbeschreibung', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||', NULL);');
SELECT check_integrity ('UPDATE "Projekt" SET "Teilprojekt_von" = NULL WHERE "Name" = '|| quote_literal(get_PTFreeTextId('TestUnterProjekt', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||';');
SELECT check_integrity ('DELETE FROM "Projekt" WHERE "Name" = '|| quote_literal(get_PTFreeTextId('TestProjekt', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||';');

-- (38) Ein Tupel der Relation "Projekt" darf keine Beziehung zu sich selbst besitzen.
SELECT check_integrity ('UPDATE "Projekt" SET "Teilprojekt_von" = '|| quote_literal(get_PTFreeTextId('TestUnterProjekt', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||' WHERE "Name" = '|| quote_literal(get_PTFreeTextId('TestUnterProjekt', get_pt_locale_id('deu', 'DE', 'UTF8'))) ||';');
*/

ROLLBACK;
