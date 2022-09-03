CREATE SCHEMA handbook;
CREATE SCHEMA tec;

CREATE TABLE tec."error" (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	"description" text NOT NULL,
	"status" varchar NOT NULL
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
/** Fucntion */
/** Fucntion GET  */


/** DATA bd */
INSERT INTO "tec"."error" ("name", "description", "status") VALUES
    ('Ошибка уникальности', 'Указанное имя события уже занято', '400'),
	('Запись не найдена', 'Указанный id события не существует', '404'),
	('Ошибка уникальности', 'Указанное имя типа параметра уже занято', '400'),
	('Запись не найдена', 'Указанный id типа параметра не существует', '404'),
	('Ошибка уникальности', 'Указанное имя типа компонента уже занято', '400'),
	('Запись не найдена', 'Указанный id типа компонента не существует', '404');
/** DATA bd */


/** Start Fucntion */
select * from tec.error_get_id(_id := 1);
/** Start Fucntion */


/** Create table */
        CREATE TABLE handbook."event" (
            id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
            "name" varchar NOT NULL,
            description text NULL,
            active boolean
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
			select * into error from tec.error_get_id(2);		
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
                IF (select * from handbook.event_check_name(_name)) <> true then
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
        
        /** Create table */
        CREATE TABLE handbook."type_component" (
            id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
            "name" varchar NOT NULL,
            description text NULL,
            active boolean
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
        /** Fucntion CHECK  */
        
        /** Fucntion SAVE  */
        CREATE OR REPLACE FUNCTION handbook.type_component_save(
            _name varchar,
            _description text DEFAULT NULL::character varying,
            _active boolean DEFAULT true,
            OUT id_ int,
            OUT error tec.error
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
			select * into error from tec.error_get_id(5);		
		END IF;	
            END;
        $function$;
        /** Fucntion SAVE  */
        
        CREATE OR REPLACE FUNCTION handbook.type_component_update_id(
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
            IF (select * from handbook.type_component_check_id(_id)) then
                IF (select * from handbook.type_component_check_name(_name)) <> true then
                    UPDATE handbook.type_component 
                    SET 
                        name = _name, 
                        description = _description, 
                        active = _active
                    where id = _id RETURNING id INTO id_;
                ELSE 
                    select * into error from tec.error_get_id(6);
                END IF;
            ELSE 
                select * into error from tec.error_get_id(5);
            END IF;
        END;
    $function$;
        
        CREATE OR REPLACE FUNCTION handbook.type_component_delete_id(_id int, OUT error tec.error, OUT id_ int)
        LANGUAGE plpgsql
    AS $function$
        BEGIN
            IF (select * from handbook.type_component_check_id(_id)) then
                DELETE FROM handbook.type_component where id = _id RETURNING id INTO id_;
            ELSE 
                select * into error from tec.error_get_id(2);
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
        
        /** Create table */
        CREATE TABLE handbook."type_params" (
            id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
            "name" varchar NOT NULL,
            description text NULL,
            active boolean
        );
        /** Create table */
        CREATE UNIQUE INDEX type_params_name_idx ON handbook.type_params USING btree (name);
        /** Column comments*/
        COMMENT ON COLUMN handbook.type_params.id IS 'Первичный ключ';
        COMMENT ON COLUMN handbook.type_params."name" IS 'Имя типа параметра';
        COMMENT ON COLUMN handbook.type_params.description IS 'Описание типа параметра';
        COMMENT ON COLUMN handbook.type_params.active IS 'Активность типа параметра';
        /** Column comments*/
        
        /** Fucntion GET  */
        CREATE OR REPLACE FUNCTION handbook.type_params_get()
        RETURNS SETOF "handbook"."type_params"
        LANGUAGE plpgsql
        AS $function$
            BEGIN
                return query select * from handbook.type_params;
            END;
        $function$;
        
        CREATE OR REPLACE FUNCTION handbook.type_params_get_id(_id int)
        RETURNS SETOF "handbook"."type_params"
        LANGUAGE plpgsql
        AS $function$
            BEGIN
                return query select * from handbook.type_params where id = _id;
            END;
        $function$;
        /** Fucntion GET  */
        
        /** Fucntion CHECK  */
        CREATE OR REPLACE FUNCTION handbook.type_params_check_id(_id int)
        RETURNS boolean
        LANGUAGE plpgsql
        AS $function$
            BEGIN
                return EXISTS (select * from handbook.type_params where "id" = _id);
            END;
        $function$;
        
        CREATE OR REPLACE FUNCTION handbook.type_params_check_name(_name varchar)
        RETURNS boolean
        LANGUAGE plpgsql
        AS $function$
            BEGIN
                return EXISTS (select * from handbook.type_params where "name" = _name);
            END;
        $function$;
        /** Fucntion CHECK  */
        
        /** Fucntion SAVE  */
        CREATE OR REPLACE FUNCTION handbook.type_params_save(
            _name varchar,
            _description text DEFAULT NULL::character varying,
            _active boolean DEFAULT true,
            OUT id_ int,
            OUT error tec.error
        )
        LANGUAGE plpgsql
        AS $function$
            BEGIN
            IF (select * from handbook.type_params_check_name(_name)) <> true then
			INSERT INTO handbook.type_params 
				("name", description, active) 
				VALUES (_name, _description,_active) 
				RETURNING id INTO id_;
		ELSE 
			select * into error from tec.error_get_id(3);		
		END IF;	
            END;
        $function$;
        /** Fucntion SAVE  */
        
        CREATE OR REPLACE FUNCTION handbook.type_params_update_id(
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
            IF (select * from handbook.type_params_check_id(_id)) then
                IF (select * from handbook.type_params_check_name(_name)) <> true then
                    UPDATE handbook.type_params 
                    SET 
                        name = _name, 
                        description = _description, 
                        active = _active
                    where id = _id RETURNING id INTO id_;
                ELSE 
                    select * into error from tec.error_get_id(4);
                END IF;
            ELSE 
                select * into error from tec.error_get_id(3);
            END IF;
        END;
    $function$;
        
        CREATE OR REPLACE FUNCTION handbook.type_params_delete_id(_id int, OUT error tec.error, OUT id_ int)
        LANGUAGE plpgsql
    AS $function$
        BEGIN
            IF (select * from handbook.type_params_check_id(_id)) then
                DELETE FROM handbook.type_params where id = _id RETURNING id INTO id_;
            ELSE 
                select * into error from tec.error_get_id(2);
            END IF;
        END;
    $function$;
        
        /** Start Fucntion */
        select * from handbook.type_params_save(_name := 'test',_description := 'test', _active := false );
        select * from handbook.type_params_get();
        select * from handbook.type_params_get_id(_id := 1);
        select * from handbook.type_params_check_id(_id := 1);
        select * from handbook.type_params_check_name(_name := 'test');
        select * from handbook.type_params_delete_id(_id := 1);
        select * from handbook.type_params_update_id(_id := 1,_name := 'test',_description := 'test', _active := false ); 
        /** Start Fucntion */
        