CREATE SCHEMA tec;


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
CREATE OR REPLACE FUNCTION tec.get_event()
	RETURNS SETOF "tec"."event"
	LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select * from tec.event;
	END;
$function$;

CREATE OR REPLACE FUNCTION tec.save_event(
	_name varchar,
	_description text DEFAULT NULL::character varying,
	_active boolean DEFAULT true,
	OUT id_res int
)
	LANGUAGE plpgsql
AS $function$
	BEGIN
		INSERT INTO tec.event 
			("name", description, active) 
			VALUES (_name, _description,_active) 
			RETURNING id INTO id_res;
	END;
$function$;
/** Fucntion */

/** Start Fucntion */
select * from tec.save_event(_name:='test',_description:='test', _active:=false );
select * from tec.get_event();
/** Start Fucntion */