
char campaign_manager_DEFAULTDB_maps[][PLATFORM_MAX_PATH] = {
    "# If any of the maps are missing, they will simply not be added to the vote",
    "",
    "# Official: L4D1",
    "",
    "@No Mercy", "c8m1_apartment", "c8m2_subway", "c8m3_sewers", "c8m4_interior", "c8m5_rooftop",
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
    "# Custom: Nightmare",
    "",
    "@No Mercy: Rehab", "nmrm1_apartment", "nmrm2_subway", "nmrm3_sewers", "nmrm4_hospital", "nmrm5_rooftop",
    "@Dark Center", "c1m1d_hotel", "c1m2d_streets", "c1m3d_mall", "c1m4d_atrium",
    "@Deadbeat Escape", "deadbeat01_forest", "deadbeat02_alley", "deadbeat03_street", "deadbeat04_park",
    "@The Dark Parish", "c5m1_darkwaterfront", "c5m2_darkpark", "c5m3_darkcemetery", "c5m4_darkquarter", "c5m5_darkbridge",
    "@Fairfield Terror", "ft_m1_apartments_08_a", "ft_m2_subway_08_a", "ft_m3_sewers_08_b", "ft_m4_hospital_08_a", "ft_m5_rooftop_08_a",
    "@Hopeless", "hopeless_m1", "hopeless_m2", "hopeless_m3",
};

#define campaign_manager_DEFAULTDB_maps_len (sizeof(campaign_manager_DEFAULTDB_maps))

char campaign_manager_MEM[campaign_manager_DEFAULTDB_maps_len][PLATFORM_MAX_PATH];
int campaign_manager_MEM_len = 0;

Campaign campaign_manager_DB_campaigns[campaign_manager_DEFAULTDB_maps_len];
int campaign_manager_DB_campaigns_len = 0

enum struct Campaign{
    int ptr_name;
    int ptr_chapters;
    int num_chapters;

    void init(int ptr_name, int ptr_chapters, int num_chapters){
        this.ptr_name = ptr_name;
        this.ptr_chapters = ptr_chapters;
        this.num_chapters = num_chapters;
    }

    char[] get_name(){
        return campaign_manager_MEM[this.ptr_name];
    }

    int get_num_chapters(){
        return this.num_chapters;
    }

    int get_ptr_chapters(){
        return this.ptr_chapters;
    }
}

void campaign_manager_FNC_init(){
    //// load campaigns from db

    campaign_manager_MEM_len = 0;

    for(int defaultdb_idx=0; defaultdb_idx<campaign_manager_DEFAULTDB_maps_len; ++defaultdb_idx){
        if(str_is_whitespace(campaign_manager_DEFAULTDB_maps[defaultdb_idx])){
            // empty
            continue;
        }

        // if(str_startswith(campaign_manager_DEFAULTDB_maps[defaultdb_idx], "#")){
        if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '#'){
            // comment
            continue;
        }

        //if(str_startswith(campaign_manager_DEFAULTDB_maps[defaultdb_idx], "@")){
        if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '@'){
            // map

            // name

            strcopy(
                campaign_manager_MEM[campaign_manager_MEM_len],
                PLATFORM_MAX_PATH,
                campaign_manager_DEFAULTDB_maps[defaultdb_idx][1]
            );

            int ptr_name = campaign_manager_MEM_len;

            campaign_manager_MEM_len += 1;

            // chapters

            int ptr_chapters = campaign_manager_MEM_len;

            int num_chapters = 0;
            bool reject_campaign = false;

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

                char _map_fuzzyfind[PLATFORM_MAX_PATH];
                if (FindMap(campaign_manager_DEFAULTDB_maps[defaultdb_idx], _map_fuzzyfind, sizeof(_map_fuzzyfind)) == FindMap_Found){

                    PrintToServer("[CS] map checked -> %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);

                    campaign_manager_MEM[campaign_manager_MEM_len] = campaign_manager_DEFAULTDB_maps[defaultdb_idx];
                    campaign_manager_MEM_len += 1;

                    num_chapters += 1;

                }else{

                    PrintToServer("[CS] map missing -> %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);

                    reject_campaign = true;

                }
            }

            if(num_chapters <= 0){
                reject_campaign = true;
            }

            if(reject_campaign){
                PrintToServer("[CS] campaign rejected -> %s", campaign_manager_MEM[ptr_name]);
                continue;
            }

            // init

            Campaign campaign;
            campaign.init(
                ptr_name,
                ptr_chapters,
                num_chapters
            );

            campaign_manager_DB_campaigns[campaign_manager_DB_campaigns_len] = campaign;
            campaign_manager_DB_campaigns_len += 1;

            PrintToServer("[CS] campaign added -> %s", campaign_manager_MEM[ptr_name]);

            // continue

            continue
        }

        PrintToServer("[CS] ERROR: unreachable code reached (A)");
    }

    //// init command

    RegConsoleCmd("printcampaigns", campaign_manager_ACTION_print_campaigns);
}

void campaign_manager_FNC_print_campaigns(){
    for(int campaign_idx=0; campaign_idx<campaign_manager_DB_campaigns_len; ++campaign_idx){
        #define campaign (campaign_manager_DB_campaigns[campaign_idx])

        int ptr_chapters = campaign.get_ptr_chapters();
        int num_chapters = campaign.get_num_chapters();

        PrintToChatAll("[CS] test: Campaign: %s", campaign.get_name());

        for(int chapter_idx=0; chapter_idx<num_chapters; ++chapter_idx){
            int ptr_chapter = ptr_chapters + chapter_idx;
            PrintToChatAll("[CS] test: Chapter: %s", campaign_manager_MEM[ptr_chapter]);
        }

        #undef campaign
    }
}

Action campaign_manager_ACTION_print_campaigns(int client_id, int args)
{
    campaign_manager_FNC_print_campaigns();
    return Plugin_Continue;
}
