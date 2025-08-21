ALTER ROLE [db_owner] ADD MEMBER [GRP-CMR-GLB-WSP-DataHub-DEV-01];


GO
ALTER ROLE [db_ddladmin] ADD MEMBER [df-datahubcnc-dev-01];


GO
ALTER ROLE [db_ddladmin] ADD MEMBER [GRP-SEC-GLB-BIAA-Contributor-DataEngineer-Dev];


GO
ALTER ROLE [db_ddladmin] ADD MEMBER [ac-bronze-dbw_dh_cnc_dev];


GO
ALTER ROLE [db_datareader] ADD MEMBER [df-datahubcnc-dev-01];


GO
ALTER ROLE [db_datareader] ADD MEMBER [GRP-SEC-GLB-BIAA-Contributor-DataEngineer-Dev];


GO
ALTER ROLE [db_datareader] ADD MEMBER [GRP-SEC-GLB-DataPlatform-POC];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ac-bronze-dbw_dh_cnc_dev];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [df-datahubcnc-dev-01];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [GRP-SEC-GLB-BIAA-Contributor-DataEngineer-Dev];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [GRP-SEC-GLB-DataPlatform-POC];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [ac-bronze-dbw_dh_cnc_dev];

