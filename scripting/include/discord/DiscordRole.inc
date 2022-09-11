#if defined _DiscordRole_included_
  #endinput
#endif
#define _DiscordRole_included_

methodmap DiscordRoleTag < JSON_Object
{
	//TODO
}

methodmap DiscordRole < DiscordObject
{
	property int Color
	{
		public get() { return this.GetInt("color"); }
	}

	property int Position
	{
		public get() { return this.GetInt("position"); }
	}

	property bool Hoist
	{
		public get() { return this.GetBool("hoist"); }
	}

	property bool Managed
	{
		public get() { return this.GetBool("managed"); }
	}

	property bool Mentionable
	{
		public get() { return this.GetBool("mentionable"); }
	}

	property DiscordRoleTag Tags
	{
		public get() { return view_as<DiscordRoleTag>(this.GetObject("tags")); }
	}

	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	public bool GetPermissions(char[] output, int maxsize)
	{
		return this.GetString("permissions", output, maxsize);
	}

	public int GetColor()
	{
		return this.Color;
	}
}