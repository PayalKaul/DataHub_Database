CREATE PROCEDURE [procfwk].[GetPipelineParametersTT]
	(
	@PipelineId INT,
    @ContainersPipelinesId VARCHAR(5) 
	)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @cols AS NVARCHAR(MAX),
            @query  AS NVARCHAR(MAX)

    SELECT @cols = STUFF((SELECT ',' + QUOTENAME(ParameterName) 
                        from procfwk.PipelineParameters
                        WHERE ContainersPipelinesId = @ContainersPipelinesId
                        AND PipelineId = @PipelineId
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')

    SET @query = N'SELECT ' + @cols + N' from 
                (
                    select ParameterValue, ParameterName
                    from procfwk.PipelineParameters
                        WHERE ContainersPipelinesId = ' + @ContainersPipelinesId
                    + N'    AND PipelineId =' + CAST(@PipelineId AS VARCHAR) + 
                N') x
                pivot 
                (
                    max(parameterValue)
                    for ParameterName in (' + @cols + N')
                ) p '
    exec sp_executesql @query;
END;
