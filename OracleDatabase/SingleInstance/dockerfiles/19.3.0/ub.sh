sqlplus -s /nolog << EOF
CONNECT  /  AS SYSDBA;
alter session set container=$ORACLE_PDB;
CREATE TABLESPACE ub_tbs DATAFILE '/opt/oracle/oradata/$ORACLE_SID/$ORACLE_PDB/ub_tbs.dbf' SIZE 20M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE  ub_temp TEMPFILE '/opt/oracle/oradata/$ORACLE_SID/$ORACLE_PDB/ub_temp.dbf' SIZE 5M AUTOEXTEND ON;
CREATE USER CT_IDM_INTEL_1X identified by ct_idm_intel_1x account unlock;
ALTER USER CT_IDM_INTEL_1X DEFAULT TABLESPACE ub_tbs TEMPORARY TABLESPACE ub_temp;
create directory DATA_1x_PUMP_DIR as '/home/oracle/dumps';
grant all on directory DATA_1x_PUMP_DIR to CT_IDM_INTEL_1X;
GRANT CREATE SESSION TO CT_IDM_INTEL_1X;
GRANT DBA TO CT_IDM_INTEL_1X;
exit; 
EOF
impdp ct_idm_intel_1x/ct_idm_intel_1x@localhost/$ORACLE_PDB directory = DATA_1x_PUMP_DIR dumpfile = oracle_ub_ct_1x.dmp logfile = oracle_ub_1x_impt.log schemas = ct_idm_intel_1x
