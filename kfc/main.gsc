// Made by szir for KFC Mod

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include kfc\_flags.gsc;
#include kfc\_cmds.gsc;
#include kfc\_antiafk.gsc;
#include kfc\_balance.gsc;

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
    thread setServerDvar();
}

playerHandler()
{
    self thread setPlayerDvar();
    self thread kfc_antiafk::AFKMonitor(); // Inicia el monitor AFK para cada jugador
}

setServerDvar()
{
    setDvar("jump_slowdownenable", 0);
}

setPlayerDvar()
{
    self setClientDvar("cl_maxpackets", 125);
}
