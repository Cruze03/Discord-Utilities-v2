#if defined _DiscordEmbedImage_included_
  #endinput
#endif
#define _DiscordEmbedImage_included_

methodmap DiscordEmbedImage < JSON_Object
{
	public DiscordEmbedImage(const char[] url = "", int height, int width)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("url", url);
		obj.SetInt("height", height);
		obj.SetInt("width", width);
		return view_as<DiscordEmbedImage>(obj);
	}

	/**
	*	height of image
	*/
	property int Height
	{
		public get() { return this.GetInt("height"); }
		public set(int value) { this.SetInt("height", value); }
	}

	/**
	*	width of image
	*/
	property int Width
	{
		public get() { return this.GetInt("width"); }
		public set(int value) { this.SetInt("width", value); }
	}

	/**
	*	source url of image (only supports http(s) and attachments)
	*/
	public bool GetUrl(char[] output, int maxsize)
	{
		return this.GetString("url", output, maxsize);
	}

	/**
	*	source url of image (only supports http(s) and attachments)
	*/
	public void SetUrl(const char[] url)
	{
		this.SetString("url", url);
	}

	/**
	*	a proxied url of the image
	*/
	public bool GetProxyUrl(char[] output, int maxsize)
	{
		return this.GetString("proxy_url", output, maxsize);
	}

	/**
	*	a proxied url of the image
	*/
	public void SetProxyUrl(const char[] url)
	{
		this.SetString("proxy_url", url);
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