CREATE TABLE [dbo].[ArtifactsToIngestParameters] (
    [ParameterId]         INT            IDENTITY (1, 1) NOT NULL,
    [ArtifactsToIngestId] INT            CONSTRAINT [DF_ArtifactsToIngestParameters_ArtifactsToIngestId] DEFAULT ((0)) NOT NULL,
    [ContainerName]       NVARCHAR (255) NULL,
    [ParameterName]       VARCHAR (128)  NOT NULL,
    [ParameterValue]      NVARCHAR (MAX) NOT NULL,
    [Description]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PipelineParameters] PRIMARY KEY CLUSTERED ([ParameterId] ASC)
);


GO
/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to delete more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [dbo].[TRIG_DELETE_ArtifactsToIngestParameters] ON dbo.ArtifactsToIngestParameters
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
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to update more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [dbo].[TRIG_UPDATE_ArtifactsToIngestParameters] ON dbo.ArtifactsToIngestParameters
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
