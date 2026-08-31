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

KNIGHT

==============================================================================
*/

$cd id1/models/knight2
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 CORPSEFRAME_rknight_1

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame CORPSEFRAME_rknight_2

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


void() rknight_run1;
void() rk_idle_sound;

void(float offset, float variant) rknight_shot =
{
	local	vector	offang;
	local	vector	org, vec;
	
	

	if (!variant)
	{
		offang = vectoangles (self.enemy.origin - self.origin);
		offang_y = offang_y + offset * 6;
		
		makevectors (offang);
		
		org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

		// set missile speed
		vec = normalize (v_forward);
		vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	}
	else
	{
		makevectors (self.angles);
		org = self.origin + self.mins + self.size*0.5 + v_forward * 10;

		// rewrite to avoid angles
		vec = normalize(self.enemy.origin - self.origin);
		local float nudge;
		nudge = 0.017 * offset * 6; // 0.017 is equivalent to 1 degree
		if (variant == 1)
		{
			org_z += 10;
			vec_z += nudge; 
			vec_y += (random() - 0.5) * 0.2;
		}
		else if (variant == 2)
		{
			org_z += 14;
			vec_y += (random() - 0.5) * 0.1 * (offset+2);
			vec_z += (random() - 0.5) * 0.1 * (offset+2);
		}
		vec = normalize(vec);
	}

	//if (!variant)
	//	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	//else
	//	vec_y = 0 - vec_y + (random() - 0.5) *0.1;
	
	launch_spike (org, vec);
	newmis.classname = "knightspike";
	setmodel (newmis, "progs/diamond_trail.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (serverflags & BLOODY_NIGHTMARE_ACTIVE)		
		newmis.velocity = vec*600;
	else
		newmis.velocity = vec*400;
	newmis.effects = EF_CANDLELIGHT;
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

//===========================================================================

void()	rknight_stand1	=[	$stand1,	rknight_stand2	] {ai_stand();};
void()	rknight_stand2	=[	$stand2,	rknight_stand3	] {ai_stand();};
void()	rknight_stand3	=[	$stand3,	rknight_stand4	] {ai_stand();};
void()	rknight_stand4	=[	$stand4,	rknight_stand5	] {ai_stand();};
void()	rknight_stand5	=[	$stand5,	rknight_stand6	] {ai_stand();};
void()	rknight_stand6	=[	$stand6,	rknight_stand7	] {ai_stand();};
void()	rknight_stand7	=[	$stand7,	rknight_stand8	] {ai_stand();};
void()	rknight_stand8	=[	$stand8,	rknight_stand9	] {ai_stand();};
void()	rknight_stand9	=[	$stand9,	rknight_stand1	] {ai_stand();};

//===========================================================================

void()	rknight_walk1	=[	$walk1,		rknight_walk2	] {
rk_idle_sound();
ai_walk(2);};
void()	rknight_walk2	=[	$walk2,		rknight_walk3	] {ai_walk(5);};
void()	rknight_walk3	=[	$walk3,		rknight_walk4	] {ai_walk(5);};
void()	rknight_walk4	=[	$walk4,		rknight_walk5	] {ai_walk(4);};
void()	rknight_walk5	=[	$walk5,		rknight_walk6	] {ai_walk(4);};
void()	rknight_walk6	=[	$walk6,		rknight_walk7	] {ai_walk(2);};
void()	rknight_walk7	=[	$walk7,		rknight_walk8	] {ai_walk(2);};
void()	rknight_walk8	=[	$walk8,		rknight_walk9	] {ai_walk(3);};
void()	rknight_walk9	=[	$walk9,		rknight_walk10	] {ai_walk(3);};
void()	rknight_walk10	=[	$walk10,	rknight_walk11	] {ai_walk(4);};
void()	rknight_walk11	=[	$walk11,	rknight_walk12	] {ai_walk(3);};
void()	rknight_walk12	=[	$walk12,	rknight_walk13	] {ai_walk(4);};
void()	rknight_walk13	=[	$walk13,	rknight_walk14	] {ai_walk(6);};
void()	rknight_walk14	=[	$walk14,	rknight_walk15	] {ai_walk(2);};
void()	rknight_walk15	=[	$walk15,	rknight_walk16	] {ai_walk(2);};
void()	rknight_walk16	=[	$walk16,	rknight_walk17	] {ai_walk(4);};
void()	rknight_walk17	=[	$walk17,	rknight_walk18	] {ai_walk(3);};
void()	rknight_walk18	=[	$walk18,	rknight_walk19	] {ai_walk(3);};
void()	rknight_walk19	=[	$walk19,	rknight_walk20	] {ai_walk(3);};
void()	rknight_walk20	=[	$walk20,	rknight_walk1	] {ai_walk(2);};


//===========================================================================
void()	rknight_runb1	=[	$walk1,		rknight_runb2	] {
rk_idle_sound();
ai_run(2);};
void()	rknight_runb2	=[	$walk2,		rknight_runb3	] {ai_run(5);};
void()	rknight_runb3	=[	$walk3,		rknight_runb4	] {ai_run(5);};
void()	rknight_runb4	=[	$walk4,		rknight_runb5	] {ai_run(4);};
void()	rknight_runb5	=[	$walk5,		rknight_runb6	] {ai_run(4);};
void()	rknight_runb6	=[	$walk6,		rknight_runb7	] {ai_run(2);};
void()	rknight_runb7	=[	$walk7,		rknight_runb8	] {ai_run(2);};
void()	rknight_runb8	=[	$walk8,		rknight_runb9	] {ai_run(3);};
void()	rknight_runb9	=[	$walk9,		rknight_runb10	] {ai_run(3);};
void()	rknight_runb10	=[	$walk10,	rknight_runb11	] {ai_run(4);};
void()	rknight_runb11	=[	$walk11,	rknight_runb12	] {ai_run(3);};
void()	rknight_runb12	=[	$walk12,	rknight_runb13	] {ai_run(4);};
void()	rknight_runb13	=[	$walk13,	rknight_runb14	] {ai_run(6);};
void()	rknight_runb14	=[	$walk14,	rknight_runb15	] {ai_run(2);};
void()	rknight_runb15	=[	$walk15,	rknight_runb16	] {ai_run(2);};
void()	rknight_runb16	=[	$walk16,	rknight_runb17	] {ai_run(4);};
void()	rknight_runb17	=[	$walk17,	rknight_runb18	] {ai_run(3);};
void()	rknight_runb18	=[	$walk18,	rknight_runb19	] {ai_run(3);};
void()	rknight_runb19	=[	$walk19,	rknight_runb20	] {ai_run(3);};
void()	rknight_runb20	=[	$walk20,	rknight_runb1	] {ai_run(2);};
//===========================================================================

void()	rknight_run1	=[	$run1,		rknight_run2	] {
rk_idle_sound();
ai_run (20);};
void()	rknight_run2	=[	$run2,		rknight_run3	] {ai_run(25);};
void()	rknight_run3	=[	$run3,		rknight_run4	] {ai_run(18);};
void()	rknight_run4	=[	$run4,		rknight_run5	] {ai_run(16);};
void()	rknight_run5	=[	$run5,		rknight_run6	] {ai_run(14);};
void()	rknight_run6	=[	$run6,		rknight_run7	] {ai_run(25);};
void()	rknight_run7	=[	$run7,		rknight_run8	] {ai_run(21);};
void()	rknight_run8	=[	$run8,		rknight_run1	] {ai_run(13);};



//============================================================================
void() rknight_pain_sound =
{
	local float r;
	r = random();
	if (r < 0.3)
		sound (self, CHAN_VOICE, "rknight/pain_01.wav", 1, ATTN_NORM);
	else if (r < 0.6)
		sound (self, CHAN_VOICE, "rknight/pain_02.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "rknight/pain_03.wav", 1, ATTN_NORM);
};

void()	rknight_pain1	=[	$pain1,		rknight_pain2	] {rknight_pain_sound();};
void()	rknight_pain2	=[	$pain2,		rknight_pain3	] {};
void()	rknight_pain3	=[	$pain3,		rknight_pain4	] {};
void()	rknight_pain4	=[	$pain4,		rknight_pain5	] {};
void()	rknight_pain5	=[	$pain5,		rknight_run	] {};

//============================================================================

void()	rknight_die1	=[	$death1,	rknight_die2	] {ai_forward(10);};
void()	rknight_die2	=[	$death2,	rknight_die3	] {ai_forward(8);};
void()	rknight_die3	=[	$death3,	rknight_die4	]
{self.solid = SOLID_NOT; ai_forward(7);};
void()	rknight_die4	=[	$death4,	rknight_die5	] {};
void()	rknight_die5	=[	$death5,	rknight_die6	] {};
void()	rknight_die6	=[	$death6,	rknight_die7	] {};
void()	rknight_die7	=[	$death7,	rknight_die8	] {};
void()	rknight_die8	=[	$death8,	rknight_die9	] {ai_forward(10);};
void()	rknight_die9	=[	$death9,	rknight_die10	] {ai_forward(11);};
void()	rknight_die10	=[	$death10,	rknight_die11	] {};
void()	rknight_die11	=[	$death11,	rknight_die12	] {};
void()	rknight_die12	=[	$CORPSEFRAME_rknight_1,	rknight_die12	] {};

void()	rknight_dieb1	=[	$deathb1,	rknight_dieb2	] {};
void()	rknight_dieb2	=[	$deathb2,	rknight_dieb3	] {};
void()	rknight_dieb3	=[	$deathb3,	rknight_dieb4	]
{self.solid = SOLID_NOT;};
void()	rknight_dieb4	=[	$deathb4,	rknight_dieb5	] {};
void()	rknight_dieb5	=[	$deathb5,	rknight_dieb6	] {};
void()	rknight_dieb6	=[	$deathb6,	rknight_dieb7	] {};
void()	rknight_dieb7	=[	$deathb7,	rknight_dieb8	] {};
void()	rknight_dieb8	=[	$deathb8,	rknight_dieb9	] {};
void()	rknight_dieb9	=[	$CORPSEFRAME_rknight_2,	rknight_dieb9	]{};

void() rknight_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_hellkn.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "rknight/death_01.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "rknight/death_02.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		rknight_die1 ();
	else
		rknight_dieb1 ();
};


//============================================================================

void()	rknight_magica1 =[	$magica1,	rknight_magica2	] {ai_face();};
void()	rknight_magica2 =[	$magica2,	rknight_magica3	] {ai_face();};
void()	rknight_magica3 =[	$magica3,	rknight_magica4	] {ai_face();};
void()	rknight_magica4 =[	$magica4,	rknight_magica5	] {ai_face();};
void()	rknight_magica5 =[	$magica5,	rknight_magica6	] {ai_face();};
void()	rknight_magica6 =[	$magica6,	rknight_magica7	] {ai_face();};
void()	rknight_magica7 =[	$magica7,	rknight_magica8	] {ai_face();};//rknight_shot(3, 1);};
void()	rknight_magica8 =[	$magica8,	rknight_magica9	] {ai_face();rknight_shot(1.5, 1);};
void()	rknight_magica9 =[	$magica9,	rknight_magica10] {ai_face();rknight_shot(0.5, 1);};
void()	rknight_magica10 =[	$magica10,	rknight_magica11] {ai_face();rknight_shot(-0.5, 1);};
void()	rknight_magica11 =[	$magica11,	rknight_magica12] {ai_face();rknight_shot(-1.5, 1);};
void()	rknight_magica12 =[	$magica12,	rknight_magica13] {ai_face();rknight_shot(-2.5, 1);};
void()	rknight_magica13 =[	$magica13,	rknight_magica14] {ai_face();};
void()	rknight_magica14 =[	$magica14,	rknight_run	] {ai_face();};

//============================================================================

void()	rknight_magicb1 =[	$magicb1,	rknight_magicb2	] {ai_face();};
void()	rknight_magicb2 =[	$magicb2,	rknight_magicb3	] {ai_face();};
void()	rknight_magicb3 =[	$magicb3,	rknight_magicb4	] {ai_face();};
void()	rknight_magicb4 =[	$magicb4,	rknight_magicb5	] {ai_face();};
void()	rknight_magicb5 =[	$magicb5,	rknight_magicb6	] {ai_face();};
void()	rknight_magicb6 =[	$magicb6,	rknight_magicb7	] {ai_face();self.ammo_nails = floor(random()*8 +0.5);};
void()	rknight_magicb7 =[	$magicb7,	rknight_magicb8	] {ai_face();rknight_shot(-2, 2);};
void()	rknight_magicb8 =[	$magicb8,	rknight_magicb9	] {ai_face();rknight_shot(-1, 2);};
void()	rknight_magicb9 =[	$magicb9,	rknight_magicb10] {ai_face();rknight_shot(0, 2);};
void()	rknight_magicb10 =[	$magicb10,	rknight_magicb11] {ai_face();rknight_shot(1, 2);};
void()	rknight_magicb11 =[	$magicb11,	rknight_magicb12] {ai_face();rknight_shot(2, 2);};
void()	rknight_magicb12 =[	$magicb12,	rknight_magicb13]
{
	
	ai_face();
	rknight_shot(3, 2);
	self.ammo_nails--;
	if (self.ammo_nails > 0)
		self.think = rknight_magicb12;
};
void()	rknight_magicb13 =[	$magicb13,	rknight_run] {ai_face();};

//============================================================================

void()	rknight_magicc1 =[	$magicc1,	rknight_magicc2	] {ai_face();};
void()	rknight_magicc2 =[	$magicc2,	rknight_magicc3	] {ai_face();};
void()	rknight_magicc3 =[	$magicc3,	rknight_magicc4	] {ai_face();};
void()	rknight_magicc4 =[	$magicc4,	rknight_magicc5	] {ai_face();};
void()	rknight_magicc5 =[	$magicc5,	rknight_magicc6	] {ai_face();};
void()	rknight_magicc6 =[	$magicc6,	rknight_magicc7	] {rknight_shot(-2, 0);};
void()	rknight_magicc7 =[	$magicc7,	rknight_magicc8	] {rknight_shot(-1, 0);};
void()	rknight_magicc8 =[	$magicc8,	rknight_magicc9	] {rknight_shot(0, 0);};
void()	rknight_magicc9 =[	$magicc9,	rknight_magicc10] {rknight_shot(1, 0);};
void()	rknight_magicc10 =[	$magicc10,	rknight_magicc11] {rknight_shot(2, 0);};
void()	rknight_magicc11 =[	$magicc11,	rknight_run] {rknight_shot(3, 0);};

//===========================================================================

void()	rknight_slice1	=[	$slice1,	rknight_slice2	] {ai_charge(9);};
void()	rknight_slice2	=[	$slice2,	rknight_slice3	] {ai_charge(6);};
void()	rknight_slice3	=[	$slice3,	rknight_slice4	] {ai_charge(13);};
void()	rknight_slice4	=[	$slice4,	rknight_slice5	] {ai_charge(4);};
void()	rknight_slice5	=[	$slice5,	rknight_slice6	] {ai_charge(7); ai_melee();};
void()	rknight_slice6	=[	$slice6,	rknight_slice7	] {ai_charge(15); ai_melee();};
void()	rknight_slice7	=[	$slice7,	rknight_slice8	] {ai_charge(8); ai_melee();};
void()	rknight_slice8	=[	$slice8,	rknight_slice9	] {ai_charge(2); ai_melee();};
void()	rknight_slice9	=[	$slice9,	rknight_slice10	] {ai_melee();};
void()	rknight_slice10	=[	$slice10,	rknight_run	] {ai_charge(3);};

//===========================================================================

void()	rknight_smash1	=[	$smash1,	rknight_smash2	] {ai_charge(1);};
void()	rknight_smash2	=[	$smash2,	rknight_smash3	] {ai_charge(13);};
void()	rknight_smash3	=[	$smash3,	rknight_smash4	] {ai_charge(9);};
void()	rknight_smash4	=[	$smash4,	rknight_smash5	] {ai_charge(11);};
void()	rknight_smash5	=[	$smash5,	rknight_smash6	] {ai_charge(10); ai_melee();};
void()	rknight_smash6	=[	$smash6,	rknight_smash7	] {ai_charge(7); ai_melee();};
void()	rknight_smash7	=[	$smash7,	rknight_smash8	] {ai_charge(12); ai_melee();};
void()	rknight_smash8	=[	$smash8,	rknight_smash9	] {ai_charge(2); ai_melee();};
void()	rknight_smash9	=[	$smash9,	rknight_smash10	] {ai_charge(3); ai_melee();};
void()	rknight_smash10	=[	$smash10,	rknight_smash11	] {ai_charge(0);};
void()	rknight_smash11	=[	$smash11,	rknight_run	] {ai_charge(0);};

//============================================================================

void()	rknight_watk1	=[	$w_attack1,	rknight_watk2	] {ai_charge(2);};
void()	rknight_watk2	=[	$w_attack2,	rknight_watk3	] {ai_charge(0);};
void()	rknight_watk3	=[	$w_attack3,	rknight_watk4	] {ai_charge(0);};
void()	rknight_watk4	=[	$w_attack4,	rknight_watk5	] {ai_melee();};
void()	rknight_watk5	=[	$w_attack5,	rknight_watk6	] {ai_melee();};
void()	rknight_watk6	=[	$w_attack6,	rknight_watk7	] {ai_melee();};
void()	rknight_watk7	=[	$w_attack7,	rknight_watk8	] {ai_charge(1);};
void()	rknight_watk8	=[	$w_attack8,	rknight_watk9	] {ai_charge(4);};
void()	rknight_watk9	=[	$w_attack9,	rknight_watk10	] {ai_charge(5);};
void()	rknight_watk10	=[	$w_attack10,	rknight_watk11	] {ai_charge(3); ai_melee();};
void()	rknight_watk11	=[	$w_attack11,	rknight_watk12	] {ai_charge(2); ai_melee();};
void()	rknight_watk12	=[	$w_attack12,	rknight_watk13	] {ai_charge(2); ai_melee();};
void()	rknight_watk13	=[	$w_attack13,	rknight_watk14	] {ai_charge(0);};
void()	rknight_watk14	=[	$w_attack14,	rknight_watk15	] {ai_charge(0);};
void()	rknight_watk15	=[	$w_attack15,	rknight_watk16	] {ai_charge(0);};
void()	rknight_watk16	=[	$w_attack16,	rknight_watk17	] {ai_charge(1);};
void()	rknight_watk17	=[	$w_attack17,	rknight_watk18	] {ai_charge(1); ai_melee();};
void()	rknight_watk18	=[	$w_attack18,	rknight_watk19	] {ai_charge(3); ai_melee();};
void()	rknight_watk19	=[	$w_attack19,	rknight_watk20	] {ai_charge(4); ai_melee();};
void()	rknight_watk20	=[	$w_attack20,	rknight_watk21	] {ai_charge(6);};
void()	rknight_watk21	=[	$w_attack21,	rknight_watk22	] {ai_charge(7);};
void()	rknight_watk22	=[	$w_attack22,	rknight_run	] {ai_charge(3);};

//============================================================================

void() rk_idle_sound =
{
	local float r;
	if (random() < 0.2)
	{
		r = random();
		if (r < 0.3)
			sound (self, CHAN_VOICE, "rknight/idle_02.wav", 1, ATTN_NORM);
		else if (r < 0.6)
			sound (self, CHAN_VOICE, "rknight/idle_03.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "rknight/idle_05.wav", 1, ATTN_NORM);
	}
};

void(entity attacker, float damage)	rknight_pain =
{
	if (self.pain_finished > time)
		return;

	//sound (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);

	if (time - self.pain_finished > 5)
	{	// allways go into pain frame if it has been a while
		rknight_pain1 ();
		self.pain_finished = time + 1;
		return;
	}
	
	if ((random()*30 > damage) )
		return;		// didn't flinch

	self.pain_finished = time + 1;
	rknight_pain1 ();
};

float	rknight_type;

void() rknight_melee =
{
	rknight_type = rknight_type + 1;

	sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
	if (rknight_type == 1)
		rknight_slice1 ();
	else if (rknight_type == 2)
		rknight_smash1 ();
	else if (rknight_type == 3)
	{
		rknight_watk1 ();
		rknight_type = 0;
	}
};

void() rknight_magic =
{
	local float r;  
	local vector vec;
	vec = self.enemy.origin - self.origin;
	if (vlen(vec) > 300)
		r = 0.6;
	else
		r = 0.2;

	if (random() < r)
		rknight_magicb1();
	else
	{
		r = 0.5;
		if (vec_z > 100)
			r = 0.7;
		
		if (random() > r)
			rknight_magica1();
		else
			rknight_magicc1();
	}
};

/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_ranged_knight =
{
	//self.classname = "monster_hell_knight";
	precache_model2 ("progs/rknight.mdl");
	//precache_model2 ("progs/k_spike.mdl");
	precache_model("progs/diamond_trail.mdl");
	precache_model2 ("progs/h_hellkn.mdl");

	
	precache_sound2 ("hknight/attack1.wav");
	//precache_sound2 ("hknight/death1.wav");
	//precache_sound2 ("hknight/pain1.wav");
	//precache_sound2 ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	//precache_sound2 ("hknight/idle.wav");
	//precache_sound2 ("hknight/grunt.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");

	precache_sound2 ("rknight/idle_02.wav");
	precache_sound2 ("rknight/idle_03.wav");
	precache_sound2 ("rknight/idle_05.wav");
	
	precache_sound2 ("rknight/death_01.wav");
	precache_sound2 ("rknight/death_02.wav");

	precache_sound2 ("rknight/sight_01.wav");
	precache_sound2 ("rknight/sight_03.wav");

	precache_sound2 ("rknight/pain_01.wav");
	precache_sound2 ("rknight/pain_02.wav");
	precache_sound2 ("rknight/pain_03.wav");
	
	self.health = 250; // is 250 for normal hknights

	self.th_stand = rknight_stand1;
	self.th_walk = rknight_walk1;
	if (self.spawnflags & 2)
		self.th_run = rknight_runb1;
	else
		self.th_run = rknight_run1;
	//self.th_melee = rknight_melee;
	self.th_missile = rknight_magic;
	self.th_pain = rknight_pain;
	self.th_die = rknight_die;
	self.allowPathFind = TRUE;
	self.combat_style = CS_RANGED;
	
	InitMonster("progs/rknight.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_SMALL);
};

void() rknight_run =
{
	if (self.spawnflags & 2)
	{
		rknight_runb1();
	}
	else
	{
		rknight_run1();
	}
}
