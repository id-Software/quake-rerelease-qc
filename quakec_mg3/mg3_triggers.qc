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

float REQUIRE_RUNE_1 = 1;
float REQUIRE_RUNE_2 = 2;
float REQUIRE_RUNE_3 = 4;
float REQUIRE_RUNE_4 = 8;

/*QUAKED trigger_always (.5 .5 .5) ? nomessage message_all
Immediately on map load, fires its targets.
*/
void() trigger_always =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;
	
	self.think = SUB_UseTargets;
	self.nextthink = time + 0.1;
};

void() rune_relay_use =
{
	// AY, Dec 17 2025
	// I'm writing this in a bad way because trying to do it the right way with bit shifts is breaking my brain
	// If the spawnflag requires a sigil, and the serverflag doesn't include it, then return.
	if ((self.spawnflags & SIGIL_E1) && !(serverflags & SIGIL_E1))
		return;
	if ((self.spawnflags & SIGIL_E2) && !(serverflags & SIGIL_E2))
		return;
	if ((self.spawnflags & SIGIL_E3) && !(serverflags & SIGIL_E3))
		return;
	if ((self.spawnflags & SIGIL_E4) && !(serverflags & SIGIL_E4))
		return;

	self.think = SUB_UseTargets;
	self.nextthink = time + 0.1;
};
/*QUAKED trigger_rune_relay (.5 .5 .5) ? nomessage message_all
When this entity receives a signal, it checks against the specific runes in its spawnflags.
If the player has all of the required runes, then the signal is passed along to its target.
*/
void() trigger_rune_relay =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;
	
	self.use = rune_relay_use;
};

void() rune_counter_use =
{
	local float runes;
	runes = 0;
	if (serverflags & SIGIL_E1)
		runes++;
	if (serverflags & SIGIL_E2)
		runes++;
	if (serverflags & SIGIL_E3)
		runes++;
	if (serverflags & SIGIL_E4)
		runes++;

	if (runes >= self.count)
		SUB_UseTargets();
};

float REQUIRE_BN_ACTIVE = 1;
float REQUIRE_BN_NEWGAME = 2;
float REQUIRE_BN_DISCOVERED = 4;
float REQUIRE_BN_NOT_ACTIVE = 8;
float REQUIRE_BN_NOT_NEWGAME = 16; 
float REQUIRE_BN_NOT_DISCOVERED = 32;

/*
float BLOODY_NIGHTMARE_ACTIVE = 1;
float BLOODY_NIGHTMARE_DISCOVERED = 2;
float BLOODY_NIGHTMARE_NEWGAME = 4;
*/
void() trigger_bloodynightmare_relay =
{
	self.use = bn_relay_use;
}

void() bn_relay_use =
{
	float can_trigger;
	can_trigger = 1;
	if ((self.spawnflags & REQUIRE_BN_ACTIVE) && (!(serverflags & BLOODY_NIGHTMARE_ACTIVE)))
		return;
	if ((self.spawnflags & REQUIRE_BN_NEWGAME) && (!(serverflags & BLOODY_NIGHTMARE_NEWGAME)))
		return;
	if ((self.spawnflags & REQUIRE_BN_NOT_ACTIVE) && (serverflags & BLOODY_NIGHTMARE_ACTIVE))
		return;
	if ((self.spawnflags & REQUIRE_BN_NOT_NEWGAME) && (serverflags & BLOODY_NIGHTMARE_NEWGAME))
		return;
	if ((self.spawnflags & REQUIRE_BN_DISCOVERED) && (!(serverflags & BLOODY_NIGHTMARE_DISCOVERED)))
		return;
	if ((self.spawnflags & REQUIRE_BN_NOT_DISCOVERED) && ((serverflags & BLOODY_NIGHTMARE_DISCOVERED)))
		return;

	SUB_UseTargets();

}

/*QUAKED trigger_rune_counter (.5 .5 .5) ? nomessage message_all
When this entity receives a signal, it checks how many runes the player has collected.
If the player has as many or more runes as this entity's count, then the signal is passed along to its target.
*/
void() trigger_rune_counter =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;
	
	if (!self.count)
		self.count = 2;

	self.use = rune_counter_use;
};

