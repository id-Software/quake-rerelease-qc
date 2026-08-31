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

SHAMBLER

==============================================================================
*/

$cd id1/models/shams
$origin 0 0 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame	run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 CORPSEFRAME_SHAMBLER_1


void() supsham_stand1	=[	$stand1,	supsham_stand2	] {ai_stand();};
void() supsham_stand2	=[	$stand2,	supsham_stand3	] {ai_stand();};
void() supsham_stand3	=[	$stand3,	supsham_stand4	] {ai_stand();};
void() supsham_stand4	=[	$stand4,	supsham_stand5	] {ai_stand();};
void() supsham_stand5	=[	$stand5,	supsham_stand6	] {ai_stand();};
void() supsham_stand6	=[	$stand6,	supsham_stand7	] {ai_stand();};
void() supsham_stand7	=[	$stand7,	supsham_stand8	] {ai_stand();};
void() supsham_stand8	=[	$stand8,	supsham_stand9	] {ai_stand();};
void() supsham_stand9	=[	$stand9,	supsham_stand10] {ai_stand();};
void() supsham_stand10	=[	$stand10,	supsham_stand11] {ai_stand();};
void() supsham_stand11	=[	$stand11,	supsham_stand12] {ai_stand();};
void() supsham_stand12	=[	$stand12,	supsham_stand13] {ai_stand();};
void() supsham_stand13	=[	$stand13,	supsham_stand14] {ai_stand();};
void() supsham_stand14	=[	$stand14,	supsham_stand15] {ai_stand();};
void() supsham_stand15	=[	$stand15,	supsham_stand16] {ai_stand();};
void() supsham_stand16	=[	$stand16,	supsham_stand17] {ai_stand();};
void() supsham_stand17	=[	$stand17,	supsham_stand1	] {ai_stand();};

void() supsham_walk1		=[      $walk1,        supsham_walk2 ] {ai_walk(10);};
void() supsham_walk2       =[      $walk2,        supsham_walk3 ] {ai_walk(9);};
void() supsham_walk3       =[      $walk3,        supsham_walk4 ] {ai_walk(9);};
void() supsham_walk4       =[      $walk4,        supsham_walk5 ] {ai_walk(5);};
void() supsham_walk5       =[      $walk5,        supsham_walk6 ] {ai_walk(6);};
void() supsham_walk6       =[      $walk6,        supsham_walk7 ] {ai_walk(12);};
void() supsham_walk7       =[      $walk7,        supsham_walk8 ] {ai_walk(8);};
void() supsham_walk8       =[      $walk8,        supsham_walk9 ] {ai_walk(3);};
void() supsham_walk9       =[      $walk9,        supsham_walk10] {ai_walk(13);};
void() supsham_walk10      =[      $walk10,       supsham_walk11] {ai_walk(9);};
void() supsham_walk11      =[      $walk11,       supsham_walk12] {ai_walk(7);};
void() supsham_walk12      =[      $walk12,       supsham_walk1 ] {ai_walk(7);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);};

void() supsham_run1       =[      $run1,        supsham_run2      ] {
	supsham_removechild();
	ai_run(20);};
void() supsham_run2       =[      $run2,        supsham_run3      ] {ai_run(24);};
void() supsham_run3       =[      $run3,        supsham_run4      ] {ai_run(20);};
void() supsham_run4       =[      $run4,        supsham_run5      ] {ai_run(20);};
void() supsham_run5       =[      $run5,        supsham_run6      ] {ai_run(24);};
void() supsham_run6       =[      $run6,        supsham_run1      ] {ai_run(20);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
};

void() supsham_smash1     =[      $smash1,       supsham_smash2    ] {
sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
ai_charge(2);};
void() supsham_smash2     =[      $smash2,       supsham_smash3    ] {ai_charge(6);};
void() supsham_smash3     =[      $smash3,       supsham_smash4    ] {ai_charge(6);};
void() supsham_smash4     =[      $smash4,       supsham_smash5    ] {ai_charge(5);};
void() supsham_smash5     =[      $smash5,       supsham_smash6    ] {ai_charge(4);};
void() supsham_smash6     =[      $smash6,       supsham_smash7    ] {ai_charge(1);};
void() supsham_smash7     =[      $smash7,       supsham_smash8    ] {ai_charge(0);};
void() supsham_smash8     =[      $smash8,       supsham_smash9    ] {ai_charge(0);};
void() supsham_smash9     =[      $smash9,       supsham_smash10   ] {ai_charge(0);};
void() supsham_smash10    =[      $smash10,      supsham_smash11   ] {
local vector	delta;
local float 	ldmg;

	blast1('0 0 0');
	if (!self.enemy)
		return;
	ai_charge(0);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	ldmg = (random() + random() + random()) * 40;
	T_Damage (self.enemy, self, self, ldmg);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
};
void() supsham_smash11    =[      $smash11,      supsham_smash12   ] {ai_charge(5);};
void() supsham_smash12    =[      $smash12,      supsham_run1	   ] {
	ai_charge(4);
	if (supsham_attack_check())
	{
		self.think = supsham_magic1;
	}
};

