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

ORB

==============================================================================
*/


$cd id1/models/a_wizard
$origin 0 0 24
$base wizbase	
$skin wizbase

$frame hover1 blink1 blink2
/*
$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14

$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10 magatt11 magatt12 magatt13

$frame pain1 pain2 pain3 pain4

$frame death1 death2 death3 death4 death5 death6 death7 CORPSEFRAME_WIZARD_1
*/

/*
==============================================================================

WIZARD

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

/*
=============
LaunchMissile

Sets the given entities velocity and angles so that it will hit self.enemy
if self.enemy maintains it's current velocity
0.1 is moderately accurate, 0.0 is totally accurate
=============
*/
void(entity missile, float mspeed, float accuracy) OrbLaunchMissile =
{
	local	vector	vec, move;
	local	float	fly;

	makevectors (self.angles);
		
// set missile speed
	vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin;

// calc aproximate time for missile to reach vec
	fly = vlen (vec) / mspeed;
	
// get the entities xy velocity
	move = self.enemy.velocity;
	move_z = 0;

// project the target forward in time
	vec = vec + move * fly;
	
	vec = normalize(vec);
	vec = vec + accuracy*v_up*(random()- 0.5) + accuracy*v_right*(random()- 0.5);
	
	missile.velocity = vec * mspeed;

	missile.angles = '0 0 0';
	missile.angles_y = vectoyaw(missile.velocity);

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;	
};


void() orb_run1;
void() orb_side1;

/*
=================
WizardCheckAttack
=================
*/
float() OrbCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_visible)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			orb_run1 ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.6;
	else if (enemy_range == RANGE_MID)
		chance = 0.2;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			orb_run1 ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			orb_side1 ();
		}
	}
	
	return FALSE;
};

/*
=================
OrbAttackFinished
=================
*/
void()	OrbAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_visible)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = orb_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = orb_side1;
	}
};

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

/*
void() Orb_FastFire =
{
	local vector		vec;
	local vector		dst;

	if (self.owner.health > 0)
	{

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.owner.origin_x);
		WriteCoord (MSG_BROADCAST, self.owner.origin_y);
		WriteCoord (MSG_BROADCAST, self.owner.origin_z);
		//self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;

		makevectors (self.enemy.angles);	
		dst = self.enemy.origin - 13*self.movedir;
	
		vec = normalize(dst - self.origin);
		sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
		launch_spike (self.origin, vec);
		newmis.velocity = vec*600;
		newmis.owner = self.owner;
		newmis.classname = "wizspike";
		//setmodel (newmis, "progs/w_spike.mdl");
		setmodel (newmis, "progs/rogue/sphere.mdl");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	}

	remove (self);
};


void() Orb_StartFast =
{
	local	entity	missile;
	
	sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors (self.angles);

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize (missile, '0 0 0', '0 0 0');		
	//setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right*14);
	setorigin (missile, self.origin + v_forward*14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = Orb_FastFire;
	missile.movedir = v_right;

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 1;
	setsize (missile, '0 0 0', '0 0 0');		
	//setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right* -14);
	setorigin (missile, self.origin + v_forward*14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.3;
	missile.think = Orb_FastFire;
	missile.movedir = VEC_ORIGIN - v_right;
};
*/


void() Orb_idlesound =
{
	if (self.waitmin < time)
	{
	 	self.waitmin = time + 15 + random() * 10;
		sound(self, CHAN_VOICE, "boss2/sight.wav", 1, ATTN_IDLE);

	}
	return;
};

void()	orb_stand1	=[	$hover1,		orb_stand1	] {ai_stand();};


void()	orb_walk1	=[	$hover1,		orb_walk1	] {ai_walk(8);
Orb_idlesound();};


void()	orb_side1	=[	$hover1,		orb_side1	] {ai_face();ai_run(16);
Orb_idlesound();};

void()	orb_run1	=[	$hover1,		orb_run1	] {ai_run(16);
Orb_idlesound();};


void()	orb_fast1	=[	$hover1,		orb_fast2	] {self.ammo_nails = 1 + floor(random() * 3 + 0.5); ai_face();};
void()	orb_fast2	=[	$blink1,		orb_fast3	] {};
void()	orb_fast3	=[	$blink2,		orb_fast4	] {self.nextthink = time + 0.3;	ai_face();};
void()	orb_fast4	=[	$hover1,		orb_fast5	]
{
	ai_face();
	orb_blast();
	self.nextthink = time + 0.2;
	self.ammo_nails--;
	if (self.ammo_nails)
		self.think = orb_fast2;
};
void()	orb_fast5	=[	$blink2,		orb_run1	] {ai_face();SUB_AttackFinished(2);OrbAttackFinished ();};


void()	orb_pain1	=[	$blink2,		orb_pain2	] {self.ammo_shells = 3;self.nextthink = time + 0.2;};
void()	orb_pain2	=[	$blink2,		orb_pain3	]
{
	pain_lightning('0 0 0');
	self.nextthink = time + 0.3;
	self.ammo_shells--;
	if (self.ammo_shells)
	{
		self.think = orb_pain2;
	}
};
void()	orb_pain3	=[	$blink2,		orb_pain4	] {};
void()	orb_pain4	=[	$hover1,		orb_run1	] {};

