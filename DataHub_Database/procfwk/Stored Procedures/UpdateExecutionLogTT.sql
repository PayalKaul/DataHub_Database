CREATE PROCEDURE [procfwk].[UpdateExecutionLogTT]
	(
	@PerformErrorCheck BIT = 1
    ,@ContainerName NVARCHAR(200)   -- added by HT
	)
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @AllCount INT
	DECLARE @SuccessCount INT
    DECLARE @ErrorString NVARCHAR(MAX)
	DECLARE @LocalExecutionId VARCHAR(200)

	IF @PerformErrorCheck = 1
	BEGIN
		--Check current execution
		SELECT @AllCount = COUNT(0) FROM [procfwk].[CurrentExecutionTT] 
            WHERE [ContainerName] = @ContainerName;
		/* 20201208: JB: Adding Skipped condition to match the count */
		SELECT @SuccessCount = COUNT(0) FROM [procfwk].[CurrentExecutionTT] WHERE [PipelineStatus] in ('Success')
            AND [ContainerName] = @ContainerName;

	/*
		Slalom threw an exception her, in a result it doesn't tranfer data into main log table ([procfwk].[ExecutionLogTT])
		We have made this commented becuase we need failed status in main in order to send notifications
	*/
	/*
		IF @AllCount <> @SuccessCount
			BEGIN
                SET @ErrorString = 'Framework execution complete but not all Worker pipelines succeeded for Container: ' + @ContainerName + '. See the [procfwk].[CurrentExecution] table for details';
                RAISERROR(@ErrorString,16,1);
				RETURN 0;
			END;
	*/
	END;

	INSERT INTO [procfwk].[ExecutionLogTT]
		(
		[LocalExecutionId],
		[StageId],
		[PipelineId],
        [ContainerName],
		[PipelineName],
		[StartDateTime],
		[PipelineStatus],
		[EndDateTime],
		[AdfPipelineRunId],
		[AdfBatchRunId],
		[AdfStageRunId],
		[AdfWorkerRunId]
		)
	SELECT
		[LocalExecutionId],
		[StageId],
		[PipelineId],
        [ContainerName],
		[PipelineName],
		[StartDateTime],
		[PipelineStatus],
		[EndDateTime],
		[AdfPipelineRunId],
		[AdfBatchRunId],
		[AdfStageRunId],
		[AdfWorkerRunId]
	FROM
		 [procfwk].[CurrentExecutionTT]
    WHERE [ContainerName] = @ContainerName;


	SELECT TOP 1 @LocalExecutionId = [LocalExecutionId] FROM 	
		[procfwk].[CurrentExecutionTT]
    WHERE [ContainerName] = @ContainerName;

    DELETE FROM [procfwk].[CurrentExecutionTT] WHERE [ContainerName] = @ContainerName;
    
END;
