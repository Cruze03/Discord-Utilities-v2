#if defined _DiscordGuild_included_
  #endinput
#endif
#define _DiscordGuild_included_

enum DiscordGuildVerificationLevel
{
	UNRESTRICTED = 0, /* unrestricted */
	LOW = 1, /* must have verified email on account */
	MEDIUM = 2, /* must be registered on Discord for longer than 5 minutes */
	HIGH = 3, /* must be a member of the server for longer than 10 minutes */
	VERY_HIGH = 4 /* must have a verified phone number */
}

enum DiscordGuildMessageNotificationLevel
{
	ALL_MESSAGES = 0, /* members will receive notifications for all messages by default */
	ONLY_MENTIONS = 1 /* members will receive notifications only for messages that @mention them by default */
}

enum DiscordGuildExplicitContentFilterLevel
{
	DISABLED = 0, /* media content will not be scanned */
	MEMBERS_WITHOUT_ROLES, /* media content sent by members without roles will be scanned */
	ALL_MEMBERS /* media content sent by all members will be scanned */
}

enum DiscordGuildMFALevel
{
	MFALevel_NONE = 0, /* guild has no MFA/2FA requirement for moderation actions */
	ELEVATED /* guild has a 2FA requirement for moderation actions */
}

enum DiscordGuildNSFWLevel
{
	DEFAULT = 0,
	EXPLICIT,
	SAFE,
	AGE_RESTRICTED
}

enum DiscordGuildPremiumTier
{
	TIER_NONE = 0, /* guild has not unlocked any Server Boost perks */
	TIER_1 = 1, /* guild has unlocked Server Boost level 1 perks */
	TIER_2 = 2, /* guild has unlocked Server Boost level 2 perks */
	TIER_3 = 3 /* guild has unlocked Server Boost level 3 perks */
}

enum DiscordGuildSystemChannelFlags
{
	SUPPRESS_JOIN_NOTIFICATIONS = (1 << 0), /* Suppress member join notifications */
	SUPPRESS_PREMIUM_SUBSCRIPTIONS = (1 << 1), /* Suppress server boost notifications */
	SUPPRESS_GUILD_REMINDER_NOTIFICATIONS = (1 << 2), /* Suppress server setup tips */
	SUPPRESS_JOIN_NOTIFICATION_REPLIES = (1 << 3) /* Hide member join sticker reply buttons */
}

enum DiscordGuildIntegrationExpireBehaviour
{
	REMOVE_ROLE = 0,
	KICK = 1
}

enum DiscordGuildScheduledEventPrivacyLevel
{
	GUILD_ONLY = 2 /* the scheduled event is only accessible to guild members */
}

enum DiscordGuildScheduledEventEntityType
{
	STAGE_INSTANCE = 1,
	VOICE = 2,
	EXTERNAL = 3
}

/*
* Once status is set to COMPLETED or CANCELED, the status can no longer be updated
* Valid Guild Scheduled Event Status Transitions
* SCHEDULED --> ACTIVE
* ACTIVE --------> COMPLETED
* SCHEDULED --> CANCELED
*/
enum DiscordGuildScheduledEventStatus
{
	SCHEDULED = 1,
	ACTIVE = 2,
	COMPLETED = 3,
	CANCELED = 4
}

/** DiscordBot.CreateGuild
*
* Called as callback after a successful request.
*
*/
typeset OnDiscordGuildCreated
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuild object received.
	*					DiscordGuild handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuild guild);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuild object received.
	*					DiscordGuild handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuild guild, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuild object received.
	*					DiscordGuild handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuild guild, any data, any data2);
}

/** DiscordBot.GetGuild
*
* Called as callback after a successful request.
*
*/
typeset OnGetDiscordGuild
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuild object received.
	*					DiscordGuild handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuild guild);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuild object received.
	*					DiscordGuild handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuild guild, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuild object received.
	*					DiscordGuild handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuild guild, any data, any data2);
}

/** DiscordBot.GetGuildMember | DiscordBot.GetGuildMemberID
*
*	Called as callback after a successful request.
*
*/
typeset OnGetDiscordGuildUser
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guildUser	DiscordGuildUser object received.
	*					DiscordGuildUser handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuildUser guildUser);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guildUser	DiscordGuildUser object received.
	*					DiscordGuildUser handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuildUser guildUser, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guildUser	DiscordGuildUser object received.
	*					DiscordGuildUser handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuildUser guildUser, any data, any data2);
}

