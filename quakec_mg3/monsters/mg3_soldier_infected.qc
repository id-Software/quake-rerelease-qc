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

void() army_infected_die =
{
	//gib
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	ThrowGib("progs/h_guard.mdl", self.health);
	//ThrowHead ("progs/h_guard.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);

	// Transform into zombie
	self.modelindex = self.modelindex_transformed;

	self.noise = "zombie/z_idle.wav";

	//setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 60;
	self.max_health = 60;

	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_die = zombie_die;
	self.th_missile = SUB_Null;
	
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_melee = zombie_missile;
	self.spawnflags = 128;
	
	self.takedamage = DAMAGE_AIM;
	
	self.classname = "monster_zombie"; // prevent infighting
	
	// Fix for infighting continuing after transformation
	infected_set_enemy("monster_zombie");

	if (!walkmove(0,0))
	{
		//handle edge case!
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
		self.health = -100;
		self.th_die();
	}
	else
		zombie_paina1();
};

/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() setup_army =
{
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	
	self.health = 30;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.infected = 1; // don't treat as legitimately dead
};

void() monster_army_infected =
{	
	setup_army();
	self.th_die = army_infected_die;
	
	// precache zombie
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");
	
	self.classname = "monster_army"; // prevent infighting
	
	setmodel (self, "progs/zombie.mdl");
	self.modelindex_transformed = self.modelindex;
	setmodel(self, string_null);
	InitMonster("progs/soldier.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_SMALL);
	
};
