
/** Create table */        
CREATE TABLE tec.right_roles (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    id_right int4 NOT NULL,
    id_roles int4 NOT NULL,
    CONSTRAINT right_roles_pk PRIMARY KEY (id),
    CONSTRAINT right_roles_fk FOREIGN KEY (id_right) REFERENCES tec.right(id),
    CONSTRAINT right_roles_fk_1 FOREIGN KEY (id_roles) REFERENCES tec.roles(id)
);
/** Create table */
/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.right_roles_save(
    _id_right int,
    _id_roles int,
    out id_ int,
    OUT error_  json
)
LANGUAGE plpgsql
AS $function$

declare
    check_right boolean;
    check_roles boolean;
    BEGIN   
        check_right := (select * from tec.right_check_id(_id_right));
        check_roles := (select * from tec.roles_check_id(_id_roles));
        if check_right <> true and check_roles <> true then
            select * into error_  from tec.error_get_id(13);
        elseif check_right <> true then 
            select * into error_  from tec.error_get_id(10);
        elseif check_roles <> true then 
            select * into error_  from tec.error_get_id(12);
        else 
            INSERT INTO  tec.right_roles
            (id_right,id_roles) 
            VALUES (_id_right,  _id_roles) 
            RETURNING id INTO id_;
        end if;
    end;
$function$;
/** Fucntion SAVE  */


/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.right_roles_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
RETURNS TABLE(id int, id_right int, id_roles int, right_name varchar, right_description text, right_active boolean, roles_name varchar,roles_description text, roles_active boolean)
LANGUAGE plpgsql
AS $function$
    BEGIN   
    return query EXECUTE (
        select * from tec.table_get(
           'select rr.id, rr.id_right, rr.id_roles, r."name" as right_name, r.description as right_description, r.active as right_active, r2."name" as roles_name, r2.description as roles_description, r2.active as roles_active from tec.right_roles rr left join "right" r ON r.id = rr."id_right" left join roles r2 ON  r2.id = rr."id_roles" ',
            _limit, _offset, _order_by, _where
            )
        );
    end;
$function$;
        
CREATE OR REPLACE FUNCTION tec.right_roles_get_id(
    _id int
)
RETURNS TABLE(id int, id_right int, id_roles int, right_name varchar, right_description text, right_active boolean, roles_name varchar,roles_description text, roles_active boolean)
LANGUAGE plpgsql
AS $function$
    BEGIN   
        return query select rr.id, rr.id_right, rr.id_roles, r."name" as right_name, r.description as right_description, r.active as right_active, r2."name" as roles_name, r2.description as roles_description, r2.active as roles_active from tec.right_roles rr left join "right" r ON r.id = rr."id_right" left join roles r2 ON  r2.id = rr."id_roles"  where rr.id = _id;
    end;
$function$;
/** Fucntion GET  */
        
/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.right_roles_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.right_roles where "id" = _id);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion DELETE  */
CREATE OR REPLACE FUNCTION tec.right_roles_delete(
    _id int,
    out id_ int,
    OUT error_  json
)
LANGUAGE plpgsql
AS $function$
    BEGIN   
	    if(select * from tec.right_roles_check_id(_id)) then
	   		DELETE FROM tec.right_roles  where id = _id RETURNING id INTO id_; 	
	    else
	    	select * into error_  from tec.error_get_id(14);   
	    end if;
     end;
$function$;
/** Fucntion DELETE  */

/** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION tec.right_roles_update_id(
    _id int,
    _id_right integer, 
    _id_roles integer,
    out id_ int,
    OUT error_  json
)
LANGUAGE plpgsql
AS $function$
declare
    check_right boolean;
    check_roles boolean;
   
    BEGIN   
	    if(select * from tec.right_roles_check_id(_id)) then
		    check_right := (select * from tec.right_check_id(_id_right));
	        check_roles := (select * from tec.roles_check_id(_id_roles));
	        if check_right <> true and check_roles <> true then
	            select * into error_  from tec.error_get_id(13);
	        elseif check_right <> true then 
	            select * into error_  from tec.error_get_id(10);
	        elseif check_roles <> true then 
	            select * into error_  from tec.error_get_id(12);
		   	else
		   		UPDATE tec.right_roles
	            SET 
	                id_right = _id_right, 
	                id_roles = _id_roles
	            where id = _id RETURNING id INTO id_;
	        end if;
	    else
		   	select * into error_  from tec.error_get_id(14);   
	    end if;
     end;
$function$;
/** Fucntion UPDATE  */

-- select * from tec.right_roles_save(1,1);
-- select * from tec.right_roles_update_id(1,1,1);
-- select * from tec.right_roles_check_id(1);
-- select * from tec.right_roles_get();
-- select * from tec.right_roles_get_id(1);
-- select * from tec.right_roles_delete(1);
