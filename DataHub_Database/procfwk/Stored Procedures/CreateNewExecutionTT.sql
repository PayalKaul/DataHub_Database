

CREATE PROCEDURE [procfwk].[CreateNewExecutionTT]
	(
    @ContainerName NVARCHAR(200)
	)
AS
BEGIN
	SET NOCOUNT ON;

	-- find out the ContainerId from the Containers Table. 
	DECLARE @ContainerId INT;
	SELECT @ContainerId =  [ContainerId] from [procfwk].[Containers] 
						  WHERE [ContainerName] = @ContainerName

	DECLARE @LocalExecutionId UNIQUEIDENTIFIER = NEWID()

	-- TRUNCATE TABLE [procfwk].[CurrentExecution];    -- HT: Can no longer do a truncate
	DELETE FROM [procfwk].[CurrentExecutionTT] 
		WHERE [ContainerName] = @ContainerName;

	INSERT INTO [procfwk].[CurrentExecutionTT]
		(
		[LocalExecutionId],
        [ContainerName],
		[StageId],
		[PipelineId],
		[PipelineName]
		)
	SELECT
		@LocalExecutionId,
        @ContainerName,
		cp.[StageId],
		p.[PipelineId],
		p.[PipelineName]
	FROM
		[procfwk].[Pipelines] p
		INNER JOIN [procfwk].[Stages] s
			ON p.[StageId] = s.[StageId]
		INNER JOIN [procfwk].[ContainersPipelines] cp
            ON p.PipelineId = cp.PipelineId
	WHERE
		-- we need to check the active flag on both Pipelines & the intersection table ContainersPipelines
        p.Enabled = 1
        AND cp.Enabled = 1
		AND cp.ContainerId IN -- need to get the containerId as it is not supplied (only name)
			(
				SELECT c2.ContainerId FROM [procfwk].[Containers] c2
					WHERE c2.ContainerName = @ContainerName
			)

	ALTER INDEX [IDX_GetPipelinesInStageTT] ON [procfwk].[CurrentExecutionTT]
	REBUILD;

	SELECT
		@LocalExecutionId AS ExecutionId
END;
