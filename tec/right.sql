/** Create table */
CREATE TABLE tec."right" (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "name" varchar NOT NULL,
    description text NULL,
    active boolean,
    CONSTRAINT right_pk PRIMARY KEY (id)
);
/** Create table */
CREATE UNIQUE INDEX right_name_idx ON tec.right USING btree (name);
/** Column comments*/
COMMENT ON COLUMN tec.right.id IS 'Первичный ключ';
COMMENT ON COLUMN tec.right."name" IS 'Имя право';
COMMENT ON COLUMN tec.right.description IS 'Описание право';
COMMENT ON COLUMN tec.right.active IS 'Активность право';
/** Column comments*/

/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.right_get()
RETURNS SETOF "tec"."right"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from tec.right;
    END;
$function$;
        
CREATE OR REPLACE FUNCTION tec.right_get_id(_id int)
RETURNS SETOF "tec"."right"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from tec.right where id = _id;
    END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.right_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.right where "id" = _id);
    END;
$function$;

CREATE OR REPLACE FUNCTION tec.right_check_name(_name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.right where "name" = _name);
    END;
$function$;

CREATE OR REPLACE FUNCTION tec.right_check_update(_id int, _name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.right where id != _id and "name" = _name);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.right_save(
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    OUT id_ int,
    OUT error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN
    IF (select * from tec.right_check_name(_name)) <> true then
    INSERT INTO tec.right 
        ("name", description, active) 
        VALUES (_name, _description,_active) 
        RETURNING id INTO id_;
ELSE 
    select * into error from tec.error_get_id(9);		
END IF;	
    END;
$function$;
/** Fucntion SAVE  */

CREATE OR REPLACE FUNCTION tec.right_update_id(
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
    IF (select * from tec.right_check_id(_id)) then
        IF (select * from tec.right_check_update(_id, _name)) <> true then
            UPDATE tec.right 
            SET 
                name = _name, 
                description = _description, 
                active = _active
            where id = _id RETURNING id INTO id_;
        ELSE 
            select * into error from tec.error_get_id(9);
        END IF;
    ELSE 
        select * into error from tec.error_get_id(10);
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION tec.right_delete_id(_id int, OUT error tec.error, OUT id_ int)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from tec.right_check_id(_id)) then
        DELETE FROM tec.right where id = _id RETURNING id INTO id_;
    ELSE 
        select * into error from tec.error_get_id(10);
    END IF;
END;
$function$;

/** Start Fucntion */
select * from tec.right_save(_name := 'test',_description := 'test', _active := false );
select * from tec.right_get();
select * from tec.right_get_id(_id := 1);
select * from tec.right_check_id(_id := 1);
select * from tec.right_check_name(_name := 'test');
select * from tec.right_delete_id(_id := 1);
select * from tec.right_update_id(_id := 1,_name := 'test',_description := 'test', _active := false ); 
/** Start Fucntion */
