#if defined _DiscordUser_included_
  #endinput
#endif
#define _DiscordUser_included_

enum DiscordUserFlags
{
	UserFlags_None = 0, /* None */
	STAFF = (1 << 0), /* Discord Employee */
	PARTNER = (1 << 1), /* Partner or Partnered Server Owner */
	HYPESQUAD = (1 << 2), /* HypeSquad Events */
	BUG_HUNTER_LEVEL_1 = (1 << 3), /* Bug Hunter Level 1 */
	HYPESQUAD_ONLINE_HOUSE_1 = (1 << 6), /* House Bravery */
	HYPESQUAD_ONLINE_HOUSE_2 = (1 << 7), /* House Brilliance */
	HYPESQUAD_ONLINE_HOUSE_3 = (1 << 8), /* House Balance */
	PREMIUM_EARLY_SUPPORTER = (1 << 9), /* Early Supporter */
	TEAM_PSEUDO_USER = (1 << 10), /* Team User */
	BUG_HUNTER_LEVEL_2 = (1 << 14), /* Bug Hunter Level 2 */
	VERIFIED_BOT = (1 << 16), /* Verified Bot */
	VERIFIED_DEVELOPER = (1 << 17), /* Early Verified Bot Developer */
	CERTIFIED_MODERATOR = (1 << 18), /* Discord Certified Moderator */
	BOT_HTTP_INTERACTIONS = (1 << 19) /* Bot uses only HTTP interactions and is shown in the online member list */
}

enum DiscordPremiumTypes
{
	PremiumType_None = 0,
	NitroClassic = 1,
	Nitro = 2
}

#define MAX_DISCORD_USERNAME_LENGTH 32
#define MAX_DISCORD_DISCRIMINATOR_LENGTH 5

/**
* Users in Discord are generally considered the base entity.
* Users can spawn across the entire platform, be members of guilds, participate in text and voice chat, and much more.
* Users are separated by a distinction of "bot" vs "normal." Although they are similar, bot users are automated users that are "owned" by another user.
* Unlike normal users, bot users do not have a limitation on the number of Guilds they can be a part of.
*/
methodmap DiscordUser < DiscordObject
{
	/**
	*	whether the user belongs to an OAuth2 application
	*/
	property bool IsBot
	{
		public get() { return this.GetBool("bot"); }
	}

	/**
	*	whether the user is an Official Discord System user (part of the urgent message system)
	*/
	property bool IsSystem
	{
		public get() { return this.GetBool("system"); }
	}

	/**
	*	whether the user has two factor enabled on their account
	*/
	property bool HasTwoFactor
	{
		public get() { return this.GetBool("mfa_enabled"); }
	}

	/**
	*	whether the email on this account has been verified
	*/
	property bool IsVerified
	{
		public get() { return this.GetBool("verified"); }
	}

	/**
	*	the user's banner color encoded as an integer representation of hexadecimal color code
	*/
	property int BannerColor
	{
		public get() { return this.GetInt("accent_color"); }
	}

	/**
	*	the flags on a user's account
	*	DiscordUserFlags
	*/
	property int Flags
	{
		public get() { return this.GetInt("flags"); }
	}

	/**
	*	the public flags on a user's account
	*	DiscordUserFlags
	*/
	property int PublicFlags
	{
		public get() { return this.GetInt("public_flags"); }
	}

	/**
	*	the type of Nitro subscription on a user's account
	*	( https://discord.com/developers/docs/resources/user#user-object-premium-types )
	*/
	property DiscordPremiumTypes PremiumType
	{
		public get() { return view_as<DiscordPremiumTypes>(this.GetInt("premium_type")); }
	}

	/**
	*	the user's username, not unique across the platform
	*/
	public bool GetUsername(char[] output, int maxsize)
    {
        return this.GetString("username", output, maxsize);
    }

	/**
	*	the user's 4-digit discord-tag
	*/
	public bool GetDiscriminator(char[] output, int maxsize)
    {
        return this.GetString("discriminator", output, maxsize);
    }

	/**
	*	the user's avatar hash
	*	( https://discord.com/developers/docs/reference#image-formatting )
	*/
	public bool GetAvatar(char[] output, int maxsize)
    {
        return this.GetString("avatar", output, maxsize);
    }

	/**
	*	the user's banner hash
	*	( https://discord.com/developers/docs/reference#image-formatting )
	*/
	public bool GetBanner(char[] output, int maxsize)
    {
        return this.GetString("banner", output, maxsize);
    }

	/**
	*	the user's chosen language option
	*	( https://discord.com/developers/docs/reference#locales )
	*/
	public bool GetLanguage(char[] output, int maxsize)
    {
        return this.GetString("locale", output, maxsize);
    }

	/**
	*	the user's email
	*/
	public bool GetEmail(char[] output, int maxsize)
    {
        return this.GetString("email", output, maxsize);
    }

	/**
	*	Get user mention string
	*/
	public bool GetMention(char[] output, int maxsize)
	{
		char szID[32];
		if(!this.GetID(szID, sizeof(szID)))
			return false;

		Format(szID, sizeof(szID), "<@%s>", szID);
		return true;
	}
}