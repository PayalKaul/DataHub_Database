CREATE TABLE [bckup].[ArtifactsToIngest] (
    [id]                            INT             IDENTITY (1, 1) NOT NULL,
    [SourceSystem]                  NVARCHAR (255)  NOT NULL,
    [UpsertDate]                    DATE            NOT NULL,
    [ArtifactSource]                NVARCHAR (1000) NOT NULL,
    [ArtifactContainer]             NVARCHAR (1000) NOT NULL,
    [ArtifactPath]                  NVARCHAR (1000) NOT NULL,
    [ArtifactName]                  NVARCHAR (255)  NOT NULL,
    [DestinationStorageAccount]     NVARCHAR (255)  NOT NULL,
    [DestinationContainer]          NVARCHAR (255)  NOT NULL,
    [DestinationPath]               NVARCHAR (255)  NOT NULL,
    [DatabricksWorkspaceUrl]        NVARCHAR (255)  NULL,
    [DatabricksWorkspaceResourceId] NVARCHAR (255)  NULL,
    [BronzeNotebookPath]            NVARCHAR (255)  NULL,
    [BronzeNotebookSpecification]   NVARCHAR (1000) NULL,
    [SilverNotebookPath]            NVARCHAR (255)  NULL,
    [SilverNotebookSpecification]   NVARCHAR (1000) NULL
);

