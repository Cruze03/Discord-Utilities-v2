~~Not recommended in server with a lot of players YET because it may still have some memory leaks~~
# [Join the DU discord server for latest binary and support](https://discord.gg/WCNjEDPD2v)

## Requirements to run these plugin(s)
**-** [**New Discord API Plugin**](https://github.com/Cruze03/discord-api/blob/main/discord_api.smx) (Remove the [old one](https://github.com/Cruze03/sourcemod-discord/blob/master/discord_api.smx) to avoid conflicts)

## Main Module
- This is needed for all the other modules.
- Consists how to retrieve and store data to config.

## Server Details Module
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill `map` in `CHANNEL_IDS` section with your server details **Channel ID**.
- Type `sm_du_refresh` in your in-game client console.

![Server Details](https://cdn.discordapp.com/attachments/756189500828549271/1010849510559330384/server_details.png)

## Chat Relay Module
- Open `addons/sourcemod/configs/DiscordUtilitiesv2.txt`
- Fill up the `key` in `BOT_TOKEN` section with your **BOT's Token Key**.
- Fill up the `key` in `API_KEY` section with your [Steam API Key](https://steamcommunity.com/dev/apikey).
- Fill `chat` in `CHANNEL_IDS` section with your chat relay **Channel ID**.
- Fill `chat` in `WEBHOOKS` section with your chat relay **Webhook URL**.
- Type `sm_du_refresh` in your in-game client console.

![Chat Relay](https://cdn.discordapp.com/attachments/756189500828549271/1010851311358586931/chat_relay1.png)
![Chat Relay](https://cdn.discordapp.com/attachments/756189500828549271/1010851312038072400/chat_relay2.png)

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
- Type `sm_du_refresh` in your in-game client console.

![Verification](https://cdn.discordapp.com/attachments/756189500828549271/1010850115101147156/verification.png)

**[Recommended]** Create a password protected, less slots server (1-5) and mark that as the "primary" server. Keep these convars values to avoid map change in that server: `sv_hibernate_when_empty 0;mp_maxrounds 99999;mp_roundtime 60;mp_roundtime_defuse 60`

**NOTE: `map` & `verification` keys in `MESSAGE_IDS` section are automatically added with **message id** by the respective plugins. If you want to add a new message in your respective channel, just remove the id from `map` or `verification` keys in `MESSAGE_IDS` section and reload the current map.**
