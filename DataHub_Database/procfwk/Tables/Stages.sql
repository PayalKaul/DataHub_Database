CREATE TABLE [procfwk].[Stages] (
    [StageId]          INT            IDENTITY (1, 1) NOT NULL,
    [StageName]        VARCHAR (225)  NOT NULL,
    [StageDescription] VARCHAR (4000) NULL,
    [Enabled]          BIT            CONSTRAINT [DF_Stages_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Stages] PRIMARY KEY CLUSTERED ([StageId] ASC)
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
CREATE TRIGGER [procfwk].[TRIG_DELETE_Stages] ON [procfwk].[Stages]
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
CREATE TRIGGER [procfwk].[TRIG_UPDATE_Stages] ON [procfwk].[Stages]
  FOR UPDATE
AS BEGIN

SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM INSERTED) > 1 
    BEGIN
        ROLLBACK;
        THROW 50001, 'More than 1 row can not be updated!', 1;
    END
END;
