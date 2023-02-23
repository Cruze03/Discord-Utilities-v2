#include <sourcemod>
#include <discord>
#include <du2>

#define EMBED_COLOR "#FF0000"

#define COMMENT_COLOR "arm"
#define CONSOLE_LINES_TO_PRINT 10
#define CONSOLE_MAX_LINES 600
#define CONSOLE_MAX_LINE_MAX_LENGTH 512
#define MAX_LENGTH_CONSOLE (CONSOLE_MAX_LINES+CONSOLE_MAX_LINES) * CONSOLE_MAX_LINE_MAX_LENGTH

char g_sServerName[128];
Handle g_hAcceleratorLogs = null, g_hFile = null;
ArrayList g_hConsole;
char g_sAccPath[PLATFORM_MAX_PATH], g_sFilePath[PLATFORM_MAX_PATH], g_sMap[256], g_sDumpURL[256], g_sServerIP[64], g_sServerPassword[128], g_sChannelID[64], g_sChannelID2[64];
static char g_sText[MAX_LENGTH_CONSOLE+1];
Handle g_hReCheck = null;

public Plugin myinfo = 
{
	name = "[Discord Utilities v2] Crash Report",
	author = "johnoclock, Cruze",
	description = "Sends webhook when accelerator uploads a crash report.",
	version = DU_VERSION,
	url = "https://github.com/Cruze03"
};

public void OnPluginStart()
{
	BuildPath(Path_SM, g_sAccPath, sizeof(g_sAccPath), "logs/accelerator.log");
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "data/dumps/accelerator_discord.txt");
	
	delete g_hReCheck;
	
	LoadTranslations("du_crashreport.phrases");
}

public void DUMain_OnServerPasswordChanged(const char[] oldVal, const char[] newVal)
{
	DUMain_GetServerPassword(g_sServerPassword);
}

public void OnAutoConfigsBuffered()
{
	CreateTimer(1.0, Timer_OnAutoConfigsBuffered, _, TIMER_FLAG_NO_MAPCHANGE);		//Multimod support
}

public Action Timer_OnAutoConfigsBuffered(Handle timer)
{
	FindConVar("hostname").GetString(g_sServerName, sizeof(g_sServerName));
}

public void DUMain_OnConfigLoaded()
{
	DUMain_GetString("channel_crashreport", g_sChannelID, 64);
	DUMain_GetString("channel_crashreport_nonadmin", g_sChannelID2, 64);
	
	DUMain_GetString("server_dns_name", g_sServerIP, 64);
	DUMain_GetServerPassword(g_sServerPassword);
}

public void OnMapInit(const char[] mapName)
{
	GetMapDisplayName(mapName, g_sMap, sizeof(g_sMap));
	ReadCoreCFG();
	CheckConsoleLogs();
	if(g_hReCheck == null)
		g_hReCheck = CreateTimer(6.0, Timer_ReCheckCrash, _, TIMER_FLAG_NO_MAPCHANGE);
}

