CREATE VIEW [dbo].[VW_Permissions] AS
SELECT Q.PrincipalName,Q.MemberOf,Q.[Type],Q.Object,Q.ObjectName,STRING_AGG(Q.Permission,', ') AS Permission FROM
	(SELECT 
		rp.name							AS PrincipalName,
		ISNULL(p.Parent,'')				AS MemberOf, 
		--rp.[type]						AS [Type], 
		rp.type_desc					AS [Type],
		--rp.authentication_type_desc		AS AuthenticationType,
		--rp.default_schema_name			AS DefaultSchema,
		--pe.class						AS Class,
		pe.class_desc					AS Object,
		CASE pe.class_desc 
			WHEN 'SCHEMA'			THEN sch.name
			WHEN 'ASYMMETRIC_KEY'	THEN ask.name
			ELSE DB_NAME()
		END								AS ObjectName,
		pe.permission_name				AS Permission
	FROM  sys.database_principals AS rp
	INNER JOIN sys.database_permissions pe ON rp.principal_id = pe.grantee_principal_id
	LEFT JOIN sys.schemas sch ON sch.schema_id = pe.major_id AND pe.class_desc = 'SCHEMA'
	LEFT JOIN sys.asymmetric_keys ask ON ask.asymmetric_key_id = pe.major_id AND pe.class_desc = 'ASYMMETRIC_KEY'
	OUTER APPLY (SELECT STRING_AGG(rm.DatabaseRole,', ') AS Parent FROM dbo.VW_RoleMembers rm WHERE rm.RoleMember = rp.name) p 
	WHERE rp.name NOT IN ('public','guest')
	)Q 
GROUP BY
Q.PrincipalName,Q.MemberOf,Q.[Type],Q.Object,Q.ObjectName	