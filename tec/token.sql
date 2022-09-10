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
CREATE OR REPLACE FUNCTION tec.token_get_id(token_ varchar)
    RETURNS TABLE(roles json, "right" json, "user" json)
	LANGUAGE plpgsql

AS $function$
    BEGIN
       return query select  
  json_agg(
	json_build_object(
		'id', r.id
	)
  )
 as roles,
   json_agg(
   	json_build_object(
		'id', rig.id
	)
   )  as "right",
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
where t.value = token_
group by u.id;
    END;
$function$;
/** Fucntion GET  */