
#include "map.sp"
#include "campaign.sp"

enum struct MapManager{
    Campaign campaigns[MAX_CAMPAIGNS];
    int campaigns_len;

    void init(){
        //////////
        ////////// init fields
        //////////

        this.campaigns_len = 0;

        //////////
        ////////// add campaigns
        //////////

        Campaign campaign;
        // IMPROVE: do not hardcode the campaigns like that

        campaign.init("No Mercy");
        campaign.add_chapter("c8m1_apartment");
        campaign.add_chapter("c8m2_subway");
        campaign.add_chapter("c8m3_sewers");
        campaign.add_chapter("c8m4_interior");
        campaign.add_chapter("c8m5_rooftop");
        campaign.add_survival("c8m2_subway");
        this.add(campaign);
    }

    void add(Campaign campaign){
        if (this.campaigns_len >= sizeof(this.campaigns)){
            PrintToServer("%s ERROR: not enough memory to add campaign: %s", PREFIX, campaign.get_name());
            return;
        }

        if(!campaign.has_any_maps()){
            return;
        }

        this.campaigns[this.campaigns_len] = campaign;
        this.campaigns_len += 1;

        PrintToServer("%s added campaign: %s", PREFIX, campaign.get_name());
    }
}

MapManager map_manager;
