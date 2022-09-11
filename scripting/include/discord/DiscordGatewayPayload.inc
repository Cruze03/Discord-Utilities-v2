#if defined _DiscordGatewayPayload_included_
  #endinput
#endif
#define _DiscordGatewayPayload_included_

enum DiscordGatewayOpCode
{
	Dispatch = 0, /* An event was dispatched. */
	Heartbeat, /* Fired periodically by the client to keep the connection alive. */
	Identify, /* Starts a new session during the initial handshake. */
	PresenceUpdate, /* Update the client's presence. */
	VoiceStateUpdate, /* Used to join/leave or move between voice channels. */
	Resume, /* 	Resume a previous session that was disconnected. */
	Reconnect, /* You should attempt to reconnect and resume immediately. */
	RequestGuildMembers, /* Request information about offline guild members in a large guild. */
	InvalidSession, /* The session has been invalidated. You should reconnect and identify/resume accordingly. */
	Hello, /* Sent immediately after connecting, contains the heartbeat_interval to use. */
	HEartbeatACK /* Sent in response to receiving a heartbeat to acknowledge that it has been received. */
}

methodmap DiscordGatewayPayload < JSON_Object
{
	public DiscordGatewayPayload(DiscordGatewayOpCode op, JSON_Object d = null, int s = 0, const char[] t = "")
	{
		JSON_Object obj = new JSON_Object();
		obj.SetInt("op", view_as<int>(op));
		obj.SetObject("d", d);
		obj.SetInt("s", s);
		obj.SetString("t", t);
		return view_as<DiscordGatewayPayload>(obj);
	}
}