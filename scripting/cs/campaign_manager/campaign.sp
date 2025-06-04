
enum struct Campaign{
    char name[MAPNAME_SIZE];

    Map chapters[SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE];
    int chapters_cap;
    int chapters_len;

    Map survivals[SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE];
    int survivals_cap;
    int survivals_len;

    //// init

    void init(char name[MAPNAME_SIZE]){
        this.name = name;

        this.chapters_cap = SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE;
        this.chapters_len = 0;

        this.survivals_cap = SETTING_MAX_MAPS_PER_CAMPAIGN_GAMEMODE;
        this.survivals_len = 0;
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

    // return `true` on failure
    bool add_survival(Map map){
        if(this.survivals_len >= this.survivals_cap){
            return true;
        }

        this.survivals[this.survivals_len] = map;
        this.survivals_len += 1;

        return false;
    }

    //// get

    char[] get_name(){
        return this.name;
    }

    // return `true` on failure
    bool get_chapter(int index, Map ret_chapter){
        // PrintToChatAll("\x03[CS]\x05 dbg: index=%d this.chapters_len=%d", index, this.chapters_len);

        if(index >= this.chapters_len){
            return true;
        }

        ret_chapter = this.chapters[index];

        return false;
    }

    //// loop

    // return `false` on failure
    bool loop_chapters(int index, Map ret_chapter){
        if(index >= this.chapters_len){
            return false;
        }

        ret_chapter = this.chapters[index];

        return true;
    }

    // return `false` on failure
    bool loop_survivals(int index, Map ret_map){
        if(index >= this.survivals_len){
            return false;
        }

        ret_map = this.survivals[index];

        return true;
    }

    ////

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
}
