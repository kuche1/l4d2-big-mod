
#define campaign_manager_SETTING_skip_chapter_enabled (true)

bool campaign_manager_DB_votes_skip_chapter[MAXPLAYERS + 1] = {false};
#define campaign_manager_DB_votes_skip_chapter_len (MAXPLAYERS + 1)

void campaign_manager_FNC_reset_skip_chapter_votes(){
    for(int idx=0; idx<campaign_manager_DB_votes_skip_chapter_len; ++idx){
        campaign_manager_DB_votes_skip_chapter[idx] = false;
    }
}

Action campaign_manager_ON_skip_chapter_vote(int client_id, int args)
{
    //// checks

    if(client_id < 1){
        PrintToServer("You cannot vote from the server console, use the in-game chat");
        return Plugin_Continue;
    }

    if(g_iGameMode != GAMEMODE_COOP){
        PrintToChat(client_id, "\x03[CS]\x05 Skipping chapters is only available for Coop");
        return Plugin_Continue;
    }

    if(!campaign_manager_SETTING_skip_chapter_enabled){
        PrintToChat(client_id, "\x03[CS]\x05 Chapter skipping has been disabled");
        return Plugin_Continue;
    }

    char client_name[MAX_NAME_LENGTH];
    if (!GetClientName(client_id, client_name, sizeof(client_name)))
    {
        LogError("[CS] ERROR: could not get client name for player %d", client_id);
        return Plugin_Continue;
    }

    //// vote

    bool client_reverted_vote = campaign_manager_DB_votes_skip_chapter[client_id];
    campaign_manager_DB_votes_skip_chapter[client_id] = !campaign_manager_DB_votes_skip_chapter[client_id];

    int total_votes = 0;
    for(int vote_idx; vote_idx<campaign_manager_DB_votes_skip_chapter_len; ++vote_idx){
        if(campaign_manager_DB_votes_skip_chapter[vote_idx]){
            total_votes += 1;
        }
    }

    int total_players = get_active_players();

    if (client_reverted_vote) {
        PrintToChatAll("\x03[CS]\x05 \x04%s\x05 has reverted their vote to skip this chapter (%d/%d)", client_name, total_votes, total_players);
    } else {
        PrintToChatAll("\x03[CS]\x05 \x04%s\x05 has voted to skip this chapter (%d/%d)", client_name, total_votes, total_players);
    }

    if (total_votes < total_players) {
        return Plugin_Continue;
    }

    campaign_manager_FNC_reset_skip_chapter_votes();

    //// skip chapter

    campaign_manager_FNC_skip_chapter();

    return Plugin_Continue;
}

void campaign_manager_ON_map_start(){
    campaign_manager_FNC_reset_skip_chapter_votes();
}

void campaign_manager_ON_before_client_disconnect(int client_id){
    campaign_manager_DB_votes_skip_chapter[client_id] = false;
}
