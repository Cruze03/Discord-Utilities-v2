#if defined _DiscordChannelMention_included_
  #endinput
#endif
#define _DiscordChannelMention_included_

methodmap DiscordChannelMention < DiscordObject
{
	property DiscordChannelType Type
	{
		public get() { return view_as<DiscordChannelType>(this.GetInt("type")); }
	}

	public bool GetGuildID(char[] output, int maxsize)
	{
		return this.GetString("guild_id", output, maxsize);
	}

	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}
}