

/* ===============================================================================================    
 Created By:   Kamran Ahmed    
 Created Date: 13/06/2025    
 Modified By:      
 Modified Date:     
 Purpose:  Update DatabricksFinOps Request Body 
      
 Change:    

      
=================================================================================================== */   
CREATE PROCEDURE [procdba].[UpdateDatabricksFinOps]
(
	@Id INT,
	@RequestBody NVARCHAR(MAX)
)
AS

BEGIN

	UPDATE [procfwk].[DatabricksFinOps] SET RequestBody = @RequestBody WHERE Id = @Id;

	SELECT @RequestBody = RequestBody  FROM [procfwk].[DatabricksFinOps] WHERE Id = @Id;

	PRINT @RequestBody
END;
