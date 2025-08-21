/* 
=============================================
Author: Janzen Balasbas     
Create date: Nov 2020
Description: Helper to create Pipelines   
Change Control Log:
YYYYMMDD  Who           Details
20201104 / Janzen Balasbas / Initial version of Script, expanding to include insertion to ContainersPipelines table.
20210120  KennyBui      Prevent duplicate PipelineName 
=============================================
*/

CREATE   PROCEDURE [procfwkHelpers].[CreateNewPipeline_v2]
              (
                             @DataFactoryName [NVARCHAR](200),
                             @ServicePrincipalName [NVARCHAR](200),
                             @ContainerName [NVARCHAR](200),
                             @StageName [NVARCHAR](200), 
                             @PipelineName [NVARCHAR](200),
                             @Enabled [BIT] 
              )
AS
BEGIN

            -- 20210120 KennyBui change starts here
            IF exists
            (
                SELECT
                * 
                FROM
                procfwk.Pipelines 
                WHERE
                PipelineName = @PipelineName
            )
            BEGIN
                PRINT 'The PipelineName already exists. Executing procfwkHelpers.ReuseExistingPipeline';
				EXEC [procfwkHelpers].[ReuseExistingPipeline] @ContainerName, @StageName, @PipelineName, @Enabled
                RETURN;
            END
            -- 20210120 KennyBui change ends here

              -- Get the DataFactory Id from the supplied name
              DECLARE @DataFactoryId INT;
              IF EXISTS (
                             SELECT df.[DataFactoryId] FROM [procfwk].[DataFactorys] df
                                           WHERE df.DataFactoryName = @DataFactoryName
              )
              BEGIN
                             SET @DataFactoryId = (SELECT df.[DataFactoryId] FROM [procfwk].[DataFactorys] df
                                           WHERE df.DataFactoryName = @DataFactoryName
              )
              END
              -- Get the Stage Id from the supplied name
              DECLARE @StageId INT;
              IF EXISTS (SELECT S.[StageId] FROM [procfwk].[Stages] S WHERE S.StageName = @StageName)
              BEGIN
				SET @StageId = (SELECT S.[StageId] FROM [procfwk].[Stages] S WHERE S.StageName = @StageName)
              END
			  ELSE
			  BEGIN
				INSERT INTO [procfwk].[Stages] (
					[StageName],
					[StageDescription],
					[Enabled]
				) VALUES (
					@StageName,
					'UPDATE WITH DESCRIPTION',
					@Enabled
				);
				SET @StageId = (SELECT SCOPE_IDENTITY());
			  END

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
/*
              -- Get the Credential Id from the supplied name
              DECLARE @CredentialId INT;
              IF EXISTS (
                             SELECT SP.[CredentialId] FROM [dbo].[ServicePrincipals] SP
                                           WHERE SP.PrincipalName = @ServicePrincipalName
              )
              BEGIN
                             SET @CredentialId = (SELECT SP.[CredentialId] FROM [dbo].[ServicePrincipals] SP
                                           WHERE SP.PrincipalName = @ServicePrincipalName
              )
              END
*/
              -- placeholder for inserted pipeline id
              DECLARE @PipelineTable TABLE (PipelineId INT);

              -- populate records to Pipeline table
              INSERT INTO [procfwk].[Pipelines]
                             (
                             [DataFactoryId],
                             [StageId],
                             [PipelineName], 
                             [LogicalPredecessorId],
                             [Enabled]
                             ) 
              OUTPUT INSERTED.[PipelineId] INTO @PipelineTable
              VALUES 
                             (
                             @DataFactoryId,
                             @StageId, 
                             @PipelineName,
                             NULL,
                             @Enabled
                             )

              -- populate records to ContainersPipelines table
              INSERT INTO [procfwk].[ContainersPipelines]
                            (
                            [ContainerId],
                            [PipelineId],
                            [Enabled],
                            [StageId]
                            )
              VALUES
                            (
                            @ContainerId,
                            (SELECT PipelineId from @PipelineTable),
                            @Enabled,
                            @StageId
                            )
/*              -- populate records to PipelineAuthLink table
              INSERT INTO [procfwk].[PipelineAuthLink]
                            (
                            [PipelineId],
                            [DataFactoryId],
                            [CredentialId]
                            )
              VALUES
                            (
                            (SELECT PipelineId from @PipelineTable),
                            @DataFactoryId,
                            @CredentialId
                            )
*/
END;
