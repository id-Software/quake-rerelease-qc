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
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

float SIGIL_E1 = 1;
float SIGIL_E2 = 2;
float SIGIL_E3 = 4;
float SIGIL_E4 = 8;
float SIGIL_E5 = 16;
float SIGIL_E6 = 32;
float SIGIL_NUMBITS = 6;

float SIGIL_ALL = SIGIL_E1 | SIGIL_E2 | SIGIL_E3 | SIGIL_E4 | SIGIL_E5;
float SIGIL_ALL_ALL_ALLLL = SIGIL_E1 | SIGIL_E2 | SIGIL_E3 | SIGIL_E4 | SIGIL_E5 | SIGIL_E6;


void() sigil_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	centerprint_all (self.netname); // Netname is localized

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	
	serverflags = serverflags | self.style;
    //float lastPickup = SUB_LeftShift(self.spawnflags & SIGIL_ALL, SIGIL_NUMBITS);
    //serverflags = serverflags | (self.spawnflags & SIGIL_ALL) | lastPickup;
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

/*
float sigil_getLastPickup()
{
    float lastPickup = SUB_RightShift(serverflags, SIGIL_NUMBITS) & SIGIL_ALL;
    return lastPickup;
}

void sigil_clearLastPickup()
{
    serverflags = serverflags & ~SUB_LeftShift(SIGIL_ALL, SIGIL_NUMBITS);
}
*/

/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4 E5 E6
End of level sigil, pick up to end episode and return to jrstart.
*/

void() item_sigil =
{
	if (!self.spawnflags)
		self.spawnflags|= SIGIL_E1;

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

    string tempmdl = string_null;
	local float is_spawned;
	is_spawned = 0;
	if (self.spawnflags & 128) // alternate flag for if the sigil is spawned
		is_spawned = 128;
	

	if (self.spawnflags & SIGIL_E1)
	{
        self.spawnflags = SIGIL_E1;
		self.style = 1;
		tempmdl = "progs/end1.mdl";
		//self.netname = "$qc_mg1_pickup_rune1";
		self.netname = "$mg3_qc_rune1";
	}
	else if (self.spawnflags & SIGIL_E2)
	{
		self.spawnflags = SIGIL_E2;
		self.style = 2;
        tempmdl = "progs/end2.mdl";
		//self.netname = "$qc_mg1_pickup_rune2";
		self.netname = "$mg3_qc_rune2";
	}
	else if (self.spawnflags & SIGIL_E3)
	{
		self.spawnflags = SIGIL_E3;
		self.style = 4;
        tempmdl = "progs/end3.mdl";
		//self.netname = "$qc_mg1_pickup_rune3";
		self.netname = "$mg3_qc_rune3";
	}
	else if (self.spawnflags & SIGIL_E4)
	{
		self.spawnflags = SIGIL_E4;
		self.style = 8;
        tempmdl = "progs/end4.mdl";
		//self.netname = "$qc_mg1_pickup_rune4";
		self.netname = "$mg3_qc_rune4";
	}
    self.spawnflags += is_spawned;

    precache_model (tempmdl);
    setmodel (self, tempmdl);

	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

// ===============================================================================

const float RUNE_INDICATOR_ACTIVE = 64;

void misc_rune_indicator_use()
{
	self.alpha = 1.0;
	SUB_UseTargets();
}

void misc_rune_indicator()
{
	float active = self.spawnflags & RUNE_INDICATOR_ACTIVE ? TRUE : FALSE;
	self.spawnflags (-) RUNE_INDICATOR_ACTIVE;
	if (!self.spawnflags)
	{
		self.spawnflags|= SIGIL_E1;
	}
	self.spawnflags &= SIGIL_ALL_ALL_ALLLL;

    string mdl = string_null;

	if (self.spawnflags & SIGIL_E1)
	{
        self.spawnflags = SIGIL_E1;
		mdl = "progs/mg1_rune1.mdl";
	}
	else if (self.spawnflags & SIGIL_E2)
	{
		self.spawnflags = SIGIL_E2;
        mdl = "progs/mg1_rune2.mdl";
	}
	else if (self.spawnflags & SIGIL_E3)
	{
		self.spawnflags = SIGIL_E3;
        mdl = "progs/mg1_rune3.mdl";
	}
	else if (self.spawnflags & SIGIL_E4)
	{
		self.spawnflags = SIGIL_E4;
        mdl = "progs/mg1_rune4.mdl";
	}
	else if (self.spawnflags & SIGIL_E5)
	{
		self.spawnflags = SIGIL_E5;
        mdl = "progs/mg1_rune5.mdl";
	}
	else if (self.spawnflags & SIGIL_E6)
	{
		self.spawnflags = SIGIL_E6;
        mdl = "progs/mg1_rune6.mdl";
	}
    
    precache_model (mdl);
    setmodel (self, mdl);

	self.use = misc_rune_indicator_use;

	if(((self.spawnflags & serverflags) == self.spawnflags) || active )
    {
		self.think = SUB_UseTargets;
		self.nextthink = time + 0.2;
	}
	else
	{
		//Show a ghost of the rune before you collect it.
		self.alpha = 0.2;
	}
}