
CREATE PROCEDURE [procfwk].[SetLogADFPipelineRunIdTT]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT,
	@ADFPipelineRunId UNIQUEIDENTIFIER
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE
		[procfwk].[CurrentExecutionTT]
	SET
		AdfPipelineRunId = @ADFPipelineRunId
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId

END;
