#include <sourcemod>
#include <discord>
#include <du2>

#undef REQUIRE_PLUGIN
#include <sourcebanspp>
#include <sourcecomms>
#include <materialadmin>

#define EMBED_BAN_COLOR "#0E40E6"
#define EMBED_PERMABAN_COLOR "#F00000"
#define EMBED_COMMSBAN_COLOR "#FF69B4"
#define EMBED_PERMACOMMSBAN_COLOR "#F00000"
#define EMBED_REPORT_COLOR "#FF9911"

char g_sBans_Webhook[256], g_sComms_Webhook[256], g_sReportPlayer_Webhook[256], g_sServerName[128], g_sServerIP[64], g_sServerPassword[128];

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] SourceBans & SourceComms",
	author = "Cruze",
	description = "Sends webhook on ban, mute, gag, silence and report.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public void OnPluginStart()
{
	LoadTranslations("du_sourcebans.phrases");
}

public void OnAutoConfigsBuffered()
{
	CreateTimer(1.0, Timer_OnAutoConfigsBuffered, _, TIMER_FLAG_NO_MAPCHANGE);		//Multimod support
}

public Action Timer_OnAutoConfigsBuffered(Handle timer)
{
	FindConVar("hostname").GetString(g_sServerName, sizeof(g_sServerName));
}

public void DUMain_OnServerPasswordChanged(const char[] oldVal, const char[] newVal)
{
	DUMain_GetServerPassword(g_sServerPassword);
}

public void DUMain_OnConfigLoaded()
{
	DUMain_GetString("webhook_bans", g_sBans_Webhook, 256);
	DUMain_GetString("webhook_comms", g_sComms_Webhook, 256);
	DUMain_GetString("webhook_report", g_sReportPlayer_Webhook, 256);
	DUMain_GetString("server_dns_name", g_sServerIP, 64);
	DUMain_GetServerPassword(g_sServerPassword);
}

