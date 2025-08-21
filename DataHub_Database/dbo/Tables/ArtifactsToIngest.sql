CREATE TABLE [dbo].[ArtifactsToIngest] (
    [id]                            INT             IDENTITY (1, 1) NOT NULL,
    [SourceSystem]                  NVARCHAR (255)  NOT NULL,
    [UpsertDate]                    DATE            NOT NULL,
    [ArtifactSource]                NVARCHAR (1000) NOT NULL,
    [ArtifactContainer]             NVARCHAR (1000) NOT NULL,
    [ArtifactPath]                  NVARCHAR (1000) NOT NULL,
    [ArtifactName]                  NVARCHAR (255)  NOT NULL,
    [DestinationStorageAccount]     NVARCHAR (255)  NOT NULL,
    [DestinationContainer]          NVARCHAR (255)  NOT NULL,
    [DestinationPath]               NVARCHAR (255)  NOT NULL,
    [DatabricksWorkspaceUrl]        NVARCHAR (255)  NULL,
    [DatabricksWorkspaceResourceId] NVARCHAR (255)  NULL,
    [BronzeNotebookPath]            NVARCHAR (255)  NULL,
    [BronzeNotebookSpecification]   NVARCHAR (1000) NULL,
    [SilverNotebookPath]            NVARCHAR (255)  NULL,
    [SilverNotebookSpecification]   NVARCHAR (1000) NULL
);


GO
/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to update more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [dbo].[TRIG_UPDATE_ArtifactsToIngest] ON dbo.ArtifactsToIngest
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;

GO
DISABLE TRIGGER [dbo].[TRIG_UPDATE_ArtifactsToIngest]
    ON [dbo].[ArtifactsToIngest];


GO
/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to delete more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [dbo].[TRIG_DELETE_ArtifactsToIngest] ON dbo.ArtifactsToIngest
  FOR DELETE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM DELETED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be deleted!', 1;
    END
END;
