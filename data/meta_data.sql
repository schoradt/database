SET search_path TO "meta_data";
SET client_encoding TO "UTF8";

-- test data for log
INSERT INTO "logger" VALUES ('11ea351d-2623-48ea-bbfc-59eecdb13fc5', 'Test logger');
INSERT INTO "level" VALUES ('ddce2963-9ce4-4f6f-8c1e-bea78b3126c2', 'info');
INSERT INTO "level" VALUES ('d8d234f3-736f-4982-b23b-4bd65462e263', 'warning');
INSERT INTO "level" VALUES ('595f23d7-ee5c-4b84-a377-1d4ab187b4e8', 'error');
INSERT INTO "log" VALUES ('734add59-80ae-4cc0-b089-c72f264c332e', 'be342747-1b16-4042-acd8-37fd4399c72b', 'Test Benutzer', CURRENT_TIMESTAMP(0), '11ea351d-2623-48ea-bbfc-59eecdb13fc5', 'ddce2963-9ce4-4f6f-8c1e-bea78b3126c2', 'Test Eintrag');

-- test data for database connection
INSERT INTO "credentials" VALUES ('affa3f0c-ee2b-487b-9584-c81a0139fc14', 'postgres', 'postgres');
INSERT INTO "databases" VALUES ('90f6fa51-2342-45e2-a1c9-b5da1e62061c', 'openinfra');
INSERT INTO "ports" VALUES ('092819af-afc8-41f5-9baf-228dad0447b5', 5432);
INSERT INTO "schemas" VALUES ('e698f215-ecd5-4070-8cfa-ea3482d27f11', 'project_fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
INSERT INTO "schemas" VALUES ('a4d3f1dc-4093-4f9e-ac13-69b19210025e', 'project_7d431941-eece-48ac-bce5-3062d8d32e76');
INSERT INTO "schemas" VALUES ('fe625f67-6224-4652-b26f-723583ecd4e0', 'project_e7d42bff-4e40-4f43-9d1b-1dc5a190cd75');
INSERT INTO "servers" VALUES ('f3846ecf-0ace-4b5e-bc11-a0fb1ad980a4', 'localhost');
INSERT INTO "database_connection" VALUES ('a3791c08-a13b-4cad-8f2e-bb2871b89518', 'f3846ecf-0ace-4b5e-bc11-a0fb1ad980a4', '092819af-afc8-41f5-9baf-228dad0447b5', '90f6fa51-2342-45e2-a1c9-b5da1e62061c', 'e698f215-ecd5-4070-8cfa-ea3482d27f11', 'affa3f0c-ee2b-487b-9584-c81a0139fc14');
INSERT INTO "database_connection" VALUES ('56277561-828b-43d7-b0de-887dc76c3d3e', 'f3846ecf-0ace-4b5e-bc11-a0fb1ad980a4', '092819af-afc8-41f5-9baf-228dad0447b5', '90f6fa51-2342-45e2-a1c9-b5da1e62061c', 'a4d3f1dc-4093-4f9e-ac13-69b19210025e', 'affa3f0c-ee2b-487b-9584-c81a0139fc14');
INSERT INTO "database_connection" VALUES ('83be7b2b-557f-4f56-8335-4bef3f31750a', 'f3846ecf-0ace-4b5e-bc11-a0fb1ad980a4', '092819af-afc8-41f5-9baf-228dad0447b5', '90f6fa51-2342-45e2-a1c9-b5da1e62061c', 'fe625f67-6224-4652-b26f-723583ecd4e0', 'affa3f0c-ee2b-487b-9584-c81a0139fc14');

-- test data for projects
INSERT INTO "projects" VALUES ('4c113731-11bd-4b96-b2dd-b71743dbfece', 'fd27a347-4e33-4ed7-aebc-eeff6dbf1054', 'a3791c08-a13b-4cad-8f2e-bb2871b89518', false); -- Baalbek
INSERT INTO "projects" VALUES ('ddb717f8-3a74-4e66-a586-67cc0ea1e359', '32ba8c4d-6272-42f5-867e-2c5829c1f34e', 'a3791c08-a13b-4cad-8f2e-bb2871b89518', true); -- testExt_SubProject1
INSERT INTO "projects" VALUES ('889e34fb-584e-4de2-b233-b6f6ea5a88a5', '95c1d361-3643-4ced-a712-21d8c9a03622', 'a3791c08-a13b-4cad-8f2e-bb2871b89518', true); -- testExt_SubProject2
INSERT INTO "projects" VALUES ('650abf79-8b9b-4465-8d73-95eadb83c0f0', '61101fc6-e4a1-421e-8965-3e3a6f692af0', 'a3791c08-a13b-4cad-8f2e-bb2871b89518', true); -- testExt_SubSubProject
INSERT INTO "projects" VALUES ('e86bb9bf-614d-48ed-b125-fc5b9955e2f3', 'f17a0adc-bc0c-47e0-92ba-92e9bde75e0f', 'a3791c08-a13b-4cad-8f2e-bb2871b89518', true); -- testExt_SubSubSubProject
INSERT INTO "projects" VALUES ('dc2461c8-a2eb-40c0-b41f-23c9069ccf0c', '7d431941-eece-48ac-bce5-3062d8d32e76', '56277561-828b-43d7-b0de-887dc76c3d3e', false); -- Palatin
INSERT INTO "projects" VALUES ('d3ecb3c4-b986-462b-860b-05faea3b4702', 'e7d42bff-4e40-4f43-9d1b-1dc5a190cd75', '83be7b2b-557f-4f56-8335-4bef3f31750a', false); -- Test

-- test data for setting keys
INSERT INTO "setting_keys" VALUES ('e9da4346-ceee-4317-993f-73d0d07404a0', 'de.btu.openinfra.backend.rest.defaultOffset');
INSERT INTO "setting_keys" VALUES ('d5e01505-49e5-4cb8-adaf-716c725fe495', 'de.btu.openinfra.backend.rest.defaultSize');
INSERT INTO "setting_keys" VALUES ('d9e8aae4-a60d-458b-8965-7d1df42c6fcd', 'de.btu.openinfra.backend.rest.maxSize');

-- test data for setting
INSERT INTO "settings" VALUES ('24106451-60f6-446c-ba12-4218fb0c8fac', 'e9da4346-ceee-4317-993f-73d0d07404a0', '0', CURRENT_TIMESTAMP(0), NULL);
INSERT INTO "settings" VALUES ('664e7570-74d1-4274-954b-ce02c6cd7a1e', 'd5e01505-49e5-4cb8-adaf-716c725fe495', '20', CURRENT_TIMESTAMP(0), NULL);
INSERT INTO "settings" VALUES ('552e2ba1-c321-436c-ae71-5188b673d393', 'd9e8aae4-a60d-458b-8965-7d1df42c6fcd', '20', CURRENT_TIMESTAMP(0), NULL);