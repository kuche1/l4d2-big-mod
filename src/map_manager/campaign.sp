
enum struct Campaign{
    char name[CAMPAIGN_NAME_MAX_SIZE];

    bool maps_campaign_error;
    Map maps_campaign[CAMPAIGN_MAX_MAPS_CAMPAIGN];
    int maps_campaign_len;

    Map maps_survival[CAMPAIGN_MAX_MAPS_SURVIVAL];
    int maps_survival_len;

    //////////
    ////////// initialisation
    //////////

    void init(char name[CAMPAIGN_NAME_MAX_SIZE]){
        this.name = name;

        this.maps_campaign_error = false;
        this.maps_campaign_len = 0;

        this.maps_survival_len = 0;
    }

    void add_chapter(char mapname[MAP_NAME_MAX_SIZE]){
        // it seems that in sourcepawn `sizeof` gives the capacity rather than the size
        if (this.maps_campaign_len >= sizeof(this.maps_campaign)){
            PrintToServer("%s ERROR: not enough memory to add campaign map: %s", PREFIX, mapname);
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

        PrintToServer("%s added campaign map: %s", PREFIX, mapname);
    }

    void add_survival(char mapname[MAP_NAME_MAX_SIZE]){
        if (this.maps_survival_len >= sizeof(this.maps_survival)){
            PrintToServer("%s ERROR: not enough memory to add survival map: %s", PREFIX, mapname);
            return;
        }

        Map map;
        if(map.init(mapname)){
            this.maps_campaign_error = true;
            return;
        }

        PrintToServer("%s added survival map: %s", PREFIX, mapname);
    }

    //////////
    ////////// ...
    //////////

    bool has_any_maps(){
        bool has_campaign_maps = this.maps_campaign_error ? (false) : (this.maps_campaign_len > 0);
        bool has_survival_maps = (this.maps_survival_len > 0);
        return has_campaign_maps || has_survival_maps;
    }

    char[] get_name(){
        return this.name;
    }
}
