CONNECT  /  AS SYSDBA;
alter session set container=$ORACLE_PDB;
CREATE  TABLESPACE tpch_tbs DATAFILE '/opt/oracle/oradata/$ORACLE_SID/$ORACLE_PDB/tpch_tbs.dbf' SIZE 20M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE  tpch_temp TEMPFILE '/opt/oracle/oradata/$ORACLE_SID/$ORACLE_PDB/tpch_temp.dbf' SIZE 5M AUTOEXTEND ON;
CREATE USER tpch identified by mstr123# account unlock;
ALTER USER tpch DEFAULT TABLESPACE tpch_tbs TEMPORARY TABLESPACE tpch_temp;
GRANT connect, resource to tpch;
GRANT CREATE SESSION TO tpch;
GRANT CREATE TABLE TO tpch;
GRANT CREATE VIEW TO tpch;
GRANT DROP ANY VIEW TO tpch;
--Set up directories and grant access to tpch 
CREATE OR REPLACE DIRECTORY tpch_dat_dir
AS '/home/oracle/flatfiles/data'; 
CREATE OR REPLACE DIRECTORY tpch_log_dir 
AS '/home/oracle/flatfiles/log'; 
CREATE OR REPLACE DIRECTORY tpch_bad_dir 
AS '/home/oracle/flatfiles/bad'; 
GRANT READ ON DIRECTORY tpch_dat_dir TO tpch; 
GRANT WRITE ON DIRECTORY tpch_log_dir TO tpch; 
GRANT WRITE ON DIRECTORY tpch_bad_dir TO tpch;


