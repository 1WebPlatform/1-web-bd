CREATE TABLE tec."event" (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	description text NULL,
	active boolean
);

CREATE UNIQUE INDEX event_name_idx ON tec.event USING btree (name);

 
/** Column comments*/
COMMENT ON COLUMN tec.event.id IS 'первичный ключ';
COMMENT ON COLUMN tec.event."name" IS 'Имя события';
COMMENT ON COLUMN tec.event.description IS 'Описание события';
COMMENT ON COLUMN tec.event.active IS 'Активность события';
/** Column comments*/

/** Fucntion */
/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.event_get()
	RETURNS SETOF "tec"."event"
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.event;
	END;
$function$;


CREATE OR REPLACE FUNCTION tec.event_get_id(_id int)
	RETURNS SETOF "tec"."event"
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.event where id = _id;
	END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.event_check_id(_id int)
	RETURNS boolean
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return EXISTS (select * from tec.event where "id" = _id);
	END;
$function$;

CREATE OR REPLACE FUNCTION tec.event_check_name(_name varchar)
	RETURNS boolean
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return EXISTS (select * from tec.event where "name" = _name);
	END;
$function$;
/** Fucntion CHECK  */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.event_save(
	_name varchar,
	_description text DEFAULT NULL::character varying,
	_active boolean DEFAULT true,
	OUT id_ int,
	OUT error tec.error
)
	LANGUAGE plpgsql
AS $function$
	BEGIN
		IF (select * from tec.event_check_name(_name)) <> true then
			INSERT INTO tec.event 
				("name", description, active) 
				VALUES (_name, _description,_active) 
				RETURNING id INTO id_;
		ELSE 
			select * into error from tec.error_get_id(1);		
		END IF;		
	END;
$function$;
/** Fucntion SAVE  */


/** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION tec.event_update_id(
		_id int, 
		_name varchar,
		_description text DEFAULT NULL::character varying,
		_active boolean DEFAULT true,
		OUT error tec.error, 
		OUT id_ int
	)
	LANGUAGE plpgsql
AS $function$
	BEGIN
		IF (select * from tec.event_check_id(_id)) then
			UPDATE tec.event 
			SET 
				name = _name, 
				description = _description, 
				active = _active
			where id = _id RETURNING id INTO id_;
		ELSE 
			select * into error from tec.error_get_id(2);
		END IF;
	END;
$function$;
/** Fucntion UPDATE  */

/** Fucntion DELETE  */
CREATE OR REPLACE FUNCTION tec.event_delete_id(_id int, OUT error tec.error, OUT id_ int)
	LANGUAGE plpgsql
AS $function$
	BEGIN
		IF (select * from tec.event_check_id(_id)) then
			DELETE FROM tec.event where id = _id RETURNING id INTO id_;
		ELSE 
			select * into error from tec.error_get_id(2);
		END IF;
	END;
$function$;
/** Fucntion DELETE  */

/** Fucntion */

/** Start Fucntion */
select * from tec.event_save(_name := 'test',_description := 'test', _active := false );
select * from tec.event_get();
select * from tec.event_get_id(_id := 1);
select * from tec.event_check_id(_id := 1);
select * from tec.event_check_name(_name := 'test');
select * from tec.event_delete_id(_id := 1);
select * from tec.event_update_id(_id := 1,_name := 'test',_description := 'test', _active := false );
/** Start Fucntion */