
void campaign_manager_FNC_change_map(char[] mapname){
    // print loading message, must delay or it wont work with OnPZEndGamePanelMsg
    CreateTimer(0.1, campaign_manager_ACTION_print_change_map_message, mapname);

    // delayed call to change the map
    CreateTimer(g_fWaitTimeBeforeSwitch[g_iGameMode], campaign_manager_ACTION_change_map, mapname);
}

Action campaign_manager_ACTION_print_change_map_message(Handle timer, char[] mapname)
{
    PrintToServer("\n\n[CS] Loading %s\n\n", mapname);
    PrintToChatAll("\x03[CS]\x05 Loading \x04%s", mapname);
    return Plugin_Stop;
}

Action campaign_manager_ACTION_change_map(Handle timer, char[] mapname)
{
    ServerCommand("changelevel %s", mapname);
    return Plugin_Stop;
}