void CheckConsoleLogs()
{
	g_sText[0] = '\0';
	char sPath[PLATFORM_MAX_PATH], sTemp[CONSOLE_MAX_LINE_MAX_LENGTH+1], sFileName[128];
	BuildPath(Path_SM, sPath, PLATFORM_MAX_PATH, "data/dumps/");
	bool bFound = false;
	int size = ByteCountToCells(CONSOLE_MAX_LINE_MAX_LENGTH);
	g_hConsole = new ArrayList(size);
	
	if(DirExists(sPath))
	{
		Handle dir;
		if((dir = OpenDirectory(sPath)) != null)
		{
			FileType fileType = FileType_Unknown;
			size = ByteCountToCells(128);
			ArrayList hFileNames = new ArrayList(size);
			ArrayList hFileTimestamps = new ArrayList(size);
			
			while(ReadDirEntry(dir, sFileName, sizeof(sFileName), fileType))
			{
				if(strcmp(sFileName, "server-id.txt", false) != 0 && strcmp(sFileName, ".", false) != 0 && strcmp(sFileName, "..", false) != 0 && StrContains(sFileName, ".txt", false) != -1)
				{
					if(fileType == FileType_File)
					{
						char tPath[PLATFORM_MAX_PATH];
						strcopy(tPath, sizeof(tPath), sPath);
						StrCat(tPath, sizeof(tPath), sFileName);
						int tStamp = GetFileTime(tPath, FileTime_LastChange);
						hFileNames.PushString(sFileName);
						hFileTimestamps.Push(tStamp);
						
						bFound = true;
					}
				}
			}
			
			if(bFound)
			{
				int greatest = hFileTimestamps.Get(0), count = 0, value;
				for(int i = 0; i < hFileTimestamps.Length; i++)
				{
					value = hFileTimestamps.Get(i);
					if(greatest < value)
					{
						greatest = value;
						count = i;
					}
				}
				
				hFileNames.GetString(count, sFileName, sizeof(sFileName));
			}
			delete hFileNames;
			delete hFileTimestamps;
		}
		CloseHandle(dir);
	}
	if(bFound)
	{
		Format(sPath, PLATFORM_MAX_PATH, "%s/%s", sPath, sFileName);
		Handle hFile = OpenFile(sPath, "r");
		if(hFile != null)
		{
			bool bSave = false;
			while(!IsEndOfFile(hFile) && ReadFileLine(hFile, sTemp, sizeof(sTemp)))
			{
				ReplaceString(sTemp, sizeof(sTemp), "\\", "/");
				
				if(StrContains(sTemp, "CONSOLE HISTORY BEGIN", false) != -1)
				{
					bSave = true;
				}
				
				if(!bSave)
					continue;
				
				if(strlen(sTemp) < 3)
					continue;
				
				g_hConsole.PushString(sTemp);
			}
		}
		CloseHandle(hFile);
		EliminateLines(g_sText, sizeof(g_sText));
	}
}

void CheckCrash()
{
	g_hAcceleratorLogs = OpenFile(g_sAccPath, "r");
	if(g_hAcceleratorLogs == null)
	{
		return;
	}
	g_hFile = OpenFile(g_sFilePath, "a+");
	char sSearch[32], sTemp[CONSOLE_MAX_LINE_MAX_LENGTH], sCrashID[128], sStoredCrashID[64];
	int index, len;
	
	while(!IsEndOfFile(g_hAcceleratorLogs) && ReadFileLine(g_hAcceleratorLogs, sTemp, sizeof(sTemp)))
	{
		len = strlen(sTemp);

		if (len < 3)
		{
			continue;
		}
		
		if(StrContains(sTemp, "Rate limit exceeded", false) != -1)
		{
			strcopy(sCrashID, sizeof(sCrashID), "Rate limit exceeded");
			continue;
		}
		
		if(StrContains(sTemp, "Uploaded crash dump: Crash ID: ", false) != -1)
		{
			strcopy(sCrashID, sizeof(sCrashID), sTemp);
		}
	}
	
	Format(sSearch, sizeof(sSearch), "Uploaded crash dump: Crash ID: ");
	index = StrContains(sCrashID, sSearch);
	if(index != -1 && sCrashID[0])
	{
		ReplaceString(sCrashID, sizeof(sCrashID), sSearch, "");
		TrimString(sCrashID);
		
		if(g_hFile != null)
		{
			while(!IsEndOfFile(g_hFile) && ReadFileLine(g_hFile, sTemp, sizeof(sTemp)))
			{
				if (sTemp[0] == '/' && sTemp[1] == '/' || IsCharSpace(sTemp[0]) || !sTemp[0])
				{
					continue;
				}

				ReplaceString(sTemp, sizeof(sTemp), "\n", "");
				ReplaceString(sTemp, sizeof(sTemp), "\r", "");
				ReplaceString(sTemp, sizeof(sTemp), "\t", "");

				len = strlen(sTemp);

				if (len < 3)
				{
					continue;
				}

				strcopy(sStoredCrashID, sizeof(sStoredCrashID), sTemp);
			}
		}
	}
	else if(strcmp(sCrashID, "Rate limit exceeded", false) != 0)
		return;
	
	if(strcmp(sCrashID, sStoredCrashID) != 0 || !strcmp(sStoredCrashID, "") || !strcmp(sCrashID, "Rate limit exceeded"))
	{
		SendCrashReportToDiscord(sCrashID);
	}
}

