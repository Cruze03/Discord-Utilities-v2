#if defined _DiscordTypeExtensions_included_
  #endinput
#endif
#define _DiscordTypeExtensions_included_

methodmap DiscordTypeExtension < JSON_Array
{
}

methodmap DiscordRoleList < DiscordTypeExtension { }
methodmap DiscordMessageList < DiscordTypeExtension { }
methodmap DiscordChannelList < DiscordTypeExtension { }
methodmap DiscordGuildList < DiscordTypeExtension { }
methodmap DiscordGuildScheduledEventList < DiscordTypeExtension { }