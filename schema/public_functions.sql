/**
 * changelog from 03.06.2015
 * - add stable function array_agg_mult
 * - add experimental function init_geom_views
 * - create_view is provided with attribute_group_id within desc parameter
 *
 * changelog from 01.06.2015
 * - quote_ident schema in SET SEARCH PATH operations
 *
 * changelog from 11.05.2015
 * - parameter for naming project in comments for function rename_project_schema
 *
 * changelog from 06.05.2015
 * - functions table_exists and column_exists added
 *
 * changelog from 16.04.2015
 * - function create_uuid inserted
 *
 * changelog from 09.04.2015
 * - function rename_project_schema added
 *
 */
SET search_path TO "public";
SET CLIENT_ENCODING TO "UTF8";


/**
 * This cast is necessary to convert varchar data automatically to json.
 */
CREATE CAST (varchar AS json) WITHOUT FUNCTION AS IMPLICIT;



/**
 * This function creates a UUUID version 4.
 *
 * @state   stable
 * @output  uuid: returns created uuid v4
 */
CREATE OR REPLACE FUNCTION public.create_uuid()
  RETURNS uuid AS $$
    SELECT public.uuid_generate_v4();
  $$ LANGUAGE 'sql';



/**
 * Allows aggregation of arrays returning a nested array.
 *
 * @state   stable
 * @output  ANYARRAY[]:
 */
DROP AGGREGATE IF EXISTS public.array_agg_mult(ANYARRAY);
CREATE AGGREGATE public.array_agg_mult(ANYARRAY)  (
  SFUNC     = array_cat,
  STYPE     = anyarray,
  INITCOND  = '{}'
);



/*
 * This function renames a project schema to project_[id], where [id] is the
 * uuid of the main project in the relation project.
 *
 * @state   stable
 * @input   varchar: name of the project for comment - DEFAULT 'no name project'
 * @output  boolean: returns true if renaming was successful, else false
 */
CREATE OR REPLACE FUNCTION public.rename_project_schema(varchar DEFAULT 'no name project')
  RETURNS boolean AS $$
  DECLARE
    _project_name ALIAS FOR $1;
    _new_schema_name varchar;
    _uuid uuid;
  BEGIN

    -- check if a project schema exists
    IF (SELECT "schema_name"
          FROM "information_schema"."schemata"
         WHERE "schema_name" = 'project') IS NULL THEN
      RAISE EXCEPTION 'Schema "project" does not exist.';
      RETURN false;
    END IF;

    -- retrieve uuid from the relation "project" of the project schema that has
    -- no subprojects
    EXECUTE 'SET search_path TO project';
    SELECT "id" INTO _uuid FROM "project" WHERE "subproject_of" IS NULL;

    -- construct new schema name
    _new_schema_name := 'project_' || _uuid;

    -- change schema name
    EXECUTE 'ALTER SCHEMA "project" RENAME TO ' || quote_ident(_new_schema_name);

    -- add comment with the name
    EXECUTE 'COMMENT ON SCHEMA ' || quote_ident(_new_schema_name) || ' IS '
                                 || quote_literal(_project_name);

    RETURN true;

  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This function determines if a passed table exists in the current used project
 * schema.
 *
 * @state   stable
 * @input   varchar: table name
 * @output  boolean: returns true if the table exists, else false
 */
CREATE OR REPLACE FUNCTION public.table_exists(varchar)
  RETURNS boolean AS $$
  DECLARE
    _table_name ALIAS FOR $1;
    _current_schema varchar;
  BEGIN
    -- retrieve the currently used project schema
    _current_schema := trim(both '"' FROM "constraints".get_current_project_schema());

    --
    IF (SELECT "table_name" IS NOT NULL FROM "information_schema"."columns" WHERE "table_name" = _table_name AND "table_schema" = _current_schema LIMIT 1) THEN
      RETURN true;
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This function determines if a passed column exists in the table and current
 * used project schema.
 *
 * @state   stable
 * @input   varchar: column name
 *          varchar: table name
 * @output  boolean: returns true if the table exists, else false
 */
