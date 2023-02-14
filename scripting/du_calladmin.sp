#include <sourcemod>
#include <discord>
#include <du2>
#include <calladmin>

#define EMBED_COLOR "#FF9911"

char g_sCallAdmin_Webhook[256], g_sServerName[128], g_sServerIP[64], g_sServerPassword[128];
int g_iLastReportID = -1;

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Call Admin",
	author = "Cruze",
	description = "Sends webhook when someone uses !calladmin or some admin handles the report.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public void OnPluginStart()
{
	LoadTranslations("du_calladmin.phrases");
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
	DUMain_GetString("webhook_calladmin", g_sCallAdmin_Webhook, 256);
	DUMain_GetString("server_dns_name", g_sServerIP, 64);
	
	DUMain_GetServerPassword(g_sServerPassword);
}

public void CallAdmin_OnReportHandled(int client, int id)
{
	if(StrEqual(g_sCallAdmin_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sCallAdmin_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	embed.SetColor(EMBED_COLOR);
	
	Format(sTrans, 128, "%T", "HandleEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	char sCName[32], sCSteamID[32], sCSteamID64[32], sClient[128], sReportID[16];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sReportID, sizeof(sReportID), "%i", id);
	Discord_EscapeString(sClient, sizeof(sClient));
	
	Format(sTrans, 128, "%T", "Handler", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "ReportID", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReportID, true));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	
	hook.Embed(embed);
	hook.Send();
	
	DisposeObject(hook);
}

public void CallAdmin_OnReportPost(int client, int target, const char[] reason)
{
	if(StrEqual(g_sCallAdmin_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	g_iLastReportID = CallAdmin_GetReportID();
	
	DiscordWebHook hook = new DiscordWebHook(g_sCallAdmin_Webhook);
	Format(sTrans, 128, "%T", "ReportMessageTitle", LANG_SERVER, g_iLastReportID);
	
	hook.SetContent(sTrans);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "ReportEmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	embed.SetColor(EMBED_COLOR);
	
	char sCName[32], sTName[32], sCSteamID[32], sTSteamID[32], sCSteamID64[32], sTSteamID64[32], sClient[128], sTarget[128], sReason[128], sReportID[16], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientName(target, sTName, sizeof(sTName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(target, AuthId_Steam2, sTSteamID, sizeof(sTSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	GetClientAuthId(target, AuthId_SteamID64, sTSteamID64, sizeof(sTSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sTarget, sizeof(sTarget), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sTName, sTSteamID64, sTSteamID);
	Format(sReason, sizeof(sReason), "%s", reason);
	
	Format(sReportID, sizeof(sReportID), "%i", g_iLastReportID);
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sTarget, sizeof(sTarget));
	Discord_EscapeString(sReason, sizeof(sReason));
	
	Format(sTrans, 128, "%T", "Reporter", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Target", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sTarget, true));
	Format(sTrans, 128, "%T", "Reason", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReason, true));
	Format(sTrans, 128, "%T", "ReportID", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sReportID, true));
	
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