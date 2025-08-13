#include maps\mp\kfc\_antiafk;
#include maps\mp\kfc\_spectator_list;

init()
{
    main();
}

main()
{
    thread maps\mp\kfc\_cmds::main();
    thread maps\mp\kfc\_spectator_list::spectator_list_init();

    setServerDvar();

    level.onPlayerConnect = ::onPlayerConnect;
}

onPlayerConnect()
{
    self waittill("connected");

    setPlayerDvar();

    playerHandler();

    // Iniciar el sistema AFK para este jugador
    self thread maps\mp\kfc\_antiafk::AFKMonitor();
}

playerHandler()
{
    self endon("disconnect");

    for (;;)
    {
        self waittill("spawned_player");
        // Lógica personalizada del jugador
    }
}

setServerDvar()
{
    setDvar("jump_slowdownenable", 0);
}

setPlayerDvar()
{
    self setClientDvar("cl_maxpackets", 125);
}

