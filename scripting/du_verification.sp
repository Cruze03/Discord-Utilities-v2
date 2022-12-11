#include <sourcemod>
#include <multicolors>

#include <discord>
#include <du2>

#pragma newdecls required
#pragma semicolon 1

const int g_iPrune = 60;
const int TIMEOUT_TIME = 30;

char g_sInviteLink[64];

char g_sChannelID[64], g_sChannelName[64], g_sMessageID[64], g_sGuildID[64], g_sRole[64], g_sCommand[5][256], g_sCommandInGame[5][256];
bool g_bPrimary = false, g_bAddMessage = false, g_bLate = false;
int g_iServerID = -1;

char g_sDatabaseName[64], g_sTableName[64], g_sUserID[MAXPLAYERS+1][64], g_sUniqueCode[MAXPLAYERS+1][64];
bool g_bChecked[MAXPLAYERS+1], g_bMember[MAXPLAYERS+1], g_bRoleGiven[MAXPLAYERS+1];

Database g_hDB;
bool g_bIsMySQl;

Handle g_hOnLinkedAccount, g_hOnAccountRevoked, g_hOnClientLoaded, g_hOnBlockedCommandUse, g_hDeleteTimer;

ArrayList g_hDeleteMessage;
StringMap g_smDeleteMessage;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("DUVerification_IsChecked", Native_IsChecked);
	CreateNative("DUVerification_IsMember", Native_IsDiscordMember);
	CreateNative("DUVerification_GetUserId", Native_GetUserId);

	g_hOnLinkedAccount = CreateGlobalForward("DUVerification_OnLinkedAccount", ET_Ignore, Param_Cell, Param_String, Param_String, Param_String);
	g_hOnAccountRevoked = CreateGlobalForward("DUVerification_OnAccountRevoked", ET_Ignore, Param_Cell, Param_String);
	g_hOnClientLoaded = CreateGlobalForward("DUVerification_OnClientLoaded", ET_Ignore, Param_Cell);
	g_hOnBlockedCommandUse = CreateGlobalForward("DUVerification_OnBlockedCommandUse", ET_Event, Param_Cell, Param_String);
	
	g_bLate = late;
	return APLRes_Success;
}

public int Native_IsChecked(Handle plugin, int numparams)
{
	return g_bChecked[GetNativeCell(1)];
}

public int Native_IsDiscordMember(Handle plugin, int numparams)
{
	if(!g_bChecked[GetNativeCell(1)])
	{
		return ThrowNativeError(25, "[Discord-Utilities] %N hasn't been checked. Call this in OnClientPostAdminCheck.", GetNativeCell(1));
	}
	return g_bMember[GetNativeCell(1)];
}

public int Native_GetUserId(Handle plugin, int numparams)
{
	if(!g_bChecked[GetNativeCell(1)])
	{
		return ThrowNativeError(25, "[Discord-Utilities] %N hasn't been checked. Call this in OnClientPostAdminCheck.", GetNativeCell(1));
	}
	if(!g_bMember[GetNativeCell(1)])
	{
		return ThrowNativeError(25, "[Discord-Utilities] %N isn't verified.", GetNativeCell(1));
	}

	SetNativeString(2, g_sUserID[GetNativeCell(1)], GetNativeCell(3));
	return 1;
}

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Verification",
	author = "Cruze",
	description = "Verification module to integrate.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_vr_deleteaccount", Command_DeleteAccount, ADMFLAG_ROOT, "Deletes steamid from discord utilities database.");
	RegAdminCmd("sm_vr_deletemessages", Command_DeleteMessages, ADMFLAG_ROOT);
	
	LoadTranslations("du_verification.phrases");
	
	if(g_bLate)
	{
		if(DUMain_IsConfigLoaded())
		{
			DUMain_OnConfigLoaded();
		}
		OnMapStart();
		g_bLate = false;
	}
}

