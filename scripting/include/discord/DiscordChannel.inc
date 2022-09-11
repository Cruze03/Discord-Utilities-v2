#if defined _DiscordChannel_included_
  #endinput
#endif
#define _DiscordChannel_included_

#include <discord/DiscordObject>

enum DiscordChannelType
{
	GUILD_TEXT = 0, /* a text channel within a server */
	DM, /* a direct message between users */
	GUILD_VOICE, /* a voice channel within a server */
	GROUP_DM, /* a direct message between multiple users */
	GUILD_CATEGORY, /* an organizational category that contains up to 50 channels. for further info: https://support.discord.com/hc/en-us/articles/115001580171-Channel-Categories-101 */
	GUILD_NEWS, /* a channel that users can follow and crosspost into their own server. for further info: https://support.discord.com/hc/en-us/articles/360032008192 */
	GUILD_STORE, /* a channel in which game developers can sell their game on Discord. for further info: https://discord.com/developers/docs/game-and-server-management/special-channels */
	GUILD_NEWS_THREAD = 10, /* a temporary sub-channel within a GUILD_NEWS channel */
	GUILD_PUBLIC_THREAD, /* a temporary sub-channel within a GUILD_TEXT channel */
	GUILD_PRIVATE_THREAD, /* a temporary sub-channel within a GUILD_TEXT channel that is only viewable by those invited and those with the MANAGE_THREADS permission */
	GUILD_STAGE_VOICE, /* a voice channel for hosting events with an audience. for further info: https://support.discord.com/hc/en-us/articles/1500005513722 */
	GUILD_DIRECTORY, /* the channel in a hub containing the listed servers */
	GUILD_FORUM /* (still in development) a channel that can only contain threads, The GUILD_FORUM channel type is still in active development. Avoid implementing any features that are not documented here, since they are subject to change without notice! */
}

enum DiscordChannelVideoQualityMode
{
	AUTO = 1, /* Discord chooses the quality for optimal performance */
	FULL /* 720p */
}

enum DiscordChannelFlags
{
	PINNED = (1 << 1) /* this thread is pinned to the top of its parent forum channel */
}

/**
* Called as callback when a new message received on a listened channel.
*
* @param bot		same handle as the bot you have used to call the native.
* @param channel	DiscordChannel object received.
* @param message	DiscordMessage object received.
*
* @noreturn
*/
typedef OnDiscordChannelMessage = function void (DiscordBot bot, DiscordChannel channel, DiscordMessage message);

/** DiscordBot.ModifyChannel | DiscordBot.ModifyChannelID
*
* Called as callback after a successful request.
*
*/
typeset OnDiscordChannelModified
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel, any data, any data2);
}

/** DiscordBot.DeleteChannel
*
* Called as callback after a successful request.
*
*/
typeset OnDiscordChannelDeleted
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel, any data, any data2);
}

/** DiscordBot.GetChannel
*
* Called as callback after a successful request.
*
*/
typeset OnGetDiscordChannel
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param channel	DiscordChannel object received.
	*					DiscordChannel handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordChannel channel, any data, any data2);
}

