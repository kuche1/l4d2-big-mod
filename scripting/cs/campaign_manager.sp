
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

    //// init commands

    RegConsoleCmd("skipchapter", campaign_manager_ON_skip_chapter_vote);
    RegConsoleCmd("printcampaigns", campaign_manager_ACTION_print_campaigns);
}

Action campaign_manager_ACTION_print_campaigns(int client_id, int args)
{
    Campaign campaign;
    for(int campaign_idx=0; campaign_manager.loop_campaigns(campaign_idx, campaign); ++campaign_idx){

        PrintToChatAll("[CS] Campaign: %s", campaign.get_name());

        Map map;

        for(int chapter_idx=0; campaign.loop_chapters(chapter_idx, map); ++chapter_idx){
            PrintToChatAll("[CS] Chapter: %s", map.get_name());
        }

        for(int survival_idx=0; campaign.loop_survivals(survival_idx, map); ++survival_idx){
            PrintToChatAll("[CS] Survival: %s", map.get_name());
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
