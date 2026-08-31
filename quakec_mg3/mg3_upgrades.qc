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
// UPGRADES
// Persistent upgrades!
// Just stubbing this out so far, AY Oct 25 2025
// Separated this to its own file and unified the code paths for all upgrades, CG Dec 19 2025

.float upgrade_flag;

const float UPGRADE1 = 1;
const float UPGRADE2 = 2;
const float UPGRADE3 = 4;
const float UPGRADE4 = 8;
const float UPGRADE5 = 16;
const float UPGRADE6 = 32;
const float UPGRADE7 = 64;
const float UPGRADE8 = 128;
const float UPGRADE9 = 256;
const float UPGRADE10 = 512;
const float UPGRADE11 = 1024;
const float UPGRADE12 = 2048;
const float UPGRADE13 = 4096;
const float UPGRADE14 = 8192;
const float UPGRADE15 = 16384;

// parm10 is health upgrade
// parm11 is shells upgrade
// parm12 is spikes upgrade
// parm13 is rockets upgrade
// parm14 is cells upgrade

float() GetUpgradeFlag =
{
	local float v;
	v = 0;
	
	if(mapname == "map1")
		v = UPGRADE1;
	else if (mapname == "map2")
		v = UPGRADE2;
	else if (mapname == "map2b") // CG: Added map2b
		v = UPGRADE14;           //
	else if (mapname == "map3")
		v = UPGRADE3;
	else if (mapname == "map4")
		v = UPGRADE4;
	else if (mapname == "map5")
		v = UPGRADE5;
	else if (mapname == "map6")
		v = UPGRADE6;
	else if (mapname == "map7")
		v = UPGRADE7;
	else if (mapname == "map8")
		v = UPGRADE8;
	else if (mapname == "secret1")
		v = UPGRADE9;
	else if (mapname == "secret2")
		v = UPGRADE10;
	else if (mapname == "secret3")
		v = UPGRADE11;
	else if (mapname == "secret4")
		v = UPGRADE12;
	else if (mapname == "secret5")
		v = UPGRADE13;
	else if (mapname == "secret6")
		v = UPGRADE15;
	else
		dprint("ERROR: Define the upgrade flag for this map!\n See mg3_items.qc, GetUpgradeFlag()\n\n");
	
	return v;
};


// how much to get for each upgrade
// const float UPGRADE_HEALTH = 15;
// const float UPGRADE_SHELLS = 10;
// const float UPGRADE_NAILS = 20;
// const float UPGRADE_ROCKETS = 10;
// const float UPGRADE_CELLS = 10;
float GetUpgradeAmount(UpgradeType Type)
{
	return 10; // Feb 18, 2026, AY rebalancing
	/*
	switch(Type)
	{
		case UpgradeType_Health: return 15;
		case UpgradeType_Nails: return 20;
		case UpgradeType_Cells: return 20; // increased, Feb 7 2026, AY.
		default: return 10;
	}
		*/
}

float GetUpgradeFlagValue(UpgradeType Type)
{
	local float v; 
	switch(Type)
	{
		case UpgradeType_Health:
			v = parm10;
			break;
		case UpgradeType_Shells:
			v = parm11;
			break;
		case UpgradeType_Nails:
			v = parm12;
			break;
		case UpgradeType_Rockets:
			v = parm13;
			break;
		case UpgradeType_Cells:
			v = parm14;
			break;
		default:
			dprint("GetUpgradeFlagValue: Unknown upgrade type.\n");
			v = -1;
	}
	return v;
}

void SetUpgradeFlagValue(UpgradeType Type, float value)
{
	switch(Type)
	{
		case UpgradeType_Health:
			parm10 = value;
			break;
		case UpgradeType_Shells:
			parm11 = value;
			break;
		case UpgradeType_Nails:
			parm12 = value;
			break;
		case UpgradeType_Rockets:
			parm13 = value;
			break;
		case UpgradeType_Cells:
			parm14 = value;
			break;
		default:
			dprint("SetUpgradeFlagValue: Unknown upgrade type.\n");
	}
}

float GetCurrentUpgradedMaxValue(UpgradeType Type, float basevalue)
{
	float upgradevalue = GetUpgradeAmount(Type);
	float parm = GetUpgradeFlagValue(Type);
	float v = basevalue;
	float flag = 1;
	// dprint("Checking Upgrade Flags: [");
	// Just scanning the parm for bits that are set
	for (float i = 0; i < 23; i++)
	{
		if(parm & flag)
		{	
			// dprint("1");
			v+= upgradevalue;
		}
		else
		{
			// dprint("0");
		}
		flag *= 2; // Next bit
	}
	// dprint("] - Max value = ");
	// dprint(ftos(v));
	// dprint("\n");
	return v;
};

