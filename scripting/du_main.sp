#include <sourcemod>
#include <SteamWorks>

#include <discord>
#include <du2>

StringMap g_smParser;
SMCParser g_hParser;
char g_sSection[64], g_sBotToken[256], g_sGuildID[64], g_sRole[64], g_sInviteLink[64], g_sCommand[256], g_sCommandInGame[256], g_sDatabaseName[64], g_sBlockedCommands[512], g_sTableName[64], g_sServersTableName[64], g_sAPIKey[128], g_sChat_Webhook[256], g_sBugReport_Webhook[256], g_sCallAdmin_Webhook[256], g_sBans_Webhook[256], g_sComms_Webhook[256], g_sReportPlayer_Webhook[256], g_sMapThumbnail[256], g_sUseSWGM[8], g_sServerDNS[64], g_sServerPassword[128];
char g_sMap_ChannelID[64], g_sChat_ChannelID[64], g_sVerification_ChannelID[64], g_sAdminlog_ChannelID[64], g_sCrashReport_ChannelID[64], g_sCrashReport_ChannelID2[64];
char g_sMap_MessageID[64], g_sVerification_MessageID[64];

bool g_bPrimary, g_bReady;
int g_iServerID;

Handle g_hOnConfigLoaded, g_hOnPasswordChanged;

DiscordBot g_eBot = null;

public Plugin myinfo = 
{
	name = "Discord Utilities v2",
	author = "Cruze",
	description = "Parser just for Discord Utilities v2 because 'CSGO'.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("DiscordUtilitiesv2");
	
	CreateNative("DUMain_UpdateConfig", Native_UpdateConfig);
	CreateNative("DUMain_ReloadConfig", Native_ReloadConfig);
	CreateNative("DUMain_IsConfigLoaded", Native_IsConfigLoaded);
	CreateNative("DUMain_Bot", Native_Bot);
	CreateNative("DUMain_GetServerPassword", Native_GetServerPassword);
	
	CreateNative("DUMain_GetString", Native_GetString);
	CreateNative("DUMain_SetString", Native_SetString);
	
	g_hOnConfigLoaded = CreateGlobalForward("DUMain_OnConfigLoaded", ET_Ignore);
	g_hOnPasswordChanged = CreateGlobalForward("DUMain_OnServerPasswordChanged", ET_Ignore, Param_String, Param_String);
}

public int Native_GetServerPassword(Handle plugin, int numParams)
{
	SetNativeString(1, g_sServerPassword, 128);
}

public int Native_Bot(Handle plugin, int numParams)
{
	if(strcmp(g_sBotToken, "") == 0 || g_eBot == INVALID_HANDLE)
	{
		return view_as<int>(INVALID_HANDLE);
	}
	return view_as<int>(g_eBot);
}

public int Native_UpdateConfig(Handle plugin, int numParams)
{
	RefreshIDsToConfig();
}

public int Native_ReloadConfig(Handle plugin, int numParams)
{
	ParseConfigs();
}

public int Native_IsConfigLoaded(Handle plugin, int numParams)
{
	return g_bReady;
}

public int Native_GetString(Handle plugin, int numParams)
{
	if(g_smParser == null || !g_bReady)
	{
		return false;
	}
	
	char key[64];
	int size = GetNativeCell(3);
	GetNativeString(1, key, 64);
	
	char[] value = new char[size];
	
	GetNativeString(2, value, size);
	
	if(!g_smParser.GetString(key, value, size))
	{
		return false;
	}
	SetNativeString(2, value, size);
	return true;
}

public int Native_SetString(Handle plugin, int numParams)
{
	if(g_smParser == null || !g_bReady)
	{
		return false;
	}
	
	char key[64];
	int size = GetNativeCell(3);
	GetNativeString(1, key, 64);
	char[] value = new char[size];
	GetNativeString(2, value, size);
	
	if(strcmp(key, "message_map") != 0 && strcmp(key, "message_verification") != 0)
	{
		return false;
	}
	
	if(!g_smParser.SetString(key, value))
	{
		return false;
	}
	if( strcmp(key, "message_map") == 0 )
	{
		strcopy(g_sMap_MessageID, 64, value);
	}
	else if( strcmp(key, "message_verification") == 0 )
	{
		strcopy(g_sVerification_MessageID, 64, value);
	}
	return true;
}

