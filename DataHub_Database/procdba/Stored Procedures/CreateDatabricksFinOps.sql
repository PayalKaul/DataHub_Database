


/* ===============================================================================================    
 Created By:   Kamran Ahmed    
 Created Date: 25/06/2025    
 Modified By:      
 Modified Date:     
 Purpose:  Create DatabricksFinOps 
      
 Change:    

      
=================================================================================================== */   
CREATE PROCEDURE [procdba].[CreateDatabricksFinOps]
(
	@ContainerName NVARCHAR(500),
	@PolicyId	NVARCHAR(500)
)
AS

BEGIN
	INSERT INTO  [procfwk].[DatabricksFinOps]
	(
		[ContainerName],
		[RequestBody],
		[RequestRelativeURL],
		[RequestStatustRelativeURL],
		[RequestResultRelativeURL],
		[AccessTokenRelativeURL],
		[BearerClientId],
		[BearerClientSecret],
		[KeyVaultResource]
	)
	 VALUES(
		 @ContainerName,
		 '{
				"run_name": "{param_run_name}",
				"email_notifications": {
					"no_alert_for_skipped_runs": false
				},
				"timeout_seconds": 0,
				"max_concurrent_runs": 1,
				"tasks": [
					{
						"task_key": "{param_task_key}",
						"run_if": "ALL_SUCCESS",
						"notebook_task": {
							"notebook_path": "{param_notebook_path}",
							"base_parameters": {
								"parameters": "{param_base_parameters}"
							},
							"source": "WORKSPACE"
						},
						"timeout_seconds": 0
					}
				],
				"queue": {
					"enabled": true
				},
				"budget_policy_id": "'+@PolicyId+'",
				"run_as": {
					"service_principal_name": "acd3a9b6-180c-4b50-a5eb-e0ba227ce980"
				},
				"access_control_list": [
					{
						"group_name": "GRP-SEC-GLB-BIAA-Contributor-DataEngineer-Dev",
						"permission_level": "CAN_MANAGE_RUN"
					}
				]
			}',
		'api/2.1/jobs/runs/submit',
		'api/2.1/jobs/runs/get',
		'api/2.1/jobs/runs/get-output',
		'oidc/v1/token',
		'https://kv-datahubcnc-dev-01.vault.azure.net/secrets/databricks-client-id?api-version=7.4', 
		'https://kv-datahubcnc-dev-01.vault.azure.net/secrets/databricks-client-secret?api-version=7.4',
		'https://vault.azure.net'
	 )
END;
