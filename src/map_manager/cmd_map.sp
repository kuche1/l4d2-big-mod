
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

    // TODO
    // if(map_manager__mapchange_votes[client]){
    //     return Plugin_Handled;
    // }

    map_manager__mapchange_votes[client] = true; // TODO: reset the votes on map change AND on client disconnect
    int votes = map_manager__mapchange_count_votes();

    PrintToChat(client, "%d client %d has voted to change the map; votes=%d", PREFIX, client, votes);
    // TODO: print the name rather than the id

    // TODO: everything below this line is untested
    // also, the error codes need to be checked

    // Create the menu
    Menu menu = CreateMenu(map_manager__cmd_map__menu_handler);

    // Give the player the option of not choosing a map
    // AddMenuItem(menu, "option1", "I Don't Care");

    SetMenuTitle(menu, "Select next map"); // TODO: do we need the new line ?

    AddMenuItem(menu, "1", "Skip Chapter");
    AddMenuItem(menu, "2", "Change Campaign");
    AddMenuItem(menu, "2", "Change Gamemode");

    SetMenuExitButton(menu, false);
    // if I set this to `true`, the button is grayed out and does nothing
    // if set to `false`, the button is not present

    DisplayMenu(menu, client, MENU_TIME_FOREVER);

    // EmitSoundToClient(client, SOUND_NEW_VOTE_START);

    return Plugin_Handled;
}

public int map_manager__cmd_map__menu_handler(Menu menu, MenuAction action, int client, int item)
{
    if (action == MenuAction_End){
        delete menu;
    }else if (action == MenuAction_Select){

        PrintToChat(client, "%d dbg: client %d has voted for %d", PREFIX, client, item);

        // g_bClientVoted[iClient] = true;

        // // Set the players current vote
        // if (iItemNum == 0)
        //     g_iClientVote[iClient] = -1;
        // else
        //     g_iClientVote[iClient] = g_iMapsIndexStartForCurrentGameMode + iItemNum - 1;

        // // Check to see if theres a new winner to the vote
        // SetTheCurrentVoteWinner();

        // // Display the appropriate message to the voter
        // if (iItemNum == 0)
        //     PrintHintText(iClient, "You did not vote.\nTo vote, type: !changecampaign");
        // else
        //     PrintHintText(iClient,
        //                   "You voted for %s.\n- To change your vote, type: !changecampaign\n- To see all the votes, type: !campaignvotes",
        //                   g_strMapListArray[g_iMapsIndexStartForCurrentGameMode + iItemNum - 1][MAP_LIST_COLUMN_MAP_DESCRIPTION]);
    }
}
