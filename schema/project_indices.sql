/*
 * changelog from 04.06.2015
 * - added spatial indices
 * - changed schema to baalbek test project
 *
 * changelog from 13.04.2015
 * - indices added for attribute_value_value and localized_character_string
 */


-- set search path to created project schema
SET search_path TO "project_fd27a347-4e33-4ed7-aebc-eeff6dbf1054";
SET CLIENT_ENCODING TO "UTF8";

CREATE INDEX topic_instance_x_topic_characteristic_id
ON topic_instance (topic_characteristic_id);

CREATE INDEX attribute_value_value_x_topic_instance_id
ON attribute_value_value (topic_instance_id);
CREATE INDEX attribute_value_geom_x_topic_instance_id
ON attribute_value_geom (topic_instance_id);

CREATE INDEX attribute_type_to_attribute_type_group_id_index
ON attribute_value_value (attribute_type_to_attribute_type_group_id);
          
CREATE INDEX pt_locale_id_index
ON localized_character_string (pt_free_text_id);

-- spatial indexing
create index attribute_value_geom_gist ON attribute_value_geom USING GIST (geom);
create index attribute_value_geomz_gist ON attribute_value_geomz USING GIST (geom);