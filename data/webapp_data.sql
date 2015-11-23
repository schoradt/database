SET search_path TO "webapp";
SET client_encoding TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- Insert default values -------------------------------
--------------------------------------------------------------------------------
INSERT INTO "webapp" VALUES ('911fee71-efb8-4194-b383-a1e54b02e806','test webapp','A web-application for testing purposes.','some data');
INSERT INTO "webapp_subject" VALUES ('8834e957-0202-4d2c-b281-962750f8c41b','911fee71-efb8-4194-b383-a1e54b02e806','45eb6a4e-c5e0-489c-b6e0-3c0f44fb8b34','some data');
INSERT INTO "webapp_system" VALUES ('807c6539-1a61-477c-bafb-138397352f30','911fee71-efb8-4194-b383-a1e54b02e806','some data');
INSERT INTO "webapp_project" VALUES ('7d7668b8-d8fd-40bc-b0a4-e6503d189daa','911fee71-efb8-4194-b383-a1e54b02e806','fd27a347-4e33-4ed7-aebc-eeff6dbf1054','some data');

INSERT INTO "webapp" VALUES ('809a2e7d-d52b-43e0-9733-04399953fa01','Webapp Test','A web-application for testing purposes.','some data');
INSERT INTO "webapp" VALUES ('74a45d99-f4c3-4d57-93c9-2e897e387a90','Webapp Implementation','A web-application for testing purposes.','some data');
INSERT INTO "webapp_system" VALUES ('0258cce9-d0e8-43db-9010-0d4bcb786f5b','809a2e7d-d52b-43e0-9733-04399953fa01','some data');
INSERT INTO "webapp_system" VALUES ('b8e394c0-3644-487b-b555-c57273fa80ae','74a45d99-f4c3-4d57-93c9-2e897e387a90','some data');