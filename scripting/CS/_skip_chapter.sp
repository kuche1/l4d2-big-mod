
// // ideally there should be a configuration file for this
// #define SETTING_MAP_ROTATION                                                                                  \
//     {                                                                                                         \
//         \
//         /* official: l4d1 */ \
//         \
//         "c8m1_apartment", "c8m2_subway", "c8m3_sewers", "c8m4_interior", "c8m5_rooftop", /* no mercy */       \
//         "c9m1_alleys", "c9m2_lots", /* crash course */                                                        \
//         "c10m1_caves", "c10m2_drainage", "c10m3_ranchhouse", "c10m4_mainstreet", "c10m5_houseboat",           \
//         "c11m1_greenhouse", "c11m2_offices", "c11m3_garage", "c11m4_terminal", "c11m5_runway",                \
//         "c12m1_hilltop", "c12m2_traintunnel", "c12m3_bridge", "c12m4_barn", "c12m5_cornfield",                \
//         "c13m1_alpinecreek", "c13m2_southpinestream", "c13m3_memorialbridge", "c13m4_cutthroatcreek",         \
//         "c14m1_junkyard", "c14m2_lighthouse", /* the last stand */                                            \
//         \
//         /* official: l4d2 */ \
//         \
//         "c1m1_hotel", "c1m2_streets", "c1m3_mall", "c1m4_atrium",  /* dead center */                          \
//         "c2m1_highway", "c2m2_fairgrounds", "c2m3_coaster", "c2m4_barns", "c2m5_concert",                     \
//         "c3m1_plankcountry", "c3m2_swamp", "c3m3_shantytown", "c3m4_plantation",                              \
//         "c4m1_milltown_a", "c4m2_sugarmill_a", "c4m3_sugarmill_b", "c4m4_milltown_b", "c4m5_milltown_escape", \
//         "c5m1_waterfront", "c5m2_park", "c5m3_cemetery", "c5m4_quarter", "c5m5_bridge",                       \
//         "c6m1_riverbank", "c6m2_bedlam", "c6m3_port",                                                         \
//         \
//         /* custom: nightmare */ \
//         \
//         "nmrm1_apartment", "nmrm2_subway", "nmrm3_sewers", "nmrm4_hospital", "nmrm5_rooftop", /* No Mercy: Rehab */ \
//         "c1m1d_hotel", "c1m2d_streets", "c1m3d_mall", "c1m4d_atrium",  /* Dark Center */ \
//         "deadbeat01_forest", "deadbeat02_alley", "deadbeat03_street", "deadbeat04_park", /* Deadbeat Escape */ \
//         "c5m1_darkwaterfront", "c5m2_darkpark", "c5m3_darkcemetery", "c5m4_darkquarter", "c5m5_darkbridge", /* The Dark Parish */ \
//         "ft_m1_apartments_08_a", "ft_m2_subway_08_a", "ft_m3_sewers_08_b", "ft_m4_hospital_08_a", "ft_m5_rooftop_08_a", /* Fairfield Terror */ \
//         "hopeless_m1", "hopeless_m2", "hopeless_m3", /* Hopeless */ \
//     }


// //// default maps
// 
// char g_map_rotation_default[][PLATFORM_MAX_PATH] = SETTING_MAP_ROTATION;
// 
// #define g_map_rotation_default_len (sizeof(g_map_rotation_default)) // ? in sourcepawn `sizeof` gives the array length right away ? or maybe it's because the type is `char` ?
// 
// //// active maps
// 
// char g_map_rotation[g_map_rotation_default_len][PLATFORM_MAX_PATH];
// 
// int  g_map_rotation_len = 0;
// 
// //// voting
// 
// bool g_skip_campaing_votes[MAXPLAYERS + 1] = {false}; // I think we're adding 1 for the server console
// 
// #define g_skip_campaing_votes_len (MAXPLAYERS + 1)

//// "private" functions

// void skip_chapter_reset_votes()
// {
//     for(int vote_idx; vote_idx < g_skip_campaing_votes_len; ++vote_idx){
//         g_skip_campaing_votes[vote_idx] = false;
//     }
// }