public void DUMain_OnConfigLoaded()
{
	char sBuffer[256];
	DUMain_GetString("channel_verification", g_sChannelID, 64);
	DUMain_GetString("message_verification", g_sMessageID, 64);
	DUMain_GetString("guildid", g_sGuildID, 64);
	DUMain_GetString("roleid", g_sRole, 64);
	DUMain_GetString("command", g_sCommand[0], 256);
	DUMain_GetString("database_name", g_sDatabaseName, 64);
	DUMain_GetString("table_name", g_sTableName, 64);
	DUMain_GetString("invite_link", g_sInviteLink, 64);
	DUMain_GetString("use_swgm_for_blocked_commands", sBuffer, 8);

	DUMain_GetString("command_ingame", g_sCommandInGame[0], 256);
	
	ExplodeString(g_sCommand[0], ", ", g_sCommand, 5, 64);
	
	int count = ExplodeString(g_sCommandInGame[0], ", ", g_sCommandInGame, 5, 64), i;
	
	if(count > 0)
	{
		for(i = 0; i <= count; i++)
		{
			if(StrContains(g_sCommandInGame[i], "sm_") == 0)
			{
				if(!CommandExists(g_sCommandInGame[i]))
				{
					RegConsoleCmd(g_sCommandInGame[i], Command_Verify);
				}
			}
		}
	}
	else
	{
		if(StrContains(g_sCommandInGame[0], "sm_") == 0)
		{
			RegConsoleCmd(g_sCommandInGame[0], Command_Verify);
		}
	}
	
	

	char sBlockedCommands[512];
	DUMain_GetString("blocked_commands", sBlockedCommands, 512);

	char sValue[MAX_COMMANDS][64];
	count = ExplodeString(sBlockedCommands, ", ", sValue, MAX_COMMANDS, 64);

	if(count > 0)
	{
		for(i = 0; i <= count; i++)
		{
			if(StrContains(sValue[i], "sm_") == 0)
			{
				AddCommandListener(Command_Block, sValue[i]);
			}
		}
	}
	else
	{
		if(StrContains(sBlockedCommands[0], "sm_") == 0)
		{
			AddCommandListener(Command_Block, sBlockedCommands);
		}
	}
	
	if(StrContains(sBuffer, "1") == 0)
	{
		KeyValues kv = new KeyValues("Command_Listener");
		BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/swgm/command_listener.ini");
		if(!FileToKeyValues(kv, sBuffer))
		{
			LogError("[Discord-Utilities-v2] Missing config file %s. If you don't use SWGM, then change 'use_swgm_for_blocked_commands' under `VERIFICATION_SETTINGS` section value to 0.", sBuffer);
		}
		else
		{
			if(kv.GotoFirstSubKey())
			{
				do
				{
					if(kv.GetSectionName(sBuffer, 64) && StrContains(sBuffer, "sm_") == 0)
					{
						AddCommandListener(Command_Block, sBuffer);
					}
				}
				while (kv.GotoNextKey());
			}
		}
		delete kv;
	}

	char sBuf[64];
	DUMain_GetString("primary", sBuf, 64);
	g_bPrimary = !!StringToInt(sBuf);
	DUMain_GetString("serverid", sBuf, 64);
	g_iServerID = StringToInt(sBuf);

	if(strlen(g_sChannelID) < LEN_ID)
	{
		SetFailState("[DiscordUtilitiesv2-Verification] Channel ID is invalid. Plugin won't work.");
		return;
	}

	if(DUMain_Bot() != INVALID_HANDLE)
	{
		DUMain_Bot().GetChannel(g_sChannelID, OnChannelReceived);
	}
	if(g_sDatabaseName[0])
	{
		Database.Connect(SQLQuery_Connect, g_sDatabaseName);
	}
}

void AddMessage()
{
	if(DUMain_Bot() == INVALID_HANDLE)
	{
		return;
	}
	if(strlen(g_sChannelID) < LEN_ID)
	{
		return;
	}
	if(strlen(g_sMessageID) > LEN_ID)
	{
		return;
	}
	if(!g_bPrimary)
	{
		return;
	}
	char sBuf[666];
	
	DiscordMessage message = new DiscordMessage(" ");
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sBuf, 64, "%T", "DiscordVerificationInfoTitle", LANG_SERVER);
	
	embed.WithTitle(sBuf);
	
	Format(sBuf, 666, "%T", "DiscordVerificationInfo", LANG_SERVER, ChangePartsInString(g_sCommandInGame[0], "sm_", "!"));
	
	embed.WithDescription(sBuf);
	
	embed.WithImage(new DiscordEmbedImage("https://cdn.discordapp.com/attachments/756189500828549271/1010527915303239752/HowToGetLink.png", 90, 409));
	
	embed.WithFooter(new DiscordEmbedFooter("Powered by Discord Utilities v2"));
	
	embed.SetColor("#FF0000");
	
	message.Embed(embed);
	
	DUMain_Bot().SendMessageToChannelID(g_sChannelID, message);
	
	DisposeObject(message);
	
	LogMessage("[SM] Added a verification info message in the channel!");
	
	g_bAddMessage = true;
}

