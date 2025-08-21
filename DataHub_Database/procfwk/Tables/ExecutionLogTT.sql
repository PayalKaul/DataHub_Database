CREATE TABLE [procfwk].[ExecutionLogTT] (
    [LogId]              INT              IDENTITY (1, 1) NOT NULL,
    [LocalExecutionId]   UNIQUEIDENTIFIER NOT NULL,
    [StageId]            INT              NOT NULL,
    [PipelineId]         INT              NOT NULL,
    [ContainerName]      NVARCHAR (200)   NOT NULL,
    [PipelineName]       NVARCHAR (200)   NOT NULL,
    [StartDateTime]      DATETIME         NULL,
    [PipelineStatus]     NVARCHAR (200)   NULL,
    [EndDateTime]        DATETIME         NULL,
    [AdfPipelineRunId]   UNIQUEIDENTIFIER NULL,
    [PipelineParamsUsed] NVARCHAR (MAX)   DEFAULT ('None') NULL,
    [AdfBatchRunId]      UNIQUEIDENTIFIER NULL,
    [AdfStageRunId]      UNIQUEIDENTIFIER NULL,
    [AdfWorkerRunId]     UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_ExecutionLogTT] PRIMARY KEY CLUSTERED ([LogId] ASC)
);

