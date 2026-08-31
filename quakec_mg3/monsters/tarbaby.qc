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

BLOB

==============================================================================
*/

$cd id1/models/tarbaby
$origin 0 0 24
$base base		

$skin skin

$frame walk1 walk2 walk3 walk4  walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame run1 run2 run3 run4 run5 run6  run7 run8 run9 run10 run11 run12 run13
$frame run14 run15 run16 run17 run18 run19 run20 run21 run22 run23
$frame run24 run25

$frame jump1 jump2 jump3 jump4 jump5 jump6

$frame fly1 fly2 fly3 fly4

$frame exp

void()	tbaby_stand1	=[	$walk1,		tbaby_stand1	] {ai_stand();};

void()	tbaby_hang1		=[	$walk1,		tbaby_hang1	] {ai_stand();};

void()	tbaby_walk1	=[	$walk1,		tbaby_walk2	] {ai_turn();};
void()	tbaby_walk2	=[	$walk2,		tbaby_walk3	] {ai_turn();};
void()	tbaby_walk3	=[	$walk3,		tbaby_walk4	] {ai_turn();};
void()	tbaby_walk4	=[	$walk4,		tbaby_walk5	] {ai_turn();};
void()	tbaby_walk5	=[	$walk5,		tbaby_walk6	] {ai_turn();};
void()	tbaby_walk6	=[	$walk6,		tbaby_walk7	] {ai_turn();};
void()	tbaby_walk7	=[	$walk7,		tbaby_walk8	] {ai_turn();};
void()	tbaby_walk8	=[	$walk8,		tbaby_walk9	] {ai_turn();};
void()	tbaby_walk9	=[	$walk9,		tbaby_walk10	] {ai_turn();};
void()	tbaby_walk10	=[	$walk10,		tbaby_walk11	] {ai_turn();};
void()	tbaby_walk11	=[	$walk11,		tbaby_walk12	] {ai_walk(2);};
void()	tbaby_walk12	=[	$walk12,		tbaby_walk13	] {ai_walk(2);};
void()	tbaby_walk13	=[	$walk13,		tbaby_walk14	] {ai_walk(2);};
void()	tbaby_walk14	=[	$walk14,		tbaby_walk15	] {ai_walk(2);};
void()	tbaby_walk15	=[	$walk15,		tbaby_walk16	] {ai_walk(2);};
void()	tbaby_walk16	=[	$walk16,		tbaby_walk17	] {ai_walk(2);};
void()	tbaby_walk17	=[	$walk17,		tbaby_walk18	] {ai_walk(2);};
void()	tbaby_walk18	=[	$walk18,		tbaby_walk19	] {ai_walk(2);};
void()	tbaby_walk19	=[	$walk19,		tbaby_walk20	] {ai_walk(2);};
void()	tbaby_walk20	=[	$walk20,		tbaby_walk21	] {ai_walk(2);};
void()	tbaby_walk21	=[	$walk21,		tbaby_walk22	] {ai_walk(2);};
void()	tbaby_walk22	=[	$walk22,		tbaby_walk23	] {ai_walk(2);};
void()	tbaby_walk23	=[	$walk23,		tbaby_walk24	] {ai_walk(2);};
void()	tbaby_walk24	=[	$walk24,		tbaby_walk25	] {ai_walk(2);};
void()	tbaby_walk25	=[	$walk25,		tbaby_walk1	] {ai_walk(2);};

