#if defined _DiscordEmbedVideo_included_
  #endinput
#endif
#define _DiscordEmbedVideo_included_

methodmap DiscordEmbedVideo < JSON_Object
{
	public DiscordEmbedVideo(const char[] url = "", int height, int width)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("url", url);
		obj.SetInt("height", height);
		obj.SetInt("width", width);
		return view_as<DiscordEmbedVideo>(obj);
	}

	/**
	*	height of video
	*/
	property int Height
	{
		public get() { return this.GetInt("height"); }
		public set(int value) { this.SetInt("height", value); }
	}

	/**
	*	width of video
	*/
	property int Width
	{
		public get() { return this.GetInt("width"); }
		public set(int value) { this.SetInt("width", value); }
	}

	/**
	*	source url of video
	*/
	public bool GetUrl(char[] output, int maxsize)
	{
		return this.GetString("url", output, maxsize);
	}

	/**
	*	source url of video
	*/
	public void SetUrl(const char[] url)
	{
		this.SetString("url", url);
	}

	/**
	*	a proxied url of the video
	*/
	public bool GetProxyUrl(char[] output, int maxsize)
	{
		return this.GetString("proxy_url", output, maxsize);
	}

	/**
	*	a proxied url of the video
	*/
	public void SetProxyUrl(const char[] url)
	{
		this.SetString("proxy_url", url);
	}
}