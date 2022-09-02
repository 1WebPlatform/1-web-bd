CREATE TABLE tec.type_params (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	"description" text NOT NULL,
	"active" boolean NOT NULL
);

/** Column comments*/
COMMENT ON COLUMN tec.type_params.id IS 'первичный ключ';
COMMENT ON COLUMN tec.type_params."name" IS 'Имя типа параметра';
COMMENT ON COLUMN tec.type_params.description IS 'Описание типа параметра';
COMMENT ON COLUMN tec.type_params.active IS 'Активность типа параметра';
/** Column comments*/


/** Fucntion */
/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.type_params_get()
	RETURNS SETOF "tec".type_params
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.type_params;
	END;
$function$;

CREATE OR REPLACE FUNCTION tec.type_params_get_id(_id int)
	RETURNS SETOF "tec".type_params
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.type_params where _id = id;
	END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.type_params_check_name(_name varchar)
	RETURNS boolean
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return EXISTS (select * from tec.type_params where "name" = _name);
	END;
$function$;
/** Fucntion CHECK  */


/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.type_params_save(
	_name varchar, 
	_description text,
	_active boolean,
	OUT id_ int,
	OUT error tec.error
	)
	LANGUAGE plpgsql
AS $function$
	BEGIN
		IF (select * from tec.type_params_check_name(_name)) <> true then
			INSERT INTO tec.type_params 
			("name", description, active) 
			VALUES (_name, _description,_active) 
			RETURNING id INTO id_;
		ELSE 
			select * into error from tec.error_get_id(3);	
		END IF;	
	END;
$function$;
/** Fucntion SAVE  */

/** Fucntion */