float ApplyUpgrade(UpgradeType Type, entity client)
{
	float value = GetUpgradeAmount(Type);
	switch(Type)
	{
		case UpgradeType_Health:
			client.max_health += value;
			T_Heal(client, client.max_health, FALSE);
			return client.max_health;
			break;

		case UpgradeType_Shells:
			ammo_shells_max += value;
			client.ammo_shells = ammo_shells_max;
			return ammo_shells_max;
			break;
			
		case UpgradeType_Nails:
			ammo_nails_max += value;
			client.ammo_nails = ammo_nails_max;
			return ammo_nails_max;
			break;

		case UpgradeType_Rockets:
			ammo_rockets_max += value;
			client.ammo_rockets = ammo_rockets_max;
			return ammo_rockets_max;
			break;

		case UpgradeType_Cells:
			ammo_cells_max += value;
			client.ammo_cells = ammo_cells_max;
			return ammo_cells_max;
			break;

		default:
			dprint("SetUpgradeFlagValue: Unknown upgrade type.\n");
			break; 
	}
}

void GiveUpgradeBonus(UpgradeType Type, entity client)
{
	/*
	local float value;
	float value = GetUpgradeAmount(Type);

	switch(Type)
	{
		case UpgradeType_Health:
			T_Heal(client, value, 0);
			return;
			break;

		case UpgradeType_Shells:
			other.ammo_shells += value;
			break;

		case UpgradeType_Nails:
			other.ammo_nails += value;
			break;

		case UpgradeType_Rockets:
			other.ammo_rockets += value;
			break;

		case UpgradeType_Cells:
			other.ammo_cells += value;
			break;

		default:
			dprint("SetUpgradeFlagValue: Unknown upgrade type.\n");
			break;
			
	}
	*/
	bound_other_ammo(client);

    
    //Update HUD display
	entity stemp = self;
	self = client;
	W_SetCurrentAmmo();
	self = stemp;
}

//=============================================================================

void() StartUpgradeItem =
{
	float parm = GetUpgradeFlagValue(self.armortype);
	if (parm & self.upgrade_flag)
	{
		// Already collected upgrade is slightly transparent.
		self.alpha = 0.6;
	}

	self.solid = SOLID_TRIGGER;
	self.touch = UpgradeTouch;	

	StartItem();
}

void UpgradeTouch()
{
	if (!(other.flags & FL_CLIENT))
		return;

	float param = GetUpgradeFlagValue(self.armortype);
	if (param & self.upgrade_flag)
	{
		//Already got it
		//sprint(other, "You found a {0} capacity upgrade!\nBut its power was already taken...\n", self.netname);
		sprint(other, "$mg3_qc_upgrade_fail", self.netname);
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		stuffcmd (other, "bf\n");
	}
	else
	{
		//Add upgrade flag and increase max limit

		param (+) self.upgrade_flag;
		SetUpgradeFlagValue(self.armortype, param);
		
		float newmax = ApplyUpgrade(self.armortype, other);
		
		//sprint(other, "{0} capacity increased to {1}!\n", self.netname, ftos(newmax));
		sprint(other, "$mg3_qc_upgrade_success", self.netname, ftos(newmax));
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		stuffcmd (other, "bf\n");
	}

	// In both cases, give a bonus boost to the upgrade value.
	GiveUpgradeBonus(self.armortype, other);
	
	activator = other;
	SUB_UseTargets();

	remove(self);
}

//=============================================================================

/*QUAKED item_upgrade_health (0 .5 .8) (0 0 0) (32 32 32)
Upgrade pickup for health capacity
*/

void() item_upgrade_health =
{
	precache_model ("progs/item_h_player.mdl");
	precache_sound ("player/tornoff2.wav");
	
	if (!self.upgrade_flag)
		self.upgrade_flag = GetUpgradeFlag();
	else
	{
		dprint(self.classname); dprint(" using overriden upgrade flag at "); dprint(vtos(self.origin)); dprint ("\n");
	}

	self.armortype = UpgradeType_Health;
	self.netname = "$mg3_qc_upgrade_health";
	self.noise = "player/tornoff2.wav";

	setmodel (self, "progs/item_h_player.mdl");
	self.origin+= '0 0 8';
	setsize (self, '-16 -16 -8', '16 16 48');

	self.think = StartUpgradeItem;
	self.nextthink = time + 0.5;	
};