public Action Command_DeleteMessages(int client, int args)
{
	if(DUMain_Bot() == INVALID_HANDLE)
	{
		ReplyToCommand(client, "[SM] Bot is not working. Please re-check your bot token and reload the map.");
		return Plugin_Handled;
	}
	if(!strcmp(g_sChannelID, ""))
	{
		ReplyToCommand(client, "[SM] Channel ID is empty in config file. Kindly fill that out first.");
		return Plugin_Handled;
	}
	if(!strcmp(g_sMessageID, ""))
	{
		ReplyToCommand(client, "[SM] Message ID is empty in config file. Kindly let the plugin fill that out first.");
		return Plugin_Handled;
	}
	
	if(DUMain_Bot() != INVALID_HANDLE && g_sChannelID[0] && g_sMessageID[0])
	{
		DUMain_Bot().GetChannelMessagesID(g_sChannelID, _, _, g_sMessageID, 100, OnUnnecessaryMessagesReceived, GetClientSerial(client));
	}
	
	return Plugin_Handled;
}

public void OnMapStart()
{
	g_hDeleteMessage = new ArrayList(ByteCountToCells(64));
	g_smDeleteMessage = new StringMap();
	
	if(!g_bLate)
	{
		g_hDeleteTimer = null;
	}
	else
	{
		delete g_hDeleteTimer;
	}
	g_hDeleteTimer = CreateTimer(4.0, Timer_DeleteMessages, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_DeleteMessages(Handle timer)
{
	if(!g_bPrimary || !g_sChannelID[0])
	{
		return;
	}
	
	static int length;
	
	if((length = g_hDeleteMessage.Length) < 1)
	{
		return;
	}
	
	static int i, iValue;
	static char sID[64];
	
	int iTime = GetTime();
	
	for(i = 0; i < length; i++)
	{
		iValue = -1;
		g_hDeleteMessage.GetString(i, sID, 64);
		g_smDeleteMessage.GetValue(sID, iValue);
		
		if(iTime > iValue)
		{
			DUMain_Bot().DeleteMessageID(g_sChannelID, sID);
			g_hDeleteMessage.Erase(i);
			g_smDeleteMessage.Remove(sID);
			break;
		}
	}
}

public int SQLQuery_Connect(Database db, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-Connect] Database failure: %s", error);
		SetFailState("[Discord Utilities v2] Failed to connect to database");
	}
	else
	{
		delete g_hDB;

		g_hDB = db;
		
		char sQuery[4096];
		SQL_GetDriverIdent(SQL_ReadDriver(g_hDB), sQuery, sizeof(sQuery));
		g_bIsMySQl = StrEqual(sQuery, "mysql", false) ? true : false;
		
		if(g_bIsMySQl)
		{
			g_hDB.Format(sQuery, sizeof(sQuery), "CREATE TABLE IF NOT EXISTS `%s` (`ID` bigint(20) NOT NULL AUTO_INCREMENT, `userid` varchar(20) COLLATE utf8_bin NOT NULL, `steamid` varchar(20) COLLATE utf8_bin NOT NULL, `member` int(20) NOT NULL, `last_accountuse` int(64) NOT NULL, PRIMARY KEY (`ID`), UNIQUE KEY `steamid` (`steamid`) ) ENGINE = InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;", g_sTableName);
		}
		else
		{
			g_hDB.Format(sQuery, sizeof(sQuery), "CREATE TABLE IF NOT EXISTS %s (userid varchar(20) NOT NULL, steamid varchar(20) PRIMARY KEY NOT NULL, member int(20) NOT NULL, last_accountuse INTEGER)", g_sTableName);
			SQL_SetCharset(g_hDB, "utf8");
		}
		g_hDB.Query(SQLQuery_ConnectCallback, sQuery);
		PruneDatabase();
	}
	
	//For late load
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && !g_bChecked[client])
		{
			OnClientPreAdminCheck(client);
		}
	}
}

public int SQLQuery_ConnectCallback(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-ConnectCallback] Database failure: %s", error);
	}
}
	
