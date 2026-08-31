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

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 CORPSEFRAME_HKNIGHT_1

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame CORPSEFRAME_HKNIGHT_2

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

//===========================================================================
void() hknight_resurrect =
{
	//dprint("resurrection completed!\n");
	self.aflag = 0;
	self.th_pain = hknight_pain;
	self.th_run = hknight_run1;
	self.th_stand = hknight_stand1;
	ai_stand();
};

float() hknight_test_rise =
{
	self.solid = SOLID_SLIDEBOX;
	if (!walkmove (0, 0))
	{
		self.solid = SOLID_NOT;
		return 0;
	}
	sound (self, CHAN_VOICE, "infected/death1_rev.wav", 1, ATTN_NORM);		
	return 1;
}

void() hknight_corpse1 =[ $CORPSEFRAME_HKNIGHT_1, hknight_corpse1_2	]{self.solid = SOLID_NOT;};
void() hknight_corpse1_2 =[ $CORPSEFRAME_HKNIGHT_1, hknight_corpse1_2	]{self.nextthink = time + 9999;};

/*
self.solid = SOLID_SLIDEBOX;
if (!walkmove (0, 0))
{
	self.think = zombie_paine11;
	self.solid = SOLID_NOT;
	return;
}
*/
void() hknight_corpse1_rise0 	=[ $CORPSEFRAME_HKNIGHT_1, hknight_corpse1_rise1	] {
if (!hknight_test_rise())
{
	self.think = hknight_corpse1_rise0;
	self.nextthink = time + 5;
}};
void()	hknight_corpse1_rise1	=[ $CORPSEFRAME_HKNIGHT_1, hknight_corpse1_rise2	]	{};
void()	hknight_corpse1_rise2	=[ $death11,	hknight_corpse1_rise3	]	{self.pain_finished = time + 1.5;};
void()	hknight_corpse1_rise3	=[ $death10,	hknight_corpse1_rise4	]	{};
void()	hknight_corpse1_rise4	=[ $death9,		hknight_corpse1_rise5	]	{ai_forward(-11);};
void()	hknight_corpse1_rise5	=[ $death8,		hknight_corpse1_rise6	]	{ai_forward(-10);};
void()	hknight_corpse1_rise6	=[ $death7,		hknight_corpse1_rise7	]	{};
void()	hknight_corpse1_rise7	=[ $death6,		hknight_corpse1_rise8	]	{};
void()	hknight_corpse1_rise8	=[ $death5,		hknight_corpse1_rise9	]	{};
void()	hknight_corpse1_rise9	=[ $death4,		hknight_corpse1_rise10	]	{};
void()	hknight_corpse1_rise10	=[ $death3,		hknight_corpse1_rise11	]	{ai_forward(-7);};
void()	hknight_corpse1_rise11	=[ $death2,		hknight_corpse1_rise12	]	{ai_forward(-8);};
void()	hknight_corpse1_rise12	=[ $death1,		hknight_corpse1_rise13	]	{};
void()	hknight_corpse1_rise13	=[ $stand1,		hknight_corpse1_rise14	]	{};
void()	hknight_corpse1_rise14	=[ $stand2,		hknight_run1			]	{ai_forward(-10);hknight_resurrect();};


void()	hknight_corpse2 =[ $CORPSEFRAME_HKNIGHT_2, hknight_corpse2_2	]{self.solid = SOLID_NOT;};
void()	hknight_corpse2_2 =[ $CORPSEFRAME_HKNIGHT_2, hknight_corpse2_2	]{self.nextthink = time + 9999;};

void()	hknight_corpse2_rise0	=[ $CORPSEFRAME_HKNIGHT_2,	hknight_corpse2_rise2	]	{
if (!hknight_test_rise())
{
	self.think = hknight_corpse2_rise0;
	self.nextthink = time + 5;
}};
void()	hknight_corpse2_rise1	=[ $CORPSEFRAME_HKNIGHT_2,	hknight_corpse2_rise2	]	{};
void()	hknight_corpse2_rise2	=[ $deathb8,	hknight_corpse2_rise3	]	{self.pain_finished = time + 1.5;};
void()	hknight_corpse2_rise3	=[ $deathb7,	hknight_corpse2_rise4	]	{};
void()	hknight_corpse2_rise4	=[ $deathb6,	hknight_corpse2_rise5	]	{};
void()	hknight_corpse2_rise5	=[ $deathb5,	hknight_corpse2_rise6	]	{};
void()	hknight_corpse2_rise6	=[ $deathb4,	hknight_corpse2_rise7	]	{};
void()	hknight_corpse2_rise7	=[ $deathb3,	hknight_corpse2_rise8	]	{};
void()	hknight_corpse2_rise8	=[ $deathb2,	hknight_corpse2_rise9	]	{};
void()	hknight_corpse2_rise9	=[ $deathb2,	hknight_corpse2_rise10	]	{};
void()	hknight_corpse2_rise10	=[ $stand1,		hknight_corpse2_rise11	]	{};
void()	hknight_corpse2_rise11	=[ $stand2,		hknight_run1			] {hknight_resurrect();};



//===========================================================================

//===========================================================================
void() hknight_infected_die =
{
	//gib
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	//ThrowHead ("progs/h_guard.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	
	// Transform into demon
	//setmodel (self, "progs/demon.mdl");
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
const float CORPSE_FLAG_A = 65536;
const float CORPSE_FLAG_B = 8388608;

void() monster_hell_knight_infected =
{
	// precache hell knight
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");

	
	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	
	// precache demon
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	
	precache_sound ("infected/death1_rev.wav");
	
	// set stats
	self.health = 250;

	if (self.spawnflags & CORPSE_FLAG_A)
	{
		
		self.th_stand = hknight_corpse1;
		self.th_run = hknight_corpse1_rise0;
	}
	else if (self.spawnflags & CORPSE_FLAG_B)
	{
		self.th_stand = hknight_corpse2;
		self.th_run = hknight_corpse2_rise0;
	}
	else // normal behavior
	{
		self.th_stand = hknight_stand1;
		self.th_run = hknight_run1;
		self.th_pain = hknight_pain;
	}
	self.th_walk = hknight_walk1;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_magicc1;
	
	self.allowPathFind = TRUE;
	self.combat_style = CS_MIXED;

	self.th_die = hknight_infected_die; // handle the transformation 
	self.infected = 1; // don't treat as legitimately dead
	
	self.classname = "monster_hell_knight"; // prevent infighting
	
	setmodel (self, "progs/demon.mdl");
	self.modelindex_transformed = self.modelindex;
	setmodel(self, string_null);
	
	InitMonster("progs/hknight.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_LARGE);
}