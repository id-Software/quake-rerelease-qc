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

ZOMBIE

==============================================================================
*/
$cd id1/models/zombie

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15
//16
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
//19
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18
//18
$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13
//13
$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14
//14
$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12
//12
$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12
//12
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28
//28
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18
//18
$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13
//13
$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30
//1
$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

//=============================================================================

.float inpain;

void() szombie_stand1	=[	$stand1,		szombie_stand2	] {ai_stand();};
void() szombie_stand2	=[	$stand2,		szombie_stand3	] {ai_stand();};
void() szombie_stand3	=[	$stand3,		szombie_stand4	] {ai_stand();};
void() szombie_stand4	=[	$stand4,		szombie_stand5	] {ai_stand();};
void() szombie_stand5	=[	$stand5,		szombie_stand6	] {ai_stand();};
void() szombie_stand6	=[	$stand6,		szombie_stand7	] {ai_stand();};
void() szombie_stand7	=[	$stand7,		szombie_stand8	] {ai_stand();};
void() szombie_stand8	=[	$stand8,		szombie_stand9	] {ai_stand();};
void() szombie_stand9	=[	$stand9,		szombie_stand10	] {ai_stand();};
void() szombie_stand10	=[	$stand10,		szombie_stand11	] {ai_stand();};
void() szombie_stand11	=[	$stand11,		szombie_stand12	] {ai_stand();};
void() szombie_stand12	=[	$stand12,		szombie_stand13	] {ai_stand();};
void() szombie_stand13	=[	$stand13,		szombie_stand14	] {ai_stand();};
void() szombie_stand14	=[	$stand14,		szombie_stand15	] {ai_stand();};
void() szombie_stand15	=[	$stand15,		szombie_stand1	] {ai_stand();};


void() szombie_hang1	=	[	$paine1,		szombie_hang1	] {};

void() szombie_walk1		=[	$walk1,		szombie_walk2	] {ai_walk(0);};
void() szombie_walk2		=[	$walk2,		szombie_walk3	] {ai_walk(2);};
void() szombie_walk3		=[	$walk3,		szombie_walk4	] {ai_walk(3);};
void() szombie_walk4		=[	$walk4,		szombie_walk5	] {ai_walk(2);};
void() szombie_walk5		=[	$walk5,		szombie_walk6	] {ai_walk(1);};
void() szombie_walk6		=[	$walk6,		szombie_walk7	] {ai_walk(0);};
void() szombie_walk7		=[	$walk7,		szombie_walk8	] {ai_walk(0);};
void() szombie_walk8		=[	$walk8,		szombie_walk9	] {ai_walk(0);};
void() szombie_walk9		=[	$walk9,		szombie_walk10	] {ai_walk(0);};
void() szombie_walk10 		=[	$walk10,		szombie_walk11	] {ai_walk(0);};
void() szombie_walk11		=[	$walk11,		szombie_walk12	] {ai_walk(2);};
void() szombie_walk12		=[	$walk12,		szombie_walk13	] {ai_walk(2);};
void() szombie_walk13		=[	$walk13,		szombie_walk14	] {ai_walk(1);};
void() szombie_walk14		=[	$walk14,		szombie_walk15	] {ai_walk(0);};
void() szombie_walk15		=[	$walk15,		szombie_walk16	] {ai_walk(0);};
void() szombie_walk16		=[	$walk16,		szombie_walk17	] {ai_walk(0);};
void() szombie_walk17		=[	$walk17,		szombie_walk18	] {ai_walk(0);};
void() szombie_walk18		=[	$walk18,		szombie_walk19	] {ai_walk(0);};
void() szombie_walk19		=[	$walk19,		szombie_walk1	] {
ai_walk(0);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);};

