#if defined _DiscordEmbedFooter_included_
  #endinput
#endif
#define _DiscordEmbedFooter_included_

#define MAX_FOOTER_TEXT_LENGTH 2048 // https://discord.com/developers/docs/resources/channel#embed-limits-limits

methodmap DiscordEmbedFooter < JSON_Object
{
	public DiscordEmbedFooter(const char[] text = "", const char[] iconUrl = "")
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("text", text);
		obj.SetString("icon_url", iconUrl);
		return view_as<DiscordEmbedFooter>(obj);
	}

	/**
	*	footer text
	*/
	public bool GetText(char[] output, int maxsize)
	{
		return this.GetString("text", output, maxsize);
	}

	/**
	*	footer text
	*/
	public void SetText(const char[] text)
	{
		this.SetString("text", text);
	}

	/**
	*	url of footer icon (only supports http(s) and attachments)
	*/
	public bool GetIcon(char[] output, int maxsize)
	{
		return this.GetString("icon_url", output, maxsize);
	}

	/**
	*	url of footer icon (only supports http(s) and attachments)
	*/
	public void SetIcon(const char[] iconUrl)
	{
		this.SetString("icon_url", iconUrl);
	}

	/**
	*	a proxied url of footer icon
	*/
	public bool GetIconProxyURL(char[] output, int maxsize)
	{
		return this.GetString("proxy_icon_url", output, maxsize);
	}

	/**
	*	a proxied url of footer icon
	*/
	public void SetIconProxyURL(const char[] iconUrl)
	{
		this.SetString("proxy_icon_url", iconUrl);
	}
}