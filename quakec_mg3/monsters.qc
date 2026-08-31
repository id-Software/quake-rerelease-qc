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

/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };

float MONSTER_SPAWNED = 4;
float MONSTER_SPAWNED_ANGRY = 8;
float MONSTER_SPAWNED_TFOG = 16;
float MONSTER_WAITWALK = 4096;

float MONSTER_TYPE_WALK = 1;
float MONSTER_TYPE_FLY = 2;
float MONSTER_TYPE_SWIM = 3;

float MONSTER_SIZE_SMALL = 1;
float MONSTER_SIZE_LARGE = 2;

/* New target types for more complex scripting off of monsters. AY, August 13 2025
"aggro_target" is a target that gets fired when the monster wakes up. This allows triggering traps and ambushes more easily.
"health_target" is a link to a trigger_health_relay which checks against health thresholds
*/
.string aggro_target;
.string health_target;
//end AY add.

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	local entity f;
	f = activator;
	
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
	{
		if ((self.classname == "monster_hell_knight") && ((self.spawnflags & CORPSE_FLAG_A) || (self.spawnflags & CORPSE_FLAG_B)))
		{
			self.th_run();
		}
		return;
	}
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
	{
		// AY Nov 5 2025, fix for bug where trigger-spawning angry from infighting fails
		// This is because the activator is not the player. So we need to find the player manually.
		f = find(world, classname, "player");
		while (f!= world && f.health <= 0) 
		{
			f = find(f, classname, "player");
		}
		
		if (f == world)
		{
			dprint("ERROR: Could not find player for spawnangry\n");
			return;
		}
	}

// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = f;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
	// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;
	
	

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};

void monster_begin_walking()
{
	if ((self.health <= 0) || (self.enemy)) // Don't start walking if dead or already has target
	{
		self.use = SUB_Null;
		return;
	}
	self.use = monster_use;
	self.pausetime = 0;
	self.th_walk();
}

//============================================================================

void() StartMonster =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, self.mdl);
	if(self.state == MONSTER_SIZE_SMALL) setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if(self.state == MONSTER_SIZE_LARGE) setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	if(self.lefty == MONSTER_TYPE_WALK)
	{
		self.origin_z = self.origin_z + 1;	// raise off floor a bit
		droptofloor();
	}

	if (!walkmove(0,0))
	{
		dprint ("monster in wall at: ");
		dprint (vtos(self.origin));
		dprint (":\n");

		dprint (self.classname);
		if(self.target){
			dprint (" (target = ");
			dprint (self.target);
			dprint (" )");
		}
		if(self.targetname){
			dprint (" (targetname = ");
			dprint (self.targetname);
			dprint (" )");
		}
		dprint ("\n");
	}

	if(self.spawnflags & MONSTER_SPAWNED)
	{
		spawn_tdeath (self.origin, self);
		if(self.spawnflags & MONSTER_SPAWNED_TFOG)
		{
			spawn_tfog(self.origin);
		}
	}
	
	
	self.takedamage = DAMAGE_AIM;
	
	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
	self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.team = TEAM_MONSTERS;
	
	self.flags = self.flags | FL_MONSTER;
	if(self.lefty == MONSTER_TYPE_FLY) self.flags = self.flags | FL_FLY;
	if(self.lefty == MONSTER_TYPE_SWIM) self.flags = self.flags | FL_SWIM;
	
	if (self.target)
	{
		if(self.spawnflags & MONSTER_ATTACK_FRIEND)
		{
			entity f = SUB_RandomTarget(self, CanTakedamage);
			if(f)
			{
				self.enemy = f;
				FoundTarget ();
				return;
			}
		}
	
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		if (self.movetarget.classname == "path_corner")
		{
			if(self.spawnflags & MONSTER_WAITWALK)
			{
				self.pausetime = 99999999;
				self.th_stand ();
				self.use = monster_begin_walking;
			}
			else
			{
				self.th_walk ();
			}
		}
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
	
	if(self.spawnflags & MONSTER_SPAWNED)
	{
		if(self.spawnflags & MONSTER_SPAWNED_ANGRY)
		{	
			monster_use(); //Make monster angry!
		}
		
		
	}
	else
	{
		// spread think times so they don't all happen at same time
		self.nextthink = self.nextthink + random()*0.5;
	}
};

void InitMonster(string model, float type, float size)
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	if (RemovedRuneCheck()) return;

	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;
	
	self.flags |= FL_FUTUREMONSTER;

	self.mdl = model;
	self.lefty = type;
	self.state = size;
	
	// AY: adding category to monsters for easier work across the whole category
	// like with the Draught of Insight. Aug 15, 2025
	//self.category = CATEGORY_MONSTER;
	// End AY add.
	
	// CG: This was removed because it caused the entity alpha to differ from the baseline alpha somehow, causing it to be transmitted over the network every frame for every monster.
	// self.alpha = 1; 
	
	total_monsters = total_monsters + 1;

	// AY: Setting up health target. Aug 14 2025
	if (self.health_target)
		self.max_health = self.health; // track this for later

	if(self.spawnflags & MONSTER_SPAWNED)
	{
		self.use = StartMonster;
		return;
	}
	// delay drop to floor to make sure all doors have been spawned
	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = StartMonster;


}

// Yoder Sept24 2021, Horde Merge
// Monster fade, used to fade out the model a few seconds after deathmatch
void() MonsterFade2 =
{
	if (self.alpha > 0)
	{
		self.alpha = self.alpha - 1 * frametime;
		//self.think = MonsterFade;
		self.nextthink = time; // think next frame
	}
	else
		remove(self);
}
void() MonsterFade =
{
	if (!cvar("horde"))
	{
		self.think = SUB_Null;
		return;
	}
	if (!self.alpha)
		self.alpha = 1;
	self.think = MonsterFade2;
	self.nextthink = time + 10 + random() * 5; // wait a bit before fading
};