void() supsham_swingr1;

void(float side) SupShamClaw =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = (random() + random() + random()) * 20;
	T_Damage (self.enemy, self, self, ldmg);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() supsham_swingl1	=[      $swingl1,      supsham_swingl2   ] {
sound (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
ai_charge(5);};
void() supsham_swingl2 =[      $swingl2,      supsham_swingl3   ] {ai_charge(3);};
void() supsham_swingl3 =[      $swingl3,      supsham_swingl4   ] {ai_charge(7);};
void() supsham_swingl4 =[      $swingl4,      supsham_swingl5   ] {ai_charge(3);};
void() supsham_swingl5 =[      $swingl5,      supsham_swingl6   ] {ai_charge(7);};
void() supsham_swingl6 =[      $swingl6,      supsham_swingl7   ] {ai_charge(9);};
void() supsham_swingl7 =[      $swingl7,      supsham_swingl8   ] {blast2(v_right * 16 + '0 0 32');ai_charge(5); SupShamClaw(250);};
void() supsham_swingl8 =[      $swingl8,      supsham_swingl9   ] {ai_charge(4);};
void() supsham_swingl9 =[      $swingl9,      supsham_run1  ] {
ai_charge(8);
//dprint("completed left swing\n");
makevectors(self.angles);

if (supsham_attack_check())
{
	self.think = supsham_magic1;
}
else if (random()<0.5)
	self.think = supsham_swingr1;
};

float() supsham_attack_check =
{
	local float cap;
	cap = 3 + floor(random() * 2 + 0.5);
	if (serverflags & BLOODY_NIGHTMARE_ACTIVE)
		cap = cap - 1;
	
	self.count++;

	if (self.count > cap)
		return TRUE;
	else
		return FALSE;
};

void() supsham_swingr1	=[      $swingr1,      supsham_swingr2   ] {
sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
ai_charge(1);};
void() supsham_swingr2	=[      $swingr2,      supsham_swingr3   ] {ai_charge(8);};
void() supsham_swingr3 =[      $swingr3,      supsham_swingr4   ] {ai_charge(14);};
void() supsham_swingr4 =[      $swingr4,      supsham_swingr5   ] {ai_charge(7);};
void() supsham_swingr5 =[      $swingr5,      supsham_swingr6   ] {ai_charge(3);};
void() supsham_swingr6 =[      $swingr6,      supsham_swingr7   ] {ai_charge(6);};
void() supsham_swingr7 =[      $swingr7,      supsham_swingr8   ] {blast2(v_right * -16 + '0 0 32');ai_charge(6); SupShamClaw(-250);};
void() supsham_swingr8 =[      $swingr8,      supsham_swingr9   ] {ai_charge(3);};
void() supsham_swingr9 =[      $swingr9,      supsham_run1  ] {ai_charge(1);
ai_charge(10);
//dprint("completed right swing\n");
makevectors(self.angles);
if (supsham_attack_check())
{
	self.think = supsham_magic1;
}
else if (random()<0.5)
	self.think = supsham_swingl1;
};

void() supsham_melee =
{
	local float chance, dist;
	local vector vec;


	vec = self.origin - self.enemy.origin;
	dist = vlen(vec);
	if (dist < 110)
	{
		if (random() < 0.8)
			supsham_smash1();
		else if (random() < 0.5)
			supsham_swingl1();
		else
			supsham_swingr1();
	}
	else if ((dist < 200) || (self.wait > time))
	{
		makevectors(self.angles);
		chance = v_right * normalize(vec);
		/*dprint("dot is: ");
		dprint(ftos(chance));
		dprint("\n");
		*/
		if (chance < 0.45)
			supsham_swingr1();
		else if (chance < 0.9)
			supsham_swingl1();
		else
			supsham_smash1();
	}
	else // standard lightning 
	{
		self.count = 0;
		if (random() > 0.4)
		{
			supsham_magic1();
			self.wait = time + 5; // rate limit the lightning
		}
		else
		{
			supsham_magic_b1(); // normal fast lightning
			self.wait = time + 3; // rate limit the lightning
		}
	}
};

//============================================================================

void() SupCastLightning =
{
	local	vector	org, dir;
	local float dist;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

	org = self.origin + '0 0 40';

	dir = self.enemy.origin + '0 0 16' - org;
	dist = vlen(dir);
	dir = normalize (dir);
	if (dist < 600)
		dist = 600;
	else if (dist > 1000)
	{
		dist = 1000;
	}

	//traceline (org, self.origin + dir*600, TRUE, self)
	traceline (org, self.origin + dir*dist, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	// overload the frags field which is unused on enemies
	self.frags += 1;

	LightningDamage (org, trace_endpos, self, 10);
};


void() supsham_magic1     =[      $magic1,       supsham_magic2    ] {ai_face();
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
	self.count = 0;
};
void() supsham_magic2     =[      $magic2,       supsham_magic3    ] {ai_face();};
void() supsham_magic3     =[      $magic3,       supsham_magic4    ] {ai_face();self.nextthink = self.nextthink + 0.2;
local entity o;

self.effects = self.effects | EF_MUZZLEFLASH;
ai_face();
self.child = spawn();
o = self.child;
o.owner = self;
o.classname = "lightning_child";
setmodel (o, "progs/s_light.mdl");
setorigin (o, self.origin);
o.angles = self.angles;
o.nextthink = time + 1.4;
o.think = SUB_Remove;
};
void() supsham_magic4     =[      $magic4,       supsham_magic5    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(1);
};
void() supsham_magic5     =[      $magic5,       supsham_magic4b    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(2);
};
void() supsham_magic4b     =[      $magic4,       supsham_magic5b    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(3);
};
void() supsham_magic5b     =[      $magic5,       supsham_magic4c    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(2);
};
void() supsham_magic4c     =[      $magic4,       supsham_magic5c    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(1);
};
void() supsham_magic5c     =[      $magic5,       supsham_magic6    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(2);
//if (self.count < skill+1)
//	spawn_orb(self.origin + '0 0 128');
};
void() supsham_magic6     =[      $magic6,       supsham_magic9    ]
{
supsham_removechild();
SupCastLightning();
sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void() supsham_magic9     =[      $magic9,       supsham_magic10   ]
{SupCastLightning();};
void() supsham_magic10    =[      $magic10,      supsham_magic11   ]
{SupCastLightning();};
void() supsham_magic11    =[      $magic11,      supsham_magic12   ] {};
void() supsham_magic12    =[      $magic12,      supsham_run1	   ] {};

//===============================================================================
void() supsham_magic_b1     =[      $magic1,       supsham_magic_b2    ] {ai_face();
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
	self.count = 0;
};
void() supsham_magic_b2     =[      $magic2,       supsham_magic_b3    ] {ai_face();};
void() supsham_magic_b3     =[      $magic3,       supsham_magic_b4    ] {ai_face();self.nextthink = self.nextthink + 0.2;
local entity o;

self.effects = self.effects | EF_MUZZLEFLASH;
ai_face();
self.child = spawn();
o = self.child;
setmodel (o, "progs/s_light.mdl");
setorigin (o, self.origin);
o.angles = self.angles;
o.nextthink = time + 0.7;
o.think = SUB_Remove;
};
void() supsham_magic_b4     =[      $magic4,       supsham_magic_b5    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(1);
};
void() supsham_magic_b5     =[      $magic5,       supsham_magic_b6    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
supsham_setchildframe(2);
};
void() supsham_magic_b6     =[      $magic6,       supsham_magic_b9    ]
{
supsham_removechild();
SupCastLightning();
sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void() supsham_magic_b9     =[      $magic9,       supsham_magic_b10   ]
{SupCastLightning();};
void() supsham_magic_b10    =[      $magic10,      supsham_magic_b11   ]
{SupCastLightning();};
void() supsham_magic_b11    =[      $magic11,      supsham_magic_b12   ] {};
void() supsham_magic_b12    =[      $magic12,      supsham_run1	   ] {};
//===============================================================================

void(float f) supsham_setchildframe =
{
	if (self.child && (self.child.owner == self) && (self.child.classname == "lightning_child"))
		self.child.frame = f;
}

void() supsham_removechild =
{
	if (self.child)
	{
		if ((self.child.owner == self) && (self.child.classname == "lightning_child"))
		{
			dprint("removing shambler's child: "); dprint(self.child.classname); dprint("\n");
			remove(self.child);
		}
		else
		{
			dprint("Don't remove! Shambler's child is stale, referencing: "); dprint(self.child.classname); dprint("\n");
		}
	}
	self.child = world;
}

void() supsham_pain1       =[      $pain1, supsham_pain2      ] {};
void() supsham_pain2       =[      $pain2, supsham_pain3      ] {};

void() supsham_pain3       =[      $pain3, supsham_pain4      ] {};
void() supsham_pain4       =[      $pain4, supsham_pain5      ] {};
void() supsham_pain5       =[      $pain5, supsham_pain6      ] {};
void() supsham_pain6       =[      $pain6, supsham_run1      ] {};

void(entity attacker, float damage)	supsham_pain =
{
	sound (self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM);

	if (damage >= self.health && attacker.classname == "player" && attacker.weapon == IT_AXE)
	{
		msg_entity = attacker;
		WriteByte (MSG_ONE, SVC_ACHIEVEMENT);
		WriteString(MSG_ONE, "ACH_CLOSE_SHAVE");
	}

	// overload frags field for shambler dance achievement
	if (damage >= self.health && attacker.classname == "player" && self.frags == 0)
	{
		msg_entity = attacker;
	    WriteByte (MSG_ONE, SVC_ACHIEVEMENT);
	    WriteString(MSG_ONE, "ACH_SHAMBLER_DANCE");
	}

	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (25 + random()*400 > damage)
		return;		// didn't flinch

	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 5;

	supsham_removechild();
		
	//spawn_tfog(self.origin + '0 0 24');
	supsham_pain1 ();
};


//============================================================================
void() cleanup_orbs =
{
	// clean up children orbs
	local entity f;
	f = find(world, classname, "monster_super_shambler");
	while (f)
	{
		if (f.owner && f.owner == self)
		{
			/*dprint("removing entity: ");
			dprint(f.classname);
			dprint("\n");*/
			f.think = f.th_die;
			f.nextthink = time + 0.1;
		}
		f = find(f, classname, "monster_super_shambler");
	}	
}

void() supsham_death1      =[      $death1,       supsham_death2     ] {};
void() supsham_death2      =[      $death2,       supsham_death3     ] {};
void() supsham_death3      =[      $death3,       supsham_death4     ]
{
	self.solid = SOLID_NOT;

	cleanup_orbs();

};
void() supsham_death4      =[      $death4,       supsham_death5     ] {};
void() supsham_death5      =[      $death5,       supsham_death6     ] {};
void() supsham_death6      =[      $death6,       supsham_death7     ] {};
void() supsham_death7      =[      $death7,       supsham_death8     ] {};
void() supsham_death8      =[      $death8,       supsham_death9     ] {};
void() supsham_death9      =[      $death9,       supsham_death10    ] {};
void() supsham_death10     =[      $death10,      supsham_death11    ] {};
void() supsham_death11     =[      $CORPSEFRAME_SHAMBLER_1,      supsham_death11    ] {};

void() supsham_die =
{
	supsham_removechild();

// check for gib
	if (self.health < -60)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_shams.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);

		//cleanup_orbs();
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM);
	supsham_death1 ();
};

//============================================================================


/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_super_shambler =
{
	precache_model ("progs/shambler_blood.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");
	
	//precache_model ("progs/missile.mdl");
	precache_model ("progs/zom_gib.mdl");
	precache_sound ("zombie/z_shot1.wav");
	//precache_sound ("hknight/attack1.wav");
	
	//precache_model("progs/teleporter_eye.mdl");
	precache_model("progs/k_spike.mdl");
	precache_sound("hknight/attack1.wav");

	precache_model ("progs/rogue/plasma.mdl");
	

	self.health = 2000;

	self.th_stand = supsham_stand1;
	self.th_walk = supsham_walk1;
	self.th_run = supsham_run1;
	self.th_die = supsham_die;
	self.th_melee = supsham_melee;
	//self.th_missile = supsham_magic1;
	//self.th_missile = supsham_missile;
	self.th_missile = supsham_melee;
	self.th_pain = supsham_pain;
	self.allowPathFind = TRUE;
	self.combat_style = CS_MIXED;

	// overload frags for lightning attack counts
	self.frags = 0;
	
	self.classname = "monster_super_shambler";

	InitMonster("progs/shambler_blood.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_LARGE);
};

/*
.entity supsham_ghost1;
.entity supsham_ghost2;
.float supsham_prior_frame1;
.float supsham_prior_frame2;
*/

void() supsham_missile =
{
	local float o;
	o = random();
	if (o < 0.36)
		supsham_magic1 ();
	else if (o < 0.66)
		supsham_swingr1 ();
	else
		supsham_swingl1 ();
}

void(vector pos_offset) blast1 =
{
	local float a;
	local float b;
	a = -5;
	b = fabs(a);
	//a = -2;
	//while (a < 4)
	while (a <= b)
	{
		supsham_shot(a, pos_offset);
		a++;
	}
	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);
	//sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
}



void(float offset, vector pos_offset) supsham_shot =
{
	local	vector	offang;
	local	vector	org, vec;

	offang = vectoangles (self.enemy.origin - self.origin);
	//offang_y = offang_y + offset * 12;
	offang_y = offang_y + offset * 5;

	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	org = org + pos_offset; 

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	
	launch_spike (org, vec);
	newmis.classname = "knightspike";
	//setmodel (newmis, "progs/zom_gib.mdl");
	//newmis.avelocity = '3000 1000 2000';
	setmodel (newmis, "progs/rogue/plasma.mdl");
	newmis.avelocity = '300 300 300';
	newmis.avelocity_x *= crandom();
	newmis.avelocity_y *= crandom();
	newmis.avelocity_z *= crandom();

	//setmodel (newmis, "progs/missile.mdl");
	newmis.movetype = MOVETYPE_TOSS;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*((crandom()*100)+400);
	newmis.velocity_z = 125 + (crandom() * 50);
	newmis.velocity_z+= get_z_offset();
	
	newmis.effects (+) EF_CANDLELIGHT; 
};

void(vector pos_offset) blast2 =
{
	// This shot is thrown from the hands!
	local float x;
	local float y;
	x = -1;
	y = -1;
	while (x < 2)
	{
		y = -1;
		while (y < 2)
		{
			supsham_shot2(x, y, pos_offset);
			y++;
		}
		x++;
	}
}

float() get_z_offset=
{
	local float z_boost;
	z_boost = (self.enemy.origin_z - self.origin_z);
	if (z_boost > 30) // shambler is below the player
	{
		z_boost = 100 + crandom() * 50; 
	}
	else if (z_boost < -30)
	{
		z_boost = -100 + crandom() * 50;
	}
	else // boost based on distance instead of on height!
	{
		z_boost = vlen(self.enemy.origin - self.origin);
		if (z_boost > 300)
		{
			z_boost = 50 + crandom() *25;
		}
		else if (z_boost < 150)
		{
			z_boost = -50 + crandom() *25;
		}
		else
			z_boost = 0;
	}

	return z_boost;
}

void(float offset_y, float offset_z, vector pos_offset) supsham_shot2 =
{
	// This shot is thrown from the hands!
	local	vector	offang;
	local	vector	org, vec;

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset_y * (12 + (crandom() * 4));
	offang_x = offang_x + offset_z * (12 + (crandom() * 4));
	
	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	org = org + pos_offset; 

// set missile speed
	vec = normalize (v_forward);
	//vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	
	launch_spike (org, vec);
	newmis.classname = "knightspike";
	//setmodel (newmis, "progs/zom_gib.mdl");
	//newmis.avelocity = '3000 1000 2000';
	setmodel (newmis, "progs/rogue/plasma.mdl");
	newmis.avelocity = '300 300 300';
	newmis.avelocity_x *= crandom();
	newmis.avelocity_y *= crandom();
	newmis.avelocity_z *= crandom();
	newmis.movetype = MOVETYPE_TOSS;
	//setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*((crandom()*100)+500);
	newmis.velocity_z = 100 + (crandom() * 50);
	newmis.velocity_z += get_z_offset();
	
	newmis.effects (+) EF_CANDLELIGHT;
	
};