public void MAOnClientMuted(int client, int target, char[] sIp, char[] sSteamID, char[] sName, int type, int time, char[] reason)
{
	if(StrEqual(g_sComms_Webhook, ""))
	{
		return;
	}
	if(type != MA_MUTE && type != MA_GAG && type != MA_SILENCE)
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sComms_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "MuteEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	if(time > 0)
	{
		embed.SetColor(EMBED_COMMSBAN_COLOR);
	}
	else
		embed.SetColor(EMBED_PERMACOMMSBAN_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sType[32], sLength[32], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	
	if(time > 0)
		Format(sLength, sizeof(sLength), "%T", "TimeInMinutes", LANG_SERVER, time);
	else
		Format(sLength, sizeof(sLength), "%T", "Permanent", LANG_SERVER, time);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	switch(type)
	{
		case MA_MUTE:
		{
			Format(sType, sizeof(sType), "%T", "MUTE", LANG_SERVER);
		}
		case MA_GAG:
		{
			Format(sType, sizeof(sType), "%T", "GAG", LANG_SERVER);
		}
		case MA_SILENCE:
		{
			Format(sType, sizeof(sType), "%T", "SILENCE", LANG_SERVER);
		}
	}
	
	Format(sTrans, 128, "%T", "Admin", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Player", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Length", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sLength, true));
	Format(sTrans, 128, "%T", "Type", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sType, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));
	
	if(g_sServerPassword[0])
	{
		Format(sDirectConnect, 256, "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sDirectConnect, 256, "steam://connect/%s", g_sServerIP);
	}
	
	Format(sTrans, 64, "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sDirectConnect, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}

public void SourceComms_OnBlockAdded(int client, int target, int time, int type, char[] reason)
{
	if(StrEqual(g_sComms_Webhook, ""))
	{
		return;
	}
	if(type != TYPE_MUTE && type != TYPE_GAG && type != TYPE_SILENCE)
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sComms_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "MuteEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	if(time > 0)
	{
		embed.SetColor(EMBED_COMMSBAN_COLOR);
	}
	else
		embed.SetColor(EMBED_PERMACOMMSBAN_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sType[32], sLength[32], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	if(time > 0)
		Format(sLength, sizeof(sLength), "%T", "TimeInMinutes", LANG_SERVER, time);
	else
		Format(sLength, sizeof(sLength), "%T", "Permanent", LANG_SERVER, time);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	switch(type)
	{
		case TYPE_MUTE:
		{
			Format(sType, sizeof(sType), "%T", "MUTE", LANG_SERVER);
		}
		case TYPE_GAG:
		{
			Format(sType, sizeof(sType), "%T", "GAG", LANG_SERVER);
		}
		case TYPE_SILENCE:
		{
			Format(sType, sizeof(sType), "%T", "SILENCE", LANG_SERVER);
		}
	}
	
	
	Format(sTrans, 128, "%T", "Admin", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Player", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Length", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sLength, true));
	Format(sTrans, 128, "%T", "Type", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sType, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));
	
	if(g_sServerPassword[0])
	{
		Format(sDirectConnect, 256, "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sDirectConnect, 256, "steam://connect/%s", g_sServerIP);
	}
	
	Format(sTrans, 64, "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sDirectConnect, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}

public void MAOnClientBanned(int client, int target, char[] sIp, char[] sSteamID, char[] sName, int time, char[] reason)
{
	if(StrEqual(g_sBans_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sBans_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "BanEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	if(time > 0)
	{
		embed.SetColor(EMBED_BAN_COLOR);
	}
	else
		embed.SetColor(EMBED_PERMABAN_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sLength[32], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	if(time > 0)
		Format(sLength, sizeof(sLength), "%T", "TimeInMinutes", LANG_SERVER, time);
	else
		Format(sLength, sizeof(sLength), "%T", "Permanent", LANG_SERVER, time);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	
	Format(sTrans, 128, "%T", "Admin", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Player", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Length", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sLength, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));
	
	if(g_sServerPassword[0])
	{
		Format(sDirectConnect, 256, "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sDirectConnect, 256, "steam://connect/%s", g_sServerIP);
	}
	
	Format(sTrans, 64, "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sDirectConnect, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}

public void SBPP_OnBanPlayer(int client, int target, int time, const char[] reason)
{
	if(StrEqual(g_sBans_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sBans_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "BanEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	if(time > 0)
	{
		embed.SetColor(EMBED_BAN_COLOR);
	}
	else
		embed.SetColor(EMBED_PERMABAN_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sLength[32], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	if(time > 0)
		Format(sLength, sizeof(sLength), "%T", "TimeInMinutes", LANG_SERVER, time);
	else
		Format(sLength, sizeof(sLength), "%T", "Permanent", LANG_SERVER, time);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	
	Format(sTrans, 128, "%T", "Admin", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Player", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Length", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sLength, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));
	
	if(g_sServerPassword[0])
	{
		Format(sDirectConnect, 256, "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sDirectConnect, 256, "steam://connect/%s", g_sServerIP);
	}
	
	Format(sTrans, 64, "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sDirectConnect, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}

public void MAOnClientReport(int client, int target, char[] reason)
{
	if(StrEqual(g_sReportPlayer_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sReportPlayer_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "ReportEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	embed.SetColor(EMBED_REPORT_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	
	Format(sTrans, 128, "%T", "Reporter", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Target", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));
	
	if(g_sServerPassword[0])
	{
		Format(sDirectConnect, 256, "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sDirectConnect, 256, "steam://connect/%s", g_sServerIP);
	}
	
	Format(sTrans, 64, "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sDirectConnect, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}

public void SBPP_OnReportPlayer(int client, int target, const char[] reason)
{
	if(StrEqual(g_sReportPlayer_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sReportPlayer_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "ReportEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	embed.SetColor(EMBED_REPORT_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	
	Format(sTrans, 128, "%T", "Reporter", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Target", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));

	if(g_sServerPassword[0])
	{
		Format(sDirectConnect, 256, "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sDirectConnect, 256, "steam://connect/%s", g_sServerIP);
	}
	
	Format(sTrans, 64, "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sDirectConnect, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}