public void OnPluginStart()
{
	RegAdminCmd("sm_du_refresh", Command_Refresh, ADMFLAG_ROOT);
	
	if(GetFeatureStatus(FeatureType_Native, "DiscordAPI_Version") != FeatureStatus_Available)
	{
		SetFailState("[DU-Main] You are running an older version of discord api. Please update to the latest version.");
	}
	if(DiscordAPI_Version() < 103)
	{
		SetFailState("[DU-Main] You are running an older version of discord api. Please update to the latest version.");
	}
}

public Action Command_Refresh(int client, int args)
{
	ParseConfigs();
	ReplyToCommand(client, "[SM] Refreshed the config file.");
	return Plugin_Handled;
}

public void OnMapStart()
{
	g_bReady = false;
	ParseConfigs();
}

void RefreshIDsToConfig()
{
	KeyValues kv = new KeyValues("DiscordUtilitiesv2");
	
	char sPath[256];
	BuildPath(Path_SM, sPath, 256, "configs/DiscordUtilitiesv2.txt");
	
	if(!FileExists(sPath))
	{
		return;
	}
	kv.ImportFromFile(sPath);
	
	kv.Rewind();
	
	if(kv.JumpToKey("CHANNEL_IDS"))
	{
		kv.SetString("map", !g_sMap_ChannelID[0] ? " " : g_sMap_ChannelID);
		kv.SetString("chat", !g_sChat_ChannelID[0] ? " " : g_sChat_ChannelID);
		kv.SetString("verification", !g_sVerification_ChannelID[0] ? " " : g_sVerification_ChannelID);
		kv.SetString("adminlog", !g_sAdminlog_ChannelID[0] ? " " : g_sAdminlog_ChannelID);
	}
	
	kv.Rewind();
	
	if(kv.JumpToKey("MESSAGE_IDS"))
	{
		kv.SetString("map", !g_sMap_MessageID[0] ? " " : g_sMap_MessageID);
		kv.SetString("verification", !g_sVerification_MessageID[0] ? " " : g_sVerification_MessageID);
	}
	
	kv.Rewind();
	
	if(kv.JumpToKey("VERIFICATION_SETTINGS"))
	{
		kv.SetString("guildid", !g_sGuildID[0] ? " " : g_sGuildID);
		kv.SetString("roleid", !g_sRole[0] ? " " : g_sRole);
	}
	
	kv.Rewind();
	kv.ExportToFile(sPath);
	
	delete kv;
}

void ParseConfigs()
{
	if(!g_hParser)
		g_hParser = new SMCParser();
	
	g_hParser.OnEnterSection = Config_NewSection;
	g_hParser.OnLeaveSection = Config_EndSection;
	g_hParser.OnKeyValue = Config_KeyValue;
	g_hParser.OnEnd = Config_End;
	
	char configPath[256];
	BuildPath(Path_SM, configPath, sizeof(configPath), "configs/DiscordUtilitiesv2.txt");
	
	if (!FileExists(configPath))
	{
		SetFailState("[DiscordUtilitiesv2-Main] Unable to find config file in path: addons/sourcemod/configs/DiscordUtilitiesv2.txt");
		return;		
	}
	
	int line;
	SMCError err = g_hParser.ParseFile(configPath, line);
	if (err != SMCError_Okay)
	{
		char error[256];
		SMC_GetErrorString(err, error, sizeof(error));
		LogError("[DiscordUtilitiesv2-Main] Unable to parse file (line %d, file \"%s\"):", line, configPath);
		SetFailState("[DiscordUtilitiesv2-Main] Parser encountered error: %s", error);
	}
}

public SMCResult Config_NewSection(SMCParser smc, const char[] name, bool opt_quotes)
{
	strcopy(g_sSection, 64, name);
	return SMCParse_Continue;
}

public SMCResult Config_EndSection(SMCParser smc)
{
	if(!strcmp(g_sSection, "BOT_TOKEN"))
	{
		if(!g_sBotToken[0])
		{
			SetFailState("[DiscordUtilitiesv2-Main] Bot Token not specified in addons/sourcemod/configs/DiscordUtilitiesv2.txt");
		}
	}
	return SMCParse_Continue;
}

