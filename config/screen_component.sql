
/** Create table */        
CREATE TABLE config.screen_component (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    id_screen int4 NOT NULL,
    id_component int4 NOT NULL,
    CONSTRAINT screen_component_pk PRIMARY KEY (id),
    CONSTRAINT screen_component_fk FOREIGN KEY (id_screen) REFERENCES config.screen(id),
    CONSTRAINT screen_component_fk_1 FOREIGN KEY (id_component) REFERENCES config.component(id)
);
/** Create table */
/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION config.screen_component_save(
    _id_screen int,
    _id_component int,
    out id_ int,
    out error_ tec.error
)
LANGUAGE plpgsql
AS $function$

declare
    check_screen boolean;
    check_component boolean;
    BEGIN   
        check_screen := (select * from config.screen_check_id(_id_screen));
        check_component := (select * from config.component_check_id(_id_component));
        if check_screen <> true and check_component <> true then
            select * into error_  from tec.error_get_id(28);
        elseif check_screen <> true then 
            select * into error_  from tec.error_get_id(21);
        elseif check_component <> true then 
            select * into error_  from tec.error_get_id(25);
        else 
            INSERT INTO  config.screen_component
            (id_screen,id_component) 
            VALUES (_id_screen,  _id_component) 
            RETURNING id INTO id_;
        end if;
    end;
$function$;
/** Fucntion SAVE  */


/** Fucntion GET  */
CREATE OR REPLACE FUNCTION config.screen_component_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
RETURNS TABLE( component_id integer , component_name varchar(10485760), component_description text , component_css text , component_params text , component_schema text , component_type varchar(10485760), component_parent_id int4, screen_id integer , screen_name varchar(10485760), screen_description text , screen_title varchar(10485760), screen_url varchar(10485760), screen_icons varchar(10485760), screen_active bool)
LANGUAGE plpgsql
AS $function$
    BEGIN   
    return query EXECUTE (
        select * from tec.table_get(
           'SELECT c.id AS component_id, c."name" AS component_name, c.description AS component_description, c.css AS component_css, c.params AS component_params, c."schema" AS component_schema, tc."name" AS component_type, c.id_parent AS component_parent_id, s.id AS screen_id, s."name" AS screen_name, s.description AS screen_description, s.title AS screen_title, s.url AS screen_url, s.icons AS screen_icons, s.active AS screen_active FROM config.screen_component sc LEFT JOIN config.screen s ON s.id = sc.id_screen LEFT JOIN config.component c ON c.id = sc.id_component LEFT JOIN handbook.type_component tc ON tc.id = c.id_type',
            _limit, _offset, _order_by, _where
            )
        );
    end;
$function$;
        
CREATE OR REPLACE FUNCTION config.screen_component_get_id(
    _id int
)
RETURNS TABLE( component_id integer , component_name varchar(10485760), component_description text , component_css text , component_params text , component_schema text , component_type varchar(10485760), component_parent_id int4, screen_id integer , screen_name varchar(10485760), screen_description text , screen_title varchar(10485760), screen_url varchar(10485760), screen_icons varchar(10485760), screen_active bool)
LANGUAGE plpgsql
AS $function$
    BEGIN   
        return query SELECT c.id AS component_id, c."name" AS component_name, c.description AS component_description, c.css AS component_css, c.params AS component_params, c."schema" AS component_schema, tc."name" AS component_type, c.id_parent AS component_parent_id, s.id AS screen_id, s."name" AS screen_name, s.description AS screen_description, s.title AS screen_title, s.url AS screen_url, s.icons AS screen_icons, s.active AS screen_active FROM config.screen_component sc LEFT JOIN config.screen s ON s.id = sc.id_screen LEFT JOIN config.component c ON c.id = sc.id_component LEFT JOIN handbook.type_component tc ON tc.id = c.id_type where sc.id = _id;
    end;
$function$;
/** Fucntion GET  */
        
/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION config.screen_component_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from config.screen_component where "id" = _id);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion DELETE  */
CREATE OR REPLACE FUNCTION config.screen_component_delete(
    _id int,
    out id_ int,
    out error_ tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN   
	    if(select * from config.screen_component_check_id(_id)) then
	   		DELETE FROM config.screen_component  where id = _id RETURNING id INTO id_; 	
	    else
	    	select * into error_  from tec.error_get_id(27);   
	    end if;
     end;
$function$;
/** Fucntion DELETE  */

/** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION config.screen_component_update_id(
    _id int,
    _id_screen integer, 
    _id_component integer,
    out id_ int,
    out error_ tec.error
)
LANGUAGE plpgsql
AS $function$
declare
    check_screen boolean;
    check_component boolean;
   
    BEGIN   
	    if(select * from config.screen_component_check_id(_id)) then
		    check_screen := (select * from config.screen_check_id(_id_screen));
	        check_component := (select * from config.component_check_id(_id_component));
	        if check_screen <> true and check_component <> true then
	            select * into error_  from tec.error_get_id(28);
	        elseif check_screen <> true then 
	            select * into error_  from tec.error_get_id(21);
	        elseif check_component <> true then 
	            select * into error_  from tec.error_get_id(25);
		   	else
		   		UPDATE config.screen_component
	            SET 
	                id_screen = _id_screen, 
	                id_component = _id_component
	            where id = _id RETURNING id INTO id_;
	        end if;
	    else
		   	select * into error_  from tec.error_get_id(27);   
	    end if;
     end;
$function$;
/** Fucntion UPDATE  */

-- select * from config.screen_component_save(1,1);
-- select * from config.screen_component_update_id(1,1,1);
-- select * from config.screen_component_check_id(1);
-- select * from config.screen_component_get();
-- select * from config.screen_component_get_id(1);
-- select * from config.screen_component_delete(1);
