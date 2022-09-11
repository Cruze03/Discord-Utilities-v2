#if defined _DiscordTypeExtensions_included_
  #endinput
#endif
#define _DiscordTypeExtensions_included_

methodmap DiscordTypeExtension < JSON_Array
{
	/**
	* Release resources
	*/
	public void Dispose()
	{
		if(this == null)
			return;

		this.Cleanup();
		delete this;
	}
}

methodmap DiscordRoleList < DiscordTypeExtension { }
methodmap DiscordMessageList < DiscordTypeExtension { }
methodmap DiscordChannelList < DiscordTypeExtension { }
methodmap DiscordGuildList < DiscordTypeExtension { }
methodmap DiscordGuildScheduledEventList < DiscordTypeExtension { }