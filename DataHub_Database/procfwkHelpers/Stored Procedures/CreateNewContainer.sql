/*   
=============================================  
Author:        
Create date: Oct 2020  
Description: Helper to create Pipelines     
Change Control Log:  
YYYYMMDD  Who           Details  
20210120  KennyBui      Prevent duplicate ContainerName 
=============================================  
*/
      CREATE PROCEDURE [procfwkHelpers].[CreateNewContainer] (@ContainerName NVARCHAR( 200), @Description NVARCHAR( 200), @Enabled BIT) AS 
      BEGIN
         -- 20210120 KennyBui change starts here
         IF exists
         (
            SELECT
               * 
            FROM
               procfwk.containers 
            WHERE
               containername = @ContainerName
         )
         BEGIN
            PRINT 'The ContainerName already exists';
            RETURN;
         END
         -- 20210120 KennyBui change ends here
         INSERT INTO
            [procfwk].[containers] (containername, description, enabled) 
         VALUES
            (
               @ContainerName,
               @Description,
               @Enabled 
            )
      END
;
