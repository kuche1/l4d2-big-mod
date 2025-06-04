
#include "campaign_manager/skip_chapter.sp"
#include "campaign_manager/change_map.sp"

//// campaign stuff

char campaign_manager_DEFAULTDB_maps[][MAPNAME_SIZE] = {
    "# Lines starting with \"#\" get ignored, as so do empty lines",
    "# Lines starting with \"@\" mark a campaign name",
    "# Lines starting with \"$\" mark a survival map (TODO UNFINISHED)",
    "# If any of the maps are missing, they will be ignored",
    "",
    "# Official: L4D1",
    "",
    "@No Mercy", "c8m1_apartment", "c8m2_subway", "c8m3_sewers", "c8m4_interior", "c8m5_rooftop", "$c8m2_subway",
    "@Crash Course", "c9m1_alleys", "c9m2_lots",
    "@Death Toll", "c10m1_caves", "c10m2_drainage", "c10m3_ranchhouse", "c10m4_mainstreet", "c10m5_houseboat",
    "@Dead Air", "c11m1_greenhouse", "c11m2_offices", "c11m3_garage", "c11m4_terminal", "c11m5_runway",
    "@Blood Harvest", "c12m1_hilltop", "c12m2_traintunnel", "c12m3_bridge", "c12m4_barn", "c12m5_cornfield",
    "@The Sacrifice", "c7m1_docks", "c7m2_barge", "c7m3_port",
    "@The Last Stand", "c14m1_junkyard", "c14m2_lighthouse",
    "",
    "# Official: L4D2",
    "",
    "@Dead Center", "c1m1_hotel", "c1m2_streets", "c1m3_mall", "c1m4_atrium",
    "@The Passing", "c6m1_riverbank", "c6m2_bedlam", "c6m3_port",
    "@Dark Carnival", "c2m1_highway", "c2m2_fairgrounds", "c2m3_coaster", "c2m4_barns", "c2m5_concert",
    "@Swamp Fever", "c3m1_plankcountry", "c3m2_swamp", "c3m3_shantytown", "c3m4_plantation",
    "@Hard Rain", "c4m1_milltown_a", "c4m2_sugarmill_a", "c4m3_sugarmill_b", "c4m4_milltown_b", "c4m5_milltown_escape",
    "@The Parish", "c5m1_waterfront", "c5m2_park", "c5m3_cemetery", "c5m4_quarter", "c5m5_bridge",
    "@Cold Stream", "c13m1_alpinecreek", "c13m2_southpinestream", "c13m3_memorialbridge", "c13m4_cutthroatcreek",
    "",
    "# Addon: Nightmare",
    "",
    "@[addon] No Mercy: Rehab", "nmrm1_apartment", "nmrm2_subway", "nmrm3_sewers", "nmrm4_hospital", "nmrm5_rooftop",
    "@[addon] Dark Center", "c1m1d_hotel", "c1m2d_streets", "c1m3d_mall", "c1m4d_atrium",
    "@[addon] Deadbeat Escape", "deadbeat01_forest", "deadbeat02_alley", "deadbeat03_street", "deadbeat04_park",
    "@[addon] The Dark Parish", "c5m1_darkwaterfront", "c5m2_darkpark", "c5m3_darkcemetery", "c5m4_darkquarter", "c5m5_darkbridge",
    "@[addon] Fairfield Terror", "ft_m1_apartments_08_a", "ft_m2_subway_08_a", "ft_m3_sewers_08_b", "ft_m4_hospital_08_a", "ft_m5_rooftop_08_a",
    "@[addon] Hopeless", "hopeless_m1", "hopeless_m2", "hopeless_m3",
};

#define campaign_manager_DEFAULTDB_maps_len (sizeof(campaign_manager_DEFAULTDB_maps))

CampaignManager campaign_manager;

//// other

enum struct Map{
    char name[MAPNAME_SIZE];

    void init(char name[MAPNAME_SIZE]){
        this.name = name;
    }

    char[] get_name(){
        return this.name;
    }
}

