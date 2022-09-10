
/** Create table */        
CREATE TABLE tec.roles_user (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    id_user int4 NOT NULL,
    id_roles int4 NOT NULL,
    CONSTRAINT roles_user_pk PRIMARY KEY (id),
    CONSTRAINT roles_user_fk FOREIGN KEY (id_user) REFERENCES tec.user(id),
    CONSTRAINT roles_user_fk_1 FOREIGN KEY (id_roles) REFERENCES tec.roles(id)
);
/** Create table */
/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.roles_user_save(
    _id_user int,
    _id_roles int,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$

declare
    check_user boolean;
    check_roles boolean;
    BEGIN   
        check_user := (select * from tec.user_check_id(_id_user));
        check_roles := (select * from tec.roles_check_id(_id_roles));
        if check_user <> true and check_roles <> true then
            select * into error  from tec.error_get_id(16);
        elseif check_user <> true then 
            select * into error  from tec.error_get_id(8);
        elseif check_roles <> true then 
            select * into error  from tec.error_get_id(12);
        else 
            INSERT INTO  tec.roles_user
            (id_user,id_roles) 
            VALUES (_id_user,  _id_roles) 
            RETURNING id INTO id_;
        end if;
    end;
$function$;
/** Fucntion SAVE  */


/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.roles_user_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
RETURNS TABLE(id int, user_id int, user_name varchar, user_patronymic varchar, user_surname varchar, user_email varchar, user_active boolean, user_verified boolean, user_create_date timestamptz, roles_id int, roles_name varchar,roles_description text, roles_active boolean)
LANGUAGE plpgsql
AS $function$
    BEGIN   
    return query EXECUTE (
        select * from tec.table_get(
           'SELECT ru.id AS id, u.id AS user_id, u."name" AS user_name, u.patronymic AS user_patronymic, u.surname AS user_surname, u.email AS user_email, u.active AS user_active, u.verified AS user_verified, u.create_date AS user_create_date, r.id AS roles_id, r."name" AS roles_name, r.description AS roles_description, r.active AS roles_active FROM tec.roles_user ru LEFT JOIN "user" u ON u.id = ru.id_user LEFT JOIN ROLES r ON r.id = ru.id_roles',
            _limit, _offset, _order_by, _where
            )
        );
    end;
$function$;
        
CREATE OR REPLACE FUNCTION tec.roles_user_get_id(
    _id int
)
RETURNS TABLE(id int, user_id int, user_name varchar, user_patronymic varchar, user_surname varchar, user_email varchar, user_active boolean, user_verified boolean, user_create_date timestamptz, roles_id int, roles_name varchar,roles_description text, roles_active boolean)
LANGUAGE plpgsql
AS $function$
    BEGIN   
        return query SELECT ru.id AS id, u.id AS user_id, u."name" AS user_name, u.patronymic AS user_patronymic, u.surname AS user_surname, u.email AS user_email, u.active AS user_active, u.verified AS user_verified, u.create_date AS user_create_date, r.id AS roles_id, r."name" AS roles_name, r.description AS roles_description, r.active AS roles_active FROM tec.roles_user ru LEFT JOIN "user" u ON u.id = ru.id_user LEFT JOIN ROLES r ON r.id = ru.id_roles where ru.id = _id;
    end;
$function$;
/** Fucntion GET  */
        
/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.roles_user_check_id(_id int)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec.roles_user where "id" = _id);
    END;
$function$;
/** Fucntion CHECK  */

/** Fucntion DELETE  */
CREATE OR REPLACE FUNCTION tec.roles_user_delete(
    _id int,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN   
	    if(select * from tec.roles_user_check_id(_id)) then
	   		DELETE FROM tec.roles_user  where id = _id RETURNING id INTO id_; 	
	    else
	    	select * into error  from tec.error_get_id(15);   
	    end if;
     end;
$function$;
/** Fucntion DELETE  */

/** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION tec.roles_user_update_id(
    _id int,
    _id_user integer, 
    _id_roles integer,
    out id_ int,
    out error tec.error
)
LANGUAGE plpgsql
AS $function$
declare
    check_user boolean;
    check_roles boolean;
   
    BEGIN   
	    if(select * from tec.roles_user_check_id(_id)) then
		    check_user := (select * from tec.user_check_id(_id_user));
	        check_roles := (select * from tec.roles_check_id(_id_roles));
	        if check_user <> true and check_roles <> true then
	            select * into error  from tec.error_get_id(16);
	        elseif check_user <> true then 
	            select * into error  from tec.error_get_id(8);
	        elseif check_roles <> true then 
	            select * into error  from tec.error_get_id(12);
		   	else
		   		UPDATE tec.roles_user
	            SET 
	                id_user = _id_user, 
	                id_roles = _id_roles
	            where id = _id RETURNING id INTO id_;
	        end if;
	    else
		   	select * into error  from tec.error_get_id(15);   
	    end if;
     end;
$function$;
/** Fucntion UPDATE  */

-- select * from tec.roles_user_save(1,1);
-- select * from tec.roles_user_update_id(1,1,1);
-- select * from tec.roles_user_check_id(1);
-- select * from tec.roles_user_get();
-- select * from tec.roles_user_get_id(1);
-- select * from tec.roles_user_delete(1);
