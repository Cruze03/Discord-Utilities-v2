#if defined _DiscordException_included_
  #endinput
#endif
#define _DiscordException_included_

methodmap DiscordException __nullable__ /* < Exception */
{
	public DiscordException(const char[] error, any ...)
	{
		char buffer[1024];
		SetGlobalTransTarget(LANG_SERVER);
		VFormat(buffer, sizeof(buffer), error, 2);
		LogError("Discord Exception: %s", buffer);
		return view_as<DiscordException>(1);	// To avoid SM 1.11 compile error.
	}
}