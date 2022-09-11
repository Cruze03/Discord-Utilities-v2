#if defined _DiscordMessage_included_
  #endinput
#endif
#define _DiscordMessage_included_

#include <discord/DiscordMessageReference>
//#include <discord/DiscordMessageComponent>

enum DiscordMessageActivityTypes
{
	JOIN = 1,
	SPECTATE = 2,
	LISTEN = 3,
	JOIN_REQUEST = 4
}

enum DiscordMessageFlags
{
	CROSSPOSTED = (1 << 0), /* this message has been published to subscribed channels (via Channel Following) */
	IS_CROSSPOST = (1 << 1), /* this message originated from a message in another channel (via Channel Following) */
	SUPPRESS_EMBEDS = (1 << 2), /* do not include any embeds when serializing this message */
	SOURCE_MESSAGE_DELETED = (1 << 3), /* the source message for this crosspost has been deleted (via Channel Following) */
	URGENT = (1 << 4), /* this message came from the urgent message system */
	HAS_THREAD = (1 << 5), /* this message has an associated thread, with the same id as the message */
	EPHEMERAL = (1 << 6), /* this message is only visible to the user who invoked the Interaction */
	LOADING = (1 << 7), /* this message is an Interaction Response and the bot is "thinking" */
	FAILED_TO_MENTION_SOME_ROLES_IN_THREAD = (1 << 8) /* this message failed to mention some roles and add their members to the thread */
}

enum DiscordMessageStickerFormat
{
	PNG = 1,
	APNG = 2,
	LOTTIE = 3
}

enum DiscordMessageStickerType
{
	STANDARD = 1, /* an official sticker in a pack, part of Nitro or in a removed purchasable pack */
	GUILD /* a sticker uploaded to a Boosted guild for the guild's members */
}

/**
* Type 19 and 20 are only in API v8. In v6, they are still type 0. Type 21 is only in API v9.
*/
enum DiscordMessageType
{
	Type_DEFAULT = 0,
	RECIPIENT_ADD = 1,
	RECIPIENT_REMOVE = 2,
	CALL = 3,
	CHANNEL_NAME_CHANGE = 4,
	CHANNEL_ICON_CHANGE = 5,
	CHANNEL_PINNED_MESSAGE = 6,
	GUILD_MEMBER_JOIN = 7,
	USER_PREMIUM_GUILD_SUBSCRIPTION = 8,
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_1 = 9,
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_2 = 10,
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_3 = 11,
	CHANNEL_FOLLOW_ADD = 12,
	GUILD_DISCOVERY_DISQUALIFIED = 14,
	GUILD_DISCOVERY_REQUALIFIED = 15,
	GUILD_DISCOVERY_GRACE_PERIOD_INITIAL_WARNING = 16,
	GUILD_DISCOVERY_GRACE_PERIOD_FINAL_WARNING = 17,
	THREAD_CREATED = 18,
	REPLY = 19,
	APPLICATION_COMMAND = 20,
	THREAD_STARTER_MESSAGE = 21,
	GUILD_INVITE_REMINDER = 22,
	CONTEXT_MENU_COMMAND = 23
}

/** DiscordBot.GetChannelMessages | DiscordBot.GetChannelMessagesID
*
* Called as callback after a successful request.
*
*/
typeset OnGetDiscordChannelMessages
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param messages	DiscordMessageList object received.
	*					DiscordMessageList handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessageList messages);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param messages	DiscordMessageList object received.
	*					DiscordMessageList handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessageList messages, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param messages	DiscordMessageList object received.
	*					DiscordMessageList handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessageList messages, any data, any data2);
}

/** DiscordBot.GetPinnedMessages | DiscordBot.GetPinnedMessagesID
*
* Called as callback after a successful request.
*
*/
typeset OnGetDiscordChannelPinnedMessages
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param messages	DiscordMessageList object received.
	*					DiscordMessageList handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessageList messages);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param messages	DiscordMessageList object received.
	*					DiscordMessageList handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessageList messages, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param messages	DiscordMessageList object received.
	*					DiscordMessageList handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessageList messages, any data, any data2);
}

/** DiscordBot.GetChannelMessage | DiscordBot.GetChannelMessageID
*
* Called as callback after a successful request.
*
*/
typeset OnGetDiscordChannelMessage
{
	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param message	DiscordMessage object received.
	*					DiscordMessage handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessage message);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param message	DiscordMessage object received.
	*					DiscordMessage handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessage message, any data);

	/**
	*
	* @param bot		same handle as the bot you have used to call the native.
	* @param message	DiscordMessage object received.
	*					DiscordMessage handle will not be deleted automatically when the callback function returns, it is your responsibility to manage memory.
	* @param data		custom data passed through the request to use in the callback
	* @param data2		custom data passed through the request to use in the callback
	*
	* @noreturn
	*/
	function void (DiscordBot bot, DiscordMessage message, any data, any data2);
}

