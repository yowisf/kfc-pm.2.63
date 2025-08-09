// Made by szir for KFC Mod
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level thread BalanceTeamsLoop();
}

BalanceTeamsLoop()
{
    level endon("vote_started");
    level endon("game_ended");

    for (;;)
    {
        wait 10; // Chequeo cada 10 seg

        team1Count = countPlayersInTeam("axis");
        team2Count = countPlayersInTeam("allies");

        if (team1Count > team2Count + 1)
        {
            p = getPlayerFromTeam("axis");
            if (isDefined(p))
            {
                movePlayerToTeam(p, "allies");
                iPrintln(p.name + " has been moved to allies to balance teams.");
            }
        }
        else if (team2Count > team1Count + 1)
        {
            p = getPlayerFromTeam("allies");
            if (isDefined(p))
            {
                movePlayerToTeam(p, "axis");
                iPrintln(p.name + " has been moved to axis to balance teams.");
            }
        }
    }
}

countPlayersInTeam(team)
{
    players = getPlayers();
    count = 0;
    for (i = 0; i < players.size; i++)
    {
        if (players[i].team == team && players[i].sessionteam != "spectator" && isAlive(players[i]))
            count++;
    }
    return count;
}

getPlayerFromTeam(team)
{
    players = getPlayers();
    for (i = 0; i < players.size; i++)
    {
        p = players[i];
        if (p.team == team && p.sessionteam != "spectator" && isAlive(p))
        {
            if (!isDefined(p.isAdmin) || !p.isAdmin) 
                return p;
        }
    }
    return undefined;
}

movePlayerToTeam(p, newTeam)
{
    if (!isDefined(p))
        return;

    p suicide();
    p setTeam(newTeam);
    p thread maps\mp\gametypes\_globallogic::spawnPlayer();
    p iprintlnbold("^2You were moved to " + newTeam + " to balance teams.");
}
