#if defined _DiscordReaction_included_
  #endinput
#endif
#define _DiscordReaction_included_

methodmap DiscordReaction < JSON_Object
{
	property int Count
	{
		public get() { return this.GetInt("count"); }
	}

	property bool Me
	{
		public get() { return this.GetBool("me"); }
	}

	property DiscordEmoji Emoji
	{
		public get() { return view_as<DiscordEmoji>(this.GetObject("emoji")); }
	}
}