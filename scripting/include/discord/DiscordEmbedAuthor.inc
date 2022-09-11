#if defined _DiscordEmbedAuthor_included_
  #endinput
#endif
#define _DiscordEmbedAuthor_included_

#define MAX_AUTHOR_NAME_LENGTH 256 // https://discord.com/developers/docs/resources/channel#embed-limits-limits

/**
* author information
*/
methodmap DiscordEmbedAuthor < JSON_Object
{
	public DiscordEmbedAuthor(const char[] name = "", const char[] url = "", const char[] iconUrl = "")
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("name", name);
		obj.SetString("url", url);
		obj.SetString("icon_url", iconUrl);
		return view_as<DiscordEmbedAuthor>(obj);
	}

	/**
	* 	name of author
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	* 	name of author
	*/
	public void SetName(const char[] name)
	{
		this.SetString("name", name);
	}

	/**
	*	url of author
	*/
	public bool GetUrl(char[] output, int maxsize)
	{
		return this.GetString("url", output, maxsize);
	}

	/**
	*	url of author
	*/
	public void SetUrl(const char[] url)
	{
		this.SetString("url", url);
	}

	/**
	* 	url of author icon (only supports http(s) and attachments)
	*/
	public bool GetIcon(char[] output, int maxsize)
	{
		return this.GetString("icon_url", output, maxsize);
	}

	/**
	* 	url of author icon (only supports http(s) and attachments)
	*/
	public void SetIcon(const char[] iconUrl)
	{
		this.SetString("icon_url", iconUrl);
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