enum struct Campaign{
    char name[MAPNAME_SIZE];

    Map chapters[SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE];
    int chapters_cap;
    int chapters_len;

    void init(char name[MAPNAME_SIZE]){
        this.name = name;

        this.chapters_cap = SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE;
        this.chapters_len = 0;
    }

    // return `true` on failure
    bool add_chapter(Map chapter){
        if(this.chapters_len >= this.chapters_cap){
            return true;
        }

        this.chapters[this.chapters_len] = chapter;
        this.chapters_len += 1;

        return false;
    }

    char[] get_name(){
        return this.name;
    }

    bool no_maps(){
        return this.chapters_len <= 0;
    }

//     // return `true` if data was returned
//     bool iter_chapters(int &mem_idx, Chapter ret_chapter){ // "reference is redundant, enum struct types are array-like"
//         if(mem_idx >= this.chapters_len){
//             return false;
//         }
// 
//         ret_chapter = this.chapters[mem_idx];
//         mem_idx += 1;
// 
//         return true;
//     }

    // return `true` on failure
    bool get_chapter(int index, Map ret_chapter){
        // PrintToChatAll("\x03[CS]\x05 dbg: index=%d this.chapters_len=%d", index, this.chapters_len);

        if(index >= this.chapters_len){
            return true;
        }

        ret_chapter = this.chapters[index];

        return false;
    }

    // return `false` on failure
    bool loop_chapters(int index, Map ret_chapter){
        if(index >= this.chapters_len){
            return false;
        }

        ret_chapter = this.chapters[index];

        return true;
    }
}

enum struct CampaignManager{
    Campaign campaigns[SETTING_MAX_CAMPAIGNS];
    int campaigns_cap;
    int campaigns_len;

    void init(){
        this.campaigns_cap = SETTING_MAX_CAMPAIGNS;
        this.campaigns_len = 0;
    }

    // return `true` on failure
    bool add_campaign(Campaign campaign){
        if(this.campaigns_len >= this.campaigns_cap){
            return true;
        }

        this.campaigns[this.campaigns_len] = campaign;
        this.campaigns_len += 1;

        return false;
    }

//     // return `true` if data was returned
//     bool iter_campaigns(int &mem_idx, Campaign ret_campaign){
//         if(mem_idx >= this.campaigns_len){
//             return false;
//         }
// 
//         ret_campaign = this.campaigns[mem_idx];
//         mem_idx += 1;
// 
//         return true;
//     }

    // return `true` on failure
    bool get_campaign_wrapping(int index, Campaign ret_campaign){
        if(this.campaigns_len <= 0){
            return true;
        }

        index %= this.campaigns_len;

        ret_campaign = this.campaigns[index];

        return false;
    }

    // return `false` on failure
    bool loop_campaigns(int index, Campaign ret_campaign){
        if(index >= this.campaigns_len){
            return false;
        }

        ret_campaign = this.campaigns[index];

        return true;
    }
}

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

                bool is_survival_map = false;

                if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '$'){
                    is_survival_map = true;
                    // TODO remove that character
                    // then increase `num_survival_maps`
                    break;
                }

                char _map_fuzzyfind[MAPNAME_SIZE];
                if (FindMap(campaign_manager_DEFAULTDB_maps[defaultdb_idx], _map_fuzzyfind, sizeof(_map_fuzzyfind)) == FindMap_Found){

                    PrintToServer("[CS] map checked -> %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);

                    Map chapter;
                    chapter.init(campaign_manager_DEFAULTDB_maps[defaultdb_idx]);

                    if(campaign.add_chapter(chapter)){
                        PrintToServer("[CS] could not add map (too many maps?)");
                    }

                }else{

                    PrintToServer("[CS] map missing -> %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);

                    if(!is_survival_map){
                        // reject_campaign = true;
                    }

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

        Map chapter;
        for(int chapter_idx=0; campaign.loop_chapters(chapter_idx, chapter); ++chapter_idx){

            PrintToChatAll("[CS] test: Chapter: %s", chapter.get_name());

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
