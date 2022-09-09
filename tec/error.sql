CREATE TABLE tec."error" (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	"description" text NOT NULL,
	"status" varchar NOT NULL,
	CONSTRAINT error_pk PRIMARY KEY (id)
);

/** Column comments*/
COMMENT ON COLUMN tec.error.id IS 'первичный ключ';
COMMENT ON COLUMN tec.error."name" IS 'Заголовок ошибки';
COMMENT ON COLUMN tec.error.description IS 'Подробное описание ошибки';
COMMENT ON COLUMN tec.error.status IS 'Код статуса ошибки';
/** Column comments*/

/** Fucntion */
/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.error_get_id(_id int)
	RETURNS SETOF "tec"."error"
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.error where id = _id;
	END;
$function$;
CREATE OR REPLACE FUNCTION tec.error_get_ids(_ids int [])
	RETURNS SETOF "tec"."error"
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.error where id = any(_ids);
	END;
$function$;
/** Fucntion */
/** Fucntion GET  */


/** DATA bd */
INSERT INTO "tec"."error" ("name", "description", "status") VALUES
    ('Ошибка уникальности', 'Указанное имя события уже занято', '400'),
	('Запись не найдена', 'Указанный id события не существует', '404'), 
	('Ошибка уникальности', 'Указанное имя типа параметра уже занято', '400'),  
	('Запись не найдена', 'Указанный id типа параметра не существует', '404'),
	('Ошибка уникальности', 'Указанное имя типа компонента уже занято', '400'),
	('Запись не найдена', 'Указанный id типа компонента не существует', '404'),
	('Ошибка уникальности', 'Указанный email пользователя уже занят', '400'),
	('Запись не найдена', 'Указанный id пользователя не существует', '404'),
	('Ошибка уникальности', 'Указанное имя право уже занято', '400'),
	('Запись не найдена', 'Указанный id право не существует', '404'),
	('Ошибка уникальности', 'Указанное имя роли уже занят', '400'),
	('Запись не найдена', 'Указанный id роли не существует', '404'),
	('Запись не найдена', 'Указанный id роли и право не существует', '404'),
	('Запись не найдена', 'Указанная связь id роли и право не существует', '404')
	

/** DATA bd */


/** Start Fucntion */
select * from tec.error_get_id(_id := 1)
/** Start Fucntion */