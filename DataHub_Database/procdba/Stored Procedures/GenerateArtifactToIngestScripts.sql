
/* ===============================================================================================    
 Created By:   Kamran Ahmed    
 Created Date: 04/06/2025    
 Modified By:      
 Modified Date:     
 Purpose:  Generate Data Scripts for ArtifactsToIngest and ArtifactsToIngestParameters from DEV to target envirnoments
			Supports "PROD" and "UAT"
 Details: 
			Parameters: SourceSystem (Conainer), TargetEnvirnoment (PRD,UAT), Ids (Comma Separated)
			its an OR condition in SourceSystem and Ids, if just few records required just leave SourceSystem empty
 Change:    
      14/08/2025	KA	Source made dynamic so that data could be generated from any envirnoment for any target
=================================================================================================== */   
CREATE PROCEDURE [procdba].[GenerateArtifactToIngestScripts]
(
	@SourceSystem VARCHAR(50),
	@TargetEnvirnoment VARCHAR(50),
	@Ids VARCHAR(500)=''
)
AS
BEGIN
	SET NOCOUNT ON;

--DECLARE @TargetEnvirnoment VARCHAR(50)
--SET @TargetEnvirnoment = 'PRD'

--DECLARE @SourceSystem VARCHAR(50)
--SET @SourceSystem = 'ServiceNow_Ignore'

