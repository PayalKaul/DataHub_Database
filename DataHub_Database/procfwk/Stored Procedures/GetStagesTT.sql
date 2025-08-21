
CREATE PROCEDURE [procfwk].[GetStagesTT]
	(
	@ExecutionId UNIQUEIDENTIFIER
	)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT 
		[StageId] 
	FROM 
		[procfwk].[CurrentExecutionTT]
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND ISNULL([PipelineStatus],'') not in ('Success')
	ORDER BY 
		[StageId] ASC
END;
