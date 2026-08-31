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

/*
==============================================================================

MG3 DEMO DOG

==============================================================================
*/
$cd id1/models/dog
$origin 0 0 24
$base base
$skin skin

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8

$frame death1 death2 death3 death4 death5 death6 death7 death8 CORPSEFRAME_DOG_1

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame CORPSEFRAME_DOG_2

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8


void() demodog_leap1;
void() demodog_run1;

/*
================
dog_bite

================
*/

void() demodog_bite =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = (random() + random() + random()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
};

void()	DemoDog_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage && self.attack_finished < time)
	{
		if ( vlen(self.velocity) > 300 )
		{
			ldmg = 10 + 10*random();
			T_Damage (other, self, self, ldmg);	
			
			if (other.flags & FL_CLIENT)
			{
				T_Damage (self, other, other, 200);
				//demodog_die();
				//killed_monsters++;
				//WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
				//self.think = SUB_Null; // prevent bug where demodog thinks it can still attack
				//self.nextthink = -1;
				return;
			}
		
			self.attack_finished = time + 0.5;
		}
	}
	

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = demodog_leap1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.wait = 0;
	self.touch = SUB_Null;
	self.think = demodog_run1;
	self.nextthink = time + 0.1;
};


void() demodog_stand1	=[	$stand1,	demodog_stand2	] {ai_stand();};
void() demodog_stand2	=[	$stand2,	demodog_stand3	] {ai_stand();};
void() demodog_stand3	=[	$stand3,	demodog_stand4	] {ai_stand();};
void() demodog_stand4	=[	$stand4,	demodog_stand5	] {ai_stand();};
void() demodog_stand5	=[	$stand5,	demodog_stand6	] {ai_stand();};
void() demodog_stand6	=[	$stand6,	demodog_stand7	] {ai_stand();};
void() demodog_stand7	=[	$stand7,	demodog_stand8	] {ai_stand();};
void() demodog_stand8	=[	$stand8,	demodog_stand9	] {ai_stand();};
void() demodog_stand9	=[	$stand9,	demodog_stand1	] {ai_stand();};

void() demodog_walk1	=[	$walk1 ,	demodog_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_walk(8);};
void() demodog_walk2	=[	$walk2 ,	demodog_walk3	] {ai_walk(8);};
void() demodog_walk3	=[	$walk3 ,	demodog_walk4	] {ai_walk(8);};
void() demodog_walk4	=[	$walk4 ,	demodog_walk5	] {ai_walk(8);};
void() demodog_walk5	=[	$walk5 ,	demodog_walk6	] {ai_walk(8);};
void() demodog_walk6	=[	$walk6 ,	demodog_walk7	] {ai_walk(8);};
void() demodog_walk7	=[	$walk7 ,	demodog_walk8	] {ai_walk(8);};
void() demodog_walk8	=[	$walk8 ,	demodog_walk1	] {ai_walk(8);};

void() demodog_run1		=[	$run1  ,	demodog_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_run(16);};
void() demodog_run2		=[	$run2  ,	demodog_run3	] {ai_run(32);};
void() demodog_run3		=[	$run3  ,	demodog_run4	] {ai_run(32);};
void() demodog_run4		=[	$run4  ,	demodog_run5	] {ai_run(20);};
void() demodog_run5		=[	$run5  ,	demodog_run6	] {ai_run(64);};
void() demodog_run6		=[	$run6  ,	demodog_run7	] {ai_run(32);};
void() demodog_run7		=[	$run7  ,	demodog_run8	] {ai_run(16);};
void() demodog_run8		=[	$run8  ,	demodog_run9	] {ai_run(32);};
void() demodog_run9		=[	$run9  ,	demodog_run10	] {ai_run(32);};
void() demodog_run10	=[	$run10  ,	demodog_run11	] {ai_run(20);};
void() demodog_run11	=[	$run11  ,	demodog_run12	] {ai_run(64);};
void() demodog_run12	=[	$run12  ,	demodog_run1	] {ai_run(32);};