public void PruneDatabase()
{
	if(g_hDB == null)
	{
		LogError("[DUv2-PruneDatabaseStart] Prune Database cannot connect to database.");
		return;
	}

	int maxlastaccuse = GetTime() - (g_iPrune * 86400);

	char sQuery[1024];

	if(g_bIsMySQl)
		g_hDB.Format(sQuery, sizeof(sQuery), "DELETE FROM `%s` WHERE `last_accountuse`<'%d' AND `last_accountuse`>'0' AND `member` = 0;", g_sTableName, maxlastaccuse);
	else
		g_hDB.Format(sQuery, sizeof(sQuery), "DELETE FROM %s WHERE last_accountuse<'%d' AND last_accountuse>'0' AND member = 0;", g_sTableName, maxlastaccuse);

	g_hDB.Query(SQLQuery_PruneDatabase, sQuery);
}

public int SQLQuery_PruneDatabase(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-PruneDatabase] Query failure: %s", error);
	}
}

public int SQLQuery_GetUserData(Database db, DBResultSet results, const char[] error, any userid)
{
	int client;
	
	/* Make sure the client didn't disconnect while the thread was running */
	
	if((client = GetClientOfUserId(userid)) == 0)
	{
		return;
	}
	
	if(db == null)
	{
		LogError("[DUv2-GetUserData] Query failure: %s", error);
		return;
	}
	if(results.RowCount == 0) 
	{
		char sSteam[32];
		char sQuery[256];
		GetClientAuthId(client, AuthId_Steam2, sSteam, sizeof(sSteam));
		if(g_bIsMySQl)
		{
			g_hDB.Format(sQuery, sizeof(sQuery), "INSERT INTO `%s`(ID, userid, steamid, member, last_accountuse) VALUES(NULL, '%s', '%s', '0', '0');", g_sTableName, NULL_STRING, sSteam);
		}
		else
		{
			g_hDB.Format(sQuery, sizeof(sQuery), "INSERT INTO %s(userid, steamid, member, last_accountuse) VALUES('%s', '%s', '0', '0');", g_sTableName, NULL_STRING, sSteam);
		}
		g_hDB.Query(SQLQuery_InsertNewPlayer, sQuery);
		OnClientPreAdminCheck(client);
		return;
	}
	while(results.FetchRow())
	{
		results.FetchString(0, g_sUserID[client], sizeof(g_sUserID));
		g_bMember[client] = !!results.FetchInt(1);
	}

	char sSteam64[32];
	GetClientAuthId(client, AuthId_SteamID64, sSteam64, sizeof(sSteam64));
	
	int uniqueNum = GetRandomInt(100000, 999999);
	Format(g_sUniqueCode[client], sizeof(g_sUniqueCode), "%i-%i-%s", g_iServerID, uniqueNum, sSteam64);
	
	g_bChecked[client] = true;
	
	if(DUMain_Bot() != INVALID_HANDLE && strlen(g_sGuildID) > LEN_ID && g_sUserID[client][0])
		DUMain_Bot().GetGuildMemberID(g_sGuildID, g_sUserID[client], INVALID_FUNCTION, OnGuildUserFailReceive);
	
	Call_StartForward(g_hOnClientLoaded);
	Call_PushCell(client);
	Call_Finish();
}

public void OnGuildUserFailReceive(DiscordBot bot, const char[] sUserID)
{
	int client = GetClientOfDiscordUserId(sUserID);
	
	if(client <= 0)
	{
		return;
	}
	
	char sSteam[32], sQuery[256];
	GetClientAuthId(client, AuthId_Steam2, sSteam, 32);
	if(g_bIsMySQl)
	{
		g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE `%s` SET `userid` = '%s', member = '0' WHERE `steamid` = '%s';", g_sTableName, NULL_STRING, sSteam);
	}
	else
	{
		g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE %s SET userid = '%s', member = '0' WHERE steamid = '%s';", g_sTableName, NULL_STRING, sSteam);
	}
	g_hDB.Query(SQLQuery_UpdatePlayer, sQuery);
	CPrintToChat(client, "%T %T", "ServerPrefix", client, "DiscordRevoked", client);
	
	g_sUserID[client][0] = '\0';
	g_bMember[client] = false;
	
	Call_StartForward(g_hOnAccountRevoked);
	Call_PushCell(client);
	Call_PushString(sUserID);
	Call_Finish();
}

public int SQLQuery_InsertNewPlayer(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-InsertNewPlayer] Query failure: %s", error);
	}
}

