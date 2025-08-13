// Made by szir for KFC Mod 
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

antiafk_init()
{
    level endon("game_ended");

    for (;;)
    {
        level waittill("connected", player);
        player thread AFKMonitor();
    }
}

AFKMonitor()
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("game_ended");

    afkLimit = 1; // segundos hasta pasar a espectador
    warnTime = 1.5; // segundos antes de moverlo para advertir

    for (;;)
    {
        // Esperar a que el jugador spawnee
        self waittill("spawned_player");
        self thread TrackAFK(afkLimit, warnTime);
    }
}

TrackAFK(limit, warn)
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("game_ended");
    self endon("spawned_player");

    lastPos = self.origin;
    idleTime = 0;
    warned = false;

    for (;;)
    {
        wait 1;

        // Si el jugador se movió, reiniciamos el contador
        if (DistanceSquared(self.origin, lastPos) > 1) // se movió un poco
        {
            idleTime = 0;
            lastPos = self.origin;
            warned = false;
        }
        else
        {
            idleTime++;

            // Aviso 10s antes
            if (!warned && idleTime >= (limit - warn))
            {
                iprintln(self.name + " será movido a espectador por inactividad en " + warn + " segundos");
                warned = true;
            }

            // Si llegó al límite, mover a espectador
            if (idleTime >= limit)
            {
                self [[level.spectator]](); // mover a espectador
                iprintln(self.name + " fue movido a espectador por estar AFK");
                break;
            }
        }
    }
}


