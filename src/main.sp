
#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#include "settings.sp"
#include "map_manager/map_manager.sp"

public Plugin myinfo =
{
    name        = "Big Mod",
    author      = "kuche1",
    description = "Big Mod",
    version     = "v0.0-dev0",
    url         = "https://github.com/kuche1/l4d2-big-mod",
}

public void OnPluginStart()
{
    // map_manager__init();
    map_manager.init();
}
