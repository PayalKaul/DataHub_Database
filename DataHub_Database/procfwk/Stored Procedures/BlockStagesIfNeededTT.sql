CREATE PROCEDURE [procfwk].[BlockStagesIfNeededTT]
	(
    	@ExecutionId UNIQUEIDENTIFIER,
	    @StageId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT
            * 
        FROM
        procfwk.CurrentExecutionTT
        WHERE StageId = @StageId
        AND LocalExecutionId = @ExecutionId
        AND PipelineStatus = 'Failed'
    )
    BEGIN
        UPDATE procfwk.CurrentExecutionTT
        SET isBlocked = 1, PipelineStatus = 'Blocked'
        WHERE StageId <> @StageId
        AND LocalExecutionId = @ExecutionId
        AND PipelineStatus IS NULL
    END

END
