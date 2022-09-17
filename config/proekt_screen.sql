
/** Create table */        
CREATE TABLE config.proekt_screen (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    id_proekt int4 NOT NULL,
    id_screen int4 NOT NULL,
    CONSTRAINT proekt_screen_pk PRIMARY KEY (id),
    CONSTRAINT proekt_screen_fk FOREIGN KEY (id_proekt) REFERENCES config.proekt(id),
    CONSTRAINT proekt_screen_fk_1 FOREIGN KEY (id_screen) REFERENCES config.screen(id)
);
/** Create table */
/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION config.proekt_screen_save(
    _id_proekt int,
    _id_screen int,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$

declare
    check_proekt boolean;
    check_screen boolean;
    BEGIN   
        check_proekt := (select * from config.proekt_check_id(_id_proekt));
        check_screen := (select * from config.screen_check_id(_id_screen));
        if check_proekt <> true and check_screen <> true then
            select * into error  from tec.error_get_id(24);
        elseif check_proekt <> true then 
            select * into error  from tec.error_get_id(21);
        elseif check_screen <> true then 
            select * into error  from tec.error_get_id(22);
        else 
            INSERT INTO  config.proekt_screen
            (id_proekt,id_screen) 
            VALUES (_id_proekt,  _id_screen) 
            RETURNING id INTO id_;
        end if;
    end;
$function$;
/** Fucntion SAVE  */


/** Fucntion GET  */
CREATE OR REPLACE FUNCTION config.proekt_screen_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
RETURNS TABLE(proekt_id serial, proekt_name varchar , proekt_description text , proekt_icons varchar , proekt_active bool, proekt_date_create timestamptz, screen_id serial NOT, screen_name varchar , screen_description text , screen_title varchar , screen_url varchar , screen_icons varchar , screen_active bool, right_id serial NOT, right_name varchar , right_description text, right_active bool)
LANGUAGE plpgsql
AS $function$
    BEGIN   
    return query EXECUTE (
        select * from tec.table_get(
           'SELECT p.id AS proekt_id, p."name" AS proekt_name, p.description AS proekt_description, p.icons AS proekt_icons, p.active AS proekt_active, p.date_create AS proekt_date_create, s.id AS screen_id, s."name" AS screen_name, s.description AS screen_description, s.title AS screen_title, s.url AS screen_url, s.icons AS screen_icons, s.active AS screen_active, r.id AS right_id, r."name" AS right_name, r.description AS right_description, r.active AS right_active FROM config.proekt_screen ps LEFT JOIN config.proekt p ON p.id = ps.id_proekt LEFT JOIN config.screen s ON s.id = ps.id_screen LEFT JOIN tec."right" r ON r.id = s.id_right',
            _limit, _offset, _order_by, _where
            )
        );
    end;
$function$;
        
CREATE OR REPLACE FUNCTION config.proekt_screen_get_id(
    _id int
)
RETURNS TABLE(proekt_id serial, proekt_name varchar , proekt_description text , proekt_icons varchar , proekt_active bool, proekt_date_create timestamptz, screen_id serial NOT, screen_name varchar , screen_description text , screen_title varchar , screen_url varchar , screen_icons varchar , screen_active bool, right_id serial NOT, right_name varchar , right_description text, right_active bool)
LANGUAGE plpgsql
AS $function$
    BEGIN   
        return query SELECT p.id AS proekt_id, p."name" AS proekt_name, p.description AS proekt_description, p.icons AS proekt_icons, p.active AS proekt_active, p.date_create AS proekt_date_create, s.id AS screen_id, s."name" AS screen_name, s.description AS screen_description, s.title AS screen_title, s.url AS screen_url, s.icons AS screen_icons, s.active AS screen_active, r.id AS right_id, r."name" AS right_name, r.description AS right_description, r.active AS right_active FROM config.proekt_screen ps LEFT JOIN config.proekt p ON p.id = ps.id_proekt LEFT JOIN config.screen s ON s.id = ps.id_screen LEFT JOIN tec."right" r ON r.id = s.id_right where ps.id = _id;
    end;
$function$;
/** Fucntion GET  */
        
/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION config.proekt_screen_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from config.proekt_screen where "id" = _id);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion DELETE  */
CREATE OR REPLACE FUNCTION config.proekt_screen_delete(
    _id int,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN   
	    if(select * from config.proekt_screen_check_id(_id)) then
	   		DELETE FROM config.proekt_screen  where id = _id RETURNING id INTO id_; 	
	    else
	    	select * into error  from tec.error_get_id(23);   
	    end if;
     end;
$function$;
/** Fucntion DELETE  */

/** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION config.proekt_screen_update_id(
    _id int,
    _id_proekt integer, 
    _id_screen integer,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$
declare
    check_proekt boolean;
    check_screen boolean;
   
    BEGIN   
	    if(select * from config.proekt_screen_check_id(_id)) then
		    check_proekt := (select * from config.proekt_check_id(_id_proekt));
	        check_screen := (select * from config.screen_check_id(_id_screen));
	        if check_proekt <> true and check_screen <> true then
	            select * into error  from tec.error_get_id(24);
	        elseif check_proekt <> true then 
	            select * into error  from tec.error_get_id(21);
	        elseif check_screen <> true then 
	            select * into error  from tec.error_get_id(22);
		   	else
		   		UPDATE config.proekt_screen
	            SET 
	                id_proekt = _id_proekt, 
	                id_screen = _id_screen
	            where id = _id RETURNING id INTO id_;
	        end if;
	    else
		   	select * into error  from tec.error_get_id(23);   
	    end if;
     end;
$function$;
/** Fucntion UPDATE  */

-- select * from config.proekt_screen_save(1,1);
-- select * from config.proekt_screen_update_id(1,1,1);
-- select * from config.proekt_screen_check_id(1);
-- select * from config.proekt_screen_get();
-- select * from config.proekt_screen_get_id(1);
-- select * from config.proekt_screen_delete(1);
