/*
 * ER/Studio Data Architect 10.0 SQL Code Generation
 * Project :      DATA MODEL
 *
 * Date Created : Tuesday, October 30, 2018 23:15:25
 * Target DBMS : Firebird 2.x
 */

/* 
 * TABLE: POW_FORMS 
 */

CREATE TABLE POW_FORMS(
    ID_FORM      INTEGER        NOT NULL,
    FORM_NAME    VARCHAR(20)    NOT NULL,
    CAPTION      VARCHAR(50),
    PRIMARY KEY (ID_FORM)
)
;



/* 
 * TABLE: POW_PARAMS 
 */

CREATE TABLE POW_PARAMS(
    ID_PARAM       INTEGER         NOT NULL,
    ID_FORM        INTEGER         NOT NULL,
    PARAM_NAME     VARCHAR(20)     NOT NULL,
    PARAM_VALUE    VARCHAR(100),
    PRIMARY KEY (ID_PARAM, ID_FORM)
)
;



/* 
 * TABLE: POW_TABS 
 */

CREATE TABLE POW_TABS(
    ID_TAB     INTEGER        NOT NULL,
    ID_FORM    INTEGER        NOT NULL,
    CAPTION    VARCHAR(30),
    "INDEX"    INTEGER        NOT NULL,
    PRIMARY KEY (ID_TAB, ID_FORM)
)
;



/* 
 * INDEX: POP_POF_FK 
 */

CREATE ASC INDEX POP_POF_FK ON POW_PARAMS(ID_FORM)
;
/* 
 * INDEX: POT_POF_FK 
 */

CREATE ASC INDEX POT_POF_FK ON POW_TABS(ID_FORM)
;
/* 
 * TABLE: POW_PARAMS 
 */

ALTER TABLE POW_PARAMS ADD CONSTRAINT POP_POF_FK 
    FOREIGN KEY (ID_FORM)
    REFERENCES POW_FORMS(ID_FORM)
;


/* 
 * TABLE: POW_TABS 
 */

ALTER TABLE POW_TABS ADD CONSTRAINT POT_POF_FK 
    FOREIGN KEY (ID_FORM)
    REFERENCES POW_FORMS(ID_FORM)
;


