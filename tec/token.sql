/** Create table */
CREATE TABLE tec.token (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"value" varchar NOT NULL,
    active boolean DEFAULT true,
    create_date timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "lifetime" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP + interval '5 hour',
     id_user int4 NOT NULL,
    CONSTRAINT token_pk PRIMARY KEY (id),
    CONSTRAINT token_pk_fk FOREIGN KEY (id_user) REFERENCES tec.user(id)
);

 create type user_check as (active boolean, verified boolean);
 create type user_dataset as ("token" json, roles json, "right" json, "user" json);


/** Fucntion */
/** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.token_save(
	_email varchar,
	_password varchar,
	_id_user int,
	out	token_ varchar 
)
    LANGUAGE plpgsql
AS $function$
    BEGIN
        insert into tec."token" 
        	("value", "id_user")
        	values (
        		lib.crypt(concat(_password::text ||  CURRENT_TIMESTAMP::text || _email::text ), lib.gen_salt('bf'::TEXT)),
        		_id_user
        		)
        	RETURNING "token".value INTO token_;
    END;
$function$;
/** Fucntion SAVE  */

/** Fucntion GET  */
 
CREATE OR REPLACE FUNCTION tec.token_get_id(
	_token varchar)
    returns SETOF tec.user_dataset
	LANGUAGE plpgsql

AS $function$
    BEGIN
       return query select  
	   json_build_object(
		'value', t.value,
		'active', t.active,
		'lifetime', t.lifetime
	   ) as "token",
 
  json_agg(r.id) as roles,
   json_agg(rig.id)  as "right",
	json_build_object(
		'id', u.id,
		'name', u."name",
		'patronymic', u.patronymic,
		'surname', u.surname,
		'email', u.email ,
		'active', u.active ,
		'verified', u.verified,
		'create_date', u.create_date
	)  as "user"
from  tec."token" t 
left join "user" u ON u.id  = t.id_user 
left join "roles_user" r_u on r_u.id_user  = u.id 
left join "roles" r on r.id  = r_u.id_roles 
left join "right_roles" r_r on r_r.id  = r.id 
left join "right" rig on rig.id  = r_r.id_right 
where t.value = _token
group by u.id, t.value, t.active, t.lifetime;
    END;
$function$;
/** Fucntion GET  */


/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.token_check(_token varchar)
    RETURNS boolean
	LANGUAGE plpgsql

AS $function$
    BEGIN
       return EXISTS (select * from tec."token" t where t.value = _token and t.active = true and t.lifetime > CURRENT_TIMESTAMP); 
    END;
$function$; 

CREATE OR REPLACE FUNCTION tec.token_check_user(
	_token varchar,
	out error_ tec.error
)
	LANGUAGE plpgsql

AS $function$
declare
	user_check_ tec.user_check%ROWTYPE;
    BEGIN
      select u.active , u.verified into user_check_
		from tec."token" t
		left join "user" u ON u.id  = t.id_user 
		where t.value  = _token;
	
    	if user_check_.active <> true then
    		select * into error_ from tec.error_get_id(19);
    	elseif user_check_.verified <> true then
    		select * into error_ from tec.error_get_id(18);
    	end if;
	END;
$function$; 

create or replace function tec.authentication(
	_token text,
	out error_ tec.error,
	out user_ tec.user_dataset
	)
 	LANGUAGE plpgsql
AS $function$
	begin
	 select * from tec.token_get_id(_token) into user_;
	 select * into error_ from tec.authentication_check(
	 	((user_.token) ->> 'active')::boolean,
	 	((user_.token) ->> 'lifetime')::timestamp, 
		((user_.user) ->> 'active')::boolean,
		((user_.user) ->> 'verified')::boolean
	);
	if error_.id IS NOT NULL then
		user_ := null;
	end if;
	END
$function$;
/** Fucntion CHECK  */

create or replace function tec.authentication_check(
	_active_token boolean, 
	_date_token timestamp,
	_active_user boolean,
	_verified_user boolean,
	out error_ tec.error
)
 	LANGUAGE plpgsql

AS $function$
	begin
		if _active_token <> true or _date_token < CURRENT_TIMESTAMP then
			select * into error_ from tec.error_get_id(17);
		elseif _active_user <> true then
    		select * into error_ from tec.error_get_id(19);
    	elseif _verified_user <> true then
    		select * into error_ from tec.error_get_id(18);
    	end if;
	END
$function$; 
/** Fucntion */
/** Fucntion */