public Action Timer_ReCheckCrash(Handle timer)
{
	g_hReCheck = null;
	CheckCrash();
}

public Action Timer_SendCrashReportToDiscord(Handle timer, DataPack pack)
{
	pack.Reset();
	char sCrashID[128];
	pack.ReadString(sCrashID, sizeof(sCrashID));
	SendCrashReportToDiscord(sCrashID);
}	

public void SendCrashReportToDiscord(char[] sCrashID)
{
	if(DUMain_Bot() == INVALID_HANDLE)
	{
		DataPack data = new DataPack();
		CreateDataTimer(3.0, Timer_SendCrashReportToDiscord, data, TIMER_FLAG_NO_MAPCHANGE);
		data.WriteString(sCrashID);
		return;
	}
	if(strlen(g_sChannelID) < LEN_ID)
	{
		if(strlen(g_sChannelID2) >= LEN_ID)
		{
			SendCrashReportToDiscordNA();
		}
		if(strcmp(sCrashID, "Rate limit exceeded", false) != 0)
		{
			WriteFileLine(g_hFile, "%s", sCrashID);

			CloseHandle(g_hFile);
		}
		
		int size = ByteCountToCells(CONSOLE_MAX_LINE_MAX_LENGTH);
		g_hConsole = new ArrayList(size);
		return;
	}
	
	static char sConsole[MAX_LENGTH_CONSOLE+1];
	sConsole[0] = '\0';
	
	char sBuffer[256], sBuf[256];
	
	DiscordMessage message = new DiscordMessage(" ");
	
	DiscordEmbed embed = new DiscordEmbed();
	
	Format(sBuffer, sizeof(sBuffer), "%T", "ServerCrashedTitle", LANG_SERVER);
	embed.WithTitle(sBuffer);
	
	embed.SetColor(EMBED_COLOR);
	
	Format(sBuffer, sizeof(sBuffer), "%T", "CrashIDField", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sBuffer, sCrashID, true));
	
	if(strcmp(sCrashID, "Rate limit exceeded", false) != 0)
	{
		Format(sBuffer, sizeof(sBuffer), "%T", "LinkField", LANG_SERVER);
		
		strcopy(sBuf, sizeof(sBuf), g_sDumpURL);
		ReplaceString(sBuf, sizeof(sBuf), "submit", "");
	
		Format(sBuf, sizeof(sBuf), "[Click here](%s?id=%s)", sBuf, sCrashID);
		
		embed.AddField(new DiscordEmbedField(sBuffer, sBuf, true));
	
		if(strcmp(g_sText, "{NONE}", false) != 0 && g_sText[0])
		{
			Format(sConsole, sizeof(sConsole), "```%s\n%s\n```\n \n ", COMMENT_COLOR, g_sText);
			embed.WithDescription(sConsole);
		}
	}
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	message.Embed(embed);
	
	DUMain_Bot().SendMessageToChannelID(g_sChannelID, message);
	
	DisposeObject(message);
	
	SendCrashReportToDiscordNA();
	
	if(strcmp(sCrashID, "Rate limit exceeded", false) != 0)
	{
		WriteFileLine(g_hFile, "%s", sCrashID);

		CloseHandle(g_hFile);
	}
	
	int size = ByteCountToCells(CONSOLE_MAX_LINE_MAX_LENGTH);
	g_hConsole = new ArrayList(size);
}