/**
* Represents a sticker that can be sent in messages.
*/
methodmap DiscordMessageSticker < DiscordObject
{
	/**
	* 	type of sticker format ( DiscordMessageStickerFormat )
	*/
	property DiscordMessageStickerFormat Format
	{
		public get() { return view_as<DiscordMessageStickerFormat>(this.GetInt("format_type")); }
	}

	/**
	* 	type of sticker format ( DiscordMessageStickerType )
	*/
	property DiscordMessageStickerType Type
	{
		public get() { return view_as<DiscordMessageStickerType>(this.GetInt("type")); }
	}

	/**
	* 	whether this guild sticker can be used, may be false due to loss of Server Boosts
	*/
	property bool Available
	{
		public get() { return this.GetBool("available"); }
	}

	/**
	* 	the standard sticker's sort order within its pack
	*/
	property int SortValue
	{
		public get() { return this.GetInt("sort_value"); }
	}

	/* the user that uploaded the sticker */
	public DiscordUser GetUser()
	{
		return view_as<DiscordUser>(this.GetObject("user"));
	}

	/**
	* 	for standard stickers, id of the pack the sticker is from
	*/
	public bool GetPackID(char[] output, int maxsize)
	{
		return this.GetString("pack_id", output, maxsize);
	}

	/**
	* 	id of the guild that owns this sticker
	*/
	public bool GetGuildID(char[] output, int maxsize)
	{
		return this.GetString("guild_id", output, maxsize);
	}

	/**
	* 	name of the sticker
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	* 	description of the sticker
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}

	/**
	* 	autocomplete/suggestion tags for the sticker (max 200 characters)
	*/
	public bool GetTags(char[] output, int maxsize)
	{
		return this.GetString("tags", output, maxsize);
	}

	/**
	* 	Deprecated
	*	previously the sticker asset hash, now an empty string
	*/
	public bool GetAsset(char[] output, int maxsize)
	{
		return this.GetString("asset", output, maxsize);
	}
}

methodmap DiscordMessageActivity < JSON_Object
{
	/**
	*	type of message activity
	*/
	property DiscordMessageActivityTypes Type
	{
		public get() { return view_as<DiscordMessageActivityTypes>(this.GetInt("type")); }
	}

	/**
	* 	party_id from a Rich Presence event
	*	( https://discord.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields )
	*/
	public bool GetPartyID(char[] output, int maxsize)
	{
		return this.GetString("party_id", output, maxsize);
	}

}

