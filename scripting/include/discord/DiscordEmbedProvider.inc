#if defined _DiscordEmbedProvider_included_
  #endinput
#endif
#define _DiscordEmbedProvider_included_

/**
* provider information
*/
methodmap DiscordEmbedProvider < JSON_Object
{
	public DiscordEmbedProvider(const char[] name = "", const char[] url = "")
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("name", name);
		obj.SetString("url", url);
		return view_as<DiscordEmbedProvider>(obj);
	}

	/**
	*	name of provider
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	*	name of provider
	*/
	public void SetName(const char[] name)
	{
		this.SetString("name", name);
	}

	/**
	*	url of provider
	*/
	public bool GetUrl(char[] output, int maxsize)
	{
		return this.GetString("url", output, maxsize);
	}

	/**
	*	url of provider
	*/
	public void SetUrl(const char[] url)
	{
		this.SetString("url", url);
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