/** Create table */
CREATE TABLE handbook."type_var" (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "name" varchar NOT NULL,
    description text NULL,
    active boolean,
    CONSTRAINT type_var_pk PRIMARY KEY (id)
);
/** Create table */
CREATE UNIQUE INDEX type_var_name_idx ON handbook.type_var USING btree (name);
/** Column comments*/
COMMENT ON COLUMN handbook.type_var.id IS 'Первичный ключ';
COMMENT ON COLUMN handbook.type_var."name" IS 'Имя типа переменной';
COMMENT ON COLUMN handbook.type_var.description IS 'Описание типа переменной';
COMMENT ON COLUMN handbook.type_var.active IS 'Активность типа переменной';
/** Column comments*/

/** Fucntion GET  */
CREATE OR REPLACE FUNCTION handbook.type_var_get()
RETURNS SETOF "handbook"."type_var"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from handbook.type_var;
    END;
$function$;
        
CREATE OR REPLACE FUNCTION handbook.type_var_get_id(_id int)
RETURNS SETOF "handbook"."type_var"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from handbook.type_var where id = _id;
    END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION handbook.type_var_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.type_var where "id" = _id);
    END;
$function$;

CREATE OR REPLACE FUNCTION handbook.type_var_check_name(_name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.type_var where "name" = _name);
    END;
$function$;

CREATE OR REPLACE FUNCTION handbook.type_var_check_update(_id int, _name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.type_var where id != _id and "name" = _name);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION handbook.type_var_save(
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    OUT id_ int,
    out error_  json
)
LANGUAGE plpgsql
AS $function$
    BEGIN
    IF (select * from handbook.type_var_check_name(_name)) <> true then
    INSERT INTO handbook.type_var 
        ("name", description, active) 
        VALUES (_name, _description,_active) 
        RETURNING id INTO id_;
ELSE 
    select * into error_ from tec.error_get_id(32);		
END IF;	
    END;
$function$;
/** Fucntion SAVE  */

CREATE OR REPLACE FUNCTION handbook.type_var_update_id(
    _id int, 
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    out error_  json, 
    OUT id_ int
)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from handbook.type_var_check_id(_id)) then
        IF (select * from handbook.type_var_check_update(_id, _name)) <> true then
            UPDATE handbook.type_var 
            SET 
                name = _name, 
                description = _description, 
                active = _active
            where id = _id RETURNING id INTO id_;
        ELSE 
            select * into error_ from tec.error_get_id(32);
        END IF;
    ELSE 
        select * into error_ from tec.error_get_id(33);
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION handbook.type_var_delete_id(_id int, out error_  json, OUT id_ int)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from handbook.type_var_check_id(_id)) then
        DELETE FROM handbook.type_var where id = _id RETURNING id INTO id_;
    ELSE 
        select * into error_ from tec.error_get_id(33);
    END IF;
END;
$function$;

/** Start Fucntion */
-- select * from handbook.type_var_save(_name := 'test',_description := 'test', _active := false );
-- select * from handbook.type_var_get();
-- select * from handbook.type_var_get_id(_id := 1);
-- select * from handbook.type_var_check_id(_id := 1);
-- select * from handbook.type_var_check_name(_name := 'test');
-- select * from handbook.type_var_delete_id(_id := 1);
-- select * from handbook.type_var_update_id(_id := 1,_name := 'test',_description := 'test', _active := false ); 
/** Start Fucntion */