/**
* The thread metadata object contains a number of thread-specific channel fields that are not needed by other channel types.
*/
methodmap ThreadMetaData < JSON_Object
{
	/**
	*	whether the thread is archived
	*/
	property bool Archived
	{
		public get() { return this.GetBool("archived"); }
	}

	/**
	* 	duration in minutes to automatically archive the thread after recent activity, can be set to: 60, 1440, 4320, 10080
	*/
	property int AutoArchiveDuration
	{
		public get() { return this.GetInt("auto_archive_duration"); }
	}

	/**
	*	whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
	*/
	property bool Locked
	{
		public get() { return this.GetBool("locked"); }
	}

	/**
	*	whether non-moderators can add other non-moderators to a thread; only available on private threads
	*/
	property bool Invitable
	{
		public get() { return this.GetBool("invitable"); }
	}

	/**
	*	timestamp when the thread was created; only populated for threads created after 2022-01-09
	*/
	public bool GetCreateTimestampDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("create_timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	timestamp when the thread was created; only populated for threads created after 2022-01-09
	*/
	public bool GetCreateTimestamp(char[] output, int maxsize)
	{
		return this.GetString("create_timestamp", output, maxsize);
	}

	/**
	*	timestamp when the thread's archive status was last changed, used for calculating recent activity
	*/
	public bool GetArchiveTimestampDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("archive_timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	timestamp when the thread's archive status was last changed, used for calculating recent activity
	*/
	public bool GetArchiveTimestamp(char[] output, int maxsize)
	{
		return this.GetString("archive_timestamp", output, maxsize);
	}

	/**
	*	Release resources
	*/
	public void Dispose()
	{
		if(this == null)
			return;

		this.Cleanup();
		delete this;
	}
}

/**
* A thread member is used to indicate whether a user has joined a thread or not.
*/
methodmap ThreadMember < DiscordObject
{
	/**
	*	any user-thread settings, currently only used for notifications
	*/
	property int Flags
	{
		public get() { return this.GetInt("flags"); }
	}

	/**
	*	the id of the user
	*/
	public bool GetUserID(char[] output, int maxsize)
	{
		return this.GetString("user_id", output, maxsize);
	}

	/**
	*	the time the current user last joined the thread
	*/
	public bool GetJoinTimestampDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("join_timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	the time the current user last joined the thread
	*/
	public bool GetJoinTimestamp(char[] output, int maxsize)
	{
		return this.GetString("join_timestamp", output, maxsize);
	}
}

/**
* Represents a guild or DM channel within Discord.
*/
methodmap DiscordChannel < DiscordObject
{
	/**
	* 	the type of channel
	*/
	property DiscordChannelType Type
	{
		public get() { return view_as<DiscordChannelType>(this.GetInt("type")); }

		public set(DiscordChannelType value) { this.SetInt("type", view_as<int>(value)); }
	}

	/**
	*	whether the channel is nsfw
	*/
	property bool IsNSFW
	{
		public get() { return this.GetBool("nsfw"); }

		public set(bool value) { this.SetBool("nsfw", value); }
	}

	/**
	* 	the bitrate (in bits) of the voice channel
	*/
	property int Bitrate
	{
		public get() { return this.GetInt("bitrate"); }

		public set(int value) { this.SetInt("bitrate", value); }
	}

	/**
	*	the user limit of the voice channel
	*/
	property int UserLimit
	{
		public get() { return this.GetInt("user_limit"); }

		public set(int value) { this.SetInt("user_limit", value); }
	}

	/**
	*	whether the channel is text
	*/
	property bool IsText
	{
		public get() { return this.Type == GUILD_TEXT; }
	}

	/**
	*	whether the channel is private DM
	*/
	property bool IsPrivate
	{
		public get() { return this.Type == DM; }
	}

	/**
	*	the camera video quality mode of the voice channel, 1 (AUTO) when not present
	*/
	property DiscordChannelVideoQualityMode VideoQualityMode
	{
		public get() { return view_as<DiscordChannelVideoQualityMode>(this.GetInt("video_quality_mode")); }
	}

	/**
	* 	an approximate count of users in a thread, stops counting at 50
	*/
	property int MemberCount
	{
		public get() { return this.GetInt("member_count"); }
	}

	/**
	*	an approximate count of messages in a thread, stops counting at 50
	*/
	property int MessageCount
	{
		public get() { return this.GetInt("message_count"); }
	}

	/**
	*	sorting position of the channel
	*/
	property int Position
	{
		public get() { return this.GetInt("position"); }

		public set(int value) { this.SetInt("position", value); }
	}

	/**
	*	explicit permission overwrites for members and roles
	*/
	property JSON_Array PermissionOverwrites
	{
		public get() { return view_as<JSON_Array>(this.GetObject("permission_overwrites")); }

		public set(JSON_Array value) { this.SetObject("permission_overwrites", value); }
	}

	/**
	*	amount of seconds a user has to wait before sending another message (0-21600);
	*	bots, as well as users with the permission manage_messages or manage_channel, are unaffected
	*	also applies to thread creation. Users can send one message and create one thread during each RateLimitPerUser interval.
	*/
	property int RateLimitPerUser
	{
		public get() { return this.GetInt("rate_limit_per_user"); }

		public set(int value) { this.SetInt("rate_limit_per_user", value); }
	}

	/**
	*	the recipients of the DM
	*/
	property JSON_Array Recipients
	{
		public get() { return view_as<JSON_Array>(this.GetObject("recipients")); }
	}

	/**
	* 	thread-specific fields not needed by other channels
	*/
	property ThreadMetaData ThreadMetaData
	{
		public get() { return view_as<ThreadMetaData>(this.GetObject("thread_metadata")); }
	}

	/**
	*	thread member object for the current user, if they have joined the thread, only included on certain API endpoints
	*/
	property ThreadMember ThreadMember
	{
		public get() { return view_as<ThreadMember>(this.GetObject("member")); }
	}

	/**
	* 	default duration that the clients (not the API) will use for newly created threads, in minutes, to automatically archive the thread after recent activity, can be set to: 60, 1440, 4320, 10080
	*/
	property int DefaultAutoArchiveDuration
	{
		public get() { return this.GetInt("default_auto_archive_duration"); }
	}

	/**
	*	DiscordChannelFlags combined as a bitfield
	*/
	property int Flags
	{
		public get() { return this.GetInt("flags"); }

		public set(int value) { this.SetInt("flags", value); }
	}

	/**
	* 	icon hash of the group DM
	*/
	public bool GetIcon(char[] output, int maxsize)
	{
		return this.GetString("icon", output, maxsize);
	}

	/**
	* 	icon hash of the group DM
	*/
	public void SetIcon(const char[] input)
	{
		this.SetString("icon", input);
	}

	/**
	* 	the name of the channel (1-100 characters)
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	* 	the name of the channel (1-100 characters)
	*/
	public void SetName(const char[] input)
	{
		this.SetString("name", input);
	}

	/**
	* 	the channel topic (0-1024 characters)
	*/
	public bool GetTopic(char[] output, int maxsize)
	{
		return this.GetString("topic", output, maxsize);
	}

	/**
	* 	the channel topic (0-1024 characters)
	*/
	public void SetTopic(const char[] input)
	{
		this.SetString("topic", input);
	}

	/**
	*	voice region id for the voice channel, automatic when set to null
	*/
	public bool GetRtcRegion(char[] output, int maxsize)
	{
		return this.GetString("rtc_region", output, maxsize);
	}

	/**
	* 	the id of the guild (may be missing for some channel objects received over gateway guild dispatches)
	*/
	public bool GetGuildID(char[] output, int maxsize)
	{
		return this.GetString("guild_id", output, maxsize);
	}

	/**
	*	the id of the last message sent in this channel (or thread for GUILD_FORUM channels) (may not point to an existing or valid message or thread)
	*/
	public bool GetLastMessageID(char[] output, int maxsize)
	{
		return this.GetString("last_message_id", output, maxsize);
	}

	/**
	*	the id of the last message sent in this channel (or thread for GUILD_FORUM channels) (may not point to an existing or valid message or thread)
	*/
	public void SetLastMessageID(const char[] output)
	{
		this.SetString("last_message_id", output);
	}

	/**
	*	id of the creator of the group DM or thread
	*/
	public bool GetOwnerID(char[] output, int maxsize)
	{
		return this.GetString("owner_id", output, maxsize);
	}

	/**
	* 	application id of the group DM creator if it is bot-created
	*/
	public bool GetApplicationID(char[] output, int maxsize)
	{
		return this.GetString("application_id", output, maxsize);
	}

	/**
	* for guild channels: id of the parent category for a channel (each parent category can contain up to 50 channels)
	* for threads: id of the text channel this thread was created 
	*/
	public bool GetParentID(char[] output, int maxsize)
	{
		return this.GetString("parent_id", output, maxsize);
	}

	/**
	*	when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
	*/
	public bool GetLastPinTimestampDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("last_pin_timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
	*/
	public bool GetLastPinTimestamp(char[] output, int maxsize)
	{
		return this.GetString("last_pin_timestamp", output, maxsize);
	}

	/**
	*	computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on a slash command interaction
	*/
	public bool GetPermissions(char[] output, int maxsize)
	{
		return this.GetString("permissions", output, maxsize);
	}

	/**
	* 	computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on a slash command interaction
	*/
	public void SetPermissions(const char[] input)
	{
		this.SetString("permissions", input);
	}
}