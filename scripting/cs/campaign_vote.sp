
#define campaign_manager_SETTING_change_campaign_enabled (true)

Action campaign_manager_ON_vote_change_campaign(int client_id, int args){
    if (!campaign_manager_SETTING_change_campaign_enabled){
        PrintToChat(iClient, "\x03[CS]\x05 Voting has been disabled on this server.");
        return;
    }

    // Open the vote menu for the client if they aren't using the server console
    if (iClient < 1)
        PrintToServer("You cannot vote for a map from the server console, use the in-game chat");
    else
        VoteMenuDraw(iClient);
}
