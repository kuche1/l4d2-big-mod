
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
