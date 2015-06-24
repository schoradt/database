SET search_path TO "public", "constraints";
SET CLIENT_ENCODING TO "UTF8";

SELECT create_view ('"project_fd27a347-4e33-4ed7-aebc-eeff6dbf1054"', '5f4ff0f0-c325-4925-b565-0516e0cd1eda',
              ARRAY[['aa7f1e16-85c8-4a82-8a8a-b752473fa320', 'c0d76ff3-a711-42af-920d-09132a287015', 'desc'],
                    ['8e4fadd7-350d-4d4e-a78e-ddb10dd06df5', 'bd0fcf55-547a-44da-b7c7-915e6e4ec40e', 'coding']/*,
                    ['6a5fd527-1f45-456c-ae6a-f70127cac793', 'bd0fcf55-547a-44da-b7c7-915e6e4ec40e', 'code']*/],
                    'multipolygon', 4326);

