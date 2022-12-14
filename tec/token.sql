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

 create type tec.user_check as (active boolean, verified boolean);
 create type tec.user_authorization as (id int ,active boolean, verified boolean);

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
create or replace function tec.token_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
	returns  TABLE(
		id int,
		"name" varchar, 
		patronymic varchar, 
		surname varchar, 
		email varchar, 
		"password" varchar, 
		active boolean, 
		verified boolean, 
		create_date timestamptz,  
		token_id int, 
		token_value varchar, 
		token_active boolean,
		token_create_date timestamptz,
		token_lifetime timestamptz
		
	)
LANGUAGE plpgsql
AS $function$
	begin
		 return query EXECUTE (
        select * from tec.table_get('select u.*, t.id  as token_id, t.value as token_value, t.active as token_active, t.create_date as token_create_date, t.lifetime as token_lifetime from tec."token" t left join "user" u ON u.id = t.id_user ', _limit, _offset, _order_by, _where));	
	end;
$function$;   


CREATE OR REPLACE FUNCTION tec.token_get_id(
	_token varchar)
    returns SETOF tec.user_dataset
	LANGUAGE plpgsql

AS $function$
    BEGIN
       return query select  
	   json_build_object(
		'id', t.id,
		'value', t.value,
		'active', t.active,
		'lifetime', t.lifetime
	   ) as "token",
 
  array_agg(r.id)::int[] as roles,
   array_agg(rig.id)::int[]  as "right",
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
left join tec."user" u ON u.id  = t.id_user 
left join tec."roles_user" r_u on r_u.id_user  = u.id 
left join tec."roles" r on r.id  = r_u.id_roles 
left join tec."right_roles" r_r on r_r.id_roles  = r.id 
left join tec."right" rig on rig.id  = r_r.id_right 
where t.value = _token
group by u.id, t.id, t.value, t.active, t.lifetime;
    END;
$function$;
/** Fucntion GET  */


/** Fucntion CHECK  */
/** TODO ???????????????? ???? ??????????*/
CREATE OR REPLACE FUNCTION tec.token_check(_token varchar)
    RETURNS boolean
	LANGUAGE plpgsql

AS $function$
    BEGIN
       return EXISTS (select * from tec."token" t where t.value = _token and t.active = true and t.lifetime > CURRENT_TIMESTAMP); 
    END;
$function$; 


/** TODO ???????????????? ???? ??????????*/
CREATE OR REPLACE FUNCTION tec.token_check_user(
	_token varchar,
	OUT error_  json
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
 
/** Fucntion CHECK  */

/** Fucntion authentication  */
CREATE OR REPLACE FUNCTION tec.token_authentication(_token text, OUT user_ tec.user_dataset, OUT error_ json)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
	begin
	 select * from tec.token_get_id(_token) into user_;
	 select * into error_ from tec.token_authentication_check(
	 	((user_.token) ->> 'value')::varchar,
	 	((user_.token) ->> 'active')::boolean,
	 	((user_.token) ->> 'lifetime')::timestamp, 
		((user_.user) ->> 'active')::boolean,
		((user_.user) ->> 'verified')::boolean
	);
	if error_ IS NOT NULL then
		user_ := null;
	else
		PERFORM tec.token_update_time( ((user_.token) ->> 'id')::int);
	end if;
	END
$function$
;
 

 
create or replace function tec.token_authentication_check(
	_value_token varchar,
	_active_token boolean, 
	_date_token timestamp,
	_active_user boolean,
	_verified_user boolean,
	OUT error_  json
)
 	LANGUAGE plpgsql

AS $function$
	begin
		if _value_token is null or  _active_token <> true or _date_token < CURRENT_TIMESTAMP then
			select * into error_ from tec.error_get_id(17);
		elseif _active_user <> true then
    		select * into error_ from tec.error_get_id(19);
    	elseif _verified_user <> true then
    		select * into error_ from tec.error_get_id(18);
    	end if;
	END
$function$; 
/** Fucntion authentication  */

/** Fucntion update */
 create or replace function tec.token_update_time(
	_id int
)
	returns  void
 	LANGUAGE plpgsql

AS $function$
	begin
		update tec.token t
		    SET lifetime = CURRENT_TIMESTAMP + interval '5 hour'
			where t.id = _id; 	
	end;
$function$;  

 create or replace function tec.token_update_active_false(
	_id int
)
	returns  void
 	LANGUAGE plpgsql

AS $function$
	begin
		update tec.token t
		    SET active = false 
			where t.id = _id; 	
	end;
$function$;

/** Fucntion update */

/** Fucntion  authorization*/
 CREATE OR REPLACE FUNCTION tec.token_authorization(
	 _email varchar, 
	 _password varchar, 
	 OUT error_  json,
	 out token_ varchar
 )
 	LANGUAGE plpgsql
 	AS $function$
 	declare
    	user_ tec.user_authorization;
 	    begin
 	    	select u.id, u.active , u.verified  into user_
			from tec."user" u 
			where email = _email and "password" = lib.crypt(_password, u."password");
 	    	if user_.active <> true then
 	    		select * into error_ from tec.error_get(19); 
   	    	elseif user_.verified <> true then
				select * into error_ from tec.error_get_id(18);
   	    	end if;
	   	    if error_.id is null then
	   	    	select  * into token_ from tec.token_save(_email, _password, user_.id);
	   	    end if;
		end;
 	$function$;

/** Fucntion  authorization*/
/** Function */