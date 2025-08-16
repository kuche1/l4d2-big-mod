
#define SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_DEFAULT     3
#define SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_DEFAULT_STR "3"
#define SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_CVAR_NAME   "cs_show_map_vote_message_after_failures"
#define SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_CVAR_DESC   "A message reminding the players that they can change campaigns will be display on every failure after that many failures"

#define SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE 10
#define SETTING_MAX_CAMPAIGNS 40

#define SETTING_DELAY_BEFORE_SWITCHING_MAP 5.0
// this used to be an array with a different value for each gamemode
// I don't know if there is a good reason for it, or just aesthetic
// float g_fWaitTimeBeforeSwitch[] = {
//     5.0,    // GAMEMODE_COOP
//     3.0,    // GAMEMODE_VERSUS
//     8.0,    // GAMEMODE_SCAVENGE
//     5.0,    // GAMEMODE_SURVIVAL
//     5.0     // GAMEMODE_VERSUS_SURVIVAL
// };

#define MAPNAME_SIZE PLATFORM_MAX_PATH
// do not change
