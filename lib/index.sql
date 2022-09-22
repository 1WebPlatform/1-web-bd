CREATE SCHEMA lib;
-- Extension: plpgsql

-- DROP EXTENSION plpgsql;

CREATE EXTENSION plpgsql
	SCHEMA "pg_catalog"
	VERSION 1.0;

-- Extension: adminpack

-- DROP EXTENSION adminpack;

CREATE EXTENSION adminpack
	SCHEMA "pg_catalog"
	VERSION 2.1;

-- Extension: pgcrypto

-- DROP EXTENSION pgcrypto;

CREATE EXTENSION pgcrypto
	SCHEMA "lib"
	VERSION 1.3;

-- Extension: intarray

-- DROP EXTENSION intarray;

CREATE EXTENSION intarray
	SCHEMA "lib"
	VERSION 1.5;
