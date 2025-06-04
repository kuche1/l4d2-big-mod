
enum struct CampaignManager{
    Campaign campaigns[SETTING_MAX_CAMPAIGNS];
    int campaigns_cap;
    int campaigns_len;

    //// init

    // would love to pass the defaultdb but spurcepawn is a little bitch
    void init(){
        this.campaigns_cap = SETTING_MAX_CAMPAIGNS;
        this.campaigns_len = 0;

        ////

        for(int defaultdb_idx=0; defaultdb_idx<campaign_manager_DEFAULTDB_maps_len; ++defaultdb_idx){
            if(str_is_whitespace(campaign_manager_DEFAULTDB_maps[defaultdb_idx])){
                //// empty
                continue;
            }

            if(campaign_manager_DEFAULTDB_maps[defaultdb_idx][0] == '#'){
                //// comment
                continue;
            }

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

                if(this.add_campaign(campaign)){
                    PrintToServer("[CS] could not add campaign (too many campaigns?)");
                }else{
                    PrintToServer("[CS] campaign added -> %s", campaign.get_name());
                }

                // continue

                continue
            }

            PrintToServer("[CS] unexpected item: %s", campaign_manager_DEFAULTDB_maps[defaultdb_idx]);
        }
    }

    ////

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
