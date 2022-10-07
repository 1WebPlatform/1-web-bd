CREATE TABLE config."css_tempale"(
   "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   "css" text NULL,
   "id_type" int NOT NULL,
   CONSTRAINT css_tempale_pk PRIMARY KEY (id),
   CONSTRAINT css_tempale_fk FOREIGN KEY (id_type) REFERENCES handbook.type_component(id)
);

CREATE OR REPLACE FUNCTION config.css_tempale_get(
   _limit integer DEFAULT NULL::integer,
   _offset integer DEFAULT NULL::integer,
   _where text DEFAULT NULL::text,
   _order_by text DEFAULT NULL::text
)
RETURNS SETOF config.css_tempale
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query EXECUTE (select * from  tec.table_get('select * from config.css_tempale', _limit, _offset, _order_by, _where));
   END;
$function$;

CREATE OR REPLACE FUNCTION config.css_tempale_get_id(
   _id int
)
RETURNS TABLE(id int, name varchar, css text)
LANGUAGE plpgsql
AS $function$
   BEGIN
      return query 
         select c_t.id, t_c."name", c_t.css  
         from config.css_tempale  c_t
         left join handbook.type_component t_c on t_c.id = c_t.id_type
         where c_t.id = _id;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.css_tempale_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.css_tempale where "id" = _id);
   END;
$function$;

CREATE OR REPLACE FUNCTION config.css_tempale_save(
   _css text,
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
       INSERT INTO config.css_tempale
           ("css","id_type")
           VALUES  (_css,_id_type)
           RETURNING id INTO id_; 
   END;
$function$;

CREATE OR REPLACE FUNCTION config.css_tempale_delete(
   _id int,
   out id_ int, 
   out error_ json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.css_tempale_check_id(_id)) then 
           DELETE FROM config.css_tempale  where id = _id RETURNING id INTO id_;
      else
      select * into error_ from tec.error_get_id(36);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.css_tempale_update(
   _id int, 
   _css text,
   _id_type int,
   out id_ int, 
   out error_ json
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.css_tempale_check_id(_id)) then 
           select * into error_ from tec.error_get_id(36);
           return;
      end if;
     if (select * from handbook.type_component_check_id(_id_type)) <> true then 
         select * into error_ from tec.error_get_id(26);
         return;
     end if;
       UPDATE  config.css_tempale SET
        "css" = _css,
        "id_type" = _id_type
       RETURNING id INTO id_; 
   END;
$function$;
