
// Campaign Switcher

// Based On:
//// Automatic Campaign Switcher for L4D2
//// Version 2.0.0 (Nov 14, 2021)
//// By Chris Pringle

#define PLUGIN_VERSION "v3.0.0"

#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#include "ACS/settings.sp"

#include "ACS/GlobalVariables.sp"
#include "ACS/MapNames.sp"
#include "ACS/Advertising.sp"
#include "ACS/ChangeMap.sp"
#include "ACS/ConsoleCommands.sp"
#include "ACS/CVars.sp"
#include "ACS/Events.sp"
#include "ACS/FileIO.sp"
#include "ACS/UtilityFunctions.sp"
#include "ACS/VoteSystem.sp"

/*======================================================================================
#####################             P L U G I N   I N F O             ####################
======================================================================================*/
public Plugin myinfo =
{
    name        = "Campaign Switcher",
    author      = "kuche1",
    description = "Allows for voting for campaigns",
    version     = PLUGIN_VERSION,
    url         = "https://github.com/kuche1/l4d2-campaign-swtcher"


}

public void
    OnPluginStart()
{
    // Create the map list file if there its not there already
    CreateNewMapListFileIfDoesNotExist();

    // Get the strings for all of the maps that are in rotation for every game mode
    SetupMapListArrayFromFile();

    // Set up all the ACS specific configurable variables
    SetUpCVars();

    // Hook all the events ACS needs
    SetUpEvents();

    // Set up the player input command listeners
    SetupConsoleCommands();

    // Repeating Timers
    // CreateTimer(g_fNextMapAdInterval, Timer_AdvertiseNextMap, _, TIMER_REPEAT);
}
