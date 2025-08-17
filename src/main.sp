
#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#include "settings.sp"
#include "map_manager/map_manager.sp"

public Plugin myinfo =
{
    name        = "Big Mod",
    author      = "kuche1",
    description = "Big Mod",
    version     = "v0.0-dev0",
    url         = "https://github.com/kuche1/l4d2-big-mod",
}

public void OnPluginStart()
{
    map_manager.init();
}

public Action Event_RoundEnd(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
    // Check to see if on a finale map, if so change to the next campaign after two rounds
    switch (g_iGameMode)
    {
        // If in Coop and on a finale, check to see if the survivors have lost the max amount of times
        case GAMEMODE_COOP:
        {
            if (g_bFinaleWon == false)
            {
                coop_failure_counter_on_coop_failure();

                int failure_count = coop_failure_counter_get_count();

                // PrintToChatAll("\x03[CS]\x05 dbg: Failure Count: %d (>=  %d)", failure_count, g_coopShowMapVoteMessageAfterFailures);

                if (g_bVotingEnabled == true)
                {
                    if (failure_count >= g_coopShowMapVoteMessageAfterFailures)
                    {
                        
                    }
                }
            }

            if ((g_iWinningMapVotes > 0) && (g_iWinningMapIndex >= 0))
            {
                ChangeMapIfNeeded();
            }
        }
        // If in Survival, check to see if round ends have reached the max amount of times
        case GAMEMODE_SURVIVAL:
        {
            // This uses round end counter to check the rounds
            // This can be fired multiple times, and this function helps handle that
            if (IncrementRoundEndCounter() >= 2)
            {
                ChangeMapIfNeeded();
            }
        }
    }
    PrintToChatAll("%s You can change the map with: %s %s !changecampaign to change the map", PREFIX, CMD_SKIP_CHAPTER, CMD_CHANGE_CAMPAIGN);
    return Plugin_Continue;
}
