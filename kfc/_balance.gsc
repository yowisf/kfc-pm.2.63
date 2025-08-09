// Made by szir for KFC Mod
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    // Ejecutar BalanceTeams cuando un jugador spawnea
    level on("spawned", ::BalanceTeams);
}

BalanceTeams()
{
    // Finaliza el hilo si hay votación o termina el juego
    level endon("vote started");
    level endon("game_ended");

    while (true)
    {
        wait 10; // Esperar 10 segundos entre chequeos

        int team1Count = countPlayersInTeam("axis");   // Cambia "axis" y "allies" según tus equipos
        int team2Count = countPlayersInTeam("allies");

        if (team1Count > team2Count + 1)
        {
            player p = getPlayerFromTeam("axis");
            if (p)
            {
                movePlayerToTeam(p, "allies");
                iPrintln(p.name + " has been moved to allies to balance teams.");
            }
        }
        else if (team2Count > team1Count + 1)
        {
            player p = getPlayerFromTeam("allies");
            if (p)
            {
                movePlayerToTeam(p, "axis");
                iPrintln(p.name + " has been moved to axis to balance teams.");
            }
        }
    }
}

// Cuenta jugadores vivos en un equipo que no sean espectadores
int countPlayersInTeam(string team)
{
    player[] players = getPlayers();
    int count = 0;
    for (int i = 0; i < players.size; i++)
    {
        if (players[i].team == team && players[i].sessionteam != "spectator" && isAlive(players[i]))
            count++;
    }
    return count;
}

// Obtiene un jugador válido para mover (no admin, no AFK, etc)
player getPlayerFromTeam(string team)
{
    player[] players = getPlayers();
    for (int i = 0; i < players.size; i++)
    {
        player p = players[i];
        if (p.team == team && p.sessionteam != "spectator" && isAlive(p))
        {
            // Aquí puedes agregar más filtros, por ejemplo no mover admins o jugadores AFK
            if (!isDefined(p.isAdmin) || !p.isAdmin) 
                return p;
        }
    }
    return null;
}

// Cambia el equipo del jugador y lo hace respawnear
void movePlayerToTeam(player p, string newTeam)
{
    if (!isDefined(p))
        return;

    // Forzar respawn para evitar bugs
    p suicide();

    p setTeam(newTeam);

    // Respawnear al jugador
    p thread maps\mp\gametypes\_globallogic::spawnPlayer();

    // Mensaje privado al jugador
    p iprintlnbold("^2You were moved to " + newTeam + " to balance teams.");
}
