/* ===============================================================================================    
 Created By:   Kamran Ahmed    
 Created Date: 03/12/2024    
 Modified By:      
 Modified Date:     
 Purpose:  Provide Pivot Data for ArtifactsToIngestParameters table
      
 Change:    
		12/03/2025	KA	To make ArtifactsToIngestParameters more flexible, paratmers will be added by id, 
						or by source system and will be picked for each ArtifactsToIngestId
		06/05/2025	KA	SET @cols=ISNULL(@cols,'[temp]') added
		12/06/2025	KA	Added a featuer if an artifactToIngestparameter contains same property as defined for a container 
						then exclusive id will get precedence
      
=================================================================================================== */   
CREATE PROCEDURE [dbo].[GetArtifactsToIngestParameters]
(
	@ArtifactsToIngestId INT
)
AS

BEGIN
	SET NOCOUNT ON;
     DECLARE @cols AS NVARCHAR(MAX),
            @query  AS NVARCHAR(MAX)

    SELECT @cols = STUFF(
						(SELECT ',' + QUOTENAME(ATIP.ParameterName) 
							FROM dbo.ArtifactsToIngest ATI
									JOIN dbo.ArtifactsToIngestParameters ATIP ON 
										(ATIP.ArtifactsToIngestId = ATI.id 
											OR (ATIP.ContainerName = ATI.SourceSystem AND ATIP.ParameterName NOT IN 
													(SELECT ParameterName FROM dbo.ArtifactsToIngestParameters 
															WHERE ArtifactsToIngestId =@ArtifactsToIngestId 
													)
												)
										)
									WHERE ATI.id = @ArtifactsToIngestId
							FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')
	--If there is no data then it will return atleast hearders without data
	SET @cols=ISNULL(@cols,'[temp]')

	SET @query = N'SELECT ' + CAST(@ArtifactsToIngestId AS VARCHAR) + 'AS ArtifactsToIngestId,' + @cols +  N' from 
				(
					SELECT ATIP.ParameterValue, ATIP.ParameterName FROM dbo.ArtifactsToIngest ATI
					JOIN dbo.ArtifactsToIngestParameters ATIP ON 
						(ATIP.ArtifactsToIngestId = ATI.id 
							OR (ATIP.ContainerName = ATI.SourceSystem AND ATIP.ParameterName NOT IN 
									(SELECT ParameterName FROM dbo.ArtifactsToIngestParameters 
										WHERE ArtifactsToIngestId = ' + CAST(@ArtifactsToIngestId AS VARCHAR) + N' 
									)
								)
							)
					WHERE ATI.id =' + CAST(@ArtifactsToIngestId AS VARCHAR) + N') x
				PIVOT 
				(
					MAX(parameterValue)
					FOR ParameterName IN (' + @cols + N')
				) p '
	exec sp_executesql @query;

END;



/*
BEGIN
	SET NOCOUNT ON;
     DECLARE @cols AS NVARCHAR(MAX),
            @query  AS NVARCHAR(MAX)

    SELECT @cols = STUFF(
							(SELECT ',' + QUOTENAME(ATIP.ParameterName) 
								FROM dbo.ArtifactsToIngest ATI
										JOIN dbo.ArtifactsToIngestParameters ATIP ON (ATIP.ArtifactsToIngestId = ATI.id OR (ATIP.ContainerName = ATI.SourceSystem AND ATI.id = @ArtifactsToIngestId ))
										WHERE ATI.id = @ArtifactsToIngestId
								FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')
	--If there is no data then it will return atleast hearders without data
	SET @cols=ISNULL(@cols,'[temp]')

	SET @query = N'SELECT ' + CAST(@ArtifactsToIngestId AS VARCHAR) + 'AS ArtifactsToIngestId,' + @cols +  N' from 
				(
					SELECT ATIP.ParameterValue, ATIP.ParameterName FROM dbo.ArtifactsToIngest ATI
					JOIN dbo.ArtifactsToIngestParameters ATIP ON (ATIP.ArtifactsToIngestId = ATI.id OR (ATIP.ContainerName = ATI.SourceSystem AND ATI.id =' + CAST(@ArtifactsToIngestId AS VARCHAR) + N' ))
					WHERE ATI.id =' + CAST(@ArtifactsToIngestId AS VARCHAR) + N') x
				PIVOT 
				(
					MAX(parameterValue)
					FOR ParameterName IN (' + @cols + N')
				) p '
	exec sp_executesql @query;

END;

*/