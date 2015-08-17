SET search_path TO "rbac";
SET client_encoding TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- Insert default values -------------------------------
--------------------------------------------------------------------------------
INSERT INTO "subject" VALUES ('10886546-8af3-4bb1-b74e-c4d14cd47451','root','root',current_date,'ffdb477f-a0be-44e5-a377-c2d342eb0242','mail@root.btu.de','Bill Gates','rich person',1,'de-DE',current_date,null,null);
INSERT INTO "subject" VALUES ('7135e8dd-3d68-4d40-9a6b-80a458a9f385','max','max',current_date,'eff3a947-6dfc-4bc5-a940-036c7bbc518d','mail@max.btu.de','Max Mustermann','he is a default user',1,'de-DE',current_date,null,null);
INSERT INTO "subject" VALUES ('929632fc-a4c6-400a-9ef3-549276f91b40','lieschen','lieschen',current_date,'07a506f3-0a2c-4b6d-a807-fdd8552315b2','mail@lieschen.btu.de','Lieschen Mueller','she is a default user',1,'de-DE',current_date,null,null);
INSERT INTO "subject" VALUES ('6142ba53-3b24-4c0a-bc8b-18968e058d9a','anonymous','anonymous',current_date,'07a506f3-0a2c-4b6d-a807-fdd8552315b2',null,'anonymous','anonymous users',1,'de-DE',current_date,null,null);

INSERT INTO "role" VALUES ('c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce','root','super cow powers');
INSERT INTO "role" VALUES ('aef02838-4b92-44e4-bf6a-dc8655b6844b','default_user','simple configuration for default users');
INSERT INTO "role" VALUES ('9b3e5f1b-c720-4242-a9d5-c243b68fc301','anonymous','users with very restictive permissions');

INSERT INTO "permission" VALUES ('97e4d76e-9e40-43a1-b1f5-e9e1e7ca147e','permission for root','*:*:*');
INSERT INTO "permission" VALUES ('e47f3cf5-b565-4035-ab37-480ff349b2f5','permission for list projects','/projects:get');
INSERT INTO "permission" VALUES ('8e618e6b-7f07-471e-95b4-9af66c6acfe8','permission for accessing all projects','/projects/{id}:get:*');
INSERT INTO "permission" VALUES ('1fbfd6eb-4b48-4819-829d-59909caf4b7c','permission for accessing only the test project','/projects/{id}:get:e7d42bff-4e40-4f43-9d1b-1dc5a190cd75');

INSERT INTO "role_permissions" VALUES ('2a5d3193-1bef-4bec-9fee-9142806af191','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce','97e4d76e-9e40-43a1-b1f5-e9e1e7ca147e');
INSERT INTO "role_permissions" VALUES ('b0a5fb65-6644-4976-b440-f5390a5f0e15','aef02838-4b92-44e4-bf6a-dc8655b6844b','e47f3cf5-b565-4035-ab37-480ff349b2f5');
INSERT INTO "role_permissions" VALUES ('a66e9e00-e0a2-44f2-8de8-0256b256e30a','aef02838-4b92-44e4-bf6a-dc8655b6844b','8e618e6b-7f07-471e-95b4-9af66c6acfe8');
INSERT INTO "role_permissions" VALUES ('d562c5b6-8e59-418a-9a4c-7f2cfedc1a86','9b3e5f1b-c720-4242-a9d5-c243b68fc301','1fbfd6eb-4b48-4819-829d-59909caf4b7c');

INSERT INTO "subject_roles" VALUES ('dbf31f00-d571-447e-bd9a-b6d57177d3c6','10886546-8af3-4bb1-b74e-c4d14cd47451','c0057bdd-b3ba-4e80-afb6-3cf5cb51ebce');
INSERT INTO "subject_roles" VALUES ('af7e691e-afcf-48f0-91b8-782f9687f078','7135e8dd-3d68-4d40-9a6b-80a458a9f385','aef02838-4b92-44e4-bf6a-dc8655b6844b');
INSERT INTO "subject_roles" VALUES ('c9563976-54cf-41e7-a19c-8d9e8b443bea','929632fc-a4c6-400a-9ef3-549276f91b40','aef02838-4b92-44e4-bf6a-dc8655b6844b');
INSERT INTO "subject_roles" VALUES ('10f7d87b-23cb-46e9-b1ae-a754b5557a4a','6142ba53-3b24-4c0a-bc8b-18968e058d9a','9b3e5f1b-c720-4242-a9d5-c243b68fc301');

INSERT INTO "password_blacklist" VALUES ('88605292-b3d3-4a5e-94e7-6d5059da3d4f','openinfra');
