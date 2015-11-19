SET search_path TO "webapp";
SET client_encoding TO "UTF8";

--------------------------------------------------------------------------------
-------------------------- Insert default values -------------------------------
--------------------------------------------------------------------------------
INSERT INTO "webapp" VALUES ('911fee71-efb8-4194-b383-a1e54b02e806','test webapp','A web-application for testing purposes.','some data');
INSERT INTO "webapp_subject" VALUES ('8834e957-0202-4d2c-b281-962750f8c41b','911fee71-efb8-4194-b383-a1e54b02e806','45eb6a4e-c5e0-489c-b6e0-3c0f44fb8b34','some data');
INSERT INTO "webapp_system" VALUES ('807c6539-1a61-477c-bafb-138397352f30','911fee71-efb8-4194-b383-a1e54b02e806','some data');
INSERT INTO "webapp_project" VALUES ('7d7668b8-d8fd-40bc-b0a4-e6503d189daa','911fee71-efb8-4194-b383-a1e54b02e806','fd27a347-4e33-4ed7-aebc-eeff6dbf1054','some data');