public int SQLQuery_CheckUserData(Database db, DBResultSet results, const char[] error, DataPack pack)
{
	if(db == null)
	{
		LogError("[DUv2-CheckUserData] Query failure: %s", error);
		return;
	}
	
	
	char sUserId[64], szUserName[32], szDiscriminator[6];
	char sReply[128];
	pack.Reset();
	int client = pack.ReadCell();
	pack.ReadString(sUserId, 64);
	pack.ReadString(szUserName, sizeof(szUserName));
	pack.ReadString(szDiscriminator, sizeof(szDiscriminator));
	delete pack;
	
	if(results.RowCount == 0) 
	{
		Format(sReply, sizeof(sReply), "%T", "DiscordNoRowFound", LANG_SERVER, sUserId);
		SendMessageToChannelID(g_sChannelID, sReply);
		return;
	}
	
	char sUserIdDB[64];
	while (results.FetchRow())
	{
		results.FetchString(0, sUserIdDB, 64);
	}

	
	if(!StrEqual(sUserIdDB, sUserId))
	{
		if(DUMain_Bot() != INVALID_HANDLE && strlen(g_sGuildID) > LEN_ID && strlen(g_sRole) > LEN_ID)
		{
			DUMain_Bot().AddRoleID(g_sGuildID, sUserId, g_sRole);
		}
		
		CPrintToChat(client, "%T %T", "ServerPrefix", client, "DiscordVerified", client, szUserName, szDiscriminator);
		g_bMember[client] = true;

		Format(g_sUserID[client], 64, sUserId);
		Format(sReply, sizeof(sReply), "%T", "DiscordLinked", LANG_SERVER, sUserId);
		SendMessageToChannelID(g_sChannelID, sReply);

		char sSteam[32];
		GetClientAuthId(client, AuthId_Steam2, sSteam, sizeof(sSteam));

		char sQuery[512];
		if(g_bIsMySQl)
		{
			g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE `%s` SET `userid` = '%s', member = 1 WHERE `steamid` = '%s';", g_sTableName, sUserId, sSteam);
		}
		else
		{
			g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE %s SET userid = '%s', member = 1 WHERE steamid = '%s'", g_sTableName, sUserId, sSteam);
		}
		g_hDB.Query(SQLQuery_LinkedAccount, sQuery);

		Call_StartForward(g_hOnLinkedAccount);
		Call_PushCell(client);
		Call_PushString(sUserId);
		Call_PushString(szUserName);
		Call_PushString(szDiscriminator);
		Call_Finish();
	}
	else
	{
		Format(sReply, sizeof(sReply), "%T", "DiscordAlreadyLinked", LANG_SERVER, sUserId);
		SendMessageToChannelID(g_sChannelID, sReply);
	}
}

void SendMessageToChannelID(const char[] channelid, const char[] sMessage)
{
	DiscordMessage dmMessage = new DiscordMessage(sMessage);
	DUMain_Bot().SendMessageToChannelID(channelid, dmMessage);
	DisposeObject(dmMessage);
}

void SendMessageToChannel(DiscordChannel channel, const char[] sMessage)
{
	DiscordMessage dmMessage = new DiscordMessage(sMessage);
	DUMain_Bot().SendMessageToChannel(channel, dmMessage);
	DisposeObject(dmMessage);
}

public int SQLQuery_LinkedAccount(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-LinkedAccount] Query failure: %s", error);
	}
}

public int SQLQuery_UpdatePlayer(Database db, DBResultSet results, const char[] error, any userid)
{
	if(db == null)
	{
		LogError("[DUv2-UpdatePlayer] Query failure: %s", error);
	}
}

public Action Command_DeleteAccount(int client, int args)
{
	if(g_hDB == null)
	{
		CReplyToCommand(client, "%T %T", "ServerPrefix", client, "TryAgainLater", client);
		return Plugin_Handled;
	}
	if(args != 1)
	{
		CReplyToCommand(client, "%T USAGE: sm_deleteaccount <playername>/STEAMID", "ServerPrefix", client);
		return Plugin_Handled;
	}
	char buffer[64], sQuery[512];
	GetCmdArg(1, buffer, sizeof(buffer));
	int iTarget = -1;
	if(StrContains(buffer, "STEAM_") == -1)
	{
		iTarget = FindTarget(client, buffer);
		if(iTarget == -1)
		{
			CReplyToCommand(client, "%T Invalid steamid format/playername. Please re-check!", "ServerPrefix", client);
			return Plugin_Handled;
		}
		GetClientAuthId(iTarget, AuthId_Steam2, buffer, sizeof(buffer));
	}
	if(g_bIsMySQl)
	{
		g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE `%s` SET `userid` = '%s', member = '0' WHERE `steamid` = '%s';", g_sTableName, NULL_STRING, buffer);
	}
	else
	{
		g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE %s SET userid = '%s', member = '0' WHERE steamid = '%s';", g_sTableName, NULL_STRING, buffer);
	}
	DataPack pack = new DataPack();
	if(client > 0)
		pack.WriteCell(GetClientSerial(client));
	else
		pack.WriteCell(0);
	if(iTarget != -1)
		pack.WriteCell(GetClientSerial(iTarget));
	else
		pack.WriteCell(-1);
	g_hDB.Query(SQLQuery_DeleteAccount, sQuery, pack);
	return Plugin_Handled;
}

