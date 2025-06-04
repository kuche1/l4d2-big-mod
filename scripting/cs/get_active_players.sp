
int get_active_players()
{
    int total_players = 0;

    for (int cli=1; cli<=MaxClients; ++cli) // `cli=1` skip "server console"
    {
        if (!IsClientInGame(cli)) {
            // not yet connected
            continue;
        }
        if (IsFakeClient(cli)) {
            // bot
            continue;
        }
        if (GetClientTeam(cli) == 1) {
            // spectator // I have not actually tested this but it should be correct
            continue;
        }
        total_players += 1;
    }

    return total_players;
}
