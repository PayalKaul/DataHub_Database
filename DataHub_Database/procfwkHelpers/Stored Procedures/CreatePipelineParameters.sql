

/* 
=============================================
Author: Janzen Balasbas     
Create date: Nov 2020
Description: Helper to create Pipeline Parameters
Change Control Log:
YYYYMMDD	Who					Details
20201104	Janzen Balasbas		Initial version of Script.
20210120	Kenny Bui			Prevent duplicate ParameterName for pipeline
20210122	Kenny Bui			Another check to ensure no duplicate parameter name
20210122	Kenny Bui			Change @ParameterValue to [NVARCHAR](MAX)
=============================================
*/

CREATE PROCEDURE [procfwkHelpers].[CreatePipelineParameters]
              (
                             @ContainerName [NVARCHAR](200),
                             @StageName [NVARCHAR](200), 
                             @PipelineName [NVARCHAR](200),
                             @ParameterName [NVARCHAR](200),
                             @ParameterValue [NVARCHAR](MAX) -- 20210122	Kenny Bui [NVARCHAR](MAX)
              )
AS
BEGIN
-- 20210120 KennyBui change starts here
DECLARE @ErrorMessage VARCHAR(max)
-- check if parameter exists already for specific container + stage + pipeline
if exists (
    select * from procfwk.PipelineParameters pp
    inner join procfwk.ContainersPipelines cp on cp.ContainersPipelinesId=pp.ContainersPipelinesId
    inner join procfwk.Pipelines p on cp.PipelineId = p.PipelineId
    inner join procfwk.Containers c on c.ContainerId = cp.ContainerId
    inner join procfwk.Stages s on s.StageId = cp.StageId
    where c.ContainerName = @ContainerName and s.StageName=@StageName and p.PipelineName=@PipelineName
    and pp.ParameterName = @ParameterName
)
BEGIN
    set @ErrorMessage = 'ParameterName ' + @ParameterName + ' already exists for ContainerName ' + @ContainerName + ', StageName ' + @StageName + ', PipelineName ' + @PipelineName;
    PRINT @ErrorMessage;
	RETURN; 
END
-- if parameter does not exist for specific container + stage + pipeline, then CONTINUE
else if (not exists (
    select * from procfwk.PipelineParameters pp
    inner join procfwk.ContainersPipelines cp on cp.ContainersPipelinesId=pp.ContainersPipelinesId
    inner join procfwk.Pipelines p on cp.PipelineId = p.PipelineId
    inner join procfwk.Containers c on c.ContainerId = cp.ContainerId
    inner join procfwk.Stages s on s.StageId = cp.StageId
    where c.ContainerName = @ContainerName and s.StageName=@StageName and p.PipelineName=@PipelineName
    and pp.ParameterName = @ParameterName
)
and @ContainerName is not null and @StageName is not null)
BEGIN
    PRINT 'Continue to insert pipeline parameter';
END
-- else check if parameter exists for specific pipeline with no container
else if exists (
    select * from procfwk.PipelineParameters pp
    inner join procfwk.Pipelines p on pp.PipelineId = p.PipelineId
    where pp.ContainersPipelinesId is NULL
    and p.PipelineName=@PipelineName
    and pp.ParameterName = @ParameterName
)
BEGIN
    set @ErrorMessage = 'ParameterName ' + @ParameterName + ' already exists for PipelineName ' + @PipelineName;
    PRINT @ErrorMessage;
	RETURN; 
END
-- 20210120 KennyBui change ends here

              -- Get the Container Id from the supplied name
              DECLARE @ContainerId INT;
              IF EXISTS (
                             SELECT C.[ContainerId] FROM [procfwk].[Containers] C
                                           WHERE C.ContainerName = @ContainerName
              )
              BEGIN
                             SET @ContainerId = (SELECT C.[ContainerId] FROM [procfwk].[Containers] C
                                           WHERE C.ContainerName = @ContainerName
              )
              END
              ELSE
              BEGIN
                             SET @ContainerId = 0
              END

              -- Get the Stage Id from the supplied name
              DECLARE @StageId INT;
              IF EXISTS (
                             SELECT S.[StageId] FROM [procfwk].[Stages] S
                                           WHERE S.StageName = @StageName
              )
              BEGIN
                             SET @StageId = (SELECT S.[StageId] FROM [procfwk].[Stages] S
                                           WHERE S.StageName = @StageName
              )
              END
              ELSE
              BEGIN
                             SET @StageId = 0
              END

              -- Get the Pipeline Id from the supplied name
              DECLARE @PipelineId INT;
              IF EXISTS (
                             SELECT P.[PipelineId] FROM [procfwk].[Pipelines] P
                                           WHERE P.PipelineName = @PipelineName
              )
              BEGIN
                             SET @PipelineId = (SELECT P.[PipelineId] FROM [procfwk].[Pipelines] P
                                           WHERE P.PipelineName = @PipelineName
              )
              END

              -- Get the Containers Pipelines Id from IDs
              DECLARE @ContainersPipelinesId INT;
              IF EXISTS (
                             SELECT CP.ContainersPipelinesId FROM [procfwk].[ContainersPipelines] CP
                                           WHERE CP.ContainerId = @ContainerId
                                                          AND CP.StageId = @StageId
                                                          AND CP.PipelineId = @PipelineId
              )
              BEGIN
                             SET @ContainersPipelinesId = (SELECT CP.ContainersPipelinesId FROM [procfwk].[ContainersPipelines] CP
                                           WHERE CP.ContainerId = @ContainerId
                                                          AND CP.StageId = @StageId
                                                          AND CP.PipelineId = @PipelineId
              )
              END
			  --20210122	Kenny Bui change starts here
			  ELSE
			  BEGIN
				SET @ContainersPipelinesId=NULL
			  END
			  
			  if (@ContainersPipelinesId is null)
			  begin
				  if exists (
					select * from procfwk.PipelineParameters
					where PipelineId=@PipelineId 
						and ParameterName=@ParameterName 
						and ContainersPipelinesId is null
						)
				  begin
					set @ErrorMessage = 'ContainersPipelinesId is NULL. Please execute procfwkHelpers.ReuseExistingPipeline for the container and pipeline. ParameterName ' + @ParameterName + ' already exists for PipelineName ' + @PipelineName + '.';
					PRINT @ErrorMessage;
					RETURN; 
				  end
				end
			  --20210122	Kenny Bui change ends here

              INSERT INTO [procfwk].[PipelineParameters]
           ([ContainersPipelinesId]
           ,[PipelineId]
           ,[ParameterName]
           ,[ParameterValue])
     VALUES
           (@ContainersPipelinesId
           ,@PipelineId
           ,@ParameterName
           ,@ParameterValue)
END
