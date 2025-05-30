# Campaign Switcher

## Change log

###### v3.0.0 (2025-05-30)

- Coop: Map voting is no longer limited to Finale maps
- Coop: Map change message will appear after N failures, instead of a forced map change
- Coop: Map will be changed after a failure if a vete had been taken

# Credits

Based on `https://github.com/Chris7c0/ACS`.

Original description:

# Automatic Campaign Switcher (ACS)

Automatic Campaign Switcher, or ACS, was created as an easily deployed solution to maintain a campaign/map rotation on a Left 4 Dead 2 server. This solves the problem of players returning to the lobby because the vote to restart a campaign was not passed. By default, ACS will cycle through maps in chronological order corresponding to the Left4Dead story timeline. However, this can easily be modified to run a different rotation, as well as to add custom campaigns/maps. ACS also includes a voting system in which people can vote for their favorite campaign/map if they wish to interrupt the current cycle. The winning campaign/map will become the next map the server loads once the current one has been completed.  I wrote ACS in such a way that is relatively easy to understand and edit for those who wish to modify the source for their needs.

The forum post corresponding to this page can be found on [AlliedMods.net](https://forums.alliedmods.net/showthread.php?t=156392)

## Installation

Simply drag the .smx file into your plugin folder. Your plugin folder will likely be something like this:

`C:\Program Files (x86)\Steam\steamapps\common\left 4 dead 2\left4dead2\addons\sourcemod\plugins\`

## Features of Automatic Campaign Switcher

- ACS is easy to install, there is no messing with text files, just plug and play.
- Automatically rotates campaigns/maps in the L4D story chronological order.
- Easily set up your own custom campaign rotation by editing a plain text config file.
- Voting System that allows players to vote for the next campaign/map.
- Supports every stock gamemode in L4D2:
  ```
  coop
  realism
  versus
  teamversus
  teamscavenge
  scavenge
  mutation 1-20
  community 1-5
  ```
- Supports dynamic gamemode switching.
  - In other words, ACS will still work if the server switches to another game mode without restarting or shutting down the server.
- You can limit the amount of failures during a Coop campaign finale map before ACS will switch to the next campaign.


## Player Commands

`!mapvote` - Allows any player to vote and revote for the next campaign to play \
`!mapvotes` - Displays to the player the current vote winner as well as all of the current votes


## Customizing ACS

### Custom Settings

If you want to disable the voting system or change other settings, then edit the cvars in the config file. This file will be located in a location similar to this:

`C:\Program Files (x86)\Steam\steamapps\common\left 4 dead 2\left4dead2\cfg\sourcemod\Automatic_Campaign _Switcher_vX.X.X.cfg`

##### Console Variables (CVars)

```
// Version of Automatic Campaign Switcher (ACS) on this server
acs_version

// Enables players to vote for the next map or campaign [0 = DISABLED, 1 = ENABLED]
acs_voting_system_enabled "1"

// Determines if a sound plays when a new map is winning the vote [0 = DISABLED, 1 = ENABLED]
acs_voting_sound_enabled "1"

// Sets how to advertise voting at the start of the map [0 = DISABLED, 1 = HINT TEXT, 2 = CHAT TEXT, 3 = OPEN VOTE MENU]
acs_voting_ad_mode "3"

// Time, in seconds, to wait after survivors leave the start area to advertise voting as defined in acs_voting_ad_mode
acs_voting_ad_delay_time "1.0"

// Sets how the next campaign/map is advertised during a finale or scavenge map [0 = DISABLED, 1 = HINT TEXT, 2 = CHAT TEXT]
acs_next_map_ad_mode "1"

// The time, in seconds, between advertisements for the next campaign/map on finales and scavenge maps
acs_next_map_ad_interval "600.0"

// The amount of times the survivors can fail a finale in Coop before it switches to the next campaign [0 = INFINITE FAILURES]
acs_max_coop_finale_failures "4"
```

### Custom Campaigns/Maps

If you choose to change the default map rotation or set up a custom maps, then edit `Campaign_Switcher_Map_List_<version>.txt` which can be found in a location similar to this:

`C:\Program Files (x86)\Steam\steamapps\common\left 4 dead 2\left4dead2\addons\sourcemod\configs\`

## Change Log

###### v2.0.0 (Nov 14, 2021)
  - Overhauled most the code, rewriting many functions to be more generic and reusable
  - Changed to a single map list array with indexes that adjust based on gamemode
  - Added a map list config file thats plain text and can be easily configured
    - This file can be edited to set up any custom map for any game mode with any order
    - Just run the plugin and this file will generate itself with the default maps 
      the first time ACS is ran.
  - Added Maps Listing in console output to help with configuring custom maps
  - Updated all the default maps for every stock game mode
  - Added hook for OnPZEndGamePanelMsg that intercepts and removes the vote at the 
    end of a campaign where it asks to play with the group again. This is also used
    as a better method for knowing its time to switch to next campaign.  This method
    works without the need for a separate signatures file. It works for all modes 
    except for Coop and Survival that will continue forever. These modes are handled
    through event hooks.
  - Added file modified detection for Map List Config that will update ACS on map change.
  - Fixed config file not loading changes
  - Converted everything to new syntax

###### v1.2.4 (Dec 31, 2020)
  - Added new maps for the Last Stand Update
  - Added precache of witch models to fix bug in The Passing campaign transition crash
  - Made map comparisons case insensitive
  - Fixed several infinite loop bugs when on the last campaign
  - Changed Timer_AdvertiseNextMap to not have TIMER_REPEAT and TIMER_FLAG_NO_MAPCHANGE together
  - Removed FCVAR_PLUGIN
  - Removed global menu handle
  - Added the code from [L4D/L4D2] Return To Lobby Fix from MasterMind420. Thank you!

###### v1.2.3 (Jan 8, 2012)
  - Added the new L4D2 campaigns

###### v1.2.2 (May 21, 2011)
  - Added message for new vote winner when a player disconnects
  - Fixed the sound to play to all the players in the game
  - Added a max amount of coop finale map failures cvar
  - Changed the wait time for voting ad from round_start to the 
    player_left_start_area event 
  - Added the voting sound when the vote menu pops up

###### v1.2.1 (May 18, 2011)
  - Fixed mutation 15 (Versus Survival)

###### v1.2.0 (May 16, 2011)
  - Changed some of the text to be more clear
  - Added timed notifications for the next map
  - Added a cvar for how to advertise the next map
  - Added a cvar for the next map advertisement interval
  - Added a sound to help notify players of a new vote winner
  - Added a cvar to enable/disable sound notification
  - Added a custom wait time for coop game modes

###### v1.1.0 (May 12, 2011)
  - Added a voting system
  - Added error checks if map is not found when switching
  - Added a cvar for enabling/disabling voting system
  - Added a cvar for how to advertise the voting system
  - Added a cvar for time to wait for voting advertisement
  - Added all current Mutation and Community game modes

###### v1.0.0 (May 5, 2011)
  - Initial Release
