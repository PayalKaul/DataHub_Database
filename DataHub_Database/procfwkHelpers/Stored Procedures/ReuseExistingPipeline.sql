



/* 
=============================================
Author: Janzen Balasbas     
Create date: Nov 2020
Description: Helper to reuse Pipelines for different container and / or stage
Change Control Log:
YYYYMMDD	Who					Details
20201104	Janzen Balasbas		Initial version of Script.
20210122	Kenny Bui			Exit gracefully if PipelineId + StageId already exists for ContainerId
=============================================
*/


CREATE PROCEDURE [procfwkHelpers].[ReuseExistingPipeline]
              (
                             @ContainerName [NVARCHAR](200),
                             @StageName [NVARCHAR](200), 
                             @PipelineName [NVARCHAR](200),
                             @Enabled [BIT] 
              )
AS
BEGIN

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

			  --20210122	Kenny Bui change starts here
			  if exists (
			  select * from procfwk.ContainersPipelines
			  where PipelineId=@PipelineId
			  and StageId=@StageId
			  and ContainerId=@ContainerId
			  )
			  begin
				print 'Pipeline '+@PipelineName+' in Stage '+@StageName+' for Container '+@ContainerName+' already exists.';
				return;
			  end
			  --20210122	Kenny Bui change ends here

              INSERT INTO [procfwk].[ContainersPipelines]
           ([ContainerId]
           ,[PipelineId]
           ,[Enabled]
           ,[StageId])
     VALUES
           (@ContainerId
           ,@PipelineId
           ,@Enabled
           ,@StageId)

END;
