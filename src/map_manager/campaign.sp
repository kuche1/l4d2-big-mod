
enum struct Campaign{
    char name[CAMPAIGN_NAME_MAX_SIZE];

    bool maps_campaign_error;
    Map maps_campaign[CAMPAIGN_MAX_MAPS_CAMPAIGN];
    int maps_campaign_len;

    Map maps_survival[CAMPAIGN_MAX_MAPS_SURVIVAL];

    void init(char name[CAMPAIGN_NAME_MAX_SIZE]){
        this.name = name;

        this.maps_campaign_error = false;
        this.maps_campaign_len = 0;
    }

    void add_chapter(char mapname[MAP_NAME_MAX_SIZE]){
        // TODO: see if we can make this work using sizeof
        if (this.maps_campaign_len >= CAMPAIGN_MAX_MAPS_CAMPAIGN){
            PrintToServer("%s ERROR: not enough memory to add chapter: %s", PREFIX, mapname);
            this.maps_campaign_error = true;
            return;
        }

        Map map;
        if(map.init(mapname)){
            this.maps_campaign_error = true;
            return;
        }

        this.maps_campaign[this.maps_campaign_len] = map;
        this.maps_campaign_len += 1;

        PrintToServer("%s dbg: added map: %s", PREFIX, mapname);
    }
}