public SMCResult Config_KeyValue(SMCParser smc, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	if(!strcmp(g_sSection, "BOT_TOKEN"))
	{
		if(!strcmp(key, "key", false))
		{
			strcopy(g_sBotToken, 256, value);
		}
	}
	else if(!strcmp(g_sSection, "API_KEY"))
	{
		if(!strcmp(key, "key", false))
		{
			strcopy(g_sAPIKey, 256, value);
		}
	}
	else if(!strcmp(g_sSection, "CHANNEL_IDS"))
	{
		if(!strcmp(key, "map", false))
		{
			strcopy(g_sMap_ChannelID, 64, value);
		}
		else if(!strcmp(key, "chat", false))
		{
			strcopy(g_sChat_ChannelID, 64, value);
		}
		else if(!strcmp(key, "verification", false))
		{
			strcopy(g_sVerification_ChannelID, 64, value);
		}
		else if(!strcmp(key, "adminlog", false))
		{
			strcopy(g_sAdminlog_ChannelID, 64, value);
		}
		else if(!strcmp(key, "crashreport", false))
		{
			strcopy(g_sCrashReport_ChannelID, 64, value);
		}
		else if(!strcmp(key, "crashreport_nonadmin", false))
		{
			strcopy(g_sCrashReport_ChannelID2, 64, value);
		}
	}
	else if(!strcmp(g_sSection, "MESSAGE_IDS"))
	{
		if(!strcmp(key, "map", false))
		{
			strcopy(g_sMap_MessageID, 64, value);
		}
		else if(!strcmp(key, "verification", false))
		{
			strcopy(g_sVerification_MessageID, 64, value);
		}
	}
	else if(!strcmp(g_sSection, "WEBHOOKS"))
	{
		if(!strcmp(key, "chat", false))
		{
			strcopy(g_sChat_Webhook, 256, value);
		}
		else if(!strcmp(key, "bugreport", false))
		{
			strcopy(g_sBugReport_Webhook, 256, value);
		}
		else if(!strcmp(key, "calladmin", false))
		{
			strcopy(g_sCallAdmin_Webhook, 256, value);
		}
		else if(!strcmp(key, "bans", false))
		{
			strcopy(g_sBans_Webhook, 256, value);
		}
		else if(!strcmp(key, "comms", false))
		{
			strcopy(g_sComms_Webhook, 256, value);
		}
		else if(!strcmp(key, "reportplayer", false))
		{
			strcopy(g_sReportPlayer_Webhook, 256, value);
		}
	}
	else if(!strcmp(g_sSection, "WEBHOOK_SETTINGS"))
	{
		if(!strcmp(key, "map_thumbnail", false))
		{
			strcopy(g_sMapThumbnail, 256, value);
		}
		else if(!strcmp(key, "server_dns_name", false))
		{
			if(value[0])
			{
				strcopy(g_sServerDNS, 64, value);
			}
			else
			{
				int ip[4];
				int iServerPort = FindConVar("hostport").IntValue;
				SteamWorks_GetPublicIP(ip);
				if(SteamWorks_GetPublicIP(ip))
				{
					Format(g_sServerDNS, 64, "%d.%d.%d.%d:%d", ip[0], ip[1], ip[2], ip[3], iServerPort);
				}
				else
				{
					int iServerIP = FindConVar("hostip").IntValue;
					Format(g_sServerDNS, 64, "%d.%d.%d.%d:%d", iServerIP >> 24 & 0x000000FF, iServerIP >> 16 & 0x000000FF, iServerIP >> 8 & 0x000000FF, iServerIP & 0x000000FF, iServerPort);
				}
			}
		}
	}
	else if(!strcmp(g_sSection, "VERIFICATION_SETTINGS"))
	{
		if(!strcmp(key, "primary"))
		{
			g_bPrimary = !!StringToInt(value);
		}
		else if(!strcmp(key, "serverid"))
		{
			g_iServerID = StringToInt(value);
		}
		else if(!strcmp(key, "guildid"))
		{
			strcopy(g_sGuildID, 64, value);
		}
		else if(!strcmp(key, "roleid"))
		{
			strcopy(g_sRole, 64, value);
		}
		else if(!strcmp(key, "invite_link"))
		{
			strcopy(g_sInviteLink, 64, value);
		}
		else if(!strcmp(key, "command"))
		{
			strcopy(g_sCommand, 256, value);
		}
		else if(!strcmp(key, "command_ingame"))
		{
			strcopy(g_sCommandInGame, 256, value);
		}
		else if(!strcmp(key, "blocked_commands"))
		{
			strcopy(g_sBlockedCommands, 512, value);
		}
		else if(!strcmp(key, "use_swgm_for_blocked_commands"))
		{
			strcopy(g_sUseSWGM, 8, value);
		}
		else if(!strcmp(key, "database_name"))
		{
			strcopy(g_sDatabaseName, 64, value);
		}
		else if(!strcmp(key, "table_name"))
		{
			strcopy(g_sTableName, 64, value);
		}
		else if(!strcmp(key, "servers_table_name"))
		{
			strcopy(g_sServersTableName, 64, value);
		}
	}
	return SMCParse_Continue;
}

