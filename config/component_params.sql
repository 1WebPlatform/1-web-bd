/** Create table */
CREATE TABLE config.component_params (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    id_component int4 NOT NULL,
    id_params int4 NOT NULL,
    CONSTRAINT component_params_pk PRIMARY KEY (id),
    CONSTRAINT component_params_fk FOREIGN KEY (id_component) REFERENCES config.params(id),
    CONSTRAINT component_params_fk_1 FOREIGN KEY (id_params) REFERENCES handbook.type_component(id)
);
/** Create table */

/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION config.component_params_save(
    _id_component int,
    _id_params int,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$

declare
    check_component boolean;
    check_params boolean;
    BEGIN   
        check_component := (select * from handbook.type_component_check_id(_id_component));
        check_params := (select * from config.params_check_id(_id_params));
        if check_component <> true and check_params <> true then
            select * into error  from tec.error_get_id(32);
        elseif check_component <> true then 
            select * into error  from tec.error_get_id(26);
        elseif check_params <> true then 
            select * into error  from tec.error_get_id(30);
        else 
            INSERT INTO  config.component_params
            (id_component,id_params) 
            VALUES (_id_component,  _id_params) 
            RETURNING id INTO id_;
        end if;
    end;
$function$;
/** Fucntion SAVE  */

/** Fucntion GET  */
CREATE OR REPLACE FUNCTION config.component_params_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
RETURNS TABLE(id integer, params_id integer , params_name varchar , params_description text , params_select text , params_id_type int4, params_type_name varchar , component_id integer , component_name varchar , component_description text , component_active bool)
LANGUAGE plpgsql
AS $function$
    BEGIN   
    return query EXECUTE (
        select * from tec.table_get(
           'SELECT cp.id as id, p.id AS params_id, p."name" AS params_name, p.description AS params_description, p."select" AS params_select, p.id_type AS params_id_type, tp."name" AS params_type_name, tc.id AS component_id, tc."name" AS component_name, tc.description AS component_description, tc.active AS component_active FROM config.component_params cp LEFT JOIN config.params p ON p.id = cp.id_params LEFT JOIN handbook.type_component tc ON tc.id = cp.id_component LEFT JOIN handbook.type_params tp ON tp.id = p.id_type',
            _limit, _offset, _order_by, _where
            )
        );
    end;
$function$;
        
CREATE OR REPLACE FUNCTION config.component_params_get_id(
    _id int
)
RETURNS TABLE(id integer, params_id integer , params_name varchar , params_description text , params_select text , params_id_type int4, params_type_name varchar , component_id integer , component_name varchar , component_description text , component_active bool)
LANGUAGE plpgsql
AS $function$
    BEGIN   
        return query SELECT cp.id as id, p.id AS params_id, p."name" AS params_name, p.description AS params_description, p."select" AS params_select, p.id_type AS params_id_type, tp."name" AS params_type_name, tc.id AS component_id, tc."name" AS component_name, tc.description AS component_description, tc.active AS component_active FROM config.component_params cp LEFT JOIN config.params p ON p.id = cp.id_params LEFT JOIN handbook.type_component tc ON tc.id = cp.id_component LEFT JOIN handbook.type_params tp ON tp.id = p.id_type where cp.id = _id;
    end;
$function$;
/** Fucntion GET  */

/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION config.component_params_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from config.component_params where "id" = _id);
    END;
$function$;
/** Fucntion CHECK  */


/** Fucntion DELETE  */
CREATE OR REPLACE FUNCTION config.component_params_delete(
    _id int,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN   
	    if(select * from config.component_params_check_id(_id)) then
	   		DELETE FROM config.component_params  where id = _id RETURNING id INTO id_; 	
	    else
	    	select * into error  from tec.error_get_id(31);   
	    end if;
     end;
$function$;
/** Fucntion DELETE  */


/** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION config.component_params_update_id(
    _id int,
    _id_component integer, 
    _id_params integer,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$
declare
    check_component boolean;
    check_params boolean;
   
    BEGIN   
	    if(select * from config.component_params_check_id(_id)) then
            check_component := (select * from handbook.type_component_check_id(_id_component));
	        check_params := (select * from config.params_check_id(_id_params));
	        if check_component <> true and check_params <> true then
	            select * into error  from tec.error_get_id(32);
	        elseif check_component <> true then 
	            select * into error  from tec.error_get_id(26);
	        elseif check_params <> true then 
	            select * into error  from tec.error_get_id(30);
		   	else
		   		UPDATE config.component_params
	            SET 
	                id_component = _id_component, 
	                id_params = _id_params
	            where id = _id RETURNING id INTO id_;
	        end if;
	    else
		   	select * into error  from tec.error_get_id(31);   
	    end if;
     end;
$function$;
/** Fucntion UPDATE  */

-- select * from config.component_params_save(1,1);
-- select * from config.component_params_update_id(1,1,1);
-- select * from config.component_params_check_id(1);
-- select * from config.component_params_get();
-- select * from config.component_params_get_id(1);
-- select * from config.component_params_delete(1);
