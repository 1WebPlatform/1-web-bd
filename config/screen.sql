CREATE TABLE config."screen"(
   "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   "name" varchar NOT NULL,
   "description" text NULL,
   "title" varchar,
   "url" varchar,
   "icons" varchar,
   "active" boolean DEFAULT true,
   "id_right" int NULL,
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

CREATE OR REPLACE FUNCTION config.screen_get_id_component(
   _id int
)
RETURNS TABLE(screen json)
LANGUAGE plpgsql
AS $function$
   BEGIN
   return query select json_build_object(
	   'screen', s.*,
	   'component', c.*
   ) as screen
   from config.screen s 
   left join config.screen_component sc on sc.id_screen = s.id 
   left join config.component c on c.id = sc.id_component
   where s.id  = _id;
      END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return  
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
           select * into error_ from tec.error_get_id(10);
           return;
       end if;
       INSERT INTO config.screen
           ("name","description","title","url","icons","id_right")
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
      if (select * from config.screen_check_id(_id)) then 
           DELETE FROM config.screen  where id = _id RETURNING id INTO id_;
      else
      select * into error_ from tec.error_get_id(21);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.screen_update(
   _id int, 
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
      if (select * from config.screen_check_id(_id)) then 
           select * into error_ from tec.error_get_id(21);
           return;
      end if;
     if (select * from tec.right_check_id(_id_right)) <> true then 
         select * into error_ from tec.error_get_id(10);
         return;
     end if;
       UPDATE  config.screen SET
        "name" = _name,
        "description" = _description,
        "title" = _title,
        "url" = _url,
        "icons" = _icons,
        "id_right" = _id_right
       RETURNING id INTO id_; 
   END;
$function$;
