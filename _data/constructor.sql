/** config.proekt */
INSERT INTO config.proekt ("name", description, icons, active, date_create) VALUES('constructor', 'Конструктор проект с помощью которого будут разрабатываться другие проекты и разрабатывать конфиги для отрисовки', NULL, true, '2022-09-23 19:41:01.438');
INSERT INTO config.screen ("name", description, title, url, icons, active, id_right) VALUES('Проекты компании', 'Проекты компании', 'Проекты компании', 'constructor/proekt', '', true, 14);
INSERT INTO config.proekt_screen (id_proekt, id_screen) VALUES(1, 1);



INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Таблица проектов', 'Таблица проектов', NULL, '{"id_col":"id"}', '{"id":{"gn":1,"nc":"id","w":40,"visible":false,"displayed":false,"sort":true,"title":true,"filter":true,"type":"number"},"name":{"gn":2,"nc":"name","w":40,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"string"},"description":{"gn":3,"nc":"description","w":40,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"string"},"icons":{"gn":4,"nc":"icons","w":40,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"string"},"active":{"gn":5,"nc":"active","w":40,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"boolean"},"date_create":{"gn":6,"nc":"date_create","w":40,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"date-time"},"delete":{"gn":7,"nc":"delete","type":"button","id":2,"w":40},"update":{"gn":8,"nc":"update","type":"button","id":3,"w":40},"get_screen":{"gn":9,"nc":"get_screen","type":"button","id":4,"w":40}}', NULL, 14, 1, NULL);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Удалить', 'Кнопка удалить проект', NULL, NULL, NULL, NULL, 14, 2, 1);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Изменить', 'Кнопка изменить проект', NULL, NULL, NULL, NULL, 14, 2, 1);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Перейди на скрин', 'Кнопка  перехода на скрин "скрины проекта"', NULL, NULL, NULL, NULL, 14, 2, 1);

/** config.proekt */