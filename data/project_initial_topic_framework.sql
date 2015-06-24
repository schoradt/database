SET search_path TO "project", "public";
SET CLIENT_ENCODING TO "UTF8";


/* Projekt */
INSERT INTO localized_character_string VALUES ('f74ff759-da16-4490-a99a-19c70cd79775', 'c0d76ff3-a711-42af-920d-09132a287015', 'iDAIfield Pergamon');
INSERT INTO project VALUES ('8ed5a09f-e550-4333-83f3-1d847b5be4ed', 'f74ff759-da16-4490-a99a-19c70cd79775', NULL, NULL);

/* Initiales Themengerüst */
INSERT INTO "localized_character_string" VALUES ('af925670-1259-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Topographie');
INSERT INTO "value_list_values" VALUES ('bdb6f170-1259-11e4-9191-0800200c9a66', 'af925670-1259-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('c641ae20-1259-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Fundplatz');
INSERT INTO "value_list_values" VALUES ('d7987640-1259-11e4-9191-0800200c9a66', 'c641ae20-1259-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('dff740f0-1259-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Befundgruppe');
INSERT INTO "value_list_values" VALUES ('f0319c90-1259-11e4-9191-0800200c9a66', 'dff740f0-1259-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('f7db6f20-1259-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Grab');
INSERT INTO "value_list_values" VALUES ('02245690-125a-11e4-9191-0800200c9a66', 'f7db6f20-1259-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('f0319c90-1259-11e4-9191-0800200c9a66', '02245690-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('02245690-125a-11e4-9191-0800200c9a66', 'f0319c90-1259-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('08088450-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Haus');
INSERT INTO "value_list_values" VALUES ('131f4310-125a-11e4-9191-0800200c9a66', '08088450-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('f0319c90-1259-11e4-9191-0800200c9a66', '131f4310-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('131f4310-125a-11e4-9191-0800200c9a66', 'f0319c90-1259-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('1bd70330-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Befund');
INSERT INTO "value_list_values" VALUES ('27eb5bd0-125a-11e4-9191-0800200c9a66', '1bd70330-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('4eadd810-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Mauer');
INSERT INTO "value_list_values" VALUES ('58b6d050-125a-11e4-9191-0800200c9a66', '4eadd810-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('27eb5bd0-125a-11e4-9191-0800200c9a66', '58b6d050-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('58b6d050-125a-11e4-9191-0800200c9a66', '27eb5bd0-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');




INSERT INTO "localized_character_string" VALUES ('62f4e250-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Schicht');
INSERT INTO "value_list_values" VALUES ('6dd48b80-125a-11e4-9191-0800200c9a66', '62f4e250-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('27eb5bd0-125a-11e4-9191-0800200c9a66', '6dd48b80-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('6dd48b80-125a-11e4-9191-0800200c9a66', '27eb5bd0-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('7477c380-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Fundkollektion');
INSERT INTO "value_list_values" VALUES ('7e10bbe0-125a-11e4-9191-0800200c9a66', '7477c380-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('85b8b9b0-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Fund');
INSERT INTO "value_list_values" VALUES ('8fb0e910-125a-11e4-9191-0800200c9a66', '85b8b9b0-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('9734bd10-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Ton');
INSERT INTO "value_list_values" VALUES ('a3412670-125a-11e4-9191-0800200c9a66', '9734bd10-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('8fb0e910-125a-11e4-9191-0800200c9a66', 'a3412670-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('a3412670-125a-11e4-9191-0800200c9a66', '8fb0e910-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');

INSERT INTO "localized_character_string" VALUES ('2789d8b5-02da-4f83-bb11-473cacd210bc', 'c0d76ff3-a711-42af-920d-09132a287015', 'Keramik');
INSERT INTO "value_list_values" VALUES ('cbdb4588-81c3-46c0-a870-2591cdacbdcd', '2789d8b5-02da-4f83-bb11-473cacd210bc', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('a3412670-125a-11e4-9191-0800200c9a66', 'cbdb4588-81c3-46c0-a870-2591cdacbdcd', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('cbdb4588-81c3-46c0-a870-2591cdacbdcd', 'a3412670-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('585c7aec-6a78-4c86-9160-e7d8a51d313a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Lampe');
INSERT INTO "value_list_values" VALUES ('09b8ee98-7f8d-4578-9e47-c34ed5fa5b1b', '585c7aec-6a78-4c86-9160-e7d8a51d313a', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('a3412670-125a-11e4-9191-0800200c9a66', '09b8ee98-7f8d-4578-9e47-c34ed5fa5b1b', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('09b8ee98-7f8d-4578-9e47-c34ed5fa5b1b', 'a3412670-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('b1d991e0-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Metall');
INSERT INTO "value_list_values" VALUES ('c5678550-125a-11e4-9191-0800200c9a66', 'b1d991e0-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('8fb0e910-125a-11e4-9191-0800200c9a66', 'c5678550-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('c5678550-125a-11e4-9191-0800200c9a66', '8fb0e910-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('cd4d4f70-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Glas');
INSERT INTO "value_list_values" VALUES ('d835d240-125a-11e4-9191-0800200c9a66', 'cd4d4f70-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('8fb0e910-125a-11e4-9191-0800200c9a66', 'd835d240-125a-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('d835d240-125a-11e4-9191-0800200c9a66', '8fb0e910-125a-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('de53fbc0-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Holz');
INSERT INTO "value_list_values" VALUES ('edce14a0-125a-11e4-9191-0800200c9a66', 'de53fbc0-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('fb9d3ca0-125a-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Stein');
INSERT INTO "value_list_values" VALUES ('070acdf0-125b-11e4-9191-0800200c9a66', 'fb9d3ca0-125a-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('0d05b800-125b-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Inschrift');
INSERT INTO "value_list_values" VALUES ('1a62bd40-125b-11e4-9191-0800200c9a66', '0d05b800-125b-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('26392280-125b-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Maßnahme');
INSERT INTO "value_list_values" VALUES ('324d5410-125b-11e4-9191-0800200c9a66', '26392280-125b-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('38d5d820-125b-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Survey');
INSERT INTO "value_list_values" VALUES ('451bef20-125b-11e4-9191-0800200c9a66', '38d5d820-125b-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('324d5410-125b-11e4-9191-0800200c9a66', '451bef20-125b-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('451bef20-125b-11e4-9191-0800200c9a66', '324d5410-125b-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('6374cb40-125b-11e4-9191-0800200c9a66', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung');
INSERT INTO "value_list_values" VALUES ('6e3af900-125b-11e4-9191-0800200c9a66', '6374cb40-125b-11e4-9191-0800200c9a66', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('324d5410-125b-11e4-9191-0800200c9a66', '6e3af900-125b-11e4-9191-0800200c9a66', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('6e3af900-125b-11e4-9191-0800200c9a66', '324d5410-125b-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('01dd13b2-13be-4fdc-8cce-a1dfdc46eb83', 'c0d76ff3-a711-42af-920d-09132a287015', 'Schnitt');
INSERT INTO "value_list_values" VALUES ('db88d485-29ac-419c-b99a-7cfc97f287cd', '01dd13b2-13be-4fdc-8cce-a1dfdc46eb83', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('324d5410-125b-11e4-9191-0800200c9a66', 'db88d485-29ac-419c-b99a-7cfc97f287cd', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('db88d485-29ac-419c-b99a-7cfc97f287cd', '324d5410-125b-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('d5bab61a-6d46-4204-8af8-3eabf712f03e', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauaufnahme');
INSERT INTO "value_list_values" VALUES ('5203b791-de2d-4415-b7d2-2334513243ef', 'd5bab61a-6d46-4204-8af8-3eabf712f03e', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('324d5410-125b-11e4-9191-0800200c9a66', '5203b791-de2d-4415-b7d2-2334513243ef', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('5203b791-de2d-4415-b7d2-2334513243ef', '324d5410-125b-11e4-9191-0800200c9a66', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('08d21e8e-a5c8-44b5-8449-209648548bac', 'c0d76ff3-a711-42af-920d-09132a287015', 'Arbeitsgang');
INSERT INTO "value_list_values" VALUES ('275cd753-c955-4434-8b07-ba1fae78f70a', '08d21e8e-a5c8-44b5-8449-209648548bac', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('823e7081-8dfa-4f27-991e-b38b88810a4a', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht');
INSERT INTO "value_list_values" VALUES ('e413d52f-07d7-4a67-aa5d-4fb9959934be', '823e7081-8dfa-4f27-991e-b38b88810a4a', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('275cd753-c955-4434-8b07-ba1fae78f70a', 'e413d52f-07d7-4a67-aa5d-4fb9959934be', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('e413d52f-07d7-4a67-aa5d-4fb9959934be', '275cd753-c955-4434-8b07-ba1fae78f70a', '0c724d32-5f3b-4278-bdb1-b4352152a99f');



INSERT INTO "localized_character_string" VALUES ('d95ac087-3adf-4c1d-b905-34395f1530e1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum');
INSERT INTO "value_list_values" VALUES ('497e2fcb-a967-4246-9fc4-e89a8d385655', 'd95ac087-3adf-4c1d-b905-34395f1530e1', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('275cd753-c955-4434-8b07-ba1fae78f70a', '497e2fcb-a967-4246-9fc4-e89a8d385655', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('497e2fcb-a967-4246-9fc4-e89a8d385655', '275cd753-c955-4434-8b07-ba1fae78f70a', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('1b679f18-9d9d-4293-b300-ecf1fc5012c0', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil');
INSERT INTO "value_list_values" VALUES ('ee736aaf-c705-4dea-80c5-5aefe47d94ae', '1b679f18-9d9d-4293-b300-ecf1fc5012c0', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('275cd753-c955-4434-8b07-ba1fae78f70a', 'ee736aaf-c705-4dea-80c5-5aefe47d94ae', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('ee736aaf-c705-4dea-80c5-5aefe47d94ae', '275cd753-c955-4434-8b07-ba1fae78f70a', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('740fe41e-8abb-410f-be4c-e5e8d5fe5773', 'c0d76ff3-a711-42af-920d-09132a287015', 'Abhub');
INSERT INTO "value_list_values" VALUES ('c8e8e68b-d242-434e-8c70-29419674782b', '740fe41e-8abb-410f-be4c-e5e8d5fe5773', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('275cd753-c955-4434-8b07-ba1fae78f70a', 'c8e8e68b-d242-434e-8c70-29419674782b', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('c8e8e68b-d242-434e-8c70-29419674782b', '275cd753-c955-4434-8b07-ba1fae78f70a', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('c7623aa7-e556-42b2-8f32-36d400eeaa6b', 'c0d76ff3-a711-42af-920d-09132a287015', 'Probe');
INSERT INTO "value_list_values" VALUES ('3809f86e-55e6-4832-8b4b-f777998102ee', 'c7623aa7-e556-42b2-8f32-36d400eeaa6b', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('4e7f8912-9093-4d86-8d1a-509f4718818e', 'c0d76ff3-a711-42af-920d-09132a287015', 'C14');
INSERT INTO "value_list_values" VALUES ('1beb5a6b-d2af-43b0-a12d-c3bc940fbb17', '4e7f8912-9093-4d86-8d1a-509f4718818e', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('3809f86e-55e6-4832-8b4b-f777998102ee', '1beb5a6b-d2af-43b0-a12d-c3bc940fbb17', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('1beb5a6b-d2af-43b0-a12d-c3bc940fbb17', '3809f86e-55e6-4832-8b4b-f777998102ee', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('90a74e93-8667-48b6-886b-ad1eab293eae', 'c0d76ff3-a711-42af-920d-09132a287015', 'Dendrochronologie');
INSERT INTO "value_list_values" VALUES ('55540a41-1bd6-4f6c-ba8d-bae53a92ebe7', '90a74e93-8667-48b6-886b-ad1eab293eae', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* broader */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('3809f86e-55e6-4832-8b4b-f777998102ee', '55540a41-1bd6-4f6c-ba8d-bae53a92ebe7', '35fe2530-fe24-44bf-a55d-020718d51bd1');

/* narrower */
INSERT INTO "value_list_values_x_value_list_values" VALUES ('55540a41-1bd6-4f6c-ba8d-bae53a92ebe7', '3809f86e-55e6-4832-8b4b-f777998102ee', '0c724d32-5f3b-4278-bdb1-b4352152a99f');


INSERT INTO "localized_character_string" VALUES ('53f82210-67bc-4978-88ad-7bbaff27edba', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk');
INSERT INTO "value_list_values" VALUES ('520af3af-2fe6-4739-ad60-b795d35a4f88', '53f82210-67bc-4978-88ad-7bbaff27edba', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');


INSERT INTO "localized_character_string" VALUES ('764cc408-71c7-4125-b924-383d097c42be', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum');
INSERT INTO "value_list_values" VALUES ('591e5432-7d62-45b8-93a4-3ab98cd9c8de', '764cc408-71c7-4125-b924-383d097c42be', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

INSERT INTO "localized_character_string" VALUES ('43335b3a-4f7f-4741-9f30-d901f2367cdb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand');
INSERT INTO "value_list_values" VALUES ('52d474e1-061d-4694-9515-389a8ea3beac', '43335b3a-4f7f-4741-9f30-d901f2367cdb', NULL, true, 'd145bf95-f6ea-4405-832b-55da75e825e5');

/* Themenausprägungen */

/* Bauwerk */
INSERT INTO "localized_character_string" VALUES ('9197f354-381f-45aa-8616-51d6834593fb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','9197f354-381f-45aa-8616-51d6834593fb','520af3af-2fe6-4739-ad60-b795d35a4f88', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');

/* Raum */
INSERT INTO "localized_character_string" VALUES ('28fd745d-9082-46fc-8adb-1206b90b0592', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','28fd745d-9082-46fc-8adb-1206b90b0592','591e5432-7d62-45b8-93a4-3ab98cd9c8de', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');

/* Wand */
INSERT INTO "localized_character_string" VALUES ('b5831587-aecf-4b24-a865-e90bcf43b28a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','b5831587-aecf-4b24-a865-e90bcf43b28a','52d474e1-061d-4694-9515-389a8ea3beac', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');


/* Abhub */
INSERT INTO "localized_character_string" VALUES ('472303e2-472a-49f2-9cee-514808e8b24c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Abhub im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','472303e2-472a-49f2-9cee-514808e8b24c','c8e8e68b-d242-434e-8c70-29419674782b', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');


/* Bohrung */
INSERT INTO "localized_character_string" VALUES ('e60bb9ef-3027-4123-bb40-7c359e52811d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','e60bb9ef-3027-4123-bb40-7c359e52811d','6e3af900-125b-11e4-9191-0800200c9a66', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');


/* BohrkernSchicht */
INSERT INTO "localized_character_string" VALUES ('9a62a123-4914-46de-9601-8b0b8edab53f', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','9a62a123-4914-46de-9601-8b0b8edab53f','e413d52f-07d7-4a67-aa5d-4fb9959934be', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');


/* Planum */
INSERT INTO "localized_character_string" VALUES ('9d5186e2-3f85-433b-9d18-d944ab6e37ea', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','9d5186e2-3f85-433b-9d18-d944ab6e37ea','497e2fcb-a967-4246-9fc4-e89a8d385655', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');


/* Profil */
INSERT INTO "localized_character_string" VALUES ('a2462bc4-cd8e-4b9a-98a9-f38df9639d12', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil im Testprojekt');
INSERT INTO "topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','a2462bc4-cd8e-4b9a-98a9-f38df9639d12','ee736aaf-c705-4dea-80c5-5aefe47d94ae', '8ed5a09f-e550-4333-83f3-1d847b5be4ed');

/* Multiplicity */
INSERT INTO "multiplicity" VALUES ('7e764492-4a75-48f9-a98e-484b0355c6d8', 0, NULL);

/*
Wertelisten und Wertelistenwerte
*/
INSERT INTO "localized_character_string" VALUES ('31089a15-5e6b-4191-ab2e-edcd2646d3f5', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Bautyp');
INSERT INTO "value_list" VALUES ('6faa9420-feae-4675-aa90-cc929b74680f', '31089a15-5e6b-4191-ab2e-edcd2646d3f5', NULL);

INSERT INTO "localized_character_string" VALUES ('875dd10c-ea6d-49ef-989d-878d647b2dc6', 'c0d76ff3-a711-42af-920d-09132a287015', 'Aedicula');
INSERT INTO "value_list_values" VALUES ('c570c778-5d30-41b7-984b-b4a4407c5a8e', '875dd10c-ea6d-49ef-989d-878d647b2dc6', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('ef8a3b50-6ba2-4ce0-bf7b-483d14e185ff', 'c0d76ff3-a711-42af-920d-09132a287015', 'Altar');
INSERT INTO "value_list_values" VALUES ('a1aaabfd-9228-4704-bafb-ada8eb420253', 'ef8a3b50-6ba2-4ce0-bf7b-483d14e185ff', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('fa55e7c4-e743-4aab-951a-a40b047cb800', 'c0d76ff3-a711-42af-920d-09132a287015', 'Amphitheater');
INSERT INTO "value_list_values" VALUES ('f46fee93-4485-4d9e-b3b7-4b0c26c3f6f0', 'fa55e7c4-e743-4aab-951a-a40b047cb800', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('966d3bae-cb23-4e8f-b153-4952879e2507', 'c0d76ff3-a711-42af-920d-09132a287015', 'Basilika');
INSERT INTO "value_list_values" VALUES ('8c6dee30-2d22-419b-8c8b-e2cab1c4e3bc', '966d3bae-cb23-4e8f-b153-4952879e2507', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('928df5fd-6857-4f0c-861c-760b3b1595ec', 'c0d76ff3-a711-42af-920d-09132a287015', 'Brücke');
INSERT INTO "value_list_values" VALUES ('5a040f68-177b-4b7f-a055-6fd2f054729c', '928df5fd-6857-4f0c-861c-760b3b1595ec', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('1d7e66bf-e99f-4ffa-831c-c4e2ac554a0b', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bogen');
INSERT INTO "value_list_values" VALUES ('647fcf43-6dde-4787-ab67-ecf7e80fb940', '1d7e66bf-e99f-4ffa-831c-c4e2ac554a0b', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('c53d2e5f-388e-43f2-aae8-ff5eb963655c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Circus');
INSERT INTO "value_list_values" VALUES ('614c9021-2b96-41c5-9cde-97156a30c70a', 'c53d2e5f-388e-43f2-aae8-ff5eb963655c', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('86088bd8-fdfc-4ec4-a6d3-d6a3f0e3f972', 'c0d76ff3-a711-42af-920d-09132a287015', 'Grabbau');
INSERT INTO "value_list_values" VALUES ('c62e7b51-443a-4477-8d56-58a4eb15ef2f', '86088bd8-fdfc-4ec4-a6d3-d6a3f0e3f972', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('28c0a727-7c29-44e3-bd91-0fd74147821a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Gymnasium');
INSERT INTO "value_list_values" VALUES ('2030c9da-0920-4329-86c1-372a170ab5bb', '28c0a727-7c29-44e3-bd91-0fd74147821a', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('73e17d27-853b-454f-9a44-edb72cc76ffc', 'c0d76ff3-a711-42af-920d-09132a287015', 'Odeion');
INSERT INTO "value_list_values" VALUES ('4e1387e4-fd35-47c3-b5ba-9e45daf91d9e', '73e17d27-853b-454f-9a44-edb72cc76ffc', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('f2f5eb99-cfaa-42bf-86c0-5fa3792ff1ad', 'c0d76ff3-a711-42af-920d-09132a287015', 'Mauerkurtine');
INSERT INTO "value_list_values" VALUES ('9c29f0d0-bcce-449a-9a73-0fbd7293fb69', 'f2f5eb99-cfaa-42bf-86c0-5fa3792ff1ad', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('58edd639-1161-45d8-8616-1545591eb6fa', 'c0d76ff3-a711-42af-920d-09132a287015', 'Nymphäum');
INSERT INTO "value_list_values" VALUES ('87f45088-1736-412a-bd57-fbbc47fc0acf', '58edd639-1161-45d8-8616-1545591eb6fa', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('e56e5a94-3fe0-4406-9f49-01d421efccc9', 'c0d76ff3-a711-42af-920d-09132a287015', 'Säulenhalle');
INSERT INTO "value_list_values" VALUES ('5fa77eba-fd9f-4107-9f42-8bd1bb3a6e99', 'e56e5a94-3fe0-4406-9f49-01d421efccc9', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('a3b459fa-7b28-44f7-90ba-4cf6af28adf3', 'c0d76ff3-a711-42af-920d-09132a287015', 'Straße');
INSERT INTO "value_list_values" VALUES ('9f426339-59d6-460f-aa82-3facbcc98590', 'a3b459fa-7b28-44f7-90ba-4cf6af28adf3', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('45a6bc05-f409-4a0f-89d1-cd9aaf16f758', 'c0d76ff3-a711-42af-920d-09132a287015', 'Stützmauer');
INSERT INTO "value_list_values" VALUES ('6007ee4e-735a-4577-be43-0721c4f55a4d', '45a6bc05-f409-4a0f-89d1-cd9aaf16f758', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('d64bc5f1-0704-4343-a057-f73f4c2cfd94', 'c0d76ff3-a711-42af-920d-09132a287015', 'Tempel');
INSERT INTO "value_list_values" VALUES ('c77f0e31-90e4-4296-be6f-00ad7367f6b4', 'd64bc5f1-0704-4343-a057-f73f4c2cfd94', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('a825ffe0-054d-4dbc-8d5f-55a2c6b4425a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Theater');
INSERT INTO "value_list_values" VALUES ('18ac4729-05c2-42f8-aa14-009618ef3a53', 'a825ffe0-054d-4dbc-8d5f-55a2c6b4425a', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('e03be511-acda-4250-8ed8-a98a915beabb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Thermen');
INSERT INTO "value_list_values" VALUES ('782761c4-4344-40cc-b832-383faedbd76b', 'e03be511-acda-4250-8ed8-a98a915beabb', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('2a87aebe-2b92-4772-a91a-9b3eb0e6d0e0', 'c0d76ff3-a711-42af-920d-09132a287015', 'Toranlage');
INSERT INTO "value_list_values" VALUES ('730bbae9-fb80-44ec-a90e-81d55e62c798', '2a87aebe-2b92-4772-a91a-9b3eb0e6d0e0', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('76289218-a3b5-409e-99f0-8c401ce395eb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Turm');
INSERT INTO "value_list_values" VALUES ('7ec33c1f-2bbb-44d1-b802-42a038b62826', '76289218-a3b5-409e-99f0-8c401ce395eb', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('6f617c64-5da0-4416-8368-350eb1d08481', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wohnbau');
INSERT INTO "value_list_values" VALUES ('3e0bfad0-1e01-4b32-90fc-fe44ede4a256', '6f617c64-5da0-4416-8368-350eb1d08481', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');

INSERT INTO "localized_character_string" VALUES ('cdc511e8-93f4-45ad-82fe-a8729bce8f4b', 'c0d76ff3-a711-42af-920d-09132a287015', 'Werkstatt');
INSERT INTO "value_list_values" VALUES ('9b3f357c-cdb2-44eb-acdb-3e467bee00c7', 'cdc511e8-93f4-45ad-82fe-a8729bce8f4b', NULL, true, '6faa9420-feae-4675-aa90-cc929b74680f');


INSERT INTO "localized_character_string" VALUES ('cf42eb69-e0be-4865-9679-a236ba3a67e1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_BautypSpeziell');
INSERT INTO "value_list" VALUES ('1cd29172-9b8a-4a64-a539-e44159d789f9', 'cf42eb69-e0be-4865-9679-a236ba3a67e1', NULL);

INSERT INTO "value_list_values" VALUES ('a845bc6d-4161-48b0-906c-4e998db296ee', '1d7e66bf-e99f-4ffa-831c-c4e2ac554a0b', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('4805877f-431a-4a9e-874e-a3ecdc5d6697', 'c0d76ff3-a711-42af-920d-09132a287015', 'Ehrenbogen');
INSERT INTO "value_list_values" VALUES ('2e2258b8-a387-4c46-8c31-839389df0cdf', '4805877f-431a-4a9e-874e-a3ecdc5d6697', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('bb91468f-e5c4-489f-bc87-190615455e0c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Triumphbogen');
INSERT INTO "value_list_values" VALUES ('9c80616e-9a26-424e-bdc6-d8c306506044', 'bb91468f-e5c4-489f-bc87-190615455e0c', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('2dc6761a-91f9-4208-bcaf-292f7adad9ab', 'c0d76ff3-a711-42af-920d-09132a287015', 'Torbogen');
INSERT INTO "value_list_values" VALUES ('e01fd57d-13aa-4c34-992a-b613f544e09a', '2dc6761a-91f9-4208-bcaf-292f7adad9ab', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "value_list_values" VALUES ('c9c6c784-1540-4947-8101-812b8a53ca8a', '966d3bae-cb23-4e8f-b153-4952879e2507', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('1df1dee4-ee16-4812-9846-a9f0bf6a2a67', 'c0d76ff3-a711-42af-920d-09132a287015', 'zweischiffig');
INSERT INTO "value_list_values" VALUES ('41b12272-1057-4b5d-8ec3-8fb7386fa63d', '1df1dee4-ee16-4812-9846-a9f0bf6a2a67', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('773b3843-276e-461a-8f42-bbc83fe2c05c', 'c0d76ff3-a711-42af-920d-09132a287015', 'dreischiffig');
INSERT INTO "value_list_values" VALUES ('b4083fc2-435e-4012-82e8-df1fd0ab0c80', '773b3843-276e-461a-8f42-bbc83fe2c05c', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('c140c407-68ed-4ce6-94ba-7f1438b0f454', 'c0d76ff3-a711-42af-920d-09132a287015', 'vierschiffig');
INSERT INTO "value_list_values" VALUES ('0c2f34c9-d249-4658-8dcf-e66c1f95dfc1', 'c140c407-68ed-4ce6-94ba-7f1438b0f454', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('7f8eac3b-1237-4ae5-ac9c-d8d775f1c123', 'c0d76ff3-a711-42af-920d-09132a287015', 'fünfschiffig');
INSERT INTO "value_list_values" VALUES ('226f3ba6-4e52-4d57-b7e0-d3195495fa46', '7f8eac3b-1237-4ae5-ac9c-d8d775f1c123', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "value_list_values" VALUES ('b812a36d-8e63-4e19-a303-346d1293f27a', '86088bd8-fdfc-4ec4-a6d3-d6a3f0e3f972', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('56a2f277-a0a4-433b-915d-53444aff4e99', 'c0d76ff3-a711-42af-920d-09132a287015', 'Aediculabau');
INSERT INTO "value_list_values" VALUES ('cfa6c9d2-d5a1-4f81-8201-79151ce7d15e', '56a2f277-a0a4-433b-915d-53444aff4e99', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('d71613ef-7cbb-49ee-bc48-f2e869ab7d36', 'c0d76ff3-a711-42af-920d-09132a287015', 'Rundbau');
INSERT INTO "value_list_values" VALUES ('cb24b85e-67ab-4ea3-9a9c-78db170e5498', 'd71613ef-7cbb-49ee-bc48-f2e869ab7d36', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('e325c8af-264e-47f9-be01-4fb7bed6e2be', 'c0d76ff3-a711-42af-920d-09132a287015', 'Tumulus');
INSERT INTO "value_list_values" VALUES ('2393ecd1-32af-4276-b91d-314b4a69e985', 'e325c8af-264e-47f9-be01-4fb7bed6e2be', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('bb80fbf1-2af6-4248-8e64-e9dca7301ea7', 'c0d76ff3-a711-42af-920d-09132a287015', 'Dipteros');
INSERT INTO "value_list_values" VALUES ('874b7a3d-40e7-4660-add7-0e136a90fba3', 'bb80fbf1-2af6-4248-8e64-e9dca7301ea7', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('ed892807-b14d-40c1-bb52-cf6f36ff70ed', 'c0d76ff3-a711-42af-920d-09132a287015', 'Hoftempel');
INSERT INTO "value_list_values" VALUES ('3ba536db-3fa2-448c-9f8b-2b6d0bd08f8c', 'ed892807-b14d-40c1-bb52-cf6f36ff70ed', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('f04426b0-4cfd-424e-98fa-ea2915080304', 'c0d76ff3-a711-42af-920d-09132a287015', 'Peripteros');
INSERT INTO "value_list_values" VALUES ('9edc467d-851b-41ba-babf-381133a6bae6', 'f04426b0-4cfd-424e-98fa-ea2915080304', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('14db1d41-b5bf-4637-b7dd-00c78350d73f', 'c0d76ff3-a711-42af-920d-09132a287015', 'Peripteros sine postico');
INSERT INTO "value_list_values" VALUES ('22885f3f-6d08-453d-b663-491091b1c26e', '14db1d41-b5bf-4637-b7dd-00c78350d73f', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('ef0b16a4-f07a-4a2b-a000-4b970acdfbca', 'c0d76ff3-a711-42af-920d-09132a287015', 'Pseudo-Dipteros');
INSERT INTO "value_list_values" VALUES ('43211101-110a-4a38-a79e-5869bd242e7e', 'ef0b16a4-f07a-4a2b-a000-4b970acdfbca', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('1247dc95-9c89-4a30-b4f0-926cb66182f1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Pseudo-Peripteros');
INSERT INTO "value_list_values" VALUES ('70ad17c2-3788-497a-98ab-17bd3ab25ca0', '1247dc95-9c89-4a30-b4f0-926cb66182f1', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('8f0585a8-d5ba-4fed-82a4-0a688c5e06dc', 'c0d76ff3-a711-42af-920d-09132a287015', 'Tholos');
INSERT INTO "value_list_values" VALUES ('5fb3ed0c-dc42-4bb7-bbe6-cc5b5b09d6d5', '8f0585a8-d5ba-4fed-82a4-0a688c5e06dc', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('c0b5eae4-489e-423f-9b5c-f5bd11988eec', 'c0d76ff3-a711-42af-920d-09132a287015', 'griechisches Theater');
INSERT INTO "value_list_values" VALUES ('a0278943-e937-48b8-bb72-50a5c85bb284', 'c0b5eae4-489e-423f-9b5c-f5bd11988eec', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('0a05d8f3-6f2a-4109-a9d9-98f735b1e1a7', 'c0d76ff3-a711-42af-920d-09132a287015', 'römisches Theater');
INSERT INTO "value_list_values" VALUES ('b3fd30e8-21c4-43c8-8247-27ceaab22d9a', '0a05d8f3-6f2a-4109-a9d9-98f735b1e1a7', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('970d207c-17b9-4913-a9f8-29e30ec5a102', 'c0d76ff3-a711-42af-920d-09132a287015', 'Atriumhaus');
INSERT INTO "value_list_values" VALUES ('c89e6dbf-d94f-45e9-8ca0-f3a9282d0bd2', '970d207c-17b9-4913-a9f8-29e30ec5a102', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('f483480e-30af-4cbc-b4ee-8356c46b6798', 'c0d76ff3-a711-42af-920d-09132a287015', 'Palast');
INSERT INTO "value_list_values" VALUES ('e991cdb3-a7ba-4403-990f-52a0df5f4791', 'f483480e-30af-4cbc-b4ee-8356c46b6798', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('2b0648f5-997f-45ac-8c5b-c08c6c6ae662', 'c0d76ff3-a711-42af-920d-09132a287015', 'Peristylhaus');
INSERT INTO "value_list_values" VALUES ('4a8126f2-4ae7-4533-9392-16af578d9f15', '2b0648f5-997f-45ac-8c5b-c08c6c6ae662', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('e9799948-e617-48d9-bf7d-4f1244137ba4', 'c0d76ff3-a711-42af-920d-09132a287015', 'Villa');
INSERT INTO "value_list_values" VALUES ('f8daf815-5804-4683-988d-9762a6c8deae', 'e9799948-e617-48d9-bf7d-4f1244137ba4', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('c1d56b1b-b0f9-498e-90f5-9be29ae54a29', 'c0d76ff3-a711-42af-920d-09132a287015', 'Schatzhaus');
INSERT INTO "value_list_values" VALUES ('aebb60c5-63ac-45a1-9176-1b67bb2a618a', 'c1d56b1b-b0f9-498e-90f5-9be29ae54a29', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('75745874-0c81-46c4-a5fa-b85939c1ae22', 'c0d76ff3-a711-42af-920d-09132a287015', 'Ehrensäule');
INSERT INTO "value_list_values" VALUES ('ff16f7c1-a1e3-46c3-8dcc-701396f82581', '75745874-0c81-46c4-a5fa-b85939c1ae22', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('8ddf9f51-5462-4e7a-9317-953e8751ccbb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Palästra');
INSERT INTO "value_list_values" VALUES ('4c390d00-0a74-49ff-a9b0-299e523d7bcd', '8ddf9f51-5462-4e7a-9317-953e8751ccbb', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('9b01d621-4711-4ad5-ac69-d9c8391419d5', 'c0d76ff3-a711-42af-920d-09132a287015', 'Rednertribüne');
INSERT INTO "value_list_values" VALUES ('cc92d995-ca43-4e27-9117-3ec0af23ed26', '9b01d621-4711-4ad5-ac69-d9c8391419d5', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');

INSERT INTO "localized_character_string" VALUES ('498c9bba-2b2c-4b93-987b-65ae05ab3695', 'c0d76ff3-a711-42af-920d-09132a287015', 'Terrassenheiligtum');
INSERT INTO "value_list_values" VALUES ('e949c9c2-beac-49a4-8b96-8026120ab4c0', '498c9bba-2b2c-4b93-987b-65ae05ab3695', NULL, true, '1cd29172-9b8a-4a64-a539-e44159d789f9');


INSERT INTO "localized_character_string" VALUES ('fccee49e-e45e-42d1-8175-e570cb9ce78b', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Kontext');
INSERT INTO "value_list" VALUES ('400a3a26-96b4-4125-8231-567b2645bdb3', 'fccee49e-e45e-42d1-8175-e570cb9ce78b', NULL);

INSERT INTO "localized_character_string" VALUES ('e168764e-7815-4959-9867-9a5732ec8cbb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Akropolis');
INSERT INTO "value_list_values" VALUES ('e2ac59a3-e48d-40d4-8f5f-aca8d0ed2683', 'e168764e-7815-4959-9867-9a5732ec8cbb', NULL, true, '400a3a26-96b4-4125-8231-567b2645bdb3');

INSERT INTO "localized_character_string" VALUES ('c30a4306-acda-4256-bc54-59d5c256e576', 'c0d76ff3-a711-42af-920d-09132a287015', 'Forum');
INSERT INTO "value_list_values" VALUES ('5b0c9f15-ff14-4944-b642-37de860c8ec5', 'c30a4306-acda-4256-bc54-59d5c256e576', NULL, true, '400a3a26-96b4-4125-8231-567b2645bdb3');

INSERT INTO "localized_character_string" VALUES ('4d3c822f-3036-4de3-bb54-e6864896803a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Heiligtum');
INSERT INTO "value_list_values" VALUES ('da161e34-cc95-4710-bb55-4b1ba88c8d2d', '4d3c822f-3036-4de3-bb54-e6864896803a', NULL, true, '400a3a26-96b4-4125-8231-567b2645bdb3');

INSERT INTO "localized_character_string" VALUES ('16225d8e-ba05-48f0-8ccf-a14600a50f96', 'c0d76ff3-a711-42af-920d-09132a287015', 'Nekropole');
INSERT INTO "value_list_values" VALUES ('889ef63a-3544-4029-8163-116d9ebae8d5', '16225d8e-ba05-48f0-8ccf-a14600a50f96', NULL, true, '400a3a26-96b4-4125-8231-567b2645bdb3');

INSERT INTO "localized_character_string" VALUES ('64620f03-4500-4f0b-85b8-05dd9bb987a9', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wohnviertel');
INSERT INTO "value_list_values" VALUES ('f0f26e25-a7ad-41dc-b028-0fee3abf5333', '64620f03-4500-4f0b-85b8-05dd9bb987a9', NULL, true, '400a3a26-96b4-4125-8231-567b2645bdb3');

INSERT INTO "localized_character_string" VALUES ('ee2fe8cf-e73a-4b97-9be8-dc1fdcb90a3a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Handwerksviertel');
INSERT INTO "value_list_values" VALUES ('77345c75-9cf4-4d02-96bf-3a680fc205ce', 'ee2fe8cf-e73a-4b97-9be8-dc1fdcb90a3a', NULL, true, '400a3a26-96b4-4125-8231-567b2645bdb3');


INSERT INTO "localized_character_string" VALUES ('113fb388-8df1-4397-876e-dcc1bc9dc7a9', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Bautechnik');
INSERT INTO "value_list" VALUES ('ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa', '113fb388-8df1-4397-876e-dcc1bc9dc7a9', NULL);

INSERT INTO "localized_character_string" VALUES ('5f5c2e57-8b58-4cad-9826-a4c49c08ee8d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bruchsteinmauerwerk');
INSERT INTO "value_list_values" VALUES ('2f07df6d-49b4-4aa4-8269-d31ecf97c095', '5f5c2e57-8b58-4cad-9826-a4c49c08ee8d', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('4dbf8120-a713-4442-a31d-101ec1c712d3', 'c0d76ff3-a711-42af-920d-09132a287015', 'Feldsteinmauerwerk');
INSERT INTO "value_list_values" VALUES ('41e84086-7e05-480c-8526-98f9a4d4fe3c', '4dbf8120-a713-4442-a31d-101ec1c712d3', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('9b003169-7653-47b9-95eb-70ef113ca83e', 'c0d76ff3-a711-42af-920d-09132a287015', 'Polygonalmauerwerk');
INSERT INTO "value_list_values" VALUES ('ee1771b7-b864-421a-8441-e69db0f811db', '9b003169-7653-47b9-95eb-70ef113ca83e', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('a5ff732d-763d-4349-a2dc-e289daf26b8b', 'c0d76ff3-a711-42af-920d-09132a287015', 'unregelmäßiges Polygonalmauerwerk');
INSERT INTO "value_list_values" VALUES ('d593d5e8-3373-4e76-8c70-276c344d04fb', 'a5ff732d-763d-4349-a2dc-e289daf26b8b', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('4e6c02a2-bca5-4215-9d8c-03e43d857754', 'c0d76ff3-a711-42af-920d-09132a287015', 'regelmäßiges Polygonalmauerwerk');
INSERT INTO "value_list_values" VALUES ('b24f453f-577c-4aa6-8ba7-80abb201d670', '4e6c02a2-bca5-4215-9d8c-03e43d857754', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('dcb67462-5701-4735-8339-3e619758be7f', 'c0d76ff3-a711-42af-920d-09132a287015', 'Kyklopenmauerwerk');
INSERT INTO "value_list_values" VALUES ('12affa95-084e-47e3-84cd-6f080d3c68d2', 'dcb67462-5701-4735-8339-3e619758be7f', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('eb2ae7e5-988e-4549-9a58-87b8146cf40e', 'c0d76ff3-a711-42af-920d-09132a287015', 'unregelmäßiges Trapezoidalmauerwerk');
INSERT INTO "value_list_values" VALUES ('4fc66798-ca7f-4634-808f-2a968ac382c4', 'eb2ae7e5-988e-4549-9a58-87b8146cf40e', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('17713fa5-853c-41f7-8aae-d02a07ded0db', 'c0d76ff3-a711-42af-920d-09132a287015', 'regelmäßiges Trapezoidalmauerwerk');
INSERT INTO "value_list_values" VALUES ('32dd006b-db7e-4233-9986-8aa2cb21bf00', '17713fa5-853c-41f7-8aae-d02a07ded0db', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('8b7bbf94-cf19-4672-962e-13493d0c2d08', 'c0d76ff3-a711-42af-920d-09132a287015', 'Quadermauerwerk');
INSERT INTO "value_list_values" VALUES ('83a78871-e429-4681-9a2e-fe31c5feff94', '8b7bbf94-cf19-4672-962e-13493d0c2d08', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('c0d086a9-3bba-44d4-801d-8b89f8219420', 'c0d76ff3-a711-42af-920d-09132a287015', 'unregelmäßiges Quadermauerwerk');
INSERT INTO "value_list_values" VALUES ('4a3b481a-cad5-4a63-94db-ccfeea615ae4', 'c0d086a9-3bba-44d4-801d-8b89f8219420', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('4648de61-d8e0-4592-9102-4b88ae7ddc8c', 'c0d76ff3-a711-42af-920d-09132a287015', 'regelmäßiges Quadermauerwerk');
INSERT INTO "value_list_values" VALUES ('438aeffa-dab1-4c95-8b8c-c86605f4429f', '4648de61-d8e0-4592-9102-4b88ae7ddc8c', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('b07897b4-17f2-439e-acb5-bc1bcc1a6fd7', 'c0d76ff3-a711-42af-920d-09132a287015', 'Mischform Polygonal-/Quadermauerwerk');
INSERT INTO "value_list_values" VALUES ('b310b3a2-a640-4d95-b3b2-452d47b83965', 'b07897b4-17f2-439e-acb5-bc1bcc1a6fd7', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('4769e249-260e-4743-b507-1f06441a3c56', 'c0d76ff3-a711-42af-920d-09132a287015', 'Würfel-/Handquadermauerwerk');
INSERT INTO "value_list_values" VALUES ('bb9806f1-26ee-42dd-8738-0a630fa52c53', '4769e249-260e-4743-b507-1f06441a3c56', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('63ccdf1a-0160-4151-bafa-8abffd5f9dfb', 'c0d76ff3-a711-42af-920d-09132a287015', 'Ziegelmauerwerk');
INSERT INTO "value_list_values" VALUES ('4f148bea-12f5-4dd2-a8c1-08498de82398', '63ccdf1a-0160-4151-bafa-8abffd5f9dfb', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('aa7b0038-6d30-4ccd-a805-50a29478fbe9', 'c0d76ff3-a711-42af-920d-09132a287015', 'Lehmziegelmauerwerk');
INSERT INTO "value_list_values" VALUES ('c55e6cd3-f27d-48f4-a674-fa090618644a', 'aa7b0038-6d30-4ccd-a805-50a29478fbe9', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('6df68e85-987e-42dc-a908-fa0643becda3', 'c0d76ff3-a711-42af-920d-09132a287015', 'Spolienmauerwerk');
INSERT INTO "value_list_values" VALUES ('e4c91acd-b491-44ce-984d-266a0c9f5b2a', '6df68e85-987e-42dc-a908-fa0643becda3', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('171249e1-f21f-4608-816f-ad2bb000a80e', 'c0d76ff3-a711-42af-920d-09132a287015', 'unspezifisches Mauerwerk');
INSERT INTO "value_list_values" VALUES ('ece8b564-cb15-498f-9408-a460d93885af', '171249e1-f21f-4608-816f-ad2bb000a80e', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('9d94609f-22c2-4d43-a92d-b534f8af2c82', 'c0d76ff3-a711-42af-920d-09132a287015', 'irreguläres Mauerwerk');
INSERT INTO "value_list_values" VALUES ('780a1db2-a6d4-4eb6-ab7e-5956585d0e61', '9d94609f-22c2-4d43-a92d-b534f8af2c82', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('c1b9682e-fa44-46bf-a944-626d2d200509', 'c0d76ff3-a711-42af-920d-09132a287015', 'Blockverbandmauerwerk');
INSERT INTO "value_list_values" VALUES ('4ed793d2-d8cf-4deb-8538-7231f69d84d2', 'c1b9682e-fa44-46bf-a944-626d2d200509', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');

INSERT INTO "localized_character_string" VALUES ('38a2374b-f0cb-4e46-9556-7aa96cbe7878', 'c0d76ff3-a711-42af-920d-09132a287015', 'Opus Camentitiummauerwerk');
INSERT INTO "value_list_values" VALUES ('cb6ccce0-ffe2-41ef-96a1-0ce68e1e74ff', '38a2374b-f0cb-4e46-9556-7aa96cbe7878', NULL, true, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');


/* Attributtypen und Attributtypgruppen */

/* Themenübergreifend */
INSERT INTO "localized_character_string" VALUES ('ee4e2c19-eb2c-49e0-a513-3f87b705dde3', 'c0d76ff3-a711-42af-920d-09132a287015', 'Metadaten_Ersteller');
INSERT INTO "attribute_type" VALUES ('a8c80bc2-6659-4d32-a931-972f3f9642b5','ee4e2c19-eb2c-49e0-a513-3f87b705dde3', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL); 

INSERT INTO "localized_character_string" VALUES ('3c2c35a2-0849-4602-bd22-8724106a94bc', 'c0d76ff3-a711-42af-920d-09132a287015', 'Metadaten_Erstellungsdatum');
INSERT INTO "attribute_type" VALUES ('91e807b7-34e1-4982-bf5f-ed196a9bd2d7','3c2c35a2-0849-4602-bd22-8724106a94bc', NULL, '1453be24-2b0c-4b40-a648-ecccf0f382a3', NULL, NULL); 

INSERT INTO "localized_character_string" VALUES ('afc6e4f2-eb24-4c40-8a9a-4adb9109c0f9', 'c0d76ff3-a711-42af-920d-09132a287015', 'Metadaten_Bearbeiter');
INSERT INTO "attribute_type" VALUES ('69b54426-9696-4656-b7fc-73da825f7620','afc6e4f2-eb24-4c40-8a9a-4adb9109c0f9', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL); 

INSERT INTO "localized_character_string" VALUES ('db68ea91-572f-4a90-a141-cea59e40db8a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Metadaten_Bearbeitungsdatum');
INSERT INTO "attribute_type" VALUES ('8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','db68ea91-572f-4a90-a141-cea59e40db8a', NULL, '1453be24-2b0c-4b40-a648-ecccf0f382a3', NULL, NULL); 

INSERT INTO "localized_character_string" VALUES ('5902234e-88d0-4073-9817-1d3d68be5c7c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Metadaten');
INSERT INTO "value_list_values" VALUES ('2981a5cb-6b7c-4cda-b2eb-46bf46694ca2', '5902234e-88d0-4073-9817-1d3d68be5c7c', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('a8c80bc2-6659-4d32-a931-972f3f9642b5','2981a5cb-6b7c-4cda-b2eb-46bf46694ca2');
INSERT INTO "attribute_type_group" VALUES ('91e807b7-34e1-4982-bf5f-ed196a9bd2d7','2981a5cb-6b7c-4cda-b2eb-46bf46694ca2');
INSERT INTO "attribute_type_group" VALUES ('69b54426-9696-4656-b7fc-73da825f7620','2981a5cb-6b7c-4cda-b2eb-46bf46694ca2');
INSERT INTO "attribute_type_group" VALUES ('8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','2981a5cb-6b7c-4cda-b2eb-46bf46694ca2');

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','a8c80bc2-6659-4d32-a931-972f3f9642b5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','91e807b7-34e1-4982-bf5f-ed196a9bd2d7','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','69b54426-9696-4656-b7fc-73da825f7620','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','8c1acb8a-93f9-4d7a-8c6b-2b51cdf1c647','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('169ec142-7eff-47c0-ab5c-038fc759e194', 'c0d76ff3-a711-42af-920d-09132a287015', 'Arbeitsnotiz');
INSERT INTO "attribute_type" VALUES ('1a488a53-66fc-41fd-82ee-05a40993fb1b','169ec142-7eff-47c0-ab5c-038fc759e194', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','1a488a53-66fc-41fd-82ee-05a40993fb1b','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','1a488a53-66fc-41fd-82ee-05a40993fb1b','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('5bdeb327-c198-4b1c-8a93-a03e971a616e', 'c0d76ff3-a711-42af-920d-09132a287015', 'Kampagne');
INSERT INTO "attribute_type" VALUES ('f5fafb4a-4645-4b4c-8161-807064aa3ae4','5bdeb327-c198-4b1c-8a93-a03e971a616e', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','f5fafb4a-4645-4b4c-8161-807064aa3ae4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','f5fafb4a-4645-4b4c-8161-807064aa3ae4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','f5fafb4a-4645-4b4c-8161-807064aa3ae4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','f5fafb4a-4645-4b4c-8161-807064aa3ae4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','f5fafb4a-4645-4b4c-8161-807064aa3ae4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

/* Bauwerk */

INSERT INTO "localized_character_string" VALUES ('389a794a-c632-4bae-8e0a-18ad69c7795f', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Nummer');
INSERT INTO "attribute_type" VALUES ('2883bdcd-1f55-4f4f-8d8d-c1d6c7bc2d1c','389a794a-c632-4bae-8e0a-18ad69c7795f', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL); 
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','2883bdcd-1f55-4f4f-8d8d-c1d6c7bc2d1c','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('2cd79f11-cfef-4fac-a706-50ddce75a5a8', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('0d7945eb-e3d1-46db-8368-68a3b8803db8','2cd79f11-cfef-4fac-a706-50ddce75a5a8', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL); 
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','0d7945eb-e3d1-46db-8368-68a3b8803db8','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('f71b2c0b-72e9-4075-a6ff-1af0f2164016', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Teilprojekt');
INSERT INTO "attribute_type" VALUES ('d4af0e7c-757e-47d1-874c-f42e6f36a23a','f71b2c0b-72e9-4075-a6ff-1af0f2164016', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL); 
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','d4af0e7c-757e-47d1-874c-f42e6f36a23a','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('263f7e96-1902-4178-8ce8-3106f12e99e1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Bezeichnung');
INSERT INTO "value_list_values" VALUES ('16b4e6c9-d12e-45a5-b54f-a7c703056b02', '263f7e96-1902-4178-8ce8-3106f12e99e1', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('2883bdcd-1f55-4f4f-8d8d-c1d6c7bc2d1c','16b4e6c9-d12e-45a5-b54f-a7c703056b02');
INSERT INTO "attribute_type_group" VALUES ('0d7945eb-e3d1-46db-8368-68a3b8803db8','16b4e6c9-d12e-45a5-b54f-a7c703056b02');
INSERT INTO "attribute_type_group" VALUES ('f5fafb4a-4645-4b4c-8161-807064aa3ae4','16b4e6c9-d12e-45a5-b54f-a7c703056b02');
INSERT INTO "attribute_type_group" VALUES ('d4af0e7c-757e-47d1-874c-f42e6f36a23a','16b4e6c9-d12e-45a5-b54f-a7c703056b02');

INSERT INTO "localized_character_string" VALUES ('13fcd3e7-d904-42ff-9717-68ddfebd0418', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_OrtAntik');
INSERT INTO "attribute_type" VALUES ('fc50f3f4-b16d-4af0-8d96-8452a2a4c486','13fcd3e7-d904-42ff-9717-68ddfebd0418', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','fc50f3f4-b16d-4af0-8d96-8452a2a4c486','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('2ed9f107-425b-4c63-8d7c-974320cac766', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_OrtModern');
INSERT INTO "attribute_type" VALUES ('08ada8aa-74de-4214-adfa-0877bb3f8486','2ed9f107-425b-4c63-8d7c-974320cac766', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','08ada8aa-74de-4214-adfa-0877bb3f8486','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('5152fce4-392c-4f98-b375-0aa81ee0527b', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Staat');
INSERT INTO "attribute_type" VALUES ('7a378ffb-38a7-48c4-8dab-f161f58fa3da','5152fce4-392c-4f98-b375-0aa81ee0527b', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','7a378ffb-38a7-48c4-8dab-f161f58fa3da','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('225dedb4-d0e3-416e-8585-918f5be85b37', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_ProvinzModern');
INSERT INTO "attribute_type" VALUES ('0c9836b3-b0ac-4a72-a3c6-707a4beb02dd','225dedb4-d0e3-416e-8585-918f5be85b37', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','0c9836b3-b0ac-4a72-a3c6-707a4beb02dd','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('b7d61a4b-6bf7-42ba-b1e4-8af5b63c0ac6', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_ProvinzAntik');
INSERT INTO "attribute_type" VALUES ('368c0204-d0f1-4862-a0c4-f5253d5e1eaa','b7d61a4b-6bf7-42ba-b1e4-8af5b63c0ac6', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','368c0204-d0f1-4862-a0c4-f5253d5e1eaa','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('d12605e4-aac7-47aa-bb0b-cf300a79e5ad', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Lokalisierung');
INSERT INTO "attribute_type" VALUES ('e0e8ab7a-58ad-4fa0-b3e1-1654e32145a3','d12605e4-aac7-47aa-bb0b-cf300a79e5ad', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','e0e8ab7a-58ad-4fa0-b3e1-1654e32145a3','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('9c31d2ba-d096-43bf-ab16-8d8763da53d8', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Lage');
INSERT INTO "value_list_values" VALUES ('e0fa961e-b407-4bca-97e8-dbf166d424dc', '9c31d2ba-d096-43bf-ab16-8d8763da53d8', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('fc50f3f4-b16d-4af0-8d96-8452a2a4c486','e0fa961e-b407-4bca-97e8-dbf166d424dc');
INSERT INTO "attribute_type_group" VALUES ('08ada8aa-74de-4214-adfa-0877bb3f8486','e0fa961e-b407-4bca-97e8-dbf166d424dc');
INSERT INTO "attribute_type_group" VALUES ('7a378ffb-38a7-48c4-8dab-f161f58fa3da','e0fa961e-b407-4bca-97e8-dbf166d424dc');
INSERT INTO "attribute_type_group" VALUES ('0c9836b3-b0ac-4a72-a3c6-707a4beb02dd','e0fa961e-b407-4bca-97e8-dbf166d424dc');
INSERT INTO "attribute_type_group" VALUES ('368c0204-d0f1-4862-a0c4-f5253d5e1eaa','e0fa961e-b407-4bca-97e8-dbf166d424dc');
INSERT INTO "attribute_type_group" VALUES ('e0e8ab7a-58ad-4fa0-b3e1-1654e32145a3','e0fa961e-b407-4bca-97e8-dbf166d424dc');


/* Bautyp */
INSERT INTO "attribute_type" VALUES ('589dcd84-a9a0-4700-b152-7d1edd32498d','31089a15-5e6b-4191-ab2e-edcd2646d3f5', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, '6faa9420-feae-4675-aa90-cc929b74680f');
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','589dcd84-a9a0-4700-b152-7d1edd32498d','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

/* BautypSpeziell */

INSERT INTO "attribute_type" VALUES ('08a8bf77-d82e-49c6-8c5f-77738a991afd','cf42eb69-e0be-4865-9679-a236ba3a67e1', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, '1cd29172-9b8a-4a64-a539-e44159d789f9');
 INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','08a8bf77-d82e-49c6-8c5f-77738a991afd','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

/* Kontext */

INSERT INTO "attribute_type" VALUES ('4fadfa81-5e98-44d2-a4a3-9eeae4b6d580','fccee49e-e45e-42d1-8175-e570cb9ce78b', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, '400a3a26-96b4-4125-8231-567b2645bdb3');
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','4fadfa81-5e98-44d2-a4a3-9eeae4b6d580','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

/* Bautechnik */

INSERT INTO "attribute_type" VALUES ('c094bb59-7b5b-42b4-a97a-de1b995dee80','113fb388-8df1-4397-876e-dcc1bc9dc7a9', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, 'ae5f8ce7-3aab-4c64-aa77-72978c4eb7aa');
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','c094bb59-7b5b-42b4-a97a-de1b995dee80','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);


/* Baumaterialien */

INSERT INTO "localized_character_string" VALUES ('96820c78-547e-47b0-9be1-6a9faca2bdfa', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Baumaterialien');
INSERT INTO "attribute_type" VALUES ('997b632b-8a7f-47fe-83c5-072808cb260f','96820c78-547e-47b0-9be1-6a9faca2bdfa', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','997b632b-8a7f-47fe-83c5-072808cb260f','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('a4166f8e-8c34-416c-9baf-619b111547cd', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Klassifizierung');
INSERT INTO "value_list_values" VALUES ('f88e9dad-e9ac-4558-bc0d-b9f10a83a87a', 'a4166f8e-8c34-416c-9baf-619b111547cd', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('997b632b-8a7f-47fe-83c5-072808cb260f','f88e9dad-e9ac-4558-bc0d-b9f10a83a87a');
INSERT INTO "attribute_type_group" VALUES ('c094bb59-7b5b-42b4-a97a-de1b995dee80','f88e9dad-e9ac-4558-bc0d-b9f10a83a87a');
INSERT INTO "attribute_type_group" VALUES ('4fadfa81-5e98-44d2-a4a3-9eeae4b6d580','f88e9dad-e9ac-4558-bc0d-b9f10a83a87a');
INSERT INTO "attribute_type_group" VALUES ('08a8bf77-d82e-49c6-8c5f-77738a991afd','f88e9dad-e9ac-4558-bc0d-b9f10a83a87a');
INSERT INTO "attribute_type_group" VALUES ('589dcd84-a9a0-4700-b152-7d1edd32498d','f88e9dad-e9ac-4558-bc0d-b9f10a83a87a');

INSERT INTO "localized_character_string" VALUES ('3ceb050a-098e-4c3b-881d-c810288ca293', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Beschreibung');
INSERT INTO "attribute_type" VALUES ('72041520-e51d-401f-977e-608273a2339e','3ceb050a-098e-4c3b-881d-c810288ca293', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','72041520-e51d-401f-977e-608273a2339e','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('2e357c18-3d15-4d1c-aa85-d382f300dedc', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Erhaltung');
INSERT INTO "attribute_type" VALUES ('8f8c9b0b-3a84-499b-9657-89e1bd47f7ce','2e357c18-3d15-4d1c-aa85-d382f300dedc', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','8f8c9b0b-3a84-499b-9657-89e1bd47f7ce','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('bbce24e9-37c1-4f94-ae4e-ab9d602d2fa3', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Beschreibungen');
INSERT INTO "value_list_values" VALUES ('e20bd0d6-7ae6-4e24-becb-485d2c21090e', 'bbce24e9-37c1-4f94-ae4e-ab9d602d2fa3', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('72041520-e51d-401f-977e-608273a2339e','e20bd0d6-7ae6-4e24-becb-485d2c21090e');
INSERT INTO "attribute_type_group" VALUES ('8f8c9b0b-3a84-499b-9657-89e1bd47f7ce','e20bd0d6-7ae6-4e24-becb-485d2c21090e');

INSERT INTO "localized_character_string" VALUES ('45f37eeb-df31-4606-b658-ed433495422d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Ausgrabungsgeschichte');
INSERT INTO "attribute_type" VALUES ('0213c1bd-e3c9-48c5-92a1-241f5b1f67c6','45f37eeb-df31-4606-b658-ed433495422d', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','0213c1bd-e3c9-48c5-92a1-241f5b1f67c6','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('2a18a278-eb7b-46fd-92c3-bcbb52e98ce0', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Forschungsgeschichte');
INSERT INTO "attribute_type" VALUES ('5a2cbbee-a2c0-43c4-873f-c76fadfb9f29','2a18a278-eb7b-46fd-92c3-bcbb52e98ce0', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','5a2cbbee-a2c0-43c4-873f-c76fadfb9f29','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('d8197ebf-9cce-451a-9bd7-c2fb8ae26070', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Geschichte');
INSERT INTO "attribute_type" VALUES ('7129abc4-3ed0-4e1d-844e-3e984d21e43e','d8197ebf-9cce-451a-9bd7-c2fb8ae26070', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','7129abc4-3ed0-4e1d-844e-3e984d21e43e','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('80413d33-08cc-4ecf-9c06-e1bff8a758d2', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bauwerk_Restaurierung');
INSERT INTO "attribute_type" VALUES ('a7fbcdad-ca80-4032-9156-a35b6ef9b95a','80413d33-08cc-4ecf-9c06-e1bff8a758d2', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('404bc61c-5629-463e-9612-7320c3750f1f','a7fbcdad-ca80-4032-9156-a35b6ef9b95a','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "value_list_values" VALUES ('40e81f06-f314-473a-82d5-70f8d8d6f0e4', 'd8197ebf-9cce-451a-9bd7-c2fb8ae26070', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('a7fbcdad-ca80-4032-9156-a35b6ef9b95a','40e81f06-f314-473a-82d5-70f8d8d6f0e4');
INSERT INTO "attribute_type_group" VALUES ('7129abc4-3ed0-4e1d-844e-3e984d21e43e','40e81f06-f314-473a-82d5-70f8d8d6f0e4');
INSERT INTO "attribute_type_group" VALUES ('5a2cbbee-a2c0-43c4-873f-c76fadfb9f29','40e81f06-f314-473a-82d5-70f8d8d6f0e4');
INSERT INTO "attribute_type_group" VALUES ('0213c1bd-e3c9-48c5-92a1-241f5b1f67c6','40e81f06-f314-473a-82d5-70f8d8d6f0e4');

/* Raum */

INSERT INTO "localized_character_string" VALUES ('4cd2fea0-d796-4e9d-876e-e3f06875c434', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Breite');
INSERT INTO "attribute_type" VALUES ('0f31a70e-dcc3-4aeb-85f3-910f04f2f551','4cd2fea0-d796-4e9d-876e-e3f06875c434', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','0f31a70e-dcc3-4aeb-85f3-910f04f2f551','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('9f11ce64-676f-4233-ae4b-330d7c066f64', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Fläche');
INSERT INTO "attribute_type" VALUES ('8bd9d36c-b055-4d68-a990-7622ef21e073','9f11ce64-676f-4233-ae4b-330d7c066f64', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', 'c5fcd4bd-83e6-4ac7-90a0-5d015c89655e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','8bd9d36c-b055-4d68-a990-7622ef21e073','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('765b56be-3298-4541-af71-cf72634cc08f', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Länge');
INSERT INTO "attribute_type" VALUES ('68c5a831-c44f-4bcc-8b40-0ec568e40aa4','765b56be-3298-4541-af71-cf72634cc08f', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','68c5a831-c44f-4bcc-8b40-0ec568e40aa4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('39a5de04-c088-42fd-92df-3d92241b1582', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Laufniveau');
INSERT INTO "attribute_type" VALUES ('204ff974-debe-4dff-8237-804529d0d0a2','39a5de04-c088-42fd-92df-3d92241b1582', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','204ff974-debe-4dff-8237-804529d0d0a2','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('7e464505-444d-432c-8f81-4de70bcf7578', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Maße');
INSERT INTO "value_list_values" VALUES ('2b9b38d8-eed8-4ccc-a187-b8e8570cda63', '7e464505-444d-432c-8f81-4de70bcf7578', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('0f31a70e-dcc3-4aeb-85f3-910f04f2f551','2b9b38d8-eed8-4ccc-a187-b8e8570cda63');
INSERT INTO "attribute_type_group" VALUES ('8bd9d36c-b055-4d68-a990-7622ef21e073','2b9b38d8-eed8-4ccc-a187-b8e8570cda63');
INSERT INTO "attribute_type_group" VALUES ('68c5a831-c44f-4bcc-8b40-0ec568e40aa4','2b9b38d8-eed8-4ccc-a187-b8e8570cda63');
INSERT INTO "attribute_type_group" VALUES ('204ff974-debe-4dff-8237-804529d0d0a2','2b9b38d8-eed8-4ccc-a187-b8e8570cda63');

INSERT INTO "localized_character_string" VALUES ('12a98f53-5841-4433-9245-af838c91fb75', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('3357774a-f0a9-48f3-a4a8-26bf02b3cb45','12a98f53-5841-4433-9245-af838c91fb75', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','3357774a-f0a9-48f3-a4a8-26bf02b3cb45','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('a918c5eb-dae8-499d-8ee5-9108bab718f4', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Nummer');
INSERT INTO "attribute_type" VALUES ('204b4eb9-836a-400c-9bba-1e59c4fa82d2','a918c5eb-dae8-499d-8ee5-9108bab718f4', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('b8bc4a79-69b6-445c-874c-f978dea5c641','204b4eb9-836a-400c-9bba-1e59c4fa82d2','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('577fcdb0-5d03-4201-bb90-72f9c459f0ee', 'c0d76ff3-a711-42af-920d-09132a287015', 'Raum_Beschreibung');
INSERT INTO "value_list_values" VALUES ('d73f1c03-77e4-4c4e-9ee1-c46fdab01956', '577fcdb0-5d03-4201-bb90-72f9c459f0ee', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('3357774a-f0a9-48f3-a4a8-26bf02b3cb45','d73f1c03-77e4-4c4e-9ee1-c46fdab01956');
INSERT INTO "attribute_type_group" VALUES ('204b4eb9-836a-400c-9bba-1e59c4fa82d2','d73f1c03-77e4-4c4e-9ee1-c46fdab01956');

/* Wand */

INSERT INTO "localized_character_string" VALUES ('a13292d7-e740-4b4b-8399-0c1c9633dd18', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Nummer');
INSERT INTO "attribute_type" VALUES ('d604eed6-e07c-4d3c-bfdb-a09a31df0ccc','a13292d7-e740-4b4b-8399-0c1c9633dd18', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','d604eed6-e07c-4d3c-bfdb-a09a31df0ccc','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('67648f2c-a6b3-415c-a812-e72a120bf2e6', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Mauerseite');
INSERT INTO "attribute_type" VALUES ('ccd14f94-3c3d-44c6-9747-793a0b5bbf5e','67648f2c-a6b3-415c-a812-e72a120bf2e6', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','ccd14f94-3c3d-44c6-9747-793a0b5bbf5e','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('fedc3325-df3e-4c45-9c13-95708dbf2ff8', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Wandflaeche');
INSERT INTO "attribute_type" VALUES ('009ab454-4b84-40fe-b45e-a9ea4ab9b418','fedc3325-df3e-4c45-9c13-95708dbf2ff8', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','009ab454-4b84-40fe-b45e-a9ea4ab9b418','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('463243c7-8477-4667-b541-db7ae175b21a', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Allgemein');
INSERT INTO "value_list_values" VALUES ('5cf553af-f4aa-440f-acd0-16be6716c57d', '463243c7-8477-4667-b541-db7ae175b21a', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('d604eed6-e07c-4d3c-bfdb-a09a31df0ccc','5cf553af-f4aa-440f-acd0-16be6716c57d');
INSERT INTO "attribute_type_group" VALUES ('ccd14f94-3c3d-44c6-9747-793a0b5bbf5e','5cf553af-f4aa-440f-acd0-16be6716c57d');
INSERT INTO "attribute_type_group" VALUES ('009ab454-4b84-40fe-b45e-a9ea4ab9b418','5cf553af-f4aa-440f-acd0-16be6716c57d');

INSERT INTO "localized_character_string" VALUES ('586ee5eb-ea24-424c-9886-a5b11c55d7ae', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Laenge');
INSERT INTO "attribute_type" VALUES ('1d61ee86-d553-4cd4-b05a-ebc485de2a84','586ee5eb-ea24-424c-9886-a5b11c55d7ae', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','1d61ee86-d553-4cd4-b05a-ebc485de2a84','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('16142026-c1bc-4774-bead-ee8842717021', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Hoehe');
INSERT INTO "attribute_type" VALUES ('3fc1a828-3fe1-4329-956c-176073220bfe','16142026-c1bc-4774-bead-ee8842717021', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','3fc1a828-3fe1-4329-956c-176073220bfe','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('402f107b-7557-4667-804b-53a86e24ab7d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Maße');
INSERT INTO "value_list_values" VALUES ('91104f9b-9bb4-43c8-9654-ab0e4ce2a436', '402f107b-7557-4667-804b-53a86e24ab7d', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('1d61ee86-d553-4cd4-b05a-ebc485de2a84','91104f9b-9bb4-43c8-9654-ab0e4ce2a436');
INSERT INTO "attribute_type_group" VALUES ('3fc1a828-3fe1-4329-956c-176073220bfe','91104f9b-9bb4-43c8-9654-ab0e4ce2a436');

INSERT INTO "localized_character_string" VALUES ('156d1613-4080-4eb1-8ce8-d790f6deb47c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Mauertechnik');
INSERT INTO "attribute_type" VALUES ('53ec3080-0514-45c6-9912-7e9bf7950cfc','156d1613-4080-4eb1-8ce8-d790f6deb47c', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','53ec3080-0514-45c6-9912-7e9bf7950cfc','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('31bfed38-e023-4e8d-8a76-a3604bc6e1f1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_MauerKonstruktionsdetails');
INSERT INTO "attribute_type" VALUES ('84b42fdb-fbe5-48f2-ba93-fbefdd297873','31bfed38-e023-4e8d-8a76-a3604bc6e1f1', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','84b42fdb-fbe5-48f2-ba93-fbefdd297873','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('a84b574e-8e62-4b4d-8d6e-e619c89dfd74', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_MauerKonstruktionsdetailsBeschreibung');
INSERT INTO "attribute_type" VALUES ('e5df658c-f312-4935-a33c-6f49e88cfe9a','a84b574e-8e62-4b4d-8d6e-e619c89dfd74', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','e5df658c-f312-4935-a33c-6f49e88cfe9a','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('0397b6cf-daf5-48c7-95af-c0266cfce17c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Fugengestaltung');
INSERT INTO "attribute_type" VALUES ('c5e006e5-5a0a-48fa-ad91-0d116bf3e217','0397b6cf-daf5-48c7-95af-c0266cfce17c', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','c5e006e5-5a0a-48fa-ad91-0d116bf3e217','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('107a680d-e9ae-421e-887d-a754cac369bc', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_SteinblockBearbeitung');
INSERT INTO "attribute_type" VALUES ('1a2edd14-2192-4a01-bda1-54bcbc742c7a','107a680d-e9ae-421e-887d-a754cac369bc', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','1a2edd14-2192-4a01-bda1-54bcbc742c7a','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('47c857b2-7bb7-4d36-8758-cd44a94984fe', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Mauer');
INSERT INTO "value_list_values" VALUES ('2547f52c-5086-46b3-964f-0032e905bcc0', '47c857b2-7bb7-4d36-8758-cd44a94984fe', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('53ec3080-0514-45c6-9912-7e9bf7950cfc','2547f52c-5086-46b3-964f-0032e905bcc0');
INSERT INTO "attribute_type_group" VALUES ('84b42fdb-fbe5-48f2-ba93-fbefdd297873','2547f52c-5086-46b3-964f-0032e905bcc0');
INSERT INTO "attribute_type_group" VALUES ('e5df658c-f312-4935-a33c-6f49e88cfe9a','2547f52c-5086-46b3-964f-0032e905bcc0');
INSERT INTO "attribute_type_group" VALUES ('c5e006e5-5a0a-48fa-ad91-0d116bf3e217','2547f52c-5086-46b3-964f-0032e905bcc0');
INSERT INTO "attribute_type_group" VALUES ('1a2edd14-2192-4a01-bda1-54bcbc742c7a','2547f52c-5086-46b3-964f-0032e905bcc0');

INSERT INTO "localized_character_string" VALUES ('3fbe389c-2c29-45bf-b648-e1b30183f592', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_BeschreibungWandgestaltung');
INSERT INTO "attribute_type" VALUES ('2e5a5c0e-1f3d-4cf3-ae5a-cea06e2602b0','3fbe389c-2c29-45bf-b648-e1b30183f592', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','2e5a5c0e-1f3d-4cf3-ae5a-cea06e2602b0','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('d5afb543-89ad-4420-a7a9-e4b8d11a8cba', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_VerputzMalschicht');
INSERT INTO "attribute_type" VALUES ('a6b20bcc-556b-413f-8faa-bde3271f696a','d5afb543-89ad-4420-a7a9-e4b8d11a8cba', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','a6b20bcc-556b-413f-8faa-bde3271f696a','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('2b5e1bcb-1adc-467c-a43d-0424d773cae6', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_VerputzAeltererPutz');
INSERT INTO "attribute_type" VALUES ('2b64820a-2e6c-4652-bb12-ff56d53636c8','2b5e1bcb-1adc-467c-a43d-0424d773cae6', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','2b64820a-2e6c-4652-bb12-ff56d53636c8','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('7dc24ebc-086d-489c-a4ca-a330e8beb688', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_VerputzDekoration');
INSERT INTO "attribute_type" VALUES ('749f1e3e-a9b5-4d38-b60e-cfdb4516ddb5','7dc24ebc-086d-489c-a4ca-a330e8beb688', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','749f1e3e-a9b5-4d38-b60e-cfdb4516ddb5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('9d2f9955-1906-490a-a6dd-ffe147649422', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Wandgestaltung');
INSERT INTO "value_list_values" VALUES ('7b5d94b7-49f5-4721-b204-064b3c4a9c3d', '9d2f9955-1906-490a-a6dd-ffe147649422', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('2e5a5c0e-1f3d-4cf3-ae5a-cea06e2602b0','7b5d94b7-49f5-4721-b204-064b3c4a9c3d');
INSERT INTO "attribute_type_group" VALUES ('a6b20bcc-556b-413f-8faa-bde3271f696a','7b5d94b7-49f5-4721-b204-064b3c4a9c3d');
INSERT INTO "attribute_type_group" VALUES ('2b64820a-2e6c-4652-bb12-ff56d53636c8','7b5d94b7-49f5-4721-b204-064b3c4a9c3d');
INSERT INTO "attribute_type_group" VALUES ('749f1e3e-a9b5-4d38-b60e-cfdb4516ddb5','7b5d94b7-49f5-4721-b204-064b3c4a9c3d');

INSERT INTO "localized_character_string" VALUES ('6df9f238-a971-4868-9cd4-57ad427bd262', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_VerputzErhaltung');
INSERT INTO "attribute_type" VALUES ('5ec538a9-8266-4a73-bbb7-583d04c2b45c','6df9f238-a971-4868-9cd4-57ad427bd262', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','5ec538a9-8266-4a73-bbb7-583d04c2b45c','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('94d30f25-077b-47ab-8cb6-866839592ce9', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_MauerErhaltungOberflaeche');
INSERT INTO "attribute_type" VALUES ('aa9cb46a-9201-46c6-be21-3e63e5f848cd','94d30f25-077b-47ab-8cb6-866839592ce9', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','aa9cb46a-9201-46c6-be21-3e63e5f848cd','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('9b509f3a-aceb-4bdd-90bb-b3e55613b2da', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_MauerErhaltungFugen');
INSERT INTO "attribute_type" VALUES ('28950d49-2ce2-48fd-a011-fe0f0d008dbf','9b509f3a-aceb-4bdd-90bb-b3e55613b2da', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('4a7eaa6d-31ae-4869-bc36-c4eea089b4e4','28950d49-2ce2-48fd-a011-fe0f0d008dbf','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('b54371f7-5313-4f61-a483-9456ca83bc2b', 'c0d76ff3-a711-42af-920d-09132a287015', 'Wand_Erhaltung');
INSERT INTO "value_list_values" VALUES ('effad859-338d-480e-a16c-baa9e0e72bda', 'b54371f7-5313-4f61-a483-9456ca83bc2b', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('5ec538a9-8266-4a73-bbb7-583d04c2b45c','effad859-338d-480e-a16c-baa9e0e72bda');
INSERT INTO "attribute_type_group" VALUES ('aa9cb46a-9201-46c6-be21-3e63e5f848cd','effad859-338d-480e-a16c-baa9e0e72bda');
INSERT INTO "attribute_type_group" VALUES ('28950d49-2ce2-48fd-a011-fe0f0d008dbf','effad859-338d-480e-a16c-baa9e0e72bda');

/* Abhub */

INSERT INTO "localized_character_string" VALUES ('629c3e7b-d592-492d-92b3-8ba66cac9403', 'c0d76ff3-a711-42af-920d-09132a287015', 'Abhub_Nummer');
INSERT INTO "attribute_type" VALUES ('d6a88bc5-9335-4bff-8be4-93e01281af37','629c3e7b-d592-492d-92b3-8ba66cac9403', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','d6a88bc5-9335-4bff-8be4-93e01281af37','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('e6bec961-2e67-4714-b0c4-babab9b52731', 'c0d76ff3-a711-42af-920d-09132a287015', 'Abhub_Beschreibung');
INSERT INTO "attribute_type" VALUES ('6f8d9576-e1d9-43ac-9d52-940c90a5813c','e6bec961-2e67-4714-b0c4-babab9b52731', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','6f8d9576-e1d9-43ac-9d52-940c90a5813c','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('ba2bddfd-e837-4b7c-94e9-8707fd321d2d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Abhub_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('66e7849d-4950-47d5-9144-9bc2b51283d4','ba2bddfd-e837-4b7c-94e9-8707fd321d2d', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','66e7849d-4950-47d5-9144-9bc2b51283d4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('f037b14c-883d-45ac-8aad-554e19ab857c', 'c0d76ff3-a711-42af-920d-09132a287015', 'Abhub_Stärke');
INSERT INTO "attribute_type" VALUES ('58cfba8d-6619-4870-9b69-04a5273e23a1','f037b14c-883d-45ac-8aad-554e19ab857c', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('1173b284-5059-4f6a-b56f-4f92b1d629a3','58cfba8d-6619-4870-9b69-04a5273e23a1','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('66776783-2c6f-44b1-8910-f15058236698', 'c0d76ff3-a711-42af-920d-09132a287015', 'Allgemein');
INSERT INTO "value_list_values" VALUES ('882ff78f-39aa-478f-85ae-54ce462a3f74', '66776783-2c6f-44b1-8910-f15058236698', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('d6a88bc5-9335-4bff-8be4-93e01281af37','882ff78f-39aa-478f-85ae-54ce462a3f74');
INSERT INTO "attribute_type_group" VALUES ('6f8d9576-e1d9-43ac-9d52-940c90a5813c','882ff78f-39aa-478f-85ae-54ce462a3f74');
INSERT INTO "attribute_type_group" VALUES ('f5fafb4a-4645-4b4c-8161-807064aa3ae4','882ff78f-39aa-478f-85ae-54ce462a3f74');
INSERT INTO "attribute_type_group" VALUES ('66e7849d-4950-47d5-9144-9bc2b51283d4','882ff78f-39aa-478f-85ae-54ce462a3f74');
INSERT INTO "attribute_type_group" VALUES ('58cfba8d-6619-4870-9b69-04a5273e23a1','882ff78f-39aa-478f-85ae-54ce462a3f74');

/* Planum */

INSERT INTO "localized_character_string" VALUES ('88a74003-35a4-4d0c-ae0e-d133f7bb9441', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Nummer');
INSERT INTO "attribute_type" VALUES ('3689fbd3-f3ef-44f5-ad43-9b01a343cac5','88a74003-35a4-4d0c-ae0e-d133f7bb9441', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','3689fbd3-f3ef-44f5-ad43-9b01a343cac5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('7998ea81-3d09-40c5-8151-14c0c2d5e5c1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('49c7e244-8d1e-4ce2-b9a9-c533eb7acf51','7998ea81-3d09-40c5-8151-14c0c2d5e5c1', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','49c7e244-8d1e-4ce2-b9a9-c533eb7acf51','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('55d357d9-68da-4274-84bb-0f222426e30f', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Datum');
INSERT INTO "attribute_type" VALUES ('ccbae929-83bd-44b1-8f79-2b57b11c6b5e','55d357d9-68da-4274-84bb-0f222426e30f', NULL, '1453be24-2b0c-4b40-a648-ecccf0f382a3', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','ccbae929-83bd-44b1-8f79-2b57b11c6b5e','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('fbde4c3b-8c83-4283-8480-a39c726a31b1', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Allgemein');
INSERT INTO "value_list_values" VALUES ('a353cc66-f69b-4c0e-8bb9-d21ca534af10', 'fbde4c3b-8c83-4283-8480-a39c726a31b1', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('3689fbd3-f3ef-44f5-ad43-9b01a343cac5','a353cc66-f69b-4c0e-8bb9-d21ca534af10');
INSERT INTO "attribute_type_group" VALUES ('49c7e244-8d1e-4ce2-b9a9-c533eb7acf51','a353cc66-f69b-4c0e-8bb9-d21ca534af10');
INSERT INTO "attribute_type_group" VALUES ('f5fafb4a-4645-4b4c-8161-807064aa3ae4','a353cc66-f69b-4c0e-8bb9-d21ca534af10');
INSERT INTO "attribute_type_group" VALUES ('ccbae929-83bd-44b1-8f79-2b57b11c6b5e','a353cc66-f69b-4c0e-8bb9-d21ca534af10');

INSERT INTO "localized_character_string" VALUES ('9f6c1189-53aa-4424-b6e8-ae0186c44811', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Beschreibung');
INSERT INTO "attribute_type" VALUES ('fe5bce12-2f07-4cbd-8d6d-ddf674953831','9f6c1189-53aa-4424-b6e8-ae0186c44811', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','fe5bce12-2f07-4cbd-8d6d-ddf674953831','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('2c1a48b1-1bd9-4ee2-8a95-5bf4666f47ff', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Horizontallage');
INSERT INTO "attribute_type" VALUES ('23068153-cdd3-4f55-af24-f321146bc9f3','2c1a48b1-1bd9-4ee2-8a95-5bf4666f47ff', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','23068153-cdd3-4f55-af24-f321146bc9f3','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('37f8156b-7c50-49fe-b68e-1bdf50f2a267', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_Flaechenform');
INSERT INTO "attribute_type" VALUES ('0e3f1dca-bece-4c09-8216-1518a0a52cf0','37f8156b-7c50-49fe-b68e-1bdf50f2a267', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','0e3f1dca-bece-4c09-8216-1518a0a52cf0','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('1b8d6c6f-97f4-433e-b1f1-1898651ba3d4', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_RelativeTiefe');
INSERT INTO "attribute_type" VALUES ('1a4fe2d1-e398-4b39-b719-b80513e8e5c2','1b8d6c6f-97f4-433e-b1f1-1898651ba3d4', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '81f2c264-feef-4d87-bd46-5c3e5e911b8e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','1a4fe2d1-e398-4b39-b719-b80513e8e5c2','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('8cd7ec8f-18c0-4c0a-96dd-ae78b434f86e', 'c0d76ff3-a711-42af-920d-09132a287015', 'Planum_RelativeTiefeBezugspunkt');
INSERT INTO "attribute_type" VALUES ('13d25341-1b42-4a81-a22d-35bbe220107b','8cd7ec8f-18c0-4c0a-96dd-ae78b434f86e', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('0b1e15c7-6d27-481c-9080-962c11d9cba8','13d25341-1b42-4a81-a22d-35bbe220107b','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "value_list_values" VALUES ('fa0de815-313d-444d-8b2b-7b82d838912b', '9f6c1189-53aa-4424-b6e8-ae0186c44811', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('fe5bce12-2f07-4cbd-8d6d-ddf674953831','fa0de815-313d-444d-8b2b-7b82d838912b');
INSERT INTO "attribute_type_group" VALUES ('23068153-cdd3-4f55-af24-f321146bc9f3','fa0de815-313d-444d-8b2b-7b82d838912b');
INSERT INTO "attribute_type_group" VALUES ('0e3f1dca-bece-4c09-8216-1518a0a52cf0','fa0de815-313d-444d-8b2b-7b82d838912b');
INSERT INTO "attribute_type_group" VALUES ('1a4fe2d1-e398-4b39-b719-b80513e8e5c2','fa0de815-313d-444d-8b2b-7b82d838912b');
INSERT INTO "attribute_type_group" VALUES ('13d25341-1b42-4a81-a22d-35bbe220107b','fa0de815-313d-444d-8b2b-7b82d838912b');

/* Profil */

INSERT INTO "localized_character_string" VALUES ('2741fe6c-c9f1-4a91-8df1-949d681a1528', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Nummer');
INSERT INTO "attribute_type" VALUES ('8ba2963d-5cc6-4c02-8452-8d52ca3eba1a','2741fe6c-c9f1-4a91-8df1-949d681a1528', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','8ba2963d-5cc6-4c02-8452-8d52ca3eba1a','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('aa4b99e7-4f57-43e0-9167-64e398f2a850', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Datum');
INSERT INTO "attribute_type" VALUES ('828ce7c7-ff2f-49a4-8de0-8d16271bd797','aa4b99e7-4f57-43e0-9167-64e398f2a850', NULL, '1453be24-2b0c-4b40-a648-ecccf0f382a3', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','828ce7c7-ff2f-49a4-8de0-8d16271bd797','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('1b05a8e3-3e37-4934-8884-7ba0324014cf', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('caaccd83-0e7c-482c-a2cb-56efc7d52ebe','1b05a8e3-3e37-4934-8884-7ba0324014cf', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','caaccd83-0e7c-482c-a2cb-56efc7d52ebe','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('6ae17f8b-e6d8-43a6-96dc-698c6b7591bf', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Allgemein');
INSERT INTO "value_list_values" VALUES ('0d89a318-a2c9-4486-b4c2-38047cab7e82', '6ae17f8b-e6d8-43a6-96dc-698c6b7591bf', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('8ba2963d-5cc6-4c02-8452-8d52ca3eba1a','0d89a318-a2c9-4486-b4c2-38047cab7e82');
INSERT INTO "attribute_type_group" VALUES ('828ce7c7-ff2f-49a4-8de0-8d16271bd797','0d89a318-a2c9-4486-b4c2-38047cab7e82');
INSERT INTO "attribute_type_group" VALUES ('f5fafb4a-4645-4b4c-8161-807064aa3ae4','0d89a318-a2c9-4486-b4c2-38047cab7e82');
INSERT INTO "attribute_type_group" VALUES ('caaccd83-0e7c-482c-a2cb-56efc7d52ebe','0d89a318-a2c9-4486-b4c2-38047cab7e82');

INSERT INTO "localized_character_string" VALUES ('2955614e-1b8d-4486-a77b-fed927b0f215', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Beschreibung');
INSERT INTO "attribute_type" VALUES ('e550c558-b3b7-4bde-b5b5-d7c2fb0e5b9c','2955614e-1b8d-4486-a77b-fed927b0f215', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','e550c558-b3b7-4bde-b5b5-d7c2fb0e5b9c','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('312bdf0c-c9f6-4bf0-8511-150590d492b2', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Verlauf');
INSERT INTO "attribute_type" VALUES ('afba6253-d225-4b76-81f3-5b0a49485695','312bdf0c-c9f6-4bf0-8511-150590d492b2', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','afba6253-d225-4b76-81f3-5b0a49485695','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('6b693f13-5ac3-43f4-8f66-e0c74efcac6d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Vertikallage');
INSERT INTO "attribute_type" VALUES ('a4106752-1e45-488e-bd6c-ac9e61032453','6b693f13-5ac3-43f4-8f66-e0c74efcac6d', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','a4106752-1e45-488e-bd6c-ac9e61032453','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "value_list_values" VALUES ('f7a07463-7a32-4bd9-a1ff-eb9b368573ac', '2955614e-1b8d-4486-a77b-fed927b0f215', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('e550c558-b3b7-4bde-b5b5-d7c2fb0e5b9c','f7a07463-7a32-4bd9-a1ff-eb9b368573ac');
INSERT INTO "attribute_type_group" VALUES ('afba6253-d225-4b76-81f3-5b0a49485695','f7a07463-7a32-4bd9-a1ff-eb9b368573ac');
INSERT INTO "attribute_type_group" VALUES ('a4106752-1e45-488e-bd6c-ac9e61032453','f7a07463-7a32-4bd9-a1ff-eb9b368573ac');


INSERT INTO "localized_character_string" VALUES ('1f492ab2-18b0-4fe0-88b3-8422e489a274', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Hoehe');
INSERT INTO "attribute_type" VALUES ('a58d0ef7-39eb-492a-81ac-dd655f729147','1f492ab2-18b0-4fe0-88b3-8422e489a274', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','a58d0ef7-39eb-492a-81ac-dd655f729147','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('b7abcb41-bce3-49bf-b0c7-4b997256a619', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_HoeheOK');
INSERT INTO "attribute_type" VALUES ('713c483c-223a-429d-9990-a39b34a2b241','b7abcb41-bce3-49bf-b0c7-4b997256a619', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','713c483c-223a-429d-9990-a39b34a2b241','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('e6a18898-7679-4210-a962-52eca03a2b09', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_HoeheUK');
INSERT INTO "attribute_type" VALUES ('812b908f-efaf-40df-9239-3539e1cb1079','e6a18898-7679-4210-a962-52eca03a2b09', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','812b908f-efaf-40df-9239-3539e1cb1079','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('35bfbfba-59ab-44de-8db8-0429fcc00859', 'c0d76ff3-a711-42af-920d-09132a287015', 'Profil_Orientierung');
INSERT INTO "attribute_type" VALUES ('e727e12d-2109-4a04-a01b-ce8ede8f7ccb','35bfbfba-59ab-44de-8db8-0429fcc00859', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('49f61547-49af-479e-80c0-a8ea40dfb60e','e727e12d-2109-4a04-a01b-ce8ede8f7ccb','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "value_list_values" VALUES ('aa3e56ce-f129-49c3-abac-ee5b08ef42dd', '1f492ab2-18b0-4fe0-88b3-8422e489a274', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('a58d0ef7-39eb-492a-81ac-dd655f729147','aa3e56ce-f129-49c3-abac-ee5b08ef42dd');
INSERT INTO "attribute_type_group" VALUES ('713c483c-223a-429d-9990-a39b34a2b241','aa3e56ce-f129-49c3-abac-ee5b08ef42dd');
INSERT INTO "attribute_type_group" VALUES ('812b908f-efaf-40df-9239-3539e1cb1079','aa3e56ce-f129-49c3-abac-ee5b08ef42dd');
INSERT INTO "attribute_type_group" VALUES ('e727e12d-2109-4a04-a01b-ce8ede8f7ccb','aa3e56ce-f129-49c3-abac-ee5b08ef42dd');

/* BohrkernSchicht */

INSERT INTO "localized_character_string" VALUES ('3b54b145-d4b0-4cbf-8da5-a5097a384a7d', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Nummer');
INSERT INTO "attribute_type" VALUES ('d0a22942-992f-4812-8675-646f8fcc6be8','3b54b145-d4b0-4cbf-8da5-a5097a384a7d', NULL, 'c10ddb22-babd-437d-a04a-f44f068ff62b', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','d0a22942-992f-4812-8675-646f8fcc6be8','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('96b5dc09-0e35-437c-8453-bb0a38a22bd1', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('52268974-6134-427a-a1cb-686cc38bc4d9','96b5dc09-0e35-437c-8453-bb0a38a22bd1', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','52268974-6134-427a-a1cb-686cc38bc4d9','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('3406e293-5edc-42d5-81b1-434ceb403182', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Oberkante');
INSERT INTO "attribute_type" VALUES ('b74df4c5-53f3-43cf-8fb6-34d56824ea53','3406e293-5edc-42d5-81b1-434ceb403182', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','b74df4c5-53f3-43cf-8fb6-34d56824ea53','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('fbb92e14-7393-40e2-a6b9-5b4107afe078', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Unterkante');
INSERT INTO "attribute_type" VALUES ('7ad3c805-e27e-48ad-b115-531e224c58a9','fbb92e14-7393-40e2-a6b9-5b4107afe078', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','7ad3c805-e27e-48ad-b115-531e224c58a9','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('ef7ac0b4-92ae-4e72-b9e8-06532aea274a', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Staerke');
INSERT INTO "attribute_type" VALUES ('7bf51c1f-86da-4df7-9875-6c878dd12e64','ef7ac0b4-92ae-4e72-b9e8-06532aea274a', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '81f2c264-feef-4d87-bd46-5c3e5e911b8e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','7bf51c1f-86da-4df7-9875-6c878dd12e64','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('c7ec35f3-456d-4d77-9b98-4e2f71f56248', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Allgemein');
INSERT INTO "value_list_values" VALUES ('8fcc5dcb-2fb6-4fb1-a51d-de06577dac24', 'c7ec35f3-456d-4d77-9b98-4e2f71f56248', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('d0a22942-992f-4812-8675-646f8fcc6be8','8fcc5dcb-2fb6-4fb1-a51d-de06577dac24');
INSERT INTO "attribute_type_group" VALUES ('52268974-6134-427a-a1cb-686cc38bc4d9','8fcc5dcb-2fb6-4fb1-a51d-de06577dac24');
INSERT INTO "attribute_type_group" VALUES ('b74df4c5-53f3-43cf-8fb6-34d56824ea53','8fcc5dcb-2fb6-4fb1-a51d-de06577dac24');
INSERT INTO "attribute_type_group" VALUES ('7ad3c805-e27e-48ad-b115-531e224c58a9','8fcc5dcb-2fb6-4fb1-a51d-de06577dac24');
INSERT INTO "attribute_type_group" VALUES ('7bf51c1f-86da-4df7-9875-6c878dd12e64','8fcc5dcb-2fb6-4fb1-a51d-de06577dac24');

INSERT INTO "localized_character_string" VALUES ('95fdf75e-a975-4408-af6b-4b8624c3489f', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Beschreibung');
INSERT INTO "attribute_type" VALUES ('5051430f-bef9-4940-bbda-05c8f1237c5f','95fdf75e-a975-4408-af6b-4b8624c3489f', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','5051430f-bef9-4940-bbda-05c8f1237c5f','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('5000f90b-6aeb-4d64-9c0d-b8adc289ea02', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Bodenart');
INSERT INTO "attribute_type" VALUES ('97042ed4-eff7-4841-839c-53368929e7c4','5000f90b-6aeb-4d64-9c0d-b8adc289ea02', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','97042ed4-eff7-4841-839c-53368929e7c4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('3662d0a9-33a2-4b5f-9c7d-de1a486b3e47', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Farbe');
INSERT INTO "attribute_type" VALUES ('fe1b4626-4b65-4f0c-8d11-e9b7f830672c','3662d0a9-33a2-4b5f-9c7d-de1a486b3e47', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','fe1b4626-4b65-4f0c-8d11-e9b7f830672c','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('b4de1de9-5dfc-4a02-83c0-ec015020944c', 'c0d76ff3-a711-42af-920d-09132a287015', 'BohrkernSchicht_Fundmaterial');
INSERT INTO "attribute_type" VALUES ('407ee9e7-ff9f-48d5-bb8e-e5c72dfd70d5','b4de1de9-5dfc-4a02-83c0-ec015020944c', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('47c5e9aa-3115-4e0d-98fc-271e5cb32338','407ee9e7-ff9f-48d5-bb8e-e5c72dfd70d5','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "value_list_values" VALUES ('d08299f3-231f-47a4-819f-1700dada805d', '95fdf75e-a975-4408-af6b-4b8624c3489f', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('5051430f-bef9-4940-bbda-05c8f1237c5f','d08299f3-231f-47a4-819f-1700dada805d');
INSERT INTO "attribute_type_group" VALUES ('97042ed4-eff7-4841-839c-53368929e7c4','d08299f3-231f-47a4-819f-1700dada805d');
INSERT INTO "attribute_type_group" VALUES ('fe1b4626-4b65-4f0c-8d11-e9b7f830672c','d08299f3-231f-47a4-819f-1700dada805d');
INSERT INTO "attribute_type_group" VALUES ('407ee9e7-ff9f-48d5-bb8e-e5c72dfd70d5','d08299f3-231f-47a4-819f-1700dada805d');

/* Bohrung */

INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','d0a22942-992f-4812-8675-646f8fcc6be8','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('53bba697-b068-4ecd-9f99-6436a0ee3556', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Leitung');
INSERT INTO "attribute_type" VALUES ('ddc90370-07e0-4581-81ce-688386c218e6','53bba697-b068-4ecd-9f99-6436a0ee3556', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','ddc90370-07e0-4581-81ce-688386c218e6','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('96c4a5aa-cfd7-4677-b991-74f953f6b35f', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Datum');
INSERT INTO "attribute_type" VALUES ('d1b10c3f-5b54-48e6-b6a5-b688006f0fca','96c4a5aa-cfd7-4677-b991-74f953f6b35f', NULL, '1453be24-2b0c-4b40-a648-ecccf0f382a3', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','d1b10c3f-5b54-48e6-b6a5-b688006f0fca','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('d2867ad7-621d-41de-a521-2a9ea538109e', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_OrtModern');
INSERT INTO "attribute_type" VALUES ('b32dad4d-783a-46b9-808c-36c38a142837','d2867ad7-621d-41de-a521-2a9ea538109e', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','b32dad4d-783a-46b9-808c-36c38a142837','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('6b0598a1-89ca-4fba-af92-29382b4651e2', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Kurzbeschreibung');
INSERT INTO "attribute_type" VALUES ('8a36b1f0-be9b-4047-bbf7-e6f7dfec6da9','6b0598a1-89ca-4fba-af92-29382b4651e2', NULL, '7ea709cf-d31d-4c40-bc7a-4e700ae3cb69', NULL, NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','8a36b1f0-be9b-4047-bbf7-e6f7dfec6da9','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('4d352c69-6e20-486e-adae-87da7cf07272', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Allgemein');
INSERT INTO "value_list_values" VALUES ('f9975933-6b96-4dfb-9c52-a939f7d812fe', '4d352c69-6e20-486e-adae-87da7cf07272', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('d0a22942-992f-4812-8675-646f8fcc6be8','f9975933-6b96-4dfb-9c52-a939f7d812fe');
INSERT INTO "attribute_type_group" VALUES ('f5fafb4a-4645-4b4c-8161-807064aa3ae4','f9975933-6b96-4dfb-9c52-a939f7d812fe');
INSERT INTO "attribute_type_group" VALUES ('ddc90370-07e0-4581-81ce-688386c218e6','f9975933-6b96-4dfb-9c52-a939f7d812fe');
INSERT INTO "attribute_type_group" VALUES ('d1b10c3f-5b54-48e6-b6a5-b688006f0fca','f9975933-6b96-4dfb-9c52-a939f7d812fe');
INSERT INTO "attribute_type_group" VALUES ('b32dad4d-783a-46b9-808c-36c38a142837','f9975933-6b96-4dfb-9c52-a939f7d812fe');
INSERT INTO "attribute_type_group" VALUES ('8a36b1f0-be9b-4047-bbf7-e6f7dfec6da9','f9975933-6b96-4dfb-9c52-a939f7d812fe');

INSERT INTO "localized_character_string" VALUES ('b1d75d61-c158-4a88-a369-b2094341d105', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Durchmesser');
INSERT INTO "attribute_type" VALUES ('b69ecab8-e391-4155-a186-4c3304ef155c','b1d75d61-c158-4a88-a369-b2094341d105', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '81f2c264-feef-4d87-bd46-5c3e5e911b8e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','b69ecab8-e391-4155-a186-4c3304ef155c','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('436697fd-7ea3-44e7-801d-c181c937c2a0', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Gesamttiefe');
INSERT INTO "attribute_type" VALUES ('a77dc332-3265-4bdf-90e6-1da542a5ba44','436697fd-7ea3-44e7-801d-c181c937c2a0', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '46e3afef-d254-4d63-a9de-fd2cabe2dc6e', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','a77dc332-3265-4bdf-90e6-1da542a5ba44','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

/* m ü.NN Einheit*/
INSERT INTO "localized_character_string" VALUES ('6d0fbf8e-5b08-4e3b-95b5-d0469408c9de', 'bd0fcf55-547a-44da-b7c7-915e6e4ec40e', 'm ü.NN');
INSERT INTO "value_list_values" VALUES ('95b9cdf6-6262-40ba-be0a-09ae41d46911', '6d0fbf8e-5b08-4e3b-95b5-d0469408c9de', NULL, true, 'b3056afa-160f-45f2-803f-69e276496a56');

INSERT INTO "localized_character_string" VALUES ('4712b446-761f-4f05-a2a3-70c4b9498290', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_NiveauOben');
INSERT INTO "attribute_type" VALUES ('82fb31fe-8b67-4a81-9421-82339d20c1c4','4712b446-761f-4f05-a2a3-70c4b9498290', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '95b9cdf6-6262-40ba-be0a-09ae41d46911', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','82fb31fe-8b67-4a81-9421-82339d20c1c4','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('c86163e2-efe1-4347-8758-7b50fef8a1ee', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_NiveauUnten');
INSERT INTO "attribute_type" VALUES ('e9659fc1-4c96-44ce-b7cf-f6855eee6c25','c86163e2-efe1-4347-8758-7b50fef8a1ee', NULL, 'f5a22fd3-1b19-408c-8b6a-94f5d090d89f', '95b9cdf6-6262-40ba-be0a-09ae41d46911', NULL);
INSERT INTO "attribute_type_to_topic_characteristic" VALUES ('24124df3-d1c1-4613-85c6-43086c24603f','e9659fc1-4c96-44ce-b7cf-f6855eee6c25','7e764492-4a75-48f9-a98e-484b0355c6d8', NULL);

INSERT INTO "localized_character_string" VALUES ('003dff63-65a0-494f-a52b-2e6e7df3b526', 'c0d76ff3-a711-42af-920d-09132a287015', 'Bohrung_Parameter');
INSERT INTO "value_list_values" VALUES ('af181819-ca3a-4dd3-b929-1e06d229b95d', '003dff63-65a0-494f-a52b-2e6e7df3b526', NULL, true, '3999454a-c82c-4ca7-9114-f427dec39bae');

INSERT INTO "attribute_type_group" VALUES ('b69ecab8-e391-4155-a186-4c3304ef155c','af181819-ca3a-4dd3-b929-1e06d229b95d');
INSERT INTO "attribute_type_group" VALUES ('a77dc332-3265-4bdf-90e6-1da542a5ba44','af181819-ca3a-4dd3-b929-1e06d229b95d');
INSERT INTO "attribute_type_group" VALUES ('82fb31fe-8b67-4a81-9421-82339d20c1c4','af181819-ca3a-4dd3-b929-1e06d229b95d');
INSERT INTO "attribute_type_group" VALUES ('e9659fc1-4c96-44ce-b7cf-f6855eee6c25','af181819-ca3a-4dd3-b929-1e06d229b95d');
