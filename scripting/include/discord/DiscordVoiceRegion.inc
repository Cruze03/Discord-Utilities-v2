#if defined _DiscordVoiceRegion_included_
  #endinput
#endif
#define _DiscordVoiceRegion_included_

methodmap DiscordVoiceRegion < JSON_Object
{
	/**
	*   whether this is a vip voice region
	*/
	property bool VipOnly
	{
		public get() { return this.GetBool("vip"); }
	}

	/**
	*   true for a single server that is closest to the current user's client
	*/
	property bool Optimal
	{
		public get() { return this.GetBool("optimal"); }
	}

	/**
	*   whether this is a deprecated voice region (avoid switching to these)
	*/
	property bool Deprecated
	{
		public get() { return this.GetBool("deprecated"); }
	}

	/**
	*   whether this is a custom voice region (used for events/etc)
	*/
	property bool Custom
	{
		public get() { return this.GetBool("custom"); }
	}

	/**
	*   name of the region
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	*   unique ID for the region
	*/
	public bool GetID(char[] output, int maxsize)
	{
		return this.GetString("id", output, maxsize);
	}
}