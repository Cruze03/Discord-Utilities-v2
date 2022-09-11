#if defined _DiscordPresence_included_
  #endinput
#endif
#define _DiscordPresence_included_

enum DiscordPresenceStatus
{
	STATUS_ONLINE = 0, /* Online */
	STATUS_DND, /* Do Not Disturb */
	STATUS_IDLE, /* AFK */
	STATUS_INVISIBLE, /* Invisible and shown as offline */
	STATUS_OFFLINE /* Offline */
}

methodmap DiscordPresence < JSON_Object
{
	public DiscordPresence(DiscordActivity activity, DiscordPresenceStatus status, bool afk = false, DateTime since)
	{
		JSON_Object obj = new JSON_Object();
		obj.SetInt("since", since.Unix);
		obj.SetBool("afk", afk);

		switch(status)
		{
			case STATUS_ONLINE: obj.SetString("status", "online");
			case STATUS_DND: obj.SetString("status", "dnd");
			case STATUS_IDLE: obj.SetString("status", "idle");
			case STATUS_INVISIBLE: obj.SetString("status", "invisible");
			case STATUS_OFFLINE: obj.SetString("status", "offline");
		}

		JSON_Array activities = new JSON_Array();
		activities.PushObject(activity);
		obj.SetObject("activities", activities);
		return view_as<DiscordPresence>(obj);
	}
}