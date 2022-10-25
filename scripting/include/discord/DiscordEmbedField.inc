#if defined _DiscordEmbedField_included_
  #endinput
#endif
#define _DiscordEmbedField_included_

#define MAX_FIELD_NAME_LENGTH 256 // https://discord.com/developers/docs/resources/channel#embed-limits-limits
#define MAX_FIELD_VALUE_LENGTH 1024 // https://discord.com/developers/docs/resources/channel#embed-limits-limits

/**
*	field information
*/
methodmap DiscordEmbedField < JSON_Object
{
	public DiscordEmbedField(const char[] name = "", const char[] value = "", bool inline = false)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("name", name);
		obj.SetString("value", value);
		obj.SetBool("inline", inline);
		return view_as<DiscordEmbedField>(obj);
	}

	/**
	*	whether or not this field should display inline
	*/
	property bool Inline
	{
		public get() { return this.GetBool("inline"); }
		public set(bool value) { this.SetBool("inline", value); }
	}

	/**
	*	name of the field
	*/
	public bool GetName(char[] output, int maxsize)
	{
		return this.GetString("name", output, maxsize);
	}

	/**
	*	name of the field
	*/
	public void SetName(const char[] name)
	{
		this.SetString("name", name);
	}

	/**
	*	value of the field
	*/
	public bool GetValue(char[] output, int maxsize)
	{
		return this.GetString("value", output, maxsize);
	}

	/**
	*	value of the field
	*/
	public void SetValue(const char[] value)
	{
		this.SetString("value", value);
	}
}