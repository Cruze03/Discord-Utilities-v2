#if defined _DiscordAttachment_included_
  #endinput
#endif
#define _DiscordAttachment_included_

methodmap DiscordAttachment < DiscordObject
{
	/**
	*   height of file (if image)
	*/
	property int Height
	{
		public get() { return this.GetInt("height"); }
	}

	/**
	*   width of file (if image)
	*/
	property int Width
	{
		public get() { return this.GetInt("width"); }
	}

	/**
	*   size of file in bytes
	*/
	property int Size
	{
		public get() { return this.GetInt("size"); }
	}

	/**
	*   whether this attachment is ephemeral
	*   Ephemeral attachments will automatically be removed after a set period of time.
	*   Ephemeral attachments on messages are guaranteed to be available as long as the message itself exists.
	*/
	property bool Ephemeral
	{
		public get() { return this.GetBool("ephemeral"); }
	}

	/**
	*   source url of file
	*/
	public bool GetUrl(char[] output, int maxsize)
	{
		return this.GetString("url", output, maxsize);
	}

	/**
	*   a proxied url of file
	*/
	public bool GetProxyUrl(char[] output, int maxsize)
	{
		return this.GetString("proxy_url", output, maxsize);
	}

	/**
	*   name of file attached
	*/
	public bool GetFilename(char[] output, int maxsize)
	{
		return this.GetString("filename", output, maxsize);
	}

	/**
	*   description for the file
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}

	/**
	*   the attachment's media type
	*   ( https://en.wikipedia.org/wiki/Media_type )
	*/
	public bool GetContentType(char[] output, int maxsize)
	{
		return this.GetString("content_type", output, maxsize);
	}
}