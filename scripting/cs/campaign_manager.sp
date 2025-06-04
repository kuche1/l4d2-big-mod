
#include "campaign_manager/defaultdb.sp"
#include "campaign_manager/map.sp"
#include "campaign_manager/campaign.sp"
#include "campaign_manager/campaign_manager.sp"

#include "campaign_manager/skip_chapter.sp"
#include "campaign_manager/change_map.sp"

CampaignManager campaign_manager;

void campaign_manager_FNC_init(){
    //// init manager

    campaign_manager.init();

    //// init votes

    campaign_manager_FNC_reset_skip_chapter_votes();

    //// load campaigns from db

    for(int defaultdb_idx=0; defaultdb_idx<campaign_manager_DEFAULTDB_maps_len; ++defaultdb_idx){
        if(str_is_whitespace(campaign_manager_DEFAULTDB_maps[defaultdb_idx])){
            //// empty
            continue;
        }

        // if(str_startswith(campaign_manager_DEFAULTDB_maps[defaultdb_idx], "#")){
        if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '#'){
            //// comment
            continue;
        }

        //if(str_startswith(campaign_manager_DEFAULTDB_maps[defaultdb_idx], "@")){
        if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '@'){
            //// map

            //// name

            Campaign campaign;
            campaign.init(campaign_manager_DEFAULTDB_maps[defaultdb_idx][1]);

            //// chapters

            for(;;){
                defaultdb_idx += 1;
                if(defaultdb_idx >= campaign_manager_DEFAULTDB_maps_len){
                    break;
                }

                if(str_is_whitespace(campaign_manager_DEFAULTDB_maps[defaultdb_idx])){
                    continue;
                }

                if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '#'){
                    continue;
                }

                if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '@'){
                    defaultdb_idx -= 1;
                    break;
                }

                bool skip_first_character = false;
                bool is_survival_map = false;

                if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '$'){
                    // PrintToServer("[CS] dbg: survival map found: %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);
                    skip_first_character = true;
                    is_survival_map = true;
                }

                int map_sart_idx = 0;
                if(skip_first_character){
                    map_sart_idx = 1; // skip first character
                }

                char _map_fuzzyfind[MAPNAME_SIZE];
                if (FindMap(campaign_manager_DEFAULTDB_maps[defaultdb_idx][map_sart_idx], _map_fuzzyfind, sizeof(_map_fuzzyfind)) == FindMap_Found){

                    PrintToServer("[CS] map checked -> %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx][map_sart_idx]);

                    Map map;
                    map.init(campaign_manager_DEFAULTDB_maps[defaultdb_idx][map_sart_idx]);

                    if(is_survival_map){
                        if(campaign.add_survival(map)){
                            PrintToServer("[CS] could not add map (too many maps?)");
                        }
                    }else{
                        if(campaign.add_chapter(map)){
                            PrintToServer("[CS] could not add map (too many maps?)");
                        }
                    }

                }else{

                    PrintToServer("[CS] map missing -> %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx][map_sart_idx]);

                }
            }

            if(campaign.no_maps()){
                PrintToServer("[CS] no maps in campaign, rejecting -> %s", campaign.get_name());
                continue;
            }

            // save campaign

            campaign_manager.add_campaign(campaign);

            PrintToServer("[CS] campaign added -> %s", campaign.get_name());

            // continue

            continue
        }

        PrintToServer("[CS] unexpected item: %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);
    }

    //// init commands

    RegConsoleCmd("skipchapter", campaign_manager_ON_skip_chapter_vote);
    RegConsoleCmd("printcampaigns", campaign_manager_ACTION_print_campaigns);
}

Action campaign_manager_ACTION_print_campaigns(int client_id, int args)
{
    Campaign campaign;
    for(int campaign_idx=0; campaign_manager.loop_campaigns(campaign_idx, campaign); ++campaign_idx){

        PrintToChatAll("[CS] test: Campaign: %s", campaign.get_name());

        Map map;

        for(int chapter_idx=0; campaign.loop_chapters(chapter_idx, map); ++chapter_idx){
            PrintToChatAll("[CS] test: Chapter: %s", map.get_name());
        }

        for(int survival_idx=0; campaign.loop_survivals(survival_idx, map); ++survival_idx){
            PrintToChatAll("[CS] test: Survival: %s", map.get_name());
        }

    }

    return Plugin_Continue;
}

void campaign_manager_FNC_skip_chapter(){
    char current_map[MAPNAME_SIZE];
    GetCurrentMap(current_map, sizeof(current_map));

    Campaign campaign;
    for(int campaign_idx=0; campaign_manager.loop_campaigns(campaign_idx, campaign); ++campaign_idx){

        Map chapter;
        for(int chapter_idx=0; campaign.loop_chapters(chapter_idx, chapter); ++chapter_idx){

            if(StrEqual(current_map, chapter.get_name())){

                Map next_chapter;
                if(campaign.get_chapter(chapter_idx + 1, next_chapter)){

                    // TODO instead of just switching to the next map, cast a vote

                    Campaign next_campaign;
                    campaign_manager.get_campaign_wrapping(campaign_idx + 1, next_campaign);

                    Map next_campaign_chapter;
                    if(next_campaign.get_chapter(0, next_campaign_chapter)){
                        PrintToChatAll("\x03[CS]\x05 ERROR: could not get first chapter of next campaign (%s)", next_campaign.get_name());
                        return;
                    }

                    campaign_manager_FNC_change_map(next_campaign_chapter.get_name());

                    return;
                }

                campaign_manager_FNC_change_map(next_chapter.get_name());
                return;

            }

        }

    }

    PrintToChatAll("\x03[CS]\x05 Current map not in the active rotation, cannot determine next map, you can change the campaign with !changecampaign");
}
