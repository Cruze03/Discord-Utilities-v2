#include <sourcemod>
#include <sdktools>
#include <cstrike>

#include <discord>
#include <du2>

#pragma newdecls required
#pragma semicolon 1

#define EMBED_COLOR "#BF40BF"
#define MAP_THUMBNAIL "https://image.gametracker.com/images/maps/160x120/csgo/MAPNAME.jpg" //'MAPNAME' will be replaced as current map name

const float UPDATE_TIME = 15.0;

ConVar g_hTimelimit, g_hMaxrounds;
Handle g_hRepeater = null;
char g_sMap[256], g_sServerName[128], g_sChannelID[64], g_sMessageID[64];
bool g_bGameStart = false;
int g_iRoundStart;

bool g_bAddMessage = false, g_bLate = false;

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Server Details",
	author = "Cruze",
	description = "Updates a detailed embed about server every X seconds.",
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
	HookEvent("round_freeze_end", Event_Round);
	HookEvent("round_end", Event_Round);
	
	RegAdminCmd("sm_sd_refresh", Command_Refresh, ADMFLAG_ROOT);
	
	g_bGameStart = false;
	
	g_hMaxrounds = FindConVar("mp_maxrounds");
	g_hTimelimit = FindConVar("mp_timelimit");
	HookConVarChange(g_hMaxrounds, OnSettingsChanged);
	HookConVarChange(g_hTimelimit, OnSettingsChanged);
	
	LoadTranslations("du_serverdetails.phrases");
	
	if(g_bLate)
	{
		if(DUMain_IsConfigLoaded())
		{
			DUMain_OnConfigLoaded();
		}
		g_bLate = false;
	}
}

public Action Command_Refresh(int client, int args)
{
	if(DUMain_Bot() == INVALID_HANDLE)
	{
		ReplyToCommand(client, "[SM] Bot is not working. Please re-check your bot token and reload the map.");
		return Plugin_Handled;
	}
	if(strlen(g_sChannelID) < LEN_ID)
	{
		ReplyToCommand(client, "[SM] Channel ID is empty in config file. Kindly fill that out first.");
		return Plugin_Handled;
	}
	if(strlen(g_sMessageID) < LEN_ID)
	{
		ReplyToCommand(client, "[SM] Message ID is empty in config file. Kindly fill that out first.");
		return Plugin_Handled;
	}
	
	UpdateScores();
	ReplyToCommand(client, "[SM] Refreshed data in map notification message.");
	return Plugin_Handled;
}

public void OnMapStart()
{
	GetCurrentMap(g_sMap, 256);
	
	g_bGameStart = false;
	
	g_hRepeater = null;
}

public void DUMain_OnConfigLoaded()
{
	DUMain_GetString("channel_map", g_sChannelID, 64);
	DUMain_GetString("message_map", g_sMessageID, 64);
	
	if(strlen(g_sChannelID) < LEN_ID)
	{
		SetFailState("[DiscordUtilitiesv2-ServerDetails] Channel ID specified is in-correct.");
		return;
	}
	
	if(DUMain_Bot() != INVALID_HANDLE && strlen(g_sMessageID) < LEN_ID)
	{
		DUMain_Bot().GetChannel(g_sChannelID, OnChannelReceived);
	}
	UpdateScores();
}

public void OnChannelReceived(DiscordBot bot, DiscordChannel channel)
{
	if(channel == null)
	{
		SetFailState("[DiscordUtilitiesv2-ServerDetails] Channel ID is invalid.");
		return;
	}
	
	bot.StartListeningToChannel(channel, OnMessageReceived);
	
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
	
	if(message.Author.IsBot && g_bAddMessage)
	{
		strcopy(g_sMessageID, 64, sMessageID);
		
		DUMain_SetString("message_map", sMessageID, 64);
		DUMain_UpdateConfig();
		
		g_bAddMessage = false;
		bot.StopListeningToChannel(channel);
		json_cleanup_and_delete(channel);
		return;
	}
	json_cleanup_and_delete(message);
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
	
	char sBuf[666];
	
	DiscordMessage message = new DiscordMessage(" ");
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sBuf, 64, "Server Details");
	
	embed.WithTitle(sBuf);
	
	Format(sBuf, 666, "This message will be edited into the server details of `%s` server.\n \n**What to do next:**\n**-** Nothing. Just be patient. This message will be gone as soon as new rounds starts in the server.\n- Click [here](https://github.com/Cruze03/discord-utilities-v2/wiki) to get redirected to the wiki page if any issue persist.", g_sServerName);
	
	embed.WithDescription(sBuf);
	
	embed.WithFooter(new DiscordEmbedFooter("Powered by Discord Utilities v2"));
	
	message.Embed(embed);
	
	DUMain_Bot().SendMessageToChannelID(g_sChannelID, message);
	json_cleanup_and_delete(message);
	
	g_bAddMessage = true;
	
	LogMessage("[SM] Added a server details message in the channel!");
}

