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

//=============================================================================

void() touch_ring =
{
	local vector org;
	if (other.classname != "player")
	return;
	
	// Teleport the player
	org = other.origin;
	org_z = (other.origin_z + self.height);
	if (self.height < 0)
		org_z += 1;
	setorigin(other, org);
	spawn_tfog(org);
	spawn_tdeath(org, other);
	
	// Teleport monsters also??? 
	/*
	local entity monster;
	monster = find(world, category, "monster");
	while(monster)
	{
		org = monster.origin;
		org_z = (monster.origin_z + self.height); 
		//monster.origin_z = (monster.origin_z - self.height) + 1;
		setorigin(monster, org);
		monster = find(monster, category, "monster");
	}
	*/
	//force_retouch = 1;
};

/*QUAKED item_draught_insight (0 .5 .8) (0 0 0) (32 32 32) big
AY, addition, August 14, 2025
*/
float SPAWNFLAG_OVERRIDE_DEST = 1;

void() item_draught_insight =
{
	precache_sound ("ambience/hum1.wav");
	precache_model ("progs/gold_ring.mdl");
	setmodel (self, "progs/gold_ring.mdl");
	self.netname = "$mg3_qc_ring_of_insight";
	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 1;
	
	if(!self.height)
	{
		self.height = -2048;
	}
	if ((self.spawnflags & SPAWNFLAG_OVERRIDE_DEST) && self.target)
		self.touch = teleport_touch;
	else
		self.touch = touch_ring;

	if (!(self.spawnflags & SPAWNED))
		draught_fx(1);
	StartItem ();
};

//=============================================================================

/*QUAKED item_draught_stupor (0 .5 .8) (0 0 0) (32 32 32) big
AY, addition, August 15, 2025
*/
void() item_draught_stupor =
{
	//self.touch = ammo_touch;
	precache_sound ("ambience/hum1.wav");
	precache_model ("progs/onyx_ring.mdl");
	setmodel (self, "progs/onyx_ring.mdl");
	self.netname = "$mg3_qc_ring_of_oblivion";
	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 1;
	
	if(!self.height)
	{
		self.height = 2048;
	}
	if ((self.spawnflags & SPAWNFLAG_OVERRIDE_DEST) && self.target)
		self.touch = teleport_touch;
	else
		self.touch = touch_ring;

	if (!(self.spawnflags & SPAWNED))
		draught_fx(1);
	StartItem ();
};

void(float static_sound) draught_fx =
{
	local entity oself;
	local vector offset;

	// don't allow spawning more than 1 fx per ring
	if (self.count)
		return;
	else
		self.count = 1;

	offset = '0 0 8';
	if (static_sound)
		ambientsound (self.origin + offset, "ambience/hum1.wav",0.7 , ATTN_STATIC);

	oself = self;
	self = spawn();
	self.origin = oself.origin + offset;
	self.size = '24 24 0';
	self.distance = 48;
	particle_tele();

	self = oself;
}

//=============================================================================

// Armor Shards
void() armor_shard_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	if (other.armortype < 0.3)
		other.armortype = 0.3;
	
	if (other.armorvalue >= 200)
		return;
	
	if (other.items & IT_ARMOR3)
		dprint("already has red armor\n");
	else if (other.items & IT_ARMOR2)
		dprint("already has yellow armor\n");
	else if (other.items & IT_ARMOR1)
		dprint("already has green armor\n");
	else
	{
		dprint("add some green armor\n");
		other.items = other.items + IT_ARMOR1;
	}
	
	//other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR1;
	other.armorvalue += 5; 
	if (other.armorvalue > 200)
		other.armorvalue = 200;
	
	sprint(other, "$mg3_qc_armor_shard_touch");
	// armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
	activator = other;
	SUB_UseTargets();
	
	remove(self);
};
void() item_armor_shard
{
	precache_model ("progs/armorshard.mdl");
	precache_sound ("items/armor1.wav");
	
	setmodel (self, "progs/armorshard.mdl");
	self.touch = armor_shard_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem ();
};
//=============================================================================
/*QUAKED weapon_laser_gun (0 .5 .8) (-16 -16 0) (16 16 32)
pulled from Hipnotic qc, Jan 17 2026, AY
*/

