CREATE TABLE [procfwk].[Pipelines] (
    [PipelineId]           INT            IDENTITY (1, 1) NOT NULL,
    [DataFactoryId]        INT            NOT NULL,
    [StageId]              INT            NOT NULL,
    [PipelineName]         NVARCHAR (200) NOT NULL,
    [LogicalPredecessorId] INT            NULL,
    [Enabled]              BIT            CONSTRAINT [DF_Pipelines_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Pipelines] PRIMARY KEY CLUSTERED ([PipelineId] ASC),
    CONSTRAINT [FK_DataFactorys_Pipelines] FOREIGN KEY ([DataFactoryId]) REFERENCES [procfwk].[DataFactorys] ([DataFactoryId]),
    CONSTRAINT [FK_Pipelines_Pipelines] FOREIGN KEY ([LogicalPredecessorId]) REFERENCES [procfwk].[Pipelines] ([PipelineId]),
    CONSTRAINT [FK_Stages_Pipelines] FOREIGN KEY ([StageId]) REFERENCES [procfwk].[Stages] ([StageId])
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
CREATE TRIGGER [procfwk].[TRIG_DELETE_Pipelines] ON [procfwk].[Pipelines]
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
CREATE TRIGGER [procfwk].[TRIG_UPDATE_Pipelines] ON [procfwk].[Pipelines]
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