void()	tbaby_run1	=[	$run1,		tbaby_run2	] {ai_face();};
void()	tbaby_run2	=[	$run2,		tbaby_run3	] {ai_face();};
void()	tbaby_run3	=[	$run3,		tbaby_run4	] {ai_face();};
void()	tbaby_run4	=[	$run4,		tbaby_run5	] {ai_face();};
void()	tbaby_run5	=[	$run5,		tbaby_run6	] {ai_face();};
void()	tbaby_run6	=[	$run6,		tbaby_run7	] {ai_face();};
void()	tbaby_run7	=[	$run7,		tbaby_run8	] {ai_face();};
void()	tbaby_run8	=[	$run8,		tbaby_run9	] {ai_face();};
void()	tbaby_run9	=[	$run9,		tbaby_run10	] {ai_face();};
void()	tbaby_run10	=[	$run10,		tbaby_run11	] {ai_face();};
void()	tbaby_run11	=[	$run11,		tbaby_run12	] {ai_run(2);};
void()	tbaby_run12	=[	$run12,		tbaby_run13	] {ai_run(2);};
void()	tbaby_run13	=[	$run13,		tbaby_run14	] {ai_run(2);};
void()	tbaby_run14	=[	$run14,		tbaby_run15	] {ai_run(2);};
void()	tbaby_run15	=[	$run15,		tbaby_run16	] {ai_run(2);};
void()	tbaby_run16	=[	$run16,		tbaby_run17	] {ai_run(2);};
void()	tbaby_run17	=[	$run17,		tbaby_run18	] {ai_run(2);};
void()	tbaby_run18	=[	$run18,		tbaby_run19	] {ai_run(2);};
void()	tbaby_run19	=[	$run19,		tbaby_run20	] {ai_run(2);};
void()	tbaby_run20	=[	$run20,		tbaby_run21	] {ai_run(2);};
void()	tbaby_run21	=[	$run21,		tbaby_run22	] {ai_run(2);};
void()	tbaby_run22	=[	$run22,		tbaby_run23	] {ai_run(2);};
void()	tbaby_run23	=[	$run23,		tbaby_run24	] {ai_run(2);};
void()	tbaby_run24	=[	$run24,		tbaby_run25	] {ai_run(2);};
void()	tbaby_run25	=[	$run25,		tbaby_run1	] {ai_run(2);};


//============================================================================


void()	tbaby_jump1;

void()	Tar_JumpTouch =
{
	local	float	ldmg;

	if (other.takedamage && other.classname != self.classname)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 10 + 10*random();
			T_Damage (other, self, self, ldmg);	
			sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM);
		}
	}
	else
		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);


	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = tbaby_run1;
	self.movetype = MOVETYPE_STEP;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = tbaby_jump1;
	self.nextthink = time + 0.1;
};

void()	tbaby_jump5;

void()	tbaby_fly1		=[	$fly1,	tbaby_fly2	] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; };
void()	tbaby_fly2		=[	$fly2,	tbaby_fly3	] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; };
void()	tbaby_fly3		=[	$fly3,	tbaby_fly4	] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; };
void()	tbaby_fly4		=[	$fly4,	tbaby_fly1	] {
	RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; 
self.cnt = self.cnt + 1;
if (self.cnt == 4)
{
//dprint ("spawn hop\n");
tbaby_jump5 ();
}
};

void()	tbaby_jump1		=[	$jump1,	tbaby_jump2		] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; ai_face(); };
void()	tbaby_jump2		=[	$jump2,	tbaby_jump3		] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; ai_face(); };
void()	tbaby_jump3		=[	$jump3,	tbaby_jump4		] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; ai_face(); };
void()	tbaby_jump4		=[	$jump4,	tbaby_jump5		] { RETURN_IF_DIED_FROM_CONTENTS_DAMAGE; ai_face(); };
void()	tbaby_jump5		=[	$jump5,	tbaby_jump6		]
{	
	RETURN_IF_DIED_FROM_CONTENTS_DAMAGE;
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Tar_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random()*150;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.cnt = 0;
};
void()	tbaby_jump6	=[	$jump6,tbaby_fly1	] {};