void() weapon_laser_gun =
{
   precache_model ("progs/g_laserg.mdl");
   setmodel (self, "progs/g_laserg.mdl");
	self.weapon = 3;
   self.netname = "$qc_laser_cannon";
   self.items = IT_LASER_CANNON;
   self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

void() mjolnir_touch =
{
	weapon_touch();
	touch_teleport_silent();
};

void() weapon_mjolnir =
{
	precache_model ("progs/g_hammer.mdl");
	setmodel (self, "progs/g_hammer.mdl");
	self.weapon = 3;
	self.netname = "$mg3_qc_hammer";
	self.items = IT_MJOLNIR;
	if (self.spawnflags & 128)
	{
		if (!self.height)
			self.height = -2048;
		self.touch = mjolnir_touch;
	}
	else
	{
		self.touch = weapon_touch;
	}
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

// =======================================================
float BLOODY_NIGHTMARE_ACTIVE = 64; // applied to server flags instead of to parm16
float BLOODY_NIGHTMARE_DISCOVERED = 128; 
float BLOODY_NIGHTMARE_NEWGAME = 256;
float TETTE = 512;

void() touch_hellknight_head =
{
	if (other.classname != "player")
		return;

	WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
	WriteString(MSG_ALL, "ACH_FIND_MG3_SECRET");
	
	bprint("$mg3_selected_bloody_nightmare");
	if (serverflags & BLOODY_NIGHTMARE_ACTIVE)
		dprint("was already on 'bloody nightmare' difficulty\n");
	else
	{
		serverflags = serverflags | BLOODY_NIGHTMARE_ACTIVE;
	}

	if (serverflags & BLOODY_NIGHTMARE_DISCOVERED)
		dprint("had already discovered 'bloody nightmare' difficulty\n");
	else
	{
		serverflags = serverflags | BLOODY_NIGHTMARE_DISCOVERED;
	}
	skill = 3;
	cvar_set("skill", "3");
	sound (other, CHAN_ITEM, "player/tornoff2.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	SUB_UseTargets();
	remove(self);
}
void () hug_tette =
{
	// Dedicated to Hanna <3 
	sprint(other, "$qc_got_item", self.netname);
	serverflags = serverflags | TETTE;
	sound (other, CHAN_ITEM, "misc/secret.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	SUB_UseTargets();
	remove(self);

}

void() item_head_hellknight =
{
	precache_model ("progs/item_h_hellkn.mdl");
	precache_model ("progs/g_bunny.mdl");
	if (serverflags & BLOODY_NIGHTMARE_ACTIVE)
	{
		if ((serverflags & BLOODY_NIGHTMARE_NEWGAME) && (!(serverflags & TETTE)))
		{
			setmodel (self, "progs/g_bunny.mdl");
			self.touch = hug_tette;
			self.netname = "$mg3_qc_newgameplus_item";

		}
		else
		{
			// replace with a megahealth!
			self.classname = "item_health"; 
			self.spawnflags = H_MEGA;
			makevectors(self.angles);
			setorigin(self, self.origin + v_right * 16 + v_forward * -16);
			item_health();
			//remove(self);
			return;
		}

	}
	else
	{
		setmodel (self, "progs/item_h_hellkn.mdl");
		self.touch = touch_hellknight_head;
	}
	
	
	
	setsize (self, '-16 -16 -16', '16 16 40');
	StartItem ();
}
// ****************************************************************
// bloody weapon upgrades, May 7 2026
float BLOODY_SG = 1;
float BLOODY_SSG = 2;

void() bloody_weapon_check =
{
	if (!(serverflags & BLOODY_NIGHTMARE_NEWGAME))
	{
		remove(self);
		return;
	}

	StartItem();
}

void() weapon_bloody_sg =
{
	precache_model ("progs/g_bloodshot.mdl");
	setmodel (self, "progs/g_bloodshot.mdl");
	self.weapon = 3;
	//self.netname = "$qc_laser_cannon";
	//self.items = IT_LASER_CANNON;
	self.touch = bloody_weapon_touch;
	self.weapon = BLOODY_SG;
	self.items = IT_SHOTGUN;
	setsize (self, '-16 -16 0', '16 16 56');
	//StartItem ();

	dprint("started bloody sg\n\n\n\n");
	self.think = bloody_weapon_check;
	self.nextthink = time + 0.5;
};

void() weapon_bloody_ssg =
{
	precache_model ("progs/g_bloodshot2.mdl");
	setmodel (self, "progs/g_bloodshot2.mdl");
	self.weapon = 3;
	//self.netname = "$qc_laser_cannon";
	//self.items = IT_LASER_CANNON;
	self.touch = bloody_weapon_touch;
	self.weapon = BLOODY_SSG;
	self.items = IT_SUPER_SHOTGUN;
	setsize (self, '-16 -16 0', '16 16 56');
	//StartItem ();

	self.think = bloody_weapon_check;
	self.nextthink = time + 0.5;
};


void() bloody_weapon_touch =
{
	local entity stemp;
	
	if (!(other.flags & FL_CLIENT))
		return;


	if ((parm15 & self.weapon) && (other.items & self.items))
	{
		dprint("you already have the upgrade\n");
		//remove(self);
		//return;
	}
	else
	{
		parm15 = parm15 | self.weapon;
	}

	other.ammo_shells = other.ammo_shells + 30;
	if (other.ammo_shells > ammo_shells_max)
		other.ammo_shells = ammo_shells_max;

	// change to the weapon
	other.items = other.items | self.items;

	// update player
	stemp = self;
	self = other;

	self.weapon = stemp.items;
	W_SetCurrentAmmo();
	self = stemp;

	sprint(other, "$mg3_map2_secret_weapon");
	// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	if (self.target)
		SUB_UseTargets();

	remove(self);
};
