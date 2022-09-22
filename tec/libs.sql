 
CREATE OR REPLACE FUNCTION tec.right_user_check (
	token_ varchar,
	id_ int,
	id_error int default 20,
	OUT error_  json
)

 LANGUAGE plpgsql
 AS $function$
declare 
	result_ tec.authentication_result;
 begin 
	 	select * into result_ from tec.token_authentication(token_);
	 if result_."error_" is not null then
	 	error_ :=  result_.error_;
	 elseif (select * from tec.right_check( (result_.user_)."right", id_)) <> true then
	 	select * into error_  from tec.error_get_id(id_error);
	 end if;
 	end;
 $function$;
 


 