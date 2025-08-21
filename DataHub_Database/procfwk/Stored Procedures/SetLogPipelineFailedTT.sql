CREATE PROCEDURE [procfwk].[SetLogPipelineFailedTT]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE
		[procfwk].[CurrentExecutionTT]
	SET
		[PipelineStatus] = 'Failed'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId

END;
