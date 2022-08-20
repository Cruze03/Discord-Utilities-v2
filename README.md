# Not recommended in server with a lot of players YET

## Server Details Module
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `map` in `CHANNEL_IDS` section with your server details **Channel ID**.
- Type `sm_sd_refresh` in your in-game client console.
- Type `sm_sd_addmessage` in your in-game client console.
- New message should be added in your channel. (If not, go to troubleshoot wiki page)
- Follow the steps given in that message to copy & paste **message id** to appropriate place.
- Type `sm_sd_refresh` again in your in-game client console.

## Chat Relay Module
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill up the `key` in `API_KEY` section with your [Steam API Key](https://steamcommunity.com/dev/apikey).
- Fill `chat` in `CHANNEL_IDS` section with your chat relay **Channel ID**.
- Fill `chat` in `WEBHOOKS` section with your chat relay **Webhook URL**.
- Type `sm_cr_refresh` in your in-game client console.

## Verification Module
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `verification` in `CHANNEL_IDS` section with your verification **Channel ID**.
- Fill `primary` in `VERIFICATION_SETTINGS` section with '1' if it's your primary server else '0'. **(Keep this '1' only in one server)**
- Fill `serverid` in `VERIFICATION_SETTINGS` section with a **unique value**.
- Fill `guildid` in `VERIFICATION_SETTINGS` section with your **Discord Server ID**.
- Fill `roleid` in `VERIFICATION_SETTINGS` section with your verification **Role ID**.
- Fill `invite_link` in `VERIFICATION_SETTINGS` section with your discord server **Invite Link**.
- Fill `command` in `VERIFICATION_SETTINGS` section with command players need to type in **Discord** to link their discord.
- Fill `command_ingame` in `VERIFICATION_SETTINGS` section with command players need to type **In-Game** to get their verification code.
- Fill `blocked_commands` in `VERIFICATION_SETTINGS` section with command players cannot access without verifying their discord. (Split multiple commands with **', '**)
- Fill `database_name` in `VERIFICATION_SETTINGS` section with database entry name in `configs/database.cfg`
- Fill `table_name` in `VERIFICATION_SETTINGS` section with table name that will be created inside the database.
- Type `sm_vr_refresh` in your in-game client console.
- Type `sm_vr_addmessage` in your in-game client console.
- New message should be added in your channel. Right-click the message and select "Copy ID".
- Paste the **message id** in `verification` in `MESSAGE_IDS` section.
- Type `sm_vr_refresh` in your in-game client console / Reload the current map.

**[Recommended]** Create a password protected, less slots server (1-5) and mark that as the "primary" server. Keep these convars values to avoid map change in that server: `sv_hibernate_when_empty 0;mp_maxrounds 99999;mp_roundtime 60;mp_roundtime_defuse 60`