/** DiscordBot.GetGuildMember | DiscordBot.GetGuildMemberID
*
*	Called as callback after a failed "not found" request.
*
*/
typeset OnFailedGetDiscordGuildUser
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param sUserID	sUserID which was not found in the guild.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, const char[] sUserID);
	
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param sUserID	sUserID which was not found in the guild.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, const char[] sUserID, any data);
	
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param sUserID	sUserID which was not found in the guild.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, const char[] sUserID, any data, any data2);
}

/** DiscordBot.GetGuildScheduledEvent
*
* Called as callback after a successful request.
*
*/
typeset OnGetDiscordGuildScheduledEvent
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuildScheduledEvent object received.
	*					DiscordGuildScheduledEvent handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuildScheduledEvent event);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuildScheduledEvent object received.
	*					DiscordGuildScheduledEvent handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuildScheduledEvent event, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param guild		DiscordGuildScheduledEvent object received.
	*					DiscordGuildScheduledEvent handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordGuildScheduledEvent event, any data, any data2);
}

methodmap ScheduledEventMetaData < JSON_Object
{
	/**
	*	location of the event (1-100 characters)
	*/
	public bool GetLocation(char[] output, int maxsize)
	{
		return this.GetString("location", output, maxsize);
	}

}

methodmap DiscordGuildScheduledEventUser < JSON_Object
{
	/**
	*	user which subscribed to an event
	*/
	property DiscordUser User
	{
		public get() { return view_as<DiscordUser>(this.GetObject("user")); }
	}

	/**
	*	guild member data for this user for the guild which this event belongs to, if any
	*/
	property DiscordGuildUser Member
	{
		public get() { return view_as<DiscordGuildUser>(this.GetObject("member")); }
	}

	/**
	*	the scheduled event id which the user subscribed to
	*/
	public bool GetEventID(char[] output, int maxsize)
	{
		return this.GetString("guild_scheduled_event_id", output, maxsize);
	}
}