public void Config_End(SMCParser smc, bool halted, bool failed)
{
	if(failed)
	{
		SetFailState("[DiscordUtilitiesv2-Main] Failed to parse the config file. Check config file for missing '\"' or '{' or '}'");
		return;
	}
	
	delete g_smParser;
	g_smParser = new StringMap();
	
	g_smParser.SetString("bot", g_sBotToken);
	g_smParser.SetString("api", g_sAPIKey);
	g_smParser.SetString("channel_map", g_sMap_ChannelID);
	g_smParser.SetString("channel_chat", g_sChat_ChannelID);
	g_smParser.SetString("channel_verification", g_sVerification_ChannelID);
	g_smParser.SetString("channel_adminlog", g_sAdminlog_ChannelID);
	g_smParser.SetString("channel_crashreport", g_sCrashReport_ChannelID);
	g_smParser.SetString("channel_crashreport_nonadmin", g_sCrashReport_ChannelID2);
	g_smParser.SetString("message_map", g_sMap_MessageID);
	g_smParser.SetString("message_verification", g_sVerification_MessageID);
	g_smParser.SetString("webhook_chat", g_sChat_Webhook);
	g_smParser.SetString("webhook_bugreport", g_sBugReport_Webhook);
	g_smParser.SetString("webhook_calladmin", g_sCallAdmin_Webhook);
	g_smParser.SetString("webhook_bans", g_sBans_Webhook);
	g_smParser.SetString("webhook_comms", g_sComms_Webhook);
	g_smParser.SetString("webhook_report", g_sReportPlayer_Webhook);
	
	g_smParser.SetString("map_thumbnail", g_sMapThumbnail);
	g_smParser.SetString("server_dns_name", g_sServerDNS);
	g_smParser.SetString("use_swgm_for_blocked_commands", g_sUseSWGM);
	
	char value[8];
	IntToString(g_bPrimary, value, 8);
	g_smParser.SetString("primary", value);
	IntToString(g_iServerID, value, 8);
	g_smParser.SetString("serverid", value);
	
	g_smParser.SetString("guildid", g_sGuildID);
	g_smParser.SetString("roleid", g_sRole);
	g_smParser.SetString("invite_link", g_sInviteLink);
	g_smParser.SetString("command", g_sCommand);
	g_smParser.SetString("command_ingame", g_sCommandInGame);
	g_smParser.SetString("blocked_commands", g_sBlockedCommands);
	g_smParser.SetString("database_name", g_sDatabaseName);
	g_smParser.SetString("table_name", g_sTableName);
	g_smParser.SetString("servers_table_name", g_sServersTableName);
	
	if(strlen(g_sBotToken) > LEN_ID)
	{
		g_eBot = new DiscordBot(g_sBotToken);
	}
	
	if(g_eBot == INVALID_HANDLE)
	{
		SetFailState("[DU_Main] Bot token is invalid. Please check your bot token again.");
		return;
	}
	
	g_bReady = true;
	
	ConVar cvar = FindConVar("sv_password");
	if(cvar != null)
	{
		cvar.GetString(g_sServerPassword, 128);
		cvar.AddChangeHook(OnPasswordChange);
	}
	delete cvar;
	
	Call_StartForward(g_hOnConfigLoaded);
	Call_Finish();
	
	// Adding du tags in sv_tags to help me keep track of server using this plugin.
	ConVar hTags = FindConVar("sv_tags");
	
	if(hTags != null)
	{
		char sBuffer[256];
		hTags.GetString(sBuffer, 256);
		if(StrContains(sBuffer, "du,duv2") == -1)
		{
			Format(sBuffer, 256, "%s,du,duv2", sBuffer);
			hTags.SetString(sBuffer);
		}
	}
	delete hTags;
}

public int OnPasswordChange(ConVar cvar, const char[] oldVal, const char[] newVal)
{
	if(StrEqual(oldVal, newVal))
	{
		return;
	}
	
	cvar.GetString(g_sServerPassword, 128);
	
	Call_StartForward(g_hOnPasswordChanged);
	Call_PushString(oldVal);
	Call_PushString(newVal);
	Call_Finish();
}

public void OnPluginEnd()
{
	if(g_eBot != null)
	{
		DisposeObject(g_eBot);
	}
}
