CREATE PROCEDURE [procfwk].[SetLogPipelineRunningTT]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT,
	@ADFBatchRunId UNIQUEIDENTIFIER,
	@ADFStageRunId UNIQUEIDENTIFIER,
	@ADFWorkerRunId UNIQUEIDENTIFIER
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE
		[procfwk].[CurrentExecutionTT]
	SET
		--case for clean up runs
		[StartDateTime] = CASE WHEN [StartDateTime] IS NULL THEN GETUTCDATE() ELSE [StartDateTime] END,
		[PipelineStatus] = 'Running',
		AdfBatchRunId = @ADFBatchRunId,
		AdfStageRunId = @ADFStageRunId,
		AdfWorkerRunId = @ADFWorkerRunId

	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
END;
