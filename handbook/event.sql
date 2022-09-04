/** Create table */
CREATE TABLE handbook."event" (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "name" varchar NOT NULL,
    description text NULL,
    active boolean,
    CONSTRAINT event_pk PRIMARY KEY (id)
);
/** Create table */
CREATE UNIQUE INDEX event_name_idx ON handbook.event USING btree (name);
/** Column comments*/
COMMENT ON COLUMN handbook.event.id IS 'Первичный ключ';
COMMENT ON COLUMN handbook.event."name" IS 'Имя события';
COMMENT ON COLUMN handbook.event.description IS 'Описание события';
COMMENT ON COLUMN handbook.event.active IS 'Активность события';
/** Column comments*/

/** Fucntion GET  */
CREATE OR REPLACE FUNCTION handbook.event_get()
RETURNS SETOF "handbook"."event"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from handbook.event;
    END;
$function$;
        
CREATE OR REPLACE FUNCTION handbook.event_get_id(_id int)
RETURNS SETOF "handbook"."event"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from handbook.event where id = _id;
    END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION handbook.event_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.event where "id" = _id);
    END;
$function$;

CREATE OR REPLACE FUNCTION handbook.event_check_name(_name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.event where "name" = _name);
    END;
$function$;

CREATE OR REPLACE FUNCTION handbook.event_check_update(_id int, _name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.event where id != _id and "name" = _name);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION handbook.event_save(
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    OUT id_ int,
    OUT error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN
    IF (select * from handbook.event_check_name(_name)) <> true then
    INSERT INTO handbook.event 
        ("name", description, active) 
        VALUES (_name, _description,_active) 
        RETURNING id INTO id_;
ELSE 
    select * into error from tec.error_get_id(1);		
END IF;	
    END;
$function$;
/** Fucntion SAVE  */

CREATE OR REPLACE FUNCTION handbook.event_update_id(
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
    IF (select * from handbook.event_check_id(_id)) then
        IF (select * from handbook.event_check_update(_id, _name)) <> true then
            UPDATE handbook.event 
            SET 
                name = _name, 
                description = _description, 
                active = _active
            where id = _id RETURNING id INTO id_;
        ELSE 
            select * into error from tec.error_get_id(1);
        END IF;
    ELSE 
        select * into error from tec.error_get_id(2);
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION handbook.event_delete_id(_id int, OUT error tec.error, OUT id_ int)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from handbook.event_check_id(_id)) then
        DELETE FROM handbook.event where id = _id RETURNING id INTO id_;
    ELSE 
        select * into error from tec.error_get_id(2);
    END IF;
END;
$function$;

/** Start Fucntion */
select * from handbook.event_save(_name := 'test',_description := 'test', _active := false );
select * from handbook.event_get();
select * from handbook.event_get_id(_id := 1);
select * from handbook.event_check_id(_id := 1);
select * from handbook.event_check_name(_name := 'test');
select * from handbook.event_delete_id(_id := 1);
select * from handbook.event_update_id(_id := 1,_name := 'test',_description := 'test', _active := false ); 
/** Start Fucntion */
