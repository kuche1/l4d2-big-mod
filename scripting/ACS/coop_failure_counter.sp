
int coop_failure_counter_g_failure_count = 0;

void coop_failure_counter_on_map_start()
{
    coop_failure_counter_g_failure_count = 0;
}

void coop_failure_counter_on_coop_failure()
{
    coop_failure_counter_g_failure_count += 1;
}

int coop_failure_counter_get_count()
{
    return coop_failure_counter_g_failure_count;
}

void coop_failure_counter_on_before_player_disconnect()
{
    if (get_active_players() <= 1) // `1` -> player not yet fully disconnected
    {
        coop_failure_counter_g_failure_count = 0;
    }
}
