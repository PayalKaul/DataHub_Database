
CREATE PROCEDURE [procfwk].[DeleteContainerAndPipeline] 

( 

    @ContainerName varchar(200) 

) 

AS 

BEGIN 

 
 

    -- delete  

    -- from procfwk.PipelineDependencies; 

 
 

    delete  

    from procfwk.PipelineParameters 

    where ParameterId in (  

                            select pp.ParameterId 

                            from procfwk.PipelineParameters pp 

                            inner join procfwk.ContainersPipelines cp on pp.ContainersPipelinesId = cp.ContainersPipelinesId  

                            where cp.ContainerId = (    select ContainerId  

                                                        from procfwk.Containers c 

                                                        where c.ContainerName = @ContainerName) 

                        ); 

 
 

    delete  

    from procfwk.ContainersPipelines  

    where ContainerId = (    select ContainerId  

                                from procfwk.Containers c 

                                where c.ContainerName = @ContainerName); --To Remove all steps for the created container 

 
 
 

    delete  

    from procfwk.Containers 

    where ContainerName = @ContainerName; 

 
 

    -- delete from procfwk.PipelineIntMsg; 

 
 

    -- delete from procfwk.CurrentExecution; 

 
 
 

END; 

