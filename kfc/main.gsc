#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

// Módulos KFC
#include kfc\_flags;
#include kfc\_cmds;
#include kfc\_antiafk;
#include kfc\_balance;
#include kfc\_spectator_list;

init()
{
    level thread serverHandler();

    for (;;)
    {
        level waittill("connected", player);
        player thread playerHandler();
    }
}

serverHandler()
{
    thread kfc_flags::init();
    thread kfc_cmds::main();
    thread kfc_antiafk::init();
    thread kfc_balance::init();
    thread kfc_spectator_list::init();
    thread setServerDvar();
}

playerHandler()
{
    self thread setPlayerDvar();
    self thread kfc_antiafk::AFKMonitor();
}

setServerDvar()
{
    setDvar("jump_slowdownenable", 0);
}

setPlayerDvar()
{
    self setClientDvar("cl_maxpackets", 125);
}
