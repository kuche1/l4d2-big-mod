
int g_coop_failure_count = 0;

void coop_failure_counter_on_map_start()
{
    g_coop_failure_count = 0;
}

void coop_failure_counter_on_coop_failure()
{
    g_coop_failure_count += 1;
}

int coop_failure_counter_get_count()
{
    return g_coop_failure_count;
}