#include <sourcemod>

#include <discord>
#include <du2>

StringMap g_smParser;
SMCParser g_hParser;
char g_sSection[64], g_sBotToken[256], g_sGuildID[64], g_sRole[64], g_sInviteLink[64], g_sCommand[64], g_sCommandInGame[64], g_sDatabaseName[64], g_sBlockedCommands[512], g_sTableName[64], g_sAPIKey[128], g_sChat_Webhook[256];
char g_sMap_ChannelID[64], g_sChat_ChannelID[64], g_sVerification_ChannelID[64];
char g_sMap_MessageID[64], g_sVerification_MessageID[64];

bool g_bPrimary, g_bReady;
int g_iServerID;

Handle g_hOnConfigLoaded;

DiscordBot g_eBot = null;

public Plugin myinfo = 
{
	name = "Discord Utilities v2",
	author = "Cruze",
	description = "Parser just for Discord Utilities v2 because 'CSGO'.",
	version = "1.0",
	url = "https://github.com/Cruze03"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("DiscordUtilitiesv2");
	
	CreateNative("DUMain_UpdateConfig", Native_UpdateConfig);
	CreateNative("DUMain_ReloadConfig", Native_ReloadConfig);
	CreateNative("DUMain_IsConfigLoaded", Native_IsConfigLoaded);
	CreateNative("DUMain_Bot", Native_Bot);
	
	CreateNative("DUMain_GetString", Native_GetString);
	CreateNative("DUMain_SetString", Native_SetString);
	
	g_hOnConfigLoaded = CreateGlobalForward("DUMain_OnConfigLoaded", ET_Ignore);
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
		if(!strcmp(key, "key"))
		{
			strcopy(g_sBotToken, 256, value);
		}
	}
	else if(!strcmp(g_sSection, "API_KEY"))
	{
		if(!strcmp(key, "key"))
		{
			strcopy(g_sAPIKey, 256, value);
		}
	}
	else if(!strcmp(g_sSection, "CHANNEL_IDS"))
	{
		if(!strcmp(key, "map"))
		{
			strcopy(g_sMap_ChannelID, 64, value);
		}
		else if(!strcmp(key, "chat"))
		{
			strcopy(g_sChat_ChannelID, 64, value);
		}
		else if(!strcmp(key, "verification"))
		{
			strcopy(g_sVerification_ChannelID, 64, value);
		}
	}
	else if(!strcmp(g_sSection, "MESSAGE_IDS"))
	{
		if(!strcmp(key, "map"))
		{
			strcopy(g_sMap_MessageID, 64, value);
		}
		else if(!strcmp(key, "verification"))
		{
			strcopy(g_sVerification_MessageID, 64, value);
		}
	}
	else if(!strcmp(g_sSection, "WEBHOOKS"))
	{
		if(!strcmp(key, "chat"))
		{
			strcopy(g_sChat_Webhook, 256, value);
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
			strcopy(g_sCommand, 64, value);
		}
		else if(!strcmp(key, "command_ingame"))
		{
			strcopy(g_sCommandInGame, 64, value);
		}
		else if(!strcmp(key, "blocked_commands"))
		{
			strcopy(g_sBlockedCommands, 512, value);
		}
		else if(!strcmp(key, "database_name"))
		{
			strcopy(g_sDatabaseName, 64, value);
		}
		else if(!strcmp(key, "table_name"))
		{
			strcopy(g_sTableName, 64, value);
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
	g_smParser.SetString("message_map", g_sMap_MessageID);
	g_smParser.SetString("message_verification", g_sVerification_MessageID);
	g_smParser.SetString("webhook_chat", g_sChat_Webhook);
	
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
	
	if(g_eBot == INVALID_HANDLE && strlen(g_sBotToken) > LEN_ID)
	{
		g_eBot = new DiscordBot(g_sBotToken);
	}
	
	g_bReady = true;
	
	Call_StartForward(g_hOnConfigLoaded);
	Call_Finish();
}