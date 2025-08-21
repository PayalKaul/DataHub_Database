CREATE TABLE [procfwk].[ContainersPipelines] (
    [ContainersPipelinesId] INT IDENTITY (1, 1) NOT NULL,
    [ContainerId]           INT NOT NULL,
    [PipelineId]            INT NOT NULL,
    [Enabled]               BIT CONSTRAINT [DF_ContainersPipelines_Enabled] DEFAULT ((1)) NOT NULL,
    [StageId]               INT NULL,
    CONSTRAINT [PK_ContainersPipelines] PRIMARY KEY CLUSTERED ([ContainersPipelinesId] ASC),
    CONSTRAINT [FK_Containers_ContainerPipeline] FOREIGN KEY ([ContainerId]) REFERENCES [procfwk].[Containers] ([ContainerId]),
    CONSTRAINT [FK_Pipelines_ContainersPipelines] FOREIGN KEY ([PipelineId]) REFERENCES [procfwk].[Pipelines] ([PipelineId]),
    CONSTRAINT [FK_Stages_ContainersPipelines] FOREIGN KEY ([StageId]) REFERENCES [procfwk].[Stages] ([StageId]),
    CONSTRAINT [UC_ContainersPipelines] UNIQUE NONCLUSTERED ([ContainerId] ASC, [StageId] ASC, [PipelineId] ASC)
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
CREATE TRIGGER [procfwk].[TRIG_DELETE_ContainersPipelines] ON [procfwk].[ContainersPipelines]
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
DISABLE TRIGGER [procfwk].[TRIG_DELETE_ContainersPipelines]
    ON [procfwk].[ContainersPipelines];


GO

/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to update more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [procfwk].[TRIG_UPDATE_ContainersPipelines] ON [procfwk].[ContainersPipelines]
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
