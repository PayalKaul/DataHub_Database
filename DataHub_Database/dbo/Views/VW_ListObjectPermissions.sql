CREATE VIEW [dbo].[VW_ListObjectPermissions] AS
WITH RoleMembers(member_principal_id, role_principal_id) AS 
(
	SELECT        member_principal_id, role_principal_id
	FROM            sys.database_role_members AS rm1 WITH (NOLOCK)

	UNION ALL

    SELECT        d.member_principal_id, rm.role_principal_id
    FROM            sys.database_role_members AS rm WITH (NOLOCK) 
	INNER JOIN   RoleMembers AS d ON rm.member_principal_id = d.role_principal_id
)

SELECT DISTINCT rp.name AS DatabaseRole, ISNULL(mp.name, 'No Members') AS DatabaseUser, rp.type AS Type, rp.type_desc AS TypeDescription
, rp.default_schema_name AS DefaultSchemaName, rp.authentication_type AS AuthenticationType 
, rp.authentication_type_desc AS AuthenticationTypeDescription
FROM  RoleMembers AS drm 
RIGHT OUTER JOIN sys.database_principals AS rp ON drm.role_principal_id = rp.principal_id 
LEFT OUTER JOIN sys.database_principals AS mp ON drm.member_principal_id = mp.principal_id
--WHERE mp.name = 'GRP-SEC-GLB-BIAA-Contributor-DataEngineer-Dev'
--ORDER BY database_role
