/** Create table */
CREATE TABLE handbook."type_component" (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "name" varchar NOT NULL,
    description text NULL,
    active boolean,
    CONSTRAINT type_component_pk PRIMARY KEY (id)
);
/** Create table */
CREATE UNIQUE INDEX type_component_name_idx ON handbook.type_component USING btree (name);
/** Column comments*/
COMMENT ON COLUMN handbook.type_component.id IS 'Первичный ключ';
COMMENT ON COLUMN handbook.type_component."name" IS 'Имя типа компонента';
COMMENT ON COLUMN handbook.type_component.description IS 'Описание типа компонента';
COMMENT ON COLUMN handbook.type_component.active IS 'Активность типа компонента';
/** Column comments*/

/** Fucntion GET  */
CREATE OR REPLACE FUNCTION handbook.type_component_get()
RETURNS SETOF "handbook"."type_component"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from handbook.type_component;
    END;
$function$;
        
CREATE OR REPLACE FUNCTION handbook.type_component_get_id(_id int)
RETURNS SETOF "handbook"."type_component"
LANGUAGE plpgsql
AS $function$
    BEGIN
        return query select * from handbook.type_component where id = _id;
    END;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION handbook.type_component_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.type_component where "id" = _id);
    END;
$function$;

CREATE OR REPLACE FUNCTION handbook.type_component_check_name(_name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.type_component where "name" = _name);
    END;
$function$;

CREATE OR REPLACE FUNCTION handbook.type_component_check_update(_id int, _name varchar)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from handbook.type_component where id != _id and "name" = _name);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION handbook.type_component_save(
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    OUT id_ int,
    out error_ tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN
    IF (select * from handbook.type_component_check_name(_name)) <> true then
    INSERT INTO handbook.type_component 
        ("name", description, active) 
        VALUES (_name, _description,_active) 
        RETURNING id INTO id_;
ELSE 
    select * into error_ from tec.error_get_id(5);		
END IF;	
    END;
$function$;
/** Fucntion SAVE  */

CREATE OR REPLACE FUNCTION handbook.type_component_update_id(
    _id int, 
    _name varchar,
    _description text DEFAULT NULL::character varying,
    _active boolean DEFAULT true,
    out error_ tec.error, 
    OUT id_ int
)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from handbook.type_component_check_id(_id)) then
        IF (select * from handbook.type_component_check_update(_id, _name)) <> true then
            UPDATE handbook.type_component 
            SET 
                name = _name, 
                description = _description, 
                active = _active
            where id = _id RETURNING id INTO id_;
        ELSE 
            select * into error_ from tec.error_get_id(5);
        END IF;
    ELSE 
        select * into error_ from tec.error_get_id(6);
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION handbook.type_component_delete_id(_id int, out error_ tec.error, OUT id_ int)
LANGUAGE plpgsql
AS $function$
BEGIN
    IF (select * from handbook.type_component_check_id(_id)) then
        DELETE FROM handbook.type_component where id = _id RETURNING id INTO id_;
    ELSE 
        select * into error_ from tec.error_get_id(6);
    END IF;
END;
$function$;

/** Start Fucntion */
select * from handbook.type_component_save(_name := 'test',_description := 'test', _active := false );
select * from handbook.type_component_get();
select * from handbook.type_component_get_id(_id := 1);
select * from handbook.type_component_check_id(_id := 1);
select * from handbook.type_component_check_name(_name := 'test');
select * from handbook.type_component_delete_id(_id := 1);
select * from handbook.type_component_update_id(_id := 1,_name := 'test',_description := 'test', _active := false ); 
/** Start Fucntion */
