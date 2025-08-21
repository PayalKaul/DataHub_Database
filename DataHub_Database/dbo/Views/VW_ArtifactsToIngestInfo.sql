



CREATE VIEW [dbo].[VW_ArtifactsToIngestInfo]
AS
/*
	Created By: Kamran Ahmed
	Created Date: 14/28/2025
	Modified By: 
	Modified Date: dd/MM/yyyy
	Description: This view provides information about the ArtifactsToIngest
	Change Log: 
		- dd/MM/yyyy - KA - Description
		Test
*/
SELECT 
	 ATI.[id] AS ArtifactsToIngestID
	,ATI.[SourceSystem] AS ContainerName
	,ATI.[UpsertDate]
	,ATI.[ArtifactSource]
	,ATI.[ArtifactContainer]
	,ATI.[ArtifactPath]
	,ATI.[ArtifactName]
	,ATI.[DestinationStorageAccount]
	,ATI.[DestinationContainer]
	,ATI.[DestinationPath]
	,ATI.[DatabricksWorkspaceUrl]
	,ATI.[DatabricksWorkspaceResourceId]
	,ATI.[BronzeNotebookPath]
	,ATI.[SilverNotebookPath]
	,ATI.[BronzeNotebookSpecification]
	,ATI.[SilverNotebookSpecification]
	,CASE 
		WHEN ISNULL(ATIP.ContainerName,'')='' THEN 'ArtifactsToIngestID' ELSE 'ContainerName'
	END AS JOIN_TYPE
	, ATIP.[ParameterName]
	, ATIP.[ParameterValue]
	, ATIP.[Description]
FROM 
	[dbo].[ArtifactsToIngest] ATI
LEFT JOIN 
	[dbo].[ArtifactsToIngestParameters] ATIP ON (ATI.id = ATIP.[ArtifactsToIngestId] OR ATI.SourceSystem = ATIP.ContainerName)

 
