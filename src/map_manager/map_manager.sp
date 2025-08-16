
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

        campaign.init("Crash Course");
        campaign.add_chapter("c9m1_alleys");
        campaign.add_chapter("c9m2_lots");
        campaign.add_survival("c9m1_alleys");
        campaign.add_survival("c9m2_lots");
        this.add(campaign);

        // TODO
        //"@Death Toll", "c10m1_caves", "c10m2_drainage", "c10m3_ranchhouse", "c10m4_mainstreet", "c10m5_houseboat",

        // TODO
        // the rest of the official maps + some community maps

        //////////
        ////////// chat/console commands
        //////////

        RegConsoleCmd("bm-dbg", map_manager__cmd_dbg);
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

Action map_manager__cmd_dbg(int client, int args)
{
    ReplyToCommand(client, "hello");
    // we could use PrintToChat or the print to console alternative, but
    // this way we automaticaclly print to wherever the command was called from

    return Plugin_Handled; // otherwise we would get "unknown command"
}
