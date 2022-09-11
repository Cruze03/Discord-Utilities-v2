#if defined _DiscordEmoji_included_
  #endinput
#endif
#define _DiscordEmoji_included_

methodmap DiscordEmoji < DiscordObject
{
	/**
	* Roles allowed to use this emoji
	*
	* @return	 Array of role object ids
	*/
	property JSON_Array Roles
	{
		public get() { return view_as<JSON_Array>(this.GetObject("roles")); }
	}

	/**
	* User that created this emoji
	*
	* @return	 DiscordUser 'object'
	*/
	property DiscordUser User
	{
		public get() { return view_as<DiscordUser>(this.GetObject("user")); }
	}

	/**
	* Whether this emoji must be wrapped in colons
	*/
	property bool RequireColons
	{
		public get() { return this.GetBool("require_colons"); }
	}

	/**
	* Whether this emoji is managed
	*/
	property bool Managed
	{
		public get() { return this.GetBool("managed"); }
	}

	/**
	* Whether this emoji is animated
	*/
	property bool Animated
	{
		public get() { return this.GetBool("animated"); }
	}

	/**
	* Whether this emoji can be used, may be false due to loss of Server Boosts
	*/
	property bool Available
	{
		public get() { return this.GetBool("available"); }
	}

	/**
	* Get emoji name.
	*
	* @param output		Output buffer.
	* @param maxsize	Length of the buffer.
	* @return			True on success, false otherwise.
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	public static DiscordEmoji FromName(const char[] name)
	{
		DiscordEmoji emoji = view_as<DiscordEmoji>(new JSON_Object());
		emoji.SetString("name", name);
		return emoji;
	}
}