CREATE OR REPLACE FUNCTION public.column_exists(varchar, varchar)
  RETURNS boolean AS $$
  DECLARE
    _column_name ALIAS FOR $1;
    _table_name ALIAS FOR $2;
    _current_schema varchar;
  BEGIN
    -- retrieve the currently used project schema
    _current_schema := trim(both '"' FROM "constraints".get_current_project_schema());

    --
    IF (SELECT "table_name" IS NOT NULL FROM "information_schema"."columns" WHERE "table_name" = _table_name AND "column_name" = _column_name AND "table_schema" = _current_schema LIMIT 1) THEN
      RETURN true;
    END IF;

    RETURN false;

  END;
  $$ LANGUAGE 'plpgsql';



/*
 * This function will iterate through the relation "localized_character_string"
 * and will calculate the apearance for every value in the referenced tables. If
 * the value is used in more than one of the referenced tables and columns, it
 * will be duplicated and the new id will be written in the first encounterd
 * referenced table. This process will be repeated as long as every entry in
 * "localized_character_string" is used only one time.
 *
 * @state   stable
 * @input   varchar: schema name
 */
CREATE OR REPLACE FUNCTION public.create_duplication(varchar)
  RETURNS void AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _result record;
    _result2 record;
    _new_id uuid;
    _count integer;
    _entry integer;
    _replace_id uuid;
    _tmp varchar;
    _statistic integer := 0;
  BEGIN
    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- run through all entries in localized_character_string, retrieve their
    -- appearance count in other tables and columns and loop through the results
    FOR _result IN (SELECT "constraints".free_text_in_use(_schema, "pt_free_text_id")
                           "count", "pt_free_text_id", "free_text", "pt_locale_id"
                      FROM "localized_character_string") LOOP

      -- if an entry is referenced more than one time
      IF _result."count" > 1 THEN
        RAISE NOTICE 'String "%" (%) found % times', _result."free_text", _result."pt_locale_id", _result."count";

        -- loop through the number of apearances minus one for the original that
        -- can be keept
        FOR i IN 1.._result."count"-1 LOOP
          RAISE NOTICE 'replacing clone %', i;
          -- create a new uuid
          _new_id := public.create_uuid();

          -- insert a new entry in localized_character_string with the same
          -- pt_locale_id and free_text but the new created pt_free_text_id for
          -- every apearance
          INSERT INTO "localized_character_string"
               VALUES (_new_id, _result."pt_locale_id", _result."free_text");

          -- find all tables that reference to pt_free_text (except
          -- localized_character_string) and run through every entry
          FOR _result2 IN
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
            -- run through the current table and column and save the id
            EXECUTE 'SELECT "id" FROM '|| quote_ident(_result2.table) ||'
                     WHERE '|| quote_ident(_result2.column) ||'
                     = '|| quote_literal(_result."pt_free_text_id") ||'
                     LIMIT 1' INTO _replace_id;

            -- if the id is not null
            IF (_replace_id IS NOT NULL) THEN
              RAISE NOTICE 'replacing % in %.% by % where id = %', _result."pt_free_text_id", _result2.table, _result2.column, _new_id, _replace_id;
              -- update the table and column with the new pt_free_text_id
              EXECUTE 'UPDATE '|| quote_ident(_result2.table) ||'
                       SET '|| quote_ident(_result2.column) ||'
                       = '|| quote_literal(_new_id) ||'
                       WHERE "id" = '|| quote_literal(_replace_id);
              RAISE NOTICE '------------------------------------------------------------------------------------------------';

              -- increment a statistic counter for every updated entry
              _statistic := _statistic + 1;
              EXIT;
            END IF;

          END LOOP;
        END LOOP;
      END IF;
    END LOOP;

    -- show how many elements were replaced
    RAISE NOTICE '% elements were replaced', _statistic;
  END
  $$ LANGUAGE 'plpgsql';



/*
 * This function will create a view for the Geo Server. It will construct a view
 * for the given topic characteristic id that includes a list of topic instances
 * that contain geometry. Additional to the geometry data, user defiend
 * attribute values (at present only from attribute_value_value) are presented.
 *
 * TODO: Add DB triggers to make view writable
 *
 * @input   varchar:  schema name
 *          uuid:     id of the topic characteristic that should retrieve a geo
 *                    reference
 *          text[]:   nested array of additional attributes that will be mapped to columns
 *                    [
                        [
                          attribute_group_id,
                          attibute_type_id,
                          pt_locale_id,
                          column description
                        ], ...
 *                    ]
 *          varchar:  geometry type
 *          varchar:  projection code - DEFAULT '4326'
 * @output  varchar:  name of the created view
 */
