INSERT INTO config.callback ("name", description, params, id_type) VALUES('loader_table_data', 'Загружает данные в компонент таблицу.', '{"body":{"type": "json"}, "name":{"type":"string"}, "schema": {"type":"string"}}'::json, 1);
INSERT INTO config.callback ("name", description, params, id_type) VALUES('api_procedures', 'Вызов api procedures', '{"body":{"type": "json"}, "name":{"type":"string"}, "schema": {"type":"string"}}'::json, NULL);
INSERT INTO config.callback ("name", description, params, id_type) VALUES('open_message', 'Открыть компонент message', '{"id": "number"}'::json, 6);
