#if defined _DiscordMessageReference_included_
  #endinput
#endif
#define _DiscordMessageReference_included_

methodmap DiscordMessageReference < JSON_Object
{
	/**
	*	when sending, whether to error if the referenced message doesn't exist instead of sending as a normal (non-reply) message, default true
	*/
	property bool FailIfNotExists
	{
		public get() { return this.GetBool("fail_if_not_exists"); }
		public set(bool value) { this.SetBool("fail_if_not_exists", value); }
	}

	public DiscordMessageReference(const char[] message_id, const char[] channel_id, const char[] guild_id, bool fail_if_not_exists)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("message_id", message_id);
		obj.SetString("channel_id", channel_id);
		obj.SetString("guild_id", guild_id);
		obj.SetBool("fail_if_not_exists", fail_if_not_exists);
		return view_as<DiscordMessageReference>(obj);
	}

	/**
	*	id of the originating message
	*/
	public bool GetMessageID(char[] output, int maxsize)
	{
		return this.GetString("message_id", output, maxsize);
	}

	/**
	*	id of the originating message
	*/
	public void SetMessageID(const char[] messageid)
	{
		this.SetString("message_id", messageid);
	}

	/**
	*	id of the originating message's channel
	*/	
	public bool GetChannelID(char[] output, int maxsize)
	{
		return this.GetString("channel_id", output, maxsize);
	}

	/**
	*	id of the originating message's channel
	*/
	public void SetChannelID(const char[] channelid)
	{
		this.SetString("channel_id", channelid);
	}

	/**
	*	id of the originating message's guild
	*/
	public bool GetGuildID(char[] output, int maxsize)
	{
		return this.GetString("guild_id", output, maxsize);
	}

	/**
	*	id of the originating message's guild
	*/
	public void SetGuildID(const char[] guildid)
	{
		this.SetString("guild_id", guildid);
	}
}