/**
* A representation of a scheduled event in a guild.
*/
methodmap DiscordGuildScheduledEvent < DiscordObject
{
	/**
	*	the user that created the scheduled event
	*/
	property DiscordUser Creator
	{
		public get() { return view_as<DiscordUser>(this.GetObject("creator")); }
	}

	/**
	*	the number of users subscribed to the scheduled event
	*/
	property int UserCount
	{
		public get() { return this.GetInt("user_count"); }
	}

	/**
	*	the status of the scheduled event
	*/
	property DiscordGuildScheduledEventStatus Status
	{
		public get() { return view_as<DiscordGuildScheduledEventStatus>(this.GetInt("status")); }
	}

	/**
	*	the privacy level of the scheduled event
	*/
	property DiscordGuildScheduledEventPrivacyLevel PrivacyLevel
	{
		public get() { return view_as<DiscordGuildScheduledEventPrivacyLevel>(this.GetInt("privacy_level")); }
	}

	/**
	*	the type of the scheduled event
	*/
	property DiscordGuildScheduledEventEntityType Type
	{
		public get() { return view_as<DiscordGuildScheduledEventEntityType>(this.GetInt("entity_type")); }
	}

	/**
	*	additional metadata for the guild scheduled event
	*/
	property ScheduledEventMetaData MetaData
	{
		public get() { return view_as<ScheduledEventMetaData>(this.GetObject("entity_metadata")); }
	}

	/**
	*	the guild id which the scheduled event belongs to
	*/
	public bool GetGuildID(char[] output, int maxsize)
	{
		return this.GetString("guild_id", output, maxsize);
	}

	/**
	*	the id of an entity associated with a guild scheduled event
	*/
	public bool GetEntityID(char[] output, int maxsize)
	{
		return this.GetString("entity_id", output, maxsize);
	}

	/**
	*	the channel id in which the scheduled event will be hosted, or null if scheduled entity type is EXTERNAL
	*/
	public bool GetChannelID(char[] output, int maxsize)
	{
		return this.GetString("channel_id", output, maxsize);
	}

	/**
	*	the id of the user that created the scheduled event
	*/
	public bool GetCreatorID(char[] output, int maxsize)
	{
		return this.GetString("creator_id", output, maxsize);
	}

	/**
	*	the name of the scheduled event (1-100 characters)
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	*	the description of the scheduled event (1-1000 characters)
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}

	/**
		the cover image hash of the scheduled event
		( https://discord.com/developers/docs/reference#image-formatting )
	*/
	public bool GetImage(char[] output, int maxsize)
	{
		return this.GetString("image", output, maxsize);
	}

	/**
	* 	the time the scheduled event will start
	*/
	public bool GetScheduledStart(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("scheduled_start_time", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	* 	the time the scheduled event will end, required if entity_type is EXTERNAL
	*/
	public bool GetScheduledEnd(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("scheduled_end_time", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}
}

methodmap DiscordIntegrationAccount < JSON_Object
{
	/**
	*	id of the account
	*/
	public bool GetID(char[] output, int maxsize)
	{
		return this.GetString("id", output, maxsize);
	}

	/**
	*	name of the account
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}
}

methodmap DiscordIntegrationApplication < DiscordObject
{
	/**
	* 	the bot associated with this application
	*/
	property DiscordUser Bot
	{
		public get() { return view_as<DiscordUser>(this.GetObject("bot")); }
	}

	/**
	* 	the name of the app
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	*	the icon hash of the app
	* 	( https://discord.com/developers/docs/reference#image-formatting )
	*/
	public bool GetIcon(char[] output, int maxsize)
	{
		return this.GetString("icon", output, maxsize);
	}

	/**
	* 	the description of the app
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}
}

methodmap DiscordBanObject < JSON_Object
{
	/**
	*	the banned user
	*/
	property DiscordUser User
	{
		public get() { return view_as<DiscordUser>(this.GetObject("user")); }
	}

	/**
	*	the reason for the ban
	*/
	public bool GetReason(char[] output, int maxsize)
	{
		return this.GetString("channel_id", output, maxsize);
	}
}

methodmap DiscordWelcomeScreenChannel < JSON_Object
{
	/**
	*	the channel's id
	*/
	public bool GetChannelID(char[] output, int maxsize)
	{
		return this.GetString("channel_id", output, maxsize);
	}

	/**
	*	the description shown for the channel
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}

	/**
	*	the emoji name if custom, the unicode character if standard, or null if no emoji is set
	*/
	public bool GetEmojiName(char[] output, int maxsize)
	{
		return this.GetString("emoji_name", output, maxsize);
	}

	/**
	*	the emoji id, if the emoji is custom
	*/
	public bool GetEmojiID(char[] output, int maxsize)
	{
		return this.GetString("emoji_id", output, maxsize);
	}
}

methodmap DiscordWelcomeScreen < JSON_Object
{
	/**
	*	the channels shown in the welcome screen, up to 5
	*/
	property JSON_Array WelcomeChannels
	{
		public get() { return view_as<JSON_Array>(this.GetObject("welcome_channels")); }
	}

	/**
	* 	the server description shown in the welcome screen
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}
}

/**
* Guilds in Discord represent an isolated collection of users and channels, and are often referred to as "servers" in the UI.
*/
methodmap DiscordGuild < DiscordObject
{
	/**
	* 	true if the user is the owner of the guild
	*/
	property bool IsOwner
	{
		public get() { return this.GetBool("owner"); }
	}

	/**
	* 	true if the server widget is enabled
	*/
	property bool Widget
	{
		public get() { return this.GetBool("widget_enabled"); }
	}

	#pragma deprecated This property has been removed by Discord.
	/**
	* 	whether the guild is large
	*/
	property bool IsLarge
	{
		public get() { return this.GetBool("large"); }
	}

	/**
	* 	whether the guild is unavailable
	*/
	property bool IsUnavailable
	{
		public get() { return this.GetBool("unavailable"); }
	}

	/**
	* 	afk timeout in seconds
	*/
	property int AfkTimeout
	{
		public get() { return this.GetInt("afk_timeout"); }
	}

	#pragma deprecated This property has been removed by Discord.
	/**
	*	the number of members this guild currently has
	*/
	property int MemberCount
	{
		public get() { return this.GetInt("member_count"); }
	}

	/**
	*	the maximum amount of users in a video channel
	*/
	property int MaxVideoChannelUsers
	{
		public get() { return this.GetInt("max_video_channel_users"); }
	}

	/**
	* 	approximate number of members in this guild, returned from the GET /guilds/<id> endpoint when with_counts is true
	*/
	property int ApproximateMemberCount
	{
		public get() { return this.GetInt("approximate_member_count"); }
	}

	/**
	* 	approximate number of non-offline members in this guild, returned from the GET /guilds/<id> endpoint when with_counts is true
	*/
	property int ApproximatePresenceCount
	{
		public get() { return this.GetInt("approximate_presence_count"); }
	}

	/**
	*	the number of boosts this guild currently has
	*/
	property int BoostCount
	{
		public get() { return this.GetInt("premium_subscription_count"); }
	}

	/**
	*	whether the guild has the boost progress bar enabled
	*/
	property bool PremiumProgressBarEnabled
	{
		public get() { return this.GetBool("premium_progress_bar_enabled"); }
	}

	/**
	*	premium tier (Server Boost level)
	*/
	property DiscordGuildPremiumTier PremiumTier
	{
		public get() { return view_as<DiscordGuildPremiumTier>(this.GetInt("premium_tier")); }
	}

	/**
	*	the welcome screen of a Community guild, shown to new members, returned in an Invite's guild object
	*/
	property DiscordWelcomeScreen WelcomeScreen
	{
		public get() { return view_as<DiscordWelcomeScreen>(this.GetObject("welcome_screen")); }
	}

	/**
	*	roles in the guild
	*/
	property JSON_Array Stickers
	{
		public get() { return view_as<JSON_Array>(this.GetObject("stickers")); }
	}

	/**
	*	roles in the guild
	*/
	property JSON_Array Roles
	{
		public get() { return view_as<JSON_Array>(this.GetObject("roles")); }
	}

	/**
	*	custom guild emojis
	*/
	property JSON_Array Emojis
	{
		public get() { return view_as<JSON_Array>(this.GetObject("emojis")); }
	}

	#pragma deprecated This property has been removed by Discord.
	/**
	*	members in the guild
	*/
	property JSON_Array Members
	{
		public get() { return view_as<JSON_Array>(this.GetObject("members")); }
	}

	#pragma deprecated This property has been removed by Discord.
	/**
	*	channels in the guild
	*/
	property JSON_Array Channels
	{
		public get() { return view_as<JSON_Array>(this.GetObject("channels")); }
	}

	/**
	*	enabled guild features
	*/
	property JSON_Array Features
	{
		public get() { return view_as<JSON_Array>(this.GetObject("features")); }
	}

	/**
	*	verification level required for the guild
	*/
	property DiscordGuildVerificationLevel VerificationLevel
	{
		public get() { return view_as<DiscordGuildVerificationLevel>(this.GetInt("verification_level")); }
	}

	/**
	*	default message notifications level
	*/
	property DiscordGuildMessageNotificationLevel NotificationLevel
	{
		public get() { return view_as<DiscordGuildMessageNotificationLevel>(this.GetInt("default_message_notifications")); }
	}

	/**
	*	explicit content filter level
	*/
	property DiscordGuildExplicitContentFilterLevel ExplicitContentFilter
	{
		public get() { return view_as<DiscordGuildExplicitContentFilterLevel>(this.GetInt("explicit_content_filter")); }
	}

	/**
	*	required MFA level for the guild
	*/
	property DiscordGuildMFALevel MFALevel
	{
		public get() { return view_as<DiscordGuildMFALevel>(this.GetInt("mfa_level")); }
	}

	/**
	*	guild NSFW level
	*/
	property DiscordGuildNSFWLevel NSFWLevel
	{
		public get() { return view_as<DiscordGuildNSFWLevel>(this.GetInt("nsfw_level")); }
	}

	/**
	*	DiscordGuildSystemChannelFlags
	*/
	property int DiscordGuildSystemChannelFlags
	{
		public get() { return this.GetInt("system_channel_flags"); }
	}

	/**
	*	the maximum number of presences for the guild (null is always returned, apart from the largest of guilds)
	*/
	property int MaxPresences
	{
		public get() { return this.GetInt("max_presences"); }
	}

	/**
	*	the maximum number of members for the guild
	*/
	property int MaxMembers
	{
		public get() { return this.GetInt("max_members"); }
	}

	/**
	*	roles in the guild
	*/
	public JSON_Array GetRoles()
	{
		return this.Roles;
	}

	/**
	*	custom guild emojis
	*/
	public JSON_Array GetEmojis()
	{
		return this.Emojis;
	}

	#pragma deprecated This property has been removed by Discord.
	/**
	*	members in the guild
	*/
	public JSON_Array GetMembers()
	{
		return this.Members;
	}

	#pragma deprecated This property has been removed by Discord.
	/**
	*	roles in the guild
	*/
	public JSON_Array GetChannels()
	{
		return this.Channels;
	}

	/**
	*	enabled guild features
	*/
	public JSON_Array GetFeatures()
	{
		return this.Features;
	}

	/**
	*	guild name (2-100 characters, excluding trailing and leading whitespace)
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	* 	the description of a guild
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}

	/**
	*	banner hash
	*	( https://discord.com/developers/docs/reference#image-formatting ) 
	*/
	public bool GetBanner(char[] output, int maxsize)
	{
		return this.GetString("banner", output, maxsize);
	}

	/**
	*	discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
	*	( https://discord.com/developers/docs/reference#image-formatting ) 
	*/
	public bool GetDiscoverySplash(char[] output, int maxsize)
	{
		return this.GetString("discovery_splash", output, maxsize);
	}

	/**
	*	icon hash
	*	( https://discord.com/developers/docs/reference#image-formatting ) 
	*/
	public bool GetIcon(char[] output, int maxsize)
	{
		return this.GetString("icon", output, maxsize);
	}

	/**
	*	icon hash, returned when in the template object
	*	( https://discord.com/developers/docs/reference#image-formatting ) 
	*/
	public bool GetIconHash(char[] output, int maxsize)
	{
		return this.GetString("icon_hash", output, maxsize);
	}

	/**
	*	splash hash
	*	( https://discord.com/developers/docs/reference#image-formatting ) 
	*/
	public bool GetSplash(char[] output, int maxsize)
	{
		return this.GetString("splash", output, maxsize);
	}

	#pragma deprecated This property has been marked as deprecated by Discord.
	/**
	* 	voice region id for the guild (deprecated)
	*/
	public bool GetRegion(char[] output, int maxsize)
	{
		return this.GetString("region", output, maxsize);
	}

	/**
	*	the preferred locale of a Community guild
	*	used in server discovery and notices from Discord, and sent in interactions
	*	defaults to "en-US" ( https://discord.com/developers/docs/reference#locales )
	*/
	public bool GetPreferredLanguage(char[] output, int maxsize)
	{
		return this.GetString("preferred_locale", output, maxsize);
	}

	/**
	*	id of afk channel
	*/
	public bool GetAfkChannelID(char[] output, int maxsize)
	{
		return this.GetString("afk_channel_id", output, maxsize);
	}

	/**
	*	id of owner
	*/
	public bool GetOwnerID(char[] output, int maxsize)
	{
		return this.GetString("owner_id", output, maxsize);
	}

	/**
	*	total permissions for the user in the guild (excludes overwrites)
	*/
	public bool GetPermissions(char[] output, int maxsize)
	{
		return this.GetString("permissions", output, maxsize);
	}

	/**
	*	the channel id that the widget will generate an invite to, or null if set to no invite
	*/
	public bool GetWidgetChannelID(char[] output, int maxsize)
	{
		return this.GetString("widget_channel_id", output, maxsize);
	}

	/**
	* 	application id of the guild creator if it is bot-created
	*/
	public bool GetApplicationID(char[] output, int maxsize)
	{
		return this.GetString("application_id", output, maxsize);
	}

	/**
	* 	the id of the channel where guild notices such as welcome messages and boost events are posted
	*/
	public bool GetSystemChannelID(char[] output, int maxsize)
	{
		return this.GetString("system_channel_id", output, maxsize);
	}

	/**
	*	the id of the channel where Community guilds can display rules and/or guidelines
	*/
	public bool GetRulesChannelID(char[] output, int maxsize)
	{
		return this.GetString("rules_channel_id", output, maxsize);
	}

	/**
	*	the vanity url code for the guild
	*/
	public bool GetVanityURL(char[] output, int maxsize)
	{
		return this.GetString("vanity_url_code", output, maxsize);
	}

	/**
	*	the id of the channel where admins and moderators of Community guilds receive notices from Discord
	*/
	public bool GetPublicUpdatesChannelID(char[] output, int maxsize)
	{
		return this.GetString("public_updates_channel_id", output, maxsize);
	}
}