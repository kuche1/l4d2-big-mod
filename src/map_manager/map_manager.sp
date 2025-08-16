
#include "map.sp"
#include "campaign.sp"

enum struct MapManager{
    Campaign campaigns[MAX_CAMPAIGNS];
}

void map_manager__init(){
    Campaign campaign;
    // IMPROVE: do not hardcode the campaigns like that

    campaign.init("No Mercy");
    campaign.add_chapter("c8m1_apartment");
    campaign.add_chapter("c8m2_subway");
    campaign.add_chapter("c8m3_sewers");
    campaign.add_chapter("c8m4_interior");
    campaign.add_chapter("c8m5_rooftop");
    // campaign.add_survival("c8m2_subway"); // TODO
}
