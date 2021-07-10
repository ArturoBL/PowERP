--Procedure: POW_CHANGEPARAM

--DROP PROCEDURE POW_CHANGEPARAM;

SET TERM ^ ;

RECREATE PROCEDURE POW_CHANGEPARAM (
 PFORMNAME   VARCHAR(15),
 PPARAMNAME  VARCHAR(30),
 PPARAMVALUE VARCHAR(40))
AS 
DECLARE  N  integer;
DECLARE  IDF  integer;
BEGIN
  select id_form
    from pow_forms
   where form_name = :PFORMNAME
    into :idf;
  
  if (:idf > 0) then
  BEGIN
    select count(*)
      from pow_params
     where id_form = :idf
       and param_name = :pparamname
      into :n;
    if (:n > 0) then
    BEGIN
      update pow_params
         set param_value = :pparamvalue
       where id_form = :idf
         and param_name = :pparamname;
    end
    else
      insert into pow_params(param_name, param_value, id_form) values(:pparamname, :pparamvalue, :idf);
  END   
  /*insert into pow_params(param_name, param_value, id_form) values('xyz', '123', 2);*/ 
END^


RECREATE PROCEDURE POW_GETPARAM (
 PFORMNAME   VARCHAR(15),
 PPARAMNAME  VARCHAR(30))
RETURNS (
 PPARAMVALUE VARCHAR(40))
AS 
DECLARE IDF  INTEGER;
DECLARE pval VARCHAR(40);
declare n integer;
BEGIN
  SELECT ID_FORM
    FROM POW_FORMS
   WHERE FORM_NAME = :pFormName
    into :idf;
  
  if (:idf > 0) then 
  BEGIN
    select param_value
      from pow_params
     where id_form = :idf
       and param_name = :pparamname
      into :pparamvalue;    
  END
END^


CREATE TRIGGER POF_BI FOR POW_FORMS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE NID INTEGER;
BEGIN  
  IF (NEW.ID_FORM IS NULL) THEN
  BEGIN
    SELECT COALESCE(MAX(ID_FORM),0)+1
      FROM POW_FORMS
      INTO :NID;
    NEW.ID_FORM = NID;
  END
END^


CREATE TRIGGER POP_BI FOR POW_PARAMS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE NID INTEGER;
BEGIN  
  IF (NEW.ID_PARAM IS NULL) THEN
  BEGIN
    SELECT COALESCE(MAX(ID_PARAM),0)+1
      FROM POW_PARAMS
      INTO :NID;
    NEW.ID_PARAM = NID;
  END
END^


CREATE TRIGGER POT_BI FOR POW_TABS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE NID INTEGER;
BEGIN  
  IF (NEW.ID_TAB IS NULL) THEN
  BEGIN
    SELECT COALESCE(MAX(ID_TAB),0)+1
      FROM POW_TABS
      INTO :NID;
    NEW.ID_TAB = NID;
  END  /* Trigger text */
END^




SET TERM ; ^