#include <sourcemod>
#include <discord>
#include <du2>
#include <bugreport>

#define EMBED_COLOR "#FF9911"

char g_sBugReport_Webhook[256], g_sServerName[128], g_sServerIP[64], g_sServerPassword[128];

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Bug Report",
	author = "Cruze",
	description = "Sends webhook when someone uses !bugreport.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public void OnPluginStart()
{
	LoadTranslations("du_bugreport.phrases");
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
	DUMain_GetString("webhook_bugreport", g_sBugReport_Webhook, 256);
	DUMain_GetString("server_dns_name", g_sServerIP, 64);
	
	DUMain_GetServerPassword(g_sServerPassword);
}

public void BugReport_OnReportPost(int client, const char[] map, const char[] reason, ArrayList array)
{
	if(StrEqual(g_sBugReport_Webhook, ""))
	{
		return;
	}
	
	char sTrans[128];
	
	DiscordWebHook hook = new DiscordWebHook(g_sBugReport_Webhook);
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sTrans, 128, "%T", "EmbedTitle", LANG_SERVER);
	
	embed.WithTitle(sTrans);
	
	embed.SetColor(EMBED_COLOR);
	
	char sCName[32], sCSteamID[32], sCSteamID64[32], sClient[128], sReason[128], sMap[256], sDirectConnect[256];
	
	GetClientName(client, sCName, sizeof(sCName));
	GetClientAuthId(client, AuthId_Steam2, sCSteamID, sizeof(sCSteamID));
	GetClientAuthId(client, AuthId_SteamID64, sCSteamID64, sizeof(sCSteamID64));
	
	Format(sClient, sizeof(sClient), "[%s](http://www.steamcommunity.com/profiles/%s) (%s)", sCName, sCSteamID64, sCSteamID);
	Format(sReason, sizeof(sReason), "%s", reason);
	Format(sMap, sizeof(sMap), "%s", map);
	
	Discord_EscapeString(sClient, sizeof(sClient));
	Discord_EscapeString(sReason, sizeof(sReason));
	Discord_EscapeString(sMap, sizeof(sMap));
	
	
	Format(sTrans, 128, "%T", "Reporter", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sClient, true));
	Format(sTrans, 128, "%T", "Map", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sMap, true));
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