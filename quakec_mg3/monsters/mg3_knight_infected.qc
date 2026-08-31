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

void() knight_infected_die =
{
	//gib
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	//ThrowHead ("progs/h_knight.mdl", self.health);
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
	//total_monsters = total_monsters + 1;
};

void() monster_knight_infected =
{	
	precache_model ("progs/knight.mdl");
	precache_model ("progs/h_knight.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");
	
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

	self.health = 75;

	self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_pain = knight_pain;
	//self.th_die = knight_die;
	self.allowPathFind = TRUE;
	self.combat_style = CS_MELEE;
	self.infected = 1; // don't treat as legitimately dead
	self.th_die = knight_infected_die;
	
	self.classname = "monster_knight"; // prevent infighting
	
	setmodel (self, "progs/zombie.mdl");
	self.modelindex_transformed = self.modelindex;
	setmodel(self, string_null);
	InitMonster("progs/knight.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_SMALL);
	
};

