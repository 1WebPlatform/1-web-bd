CREATE TABLE config."component"(
   "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
   "name" varchar NOT NULL,
   "description" text NULL,
   "css" text NULL,
   "params" text NULL,
   "schema" text NULL,
   "event" text NULL,
   "id_right" int NULL,
   "id_type" int NOT NULL,
   "id_parent" int NULL,
   CONSTRAINT component_pk PRIMARY KEY (id),
   CONSTRAINT component_fk FOREIGN KEY (id_right) REFERENCES tec.right(id),
   CONSTRAINT component_fk_1 FOREIGN KEY (id_type) REFERENCES handbook.type_component(id)
);
CREATE OR REPLACE FUNCTION config.component_get(
   _limit integer DEFAULT NULL::integer,
   _offset integer DEFAULT NULL::integer,
   _where text DEFAULT NULL::text,
   _order_by text DEFAULT NULL::text
)
RETURNS SETOF config.component
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query EXECUTE (select * from  tec.table_get('select * from config.component', _limit, _offset, _order_by, _where));
   END;
$function$;

CREATE OR REPLACE FUNCTION config.component_get_id(
   _id int
)
RETURNS SETOF config.component
LANGUAGE plpgsql
AS $function$
   BEGIN
       return query select * from config.component where id = _id;  
   END;
$function$;

CREATE OR REPLACE FUNCTION config.component_check_id(
   _id int
)
RETURNS boolean 
LANGUAGE plpgsql
AS $function$
   BEGIN
      return EXISTS (select * from config.component where "id" = _id);
   END;
$function$;


CREATE OR REPLACE FUNCTION config.component_select_css_get_id(_id integer)
 RETURNS table (id int,name varchar, css text)
 LANGUAGE plpgsql
AS $function$
   BEGIN
      return query 
         select c.id, t_c."name", c.css
         from config.component c  
         left join handbook.type_component t_c on t_c.id = c.id_type  
         where c.id = _id;  
  
   END;
$function$;



CREATE OR REPLACE FUNCTION config.component_save(
   _name varchar,
   _description text,
   _css text,
   _params text,
   _schema text,
   _event text,
   _id_right int,
   _id_type int,
   _id_parent int,
   out id_ int, 
   OUT error_  json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
       if (select * from tec.right_check_id(_id_right)) <> true then 
           select * into error_ from tec.error_get_id(10);
           return;
       end if;
       if (select * from handbook.type_component_check_id(_id_type)) <> true then 
           select * into error_ from tec.error_get_id(26);
           return;
       end if;
       if (select * from config.component_check_id(_id_parent)) <> true then 
           select * into error_ from tec.error_get_id(25);
           return;
       end if;
       INSERT INTO config.component
           ("name","description","css","params","schema","event","id_right","id_type","id_parent")
           VALUES  (_name,_description,_css,_params,_schema,_event,_id_right,_id_type,_id_parent)
           RETURNING id INTO id_; 
   END;
$function$;

CREATE OR REPLACE FUNCTION config.component_delete(
   _id int,
   out id_ int, 
   OUT error_  json 
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.component_check_id(_id)) then 
           DELETE FROM config.component  where id = _id RETURNING id INTO id_;
      else
      select * into error_ from tec.error_get_id(25);
      end if;
   END;
$function$;

CREATE OR REPLACE FUNCTION config.component_update(
   _id int, 
   _name varchar,
   _description text,
   _css text,
   _params text,
   _schema text,
   _event text,
   _id_right int,
   _id_type int,
   _id_parent int,
   out id_ int, 
   OUT error_  json
)
LANGUAGE plpgsql
AS $function$
   BEGIN
      if (select * from config.component_check_id(_id)) then 
           select * into error_ from tec.error_get_id(25);
           return;
      end if;
     if (select * from tec.right_check_id(_id_right)) <> true then 
         select * into error_ from tec.error_get_id(10);
         return;
     end if;
     if (select * from handbook.type_component_check_id(_id_type)) <> true then 
         select * into error_ from tec.error_get_id(26);
         return;
     end if;
     if (select * from config.component_check_id(_id_parent)) <> true then 
         select * into error_ from tec.error_get_id(25);
         return;
     end if;
       UPDATE  config.component SET
        "name" = _name,
        "description" = _description,
        "css" = _css,
        "params" = _params,
        "schema" = _schema,
        "event" = _event,
        "id_right" = _id_right,
        "id_type" = _id_type,
        "id_parent" = _id_parent
       RETURNING id INTO id_; 
   END;
$function$;
