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

void() enforcer_infected_die =
{
	//gib
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	//ThrowHead ("progs/h_guard.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	
	// Transform into demon
	self.modelindex = self.modelindex_transformed;
	self.noise = "demon/sight2.wav";
	
	self.health = 300;
	self.max_health = 300;

	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;
	self.th_missile = demon1_jump1;
	self.th_pain = demon1_pain;
	self.combat_style = CS_MELEE;

	self.classname= "monster_zombie";
	// set damageable
	self.takedamage = DAMAGE_AIM;
	self.pain_finished = time + 1;
	self.attack_finished = 0;
	self.classname = "monster_demon1";
	
	// Fix for infighting continuing after transformation
	infected_set_enemy("monster_demon1");
	
	if (!walkmove(0,0))
	{
		//handle edge case!
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
		self.health = -100;
		self.th_die();
	}
	else
		demon1_pain1();
	
	
	//total_monsters = total_monsters + 1;
};

/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_enforcer_infected =
{
	// precache enforcer
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	
	// precache demon
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	
	self.health = 80;

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_missile = enf_atk1;
	//self.th_die = enf_die;
	self.th_die = enforcer_infected_die; // handle the transformation 
	self.infected = 1; // don't treat as legitimately dead
	
	self.classname = "monster_enforcer"; // prevent infighting
	
	setmodel( self, "progs/demon.mdl");
	self.modelindex_transformed = self.modelindex;

	setmodel(self, string_null);
	
	InitMonster("progs/enforcer.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_LARGE);
}