CREATE TABLE config."proekt"(
   "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   "name" varchar NOT NULL,
   "description" text NULL,
   "icons" varchar,
   "active" boolean DEFAULT true,
   "date_create" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT proekt_pk PRIMARY KEY (id)
);
CREATE OR REPLACE FUNCTION config.proekt_get(
   _limit integer DEFAULT NULL::integer,
   _offset integer DEFAULT NULL::integer,
   _where text DEFAULT NULL::text,
   _order_by text DEFAULT NULL::text
)
RETURNS SETOF config.proekt
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query EXECUTE (select * from  tec.table_get('select * from config.proekt', _limit, _offset, _order_by, _where));
   END;
$function$;

CREATE OR REPLACE FUNCTION config.proekt_get_id(
   _id int
)
RETURNS SETOF config.proekt
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query select * from config.proekt where id = _id;  
   END;
$function$;

CREATE OR REPLACE FUNCTION config.proekt_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.proekt where "id" = _id);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.proekt_save(
   _name varchar,
   _description text,
   _icons varchar,
   out id_ int, 
   OUT error_  json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
       INSERT INTO config.proekt
           ("name","description","icons")
           VALUES  (_name,_description,_icons)
           RETURNING id INTO id_; 
   END;
$function$;

CREATE OR REPLACE FUNCTION config.proekt_delete(
   _id int,
   out id_ int, 
   OUT error_  json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.proekt_check_id(_id)) then 
           DELETE FROM config.proekt  where id = _id RETURNING id INTO id_;
      else
      select * into error_ from tec.error_get_id(22);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.proekt_update(
   _id int, 
   _name varchar,
   _description text,
   _icons varchar,
   out id_ int, 
   OUT error_  json
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.proekt_check_id(_id)) then 
           select * into error_ from tec.error_get_id(22);
           return;
      end if;
       UPDATE  config.proekt SET
        "name" = _name,
        "description" = _description,
        "icons" = _icons
       RETURNING id INTO id_; 
   END;
$function$;
