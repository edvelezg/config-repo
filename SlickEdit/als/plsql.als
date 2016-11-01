table(name "table name?" table1
      )
 CREATE TABLE %(NAME) (
 id INTEGER NOT NULL,
 description VARCHAR(50) NOT NULL,%\c
 active_yn CHAR(1) CONSTRAINT %(NAME)_active CHECK (active_yn IN (‘Y’, ‘N’))
 );
 ALTER TABLE %(NAME) ADD CONSTRAINT %(NAME)_pk
 PRIMARY KEY (id);
 %\c
