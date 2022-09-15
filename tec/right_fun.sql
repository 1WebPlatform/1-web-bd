CREATE TABLE tec."right_fun" (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
    "schema" varchar NOT NULL,
    id_right int NOT NULL,
	CONSTRAINT right_fun_pk PRIMARY KEY (id),
    CONSTRAINT right_fun_fk FOREIGN KEY (id_right) REFERENCES tec.right(id)
);


CREATE OR REPLACE FUNCTION tec.right_fun_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
RETURNS TABLE(id int, name varchar, schema varchar, id_right int, right_name varchar)
LANGUAGE plpgsql
AS $function$
    BEGIN   
    return query EXECUTE (
        select * from tec.table_get(
           'select rf.*,r."name"  as right_name from tec.right_fun rf left join tec."right" r on r.id = rf.id_right',
            _limit, _offset, _order_by, _where
            )
        );
    end;
$function$;


CREATE OR REPLACE FUNCTION tec.right_fun_get_find(
    _schema varchar,
    _name varchar
)
RETURNS TABLE(id_right int)
LANGUAGE plpgsql
AS $function$
    begin
	  	return query select rf.id_right  from  tec.right_fun rf where rf."schema" = _schema and rf."name" = _name;    	
    end
$function$;