CREATE OR REPLACE FUNCTION public.create_view(varchar, uuid, text[],
                                       varchar, integer DEFAULT 4326)
  RETURNS varchar AS $$
  DECLARE
    _schema ALIAS FOR $1;
    _tc_id ALIAS FOR $2;
    _attribute_types ALIAS FOR $3;
    _geom_type ALIAS FOR $4;
    _projection ALIAS FOR $5;
    _locale_id uuid;
    _view_name varchar := 'geom_' || _tc_id;
    _sql varchar;
    _it text[];
    _ata_id uuid;
    _loop_counter integer := 1;
    _create_query TEXT;
  BEGIN

    -- set search path to passed schema
    EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

    -- construct static part of the sql string
    _sql := '
    SELECT
      "ti"."id"::TEXT,';

    IF (array_length(_attribute_types, 1) IS NULL) THEN
      RETURN 'no attributes';
    END IF;

    -- run through the array and retrieve the locale uuids
    FOREACH _it SLICE 1 IN ARRAY _attribute_types
    LOOP
      -- check if the locale exists
      IF ((SELECT count("id") FROM "pt_locale" WHERE "id" = _it[3]::uuid) = 0) THEN
        -- throw exception if it does not exist
        RAISE EXCEPTION 'The pt_locale id "%" does not exist.', _it[3];
      END IF;

      -- set readable column name
      _sql := _sql || '
        get_localized_character_string('||
              quote_literal(_schema) ||',
              "avv_'|| _loop_counter || '"."value_'|| _loop_counter ||'")';

      -- use the forth entry for naming the column
      _sql := _sql ||' AS '|| quote_ident(_it[4]) ||',';

      -- increment the loop counter
      _loop_counter := _loop_counter + 1;
    END LOOP;

    -- TODO: test geom type in column: ST_GeometryType(the_geom)
    _sql := _sql || '
      ST_Transform(ST_Multi("avg"."geom"), '|| _projection ||')::geometry('|| _geom_type ||', '|| _projection ||
      ') AS the_geom';

    -- construct static part of the sql string
    _sql := _sql || '
    FROM
      "topic_instance" "ti"
    INNER JOIN (
      SELECT
        "topic_instance_id",
        "geom"
      FROM "attribute_value_geom"
    ) AS "avg"
    ON "avg"."topic_instance_id" = "ti"."id"';

    -- reset counter
    _loop_counter := 1;

    -- run through the array and retrieve the locale uuids
    FOREACH _it SLICE 1 IN ARRAY _attribute_types
    LOOP
      _sql := _sql || '
         LEFT JOIN (
         SELECT
           "avv"."value" AS "value_'|| _loop_counter ||'",
           "avv"."topic_instance_id"
         FROM
           "attribute_value_value" "avv"
         WHERE
           "avv"."attribute_type_to_attribute_type_group_id" = '|| quote_literal(_it[1]) ||'
         ) AS "avv_'|| _loop_counter ||'"
         ON "avv_'|| _loop_counter ||'"."topic_instance_id" = "ti"."id"';

      -- increment the loop counter
      _loop_counter := _loop_counter + 1;

    END LOOP;

    -- construct static part of the sql string
    _sql := _sql || '
    WHERE
      "ti"."topic_characteristic_id" = '|| quote_literal(_tc_id);

     EXECUTE 'DROP VIEW IF EXISTS '|| quote_ident(_schema) ||'.'|| quote_ident(_view_name);
     EXECUTE 'CREATE OR REPLACE VIEW '|| quote_ident(_schema) ||'.'|| quote_ident(_view_name)||
            ' AS '||_sql ;

    -- prune entry if any
    EXECUTE 'DELETE FROM "meta_data"."gt_pk_metadata_table"
      WHERE table_schema = ' || quote_literal(_schema) || '
      AND   table_name   = ' || quote_literal(_view_name);

    -- insert metadata
    EXECUTE 'INSERT INTO "meta_data"."gt_pk_metadata_table" VALUES (
        ' || quote_literal(_schema) || ',
        ' || quote_literal(_view_name) || ',
        ''id'',
        1,
        ''assigned'',
        NULL
    )';

    RETURN _view_name;
  END;
  $$ LANGUAGE 'plpgsql';