public void OnAutoConfigsBuffered()
{
	CreateTimer(1.0, Timer_OnAutoConfigsBuffered, _, TIMER_FLAG_NO_MAPCHANGE);		//Multimod support
}

public Action Timer_OnAutoConfigsBuffered(Handle timer)
{
	FindConVar("hostname").GetString(g_sServerName, sizeof(g_sServerName));
}

public int OnSettingsChanged(ConVar cvar, const char[] oldVal, const char[] newVal)
{
	UpdateScores();
}

public void Event_Round(Event ev, const char[] name, bool dbc)
{
	if(strcmp(name, "round_freeze_end", false) == 0)
	{
		g_bGameStart = true;
		g_iRoundStart = GetTime()+1;
	}
	else
	{
		delete g_hRepeater;
	}
	CreateTimer(1.0, Timer_UpdateScores, strcmp(name, "round_freeze_end", false));
}

public Action Timer_UpdateScores(Handle timer, any data)
{
	if(!IsWarmup() && data == 0)
	{
		delete g_hRepeater;
		g_hRepeater = CreateTimer(UPDATE_TIME, Timer_RoundStart, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
	UpdateScores();
}

public Action Timer_RoundStart(Handle timer)
{
	UpdateScores();
}

public void UpdateScores()
{
	if(DUMain_Bot() == INVALID_HANDLE)
	{
		return;
	}
	if(strlen(g_sChannelID) < LEN_ID)
	{
		return;
	}
	if(strlen(g_sMessageID) < LEN_ID)
	{
		return;
	}
	
	char sTeamScore[64], sTimeleft[64], sTime[64], sOnline[16], sRoundTime[16], sBuf[512], sTrans[64];
	int timeleft, timeplayed, totalroundtime, roundtimeleft, roundsleft, scoreCT, scoreT;
	
	scoreCT = GetTeamScore(3);
	scoreT = GetTeamScore(2);
	
	DateTime time = new DateTime();
	Format(sTrans, 64, "%T", "DateTime_Format", LANG_SERVER);
	ReplaceString(sTrans, 64, "{DATE}", "%d", false);
	ReplaceString(sTrans, 64, "{MONTH}", "%m", false);
	ReplaceString(sTrans, 64, "{YEAR}", "%Y", false);
	ReplaceString(sTrans, 64, "{HOUR}", "%H", false);
	ReplaceString(sTrans, 64, "{MINUTES}", "%M", false);
	ReplaceString(sTrans, 64, "{SECONDS}", "%S", false);
	time.ToString(sTime, 64, sTrans);
	
	Format(sTime, 64, "%T", "LastEdited", LANG_SERVER, sTime);
	
	Format(sTeamScore, 64, "%T", "TeamScore", LANG_SERVER, scoreCT > 1000 ? 0 : scoreCT, scoreT > 1000 ? 0 : scoreT);
	
	Format(sBuf, 512, MAP_THUMBNAIL);
	
	ReplaceString(sBuf, 512, "MAPNAME", g_sMap);
	
	Format(sOnline, 16, "%i/%i", GetOnlinePlayers(), GetMaxHumanPlayers());
	
	if(IsWarmup())
	{
		Format(sRoundTime, 64, "%T", "Unknown", LANG_SERVER);
		Format(sTimeleft, 64, "%T", "Warmup", LANG_SERVER);
	}
	else if(GetMapTimeLeft(timeleft) && timeleft > 0)
	{
		timeplayed = GetRoundTimePlayed();
		totalroundtime = GetCurrentRoundTime();
		roundtimeleft = timeplayed-totalroundtime;
		if(roundtimeleft < 0 || timeplayed < 0 || totalroundtime < 0)
		{
			Format(sRoundTime, 64, "%T", "Unknown", LANG_SERVER);
		}
		else
		{
			SecToTime2(roundtimeleft, sRoundTime, 64);
		}
		SecToTime(timeleft, sTimeleft, 64);
	}
	else if(GetRoundsLeft(roundsleft) && roundsleft > 0)
	{
		timeplayed = GetRoundTimePlayed();
		totalroundtime = GetCurrentRoundTime();
		roundtimeleft = timeplayed-totalroundtime;
		if(roundtimeleft < 0 || timeplayed < 0 || totalroundtime < 0)
		{
			Format(sRoundTime, 64, "%T", "Unknown", LANG_SERVER);
		}
		else
		{
			SecToTime2(roundtimeleft, sRoundTime, 64);
		}
		Format(sTimeleft, 64, "%T", "RoundsLeft", LANG_SERVER, roundsleft);
	}
	else
	{
		timeplayed = GetRoundTimePlayed();
		totalroundtime = GetCurrentRoundTime();
		roundtimeleft = timeplayed-totalroundtime;
		if(roundtimeleft < 0 || timeplayed < 0 || totalroundtime < 0)
		{
			Format(sRoundTime, 64, "%T", "Unknown", LANG_SERVER);
		}
		else
		{
			SecToTime2(roundtimeleft, sRoundTime, 64);
		}
		Format(sTimeleft, 64, "%T", "LastRound", LANG_SERVER);
	}
	
	DiscordMessage message = new DiscordMessage(" ");
	
	DiscordEmbed embed = new DiscordEmbed();
	
	embed.WithTitle(g_sServerName);
	
	embed.SetColor(EMBED_COLOR);
	
	embed.WithThumbnail(new DiscordEmbedThumbnail(sBuf, 160, 120));
	
	Format(sTrans, 64, "%T", "CurrentMap", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, g_sMap, true));
	
	Format(sTrans, 64, "%T", "OnlinePlayers", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sOnline, true));
	
	Format(sTrans, 64, "%T", "TeamScoreTitle", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTeamScore, false));
	
	Format(sTrans, 64, "%T", "RoundTimeleft", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sRoundTime, true));
	
	Format(sTrans, 64, "%T", "Timeleft", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTimeleft, true));
	
	embed.WithFooter(new DiscordEmbedFooter(sTime));
	
	message.Embed(embed);
	DUMain_Bot().EditMessageID(g_sChannelID, g_sMessageID, message);
	
	//json_cleanup_and_delete(embed);
	json_cleanup_and_delete(message);
}

