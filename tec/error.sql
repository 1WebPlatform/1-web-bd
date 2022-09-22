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


CREATE OR REPLACE FUNCTION tec.error_get_id(_id integer, out error_ json)
 LANGUAGE plpgsql
AS $function$
	BEGIN  
	select 
		json_build_object(
			'id', e.id ,
			'name', e."name",
			'description', e.description, 
			'status', e.status 
		) into error_  from tec.error e where id = _id;
	END;
$function$
;

/** Fucntion */
/** Fucntion GET  */

/** Start Fucntion */
select * from tec.error_get_id(_id := 1)
/** Start Fucntion */