/*
 * Creates database views of all geometry related topic characteristics.
 * Characteristics with no attributes but geometry will be left out and are
 * considered test data.
 *
 * TODO: determine PostGIS geometry type from geom attribute_type
 *
 * @state   experimental
 *
 * @input   varchar:  project schema name,
 * @input   UUID:  locale_id of attributes
 * @output  void
 */
CREATE OR REPLACE FUNCTION public.init_geom_views(
    VARCHAR,
    VARCHAR DEFAULT 'c0d76ff3-a711-42af-920d-09132a287015')
  RETURNS VOID
  AS $$
DECLARE
  _schema        ALIAS FOR $1;
  _locale_id     ALIAS FOR $2;
  _i             RECORD;
  _desc          TEXT [] [];
  _geometry_type RECORD;
BEGIN
  -- set search path to passed schema
  EXECUTE 'SET search_path TO '|| quote_ident(_schema) ||', constraints, public';

  -- loop over characteristics that have geom attribute_types
  FOR _i IN (
    SELECT DISTINCT tc.id
    FROM topic_characteristic tc
      INNER JOIN attribute_type_group_to_topic_characteristic atgtc
        ON tc.id = atgtc.topic_characteristic_id
      INNER JOIN attribute_type_to_attribute_type_group atatg
        ON atgtc.id = atatg.attribute_type_group_to_topic_characteristic_id
      INNER JOIN attribute_type at ON atatg.attribute_type_id = at.id
    -- attribute_types that reference attribute_value_geom
    WHERE at.id IN (
      SELECT DISTINCT (at.id)
      FROM attribute_value_geom avg
        INNER JOIN attribute_type_to_attribute_type_group atatg
          ON avg.attribute_type_to_attribute_type_group_id = atatg.id
        INNER JOIN attribute_type at ON atatg.attribute_type_id = at.id
    )
  )
  LOOP
    BEGIN
      SELECT array_agg_mult(ARRAY [ARRAY [
        atatg.id::TEXT,
        at.id::TEXT,
        _locale_id,
        replace(
            get_localized_character_string(_schema, at.name)::TEXT,
            ' ', '_'
        )
      ]]) INTO _desc
      FROM topic_characteristic tc
      INNER JOIN attribute_type_group_to_topic_characteristic atgtc
        ON tc.id = atgtc.topic_characteristic_id
      INNER JOIN attribute_type_to_attribute_type_group atatg
        ON atgtc.id = atatg.attribute_type_group_to_topic_characteristic_id
      INNER JOIN attribute_type at
        ON atatg.attribute_type_id = at.id
      WHERE
        at.id NOT IN ('78b47591-b1eb-447f-b369-0aa3476c965c') -- Non-Geometrie attribute_types
        AND domain IS NULL                                    -- non-domain values only
        AND tc.id = _i.id;

      -- skip any tc's that do not have attribute_types other than geom
      IF (array_length(_desc, 1) IS NULL) THEN
        CONTINUE;
      END IF;

      -- determine geometry attributes to set on view
      -- will throw if topic characteristic is empty or more than one geometrytype
      -- or srid is used with that characteristic
      -- if that is the case, manual call to create_view is nesessary
      --
      -- We need to cast to multi geometries as GeoServer seems to have problems
      -- with single type geometry layers (Polygon vs. MultiPolygon)
      SELECT DISTINCT
        geometrytype(ST_Multi(geom)) AS gtype,
        st_srid(geom)      AS srid
      INTO STRICT _geometry_type
      FROM topic_characteristic tc
      INNER JOIN attribute_type_group_to_topic_characteristic atgtc
        ON tc.id = atgtc.topic_characteristic_id
      INNER JOIN attribute_type_to_attribute_type_group atatg
        ON atgtc.id = atatg.attribute_type_group_to_topic_characteristic_id
      INNER JOIN attribute_value_geom avg
        ON atatg.id = avg.attribute_type_to_attribute_type_group_id
      WHERE tc.id = _i.id;

      PERFORM create_view(_schema, _i.id, _desc, _geometry_type.gtype, _geometry_type.srid);

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE NOTICE 'TC % does not have any attribute_value_geom rows to determine geometry from.', _i.id;
        WHEN TOO_MANY_ROWS THEN
          RAISE NOTICE 'TC % attribute_value_geom rows do not share common geometrytype or srid.', _i.id;
    END;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
