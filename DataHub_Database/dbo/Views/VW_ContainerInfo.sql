CREATE VIEW [dbo].[VW_ContainerInfo]
AS
/*
	Created By: Kamran Ahmed
	Created Date: 25/11/2024
	Modified By: 
	Modified Date: dd/MM/yyyy
	Description: This view provides information about the container and loading pipeline by stage
				Each pipeline takes Container Name parameter along with [procfwk].[PipelineParameters] tables 
	Change Log: 
		- dd/MM/yyyy - KA - Description
*/
SELECT 
	con.ContainerId,con.ContainerName,con.Description,con.Enabled,
	pip.PipelineId,pip.PipelineName,pip.StageId
FROM procfwk.Containers con 
	LEFT JOIN procfwk.ContainersPipelines cop on con.ContainerId = cop.ContainerId 
	LEFT JOIN  procfwk.Pipelines pip on cop.PipelineId = pip.PipelineId
 