
CREATE PROCEDURE [procfwk].[GetPipelinesInStageTT]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	/* 2020-12-08: Ignore pipelines with "Skipped" status */
	SELECT 
		[PipelineId]
	FROM 
		[procfwk].[CurrentExecutionTT]
	WHERE 
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND ISNULL([PipelineStatus],'') not in ('Success')
		AND [IsBlocked] <> 1
	ORDER BY
		[PipelineId] ASC;
END;
