

/* ===============================================================================================    
 Created By:   Kamran Ahmed    
 Created Date: 21/07/2025    
 Modified By:      
 Modified Date:     
 Purpose:  This procedure creates backup tables as bckup.ArtifactsToIngest and bckup.ArtifactsToIngestParameters

 Details: 
			Must be executed before deployment of records in target envinoment
 Change:    
      
=================================================================================================== */   
CREATE PROCEDURE [procdba].[BackupTables]
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @SourceSchema VARCHAR(50)
DECLARE @SourceTable VARCHAR(500)
DECLARE @Source VARCHAR(500)

DECLARE @TargetSchema VARCHAR(50)
DECLARE @Target VARCHAR(500)
SET @TargetSchema = 'bckup'

DECLARE @SQL VARCHAR(MAX)
BEGIN TRY
	BEGIN TRAN
		PRINT 'TRANSACTION STARTED'
		DECLARE CUR_BCKUP CURSOR
			FOR 
				SELECT TABLE_SCHEMA,TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
					WHERE TABLE_TYPE='BASE TABLE' 
							AND TABLE_NAME IN ('ArtifactsToIngest','ArtifactsToIngestParameters','DatabricksFinOps') AND TABLE_SCHEMA IN ('dbo','procfwk')
			OPEN CUR_BCKUP
			FETCH NEXT FROM CUR_BCKUP INTO @SourceSchema,@SourceTable
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @Source = CONCAT(@SourceSchema,'.',@SourceTable)
					SET @Target = CONCAT(@TargetSchema,'.',@SourceTable)
					--Create Drop Backup Statement
					SET @SQL = CONCAT('DROP TABLE IF EXISTS ',@Target)
					PRINT CONCAT('Executing Statement: ',@SQL)
					--Drop existing backup table
					EXEC (@SQL)

					PRINT CONCAT('BACKUP STARTED FOR ',@Source)
					--Create Backup Statement
					SET @SQL=CONCAT('SELECT * INTO ', @Target, ' FROM ',@Source)
					PRINT @SQL
					-- Create Backup
					EXEC (@SQL)
					PRINT CONCAT('BACKUP FINISHED FOR ', @Source , ' INTO ', @Target)
					FETCH NEXT FROM CUR_BCKUP INTO @SourceSchema,@SourceTable
				END
			CLOSE CUR_BCKUP
			DEALLOCATE CUR_BCKUP
			PRINT 'TRANSACTION COMMITTED'
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'TRANSACTION ROLLBACKED'
	CLOSE CUR_BCKUP
	DEALLOCATE CUR_BCKUP
	ROLLBACK TRAN
END CATCH

END;