public int SQLQuery_DeleteAccount(Database db, DBResultSet results, const char[] error, DataPack pack)
{
	if(db == null)
	{
		pack.Reset();
		delete pack;
		LogError("[DUv2-DeleteAccount] Query failure: %s", error);
		return;
	}
	pack.Reset();
	int userid = pack.ReadCell();
	int userid2 = pack.ReadCell();
	delete pack;
	int client, target;
	if((target = GetClientFromSerial(userid2)) > 0)
	{
		g_bMember[target] = false;
		g_sUserID[target][0] = '\0';
	}
	if(userid != 0 && (client = GetClientFromSerial(userid)) == 0)
	{
		return;
	}
	CReplyToCommand(client, "%T Successfully deleted account from database.", "ServerPrefix", client);
}

public void OnClientPutInServer(int client)
{
	g_bChecked[client] = false;
	g_bMember[client] = false;
	g_sUniqueCode[client][0] = '\0';
	g_sUserID[client][0] = '\0';
	g_bRoleGiven[client] = false;
}

public Action OnClientPreAdminCheck(int client)
{
	if(IsFakeClient(client) || g_hDB == null)
	{
		return;
	}
	char sQuery[512], sSteamID[32];
	
	GetClientAuthId(client, AuthId_Steam2, sSteamID, sizeof(sSteamID));
	
	g_hDB.Format(sQuery, sizeof(sQuery), "SELECT userid, member FROM %s WHERE steamid = '%s'", g_sTableName, sSteamID);
	g_hDB.Query(SQLQuery_GetUserData, sQuery, GetClientUserId(client));
}

public void OnClientDisconnect(int client)
{
	if(IsFakeClient(client) || g_hDB == null)
	{
		return;
	}
	UpdatePlayer(client);
}

void UpdatePlayer(int client)
{
	char sSteam[32], sQuery[512];
	
	GetClientAuthId(client, AuthId_Steam2, sSteam, 32);
	if(g_bIsMySQl)
	{
		g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE `%s` SET last_accountuse = '%d' WHERE `steamid` = '%s';", g_sTableName, GetTime(), sSteam);
	}
	else
	{
		g_hDB.Format(sQuery, sizeof(sQuery), "UPDATE %s SET last_accountuse = '%d' WHERE steamid = '%s'", g_sTableName, GetTime(), sSteam);
	}
	g_hDB.Query(SQLQuery_UpdatePlayer, sQuery, GetClientUserId(client));
}

public void OnChannelReceived(DiscordBot bot, DiscordChannel channel)
{
	if(channel == null)
	{
		SetFailState("[DiscordUtilitiesv2-Verification] Channel ID is invalid.");
		return;
	}
	
	g_sChannelName[0] = '#';
	channel.GetName(g_sChannelName[1], 64);
	
	DUMain_Bot().StartListeningToChannel(channel, OnMessageReceived);
	
	CreateTimer(5.0, Timer_AddMessage);
}

public Action Timer_AddMessage(Handle timer)
{
	AddMessage();
}

