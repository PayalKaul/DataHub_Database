
CREATE   PROCEDURE [procfwk].[CreatePipelineFromJson] 

( 

    @json varchar(MAX) 

) 

AS 

BEGIN 

 
 

    BEGIN TRY 

        BEGIN TRANSACTION 

 
 

            --to parse all the pipelines in the container 

            DECLARE @count INT 

            --to parse the parameters of each pipeline 

            DECLARE @parm_count INT 

            --to parse all the dependent stages (hard dependencies) 

            Declare @dep_count INT 

 
 
 
 

            --Create the container by calling the stored proc 

            print('Create the container by calling the stored proc') 

            Declare @ContainerName VARCHAR(max) 

            Declare @ContainerDescription varchar(max) 

            Declare @ContainerEnabled varchar(max) 

            Declare @DataFactoryName varchar(max) 

            Declare @ServicePrincipalName varchar(max)

 
 

            set @ContainerName = (SELECT JSON_Value(@json, '$.Container.Name') as ContainerName); 

            set @ContainerDescription = (select JSON_Value(@json, '$.Container.Description') as ContainerDescription); 

            set @ContainerEnabled = (select JSON_Value(@json, '$.Container.Enabled') as ContainerEnabled); 

            set @DataFactoryName = (select JSON_Value(@json, '$.DataFactoryName') as DataFactoryName); 
            
            set @ServicePrincipalName = (select JSON_Value(@json, '$.ServicePrincipalName') as ServicePrincipalName); 

 
 

            EXEC procfwkHelpers.CreateNewContainer  

            @ContainerName = @ContainerName,  

            @Description = @ContainerDescription,  

            @Enabled = @ContainerEnabled; 

 
 
 

            --Add the pipelines and their parameters 

            --pipelines 

            Declare @StageName VARCHAR(max) 

            Declare @PipelineName varchar(max) 

            Declare @PipelineEnabled varchar(max) 

            Declare @ParameterName varchar(max) 

            Declare @ParameterValue varchar(max) 

 
 

            SET @count = 0 

            WHILE @count < (SELECT count(*) FROM OpenJson(JSON_Query(@json, '$.Pipelines'))) 

            BEGIN 

 
 

                --create pipeline 

                Set @StageName = (SELECT JSON_Value(@json, CONCAT('$.Pipelines[', @count, '].StageName'))) 

                Set @PipelineName = (SELECT JSON_Value(@json, CONCAT('$.Pipelines[', @count, '].PipelineName'))) 

                Set @PipelineEnabled = (SELECT JSON_Value(@json, CONCAT('$.Pipelines[', @count, '].Enabled'))) 

 
 

                EXECUTE procfwkHelpers.CreateNewPipeline  

                @DataFactoryName = @DataFactoryName 

                ,@ContainerName = @ContainerName 

                ,@StageName = @StageName 

                ,@PipelineName = @PipelineName 

                ,@ServicePrincipalName = @ServicePrincipalName

                ,@Enabled = @PipelineEnabled; 

 
 

                SET @parm_count = 0 

                WHILE @parm_count < (SELECT count(*) FROM OpenJson(JSON_Query(@json, CONCAT('$.Pipelines[', @count, '].Parameters')   ))) 

                    BEGIN 

                        --parameters 

                        Set @ParameterName = (SELECT JSON_Value(@json, CONCAT('$.Pipelines[', @count, '].Parameters[', @parm_count, '].ParameterName' ))) 

                        Set @ParameterValue = (SELECT JSON_Value(@json, CONCAT('$.Pipelines[', @count, '].Parameters[', @parm_count, '].ParameterValue' ))) 

 
 

                        EXEC procfwkHelpers.CreatePipelineParameters  

                            @ContainerName = @ContainerName,  

                            @StageName = @StageName,        

                            @PipelineName = @PipelineName,  

                            @ParameterName = @ParameterName,  

                            @ParameterValue = @ParameterValue; 

 
 

                        SET @parm_count = @parm_count + 1; 

                    End; 

 
 

                SET @count = @count + 1; 

            END; 

 
 
 
 

            --Add the Dependencies 

            Declare @IndependantPipelineName VARCHAR(max) 

            Declare @DependantPipelineName varchar(max) 

 
/* 

            SET @dep_count = 0 

            WHILE @dep_count < (SELECT count(*) FROM OpenJson(JSON_Query(@json, '$.Dependencies'))) 

            BEGIN 

 
 

                Set @IndependantPipelineName = (SELECT JSON_Value(@json, CONCAT('$.Dependencies[', @dep_count, '].IndependantPipelineName'))) 

                Set @DependantPipelineName   = (SELECT JSON_Value(@json, CONCAT('$.Dependencies[', @dep_count, '].DependantPipelineName'))) 

 
 

                EXECUTE procfwkHelpers.AddPipelineDependant  

                @PipelineName = @IndependantPipelineName 

                ,@DependantPipelineName =  @DependantPipelineName; 

 
 

            SET @dep_count = @dep_count + 1; 

            END; 

 
*/ 
 

        COMMIT TRAN -- Transaction Success! 

    END TRY 

    BEGIN CATCH 

        IF @@TRANCOUNT > 0 

            ROLLBACK TRAN --RollBack in case of Error 

 
 

        DECLARE @ErrorMessage NVARCHAR(4000);   

        DECLARE @ErrorSeverity INT;   

        DECLARE @ErrorState INT;   

 
 

        SELECT    

        @ErrorMessage = ERROR_MESSAGE(),   

        @ErrorSeverity = ERROR_SEVERITY(),   

        @ErrorState = ERROR_STATE();   

 
 

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);   

 
 

    END CATCH 

 
 
 

END; 

