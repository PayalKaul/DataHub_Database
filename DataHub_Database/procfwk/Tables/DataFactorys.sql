CREATE TABLE [procfwk].[DataFactorys] (
    [DataFactoryId]           INT              IDENTITY (1, 1) NOT NULL,
    [DataFactoryName]         NVARCHAR (200)   NOT NULL,
    [ResourceGroupName]       NVARCHAR (200)   NOT NULL,
    [SubscriptionId]          UNIQUEIDENTIFIER NOT NULL,
    [Description]             NVARCHAR (MAX)   NULL,
    [Envirnoment]             NVARCHAR (50)    NULL,
    [NotificationRecipient]   NVARCHAR (200)   NULL,
    [NotificationAppURL]      NVARCHAR (MAX)   NULL,
    [SendSuccessNotification] BIT              DEFAULT ((0)) NULL,
    CONSTRAINT [PK_DataFactorys] PRIMARY KEY CLUSTERED ([DataFactoryId] ASC)
);

