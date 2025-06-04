
void campaign_manager_FNC_change_map(char[] mapname){
    // PrintToChatAll("\x03[CS]\x05 dbg: trying to load \x04%s", mapname);

    // int len = strlen(mapname)+1;
    // char[] dynmem_mapname = new char[len];
    // strcopy(dynmem_mapname, len, mapname);

    DataPack pack0 = new DataPack();
    pack0.WriteString(mapname);
    // pack.WriteCell(1);
    // pack.WriteCell(2);
    // pack.WriteCell(3);

    DataPack pack1 = new DataPack();
    pack1.WriteString(mapname);

    // print loading message, must delay or it wont work with OnPZEndGamePanelMsg
    CreateTimer(0.1, campaign_manager_ACTION_print_change_map_message, pack0);

    // delayed call to change the map
    CreateTimer(SETTING_DELAY_BEFORE_SWITCHING_MAP, campaign_manager_ACTION_change_map, pack1);
}

Action campaign_manager_ACTION_print_change_map_message(Handle timer, DataPack pack)
{
    pack.Reset(); // reset read position
    char mapname[MAPNAME_SIZE];
    pack.ReadString(mapname, sizeof(mapname));
    delete pack;

    // pack.Reset();
    // int a = pack.ReadCell();
    // int b = pack.ReadCell();
    // int c = pack.ReadCell();
    // PrintToChatAll("\x03[CS]\x05 test: a=%d b=%d c=%d", a, b, c);

    PrintToServer("\n\n[CS] Loading %s\n\n", mapname);
    PrintToChatAll("\x03[CS]\x05 Loading \x04%s", mapname);

    return Plugin_Stop;
}

Action campaign_manager_ACTION_change_map(Handle timer, DataPack pack)
{
    pack.Reset();
    char mapname[MAPNAME_SIZE];
    pack.ReadString(mapname, sizeof(mapname));
    delete pack;

    ServerCommand("changelevel %s", mapname);

    return Plugin_Stop;
}