//=============================================================================
void() SlimeStartCheck =
{
	
	if (!walkmove(0,0))
	{
		//dprint("could not walkmove\n");
		tbaby_explode();
	}
	else
	{
		self.think = FoundTarget;
		self.nextthink = time + 0.1;
		total_monsters++;
		WriteByte(MSG_ALL, SVC_UPDATESTAT);
		WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
		WriteLong(MSG_ALL, total_monsters);
		
		self.takedamage = DAMAGE_AIM;
	}
		//monster_use();
};
void() SlimeMissileTouch =
{
	if (other == self.owner)
		return;
	
	if (other.health)
	{
		// explode
		T_RadiusDamage (self, self, 120, world);

		tbaby_explode();
	}
	else
	{
		local entity new;
		new = spawn ();
		new.angles = '0 0 0';
		new.angles_y = crandom() * 180;
		new.classname = "monster_tarbaby";
		new.health = 80;
		setorigin(new, self.origin + '0 0 25');
		//new.origin += '0 0 24';

		new.slime = self.slime;
		new.enemy = self.enemy;
		
		new.ideal_yaw = new.angles * '0 1 0';
		if (!new.yaw_speed)
			new.yaw_speed = 20;
		new.view_ofs = '0 0 25';
		new.team = TEAM_MONSTERS;
		
		//new.takedamage = DAMAGE_AIM;
		new.flags = new.flags | FL_MONSTER;
		

		new.th_stand = tbaby_stand1;
		new.th_walk = tbaby_walk1;
		new.th_run = tbaby_run1;
		new.th_missile = tbaby_jump1;
		new.th_melee = tbaby_jump1;
		new.th_die = tbaby_die1;
		new.allowPathFind = TRUE;
		new.combat_style = CS_MELEE;

		new.lefty = MONSTER_TYPE_WALK;
		new.state = MONSTER_SIZE_SMALL;
		
		new.solid = SOLID_SLIDEBOX;
		new.movetype = MOVETYPE_STEP;
		
		new.classname = "monster_tarbaby";
		
		setmodel (new, "progs/tarbaby.mdl");
		setsize (new, VEC_HULL_MIN, VEC_HULL_MAX);

		new.pausetime = 99999999;
		new.think = SlimeStartCheck;
		new.nextthink = time + 0.1;

		remove(self);
		//InitMonster("progs/tarbaby.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_SMALL);	
		
		//self.think = CheckSpawn;
		//self.nextthink = time + 0.4;

		//	dprint("can't walkmove after transformation\n");
	}
};

void(float offset) SlimeMissile =
{
	//dprint("spawning Slime missile\n");
	local entity missile;
	//local vector dir;
	
	missile = spawn();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.slime = self.slime;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_BOUNCE;
	setmodel (missile, "progs/v_spike.mdl");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 16');
	//missile.origin = self.origin + '0 0 10';
	
	local vector ang;
	ang = '0 0 0';
	ang_y = offset;
	
	makevectors(self.angles + ang);
	
	missile.velocity = v_forward * 200;
	missile.velocity_z = 200;
	
	missile.avelocity = '300 300 300';
	missile.touch = SlimeMissileTouch;
	
	// handle case where it falls out of the world;
	missile.think = SUB_Remove;
	missile.nextthink = time + 5;
};

void() tbaby_explode =
{
	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion ();
};
//=============================================================================
void()	tbaby_die1	=[	$exp,		tbaby_die2	] {
self.takedamage = DAMAGE_NO;
};
void()	tbaby_die2	=[	$exp,		tbaby_run1	] 
{
	T_RadiusDamage (self, self, 120, world);

	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	// AY Oct 26 2025
	local float offset;
	if (self.slime)
	{
		self.slime -= 1; 
		
		offset = 180 + crandom() * 20;
		if (random() > 0.7)
		{
			offset = 120 + crandom() * 20;
			SlimeMissile(offset * -1);
		}	
		SlimeMissile(0 + crandom() * 20);
		SlimeMissile(offset);
	}
	BecomeExplosion ();
};

//=============================================================================


/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_tarbaby =
{
	precache_model2 ("progs/tarbaby.mdl");

	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
	
	
	self.health = 80;

	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;
	self.allowPathFind = TRUE;
	self.combat_style = CS_MELEE;
	
	InitMonster("progs/tarbaby.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_SMALL);
};

// AY Oct 25 2025 addition
// news split into news when killed. 
void() monster_slime =
{
	precache_model2 ("progs/v_spike.mdl"); // Adding Vore ball for special spawning
	precache_sound2 ("shalrath/attack2.wav");
	
	self.slime = 2;
	self.classname = "monster_tarbaby";
	self.aflag = 1; 
	monster_tarbaby();
};

.float slime;