--HELPER VARS
DECLARE @DBName VARCHAR(100)
DECLARE @KVSource VARCHAR(100)
DECLARE @KVTarget VARCHAR(100)
DECLARE @RecordNumber INT
DECLARE @SubRecordNumber INT
DECLARE @Line VARCHAR(50)
DECLARE @SQ VARCHAR(10)
DECLARE @C VARCHAR(10)
SET @RecordNumber = 0 
SET @Line = '-------------------------------------------------------------------------'
SET @SQ = ''''
SET @C = ','
--SET @KVSource = 'https://kv-datahubcnc-dev-01'

-- Fields VARS
DECLARE 
		@ArtifactsToIngestId INT,
		@ArtifactSource VARCHAR(500),@ArtifactContainer VARCHAR(500),@ArtifactPath VARCHAR(500),@ArtifactName VARCHAR(500),
		@DestinationStorageAccount VARCHAR(500),@DestinationContainer VARCHAR(500),@DestinationPath VARCHAR(500),
		@DatabricksWorkspaceUrl VARCHAR(500),@DatabricksWorkspaceResourceId VARCHAR(500),
		@BronzeNotebookPath VARCHAR(500),@BronzeNotebookSpecification VARCHAR(500)
		,@SilverNotebookPath VARCHAR(500),@SilverNotebookSpecification VARCHAR(500)

-- Determine Source Envirnoment
SELECT @DBName = DB_NAME()
SET @KVSource = CASE
					WHEN @DBName = 'dbdhcncdev' THEN 'https://kv-datahubcnc-dev-01'
					WHEN @DBName = 'dbdhcncuat' THEN 'https://kv-datahubcnc-uat-01'
					WHEN @DBName = 'dbdhcncprd' THEN 'https://kv-datahubcnc-prd-02'
				END

-- Setting Target Envrinoment Variables
IF @TargetEnvirnoment = 'PRD'
BEGIN
	SET @DestinationStorageAccount = 'https://dccld200sto69.dfs.core.windows.net/'
	SET @DatabricksWorkspaceUrl = 'https://adb-753746129545942.2.azuredatabricks.net/'
	SET @DatabricksWorkspaceResourceId = '/subscriptions/59d5cae1-997c-44ba-83b8-e8973ba19b6c/resourceGroups/RG-GLB-PRI-DCCLD200-DataHub-PRD-01/providers/Microsoft.Databricks/workspaces/dbw_dh_cnc_prd'
	SET @KVTarget = 'https://kv-datahubcnc-prd-02'
END

IF @TargetEnvirnoment = 'UAT'
BEGIN
	SET @DestinationStorageAccount = 'https://dccld200sto66.dfs.core.windows.net/'
	SET @DatabricksWorkspaceUrl = 'https://adb-3452502350087205.5.azuredatabricks.net/'
	SET @DatabricksWorkspaceResourceId = '/subscriptions/59d5cae1-997c-44ba-83b8-e8973ba19b6c/resourceGroups/RG-GLB-PRI-DCCLD200-DataHub-UAT-01/providers/Microsoft.Databricks/workspaces/dbw_dh_cnc_uat'
	SET @KVTarget = 'https://kv-datahubcnc-uat-01'
END

IF @TargetEnvirnoment = 'DEV'
BEGIN
	SET @DestinationStorageAccount = 'https://dccld200sto64.dfs.core.windows.net/'
	SET @DatabricksWorkspaceUrl = 'https://adb-1940009658276268.8.azuredatabricks.net'
	SET @DatabricksWorkspaceResourceId = '/subscriptions/59d5cae1-997c-44ba-83b8-e8973ba19b6c/resourceGroups/RG-GLB-PRI-DCCLD200-DataHub-DEV-01/providers/Microsoft.Databricks/workspaces/dbw_dh_cnc_dev'
	SET @KVTarget = 'https://kv-datahubcnc-dev-01'
END

DECLARE 
		@ContainerName VARCHAR(500),
		@ParameterName VARCHAR(500),@ParameterValue VARCHAR(MAX),@Description VARCHAR(MAX)

DECLARE CUR_ATI CURSOR
    FOR 
		SELECT id,SourceSystem,ArtifactSource,ArtifactContainer,ArtifactPath,ArtifactName,
		DestinationContainer,DestinationPath,
		BronzeNotebookPath,BronzeNotebookSpecification,
		SilverNotebookPath,SilverNotebookSpecification FROM ArtifactsToIngest 
		WHERE SourceSystem = @SourceSystem 
			OR id IN (SELECT value FROM STRING_SPLIT(@Ids, ',')) -- Have to do it otherwise it is considered as string

OPEN CUR_ATI
-- Start Trans
PRINT CONCAT('PRINT ',@SQ,'---***PROCESS STARTED***---',@SQ)
PRINT 'DECLARE @InsertedArtifactsToIngestId INT'
PRINT 'BEGIN TRY'

PRINT 'BEGIN TRAN'
FETCH NEXT FROM CUR_ATI 
	INTO 
		@ArtifactsToIngestId,@SourceSystem,@ArtifactSource,@ArtifactContainer,@ArtifactPath,@ArtifactName,
		@DestinationContainer,@DestinationPath,
		@BronzeNotebookPath,@BronzeNotebookSpecification,
		@SilverNotebookPath,@SilverNotebookSpecification

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SubRecordNumber = 0 
	SET @RecordNumber = @RecordNumber + 1
	PRINT CONCAT('--INSERTING ArtifactsToIngest RECORD NUMBER #', @RecordNumber)
	PRINT @Line
	PRINT CONCAT('
	INSERT INTO ArtifactsToIngest
		(SourceSystem,UpsertDate,ArtifactSource,ArtifactContainer,ArtifactPath,ArtifactName,
		DestinationStorageAccount,DestinationContainer,DestinationPath,
		DatabricksWorkspaceUrl,DatabricksWorkspaceResourceId,
		BronzeNotebookPath,BronzeNotebookSpecification,
		SilverNotebookPath,SilverNotebookSpecification)',CHAR(10),
	'VALUES(',@SQ,@SourceSystem,@SQ,@C,CHAR(10)
			,@SQ,CAST(GETDATE() AS DATE),@SQ,@C,CHAR(10)
			,@SQ,@ArtifactSource,@SQ,@C,CHAR(10)
			,@SQ,@ArtifactContainer,@SQ,@C,CHAR(10)
			,@SQ,@ArtifactPath,@SQ,@C,CHAR(10)
			,@SQ,@ArtifactName,@SQ,@C,CHAR(10)
			,@SQ,@DestinationStorageAccount,@SQ,@C,CHAR(10)
			,@SQ,@DestinationContainer,@SQ,@C,CHAR(10)
			,@SQ,@DestinationPath,@SQ,@C,CHAR(10)
			,@SQ,@DatabricksWorkspaceUrl,@SQ,@C,CHAR(10)
			,@SQ,@DatabricksWorkspaceResourceId,@SQ,@C,CHAR(10)
			,@SQ,@BronzeNotebookPath,@SQ,@C,CHAR(10)
			,@SQ,@BronzeNotebookSpecification,@SQ,@C,CHAR(10)
			,@SQ,@SilverNotebookPath,@SQ,@C,CHAR(10)
			,@SQ,@SilverNotebookSpecification,@SQ
	,')')
	PRINT CHAR(10)
	PRINT CHAR(10)
	PRINT @Line
	PRINT '--START INSERTING PARAMETERS RECORDS IN ArtifactsToIngestParameters'
	--Get Inserted ID
	PRINT 'SET @InsertedArtifactsToIngestId = @@IDENTITY'

	--Get ArtifactsToIngestParameters Data
	DECLARE CUR_ATIP CURSOR
    FOR 
		SELECT 
			ArtifactsToIngestId,ContainerName,ParameterName,REPLACE(ParameterValue,@KVSource,@KVTarget),Description 
			FROM ArtifactsToIngestParameters 
			WHERE ArtifactsToIngestId = @ArtifactsToIngestId
	OPEN CUR_ATIP
	FETCH NEXT FROM CUR_ATIP
	INTO @ArtifactsToIngestId,@ContainerName,@ParameterName,@ParameterValue,@Description 
	WHILE @@FETCH_STATUS = 0
		BEGIN
				SET @SubRecordNumber = @SubRecordNumber + 1
				PRINT CONCAT('--INSERTING ArtifactsToIngest PARAMETERS RECORD NUMBER #', @SubRecordNumber)
				PRINT @Line
				PRINT CONCAT('INSERT INTO ArtifactsToIngestParameters',
								'(ArtifactsToIngestId,ContainerName,ParameterName,ParameterValue,Description)',CHAR(10),
								'VALUES(@InsertedArtifactsToIngestId',@C,CHAR(10)
										,@SQ,@ContainerName,@SQ,@C,CHAR(10)
										,@SQ,@ParameterName,@SQ,@C,CHAR(10)
										,@SQ,@ParameterValue,@SQ,@C,CHAR(10)
										,@SQ,@Description,@SQ,CHAR(10)
						,')')


				FETCH NEXT FROM CUR_ATIP
				INTO @ArtifactsToIngestId,@ContainerName,@ParameterName,@ParameterValue,@Description 
		END
	CLOSE CUR_ATIP
	DEALLOCATE CUR_ATIP
	--End ArtifactsToIngestParameters Work
	PRINT @Line
	PRINT '--END INSERTING PARAMETERS RECORDS IN ArtifactsToIngestParameters'
	PRINT @Line
	PRINT CHAR(10)
	PRINT CHAR(10)
	--Next Row
	FETCH NEXT FROM CUR_ATI 
		INTO 
			@ArtifactsToIngestId,@SourceSystem,@ArtifactSource,@ArtifactContainer,@ArtifactPath,@ArtifactName,
			@DestinationContainer,@DestinationPath,
			@BronzeNotebookPath,@BronzeNotebookSpecification,
			@SilverNotebookPath,@SilverNotebookSpecification
END



--Get ArtifactsToIngestParameters Conainter Data
PRINT CHAR(10)
PRINT CHAR(10)
PRINT @Line
PRINT '--START INSERTING CONAINER PARAMETERS RECORDS IN ArtifactsToIngestParameters'
	SET @SubRecordNumber = 0
	DECLARE CUR_ATIPC CURSOR
    FOR 
		SELECT 
			ContainerName,ParameterName,REPLACE(ParameterValue,@KVSource,@KVTarget),Description 
			FROM ArtifactsToIngestParameters 
			WHERE ContainerName = @SourceSystem AND ArtifactsToIngestId = 0
	OPEN CUR_ATIPC
	FETCH NEXT FROM CUR_ATIPC
	INTO @ContainerName,@ParameterName,@ParameterValue,@Description 
	WHILE @@FETCH_STATUS = 0
		BEGIN
				SET @SubRecordNumber = @SubRecordNumber + 1
				PRINT CONCAT('--INSERTING CONAINER PARAMETERS RECORD NUMBER #', @SubRecordNumber)
				PRINT @Line
				PRINT CONCAT('INSERT INTO ArtifactsToIngestParameters',
								'(ArtifactsToIngestId,ContainerName,ParameterName,ParameterValue,Description)',CHAR(10),
								'VALUES(0',@C,CHAR(10)
										,@SQ,@ContainerName,@SQ,@C,CHAR(10)
										,@SQ,@ParameterName,@SQ,@C,CHAR(10)
										,@SQ,@ParameterValue,@SQ,@C,CHAR(10)
										,@SQ,@Description,@SQ,CHAR(10)
						,')')


				FETCH NEXT FROM CUR_ATIPC
				INTO @ContainerName,@ParameterName,@ParameterValue,@Description 
		END
	CLOSE CUR_ATIPC
	DEALLOCATE CUR_ATIPC
	--End ArtifactsToIngestParameters Work
	PRINT @Line
	PRINT '--END INSERTING CONAINER PARAMETERS RECORDS IN ArtifactsToIngestParameters'

	PRINT CHAR(10)
	PRINT CHAR(10)


PRINT 'COMMIT TRAN'
PRINT 'END TRY'
PRINT CHAR(10)
PRINT CHAR(10)
PRINT 'BEGIN CATCH'
PRINT 'IF @@TRANCOUNT > 0'
PRINT 'ROLLBACK TRANSACTION;'
PRINT 'END CATCH'

CLOSE CUR_ATI
DEALLOCATE CUR_ATI
PRINT CONCAT('PRINT ',@SQ,'---***PROCESS ENDED***---',@SQ)

END;
