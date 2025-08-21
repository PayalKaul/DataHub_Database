CREATE TABLE [bckup].[ArtifactsToIngestParameters] (
    [ParameterId]         INT            IDENTITY (1, 1) NOT NULL,
    [ArtifactsToIngestId] INT            NOT NULL,
    [ContainerName]       NVARCHAR (255) NULL,
    [ParameterName]       VARCHAR (128)  NOT NULL,
    [ParameterValue]      NVARCHAR (MAX) NOT NULL,
    [Description]         NVARCHAR (MAX) NULL
);