void() szombie_run1		=[	$run1,		szombie_run2		] {ai_run(1);self.inpain = 0;};
void() szombie_run2		=[	$run2,		szombie_run3		] {ai_run(1);};
void() szombie_run3		=[	$run3,		szombie_run4		] {ai_run(0);};
void() szombie_run4		=[	$run4,		szombie_run5		] {ai_run(1);};
void() szombie_run5		=[	$run5,		szombie_run6		] {ai_run(2);};
void() szombie_run6		=[	$run6,		szombie_run7		] {ai_run(3);};
void() szombie_run7		=[	$run7,		szombie_run8		] {ai_run(4);};
void() szombie_run8		=[	$run8,		szombie_run9		] {ai_run(4);};
void() szombie_run9		=[	$run9,		szombie_run10	] {ai_run(2);};
void() szombie_run10		=[	$run10,		szombie_run11	] {ai_run(0);};
void() szombie_run11		=[	$run11,		szombie_run12	] {ai_run(0);};
void() szombie_run12		=[	$run12,		szombie_run13	] {ai_run(0);};
void() szombie_run13		=[	$run13,		szombie_run14	] {ai_run(2);};
void() szombie_run14		=[	$run14,		szombie_run15	] {ai_run(4);};
void() szombie_run15		=[	$run15,		szombie_run16	] {ai_run(6);};
void() szombie_run16		=[	$run16,		szombie_run17	] {ai_run(7);};
void() szombie_run17		=[	$run17,		szombie_run18	] {ai_run(3);};
void() szombie_run18		=[	$run18,		szombie_run1	] {
ai_run(8);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE);
};



void() szombie_atta1		=[	$atta1,		szombie_atta2	] {ai_face();};
void() szombie_atta2		=[	$atta2,		szombie_atta3	] {ai_face();};
void() szombie_atta3		=[	$atta3,		szombie_atta4	] {ai_face();};
void() szombie_atta4		=[	$atta4,		szombie_atta5	] {ai_face();};
void() szombie_atta5		=[	$atta5,		szombie_atta6	] {ai_face();};
void() szombie_atta6		=[	$atta6,		szombie_atta7	] {ai_face();};
void() szombie_atta7		=[	$atta7,		szombie_atta8	] {ai_face();};
void() szombie_atta8		=[	$atta8,		szombie_atta9	] {ai_face();};
void() szombie_atta9		=[	$atta9,		szombie_atta10	] {ai_face();};
void() szombie_atta10		=[	$atta10,		szombie_atta11	] {ai_face();};
void() szombie_atta11		=[	$atta11,		szombie_atta12	] {ai_face();};
void() szombie_atta12		=[	$atta12,		szombie_atta13	] {ai_face();};
void() szombie_atta13		=[	$atta13,		szombie_run1		] {ai_face();SzombieFireGrenade('-10 -22 30');};

void() szombie_attb1		=[	$attb1,		szombie_attb2	] {ai_face();};
void() szombie_attb2		=[	$attb2,		szombie_attb3	] {ai_face();};
void() szombie_attb3		=[	$attb3,		szombie_attb4	] {ai_face();};
void() szombie_attb4		=[	$attb4,		szombie_attb5	] {ai_face();};
void() szombie_attb5		=[	$attb5,		szombie_attb6	] {ai_face();};
void() szombie_attb6		=[	$attb6,		szombie_attb7	] {ai_face();};
void() szombie_attb7		=[	$attb7,		szombie_attb8	] {ai_face();};
void() szombie_attb8		=[	$attb8,		szombie_attb9	] {ai_face();};
void() szombie_attb9		=[	$attb9,		szombie_attb10	] {ai_face();};
void() szombie_attb10		=[	$attb10,		szombie_attb11	] {ai_face();};
void() szombie_attb11		=[	$attb11,		szombie_attb12	] {ai_face();};
void() szombie_attb12		=[	$attb12,		szombie_attb13	] {ai_face();};
void() szombie_attb13		=[	$attb13,		szombie_attb14	] {ai_face();};
void() szombie_attb14		=[	$attb13,		szombie_run1		] {ai_face();SzombieFireGrenade('-10 -24 29');};

