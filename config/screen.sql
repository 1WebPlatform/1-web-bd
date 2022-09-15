/** Create table */
CREATE TABLE config."screen" (
    id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "name" varchar NOT NULL,
    description text NULL,
    title varchar,
    url varchar,
    icons - varchar,
    active boolean DEFAULT true,
    id_right int,
    CONSTRAINT screen_fk FOREIGN KEY (id_right) REFERENCES tec.right(id),
    CONSTRAINT screen_pk PRIMARY KEY (id)
);
