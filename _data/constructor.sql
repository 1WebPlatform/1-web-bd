/** config.proekt */
/** ДУБАЛЬ с proekt.sql */
INSERT INTO config.proekt ("name", description, icons, active, date_create) VALUES('Конструктор', 'Конструктор проект с помощью которого будут разрабатываться другие проекты и разрабатывать конфиги для отрисовки', NULL, true, '2022-09-23 19:41:01.438');

INSERT INTO config.screen ("name", description, title, url, icons, active, id_right) VALUES('Проекты компании', 'Проекты компании', 'Проекты компании', 'constructor/proekt', '', true, 14);
INSERT INTO config.proekt_screen (id_proekt, id_screen) VALUES(1, 1);


INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Таблица проектов', 'Таблица проектов', '', '{"id_col":"id"}', '{"id":{"gn":1,"nc":"id","name":"id","w":40,"visible":false,"displayed":false,"sort":true,"title":true,"filter":true,"type":"number"},"name":{"gn":2,"nc":"name","name":"Имя проекта","w":100,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"string"},"description":{"gn":3,"nc":"description","name":"Описания проекта","w":140,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"string"},"icons":{"gn":4,"nc":"icons","name":"Url иконки проекта","w":140,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"string"},"active":{"gn":5,"nc":"active","name":"активность проекта","w":140,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"boolean"},"date_create":{"gn":6,"nc":"date_create","name":"Дата создания проекта","w":180,"visible":true,"displayed":true,"sort":true,"title":true,"filter":true,"type":"date-time"},"delete":{"gn":7,"nc":"delete","name":"Удалить проект","type":"button","id":2,"w":120,"visible":true},"update":{"gn":8,"nc":"update","type":"button","name":"Изменить проект","id":3,"w":120,"visible":true},"get_screen":{"gn":9,"nc":"get_screen","name":"Открыть скрины проекта","type":"button","id":4,"w":180,"visible":true}}', '{"create":[{"fun":"loader_table_data","params":{"name":{"value":"proekt_get"},"schema":{"value":"config"}}}]}', NULL, 1, 5);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Удалить', 'Кнопка удалить проект', NULL, '{"title": "Удалить проект", "icons":"delete.svg"}', NULL, '{"click":[{"fun":"api_procedures","params":{"name":{"value":"proekt_delete"},"schema":{"value":"config"},"body":[{"_id":{"type":"context","nc":"id","id":2}}]}}]}', NULL, 2, 1);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Изменить', 'Кнопка изменить проект', NULL, '{"title": "Редактировать проект", "icons":"editor.svg"}', NULL, NULL, NULL, 2, 1);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Перейди на скрин', 'Кнопка  перехода на скрин "скрины проекта"', NULL, '{"title": "Открыть скрин ''Скрины проекта'' ", "icons":"door-leave.svg"}', NULL, NULL, NULL, 2, 1);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Контейнер', 'Контейнер главный экран "Проекты"', NULL, NULL, NULL, NULL, NULL, 4, NULL);
INSERT INTO config.component ("name", description, css, params, "schema", "event", id_right, id_type, id_parent) VALUES('Сообщение', 'Сообщение вопрос при нажатия кнопку удаления', NULL, '{"name": "Удаление проекта", "text": "Вы уверены что хотите удалить проект?" ', NULL, NULL, NULL, 6, NULL);




INSERT INTO config.screen_component (id_screen, id_component) VALUES(1, 1);
INSERT INTO config.screen_component (id_screen, id_component) VALUES(1, 2);
INSERT INTO config.screen_component (id_screen, id_component) VALUES(1, 3);
INSERT INTO config.screen_component (id_screen, id_component) VALUES(1, 4);
INSERT INTO config.screen_component (id_screen, id_component) VALUES(1, 5);
INSERT INTO config.screen_component (id_screen, id_component) VALUES(1, 6);
    

/** config.proekt */