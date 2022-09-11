#if defined _DiscordActivity_included_
  #endinput
#endif
#define _DiscordActivity_included_

enum DiscordActivityType
{
	Game = 0,
	Streaming,
	Listening,
	Watching,
	Custom,
	Competing
}

methodmap DiscordActivity < JSON_Object
{
    public DiscordActivity(const char[] name, DiscordActivityType type, const char[] url = "")
    {
		JSON_Object obj = new JSON_Object();
		obj.SetString("name", name);
		obj.SetString("url", url);
		obj.SetInt("type", view_as<int>(type));
		return view_as<DiscordActivity>(obj);
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