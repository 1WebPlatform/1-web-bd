/** Create table */
CREATE TABLE tec."roles" (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "name" varchar NOT NULL,
    description text NULL,
    active boolean,
    CONSTRAINT roles_pk PRIMARY KEY (id)
);
/** Create table */
CREATE UNIQUE INDEX roles_name_idx ON tec.roles USING btree (name);
/** Column comments*/
COMMENT ON COLUMN tec.roles.id IS 'Первичный ключ';
COMMENT ON COLUMN tec.roles."name" IS 'Имя роли';
COMMENT ON COLUMN tec.roles.description IS 'Описание роли';
COMMENT ON COLUMN tec.roles.active IS 'Активность роли';
/** Column comments*/

/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.roles_get()
RETURNS SETOF "tec"."roles"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from tec.roles;
    END;
$function$;
        
CREATE OR REPLACE FUNCTION tec.roles_get_id(_id int)
RETURNS SETOF "tec"."roles"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from tec.roles where id = _id;
    END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.roles_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.roles where "id" = _id);
    END;
$function$;

CREATE OR REPLACE FUNCTION tec.roles_check_name(_name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.roles where "name" = _name);
    END;
$function$;

CREATE OR REPLACE FUNCTION tec.roles_check_update(_id int, _name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.roles where id != _id and "name" = _name);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.roles_save(
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    OUT id_ int,
    OUT error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN
    IF (select * from tec.roles_check_name(_name)) <> true then
    INSERT INTO tec.roles 
        ("name", description, active) 
        VALUES (_name, _description,_active) 
        RETURNING id INTO id_;
ELSE 
    select * into error from tec.error_get_id(11);		
END IF;	
    END;
$function$;
/** Fucntion SAVE  */

CREATE OR REPLACE FUNCTION tec.roles_update_id(
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
    IF (select * from tec.roles_check_id(_id)) then
        IF (select * from tec.roles_check_update(_id, _name)) <> true then
            UPDATE tec.roles 
            SET 
                name = _name, 
                description = _description, 
                active = _active
            where id = _id RETURNING id INTO id_;
        ELSE 
            select * into error from tec.error_get_id(11);
        END IF;
    ELSE 
        select * into error from tec.error_get_id(12);
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION tec.roles_delete_id(_id int, OUT error tec.error, OUT id_ int)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from tec.roles_check_id(_id)) then
        DELETE FROM tec.roles where id = _id RETURNING id INTO id_;
    ELSE 
        select * into error from tec.error_get_id(12);
    END IF;
END;
$function$;

/** Start Fucntion */
select * from tec.roles_save(_name := 'test',_description := 'test', _active := false );
select * from tec.roles_get();
select * from tec.roles_get_id(_id := 1);
select * from tec.roles_check_id(_id := 1);
select * from tec.roles_check_name(_name := 'test');
select * from tec.roles_delete_id(_id := 1);
select * from tec.roles_update_id(_id := 1,_name := 'test',_description := 'test', _active := false ); 
/** Start Fucntion */
