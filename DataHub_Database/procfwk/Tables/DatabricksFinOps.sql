CREATE TABLE [procfwk].[DatabricksFinOps] (
    [Id]                        INT            IDENTITY (1, 1) NOT NULL,
    [ContainerName]             NVARCHAR (255) NOT NULL,
    [RequestBody]               NVARCHAR (MAX) NOT NULL,
    [RequestRelativeURL]        NVARCHAR (255) NOT NULL,
    [RequestStatustRelativeURL] NVARCHAR (255) NOT NULL,
    [RequestResultRelativeURL]  NVARCHAR (255) NOT NULL,
    [AccessTokenRelativeURL]    NVARCHAR (255) NOT NULL,
    [BearerClientId]            NVARCHAR (255) NOT NULL,
    [BearerClientSecret]        NVARCHAR (255) NOT NULL,
    [KeyVaultResource]          NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Databricks] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DatabricksFinOps_Container]
    ON [procfwk].[DatabricksFinOps]([ContainerName] ASC);


GO
/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		13/06/2025
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to delete more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [procfwk].[TRIG_DELETE_DatabricksFinOps] ON procfwk.DatabricksFinOps
  FOR DELETE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM DELETED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be deleted!', 1;
    END
END;

GO
/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		13/06/2025
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to update more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [procfwk].[TRIG_UPDATE_DatabricksFinOps] ON procfwk.DatabricksFinOps
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
