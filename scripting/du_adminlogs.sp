#include <sourcemod>

#include <discord>
#include <du2>

#pragma newdecls required
#pragma semicolon 1

char g_sServerName[128], g_sMap[PLATFORM_MAX_PATH], g_sChannelID[64];
bool g_bLate = false;

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Admin logs",
	author = "Cruze",
	description = "Puts all admin logs in a discord channel",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_bLate = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	if(g_bLate)
	{
		if(DUMain_IsConfigLoaded())
		{
			DUMain_OnConfigLoaded();
		}
		OnAutoConfigsBuffered();
		g_bLate = false;
	}
	LoadTranslations("du_adminlogs.phrases");
}

public void OnAutoConfigsBuffered()
{
	CreateTimer(1.0, Timer_OnAutoConfigsBuffered, _, TIMER_FLAG_NO_MAPCHANGE);		//Multimod support
}

public Action Timer_OnAutoConfigsBuffered(Handle timer)
{
	FindConVar("hostname").GetString(g_sServerName, sizeof(g_sServerName));
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, PLATFORM_MAX_PATH);
	GetMapDisplayName(map, g_sMap, sizeof(g_sMap));
}

public void DUMain_OnConfigLoaded()
{
	DUMain_GetString("channel_adminlog", g_sChannelID, 64);
	
	if(strlen(g_sChannelID) < LEN_ID)
	{
		SetFailState("[DUv2_AdminLogs] Channel ID cannot be less than %i", LEN_ID);
	}
	if(DUMain_Bot() == INVALID_HANDLE)
	{
		SetFailState("[DUv2_AdminLogs] Bot is invalid");
	}	
}

public Action OnLogAction(Handle hSource, Identity ident, int client, int target, const char[] sMsg)
{
	if(strlen(g_sChannelID) < LEN_ID || DUMain_Bot() == INVALID_HANDLE)
	{
		delete hSource;
		return Plugin_Continue;
	}

	if(client <= 0)
	{
		delete hSource;
		return Plugin_Continue;
	}

	if(StrContains(sMsg, "sm_chat", false) != -1)
	{
		delete hSource;
		return Plugin_Continue;// dont log sm_chat because it's already being showed in admin chat relay channel.
	}
	
	SendAdminLog(client, target, sMsg);
	delete hSource;
	
	return Plugin_Continue;
}

void SendAdminLog(int client, int target, const char[] sArgs)
{
	char sTime[64], sCName[MAX_NAME_LENGTH+1], sCSteamID[32], sTName[MAX_NAME_LENGTH+1], sTSteamID[32], sMessage[512];
	
	if(client > 0)
	{
		GetClientName(client, sCName, sizeof(sCName));
		Discord_EscapeString(sCName, sizeof(sCName), true);
		GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	}

	if(target > 0)
	{
		GetClientName(target, sTName, sizeof(sTName));
		Discord_EscapeString(sTName, sizeof(sTName), true);
		GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	}

	ExtractActivityFromLog(client, target, sArgs, sMessage);
	
	Format(sTime, 64, "[<t:%i:T>] ", GetTime());
	
	if(target > 0)
	{
		Format(sMessage, 512, "%T", "Log", LANG_SERVER, g_sServerName, g_sMap, sTime, sCName, sCSteamID, sMessage, sTName, sTSteamID);
	}
	else
	{
		Format(sMessage, 512, "%T", "LogClientOnly", LANG_SERVER, g_sServerName, g_sMap, sTime, sCName, sCSteamID, sMessage);
	}

	DiscordMessage message = new DiscordMessage(sMessage);
	DUMain_Bot().SendMessageToChannelID(g_sChannelID, message);

	DisposeObject(message);
}

void ExtractActivityFromLog(int client, int target, const char[] sArgs, char[] sActivity)
{
	char sMsg[256];
	strcopy(sMsg, 256, sArgs);
	
	int index = -1, endex = -1;
	bool copy = true;
	if((index = StrContains(sMsg, "changed map to")) != -1)
	{
		char findmap[256];
		
		index += 16;
		strcopy(findmap, 256, sMsg[index]);
		endex = StrContains(findmap, "\"");
		if(endex != -1)
			findmap[endex] = '\0';

		if(FindMap(findmap, findmap, 256) != FindMap_NotFound)
		{
			sMsg[index-1] = '\0';
			Format(sActivity, 256, "%s\"%s\"", sMsg, findmap);
			copy = false;
		}
	}

	if(client > 0)
	{
		char sBuff[128];
		Format(sBuff, 128, "\"%L\" ", client);
		ReplaceString(sMsg, 256, sBuff, "", false);
		ReplaceString(sActivity, 256, sBuff, "", false);
	}
	if(target > 0)
	{
		char sBuff2[128];
		Format(sBuff2, 128, " \"%L\"", target);
		ReplaceString(sMsg, 256, sBuff2, "", false);
		ReplaceString(sActivity, 256, sBuff2, "", false);
	}
	
	if(copy)
		strcopy(sActivity, 128, sMsg);
}