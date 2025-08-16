
bool map_manager__mapchange_votes[MAXPLAYERS + 1];

int map_manager__mapchange_count_votes(){
    int votes = 0;

    for(int i=0; i<sizeof(map_manager__mapchange_votes); ++i){
        if(map_manager__mapchange_votes[i]){
            votes += 1;
        }
    }

    return votes;
}

Action map_manager__cmd_map(int client, int args)
{
    // TODO: and what if the server decides to vote ?
    // TODO: or an invalid client ?

    if(map_manager__mapchange_votes[client]){
        return Plugin_Handled;
    }

    map_manager__mapchange_votes[client] = true; // TODO: reset the votes on map change AND on client disconnect
    int votes = map_manager__mapchange_count_votes();

    PrintToChat(client, "client %d has voted to change the map; votes=%d", client, votes);
    // TODO: print the name rather than the id

    return Plugin_Handled; // otherwise we would get "unknown command"
}