bool GetRoundsLeft(int &round)
{		
	round = -1;
	if(g_hMaxrounds)
	{
		int maxrounds = g_hMaxrounds.IntValue;
		
		int rounds = GetRoundsPlayed();
		
		if(rounds == -1)
		{
			return false;
		}
		
		if(maxrounds)
		{
			round = maxrounds - rounds;
			return true;			
		}
	}
	return false;
}

int GetRoundsPlayed()
{
	if(g_bGameStart)
		return GameRules_GetProp("m_totalRoundsPlayed");
	return -1;
}

int GetCurrentRoundTime()
{
	if(g_bGameStart)
		return GetTime() - g_iRoundStart;
	return -1;
}

int GetRoundTimePlayed()
{
	if(g_bGameStart)
		return GameRules_GetProp("m_iRoundTime");
	return -1;
}

bool IsWarmup()
{
	if(g_bGameStart)
		return view_as<bool>(GameRules_GetProp("m_bWarmupPeriod"));
	return true;
}

void SecToTime(int time, char[] buffer, int size)
{
	int iHours = 0;
	int iMinutes = 0;
	int iSeconds = time;

	while (iSeconds >= 3600)
	{
		iHours++;
		iSeconds -= 3600;
	}
	while (iSeconds >= 60)
	{
		iMinutes++;
		iSeconds -= 60;
	}

	if (iHours >= 1)
	{
		Format(buffer, size, "%T", "TimeleftFormat1", LANG_SERVER, iHours, iMinutes);
	}
	else if (iMinutes >= 1)
	{
		Format(buffer, size, "%T", "TimeleftFormat2", LANG_SERVER, iMinutes);
	}
	else
	{
		Format(buffer, size, "%T", "TimeleftFormat3", LANG_SERVER, iSeconds);
	}
}

void SecToTime2(int time, char[] buffer, int size)
{
	int iHours = 0;
	int iMinutes = 0;
	int iSeconds = time;

	while (iSeconds >= 3600)
	{
		iHours++;
		iSeconds -= 3600;
	}
	while (iSeconds >= 60)
	{
		iMinutes++;
		iSeconds -= 60;
	}

	if (iHours >= 1)
	{
		Format(buffer, size, "%T", "RoundTimeleftFormat1", LANG_SERVER, iHours, iMinutes, iSeconds);
	}
	else if (iMinutes >= 1)
	{
		Format(buffer, size, "%T", "RoundTimeleftFormat2", LANG_SERVER, iMinutes, iSeconds);
	}
	else
	{
		Format(buffer, size, "%T", "RoundTimeleftFormat3", LANG_SERVER, iSeconds);
	}
}

int GetOnlinePlayers()
{
	int i, count;
	for(i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsClientSourceTV(i) && !IsClientReplay(i))
		{
			count++;
		}
	}
	return count;
}