/*
 * changelog from 13.04.2015
 * - index added for localized_character_string
 */


-- set search path to created system schema
SET search_path TO "system";
SET CLIENT_ENCODING TO "UTF8";


CREATE INDEX pt_locale_id_index
          ON localized_character_string (pt_free_text_id);