void() demodog_atta1	=[	$attack1,	demodog_atta2	] {ai_charge(10);};
void() demodog_atta2	=[	$attack2,	demodog_atta3	] {ai_charge(10);};
void() demodog_atta3	=[	$attack3,	demodog_atta4	] {ai_charge(10);};
void() demodog_atta4	=[	$attack4,	demodog_atta5	] {
sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);
demodog_bite();};
void() demodog_atta5	=[	$attack5,	demodog_atta6	] {ai_charge(10);};
void() demodog_atta6	=[	$attack6,	demodog_atta7	] {ai_charge(10);};
void() demodog_atta7	=[	$attack7,	demodog_atta8	] {ai_charge(10);};
void() demodog_atta8	=[	$attack8,	demodog_run1	] {ai_charge(10);};

void() demodog_leap1	=[	$leap1,		demodog_leap2	] {ai_face();};
void() demodog_leap2	=[	$leap2,		demodog_leap3	]
{
	ai_face();
	
	self.touch = DemoDog_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() demodog_leap3	=[	$leap3,		demodog_leap4	] {};
void() demodog_leap4	=[	$leap4,		demodog_leap5	] {};
void() demodog_leap5	=[	$leap5,		demodog_leap6	] {};
void() demodog_leap6	=[	$leap6,		demodog_leap7	] {};
void() demodog_leap7	=[	$leap7,		demodog_leap8	] {};
void() demodog_leap8	=[	$leap8,		demodog_leap9	] {};
void() demodog_leap9	=[	$leap9,		demodog_leap9	] {};

void() demodog_pain1	=[	$pain1 ,	demodog_pain2	] {};
void() demodog_pain2	=[	$pain2 ,	demodog_pain3	] {};
void() demodog_pain3	=[	$pain3 ,	demodog_pain4	] {};
void() demodog_pain4	=[	$pain4 ,	demodog_pain5	] {};
void() demodog_pain5	=[	$pain5 ,	demodog_pain6	] {};
void() demodog_pain6	=[	$pain6 ,	demodog_run1	] {};

void() demodog_painb1	=[	$painb1 ,	demodog_painb2	] {};
void() demodog_painb2	=[	$painb2 ,	demodog_painb3	] {};
void() demodog_painb3	=[	$painb3 ,	demodog_painb4	] {ai_pain(4);};
void() demodog_painb4	=[	$painb4 ,	demodog_painb5	] {ai_pain(12);};
void() demodog_painb5	=[	$painb5 ,	demodog_painb6	] {ai_pain(12);};
void() demodog_painb6	=[	$painb6 ,	demodog_painb7	] {ai_pain(2);};
void() demodog_painb7	=[	$painb7 ,	demodog_painb8	] {};
void() demodog_painb8	=[	$painb8 ,	demodog_painb9	] {ai_pain(4);};
void() demodog_painb9	=[	$painb9 ,	demodog_painb10	] {};
void() demodog_painb10	=[	$painb10 ,	demodog_painb11	] {ai_pain(10);};
void() demodog_painb11	=[	$painb11 ,	demodog_painb12	] {};
void() demodog_painb12	=[	$painb12 ,	demodog_painb13	] {};
void() demodog_painb13	=[	$painb13 ,	demodog_painb14	] {};
void() demodog_painb14	=[	$painb14 ,	demodog_painb15	] {};
void() demodog_painb15	=[	$painb15 ,	demodog_painb16	] {};
void() demodog_painb16	=[	$painb16 ,	demodog_run1	] {};

void(entity attacker, float damage) demodog_pain =
{
	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		demodog_pain1 ();
	else
		demodog_painb1 ();
};

void() demodog_die1		=[	$death1,	demodog_die2	] {};
void() demodog_die2		=[	$death2,	demodog_die3	] {};
void() demodog_die3		=[	$death3,	demodog_die4	] {};
void() demodog_die4		=[	$death4,	demodog_die5	] {};
void() demodog_die5		=[	$death5,	demodog_die6	] {};
void() demodog_die6		=[	$death6,	demodog_die7	] {};
void() demodog_die7		=[	$death7,	demodog_die8	] {};
void() demodog_die8		=[	$death8,	demodog_die9	] {};
void() demodog_die9		=[	$CORPSEFRAME_DOG_1,	demodog_die9	] {};

void() demodog_dieb1		=[	$deathb1,	demodog_dieb2	] {};
void() demodog_dieb2		=[	$deathb2,	demodog_dieb3	] {};
void() demodog_dieb3		=[	$deathb3,	demodog_dieb4	] {};
void() demodog_dieb4		=[	$deathb4,	demodog_dieb5	] {};
void() demodog_dieb5		=[	$deathb5,	demodog_dieb6	] {};
void() demodog_dieb6		=[	$deathb6,	demodog_dieb7	] {};
void() demodog_dieb7		=[	$deathb7,	demodog_dieb8	] {};
void() demodog_dieb8		=[	$deathb8,	demodog_dieb9	] {};
void() demodog_dieb9		=[	$CORPSEFRAME_DOG_2,	demodog_dieb9	] {};

void(float alt) demodog_spawn_grenade =
{
	local vector v;
	
	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();
	v = v * 1.5;

	if (alt)
	{
		v_x = 0;
		v_y = 0;
	}
	
	makevectors(self.angles);
	v += v_forward * 100;
	
	//Random Grenade
	local	entity missile;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	missile.dmg = 60; // bumped up from 40, April 11, 2026
		
	// set missile speed	

	missile.velocity = v;
	missile.oldorigin = v;
	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenadeTouch;
	

	missile.nextthink = time + 2.5 + 0.25 * crandom();
	missile.think = GrenadeExplode;
	

	setmodel (missile, "progs/grenade.mdl"); // Probably need to replace?!
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);	
	
	//W_FireGrenade(40, v);
};