/*QUAKED trigger_tome (0 .5 .8)
AY, addition, August 15, 2025
*/
void() trigger_lore_touch =
{
	if (!(other.flags & FL_CLIENT))
		return;
	
	if (time > other.lore_active)
	{
		other.lore_active = time + 0.5; //throttle refire rate



		centerprint(other, self.message);
	}
	
};

void() trigger_lore = 
{
	// special case for the hub
	if (world.model == "maps/hub.bsp")
	{
		if ((serverflags & SIGIL_E1) && (self.message == "$mg3_hub_rune1_hint"))
			self.message = "$mg3_hub_rune1_hint_complete";
		else if ((serverflags & SIGIL_E2) && (self.message == "$mg3_hub_rune2_hint"))
			self.message = "$mg3_hub_rune2_hint_complete";
		else if ((serverflags & SIGIL_E3) && (self.message == "$mg3_hub_rune3_hint"))
			self.message = "$mg3_hub_rune3_hint_complete";
	}

	if (world.model == "maps/map4.bsp")
	{
		if (self.message == "$mg3_hint_bloody_nightmare_new")
		{
			if ((serverflags & BLOODY_NIGHTMARE_ACTIVE) || (serverflags & BLOODY_NIGHTMARE_DISCOVERED) || 
				(serverflags & BLOODY_NIGHTMARE_NEWGAME))
			{
				remove(self);
			}
			
		}
	}

	self.netname = "trigger_lore"; // for bot nav support.
	InitTrigger ();
	
	self.touch = trigger_lore_touch;
	self.pausetime = -1;
};

//=============================================================================
/*QUAKED trigger_door_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)

This entity targets doors and buttons, checks their states, and modifies

Note that doors and buttons have 4 states:
STATE_TOP (stationary at top position)
STATE_BOTTOM (stationary at bottom position)
STATE_UP (moving to the top position)
STATE_DOWN (moving to the bottom position)

By default, the relay will toggle 
*/
float IGNORE_IF_TOP = 1;
float IGNORE_IF_BOTTOM = 2;
//.string door_group;

void() UseDoorRelay =
{
	local entity t, oself;
	t = find(world, targetname, self.target);
	while(t)
	{
		dprint(t.classname);
		dprint(" is in state: ");
		dprint(ftos(t.state));
		dprint("\n");
	
		if ((t.state == STATE_TOP) || (t.state == STATE_UP))
		{
			if (!(self.spawnflags & IGNORE_IF_TOP))
			{
				
				oself = self;
				self = t;
				if (t.classname == "func_door")
					door_go_down();
				else if (t.classname == "func_button")
					button_return();
				self = oself;
				dprint("going down\n");
			}
		}
		else if ((t.state == STATE_BOTTOM)||(t.state == STATE_DOWN))
		{
			if (!(self.spawnflags & IGNORE_IF_BOTTOM))
			{
				oself = self;
				self = t;
				if (t.classname == "func_door")
					door_go_up();
				else if (t.classname == "func_button")
					button_fire();
				
				self = oself;
				dprint("going up\n");
			}
		}
		t = find(t, targetname, self.target);
	}
};
void() trigger_door_relay =
{
	if (!self.target)
	{
		dprint("ERROR: Bad setup on trigger_door_relay! Removing.\n\n");
		remove(self);
	}
	self.use = UseDoorRelay;
};


// AY: This is a system for checking the state of a bunch of doors against a goal state
// Can use this for things like code-entry pressure-plates and switches.
.float goal_state;

void() UseDoorgroup =
{
	local entity t;

	t = find (world, category, self.category);
	while(t)
	{
		if ((((t.state == STATE_BOTTOM) || (t.state == STATE_DOWN)) && t.goal_state == STATE_TOP)
			|| (((t.state == STATE_TOP) || (t.state == STATE_UP)) && t.goal_state == STATE_BOTTOM))
		{
			dprint("Failed! ");
			dprint(t.classname);
			dprint(" is in state ");
			dprint(ftos(t.state));
			dprint(" with goal of ");
			dprint(ftos(t.goal_state));
			dprint("\n\n");
			return;
		}
		t = find(t, category, self.category);
	}
	dprint("success!\n\n");
	SUB_UseTargets();
};

