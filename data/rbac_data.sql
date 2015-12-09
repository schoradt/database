SET search_path TO "rbac";
SET client_encoding TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- Insert default values -------------------------------
--------------------------------------------------------------------------------
INSERT INTO "subject" VALUES ('7135e8dd-3d68-4d40-9a6b-80a458a9f385','max','bOwjv/SrMGt3HRxiLnD/7BKzcIxvatzlxymRmojQxUk=',current_date,'eff3a947-6dfc-4bc5-a940-036c7bbc518d','mail@max.btu.de','Max Mustermann','he is a default user',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('929632fc-a4c6-400a-9ef3-549276f91b40','lieschen','jy8/FzB8ptNdwfhkdwn0l0W0/fvTVoTN6g1bpeEg1V8=',current_date,'07a506f3-0a2c-4b6d-a807-fdd8552315b2','mail@lieschen.btu.de','Lieschen Mueller','she is a default user',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('6142ba53-3b24-4c0a-bc8b-18968e058d9a','anonymous','Xo4fBVStqh/kX68b2WoOZJtLthNkTJqyAi3wYaWBxhw=',current_date,'966a91eb-328f-4df0-9e66-4dafed830088',null,'anonymous','anonymous users',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('a85c2c25-6d02-42ef-a90e-560997da01fe','siehstnix','jbqDG4aYxr8Ci0RDXdIUxy6VffcxUlCHojIx1Nopmgs=',current_date,'db848094-0ead-4214-a850-d3c8cb23971c',null,'benutzer ohne rechte','nutzer ohne rechte',1,'de-DE',current_date,null,null,null);

-- Roles as users --
INSERT INTO "subject" VALUES ('10886546-8af3-4bb1-b74e-c4d14cd47451','root','O4mJruH4OoFoUL1sFbQ0dyX9tmYLhpT2ZH69zkNPp80=',current_date,'ffdb477f-a0be-44e5-a377-c2d342eb0242','mail@root.btu.de','Bill Gates','rich person',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('4e5f2209-4397-4eb4-93c7-2002f3a38cdd','sysadmin','A5pqE0++9Jf7JXuQp9YORFQgIQf+nhX7A255a+L8h50=',current_date,'e9159662-5767-4efc-adcc-0f9ad9fa0bcb','mail@sysadmin.btu.de','sysadmin','system administrator',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('4f04b79b-4ef3-49b6-a99f-bb187c4d7ca0','syseditor','fPYc138vFj9QO1egmGI+s4orplUkQXv0jDjGEB6dMJo=',current_date,'81c23f40-8a3c-46ca-b561-7fc259113d77','mail@syseditor.btu.de','syseditor','system editor',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('e9f00ee1-7687-4534-b938-f4c3e5367479','sysguest','HDaEVa+zr/l4j/Rcs/kk+/69ACN6nsAZ+A9aMxZ5xdc=',current_date,'581d9c8f-3a59-4d49-9aad-f06ad0aa6d16','mail@sysguest.btu.de','sysguest','system guest',1,'de-DE',current_date,null,null,null);

INSERT INTO "subject" VALUES ('45eb6a4e-c5e0-489c-b6e0-3c0f44fb8b34','projectadmin_baal','gjtN0CuyOEiBUmETrvT/aWx36RcP3/M8O2h+K5iTWvM=',current_date,'ca0202b3-3675-46d2-8e59-4d4bd666489a','mail@projectadmin.btu.de','baalbek admin','baalbek admin',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('0a60ad9f-b9a8-4c38-b0dd-820dc0eba951','projectguest_baal','vI3f+etxzFvC1bd1qiHNnOTtqQ+r+K4PMDAabgMxQJM=',current_date,'2d38ac64-1242-490b-8569-18477bf18a9c','mail@projectadmin.btu.de','baalbek guest','baalbek guest',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('c7e4fb74-3232-446d-9129-ccd20222b9ed','projecteditor_baal','mAFrm/YvdkCHPja/ijoUfMvmO/X12VMFh5Jh61JBk1g=',current_date,'64573585-8546-429c-98dc-e1b379744d42','mail@projecteditor.btu.de','baalbek editor','baalbek editor',1,'de-DE',current_date,null,null,null);

INSERT INTO "role" VALUES ('c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce','root','super cow powers');
INSERT INTO "role" VALUES ('aef02838-4b92-44e4-bf6a-dc8655b6844b','sysadmin','Der Systemadministrator soll das Nutzermanagement und die Projektverwaltung durchführen können. Das schließt die Zuordnung von Nutzern zu Projekten und die allgemeine Konfiguration von OpenInfRA mit ein.');
INSERT INTO "role" VALUES ('fe45a9e1-1fe6-4b9b-9c92-6f71559c5771','syseditor','Der Systembearbeiter soll Inhalte der Systemdatenbank lesen und bearbeiten können.');
INSERT INTO "role" VALUES ('9b3e5f1b-c720-4242-a9d5-c243b68fc301','sysguest','Der Systemgast soll ausschließlich lesenden Zugriff auf die Inhalte der Systemdatenbank haben.');
INSERT INTO "role" VALUES ('e9c3921f-ccaa-4ad7-abfc-e8881f2440c5','fileuploader','Eine Rolle zum Hochladen von Bildern.');

INSERT INTO "permission" VALUES ('97e4d76e-9e40-43a1-b1f5-e9e1e7ca147e','permission for root','*:*:*');
INSERT INTO "permission" VALUES ('8e618e6b-7f07-471e-95b4-9af66c6acfe8','permission for reading system database','/system:r');
INSERT INTO "permission" VALUES ('1fbfd6eb-4b48-4819-829d-59909caf4b7c','permission for reading and writing system database','/system:r,w');
INSERT INTO "permission" VALUES ('5fdf7895-3717-476d-8373-fc56a60350aa','permission for reading and writing rbac database','/rbac:r,w');
INSERT INTO "permission" VALUES ('c906813d-2268-4f94-9dfb-a467e4340cd5','permission for creating new project schemas','/projects:r,w');
INSERT INTO "permission" VALUES ('86353fab-0b70-43f8-84bc-1c5d81a94f9e','permission for uploading files','/files:r,w');
INSERT INTO "permission" VALUES ('4b220b38-86da-490d-b52f-5c4b234a57b8','permission for a specific topic characteristic','/system/topiccharacteristics/{id}:r,w:404bc61c-5629-463e-9612-7320c3750f1f');

-- root
INSERT INTO "role_permissions" VALUES ('2a5d3193-1bef-4bec-9fee-9142806af191','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce','97e4d76e-9e40-43a1-b1f5-e9e1e7ca147e');
-- systemguest
INSERT INTO "role_permissions" VALUES ('a66e9e00-e0a2-44f2-8de8-0256b256e30a','9b3e5f1b-c720-4242-a9d5-c243b68fc301','8e618e6b-7f07-471e-95b4-9af66c6acfe8');
-- syseditor
INSERT INTO "role_permissions" VALUES ('d562c5b6-8e59-418a-9a4c-7f2cfedc1a86','fe45a9e1-1fe6-4b9b-9c92-6f71559c5771','1fbfd6eb-4b48-4819-829d-59909caf4b7c');
INSERT INTO "role_permissions" VALUES ('cda986d4-81ae-442f-9411-addf89e9489f','fe45a9e1-1fe6-4b9b-9c92-6f71559c5771','4b220b38-86da-490d-b52f-5c4b234a57b8');
-- sysadmin
INSERT INTO "role_permissions" VALUES ('ad048dda-a52a-4d4c-81eb-205b1f4723cb','aef02838-4b92-44e4-bf6a-dc8655b6844b','5fdf7895-3717-476d-8373-fc56a60350aa');
INSERT INTO "role_permissions" VALUES ('6c096e21-359d-4ed9-942f-82dbb8427ea5','aef02838-4b92-44e4-bf6a-dc8655b6844b','c906813d-2268-4f94-9dfb-a467e4340cd5');
-- fileuploader
INSERT INTO "role_permissions" VALUES ('ca43e142-44b4-4843-8dea-340ae71ef5a9','e9c3921f-ccaa-4ad7-abfc-e8881f2440c5','86353fab-0b70-43f8-84bc-1c5d81a94f9e');

-- root
INSERT INTO "subject_roles" VALUES ('dbf31f00-d571-447e-bd9a-b6d57177d3c6','10886546-8af3-4bb1-b74e-c4d14cd47451','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
-- sysadmin
INSERT INTO "subject_roles" VALUES ('af7e691e-afcf-48f0-91b8-782f9687f078','4e5f2209-4397-4eb4-93c7-2002f3a38cdd','aef02838-4b92-44e4-bf6a-dc8655b6844b');
-- sysguest
INSERT INTO "subject_roles" VALUES ('10f7d87b-23cb-46e9-b1ae-a754b5557a4a','e9f00ee1-7687-4534-b938-f4c3e5367479','9b3e5f1b-c720-4242-a9d5-c243b68fc301');
-- syseditor
INSERT INTO "subject_roles" VALUES ('7110e1e4-21cb-4442-8780-3eeebe547295','4f04b79b-4ef3-49b6-a99f-bb187c4d7ca0','fe45a9e1-1fe6-4b9b-9c92-6f71559c5771');
-- fileuploader projecteditor_baal
INSERT INTO "subject_roles" VALUES ('d7abfb91-9e38-40a9-88df-e03780007b84','c7e4fb74-3232-446d-9129-ccd20222b9ed','e9c3921f-ccaa-4ad7-abfc-e8881f2440c5');

INSERT INTO "subject" VALUES ('d3b429e6-f71e-4412-ad52-2d27d3a33c6d','tino','GjdIsQh1TZW1e0L+0s2AOyxY2jWuJd8zXatEV0rqLnQ=',current_date,'f05d2d8a-7dec-44dc-83b2-eb9e00b8fc03','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('e66e47b7-470e-46c1-84e4-56472ebdeb66','frankh','2oBKRJhWHAsPFI+/IwUmXQoRb7L1TE68G4tQO7NHcIw=',current_date,'9fa5e53e-95ff-4419-a618-6dc2c30ea82f','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('3cc1d241-e939-4538-8309-9649149e8236','franks','PXZApu1uKeoDrBkOd7ep2lRqZe+xG25H+2XwRnZAlNI=',current_date,'afdffe4e-b391-4ca1-a9bd-018c530754d9','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('7f08131c-a6d9-4db1-8841-8a80a5066b6a','cornell','BbEuJjKEKCMfF3k/TOmealK3Tnu0Xz6rzfYaz1fi5Qw=',current_date,'208bd57f-01ee-49b0-bdcb-23fb4ad685ff','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('44ca4b96-a599-4b6c-b291-d5bfd1994e3c','alex','TTgoFlU9IH90e8ybw02KfPtySzPObeDzxO+bm882Qs4=',current_date,'f3eaa8f9-5fc2-486b-9eab-e9a90d5281a6','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('d8256603-f73e-449b-a1a0-5499b00b42f8','philipp','YxCGd2r7KG1xg/2Z1jbjkMdKdZ+V2UAjfozT4wNJZjc=',current_date,'3ffca723-6323-4181-84dd-d9f7e4fea5f2','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('650b0144-b667-40a2-9fb9-0b545f218734','hanna','maLJKoTqv84aXU541IDtx0wWsZwZo6CkzEemM+7lpUM=',current_date,'dab1a46c-436f-4b80-a8ed-8672742a6aed','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('5fbe0643-1c79-47ed-a8a9-777306eb7a7a','katja','kAnf6BDkh/f29eKTtvz5bkODvULH6Wu6mMDztNtJqBE=',current_date,'1f53110a-5ccb-4713-8bac-8e49379bc688','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
INSERT INTO "subject" VALUES ('8313a98d-b7b2-4de7-9cd9-00e82f4fbf03','dörthe','GbPKBT6K61iDsilpIXbAOz+DTyFui4DoWYdRI5NGhgk=',current_date,'58245dfc-29fc-4382-b826-b974d07ae255','mail@projecteditor.btu.de','root','root',1,'de-DE',current_date,null,null,null);
-- root
INSERT INTO "subject_roles" VALUES ('18184349-9976-41e2-a20e-45c46fd358b4','d3b429e6-f71e-4412-ad52-2d27d3a33c6d','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('e807ca15-bf98-4958-9351-0b7d0cd02858','e66e47b7-470e-46c1-84e4-56472ebdeb66','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('04dd14aa-4a15-400d-85f7-1c662e17c186','3cc1d241-e939-4538-8309-9649149e8236','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('c9e4b5d6-7253-4641-8440-081175d24be9','7f08131c-a6d9-4db1-8841-8a80a5066b6a','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('b9602c30-44de-475a-b405-dfcc241ae340','44ca4b96-a599-4b6c-b291-d5bfd1994e3c','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('cadb27d0-0307-4ea5-be2c-78186c456dc4','d8256603-f73e-449b-a1a0-5499b00b42f8','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('67b63c57-d212-47e9-b8ec-7986d66a9312','650b0144-b667-40a2-9fb9-0b545f218734','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('ab24a825-98bf-41d8-b898-5c7c52f8cc79','5fbe0643-1c79-47ed-a8a9-777306eb7a7a','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('5f3e92b9-2378-48d1-b588-b0d98d94a478','8313a98d-b7b2-4de7-9cd9-00e82f4fbf03','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');


INSERT INTO "project_related_roles" VALUES ('0624533e-a8b0-4786-b590-885e414c88fe','projectadmin','Projektadministrator');
INSERT INTO "project_related_roles" VALUES ('444749dc-d645-4ce8-9e01-c21d685ab690','projecteditor','Projektbearbeiter');
INSERT INTO "project_related_roles" VALUES ('824fdc95-47d1-49fb-9a2f-3d61b6128beb','projectguest','Projektgast');

-- projectadmin_baal to projectadmin to baalbek
INSERT INTO "subject_projects" VALUES ('d550bcbc-750b-4794-a950-17f81a53ca0a','45eb6a4e-c5e0-489c-b6e0-3c0f44fb8b34','0624533e-a8b0-4786-b590-885e414c88fe','fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
-- projectguest_baal to projectguest to baalbek
INSERT INTO "subject_projects" VALUES ('fc1204c5-4fe3-4fd2-ad6b-58046b791bc4','0a60ad9f-b9a8-4c38-b0dd-820dc0eba951','824fdc95-47d1-49fb-9a2f-3d61b6128beb','fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
-- projecteditor_baal to projecteditor to baalbek
INSERT INTO "subject_projects" VALUES ('1837a0f4-1db0-488b-b836-64930bcb576a','c7e4fb74-3232-446d-9129-ccd20222b9ed','444749dc-d645-4ce8-9e01-c21d685ab690','fd27a347-4e33-4ed7-aebc-eeff6dbf1054');

-- max to projectguest to testproject and palatin
INSERT INTO "subject_projects" VALUES ('c9618a12-cdb4-4b25-8d45-73efbdb17117','7135e8dd-3d68-4d40-9a6b-80a458a9f385','824fdc95-47d1-49fb-9a2f-3d61b6128beb','7d431941-eece-48ac-bce5-3062d8d32e76');
INSERT INTO "subject_projects" VALUES ('62189c29-8878-4929-9571-dc38a0be9673','7135e8dd-3d68-4d40-9a6b-80a458a9f385','824fdc95-47d1-49fb-9a2f-3d61b6128beb','e7d42bff-4e40-4f43-9d1b-1dc5a190cd75');

-- lieschen to projecteditor to baalbek
INSERT INTO "subject_projects" VALUES ('5b482094-3104-4da3-ba5c-e41d1c49587d','929632fc-a4c6-400a-9ef3-549276f91b40','444749dc-d645-4ce8-9e01-c21d685ab690','fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
-- anonymous to projectguest to baalbek
INSERT INTO "subject_projects" VALUES ('1d6694c9-0949-412e-960a-9e5f3a00c7ee','6142ba53-3b24-4c0a-bc8b-18968e058d9a','824fdc95-47d1-49fb-9a2f-3d61b6128beb','fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
INSERT INTO "subject_projects" VALUES ('346ff14a-f97e-44d4-ac3f-a6f898dbdbb6','6142ba53-3b24-4c0a-bc8b-18968e058d9a','824fdc95-47d1-49fb-9a2f-3d61b6128beb','7d431941-eece-48ac-bce5-3062d8d32e76');

-- openinfra objects (only topiccharacteristics)
INSERT INTO "openinfra_objects" VALUES ('5d584128-7ff0-4c3d-bc07-887c8ecbe4f2','topiccharacteristics','Themenausprägungen');

-- lieschen to topiccharacteristics to foto to baalbek
INSERT INTO "subject_objects" VALUES ('47219980-a09c-49e9-8bd2-2e8bb5732c10','929632fc-a4c6-400a-9ef3-549276f91b40','5d584128-7ff0-4c3d-bc07-887c8ecbe4f2','b52b31de-8408-4ef8-8b9e-46684b315b91',true,'fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
INSERT INTO "subject_objects" VALUES ('b28b3c15-e1da-4d12-8ecc-a489fb451291','929632fc-a4c6-400a-9ef3-549276f91b40','5d584128-7ff0-4c3d-bc07-887c8ecbe4f2','50d4cb6f-46f1-4422-954c-4c3ec371f063',true,'fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
INSERT INTO "subject_objects" VALUES ('38f422b3-80bb-4ae9-adff-5355ffef3ec6','929632fc-a4c6-400a-9ef3-549276f91b40','5d584128-7ff0-4c3d-bc07-887c8ecbe4f2','8c599255-2cd9-4715-9607-dc29afb57a02',true,'fd27a347-4e33-4ed7-aebc-eeff6dbf1054');

-- anonymous to topiccharacteristics to foto to baalbek
INSERT INTO "subject_objects" VALUES ('ac5e5fc5-1d1c-4ae5-8260-e7e213507522','6142ba53-3b24-4c0a-bc8b-18968e058d9a','5d584128-7ff0-4c3d-bc07-887c8ecbe4f2','b52b31de-8408-4ef8-8b9e-46684b315b91',true,'fd27a347-4e33-4ed7-aebc-eeff6dbf1054');
INSERT INTO "subject_objects" VALUES ('5c5aeffb-bd65-4168-b056-b869434423be','6142ba53-3b24-4c0a-bc8b-18968e058d9a','5d584128-7ff0-4c3d-bc07-887c8ecbe4f2','8dcd5717-c927-4fa2-8c8c-9f6a1b56aa94',true,'7d431941-eece-48ac-bce5-3062d8d32e76');


INSERT INTO "password_blacklist" VALUES ('88605292-b3d3-4a5e-94e7-6d5059da3d4f','openinfra');
