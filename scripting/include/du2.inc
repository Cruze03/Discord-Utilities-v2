#if defined _discord_utilities_v2_included
 #endinput
#endif
#define _discord_utilities_v2_included

#define DU_VERSION "1.0.3"

const int LEN_ID = 10;				// Channel ID length less than this value is considered invalid
const int MAX_COMMANDS = 64;		// Max commands possible in "VERIFICATION_SETTINGS" > "blocked_commands"

//du_main
native void DUMain_UpdateConfig();
native void DUMain_ReloadConfig();
native bool DUMain_IsConfigLoaded();
native bool DUMain_GetString(char[] key, char[] value, int size);
native bool DUMain_SetString(char[] key, char[] value, int size);
native void DUMain_GetServerPassword(char[] password);

native DiscordBot DUMain_Bot();

forward void DUMain_OnConfigLoaded();
forward void DUMain_OnServerPasswordChanged(const char[] oldValue, const char[] newValue);

//du_verification
native bool DUVerification_IsChecked(int client);
native bool DUVerification_IsMember(int client);
native bool DUVerification_GetUserId(int client, char[] sUserID, int size);

forward void DUVerification_OnLinkedAccount(int client, char[] sUserID, char[] sUsername, char[] sDiscriminator);
forward void DUVerification_OnAccountRevoked(int client, char[] sUserID);
forward void DUVerification_OnClientLoaded(int client);
forward Action DUVerification_OnBlockedCommandUse(int client, char[] sCommand);


stock void Discord_EscapeString(char[] string, int maxlen, bool name = false)
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

public void DisposeObject(JSON_Object &obj)
{
	json_cleanup_and_delete(obj);
}

public SharedPlugin __pl_discord_utilities_v2 =
{
		name = "DiscordUtilitiesv2",
		file = "du_main.smx",
	#if defined REQUIRE_PLUGIN
		required = 1,
	#else
		required = 0,
	#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_discord_utilities_v2_SetNTVOptional()
{
	MarkNativeAsOptional("DUMain_Bot");
	MarkNativeAsOptional("DUParser_UpdateConfig");
	MarkNativeAsOptional("DUParser_ReloadConfig");
	MarkNativeAsOptional("DUMain_IsConfigLoaded");
	MarkNativeAsOptional("DUParser_GetString");
	MarkNativeAsOptional("DUParser_SetString");
	MarkNativeAsOptional("DU_IsChecked");
	MarkNativeAsOptional("DU_IsMember");
	MarkNativeAsOptional("DU_GetUserId");
}
#endif 
