#if defined _DiscordWebHook_included_
  #endinput
#endif
#define _DiscordWebHook_included_

#include <discord/DiscordEmbed>

#define MAX_WEBHOOK_EMBEDS 10

methodmap DiscordWebHook < JSON_Object
{
	public DiscordWebHook(const char[] endpoint)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("__endpoint", endpoint);
		obj.SetHidden("__endpoint", true);
		return view_as<DiscordWebHook>(obj);
	}

	property bool TTS
	{
		public get() { return this.GetBool("tts"); }
		public set(bool value) { this.SetBool("tts", value); }
	}

	public void SetEndpoint(const char[] endpoint)
	{
		this.SetString("__endpoint", endpoint);
	}

	public bool GetEndpoint(char[] output, int maxsize)
	{
		return this.GetString("__endpoint", output, maxsize);
	}

	public void SetUsername(const char[] userName)
	{
		this.SetString("username", userName);
	}

	public bool GetUsername(char[] output, int maxsize)
	{
		return this.GetString("username", output, maxsize);
	}

	public void SetAvatar(const char[] avatarUrl)
	{
		this.SetString("avatar_url", avatarUrl);
	}

	public bool GetAvatar(char[] output, int maxsize)
	{
		return this.GetString("avatar_url", output, maxsize);
	}

	public JSON_Array GetEmbeds()
	{
		return view_as<JSON_Array>(this.GetObject("embeds"));
	}

	public void Embed(DiscordEmbed embed)
	{
		if(!this.HasKey("embeds"))
			this.SetObject("embeds", new JSON_Array());

		JSON_Array embeds = this.GetEmbeds();
		if(embeds.Length < MAX_WEBHOOK_EMBEDS)
		{
			embeds.PushObject(embed);
			this.SetObject("embeds", embeds);
		} else LogError("DiscordWebHook cannot have more than %i embeds!", MAX_WEBHOOK_EMBEDS);
	}

	public bool RemoveEmbed(int index)
	{
		JSON_Array embeds = this.GetEmbeds();
		bool result = embeds.Remove(index);
		this.SetObject("embeds", embeds);
		return result;
	}

	public void SetContent(const char[] content)
	{
		this.SetString("content", content);
	}

	public bool GetContent(char[] output, int maxsize)
	{
		return this.GetString("content", output, maxsize);
	}

	public void Send()
	{
		char url[256];
		this.GetEndpoint(url, sizeof(url));

		DiscordRequest request = new DiscordRequest(url, k_EHTTPMethodPOST);
		request.SetCallbacks(OnHTTPRequestComplete, _, OnHTTPDataReceive);
		request.SetJsonBody(this);
		request.Send();
	}
}