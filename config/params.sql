CREATE TABLE config."params"(
   id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   name varchar NOT NULL,
   description text NULL,
   "select" text NULL,
   id_type int NULL,
   CONSTRAINT params_pk PRIMARY KEY (id),
   CONSTRAINT params_fk FOREIGN KEY (id_type) REFERENCES handbook.type_params(id)
);
CREATE OR REPLACE FUNCTION config.params_get(
   _limit integer DEFAULT NULL::integer,
   _offset integer DEFAULT NULL::integer,
   _where text DEFAULT NULL::text,
   _order_by text DEFAULT NULL::text
)
RETURNS SETOF config.params
LANGUAGE plpgsql
AS $function$
   BEGIN
   return query EXECUTE (select * from  tec.table_get('select * from config.params', _limit, _offset, _order_by, _where));
   END;
$function$;

CREATE OR REPLACE FUNCTION config.params_get_id(
   _id int
)
RETURNS SETOF config.params
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query select * from config.params where id = _id;  
   END;
$function$;

CREATE OR REPLACE FUNCTION config.params_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.params where "id" = _id);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.params_save(
   _name varchar,
   _description text,
   _select text,
   _id_type text,
   out id_ int, 
   OUT error_  json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
       if (select * from handbook.type_params_check_id(_id_type)) <> true then 
           select * into error_ from tec.error_get_id(29);
           return;
       end if;
       INSERT INTO config.params
           (name,description,"select",id_type)
           VALUES  (_name,_description,_select,_id_type)
           RETURNING id INTO id_; 
   END;
$function$;

CREATE OR REPLACE FUNCTION config.params_delete(
   _id int,
   out id_ int, 
   OUT error_  json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.params_check_id(_id)) then 
           DELETE FROM config.params  where id = _id RETURNING id INTO id_;
      else
      select * from tec.errors_get_id(30);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.params_update(
   _name varchar,
   _description text,
   _select text,
   _id_type text,
   out id_ int, 
   OUT error_  json
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.params_check_id) then 
           select * into error_ from tec.error_get_id(30);
           return;
      end if;
     if (select * from handbook.type_params_check_id(_id_type)) <> true then 
         select * into error_ from tec.error_get_id(29);
         return;
     end if;
       UPDATE  config.params SET
        name = _name,
        description = _description,
        "select" = _select,
        id_type = _id_type
       RETURNING id INTO id_; 
   END;
$function$;
