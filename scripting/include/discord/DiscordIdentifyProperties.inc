#if defined _DiscordIdentifyProperties_included_
  #endinput
#endif
#define _DiscordIdentifyProperties_included_

methodmap DiscordIdentifyProperties < JSON_Object
{
	public DiscordIdentifyProperties(const char[] os = "linux", const char[] browser = "disco", const char[] device = "disco")
	{
		JSON_Object obj = new JSON_Object();
		obj.SetString("$os", os);
		obj.SetString("$browser", browser);
		obj.SetString("$device", device);
		return view_as<DiscordIdentifyProperties>(obj);
	}
}