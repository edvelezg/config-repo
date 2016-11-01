-- $$Id$
-- $copyright$
-- $username$
-- $localdate$

CREATE OR REPLACE PACKAGE pkg_$itemname$ AS
  -- add members here ...

  PROCEDURE test;

END;
/

GRANT EXECUTE ON pkg_$itemname$ TO $granted_user$;

