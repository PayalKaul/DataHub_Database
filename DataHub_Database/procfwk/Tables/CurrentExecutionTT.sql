CREATE TABLE [procfwk].[CurrentExecutionTT] (
    [LocalExecutionId] UNIQUEIDENTIFIER NOT NULL,
    [ContainerName]    NVARCHAR (200)   NOT NULL,
    [StageId]          INT              NOT NULL,
    [PipelineId]       INT              NOT NULL,
    [PipelineName]     NVARCHAR (200)   NOT NULL,
    [StartDateTime]    DATETIME         NULL,
    [PipelineStatus]   NVARCHAR (200)   NULL,
    [EndDateTime]      DATETIME         NULL,
    [IsBlocked]        BIT              DEFAULT ((0)) NOT NULL,
    [AdfPipelineRunId] UNIQUEIDENTIFIER NULL,
    [AdfBatchRunId]    UNIQUEIDENTIFIER NULL,
    [AdfStageRunId]    UNIQUEIDENTIFIER NULL,
    [AdfWorkerRunId]   UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_CurrentExecutionTT] PRIMARY KEY CLUSTERED ([LocalExecutionId] ASC, [StageId] ASC, [PipelineId] ASC),
    CONSTRAINT [UC_CurrentExecutionTT] UNIQUE NONCLUSTERED ([LocalExecutionId] ASC, [ContainerName] ASC, [StageId] ASC, [PipelineName] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_GetPipelinesInStageTT]
    ON [procfwk].[CurrentExecutionTT]([StageId] ASC, [PipelineStatus] ASC)
    INCLUDE([PipelineId], [PipelineName]);

