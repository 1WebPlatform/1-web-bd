CREATE SCHEMA tec;

 create type tec.user_dataset as ("token" json, roles int[], "right" int[], "user" json);
  create type tec.authentication_result as ("user_" tec.user_dataset, error_ tec.error);

CREATE OR REPLACE FUNCTION tec.table_get(
    _sql character varying, 
    _limit integer DEFAULT NULL::integer, 
    _offset integer DEFAULT NULL::integer, 
    _order_by character varying DEFAULT NULL::character varying, 
    _where text DEFAULT NULL::text
    )
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
    sql varchar;
begin
    sql := _sql;
    IF _where  IS NOT NULL THEN 
        IF (select position('where' in sql)) > 0 THEN
          sql := concat(sql || ' and ' || _where);
        ELSE
            sql := concat(sql || ' where ' || _where); END IF;
        END IF;
    IF _order_by  IS NOT NULL THEN sql := concat(sql || ' order by ' || _order_by); END IF;
    IF _limit  IS NOT NULL THEN sql := concat(sql || ' limit ' || _limit); END IF;
    IF _offset  IS NOT NULL THEN sql := concat(sql || ' offset ' || _offset); END IF;
    return sql;
END;
$function$;

CREATE OR REPLACE FUNCTION tec.right_check (
	ids_ int[],
	id_ int
)
 RETURNS  boolean
 LANGUAGE plpgsql
 AS $function$
 	begin 
 		return lib.idx(ids_, id_) <> 0;
 	end;
 $function$;


CREATE OR REPLACE FUNCTION tec.right_user_check (
	token_ varchar,
	id_ int,
	id_error int default 20,
	out error_ tec.error
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
 


CREATE OR REPLACE FUNCTION tec.get_function(
    _limit integer DEFAULT NULL::integer, 
    _offset integer DEFAULT NULL::integer, 
    _order_by character varying DEFAULT NULL::character varying, 
    _where text DEFAULT NULL::text
)
 RETURNS TABLE(name information_schema.sql_identifier , schema information_schema.sql_identifier )
 LANGUAGE plpgsql
AS $function$
    begin 
        return query EXECUTE (select * from tec.table_get(
            ' SELECT routine_name  as "name", specific_schema  as "schema" FROM information_schema.routines 
                WHERE routine_type=''FUNCTION'' AND specific_schema <> ''lib'' AND specific_schema <> ''pg_catalog'' AND specific_schema <> ''information_schema''',
            _limit, _offset, _order_by, _where)    
        );
    end;
$function$;