void() szombie_attc1		=[	$attc1,		szombie_attc2	] {ai_face();};
void() szombie_attc2		=[	$attc2,		szombie_attc3	] {ai_face();};
void() szombie_attc3		=[	$attc3,		szombie_attc4	] {ai_face();};
void() szombie_attc4		=[	$attc4,		szombie_attc5	] {ai_face();};
void() szombie_attc5		=[	$attc5,		szombie_attc6	] {ai_face();};
void() szombie_attc6		=[	$attc6,		szombie_attc7	] {ai_face();};
void() szombie_attc7		=[	$attc7,		szombie_attc8	] {ai_face();};
void() szombie_attc8		=[	$attc8,		szombie_attc9	] {ai_face();};
void() szombie_attc9		=[	$attc9,		szombie_attc10	] {ai_face();};
void() szombie_attc10		=[	$attc10,		szombie_attc11	] {ai_face();};
void() szombie_attc11		=[	$attc11,		szombie_attc12	] {ai_face();};
void() szombie_attc12		=[	$attc12,		szombie_run1		] {ai_face();SzombieFireGrenade('-12 -19 29');};

void() szombie_missile =
{
	local float	r;
	
	r = random();
	
	if (r < 0.3)
		szombie_atta1 ();
	else if (r < 0.6)
		szombie_attb1 ();
	else
		szombie_attc1 ();
};


/*
=============================================================================

PAIN

=============================================================================
*/

