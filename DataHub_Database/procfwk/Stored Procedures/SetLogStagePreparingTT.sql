CREATE PROCEDURE [procfwk].[SetLogStagePreparingTT]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	/* 2020-12-08: JB: Ignore pipelines with "Skipped" status */
	UPDATE
		[procfwk].[CurrentExecutionTT]
	SET
		[PipelineStatus] = 'Preparing'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [StartDateTime] IS NULL
		AND [IsBlocked] <> 1;
END;
