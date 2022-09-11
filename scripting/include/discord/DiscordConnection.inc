#if defined _DiscordConnection_included_
  #endinput
#endif
#define _DiscordConnection_included_

enum DiscordConnectionVisibility
{
	Visibility_NONE = 0,
	Visibility_EVERTYONE = 1
}

methodmap DiscordConnection < DiscordObject
{
	property bool Revoked
	{
		public get() { return this.GetBool("revoked"); }
	}

	property bool Verified
	{
		public get() { return this.GetBool("verified"); }
	}

	property bool FriendSync
	{
		public get() { return this.GetBool("friend_sync"); }
	}

	property bool ShowActivity
	{
		public get() { return this.GetBool("show_activity"); }
	}

	property DiscordConnectionVisibility Visibility
	{
		public get() { return view_as<DiscordConnectionVisibility>(this.GetInt("visibility")); }
	}

	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	public bool GetType(char[] output, int maxsize)
	{
		return this.GetString("type", output, maxsize);
	}

	public JSON_Array GetIntegrations()
	{
		return view_as<JSON_Array>(this.GetObject("integrations"));
	}
}