public void OnMessageReceived(DiscordBot bot, DiscordChannel channel, DiscordMessage message)
{
	char sMessageID[64];
	message.GetID(sMessageID, 64);
	int iTime = GetTime();
	
	if(message.Author.IsBot)
	{
		if(g_bAddMessage)
		{
			strcopy(g_sMessageID, 64, sMessageID);
			
			DUMain_SetString("message_verification", sMessageID, 64);
			DUMain_UpdateConfig();
			
			g_bAddMessage = false;
			DisposeObject(message);
			return;
		}
		if(strcmp(sMessageID, g_sMessageID) != 0 && sMessageID[0] && g_bPrimary)
		{
			g_smDeleteMessage.SetValue(sMessageID, iTime+TIMEOUT_TIME);
			g_hDeleteMessage.PushString(sMessageID);
		}
		DisposeObject(message);
		return;
	}
	
	char szMessage[256], sValue[2][64], sValue2[3][64], sReply[512], sUserID[64];
	char sUsername[MAX_DISCORD_USERNAME_LENGTH];
	char sDiscriminator[MAX_DISCORD_DISCRIMINATOR_LENGTH];
	
	message.GetContent(szMessage, 256);
	
	DiscordUser user = message.GetAuthor();
	
	message.Author.GetID(sUserID, 64);
	
	user.GetUsername(sUsername, MAX_DISCORD_USERNAME_LENGTH);

	user.GetDiscriminator(sDiscriminator, MAX_DISCORD_DISCRIMINATOR_LENGTH);
	
	DisposeObject(message);
	
	if(!szMessage[0])
	{
		new DiscordException("[verification] Message is empty. Make sure 'Message Content Intent' is enabled in bot settings. For more: [https://github.com/Cruze03/discord-utilities/wiki/Troubleshoot#discord-to-gameserver-is-sending-blank-message--verification-bot-is-not-responding-as-it-should]");
	}
	
	int count = ExplodeString(szMessage, " ", sValue, 2, 64);
	TrimString(sValue[1]);
	
	int count2 = ExplodeString(sValue[1], "-", sValue2, 3, 64);
	
	bool bCommand = false;
	
	for(int i = 0; i < 5; i++)
	{
		if(!g_sCommand[i][0] || strcmp(sValue[0], g_sCommand[i], false) != 0)
		{
			continue;
		}
		bCommand = true;
	}
	
	if(!bCommand)
	{
		if(g_bPrimary)
		{
			Format(sReply, 256, "%T", "DiscordInfo", LANG_SERVER, sUserID, g_sCommand[0]);
			SendMessageToChannel(channel, sReply);
			DUMain_Bot().DeleteMessageID(g_sChannelID, sMessageID);
		}
		return;
	}
	
	if (count != 2)
	{
		if (g_bPrimary)
		{
			Format(sReply, 256, "%T", "DiscordMissingParameters", LANG_SERVER, sUserID);
			SendMessageToChannel(channel, sReply);
			DUMain_Bot().DeleteMessageID(g_sChannelID, sMessageID);
		}
		return;
	}
	else if (count2 != 3)
	{
		if (g_bPrimary)
		{
			Format(sReply, 256, "%T", "DiscordInvalidID", LANG_SERVER, sUserID, g_sCommandInGame[0]);
			SendMessageToChannel(channel, sReply);
			DUMain_Bot().DeleteMessageID(g_sChannelID, sMessageID);
		}
		return;
	}
	int id = StringToInt(sValue2[0]);
	
	if(id != g_iServerID)
	{
		return;
	}
	
	int client = GetClientFromUniqueCode(sValue[1]);
	
	if(client <= 0)
	{
		Format(sReply, 256, "%T", "DiscordInvalid", LANG_SERVER, sUserID);
		SendMessageToChannel(channel, sReply);
		DUMain_Bot().DeleteMessageID(g_sChannelID, sMessageID);
		return;
	}
	if(g_bMember[client])
	{
		Format(sReply, 256, "%T", "DiscordAlreadyLinked", LANG_SERVER, sUserID);
		SendMessageToChannel(channel, sReply);
		DUMain_Bot().DeleteMessageID(g_sChannelID, sMessageID);
		return;
	}

	DataPack datapack = new DataPack();
	datapack.WriteCell(client);
	datapack.WriteString(sUserID);
	datapack.WriteString(sUsername);
	datapack.WriteString(sDiscriminator);

	char sSteam[32];
	GetClientAuthId(client, AuthId_Steam2, sSteam, 32);

	char sQuery[512];
	g_hDB.Format(sQuery, sizeof(sQuery), "SELECT userid FROM %s WHERE steamid = '%s'", g_sTableName, sSteam);
	g_hDB.Query(SQLQuery_CheckUserData, sQuery, datapack);
	
	
	GetClientAuthId(client, AuthId_SteamID64, sSteam, 32);
	
	int uniqueNum = GetRandomInt(100000, 999999);
	Format(g_sUniqueCode[client], sizeof(g_sUniqueCode), "%i-%i-%s", g_iServerID, uniqueNum, sSteam);
	
	Format(sReply, 512, "%T", "DiscordPleaseWait", LANG_SERVER, sUserID);
	SendMessageToChannel(channel, sReply);
	DUMain_Bot().DeleteMessageID(g_sChannelID, sMessageID);
}

