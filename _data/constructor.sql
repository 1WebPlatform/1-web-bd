/** config.proekt */
INSERT INTO config.proekt ("name", description, icons, active, date_create) VALUES('constructor', 'Конструктор проект с помощью которого будут разрабатываться другие проекты и разрабатывать конфиги для отрисовки', NULL, true, '2022-09-23 19:41:01.438');
INSERT INTO config.screen ("name", description, title, url, icons, active, id_right) VALUES('Проекты компании', 'Проекты компании', 'Проекты компании', 'constructor/proekt', '', true, 14);
INSERT INTO config.proekt_screen (id_proekt, id_screen) VALUES(1, 1);
/** config.proekt */