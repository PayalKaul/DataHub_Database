







/*
	Created By: Kamran Ahmed
	Created Date: 06-02-2025
	Modified By: 
	Modified Date: 
	Description: Failed pipelines including Monitoring URL (%2F is used for forward slash)
	Change Log: 
	NOTE: Providing informtion for notification in the view 
	becuase it is poissible that in future notification receipient may differ from container to container
	right now it is coming from DataFactorys table but it may come from containers
*/

CREATE VIEW [procfwk].[VW_GetPipelinesExecutionResult]
AS
WITH CTE_MAIN AS(
	SELECT 
		 LG.LocalExecutionId
		,LG.StageId
		,LG.PipelineId
		,LG.ContainerName
		,LG.PipelineName
		,LG.StartDateTime
		,LG.PipelineStatus
		,LG.EndDateTime
		,LOWER(LG.AdfBatchRunId)AdfBatchRunId
		,LOWER(LG.AdfStageRunId)AdfStageRunId
		,LOWER(LG.AdfWorkerRunId)AdfWorkerRunId
		,LOWER(LG.AdfPipelineRunId)AdfPipelineRunId
		,LG.PipelineParamsUsed 
		,CONCAT('https://adf.azure.com/en/monitoring/pipelineruns/',
			LOWER(LG.AdfBatchRunId),
			'?factory=%2Fsubscriptions%2F',
			LOWER(DF.SubscriptionId),
			'%2FresourceGroups%2F',
			DF.ResourceGroupName,
			'%2Fproviders%2FMicrosoft.DataFactory%2Ffactories%2F',
			DF.DataFactoryName
			) AS BatchPipelineURL
			,CONCAT('https://adf.azure.com/en/monitoring/pipelineruns/',
			LOWER(LG.AdfStageRunId),
			'?factory=%2Fsubscriptions%2F',
			LOWER(DF.SubscriptionId),
			'%2FresourceGroups%2F',
			DF.ResourceGroupName,
			'%2Fproviders%2FMicrosoft.DataFactory%2Ffactories%2F',
			DF.DataFactoryName
			) AS StagePipelineURL
			,CONCAT('https://adf.azure.com/en/monitoring/pipelineruns/',
			LOWER(LG.AdfWorkerRunId),
			'?factory=%2Fsubscriptions%2F',
			LOWER(DF.SubscriptionId),
			'%2FresourceGroups%2F',
			DF.ResourceGroupName,
			'%2Fproviders%2FMicrosoft.DataFactory%2Ffactories%2F',
			DF.DataFactoryName
			) AS WorkerPipelineURL
		,CONCAT('https://adf.azure.com/en/monitoring/pipelineruns/',
			LOWER(LG.AdfPipelineRunId),
			'?factory=%2Fsubscriptions%2F',
			LOWER(DF.SubscriptionId),
			'%2FresourceGroups%2F',
			DF.ResourceGroupName,
			'%2Fproviders%2FMicrosoft.DataFactory%2Ffactories%2F',
			DF.DataFactoryName
			) AS ProcessingPipelineURL,
			DF.Envirnoment,
			DF.NotificationRecipient,
			DF.NotificationAppURL,
			DF.SendSuccessNotification
	FROM [procfwk].[ExecutionLogTT] LG,[procfwk].[DataFactorys] DF
	)

SELECT 
	LG.*,
	CASE
		WHEN LGI.LocalExecutionId IS NULL THEN 'Success' ELSE 'Failed'
	END AS ExecutionStatus
FROM 
	CTE_MAIN LG
	OUTER APPLY (SELECT TOP 1 LGI.LocalExecutionId FROM [procfwk].[ExecutionLogTT] LGI 
					WHERE LGI.LocalExecutionId = LG.LocalExecutionId 
					AND LGI.PipelineStatus != 'Success') LGI
