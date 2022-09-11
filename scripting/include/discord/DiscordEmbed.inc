#if defined _DiscordEmbed_included_
  #endinput
#endif
#define _DiscordEmbed_included_

#include <discord/DiscordEmbedAuthor>
#include <discord/DiscordEmbedFooter>
#include <discord/DiscordEmbedProvider>
#include <discord/DiscordEmbedThumbnail>
#include <discord/DiscordEmbedImage>
#include <discord/DiscordEmbedVideo>
#include <discord/DiscordEmbedField>

#define MAX_EMBED_DESCRIPTION_LENGTH 4096 // https://discord.com/developers/docs/resources/channel#embed-limits-limits
#define MAX_EMBED_FIELDS 25

methodmap DiscordEmbed < JSON_Object
{
	public DiscordEmbed(DiscordEmbed embed = view_as<DiscordEmbed>(null))
	{
		if(embed == null)
			embed = view_as<DiscordEmbed>(new JSON_Object());

		return embed;
	}

	/**
	* 	title of embed
	*/
	public void WithTitle(const char[] title)
	{
		this.SetString("title", title);
	}

	/**
	*	title of embed
	*/
	public bool GetTitle(char[] output, int maxsize)
	{
		return this.GetString("title", output, maxsize);
	}

	/**
	* 	description of embed
	*/
	public void WithDescription(const char[] description)
	{
		this.SetString("description", description);
	}

	/**
	* 	description of embed
	*/
	public bool GetDescription(char[] output, int maxsize)
	{
		return this.GetString("description", output, maxsize);
	}

	/**
	* 	url of embed
	*/
	public void WithUrl(const char[] url)
	{
		this.SetString("url", url);
	}

	/**
	* 	url of embed
	*/
	public bool GetUrl(char[] output, int maxsize)
	{
		return this.GetString("url", output, maxsize);
	}

	/**
	*	timestamp of embed content
	*/
	public void WithTimestamp(DateTime dateTime)
	{
		char szDate[DATE_LENGTH];
		dateTime.ToString(szDate, sizeof(szDate), "%Y-%m-%d %H:%M:%S%z");
		this.SetString("timestamp", szDate);
	}

	/**
	* 	timestamp of embed content
	*/
	public bool GetTimestamp(DateTime& out)
	{
		char szDate[DATE_LENGTH];
		this.GetString("timestamp", szDate, sizeof(szDate));
		return DateTime.TryParse(szDate, out);
	}

	/**
	* 	type of embed (always "rich" for webhook embeds)
	*	( https://discord.com/developers/docs/resources/channel#embed-object-embed-types )
	*/
	public void SetType(const char[] type = "rich")
	{
		this.SetString("type", type);
	}

	/**
	* 	type of embed (always "rich" for webhook embeds)
	*	( https://discord.com/developers/docs/resources/channel#embed-object-embed-types )
	*/
	public bool GetType(char[] output, int maxsize)
	{
		return this.GetString("type", output, maxsize);
	}

	/**
	*	color code of the embed
	*/
	public void SetColor(const char[] hexcode)
	{
		this.SetInt("color", HexToDec(hexcode));
	}

	/**
	* 	color code of the embed
	*/
	public void GetColor(char[] output, int maxsize)
	{
		int color = this.GetInt("color");
		Format(output, maxsize, "#%X", color);
	}

	/**
	* 	author information
	*/
	public void WithAuthor(DiscordEmbedAuthor author)
	{
		this.SetObject("author", author);
	}

	/**
	* 	author information
	*/
	public DiscordEmbedAuthor GetAuthor()
	{
		return view_as<DiscordEmbedAuthor>(this.GetObject("author"));
	}

	/**
	* 	footer information
	*/
	public void WithFooter(DiscordEmbedFooter footer)
	{
		this.SetObject("footer", footer);
	}

	/**
	* 	footer information
	*/
	public DiscordEmbedFooter GetFooter()
	{
		return view_as<DiscordEmbedFooter>(this.GetObject("footer"));
	}

	/**
	*	image information
	*/
	public void WithImage(DiscordEmbedImage image)
	{
		this.SetObject("image", image);
	}

	/**
	* 	image information
	*/
	public DiscordEmbedImage GetImage()
	{
		return view_as<DiscordEmbedImage>(this.GetObject("image"));
	}

	/**
	*	thumbnail information
	*/
	public void WithThumbnail(DiscordEmbedThumbnail thumbnail)
	{
		this.SetObject("thumbnail", thumbnail);
	}

	/**
	*	thumbnail information
	*/
	public DiscordEmbedThumbnail GetThumbnail()
	{
		return view_as<DiscordEmbedThumbnail>(this.GetObject("thumbnail"));
	}

	/**
	* 	video information
	*/
	public void WithVideo(DiscordEmbedVideo video)
	{
		this.SetObject("video", video);
	}

	/**
	* 	video information
	*/
	public DiscordEmbedVideo GetVideo()
	{
		return view_as<DiscordEmbedVideo>(this.GetObject("video"));
	}

	/**
	* 	provider information
	*/
	public void WithProvider(DiscordEmbedProvider provider)
	{
		this.SetObject("provider", provider);
	}

	/**
	* 	provider information
	*/
	public DiscordEmbedProvider GetProvider()
	{
		return view_as<DiscordEmbedProvider>(this.GetObject("provider"));
	}

	/**
	* 	fields information
	*/
	public JSON_Array GetFields()
	{
		return view_as<JSON_Array>(this.GetObject("fields"));
	}

	/**
	* 	add a new field to the embed
	*/
	public void AddField(DiscordEmbedField field)
	{
		if(!this.HasKey("fields"))
			this.SetObject("fields", new JSON_Array());

		JSON_Array fields = this.GetFields();
		if(fields.Length < MAX_EMBED_FIELDS)
		{
			fields.PushObject(field);
			this.SetObject("fields", fields);
		} else LogError("DiscordEmbed cannot have more than %i fields!", MAX_EMBED_FIELDS);
	}

	/**
	* 	remove a field from the embed
	*/
	public bool RemoveField(int index)
	{
		JSON_Array fields = this.GetFields();
		bool result = fields.Remove(index);
		this.SetObject("fields", fields);
		return result;
	}

	/**
	* 	color code of the embed
	*/
	property int Color
	{
		public get() { return this.GetInt("color"); }
		public set(int value) { this.SetInt("color", value); }
	}

	/**
	* 	timestamp of embed content
	*/
	property DateTime Timestamp
	{
		public get()
		{ 
			char szDate[DATE_LENGTH];
			this.GetString("timestamp", szDate, sizeof(szDate));
			return DateTime.Parse(szDate);
		}

		public set(DateTime value) { this.WithTimestamp(value); }
	}

	/**
	* 	author information
	*/
	property DiscordEmbedAuthor Author
	{
		public get() { return this.GetAuthor(); }
		public set(DiscordEmbedAuthor value) { this.WithAuthor(value); }
	}

	/**
	* 	footer information
	*/
	property DiscordEmbedFooter Footer
	{
		public get() { return this.GetFooter(); }
		public set(DiscordEmbedFooter value) { this.WithFooter(value); }
	}

	/**
	* 	image information
	*/
	property DiscordEmbedImage Image
	{
		public get() { return this.GetImage(); }
		public set(DiscordEmbedImage value) { this.WithImage(value); }
	}

	/**
	* 	thumbnail information
	*/
	property DiscordEmbedThumbnail Thumbnail
	{
		public get() { return this.GetThumbnail(); }
		public set(DiscordEmbedThumbnail value) { this.WithThumbnail(value); }
	}

	/**
	* 	video information
	*/
	property DiscordEmbedVideo Video
	{
		public get() { return this.GetVideo(); }
		public set(DiscordEmbedVideo value) { this.WithVideo(value); }
	}

	/**
	* 		provider information
	*/
	property DiscordEmbedProvider Provider
	{
		public get() { return this.GetProvider(); }
		public set(DiscordEmbedProvider value) { this.WithProvider(value); }
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

public int HexToDec(const char[] hex)
{
	int i, val, decimal;
	int len = strlen(hex);
	len--;
	
	for(i = 0; hex[i] != '\0'; i++)
	{
		/* Find the decimal representation of hex[i] */
		if(hex[i] >= '0' && hex[i] <= '9')
		{
			val = hex[i] - 48;
		}
		else if(hex[i] >= 'a' && hex[i] <= 'f')
		{
			val = hex[i] - 97 + 10;
		}
		else if(hex[i] >= 'A' && hex[i] <= 'F')
		{
			val = hex[i] - 65 + 10;
		}

		decimal += val * RoundToFloor(Pow(float(16),float(len)));
		len--;
	}
	return decimal;
}