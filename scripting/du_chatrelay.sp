#include <sourcemod>
#include <SteamWorks>

#undef REQUIRE_PLUGIN
#include <basecomm>
#define REQUIRE_PLUGIN

#include <discord>
#include <du2>

#pragma newdecls required
#pragma semicolon 1

SMCParser g_hParser;
char g_sPChatTrigger[16], g_sSChatTrigger[16];
char g_sAPIKey[128], g_sChannelID[64], g_sWebhook[256], g_sAvatar[MAXPLAYERS+1][256];
bool g_bBaseComm = false, g_bLate = false;

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Chat Relay",
	author = "Cruze",
	description = "Discord => In-Game and vice-versa relay",
	version = "1.0",
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
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				OnClientPostAdminCheck(i);
			}
		}
		g_bLate = false;
	}
}

public void DUMain_OnConfigLoaded()
{
	DUMain_GetString("api", g_sAPIKey, 128);
	DUMain_GetString("channel_chat", g_sChannelID, 64);
	DUMain_GetString("webhook_chat", g_sWebhook, 256);
	
	if(strlen(g_sChannelID) < LEN_ID && strlen(g_sWebhook) < LEN_ID)
	{
		SetFailState("[DiscordUtilitiesv2-ChatRelay] Channel ID and Webhook is invalid. Plugin won't work.");
		return;
	}
	
	if(DUMain_Bot() != INVALID_HANDLE && strlen(g_sChannelID) > LEN_ID)
	{
		DUMain_Bot().GetChannel(g_sChannelID, OnChannelReceived);
	}
}

public void OnAllPluginsLoaded()
{
	g_bBaseComm = LibraryExists("basecomm");
}

public void OnLibraryAdded(const char[] name)
{
	if(!strcmp(name, "basecomm", false))
	{
		g_bBaseComm = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if(!strcmp(name, "basecomm", false))
	{
		g_bBaseComm = false;
	}
}

public void OnMapStart()
{
	ReadCoreCFG();
}

public void OnChannelReceived(DiscordBot bot, DiscordChannel channel)
{
	if(channel == null)
	{
		SetFailState("[DiscordUtilitiesv2-ChatRelay] Channel ID is invalid.");
		return;
	}

	bot.StartListeningToChannel(channel, OnMessageReceived);
}

public void OnMessageReceived(DiscordBot bot, DiscordChannel channel, DiscordMessage message)
{
	if(message.Author.IsBot)
		return;

	DiscordUser user = message.GetAuthor();

	char szMessage[256];
	message.GetContent(szMessage, sizeof(szMessage));

	char szUsername[MAX_DISCORD_USERNAME_LENGTH];
	user.GetUsername(szUsername, sizeof(szUsername));

	char szDiscriminator[MAX_DISCORD_DISCRIMINATOR_LENGTH];
	user.GetDiscriminator(szDiscriminator, sizeof(szDiscriminator));

	PrintToChatAll(" \x06» \x03%s#%s\x01: \x04%s", szUsername, szDiscriminator, szMessage);
	
	json_cleanup_and_delete(message);
}

public void OnClientPostAdminCheck(int client)
{
	if(IsFakeClient(client))
	{
		return;
	}
	
	g_sAvatar[client][0] = '\0';
	
	if(strlen(g_sAPIKey) < LEN_ID)
	{
		return;
	}
	
	char sSteamID64[32];
	if(!GetClientAuthId(client, AuthId_SteamID64, sSteamID64, sizeof(sSteamID64)))
	{
		return;
	}

	static char sRequest[256];
	FormatEx(sRequest, sizeof(sRequest), "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s&format=vdf", g_sAPIKey, sSteamID64);
	Handle hRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, sRequest);
	if(!hRequest || !SteamWorks_SetHTTPRequestContextValue(hRequest, client) || !SteamWorks_SetHTTPCallbacks(hRequest, OnTransferCompleted) || !SteamWorks_SendHTTPRequest(hRequest))
	{
		delete hRequest;
	}
}