void() demodog_die =
{
// check for gib
	self.health  = -50;
	demodog_spawn_grenade(0);
	demodog_spawn_grenade(0);
	demodog_spawn_grenade(0);
	if (skill > 2)
	{
		if (random() > 0.7)
			demodog_spawn_grenade(1);
	}
		
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	ThrowHead ("progs/h_dog.mdl", self.health);
	

	return;	
	/*
	
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowHead ("progs/h_dog.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	if (random() > 0.5)
		demodog_die1 ();
	else
		demodog_dieb1 ();
	*/
};

//============================================================================

/*
==============
CheckDogMelee

Returns TRUE if a melee attack would hit right now
==============
*/
/*
float()	CheckDogMelee =
{
	if (enemy_range == RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};
*/
/*
==============
CheckDogJump

==============
*/
/*
float()	CheckDogJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 80)
		return FALSE;
		
	if (d > 150)
		return FALSE;
		
	return TRUE;
};

float()	DogCheckAttack =
{
	// if close enough for slashing, go for it
	if (CheckDogMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDogJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};
*/

//===========================================================================

/*QUAKED monster_demodog (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_demodog =
{
	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog_explosive.mdl");

	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");

	self.classname = "monster_dog"; // pretend you're a normal dog, so that you play aggro and idle sfx
	self.aflag = 1;

	self.wait = 0; // 1 means can explode on touch, 0 means can't. 
	
	self.health = 25;

	self.th_stand = demodog_stand1;
	self.th_walk = demodog_walk1;
	self.th_run = demodog_run1;
	self.th_pain = demodog_pain;
	self.th_die = demodog_die;
	self.th_melee = demodog_atta1;
	self.th_missile = demodog_leap1;
	self.allowPathFind = TRUE;
	self.combat_style = CS_MELEE;
	
	InitMonster("progs/dog_explosive.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_LARGE);
};
