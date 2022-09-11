#if defined _DiscordGuildUser_included_
  #endinput
#endif
#define _DiscordGuildUser_included_

#include <discord/DiscordUser>

#define MAX_DISCORD_NICKNAME_LENGTH 32

methodmap DiscordGuildUser < JSON_Object
{
	/**
	*	the user this guild member represents
	*/
	public DiscordUser GetUser()
	{
		return view_as<DiscordUser>(this.GetObject("user"));
	}

	/**
	*	whether the user is deafened in voice channels
	*/
	property bool IsDeafened
	{
		public get() { return this.GetBool("deaf"); }
	}

	/**
	*	whether the user is muted in voice channels
	*/
	property bool IsMuted
	{
		public get() { return this.GetBool("mute"); }
	}

	/**
	*	whether the user has not yet passed the guild's Membership Screening requirements
	*/
	property bool IsPending
	{
		public get() { return this.GetBool("pending"); }
	}

	/**
	*	the member's guild avatar hash
	*	( https://discord.com/developers/docs/reference#image-formatting )
	*/
	public bool GetAvatar(char[] output, int maxsize)
	{
		return this.GetString("avatar", output, maxsize);
	}

	/**
	*	this user's guild nickname
	*/
	public bool GetNickname(char[] output, int maxsize)
	{
		return this.GetString("nick", output, maxsize);
	}

	/**
	*	total permissions of the member in the channel, including overwrites, returned when in the interaction object
	*/
	public bool GetPermissions(char[] output, int maxsize)
	{
		return this.GetString("permissions", output, maxsize);
	}

	/**
	*	when the user joined the guild
	*/
	public bool GetJoinedDate(char[] buffer, int maxsize)
	{
		return this.GetString("joined_at", buffer, maxsize);
	}

	/**
	*	when the user joined the guild
	*/
	public bool GetJoinedDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("joined_at", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	when the user started boosting the guild
	*/
	public bool GetBoostingSince(char[] buffer, int maxsize)
	{
		return this.GetString("premium_since", buffer, maxsize);
	}

	/**
	*	when the user started boosting the guild
	*/
	public bool GetBoostingSinceDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("premium_since", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	when the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
	*/
	public bool GetTimeoutDate(char[] buffer, int maxsize)
	{
		return this.GetString("communication_disabled_until", buffer, maxsize);
	}

	/**
	*	when the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
	*/
	public bool GetTimeoutDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("communication_disabled_until", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	array of role object ids
	*	! array of snowflakes !
	*/
	public DiscordRoleList GetRoles()
	{
		return view_as<DiscordRoleList>(this.GetObject("roles"));
	}

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