public void SendCrashReportToDiscordNA()
{
	DiscordMessage message = new DiscordMessage(" ");
	
	DiscordEmbed embed = new DiscordEmbed();
	
	embed.SetColor(EMBED_COLOR);
	
	char sTrans[256], sBuffer[256];
	Format(sTrans, sizeof(sTrans), "%T", "ServerCrashedTitle", LANG_SERVER);
	embed.WithTitle(sTrans);
	
	Format(sTrans, sizeof(sTrans), "%T", "Map", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, g_sMap, true));
	
	if(g_sServerPassword[0])
	{
		Format(sBuffer, sizeof(sBuffer), "steam://connect/%s/%s", g_sServerIP, g_sServerPassword);
	}
	else
	{
		Format(sBuffer, sizeof(sBuffer), "steam://connect/%s", g_sServerIP);
	}
	Format(sTrans, sizeof(sTrans), "%T", "DirectConnect", LANG_SERVER);
	embed.AddField(new DiscordEmbedField(sTrans, sBuffer, false));
	
	embed.WithFooter(new DiscordEmbedFooter(g_sServerName));
	
	message.Embed(embed);
	
	DUMain_Bot().SendMessageToChannelID(g_sChannelID2, message);
	
	DisposeObject(message);
}

stock void EliminateLines(char[] sText, int size)
{
	if(!g_hConsole)
	{
		strcopy(sText, size, "{NONE}");
		return;
	}
	if(g_hConsole.Length < 1)
	{
		strcopy(sText, size, "{NONE}");
		return;
	}
	
	char sBuffer[CONSOLE_MAX_LINE_MAX_LENGTH], sMessage[MAX_LENGTH_CONSOLE+1];
	int count = g_hConsole.Length - CONSOLE_LINES_TO_PRINT;
	--count;
	
	for(int i = 0; i < g_hConsole.Length; i++)
	{
		if(i > CONSOLE_LINES_TO_PRINT && i < count)
		{
			if(i == CONSOLE_LINES_TO_PRINT+1 && sMessage[0])
			{
				Format(sMessage, sizeof(sMessage), "%s\n...\n...\n...\n \n", sMessage);
			}
			continue;
		}
		
		g_hConsole.GetString(i, sBuffer, CONSOLE_MAX_LINE_MAX_LENGTH);
		
		if(sMessage[0])
			Format(sMessage, sizeof(sMessage), "%s%s", sMessage, sBuffer);
		else
			Format(sMessage, sizeof(sMessage), "%s", sBuffer);
	}
	strcopy(sText, size, sMessage);
}

public bool ReadCoreCFG()
{
	static SMCParser hParser;
	if(!hParser)
		hParser = new SMCParser();
	
	hParser.OnEnterSection = Config_CoreNewSection;
	hParser.OnLeaveSection = Config_CoreEndSection;
	hParser.OnKeyValue = Config_CoreKeyValue;
	hParser.OnEnd = Config_CoreEnd;
	
	char configPath[256];
	BuildPath(Path_SM, configPath, sizeof(configPath), "configs/core.cfg");

	int line;
	SMCError err = hParser.ParseFile(configPath, line);
	if (err != SMCError_Okay)
	{
		char error[256];
		SMC_GetErrorString(err, error, sizeof(error));
		LogError("[DiscordUtilitiesv2-CrashReport] Unable to parse file (line %d) [File: %s]", line, configPath);
		SetFailState("[DiscordUtilitiesv2-CrashReport] Parser encountered error: %s", error);
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
	if(StrEqual(key, "MinidumpUrl", false))
		strcopy(g_sDumpURL, sizeof(g_sDumpURL), value);

	return SMCParse_Continue;
}

public SMCResult Config_CoreEndSection(SMCParser parser) 
{
	return SMCParse_Continue;
}

public void Config_CoreEnd(SMCParser parser, bool halted, bool failed) 
{
	if(!g_sDumpURL[0])
	{
		strcopy(g_sDumpURL, sizeof(g_sDumpURL), "http://crash.limetech.org/submit");
	}
}