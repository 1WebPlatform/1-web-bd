CREATE TABLE config."screen"(
   id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   name varchar NOT NULL,
   description text NULL,
   title varchar,
   url varchar,
   icons varchar,
   active boolean DEFAULT true,
   id_right int NULL,
   CONSTRAINT screen_fk FOREIGN KEY (id_right) REFERENCES tec.right(id),
   CONSTRAINT screen_pk PRIMARY KEY (id)
);
CREATE OR REPLACE FUNCTION config.screen_get(
   _limit integer DEFAULT NULL::integer,
   _offset integer DEFAULT NULL::integer,
   _where text DEFAULT NULL::text,
   _order_by text DEFAULT NULL::text
)
RETURNS SETOF config.screen
LANGUAGE plpgsql
AS $function$
   BEGIN
   return query EXECUTE (select * from  tec.table_get('select * from config.screen', _limit, _offset, _order_by, _where));
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_get_id(
   _id int
)
RETURNS SETOF config.screen
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query select * from config.screen where id = _id;  
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.screen where "id" = _id);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_check_right(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from tec.right where "id_right" = _id);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_save(
   _name varchar,
   _description text,
   _title varchar,
   _url varchar,
   _icons varchar,
   _id_right int,
   out id_ int, 
   out error_ tec.error 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
       if (select * from tec.right_check_id(_id_right)) <> true then 
           select * into error_ from tec.error_get_id(12);
           return;
       end if;
       INSERT INTO config.screen
           (name,description,title,url,icons,id_right)
           VALUES  (_name,_description,_title,_url,_icons,_id_right)
           RETURNING id INTO id_; 
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_delete(
   _id int,
   out id_ int, 
   out error_ tec.error 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.screen_check_id) then 
           DELETE FROM config.screen  where id = _id RETURNING id INTO id_;
      else
      select * from tec.errors_get_id(21);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_update(
   _name varchar,
   _description text,
   _title varchar,
   _url varchar,
   _icons varchar,
   _id_right int,
   out id_ int, 
   out error_ tec.error
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.screen_check_id) then 
           select * into error_ from tec.error_get_id(21);
           return;
      end if;
     if (select * from tec.right_check_id(_id_right)) <> true then 
         select * into error_ from tec.error_get_id(12);
         return;
     end if;
       UPDATE  config.screen SET
        name = _name,
        description = _description,
        title = _title,
        url = _url,
        icons = _icons,
        id_right = _id_right
       RETURNING id INTO id_; 
   END;
$function$;
