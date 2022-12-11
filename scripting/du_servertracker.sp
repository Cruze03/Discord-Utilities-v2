#include <sourcemod>

#include <discord>
#include <du2>

bool g_bPrimary;
int g_iServerID;
char g_sTableName[64], g_sDatabaseName[64], g_sServerName[128];
Database g_hDB;

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Server Tracker",
	author = "Cruze",
	description = "Track which server is using which server id and which server is primary.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public void DUMain_OnConfigLoaded()
{
	char sBuf[64];
	DUMain_GetString("primary", sBuf, 64);
	g_bPrimary = !!StringToInt(sBuf);
	DUMain_GetString("serverid", sBuf, 64);
	g_iServerID = StringToInt(sBuf);
	
	DUMain_GetString("database_name", g_sDatabaseName, 64);
	DUMain_GetString("servers_table_name", g_sTableName, 64);
	
	if(!g_sTableName[0])
	{
		Format(g_sTableName, 64, "du_servers");
	}

	if(g_sDatabaseName[0])
	{
		Database.Connect(SQLQuery_Connect, g_sDatabaseName);
	}
	
	FindConVar("hostname").GetString(g_sServerName, 128);
}

public int SQLQuery_Connect(Database db, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-ST-Connect] Database failure: %s", error);
		SetFailState("[Discord Utilities v2 Server Tracker] Failed to connect to database");
	}
	else
	{
		delete g_hDB;

		g_hDB = db;
		
		char sQuery[4096];
		SQL_GetDriverIdent(SQL_ReadDriver(g_hDB), sQuery, sizeof(sQuery));
		bool bIsMySQl = StrEqual(sQuery, "mysql", false) ? true : false;
		
		if(!bIsMySQl)
		{
			SetFailState("[Discord Utilities v2 Server Tracker] Only MySQL supported.");
			return;
		}
		
		g_hDB.Format(sQuery, sizeof(sQuery), "CREATE TABLE IF NOT EXISTS `%s` (`server_id` int(16) NOT NULL, `server_name` varchar(128) COLLATE utf8_bin NOT NULL, `primary` int(16) NOT NULL, PRIMARY KEY (`server_id`, `server_name`)) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;", g_sTableName);
		g_hDB.Query(SQLQuery_ConnectCallback, sQuery);
	}
}

public int SQLQuery_ConnectCallback(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-ST-ConnectCallback] Query failure: %s", error);
		return;
	}
	char sQuery[1024];
	g_hDB.Format(sQuery, sizeof(sQuery), "SELECT * FROM `%s` WHERE `server_id` = '%i' AND `server_name` = '%s'", g_sTableName, g_sServerName, g_iServerID);
	g_hDB.Query(SQLQuery_SelectServers, sQuery);
}

public int SQLQuery_SelectServers(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-ST-SelectServers] Query failure: %s", error);
		return;
	}
	if(results.RowCount > 0) 
	{
		return;
	}
	
	char sQuery[1024];
	g_hDB.Format(sQuery, sizeof(sQuery), "INSERT INTO `%s`(`server_id`, `server_name`, `primary`) VALUES('%i', '%s', '%i');", g_sTableName, g_iServerID, g_sServerName, g_bPrimary);
	g_hDB.Query(SQLQuery_SelectServerCallback, sQuery);
}

public int SQLQuery_SelectServerCallback(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-ST-SelectServerCallback] Query failure: %s", error);
	}
}