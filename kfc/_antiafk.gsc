// Made by szir for KFC Mod
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

namespace kfc_antiafk
{
    init()
    {
        // Inicializaciones globales si necesitas
    }

    AFKMonitor()
    {
        self endon("disconnect");
        self endon("joined_spectators");
        self endon("game_ended");
        self endon("vote_started");
        self endon("isKnifing");
        self endon("inintro");

        timer = 0;

        while (isAlive(self) && self.sessionteam != "spectator")
        {
            ori = self.origin;
            ang = self.angles;
            wait 1;

            if (isAlive(self) && self.sessionteam != "spectator")
            {
                if (self.origin == ori && self.angles == ang)
                    timer++;
                else
                    timer = 0;

                if (timer == 295) // 4 min 55 seg
                    self iPrintlnBold("^7You appear to be ^1AFK! You will be moved to spectator in 5 seconds.");

                if (timer >= 300) // 5 minutos
                {
                    if (self.sessionstate == "playing" && (!isDefined(self.isPlanting) || !self.isPlanting) && !level.gameEnded)
                    {
                        if (isDefined(self.carryObject))
                            self.carryObject thread maps\mp\gametypes\_gameobjects::setDropped();
                    }
                    self.sessionteam = "spectator";
                    self.sessionstate = "spectator";
                    level.spawnSpectator(self);
                    iprintln(self.name + " ^7was moved to spectator for being AFK.");
                    return;
                }
            }
            else
            {
                timer = 0;
            }
        }
    }
}
