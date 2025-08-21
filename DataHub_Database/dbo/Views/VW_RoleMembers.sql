
CREATE VIEW [dbo].[VW_RoleMembers]
AS
	SELECT 
		rp.name							AS DatabaseRole, 
		rp.is_fixed_role				AS RoleType,
		ISNULL(rpmn.name, 'No Members') AS RoleMember,
		rpmn.[type]						AS MemberType, 
		rpmn.type_desc					AS MemberTypeDesc,
		rpmn.authentication_type_desc	AS MemberAuthenticationType
		--rp.default_schema_name 
		--rp.authentication_type, 
	FROM  sys.database_principals AS rp
	--Role to Member
	LEFT OUTER JOIN sys.database_role_members AS rpm   ON rpm.role_principal_id = rp.principal_id 
	LEFT OUTER JOIN sys.database_principals AS rpmn ON rpm.member_principal_id = rpmn.principal_id
	--WHERE  rp.type = 'R'
	--ORDER BY rp.is_fixed_role,rp.name,rpmn.name