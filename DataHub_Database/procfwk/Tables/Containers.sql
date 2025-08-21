CREATE TABLE [procfwk].[Containers] (
    [ContainerId]   INT            IDENTITY (1, 1) NOT NULL,
    [ContainerName] NVARCHAR (200) NOT NULL,
    [Description]   NVARCHAR (200) NULL,
    [Enabled]       BIT            CONSTRAINT [DF_Containers_Enabled] DEFAULT ((1)) NOT NULL,
    [Debug]         BIT            CONSTRAINT [DF_Containers_Debug] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Containers] PRIMARY KEY CLUSTERED ([ContainerId] ASC)
);


GO

/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to delete more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [procfwk].[TRIG_DELETE_Containers] ON [procfwk].[Containers]
  FOR DELETE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM DELETED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be deleted!', 1;
    END
END;

GO

/* ===============================================================================================
	Created By:			Kamran Ahmed
	Created Date:		04/12/2024
	Modified By:		
	Modified Date:	
	Purpose:		This trigger prevents to update more than 1 row to avoid disaster
	Change:
		
=================================================================================================== */
CREATE TRIGGER [procfwk].[TRIG_UPDATE_Containers] ON [procfwk].[Containers]
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