/*QUAKED item_upgrade_shells (0 .5 .8) (0 0 0) (32 32 32)
Upgrade pickup for shell capacity
*/
void() item_upgrade_shells =
{
	precache_model ("progs/backpackshells.mdl");
	precache_sound ("weapons/lock4.wav");
	
	if (!self.upgrade_flag)
		self.upgrade_flag = GetUpgradeFlag();
	else
		dprint("using overriden upgrade flag at "); dprint(vtos(self.origin)); dprint ("\n");

	self.armortype = UpgradeType_Shells;
	self.netname = "$mg3_qc_upgrade_shell";
	self.noise = "weapons/lock4.wav";
	
	setmodel (self, "progs/backpackshells.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.think = StartUpgradeItem;
	self.nextthink = time + 0.5;
};

/*QUAKED item_upgrade_nails (0 .5 .8) (0 0 0) (32 32 32)
Upgrade pickup for nail capacity
*/
void() item_upgrade_nails =
{
	precache_model ("progs/backpacknails.mdl");
	precache_sound ("weapons/lock4.wav");
	
	if (!self.upgrade_flag)
		self.upgrade_flag = GetUpgradeFlag();
	else
		dprint("using overriden upgrade flag at "); dprint(vtos(self.origin)); dprint ("\n");

	self.armortype = UpgradeType_Nails;
	self.netname = "$mg3_qc_upgrade_nail";
	self.noise = "weapons/lock4.wav";
	
	setmodel (self, "progs/backpacknails.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.think = StartUpgradeItem;
	self.nextthink = time + 0.5;
};

/*QUAKED item_upgrade_rockets (0 .5 .8) (0 0 0) (32 32 32)
Upgrade pickup for rocket capacity
*/
void() item_upgrade_rockets =
{
	precache_model ("progs/backpacker.mdl");
	precache_sound ("weapons/lock4.wav");
	
	if (!self.upgrade_flag)
		self.upgrade_flag = GetUpgradeFlag();
	else
		dprint("using overriden upgrade flag at "); dprint(vtos(self.origin)); dprint ("\n");

	self.armortype = UpgradeType_Rockets;
	self.netname = "$mg3_qc_upgrade_rocket";
	self.noise = "weapons/lock4.wav";
	
	setmodel (self, "progs/backpacker.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.think = StartUpgradeItem;
	self.nextthink = time + 0.5;
};

/*QUAKED item_upgrade_cells (0 .5 .8) (0 0 0) (32 32 32)
Upgrade pickup for cell capacity
*/
void() item_upgrade_cells =
{
	precache_model ("progs/backpackcells.mdl");
	precache_sound ("weapons/lock4.wav");
	
	if (!self.upgrade_flag)
		self.upgrade_flag = GetUpgradeFlag();
	else
		{dprint("using overriden upgrade flag at "); dprint(vtos(self.origin)); dprint ("\n");}

	self.armortype = UpgradeType_Cells;
	self.netname = "$mg3_qc_upgrade_cell";
	self.noise = "weapons/lock4.wav";
	
	setmodel (self, "progs/backpackcells.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.think = StartUpgradeItem;
	self.nextthink = time + 0.5;
};

//=============================================================================

// For debug impulse giving next free item
void GiveNextFreeUpgrade(UpgradeType Type, entity client)
{
	entity oself;
	string name = "";
	float param = GetUpgradeFlagValue(Type);
	switch(Type)
	{
		case UpgradeType_Health:
			name = "Health";
			break;
		case UpgradeType_Shells:
			name = "Shell";
			break;
		case UpgradeType_Nails:
			name = "Nail";
			break;
		case UpgradeType_Rockets:
			name = "Rocket";
			break;
		case UpgradeType_Cells:
			name = "Cells";
			break;
		default:
			dprint("Unknown upgrade type. Nothing happened.\n");
	}

	float flag = 1;
	while(flag <= UPGRADE15)
	{
		if(flag & param == 0)
		{
			//This one is free
			oself = self;
			self = spawn();
			self.upgrade_flag = flag;
			self.armortype = Type;
			self.netname = name;
			other = client;
			UpgradeTouch();
			self = oself;
			return;
		}
		flag *= 2;
	}
	dprint("You are already fully upgraded! Congrats!\n");
}