void()	orb_death1	=[	$blink1,		orb_death2	] {

self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 150 + 150*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
self.solid = SOLID_BBOX;
setsize (self, '0 0 0', '0 0 0');
//sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
sound (self, CHAN_VOICE, "orb/orb_death.wav", 1, ATTN_NORM);
};
void()	orb_death2	=[	$blink2,		orb_death3	] {};
void()	orb_death3	=[	$blink2,		orb_death4	]{self.touch = orb_death_touch;};
void()	orb_death4	=[	$blink2,		orb_death4	] {self.nextthink = time + 9999;};


void() orb_death_touch =
{
	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing
	if ((other.solid == SOLID_BBOX) && !(other.health))
		return; // don't explode on projectiles
		
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);

	T_RadiusDamage (self, self, 100, world);

	remove(self);
}


void() orb_die =
{
// check for gib
/*
	if (self.health < -40)
	{
		//sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		//ThrowHead ("progs/h_wizard.mdl", self.health);
		sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		WriteByte (MSG_BROADCAST, 244);
		WriteByte (MSG_BROADCAST, 3);

		remove(self);
		return;
	}
*/
	orb_death1 ();
};


void(entity attacker, float damage) Orb_Pain =
{
	if (self.pain_finished > time)
		return;
	if (random()*200 > damage)
		return;		// didn't flinch

	//sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
	sound (self, CHAN_VOICE, "orb/orb_pain.wav", 1, ATTN_NORM);

	self.pain_finished = time + 8;

	orb_pain1 ();
};


void() Orb_Missile =
{
	orb_fast1();
};

/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_orb =
{
	precache_model ("progs/teleporter_eye_blink.mdl");
	//precache_model ("progs/h_wizard.mdl");
	//precache_model ("progs/w_spike.mdl");
	precache_model ("progs/rogue/sphere.mdl");

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound2 ("orb/orb_death.wav");
	precache_sound2 ("orb/orb_pain.wav");
	
	//precache_sound ("wizard/widle1.wav");
	//precache_sound ("wizard/widle2.wav");
	precache_sound2 ("boss2/idle.wav");

	precache_sound ("wizard/wpain.wav");
	//precache_sound ("wizard/wsight.wav");
	precache_sound2 ("boss2/sight.wav");
	precache_sound ("misc/power.wav");

	/*
	precache_sound2 ("boss2/death.wav");
	precache_sound2 ("boss2/idle.wav");
	precache_sound2 ("boss2/sight.wav");
	precache_sound2 ("boss2/pop2.wav");
*/
	self.health = 300;

	self.th_stand = orb_stand1;
	self.th_walk = orb_walk1;
	self.th_run = orb_run1;
	self.th_missile = Orb_Missile;
	self.th_pain = Orb_Pain;
	self.th_die = orb_die;
	self.combat_style = CS_RANGED;
		
	InitMonster("progs/teleporter_eye_blink.mdl", MONSTER_TYPE_FLY, MONSTER_SIZE_LARGE);
};


void() orb_blast =
{
	local float spread;
	spread = 0.01;
	local vector p; // relative offset 
	p = '15 0 0'; 
	local vector org, vec, offang, new_vec;
	local float orbs, t;
	local vector spread_vec, d;

	local float base_speed;
	base_speed = 400;
	if (skill > 2)
		base_speed = 500;
	else if (skill > 0)
		base_speed = 450;
	//spread_vec = '0.28 0.16 0';
	spread_vec = '0.1 0.1 0.01';
	//spread_vec += '1 1 0' * fabs(spread);
	//spread_vec = '0.5 0.25 0';
	orbs = 4 + floor(random() * 2 +0.5);

	offang = vectoangles(self.enemy.origin - self.origin);

	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

		// lead the player on hard mode
	t = vlen(self.enemy.origin - org) / base_speed;
	vec = self.enemy.velocity;
	vec_z = 0;
	d = self.enemy.origin + t/4 * vec;		
	
	vec = normalize (d - org);
	//vec = normalize(vec) + (v_right * spread) + (v_up * spread * .2);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);


	while (orbs)
	{
		new_vec = normalize(vec + crandom()*spread_vec_x*v_right + crandom()*spread_vec_y*v_up);


		//vec_z = 0; // remove the z element to keep the line on the ground
		//vec = normalize(vec);

		launch_spike (org + new_vec * 8, new_vec);
		newmis.classname = "rock";
		newmis.owner = self; 

			//if (projectile_count == random_projectile)
		setmodel (newmis, "progs/rogue/sphere.mdl");
		//setmodel (newmis, "progs/rogue/plasma.mdl");
			//else
			//	setmodel (newmis, "progs/rogue/rubble.mdl");
		setsize (newmis, '0 0 0', '0 0 0');	
		//newmis.velocity = vec * 25;

		newmis.velocity = new_vec * (base_speed + crandom() * 100);
		//newmis.think = Rock_Accelerate;
		//newmis.nextthink = time + 0.1;

		newmis.avelocity = '300 300 300';
		newmis.avelocity_x *= crandom();
		newmis.avelocity_y *= crandom();
		newmis.avelocity_z *= crandom();

		if (orbs % 2 == 0)
		{
			newmis.frags = 1;
			newmis.effects (+) EF_CANDLELIGHT; // TODO after Mike fies up? 
		}

		newmis.touch = T_OrbTouch;

		orbs--;
	}
};

void() T_OrbTouch ={
	if (other == self.owner)
		return;

	if (other.classname == "monster_orb")
	{
		remove(self);
		return;
	}
	if (other.classname == "monster_lava_man")
	{
		remove(self);
		return;
	}
	if (other.classname == "monster_super_shambler")
	{
		remove(self);
		return;
	}

	if (other.classname == self.classname)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else if (self.frags)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);
		

}