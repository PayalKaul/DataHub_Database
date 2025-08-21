CREATE TABLE [bckup].[DatabricksFinOps] (
    [Id]                        INT            IDENTITY (1, 1) NOT NULL,
    [ContainerName]             NVARCHAR (255) NOT NULL,
    [RequestBody]               NVARCHAR (MAX) NOT NULL,
    [RequestRelativeURL]        NVARCHAR (255) NOT NULL,
    [RequestStatustRelativeURL] NVARCHAR (255) NOT NULL,
    [RequestResultRelativeURL]  NVARCHAR (255) NOT NULL,
    [AccessTokenRelativeURL]    NVARCHAR (255) NOT NULL,
    [BearerClientId]            NVARCHAR (255) NOT NULL,
    [BearerClientSecret]        NVARCHAR (255) NOT NULL,
    [KeyVaultResource]          NVARCHAR (255) NOT NULL
);

