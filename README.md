## Requirements to run these plugin(s)
**-** [**New Discord API Plugin**](https://github.com/Cruze03/discord-api/blob/main/discord_api.smx) (Remove the [old one](https://github.com/Cruze03/sourcemod-discord/blob/master/discord_api.smx) to avoid conflicts) (**Please restart server when first added / when new version added**)

## Main Module
- This is needed for all the other modules.
- Consists how to retrieve and store data to config.

## Server Details Module
- Add `addons/sourcemod/plugins/du_serverdetails.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill up the `map_thumbnail` in `WEBHOOK_SETTINGS` section with your **Custom Map Thumbnail URL**.
- Fill `map` in `CHANNEL_IDS` section with your server details **Channel ID**.
- Fill up the `server_dns_name` in `WEBHOOK_SETTINGS` section with your **Custom DNS** or leave it empty to use regular public IP.
- Add `addons/sourcemod/translations/du_serverdetails.phrases.txt` in your server.
- Reload your current map.

![Server Details](https://cdn.discordapp.com/attachments/756189500828549271/1051479840194314322/ServerDetails.png?ex=66323969&is=6630e7e9&hm=e1e987739be877fad5074bb1dbd066f3f0ff545bca5e2f79a87aefe3a1d60408&)

## Chat Relay Module
- Add `addons/sourcemod/plugins/du_chatrelay.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill up the `key` in `API_KEY` section with your [Steam API Key](https://steamcommunity.com/dev/apikey).
- Fill `chat` in `CHANNEL_IDS` section with your chat relay **Channel ID**.
- Fill `chat` in `WEBHOOKS` section with your chat relay **Webhook URL**.
- Reload your current map.

![Chat Relay](https://cdn.discordapp.com/attachments/756189500828549271/1010851311358586931/chat_relay1.png?ex=66321325&is=6630c1a5&hm=c852dbf66ed51f70d887eae32f87b2161351804e9336b852a997dc29759c9c29&)
![Chat Relay2](https://cdn.discordapp.com/attachments/756189500828549271/1010851312038072400/chat_relay2.png?ex=66321325&is=6630c1a5&hm=67a4d3361ac57b0da108878693ff1d82a22b37657de5b5b0e08cae5e5ddfccf9&)

## Verification Module
- Add `addons/sourcemod/plugins/du_verification.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `verification` in `CHANNEL_IDS` section with your verification **Channel ID**.
- Fill `primary` in `VERIFICATION_SETTINGS` section with '1' if it's your primary server else '0'. **(Keep this '1' only in one server)**
- Fill `serverid` in `VERIFICATION_SETTINGS` section with a **unique value**.
- Fill `guildid` in `VERIFICATION_SETTINGS` section with your **Discord Server ID**.
- Fill `roleid` in `VERIFICATION_SETTINGS` section with your verification **Role ID**.
- Fill `invite_link` in `VERIFICATION_SETTINGS` section with your discord server **Invite Link**.
- Fill `command` in `VERIFICATION_SETTINGS` section with the command(s) players need to type in **Discord** to link their discord. (Split multiple commands with **',{space}'**)**(Max 5)**
- Fill `command_ingame` in `VERIFICATION_SETTINGS` section with the command(s) players need to type **In-Game** to get their verification code. (Split multiple commands with **',{space}'**)**(Max 5)**
- Fill `blocked_commands` in `VERIFICATION_SETTINGS` section with the command(s) players cannot access without verifying their discord. (Split multiple commands with **',{space}'**)**(Max 64)**
- Change `use_swgm_for_blocked_commands` in `VERIFICATION_SETTINGS` section to '1' if you want to use  commands from **SWGM config file** as well.
- Fill `database_name` in `VERIFICATION_SETTINGS` section with database entry name in `configs/database.cfg`
- Fill `table_name` in `VERIFICATION_SETTINGS` section with your desired table name in the database.
- Add `addons/sourcemod/translations/du_verification.phrases.txt` in your server.
- Reload your current map.

![Verification](https://cdn.discordapp.com/attachments/756189500828549271/1010850115101147156/verification.png?ex=66321208&is=6630c088&hm=18865cdce32439dbffade7aee851d08fed0f2e98718f066a7f8c936bb6d41716&)

## Bug Report Module
- Add `addons/sourcemod/plugins/du_bugreport.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `bugreport` in `WEBHOOKS` section with your bug report **Webhook URL**.
- Fill up the `server_dns_name` in `WEBHOOK_SETTINGS` section with your custom dns or leave it empty.
- Add `addons/sourcemod/translations/du_bugreport.phrases.txt` in your server.
- Reload your current map.

![Bug Report](https://cdn.discordapp.com/attachments/756189500828549271/1051478038409383977/Bugreport.png?ex=663237bb&is=6630e63b&hm=d67fe6c6400425fbbe1a53d696d5aa3fa414a364acc7ef76050903b0858ed9cf&)

## Call Admin Module
- Add `addons/sourcemod/plugins/du_calladmin.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `calladmin` in `WEBHOOKS` section with your calladmin **Webhook URL**.
- Fill up the `server_dns_name` in `WEBHOOK_SETTINGS` section with your custom dns or leave it empty.
- Add `addons/sourcemod/translations/du_calladmin.phrases.txt` in your server.
- Reload your current map.

![CallAdmin](https://cdn.discordapp.com/attachments/756189500828549271/1051478038119981127/Calladmin.png?ex=663237bb&is=6630e63b&hm=25e20ef878edb72ba8e58f969d89b3f19c9f749bf20f06ae4c62aec48ae17d11&)

## Sourcebans / MaterialAdmin Module
- Add `addons/sourcemod/plugins/du_sourcebans.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `bans` in `WEBHOOKS` section with your bans **Webhook URL**.
- Fill `comms` in `WEBHOOKS` section with your comms **Webhook URL**.
- Fill `reportplayer` in `WEBHOOKS` section with your sourcebans/materialadmin report **Webhook URL**.
- Fill up the `server_dns_name` in `WEBHOOK_SETTINGS` section with your custom dns or leave it empty.
- Add `addons/sourcemod/translations/du_sourcebans.phrases.txt` in your server.
- Reload your current map.

![Sourcebans or MaterialAdmin](https://cdn.discordapp.com/attachments/756189500828549271/1051478037734113320/Sourcebans.png?ex=663237bb&is=6630e63b&hm=2ab4d047800480ad460b0330d0f5d839c7199f5e09de8b216c334fdaef91db20&)

## Admin Logs Module
- Add `addons/sourcemod/plugins/du_adminlogs.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `adminlog` in `CHANNEL_IDS` section with your adminlog **Channel ID**.
- Add `addons/sourcemod/translations/du_adminlogs.phrases.txt` in your server.
- Reload your current map.

![AdminLogs](https://cdn.discordapp.com/attachments/756189500828549271/1064499566478630972/image.png?ex=663220fa&is=6630cf7a&hm=3547848391a612815b655381fb4736460dd10fc58c26c5641f20e2bc4966e386&)

## Crash Report Module
- Add `addons/sourcemod/plugins/du_crashreport.smx`
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `crashreport` in `CHANNEL_IDS` section with your crash report **Channel ID** which is only visible to admins.
- Fill `crashreport_nonadmin` in `CHANNEL_IDS` section with your adminlog **Channel ID**.
- Fill up the `server_dns_name` in `WEBHOOK_SETTINGS` section with your custom dns or leave it empty.
- Add `addons/sourcemod/translations/du_crashreport.phrases.txt` in your server.
- Reload your current map.

### Console history works in Windows only

![CrashReport1](https://cdn.discordapp.com/attachments/756189500828549271/1078406956684955688/crashreport.png?ex=6631f77e&is=6630a5fe&hm=d95f5d67c462f041d32c0cbdff61a2a1cc5507494c5ab0e087a1c098e019f028&)

![CrashReport2](https://cdn.discordapp.com/attachments/756189500828549271/1078406957028872313/crashreport_nonadmin.png?ex=6631f77e&is=6630a5fe&hm=b653561ed2c47fe11e145b91c243f056c160a6058fe48f958a4c49f82f416e36&)

## Server Tracker Module
- This module is used for your convenience only. It helps you know which of your server is using which `serverid` & which server is `primary`.
- Fill up the `servers_table_name` in `VERIFICATION_SETTINGS` section with your desired table name for this module. (Table will be created under `database_name` database)
- Reload your current map.

![Server Tracker](https://cdn.discordapp.com/attachments/756189500828549271/1051483671657455677/ServerTracker.png?ex=66323cfa&is=6630eb7a&hm=a9282e08a35280cad8accd43a141f165d77682715b4d38b3a4de192a85a74741&)

### Recommended:
1) Create a password protected, less slots server (1-5) and mark that as the "primary" server. Keep these convars values to avoid map change in that server: `sv_hibernate_when_empty 0;mp_maxrounds 99999;mp_roundtime 60;mp_roundtime_defuse 60`. This is to avoid bot missing a message to delete when primary server is between changing maps.
2) Make sure **slow-mode** in turned on for atleast **15 seconds** in **Chat Relay** & **Verification** discord channel(s) to avoid getting Rate Limited when someone is spamming.

### NOTE:
1) `map` & `verification` keys in `MESSAGE_IDS` section are automatically added with **message id** by the respective plugins. If you want to add a new message in your respective channel, just remove the id from `map` or `verification` keys in `MESSAGE_IDS` section and reload the current map.
2) Why is this not compilable in SM 1.12? [It is because of this :(](https://github.com/alliedmodders/sourcepawn/issues/671). I personally use SM 1.10 compiler