/**
* Represents a message sent in a channel within Discord.
*/
methodmap DiscordMessage < DiscordObject
{
	/**
	* 	whether this message mentions everyone
	*/
	property bool MentionsEveryone
	{
		public get() { return this.GetBool("mention_everyone"); }
	}

	/**
	*	message flags combined as a bitfield
	*/
	property int Flags
	{
		public get() { return this.GetInt("flags"); }
	}

	/**
	* 	whether this was a TTS message
	*/
	property bool TTS
	{
		public get() { return this.GetBool("tts"); }
	}

	/**
	* 	whether this message is pinned
	*/
	property bool Pinned
	{
		public get() { return this.GetBool("pinned"); }
	}

	/**
	*	the thread that was started from this message, includes thread member object
	*/
	property DiscordChannel Thread
	{
		public get() { return view_as<DiscordChannel>(this.GetObject("thread")); }
	}

	/**
	*	sent if the message contains components like buttons, action rows, or other interactive components
	*	https://discord.com/developers/docs/interactions/message-components#component-object
	*/
	property JSON_Object Components
	{
		public get() { return this.GetObject("components"); }
	}

	/**
	*	type of message
	*/
	property DiscordMessageType Type
	{
		public get() { return view_as<DiscordMessageType>(this.GetInt("type")); }
	}

	/**
	*	sent with Rich Presence-related chat embeds
	*/
	property DiscordMessageActivity Activity
	{
		public get() { return view_as<DiscordMessageActivity>(this.GetObject("activity")); }
	}

	/**
	* 	the author of this message (not guaranteed to be a valid user, see below)
	*	The author object follows the structure of the user object, but is only a valid user in the case where the message is generated by a user or bot user.
	*	If the message is generated by a webhook, the author object corresponds to the webhook's id, username, and avatar.
	*	You can tell if a message is generated by a webhook by checking for the webhook_id on the message object.
	*/
	property DiscordUser Author
	{
		public get() { return view_as<DiscordUser>(this.GetObject("author")); }
	}

	/**
	* 	member properties for this message's author
	*	! partial ! guild member object
	*/
	property DiscordGuildUser Member
	{
		public get() { return view_as<DiscordGuildUser>(this.GetObject("member")); }
	}

	public DiscordMessage(const char[] content = "", DiscordEmbed embed = null)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("content", content);
		
		if(embed != null)
		{
			JSON_Array embeds = new JSON_Array();
			embeds.PushObject(embed);
			obj.SetObject("embeds", embeds);
		}
			
		return view_as<DiscordMessage>(obj);
	}

	/**
	* 	if the message is generated by a webhook, this is the webhook's id
	*/
	public bool GetWebhookID(char[] output, int maxsize)
	{
		return this.GetString("webhook_id", output, maxsize);
	}

	/**
	* 	id of the channel the message was sent in
	*/
	public bool GetChannelID(char[] output, int maxsize)
	{
		return this.GetString("channel_id", output, maxsize);
	}

	/**
	*	id of the guild the message was sent in
	*/
	public bool GetGuildID(char[] output, int maxsize)
	{
		return this.GetString("guild_id", output, maxsize);
	}

	/**
	*	if the message is an Interaction or application-owned webhook, this is the id of the application
	*	( https://discord.com/developers/docs/interactions/receiving-and-responding )
	*/
	public bool GetApplicationID(char[] output, int maxsize)
	{
		return this.GetString("application_id", output, maxsize);
	}

	/**
	* 	the author of this message (not guaranteed to be a valid user, see below)
	*	The author object follows the structure of the user object, but is only a valid user in the case where the message is generated by a user or bot user.
	*	If the message is generated by a webhook, the author object corresponds to the webhook's id, username, and avatar.
	*	You can tell if a message is generated by a webhook by checking for the webhook_id on the message object.
	*/
	public DiscordUser GetAuthor()
	{
		return this.Author;
	}

	/**
	* 	member properties for this message's author
	*	! partial ! guild member object
	*/
	public DiscordGuildUser GetMember()
	{
		return this.Member;
	}

	/**
	*	contents of the message
	*/
	public bool GetContent(char[] output, int maxsize)
	{
		return this.GetString("content", output, maxsize);
	}

	/**
	* 	when this message was sent
	*/
	public bool GetTimestamp(char[] buffer, int maxsize)
	{
		return this.GetString("timestamp", buffer, maxsize);
	}

	/**
	* 	when this message was sent
	*/
	public bool GetTimestampDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	* 	when this message was edited (or null if never)
	*/
	public bool GetEditedTimestamp(char[] buffer, int maxsize)
	{
		return this.GetString("edited_timestamp", buffer, maxsize);
	}

	/**
	* 	when this message was edited (or null if never)
	*/
	public bool GetEditedTimestampDateTime(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("edited_timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	*	users specifically mentioned in the message
	*	The user objects in the mentions array will only have the partial member field present in MESSAGE_CREATE and MESSAGE_UPDATE events from text-based guild channels.
	*/
	public JSON_Array GetMentionedUsers()
	{
		return view_as<JSON_Array>(this.GetObject("mentions"));
	}

	/**
	*	any attached files
	*	array of attachment objects
	*/
	public JSON_Array GetAttachments()
	{
		return view_as<JSON_Array>(this.GetObject("attachments"));
	}

	/**
	* 	roles specifically mentioned in this message
	*/
	public JSON_Array GetMentionedRoles()
	{
		return view_as<JSON_Array>(this.GetObject("mention_roles"));
	}

	/**
	* 	channels specifically mentioned in this message
	*/
	public JSON_Array GetMentionedChannels()
	{
		return view_as<JSON_Array>(this.GetObject("mention_channels"));
	}

	/**
	* 	any embedded content
	*	array of embed objects
	*/
	public JSON_Array GetEmbeds()
	{
		return view_as<JSON_Array>(this.GetObject("embeds"));
	}

	/**
	* 	reactions to the message
	*	array of reaction objects
	*/
	public JSON_Array GetReactions()
	{
		return view_as<JSON_Array>(this.GetObject("reactions"));
	}

	/**
	*	Array of DiscordMessageSticker but only with id, name and format_type fields
	*	( https://discord.com/developers/docs/resources/sticker#sticker-item-object )
	*/
	public JSON_Array GetStickerItems()
	{
		return view_as<JSON_Array>(this.GetObject("sticker_items"));
	}

	/**
	*	Deprecated
	*	the stickers sent with the message
	*	array of sticker objects
	*/
	public JSON_Array GetStickers()
	{
		return view_as<JSON_Array>(this.GetObject("stickers"));
	}

	/**
	*	data showing the source of a crosspost, channel follow add, pin, or reply message
	*/
	public DiscordMessageReference GetReference()
	{
		return view_as<DiscordMessageReference>(this.GetObject("message_reference"));
	}

	/**
	* 	the message associated with the message_reference
	*/
	public DiscordMessage GetReferencedMessage()
	{
		return view_as<DiscordMessage>(this.GetObject("referenced_message"));
	}

	/**
	* 	Add embed object to the embeds array.
	*/
	public void Embed(DiscordEmbed embed)
	{
		if(!this.HasKey("embeds"))
			this.SetObject("embeds", new JSON_Array());

		JSON_Array embeds = this.GetEmbeds();
		embeds.PushObject(embed);
		this.SetObject("embeds", embeds);
	}
}