public int OnTransferCompleted(Handle hRequest, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode, int client)
{
	if (bFailure || !bRequestSuccessful || eStatusCode != k_EHTTPStatusCode200OK)
	{
		LogError("SteamAPI HTTP Response failed: %i", eStatusCode);
		delete hRequest;
		return;
	}

	int iBodyLength;
	SteamWorks_GetHTTPResponseBodySize(hRequest, iBodyLength);

	char[] sData = new char[iBodyLength];
	SteamWorks_GetHTTPResponseBodyData(hRequest, sData, iBodyLength);

	delete hRequest;
	
	KeyValues kvResponse = new KeyValues("SteamAPIResponse");

	if (!kvResponse.ImportFromString(sData, "SteamAPIResponse"))
	{
		LogError("kvResponse.ImportFromString(\"SteamAPIResponse\") in APIWebResponse failed. Try updating your steamworks extension.");

		delete kvResponse;
		return;
	}

	if (!kvResponse.JumpToKey("players"))
	{
		LogError("kvResponse.JumpToKey(\"players\") in APIWebResponse failed. Try updating your steamworks extension.");

		delete kvResponse;
		return;
	}

	if (!kvResponse.GotoFirstSubKey())
	{
		LogError("kvResponse.GotoFirstSubKey() in APIWebResponse failed. Try updating your steamworks extension.");

		delete kvResponse;
		return;
	}

	kvResponse.GetString("avatarfull", g_sAvatar[client], sizeof(g_sAvatar[]));
	delete kvResponse;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if(strlen(g_sWebhook) < LEN_ID)
	{
		return Plugin_Continue;
	}
	if(!client)
	{
		return Plugin_Continue;
	}
	if(g_bBaseComm)
	{
		if(BaseComm_IsClientGagged(client))
		{
			return Plugin_Continue;
		}
	}
	if(sArgs[0] == g_sPChatTrigger[0] || sArgs[0] == g_sSChatTrigger[0] || sArgs[0] == '@')
	{
		return Plugin_Continue;
	}
	SendChatRelay(client, sArgs);
	return Plugin_Continue;
}

void SendChatRelay(int client, const char[] sArgs)
{
	static char sName[MAX_NAME_LENGTH], sUsername[64], sContent[256];
	GetClientName(client, sName, MAX_NAME_LENGTH);
	
	Discord_EscapeString(sName, MAX_NAME_LENGTH, true);
	GetClientAuthId(client, AuthId_Steam2, sUsername, 64);
	Format(sUsername, 64, "%s [%s]", sName, sUsername);
	
	strcopy(sContent, 256, sArgs);
	Discord_EscapeString(sContent, 256);
	
	DiscordWebHook hook = new DiscordWebHook(g_sWebhook);
	hook.SetUsername(sUsername);
	if(g_sAvatar[client][0])
	{
		hook.SetAvatar(g_sAvatar[client]);
	}
	
	hook.SetContent(sContent);
	
	hook.Send();
	json_cleanup_and_delete(hook);
}

void Discord_EscapeString(char[] string, int maxlen, bool name = false)
{
	if(name)
	{
		ReplaceString(string, maxlen, "everyone", "everyonｅ");
		ReplaceString(string, maxlen, "here", "herｅ");
		ReplaceString(string, maxlen, "discordtag", "dｉscordtag");
	}
	ReplaceString(string, maxlen, "#", "＃");
	ReplaceString(string, maxlen, "@", "＠");
	//ReplaceString(string, maxlen, ":", "");
	ReplaceString(string, maxlen, "_", "ˍ");
	ReplaceString(string, maxlen, "'", "＇");
	ReplaceString(string, maxlen, "`", "＇");
	ReplaceString(string, maxlen, "~", "∽");
	ReplaceString(string, maxlen, "\"", "＂");
}

public bool ReadCoreCFG()
{
	if(!g_hParser)
		g_hParser = new SMCParser();
	
	g_hParser.OnEnterSection = Config_CoreNewSection;
	g_hParser.OnLeaveSection = Config_CoreEndSection;
	g_hParser.OnKeyValue = Config_CoreKeyValue;
	g_hParser.OnEnd = Config_CoreEnd;
	
	char configPath[256];
	BuildPath(Path_SM, configPath, sizeof(configPath), "configs/core.cfg");

	int line;
	SMCError err = g_hParser.ParseFile(configPath, line);
	if (err != SMCError_Okay)
	{
		char error[256];
		SMC_GetErrorString(err, error, sizeof(error));
		LogError("[DiscordUtilitiesv2-ChatRelay] Unable to parse file (line %d) [File: %s]", line, configPath);
		SetFailState("[DiscordUtilitiesv2-ChatRelay] Parser encountered error: %s", error);
	}
	
	return (err == SMCError_Okay);
}

public SMCResult Config_CoreNewSection(SMCParser smc, const char[] name, bool opt_quotes)
{
	if(StrEqual(name, "Core"))
	{
		return SMCParse_Continue;
	}
	return SMCParse_Continue;
}

public SMCResult Config_CoreKeyValue(SMCParser parser, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	if(StrEqual(key, "PublicChatTrigger", false))
		strcopy(g_sPChatTrigger, 16, value[0]);
	else if(StrEqual(key, "SilentChatTrigger", false))
		strcopy(g_sSChatTrigger, 16, value[0]);

	return SMCParse_Continue;
}

public SMCResult Config_CoreEndSection(SMCParser parser) 
{
	return SMCParse_Continue;
}

public void Config_CoreEnd(SMCParser parser, bool halted, bool failed) 
{
}