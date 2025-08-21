CREATE TABLE [procfwk].[PipelineParameters] (
    [ParameterId]           INT            IDENTITY (1, 1) NOT NULL,
    [ContainersPipelinesId] INT            NULL,
    [PipelineId]            INT            NOT NULL,
    [ParameterName]         VARCHAR (128)  NOT NULL,
    [ParameterValue]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PipelineParameters] PRIMARY KEY CLUSTERED ([ParameterId] ASC),
    CONSTRAINT [FK_ContainersPipelines_PipelineParameters] FOREIGN KEY ([ContainersPipelinesId]) REFERENCES [procfwk].[ContainersPipelines] ([ContainersPipelinesId]),
    CONSTRAINT [FK_Pipelines_PipelineParameters] FOREIGN KEY ([PipelineId]) REFERENCES [procfwk].[Pipelines] ([PipelineId])
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
CREATE TRIGGER [procfwk].[TRIG_DELETE_PipelineParameters] ON [procfwk].[PipelineParameters]
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
DISABLE TRIGGER [procfwk].[TRIG_DELETE_PipelineParameters]
    ON [procfwk].[PipelineParameters];


GO

/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to update more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [procfwk].[TRIG_UPDATE_PipelineParameters] ON [procfwk].[PipelineParameters]
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
