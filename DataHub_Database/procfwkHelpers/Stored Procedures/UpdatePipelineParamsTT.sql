CREATE PROCEDURE [procfwkHelpers].[UpdatePipelineParamsTT](
    @PipelineId INT,
    @ParameterName NVARCHAR(200),
    @ParameterValue NVARCHAR(200)
)
AS
BEGIN  
    SET NOCOUNT ON;

    DECLARE @ErrorMessage VARCHAR(MAX)

    IF EXISTS(
        SELECT pp.* 
        FROM procfwk.PipelineParameters pp
        WHERE pp.PipelineId = @PipelineId
        and pp.ParameterName = TRIM(@ParameterName)
    )
    BEGIN
        UPDATE procfwk.PipelineParameters
        SET ParameterValue = CAST(@ParameterValue AS NVARCHAR(250))
        WHERE PipelineId = @PipelineId
        and ParameterName = @ParameterName
    END
    ELSE IF( NOT EXISTS(
        SELECT pp.* 
        FROM procfwk.PipelineParameters pp
        WHERE pp.PipelineId = @PipelineId
        and pp.ParameterName = TRIM(@ParameterName)
    )
    )
    BEGIN
        set @ErrorMessage = 'ParameterName ' + @ParameterName + ' does not exist for pipelineId' + @PipelineId
        PRINT @ErrorMessage
        RETURN;
    END
END