// void skip_chapter_change_map(int active_rotation_map_index)
// {
//     // no need to worry about invalid indexes
//     // if that happens sourcemod is going to catch that at runtime (prevent server crash)
// 
//     // print loading message, must delay or it wont work with OnPZEndGamePanelMsg
//     CreateTimer(0.1, skip_chapter_timer_print_change_map_message, active_rotation_map_index);
// 
//     // delayed call to change the map
//     CreateTimer(g_fWaitTimeBeforeSwitch[g_iGameMode], skip_chapter_timer_change_map, active_rotation_map_index);
// }

// Action skip_chapter_timer_print_change_map_message(Handle timer, int active_rotation_map_index)
// {
//     PrintToServer("\n\n[CS] Loading %s\n\n", g_map_rotation[active_rotation_map_index]);
//     PrintToChatAll("\x03[CS]\x05 Loading \x04%s", g_map_rotation[active_rotation_map_index]);
//     return Plugin_Stop;
// }
// 
// Action skip_chapter_timer_change_map(Handle timer, int active_rotation_map_index)
// {
//     ServerCommand("changelevel %s", g_map_rotation[active_rotation_map_index]);
//     return Plugin_Stop;
// }

//// "public" functions

// void skip_chapter_on_map_start(){
//     skip_chapter_reset_votes();
// }

// Action skip_chapter_on_client_vote(int clint_id, int args)
// {
//     if (g_bVotingEnabled == false)
//     {
//         PrintToChat(clint_id, "\x03[CS]\x05 Voting has been disabled on this server.");
//         return Plugin_Continue;
//     }
// 
//     if (clint_id < 1) {
//         PrintToServer("You cannot vote from the server console, use the in-game chat");
//         return Plugin_Continue;
//     }
// 
//     if (g_iGameMode != GAMEMODE_COOP) {
//         PrintToChat(clint_id, "\x03[CS]\x05 Skipping chapters is only available for Coop.");
//         return Plugin_Continue;
//     }
// 
//     char client_name[MAX_NAME_LENGTH];
//     if (!GetClientName(clint_id, client_name, sizeof(client_name)))
//     {
//         return Plugin_Continue;
//     }
// 
//     bool client_reverted_vote = g_skip_campaing_votes[clint_id];
//     g_skip_campaing_votes[clint_id] = !g_skip_campaing_votes[clint_id];
// 
//     int total_votes = 0;
//     for(int vote_idx; vote_idx < g_skip_campaing_votes_len; ++vote_idx){
//         if (g_skip_campaing_votes[vote_idx] ){
//             total_votes += 1;
//         }
//     }
// 
//     int total_players = get_active_players();
// 
//     if (client_reverted_vote) {
//         PrintToChatAll("\x03[CS]\x05 \x04%s\x05 has reverted their vote to skip this chapter (%d/%d)", client_name, total_votes, total_players);
//     } else {
//         PrintToChatAll("\x03[CS]\x05 \x04%s\x05 has voted to skip this chapter (%d/%d)", client_name, total_votes, total_players);
//     }
// 
//     if (total_votes < total_players) {
//         return Plugin_Continue;
//     }
// 
//     skip_chapter_reset_votes();
// 
//     //// determine next map
// 
//     char current_map[PLATFORM_MAX_PATH];
//     GetCurrentMap(current_map, sizeof(current_map));
// 
//     bool map_found = false;
//     int next_map_idx = 0;
// 
//     for(int rotation_idx=0; rotation_idx<g_map_rotation_len; ++rotation_idx){
//         #define rotation_map (g_map_rotation[rotation_idx])
// 
//         if (StrEqual(current_map, rotation_map)) {
//             map_found = true;
//             next_map_idx = (rotation_idx + 1) % g_map_rotation_len;
//             break;
//         }
// 
//         #undef rotation_map
//     }
// 
//     if (!map_found) {
//         PrintToChatAll("\x03[CS]\x05 current map not found in the active rotation, cannot determine next map");
//         return Plugin_Continue;
//     }
// 
//     //// change map
// 
//     skip_chapter_change_map(next_map_idx);
// 
//     return Plugin_Continue;
// }

// void skip_chapter_on_before_client_disconnect(int client_id)
// {
//     g_skip_campaing_votes[client_id] = false;
// }