void() trigger_doorgroup_relay =
{
	if ((!self.category) || (!self.target))
	{
		dprint("ERROR: Bad setup on trigger_doorgroup_relay! Removing.\n\n");
		remove(self);
	}
	self.use = UseDoorgroup;
};

// AY:

void() touch_teleport_silent =
{
	local vector org;
	if (other.classname != "player")
	return;
	
	// Teleport the player
	org = other.origin;
	org_z = (other.origin_z + self.height);
	if (self.height < 0)
		org_z += 1;
	spawn_tdeath(org, other);
	setorigin(other, org);
	
}; 

void() trigger_teleport_silent =
{
	if (!self.height)
		self.height = -2048;
	InitTrigger ();
	self.touch = touch_teleport_silent;
};

void() trigger_music_use =
{
	local entity trig;

	if (self.sounds == self.style)
	{
		dprint("Attempted to change to track that is already playing! Ignore!\n");
		return;
	}
	
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, self.style);
	WriteByte (MSG_ALL, self.style); // not sure why this is needed twice...


	// update all of the trigger_music entities to be aware what the current track is!
	trig = find(world, classname, "trigger_music");
	while (trig)
	{
		trig.sounds = self.style;
		trig = find(trig, classname, "trigger_music");
	}
};

void() trigger_music =
{
	self.sounds = world.sounds;

	if (!self.targetname)
		remove(self);

	if (!self.style)
		self.style = 3;

	self.use = trigger_music_use;
};

// TEST, feb 22 2026
void() cutscene_touch =
{
	entity pl;
	entity pos;
	if (other.classname != "player")
		return;

	self.touch = SUB_Null;


	pos = find(world, classname, "info_intermission");
	if (!pos)
		error ("no intermission camera!");

	WriteByte (MSG_ALL, SVC_CUTSCENE);

	pl = find(world, classname, "player");
	while (pl)
	{
		pl.view_ofs = '0 0 0';
		pl.angles = pos.mangle;
		pl.mangle = pos.mangle;
		pl.fixangle = TRUE;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = 0;
		setorigin (pl, pos.origin);

		pl = find (pl, classname, "player");
	}




	
}
void() trigger_cutscene =
{
	InitTrigger();
	self.touch = cutscene_touch;
};

void() trigger_heal =
{
	if (!self.dmg)
		self.dmg = 1;
	if (!self.wait)
		self.wait = 0.1;

	InitTrigger ();
	self.touch = heal_touch;
}

void() heal_touch =
{
	if (other == world)
		return;
	if (other.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	T_Heal(other, self.dmg, FALSE);
	self.attack_finished = time + self.wait;
	
}

void() trigger_quad =
{
	precache_sound("items/damage.wav");
	InitTrigger ();
	self.touch = quad_touch;
}

void() quad_touch =
{
	if (other == world)
		return;

	if (other.classname == "player")
	{
		if (!(other.items & IT_QUAD))
		{
			other.items = other.items | IT_QUAD;
			sound (other, CHAN_ITEM, "items/damage.wav", 1, ATTN_NORM);
		}
		other.super_damage_finished = time + 0.1;
		other.super_time = 2;
	}
}

void() use_kill_monster =
{
	local entity f;
	f = find(world, targetname, self.target);
	while (f)
	{
		if ((f.flags & FL_MONSTER) && (f.health > 0))
		{
			T_Damage(f, activator, activator, f.health * 2);
		}

		f = find(f, targetname, self.target);
	}

}

void() trigger_relay_killmonster =
{
	if ((!self.targetname) || (!self.target))
	{
		dprint("trigger_relay_killmonster at"); dprint(vtos(self.origin)); dprint(" is missing target or targetname!!!\n");
		remove(self);
	}
	self.use = use_kill_monster;
}