void() szombie_paina1	=[	$paina1,	szombie_paina2	] {sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() szombie_paina2	=[	$paina2,	szombie_paina3	] {ai_painforward(3);};
void() szombie_paina3	=[	$paina3,	szombie_paina4	] {ai_painforward(1);};
void() szombie_paina4	=[	$paina4,	szombie_paina5	] {ai_pain(1);};
void() szombie_paina5	=[	$paina5,	szombie_paina6	] {ai_pain(3);};
void() szombie_paina6	=[	$paina6,	szombie_paina7	] {ai_pain(1);};
void() szombie_paina7	=[	$paina7,	szombie_paina8	] {};
void() szombie_paina8	=[	$paina8,	szombie_paina9	] {};
void() szombie_paina9	=[	$paina9,	szombie_paina10	] {};
void() szombie_paina10	=[	$paina10,	szombie_paina11	] {};
void() szombie_paina11	=[	$paina11,	szombie_paina12	] {};
void() szombie_paina12	=[	$paina12,	szombie_run1		] {};

void() szombie_painb1	=[	$painb1,	szombie_painb2	] {sound (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() szombie_painb2	=[	$painb2,	szombie_painb3	] {ai_pain(2);};
void() szombie_painb3	=[	$painb3,	szombie_painb4	] {ai_pain(8);};
void() szombie_painb4	=[	$painb4,	szombie_painb5	] {ai_pain(6);};
void() szombie_painb5	=[	$painb5,	szombie_painb6	] {ai_pain(2);};
void() szombie_painb6	=[	$painb6,	szombie_painb7	] {};
void() szombie_painb7	=[	$painb7,	szombie_painb8	] {};
void() szombie_painb8	=[	$painb8,	szombie_painb9	] {};
void() szombie_painb9	=[	$painb9,	szombie_painb10	] {sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);};
void() szombie_painb10	=[	$painb10,	szombie_painb11	] {};
void() szombie_painb11	=[	$painb11,	szombie_painb12	] {};
void() szombie_painb12	=[	$painb12,	szombie_painb13	] {};
void() szombie_painb13	=[	$painb13,	szombie_painb14	] {};
void() szombie_painb14	=[	$painb14,	szombie_painb15	] {};
void() szombie_painb15	=[	$painb15,	szombie_painb16	] {};
void() szombie_painb16	=[	$painb16,	szombie_painb17	] {};
void() szombie_painb17	=[	$painb17,	szombie_painb18	] {};
void() szombie_painb18	=[	$painb18,	szombie_painb19	] {};
void() szombie_painb19	=[	$painb19,	szombie_painb20	] {};
void() szombie_painb20	=[	$painb20,	szombie_painb21	] {};
void() szombie_painb21	=[	$painb21,	szombie_painb22	] {};
void() szombie_painb22	=[	$painb22,	szombie_painb23	] {};
void() szombie_painb23	=[	$painb23,	szombie_painb24	] {};
void() szombie_painb24	=[	$painb24,	szombie_painb25	] {};
void() szombie_painb25	=[	$painb25,	szombie_painb26	] {ai_painforward(1);};
void() szombie_painb26	=[	$painb26,	szombie_painb27	] {};
void() szombie_painb27	=[	$painb27,	szombie_painb28	] {};
void() szombie_painb28	=[	$painb28,	szombie_run1		] {};

void() szombie_painc1	=[	$painc1,	szombie_painc2	] {sound (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() szombie_painc2	=[	$painc2,	szombie_painc3	] {};
void() szombie_painc3	=[	$painc3,	szombie_painc4	] {ai_pain(3);};
void() szombie_painc4	=[	$painc4,	szombie_painc5	] {ai_pain(1);};
void() szombie_painc5	=[	$painc5,	szombie_painc6	] {};
void() szombie_painc6	=[	$painc6,	szombie_painc7	] {};
void() szombie_painc7	=[	$painc7,	szombie_painc8	] {};
void() szombie_painc8	=[	$painc8,	szombie_painc9	] {};
void() szombie_painc9	=[	$painc9,	szombie_painc10	] {};
void() szombie_painc10	=[	$painc10,	szombie_painc11	] {};
void() szombie_painc11	=[	$painc11,	szombie_painc12	] {ai_painforward(1);};
void() szombie_painc12	=[	$painc12,	szombie_painc13	] {ai_painforward(1);};
void() szombie_painc13	=[	$painc13,	szombie_painc14	] {};
void() szombie_painc14	=[	$painc14,	szombie_painc15	] {};
void() szombie_painc15	=[	$painc15,	szombie_painc16	] {};
void() szombie_painc16	=[	$painc16,	szombie_painc17	] {};
void() szombie_painc17	=[	$painc17,	szombie_painc18	] {};
void() szombie_painc18	=[	$painc18,	szombie_run1	] {};

void() szombie_paind1	=[	$paind1,	szombie_paind2	] {sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() szombie_paind2	=[	$paind2,	szombie_paind3	] {};
void() szombie_paind3	=[	$paind3,	szombie_paind4	] {};
void() szombie_paind4	=[	$paind4,	szombie_paind5	] {};
void() szombie_paind5	=[	$paind5,	szombie_paind6	] {};
void() szombie_paind6	=[	$paind6,	szombie_paind7	] {};
void() szombie_paind7	=[	$paind7,	szombie_paind8	] {};
void() szombie_paind8	=[	$paind8,	szombie_paind9	] {};
void() szombie_paind9	=[	$paind9,	szombie_paind10	] {ai_pain(1);};
void() szombie_paind10	=[	$paind10,	szombie_paind11	] {};
void() szombie_paind11	=[	$paind11,	szombie_paind12	] {};
void() szombie_paind12	=[	$paind12,	szombie_paind13	] {};
void() szombie_paind13	=[	$paind13,	szombie_run1	] {};

void() szombie_paine1	=[	$paine1,	szombie_paine2	] {
sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);
self.health = 60;
};
void() szombie_paine2	=[	$paine2,	szombie_paine3	] {ai_pain(8);};
void() szombie_paine3	=[	$paine3,	szombie_paine4	] {ai_pain(5);};
void() szombie_paine4	=[	$paine4,	szombie_paine5	] {ai_pain(3);};
void() szombie_paine5	=[	$paine5,	szombie_paine6	] {ai_pain(1);};
void() szombie_paine6	=[	$paine6,	szombie_paine7	] {ai_pain(2);};
void() szombie_paine7	=[	$paine7,	szombie_paine8	] {ai_pain(1);};
void() szombie_paine8	=[	$paine8,	szombie_paine9	] {ai_pain(1);};
void() szombie_paine9	=[	$paine9,	szombie_paine10	] {ai_pain(2);};
void() szombie_paine10	=[	$paine10,	szombie_paine11	] {
sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);
self.solid = SOLID_NOT;
};
void() szombie_paine11	=[	$paine11,	szombie_paine12	] {self.nextthink = self.nextthink + 5;self.health = 60;};
void() szombie_paine12	=[	$paine12,	szombie_paine13	]{
// see if ok to stand up
self.health = 60;
sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
self.solid = SOLID_SLIDEBOX;
if (!walkmove (0, 0))
{
	self.think = szombie_paine11;
	self.solid = SOLID_NOT;
	return;
}
};
void() szombie_paine13	=[	$paine13,	szombie_paine14	] {};
void() szombie_paine14	=[	$paine14,	szombie_paine15	] {};
void() szombie_paine15	=[	$paine15,	szombie_paine16	] {};
void() szombie_paine16	=[	$paine16,	szombie_paine17	] {};
void() szombie_paine17	=[	$paine17,	szombie_paine18	] {};
void() szombie_paine18	=[	$paine18,	szombie_paine19	] {};
void() szombie_paine19	=[	$paine19,	szombie_paine20	] {};
void() szombie_paine20	=[	$paine20,	szombie_paine21	] {};
void() szombie_paine21	=[	$paine21,	szombie_paine22	] {};
void() szombie_paine22	=[	$paine22,	szombie_paine23	] {};
void() szombie_paine23	=[	$paine23,	szombie_paine24	] {};
void() szombie_paine24	=[	$paine24,	szombie_paine25	] {};
void() szombie_paine25	=[	$paine25,	szombie_paine26	] {ai_painforward(5);};
void() szombie_paine26	=[	$paine26,	szombie_paine27	] {ai_painforward(3);};
void() szombie_paine27	=[	$paine27,	szombie_paine28	] {ai_painforward(1);};
void() szombie_paine28	=[	$paine28,	szombie_paine29	] {ai_pain(1);};
void() szombie_paine29	=[	$paine29,	szombie_paine30	] {};
void() szombie_paine30	=[	$paine30,	szombie_run1		] {};

void() szombie_die =
{
	//self.effects = self.effects - (self.effects & EF_CANDLELIGHT);
	sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
	
	//ThrowHead ("progs/h_zombie.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	//auto_gun(self.origin, 0);

	//spawn_homing_flame();
	remove(self);
};

/*
=================
szombie_pain

Zombies can only be killed (gibbed) by doing 60 hit points of damage
in a single frame (rockets, grenades, quad shotgun, quad nailgun).

A hit of 25 points or more (super shotgun, quad nailgun) will allways put it
down to the ground.

A hit of from 10 to 40 points in one frame will cause it to go down if it
has been twice in two seconds, otherwise it goes into one of the four
fast pain frames.

A hit of less than 10 points of damage (winged by a shotgun) will be ignored.
=================
*/
void(entity attacker, float take) szombie_pain =
{
	local float r;

	self.health = 60;		// allways reset health

	if (take < 9)
		return;				// totally ignore

	if (self.inpain == 2)
		return;			// down on ground, so don't reset any counters

// go down immediately if a big enough hit
	if (take >= 25)
	{
		self.inpain = 2;
		szombie_paine1 ();
		return;
	}
	
	if (self.inpain)
	{
// if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 3;
		return;			// currently going through an animation, don't change
	}
	
	if (self.pain_finished > time)
	{
// hit again, so drop down
		self.inpain = 2;
		szombie_paine1 ();
		return;
	}

// gp into one of the fast pain animations	
	self.inpain = 1;

	r = random();
	if (r < 0.25)
		szombie_paina1 ();
	else if (r <  0.5)
		szombie_painb1 ();
	else if (r <  0.75)
		szombie_painc1 ();
	else
		szombie_paind1 ();
};

//============================================================================

/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_szombie =
{
	self.health = 60;
	self.classname = "monster_szombie";
	
	self.inpain = 2;
	self.th_stand = szombie_stand1;
	self.th_walk = szombie_walk1;
	self.th_run = szombie_run1;
	self.th_pain = szombie_pain;
	self.th_die = szombie_die;
	
	self.th_melee = szombie_missile; // unlike normal zombie, get close range first!
	
	//self.frame = paine12;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/zombie.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(self, self.owner.origin);
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.view_ofs = '0 0 25';
	self.team = TEAM_MONSTERS;
	self.flags = self.flags | FL_MONSTER;
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.combat_style = CS_MELEE;
	//self.effects = EF_CANDLELIGHT;

	total_monsters++;
	WriteByte(MSG_ALL, SVC_UPDATESTAT);
	WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
	WriteLong(MSG_ALL, total_monsters);

	self.enemy = find(world, classname, "player");

	self.frame = 174;
	self.think = szombie_paine11;
	self.nextthink = time + 2;
};

void() spawn_szombie =
{
	local entity info, oself;
	local float count, pick, total;

	// step 0, count all zombies and see if we've got too many!
	count = 0;
	info = find(world, classname, "monster_szombie");
	while (info)
	{
		count++;
		info = find(info, classname, "monster_szombie");
	}
	dprint("there are "); dprint(ftos(count)); dprint(" szombies\n");
	if (count > 32)
		return;

	// step 1, count all valid spawns
	count = 0;
	total = 0;
	info = find(world,classname, "info_szombie_spawn");
	if (info == world)
	{
		dprint("ERROR! No 'info_szombie_spawn' entities found.\n");
		return;
	}
	while (info)
	{
		if (info.wait && (info.wait < time))
			count++;
		total++;
		info = find(info, classname, "info_szombie_spawn");
	}
	dprint("found "); dprint(ftos(count)); dprint(" valid spawn points. of "); dprint(ftos(total)); dprint("\n");

	if (count == 0)
	{
		dprint("ERROR! None of the spawn points are valid! Try adding more!\n");
		return;
	}

	// step 2, pick one of the valid spawns at random
	pick = floor(random() * (count-1) + 0.5);
	dprint("picked: "); dprint(ftos(pick)); dprint("\n");
	
	// step 3, go through list again (only counting valid) to find the one we picked
	count = 0;
	info = find(world, classname, "info_szombie_spawn");
	while (count != pick)
	{
		count++;
		info = find(info, classname, "info_szombie_spawn");
	}

	// step 4, increment time on the picked spawn
	if (info != world)
		info.wait = time + 8; 

	// spawn the actual zombie!
	oself = self;
	self = spawn();
	self.owner = info;
	monster_szombie();
	self = oself;
	
}

void() info_szombie_spawn =
{
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/flame2.mdl");

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


	self.wait = -1;
}

void() spawn_homing_flame =
{
	local entity p, oself;
	oself = self;
	self = spawn();
	self.enemy = oself.enemy;
	setorigin(self, oself.origin + '0 0 4');
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLYMISSILE;

	setmodel (self, "progs/flame2.mdl");
	setsize (self, '0 0 0', '0 0 0');
	self.effects = EF_CANDLELIGHT;

	self.touch = spike_touch;

	if ((!self.enemy) || (self.enemy.classname != "player"))
	{
		p = find(world, classname, "player");
		self.enemy = p;
	}

	self.speed = 400;
	self.velocity = normalize(self.enemy.origin - self.origin) * self.speed;
	//makeangles(normalize(self.velocity));

	self.waitmin = time;
	self.think = homing_flame_think;
	self.nextthink = time + 0.1;

	remove(oself);
}

void() homing_flame_think
{
	local vector v;
	if (self.waitmin + 3 < time)
	{
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

	self.speed -= 10;
	if (self.speed < 0)
		self.speed = 0;

	v = normalize(self.enemy.origin - self.origin);
	v = v * 0.3 + normalize(self.velocity) * 0.7;
	v *= self.speed;
	self.velocity = v;
		

	self.nextthink = time + 0.1;
}
/*
================
ZombieFireGrenade
================
*/
void(vector st) SzombieFireGrenade =
{
	local	entity missile;
	local	vector	org;

	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// calc org
	org = self.origin + st_x * v_forward + st_y * v_right + (st_z - 24) * v_up;
	
// set missile speed	

	makevectors (self.angles);

	missile.velocity = normalize(self.enemy.origin - org);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;

	missile.avelocity = '3000 1000 2000';

	missile.touch = SzombieGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};
void() SzombieGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.classname && (other.classname == "monster_oldone_new" || other.classname == "oldnew_child"))
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 10 );
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);	// bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Remove;
};