stock int GetClientFromUniqueCode(const char[] unique)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i))
			continue;
		if(IsFakeClient(i))
			continue;
		if(!strcmp(g_sUniqueCode[i], unique))
			return i;
	}
	return -1;
}

stock int GetClientOfDiscordUserId(const char[] userid)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i))
			continue;
		if(IsFakeClient(i))
			continue;
		if(!strcmp(g_sUserID[i], userid))
			return i;
	}
	return -1;
}

public Action Command_Verify(int client, int args)
{
	if(!client || !IsClientInGame(client) || !strcmp(g_sChannelID, ""))
	{
		return Plugin_Handled;
	}
	if(!g_bChecked[client])
	{
		CReplyToCommand(client, "%T %T", "ServerPrefix", client, "TryAgainLater", client);
		return Plugin_Handled;
	}
	if(g_bMember[client])
	{
		CReplyToCommand(client, "%T %T", "ServerPrefix", client, "DiscordAlreadyMember", client);
		return Plugin_Handled;
	}
	
	CPrintToChat(client, "%T %T", "ServerPrefix", client, "LinkConnect", client);
	CPrintToChat(client, "%T {orange}%s{default}", "ServerPrefix", client, g_sInviteLink);
	CPrintToChat(client, "%T %T", "ServerPrefix", client, "LinkUsage", client, g_sCommand[0], g_sUniqueCode[client], g_sChannelName);
	CPrintToChat(client, "%T %T", "ServerPrefix", client, "CopyPasteFromConsole", client);

	char buf[128], g_sServerPrefix2[128];
	Format(g_sServerPrefix2, sizeof(g_sServerPrefix2), "%T", "ServerPrefix", client);
	for(int i = 0; i < sizeof(C_Tag); i++)
	{
		ReplaceString(g_sServerPrefix2, sizeof(g_sServerPrefix2), C_Tag[i], "");
	}
	
	PrintToConsole(client, "*****************************************************");
	PrintToConsole(client, "%s %T", g_sServerPrefix2, "LinkConnect", client, g_sInviteLink);
	PrintToConsole(client, "%s %s", g_sServerPrefix2, g_sInviteLink);
	Format(buf, sizeof(buf), "%T", "LinkUsage", client, g_sCommand[0], g_sUniqueCode[client], g_sChannelName);
	for(int i = 0; i < sizeof(C_Tag); i++)
	{
		ReplaceString(buf, sizeof(buf), C_Tag[i], "");
	}
	PrintToConsole(client, "%s %s", g_sServerPrefix2,  buf);
	PrintToConsole(client, "*****************************************************");
	
	return Plugin_Handled;
}

public Action Command_Block(int client, const char[] command, int args)
{
	if(!client)
	{
		return Plugin_Continue;
	}
	if(!IsClientInGame(client))
	{
		return Plugin_Continue;
	}
	Action action = Plugin_Handled;
	Call_StartForward(g_hOnBlockedCommandUse);
	Call_PushCell(client);
	Call_PushString(command);
	Call_Finish(action);
	if(action == Plugin_Continue)
	{
		return Plugin_Continue;
	}
	else if(action > Plugin_Handled)
	{
		return action;
	}
	if(!g_bMember[client])
	{
		CPrintToChat(client, "%T %T", "ServerPrefix", client, "MustVerify", client, ChangePartsInString(g_sCommandInGame[0], "sm_", "!"));
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

stock char[] ChangePartsInString(char[] input, const char[] from, const char[] to)
{
	char output[64];
	strcopy(output, sizeof(output), input);
	ReplaceString(output, sizeof(output), from, to);
	return output;
}

public void OnUnnecessaryMessagesReceived(DiscordBot bot, DiscordMessageList messages, int serial)
{
	int client;
	if((client = GetClientFromSerial(serial)) < 1)
	{
		return;
	}
	
	int count = messages.Length;
	if(count < 2)
	{
		ReplyToCommand(client, "[SM] Less than 2 messages cannot be deleted. Delete it manually.");
		return;
	}
	
	DUMain_Bot().DeleteMessagesBulk(g_sChannelID, messages);
	DisposeObject(messages);
	
	
	ReplyToCommand(client, "[SM] Deleted upto 100 messages from %s channel", g_sChannelName);
}
