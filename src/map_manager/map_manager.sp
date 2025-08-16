
#include "map.sp"
#include "campaign.sp"

void map_manager__init(){
    // note: this fuzzy find trick does not work on orange box games with workshop maps
    // https://sm.alliedmods.net/new-api/halflife/FindMap
    char fuzzy_search_map_found[MAP_NAME_MAX_SIZE];
    FindMapResult find_type = FindMap("a", fuzzy_search_map_found, sizeof(fuzzy_search_map_found));
    PrintToServer("%s resulttype:%d", PREFIX, find_type);
    
    switch(find_type){
        case FindMap_Found: {
            PrintToServer("%s !found!", PREFIX, fuzzy_search_map_found);
        }
        case FindMap_NotFound: {

        }
        case FindMap_FuzzyMatch: {
            PrintToServer("%s fuzzy found: %s", PREFIX, fuzzy_search_map_found);
        }
    }
}
