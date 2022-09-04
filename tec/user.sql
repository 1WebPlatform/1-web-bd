/** Create table */
CREATE TABLE tec."user" (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	"patronymic" varchar NOT NULL,
    "surname" varchar NOT NULL,
    "email" varchar NOT NULL,
    "password" varchar NOT NULL,
    "active" boolean DEFAULT true,
    "verified" boolean DEFAULT false,
    "create_date" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_pk PRIMARY KEY (id)
);
/** Create table */
CREATE UNIQUE INDEX user_email_idx ON tec."user" USING btree (email);

/** Column comments*/
COMMENT ON COLUMN tec."user".id IS 'Первичный ключ';
COMMENT ON COLUMN tec."user"."name" IS 'Имя пользователя';
COMMENT ON COLUMN tec."user".surname IS 'Фамилия  пользователя';
COMMENT ON COLUMN tec."user".patronymic IS 'Отчество пользователя';
COMMENT ON COLUMN tec."user".email IS 'Почта пользователя';
COMMENT ON COLUMN tec."user".active IS 'Активность пользователя';
COMMENT ON COLUMN tec."user".verified IS 'Подверждение почты пользователя';
COMMENT ON COLUMN tec."user".create_date IS 'Дата создания пользователя';
/** Column comments*/

CREATE TYPE tec.type_user_get AS (
    id int, 
    name varchar,
    patronymic varchar,
    surname varchar,
    email varchar,
    active boolean,
    verified  boolean,
    create_date timestamp WITH TIME ZONE
);


/** Fucntion */
/** Fucntion GET  */
CREATE OR REPLACE FUNCTION tec.user_get(
    _limit int DEFAULT NULL::integer,
    _offset int DEFAULT NULL::integer,
    _where varchar DEFAULT NULL::integer,
    _order_by varchar DEFAULT NULL::integer
)
	RETURNS SETOF tec.type_user_get
	LANGUAGE plpgsql
AS $function$
	BEGIN
        return query EXECUTE (select * from tec.table_get('select id, name, surname,patronymic, email,active,verified, create_date from tec."user" ', _limit, _offset, _order_by, _where));
	END;
$function$;

CREATE OR REPLACE FUNCTION tec.user_get_id(
    _id int
)
	RETURNS SETOF tec.type_user_get
	LANGUAGE plpgsql
AS $function$
	BEGIN
        return query select id, name, surname,patronymic, email,active,verified, create_date from tec."user" where id = _id;
	END;
$function$;
/** Fucntion GET  */
 
/** Fucntion CHECK  */
CREATE OR REPLACE FUNCTION tec.user_check_id(_id int)
    RETURNS boolean
    LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec."user" where "id" = _id);
    END;
$function$;

CREATE OR REPLACE FUNCTION tec.user_check_email(_email varchar)
    RETURNS boolean
    LANGUAGE plpgsql
AS $function$
    BEGIN
        return EXISTS (select * from tec."user" where "email" = _email);
    END;
$function$;
/** Fucntion CHECK  */

 /** Fucntion SAVE  */
CREATE OR REPLACE FUNCTION tec.user_save(
    _name varchar, 
    _patronymic varchar,
    _surname varchar,
    _email varchar,
    _password varchar,
    OUT id_ int,
    OUT error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN
    IF (select * from tec.user_check_email(_email)) <> true then
    INSERT INTO tec.user
      ("name", "patronymic", "surname", "email", "password")
        VALUES (_name, _patronymic,_surname, _email, lib.crypt(_password::TEXT, lib.gen_salt('bf'::TEXT))) 
        RETURNING id INTO id_;
ELSE 
    select * into error from tec.error_get_id(7);		
END IF;	
    END;
$function$;
/** Fucntion SAVE  */

 /** Fucntion UPDATE  */
CREATE OR REPLACE FUNCTION tec.user_update_id(
    _id int, 
    _name varchar, 
    _patronymic varchar,
    _surname varchar,
    _password varchar,
    OUT id_ int,
    OUT error tec.error
)
LANGUAGE plpgsql
AS $function$
    BEGIN
        IF (select * from tec.user_check_id(_id)) then
            UPDATE tec.user 
            SET 
                name = _name, 
                patronymic = _patronymic, 
                surname = _surname, 
                password = _password
                where id = _id 
                RETURNING id INTO id_;
        ELSE 
            select * into error from tec.error_get_id(8);		
        END IF;	
    END;
$function$;
/** Fucntion UPDATE  */
/** Fucntion */

/** Start Fucntion */
select * from tec.user_save('1', '1','1', '1', '4');
select * from tec.user_update_id(1, '1', '1','1', '4'); 
select * from tec.user_get_id(1);
select * from tec.user_get(1,1);
select * from tec.user_check_id(1);
select * from tec.user_check_email('1');
/** Start Fucntion */