​CONNECT tpch/mstr123#;
alter session set container=$ORACLE_PDB;
-- create the external table
CREATE TABLE TPCH_EXT_NATION
                   ( N_NATIONKEY  INTEGER NOT NULL,
                     N_NAME       CHAR(25) NOT NULL,
                     N_REGIONKEY  INTEGER NOT NULL,
                     N_COMMENT    VARCHAR(152)
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
         missing field values are null 
         ( N_NATIONKEY, N_NAME, N_REGIONKEY, N_COMMENT
         ) 
       ) 
       LOCATION ('nation.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED;
​
CREATE TABLE TPCH_EXT_REGION
                   ( R_REGIONKEY  INTEGER NOT NULL,
                     R_NAME       CHAR(25) NOT NULL,
                     R_COMMENT    VARCHAR(152)
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
         missing field values are null 
         ( R_REGIONKEY, R_NAME, R_COMMENT
         ) 
       ) 
       LOCATION ('region.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
​
CREATE TABLE TPCH_EXT_PART
                   ( P_PARTKEY     INTEGER NOT NULL,
                     P_NAME        VARCHAR(55) NOT NULL,
                     P_MFGR        CHAR(25) NOT NULL,
                     P_BRAND       CHAR(10) NOT NULL,
                     P_TYPE        VARCHAR(25) NOT NULL,
                     P_SIZE        INTEGER NOT NULL,
                     P_CONTAINER   CHAR(10) NOT NULL,
                     P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                     P_COMMENT     VARCHAR(23) NOT NULL 
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
         missing field values are null 
         ( P_PARTKEY, P_NAME, P_MFGR, P_BRAND, P_TYPE, P_SIZE, P_CONTAINER, P_RETAILPRICE, P_COMMENT
         ) 
       ) 
       LOCATION ('part.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
​
​
CREATE TABLE TPCH_EXT_SUPPLIER
                   ( S_SUPPKEY     INTEGER NOT NULL,
                     S_NAME        CHAR(25) NOT NULL,
                     S_ADDRESS     VARCHAR(40) NOT NULL,
                     S_NATIONKEY   INTEGER NOT NULL,
                     S_PHONE       CHAR(15) NOT NULL,
                     S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                     S_COMMENT     VARCHAR(101) NOT NULL
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
       ) 
       LOCATION ('supplier.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
​
​
CREATE TABLE TPCH_EXT_PARTSUPP
                   ( PS_PARTKEY     INTEGER NOT NULL,
                     PS_SUPPKEY     INTEGER NOT NULL,
                     PS_AVAILQTY    INTEGER NOT NULL,
                     PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                     PS_COMMENT     VARCHAR(199) NOT NULL
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
       ) 
       LOCATION ('partsupp.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
​
CREATE TABLE TPCH_EXT_CUSTOMER
                   ( C_CUSTKEY     INTEGER NOT NULL,
                     C_NAME        VARCHAR(25) NOT NULL,
                     C_ADDRESS     VARCHAR(40) NOT NULL,
                     C_NATIONKEY   INTEGER NOT NULL,
                     C_PHONE       CHAR(15) NOT NULL,
                     C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                     C_MKTSEGMENT  CHAR(10) NOT NULL,
                     C_COMMENT     VARCHAR(117) NOT NULL
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
       ) 
       LOCATION ('customer.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
	 
​
CREATE TABLE TPCH_EXT_ORDERS
                   ( O_ORDERKEY       INTEGER NOT NULL,
                     O_CUSTKEY        INTEGER NOT NULL,
                     O_ORDERSTATUS    CHAR(1) NOT NULL,
                     O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                     O_ORDERDATE      DATE NOT NULL,
                     O_ORDERPRIORITY  CHAR(15) NOT NULL,  
                     O_CLERK          CHAR(15) NOT NULL, 
                     O_SHIPPRIORITY   INTEGER NOT NULL,
                     O_COMMENT        VARCHAR(79) NOT NULL
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
		 ( O_ORDERKEY, O_CUSTKEY, O_ORDERSTATUS, O_TOTALPRICE, O_ORDERDATE  char date_format date mask "yyyy-mm-dd", O_ORDERPRIORITY, O_CLERK, O_SHIPPRIORITY, O_COMMENT
         ) 
       ) 
       LOCATION ('orders.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
	 
	 
CREATE TABLE TPCH_EXT_LINEITEM
                   ( L_ORDERKEY    INTEGER NOT NULL,
                     L_PARTKEY     INTEGER NOT NULL,
                     L_SUPPKEY     INTEGER NOT NULL,
                     L_LINENUMBER  INTEGER NOT NULL,
                     L_QUANTITY    DECIMAL(15,2) NOT NULL,
                     L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                     L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                     L_TAX         DECIMAL(15,2) NOT NULL,
                     L_RETURNFLAG  CHAR(1) NOT NULL,
                     L_LINESTATUS  CHAR(1) NOT NULL,
                     L_SHIPDATE    DATE NOT NULL,
                     L_COMMITDATE  DATE NOT NULL,
                     L_RECEIPTDATE DATE NOT NULL,
                     L_SHIPINSTRUCT CHAR(25) NOT NULL,
                     L_SHIPMODE     CHAR(10) NOT NULL,
                     L_COMMENT      VARCHAR(44) NOT NULL
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY tpch_dat_dir 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile tpch_bad_dir:'tpch%a_%p.bad' 
         logfile tpch_log_dir:'tpch%a_%p.log' 
         fields terminated by '|' 
		( L_ORDERKEY, L_PARTKEY, L_SUPPKEY, L_LINENUMBER, L_QUANTITY, L_EXTENDEDPRICE, L_DISCOUNT, L_TAX,
		L_RETURNFLAG, L_LINESTATUS, L_SHIPDATE char date_format date mask "yyyy-mm-dd",L_COMMITDATE char date_format date mask "yyyy-mm-dd",  L_RECEIPTDATE char date_format date mask "yyyy-mm-dd", L_SHIPINSTRUCT, L_SHIPMODE, L_COMMENT
         ) 
       ) 
       LOCATION ('lineitem.tbl') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 
	 
	 
	 
-- enable parallel for loading (good if lots of data to load)
ALTER SESSION ENABLE PARALLEL DML;
-- load the data in tpch  table
INSERT INTO NATION (N_NATIONKEY, N_NAME, N_REGIONKEY, N_COMMENT) 
            SELECT * FROM TPCH_EXT_NATION;
INSERT INTO REGION (R_REGIONKEY, R_NAME, R_COMMENT) 
            SELECT * FROM TPCH_EXT_REGION;
INSERT INTO PART SELECT * FROM TPCH_EXT_PART;			
INSERT INTO SUPPLIER SELECT * FROM TPCH_EXT_SUPPLIER;	
INSERT INTO PARTSUPP SELECT * FROM TPCH_EXT_PARTSUPP;	
INSERT INTO CUSTOMER SELECT * FROM TPCH_EXT_CUSTOMER;	
INSERT INTO ORDERS SELECT * FROM TPCH_EXT_ORDERS;	
INSERT INTO LINEITEM SELECT * FROM TPCH_EXT_LINEITEM;