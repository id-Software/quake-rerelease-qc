/*  Copyright (C) 1996-2026 id Software LLC

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/


//============================================================================

typedef struct 
{
    string mdl;
    float frame;
}poseInfo;

#pragma warning disable F317 //Use of stale framemacros
poseInfo poses[] =
{
    { "progs/demon.mdl", $CORPSEFRAME_DEMON_1 },
    { "progs/dog.mdl", $CORPSEFRAME_DOG_1 },
    { "progs/dog.mdl", $CORPSEFRAME_DOG_2 },
    { "progs/enforcer.mdl", $CORPSEFRAME_ENFORCER_1 },
    { "progs/enforcer.mdl", $CORPSEFRAME_ENFORCER_2 },
    { "progs/fish.mdl", $CORPSEFRAME_FISH_1 },
    { "progs/hknight.mdl", $CORPSEFRAME_HKNIGHT_1 },
    { "progs/hknight.mdl", $CORPSEFRAME_HKNIGHT_2 },
    { "progs/knight.mdl", $CORPSEFRAME_KNIGHT_1 },
    { "progs/knight.mdl", $CORPSEFRAME_KNIGHT_2 },
    { "progs/ogre.mdl", $CORPSEFRAME_OGRE_1 },
    { "progs/ogre.mdl", $CORPSEFRAME_OGRE_2 },
    { "progs/shalrath.mdl", $CORPSEFRAME_SHALRATH_1 },
    { "progs/shambler.mdl", $CORPSEFRAME_SHAMBLER_1 },
    { "progs/soldier.mdl", $CORPSEFRAME_SOLDIER_1 },
    { "progs/soldier.mdl", $CORPSEFRAME_SOLDIER_2 },
    { "progs/wizard.mdl", $CORPSEFRAME_WIZARD_1 },
    { "progs/player.mdl", $CORPSEFRAME_PLAYER_1 },
    { "progs/player.mdl", $CORPSEFRAME_PLAYER_2 },
    { "progs/player.mdl", $CORPSEFRAME_PLAYER_3 },
    { "progs/player.mdl", $CORPSEFRAME_PLAYER_4 },
    { "progs/player.mdl", $CORPSEFRAME_PLAYER_5 },
    { "progs/player.mdl", $CORPSEFRAME_PLAYER_6 },
    // Heads
    { "progs/h_demon.mdl", 0 },
    { "progs/h_dog.mdl", 0 },
    { "progs/h_guard.mdl", 0 },
    { "progs/h_hellkn.mdl", 0 },
    { "progs/h_knight.mdl", 0 },
    { "progs/h_mega.mdl", 0 },
    { "progs/h_ogre.mdl", 0 },
    { "progs/h_player.mdl", 0 },
    { "progs/h_shal.mdl", 0 },
    { "progs/h_shams.mdl", 0 },
    { "progs/h_wizard.mdl", 0 },
    { "progs/h_zombie.mdl", 0 },
    // Gibs
    { "progs/gib1.mdl", 0 },
    { "progs/gib2.mdl", 0 },
    { "progs/gib3.mdl", 0 },
};
#pragma warning enable F317

void misc_corpse()
{
    INHIBIT_COOP
    if (RemovedOutsideCoop()) return;
    if (RemovedRuneCheck()) return; // AY May 2026, remove based on rune spawnflags

    if(self.style < 0 || self.style >= poses.length)
    {
        objerror("misc_corpse with invalid style.");
        return;
    }

    poseInfo pose = poses[self.style];
    precache_model(pose.mdl);
    self.frame = pose.frame;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    setmodel (self, pose.mdl);
}

void printCorpseFGDStuff()
{
    dprint("Corpseframes:\n");
    for(float i = 0; i < poses.length; i++)
    {
        //style ==  0 -> { path: "progs/demon.mdl"      , frame: 53  },
        dprint("style ==  ");
        dprint(ftos(i));
        dprint(" -> { path: \"");
        dprint(poses[i].mdl);
        dprint("\"\t, frame: ");
        dprint(ftos(poses[i].frame));
        dprint("\t},\n");
    }
}

//============================================================================
