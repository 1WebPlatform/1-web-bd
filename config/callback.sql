CREATE TABLE config."callback"(
   "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   "name" varchar NOT NULL,
   "description" text NULL,
   "params" json NULL,
   "id_type" int NULL,
   CONSTRAINT callback_fk FOREIGN KEY (id_type) REFERENCES handbook.type_component(id),
   CONSTRAINT callback_pk PRIMARY KEY (id)
);
CREATE UNIQUE INDEX callback_name_idx ON config.callback USING btree (name); 

CREATE OR REPLACE FUNCTION config.callback_get(
   _limit integer DEFAULT NULL::integer,
   _offset integer DEFAULT NULL::integer,
   _where text DEFAULT NULL::text,
   _order_by text DEFAULT NULL::text
)
RETURNS SETOF config.callback
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query EXECUTE (select * from  tec.table_get('select * from config.callback', _limit, _offset, _order_by, _where));
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_get_id(
   _id int
)
RETURNS SETOF config.callback
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query select * from config.callback where id = _id;  
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.callback where "id" = _id);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_check_name(
   _name varchar
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.callback where "name" = _name);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_check_update_name(
   _id int,
   _name varchar
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.callback where "id" != _id and "name" = _name);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_save(
   _name varchar,
   _description text,
   _params json,
   _id_type int,
   out id_ int, 
   out error_ json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
       if (select * from handbook.type_component_check_id(_id_type)) <> true then 
           select * into error_ from tec.error_get_id(26);
           return;
       end if;
       if (select * from config.callback_check_name(_name)) <> true then 
           select * into error_ from tec.error_get_id(34);
           return;
       end if;
       INSERT INTO config.callback
           ("name","description","params","id_type")
           VALUES  (_name,_description,_params,_id_type)
           RETURNING id INTO id_; 
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_delete(
   _id int,
   out id_ int, 
   out error_ json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.callback_check_id(_id)) then 
           DELETE FROM config.callback  where id = _id RETURNING id INTO id_;
      else
      select * into error_ from tec.error_get_id(35);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.callback_update(
   _id int, 
   _name varchar,
   _description text,
   _params json,
   _id_type int,
   out id_ int, 
   out error_ json
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.callback_check_id(_id)) then 
           select * into error_ from tec.error_get_id(35);
           return;
      end if;
     if (select * from handbook.type_component_check_id(_id_type)) <> true then 
         select * into error_ from tec.error_get_id(26);
         return;
     end if;
       if (select * from config.callback_check_update_name(_id, _name)) <> true then 
           select * into error_ from tec.error_get_id(34);
           return;
       end if;
       UPDATE  config.callback SET
        "name" = _name,
        "description" = _description,
        "params" = _params,
        "id_type" = _id_type
       RETURNING id INTO id_; 
   END;
$function$;
