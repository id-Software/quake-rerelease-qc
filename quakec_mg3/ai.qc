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

void() t_movetarget;
void() knight_walk1;
void() knight_bow6;
void() knight_bow1;
void(entity etemp, entity stemp, entity stemp, float dmg) T_Damage;
float CanTakedamage(entity e) = { return e.takedamage > 0; }
/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/

// added way to fire targets when monsters first find a target. AY, Aug 13 2025
.string aggro_target;
// End AY addition


//
// globals
//

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;

float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/


/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
	if (!self.targetname)
		objerror ("path_corner with no targetname.\n");
	
	if (self.wait < 0) self.wait = 999999;

	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
	local entity	temp;
	
	if (other.movetarget != self)
	return;
	
	if (other.enemy)
	return;		// fighting, not following a path
	
	self.owner = other; //We have a valid visitor!
	if(other.dmg_inflictor && other.dmg_inflictor.classname == "path_corner")
	{
		//Clear the previous path corner from owning our new visitor
		if(other.dmg_inflictor.owner == other.dmg_inflictor)
		{
			other.dmg_inflictor.owner = world;
		}
	}
	other.dmg_inflictor = self;
	
	if(other.pausetime > time)
	return; // Waiting to walk...
	
	temp = self;
	self = other;
	other = temp;
	
	if (self.classname == "monster_ogre")
	sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound
	
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand ();
	}
	else if(other.wait)
	{
		self.pausetime = time + other.wait;
		self.th_stand ();
	}
};

//============================================================================
// Functions for changing how path_corners work.
//============================================================================
void monster_use();

void target_cancelpause_use()
{
	entity mon = find(world, targetname, self.target);
	while(mon)
	{
		if(mon.flags & FL_MONSTER)
		{
			mon.pausetime = 0;
			mon.use = monster_use;
		}
		mon = find(mon, targetname, self.target);
	}
}

/*QUAKED target_cancelpause (0.5 0.3 0) (-8 -8 -8) (8 8 8)
When activated, will zero out the pausetime for monsters, causing them to continue walking their paths.
*/
void target_cancelpause()
{
	if(!self.target) objerror("target_cancelpause with no target given.\n");
	if(!self.targetname) objerror("target_cancelpause with no targetname given.\n");
	self.use = target_cancelpause_use;
}

//============================================================================

void target_switchpath_use()
{
	entity e = find(world, targetname, self.target);
	while(e)
	{
		if(e.classname == "path_corner")
		{
			string oldTarget = e.target;
			// Just switch the target
			e.target = self.netname;
			
			// Has this corner been visited by a monster lately?
			if(e.owner)
			{
				entity o = e.owner;
				entity oldTargetEntity = find(world, targetname, oldTarget);
				if(o.movetarget == oldTargetEntity)
				{
					// Switch that monster over to walk to the new target instead
					o.goalentity = o.movetarget = find(world, targetname, e.target);
					o.ideal_yaw = vectoyaw(o.goalentity.origin - o.origin);
				}
			}
		}
		e = find(e, targetname, self.target);
	}
}

/*QUAKED target_switchpath (0.5 0.3 0) (-8 -8 -8) (8 8 8)
When activated, will switch out the target .
*/
void target_switchpath()
{
	if(!self.target) objerror("target_switchtarget with no target given.\n");
	if(!self.targetname) objerror("target_switchtarget with no targetname given.\n");
	if(!self.netname) objerror("target_switchtarget with no netname given.\n");
	self.use = target_switchpath_use;
}

#ifdef MONSTERS_AWARE_OF_CONTENTS
#define RETURN_IF_DIED_FROM_CONTENTS_DAMAGE if(CheckContentsDamage()) return;

//============================================================================
// CheckContentsDamage
// Returns TRUE if the monster died and shouldn't proceed with its current think
//============================================================================

.float dmgtime;
float CheckContentsDamage()
{
	if(self.waterlevel == 0) return FALSE; //Not in any liquid
	if(self.health <= 0) return FALSE; //Dead or dying
	if(time < self.dmgtime) return FALSE; //Still processing damage from last time
	if(self.spawnflags & SPAWNFLAG_NO_CONTENTS_DAMAGE) return FALSE; //We're immune

	if(self.watertype == CONTENT_SLIME)
	{
		self.dmgtime = time + 1;
		T_Damage (self, world, world, 4 * self.waterlevel);
		// self.pain_finished = 0; //Enable for spasming monsters
	}
	else if(self.watertype == CONTENT_LAVA)
	{
		self.dmgtime = time + 0.2;
		if(self.classname == "monster_zombie")
		{
			T_Damage (self, world, world, 120); // GIB!
			return TRUE;
		}
		/*dprint("entity ");
		dprint(self.classname);
		dprint(" is taking damage from lava!\n");*/
		T_Damage (self, world, world, 30 * self.waterlevel);
		// self.pain_finished = 0; //Enable for spasming monsters
	}

	return self.health <= 0;
}
#else
#define RETURN_IF_DIED_FROM_CONTENTS_DAMAGE ;
#endif

//============================================================================

const vector RANGES_NORMAL = '120 500 1000';
const vector RANGES_NEARSIGHTED = '120 300 340';

const float VISIONCONE_NORMAL = 0.3;
const float VISIONCONE_NEARSIGHTED = 0.866; // ~30 degrees
/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/


float(entity targ) range =
{
	vector spot1 = self.origin + self.view_ofs;
	vector spot2 = targ.origin + targ.view_ofs;
	float r = vlen (spot1 - spot2);
	
	vector ranges = (self.spawnflags & SPAWNFLAG_NEARSIGHTED) ? ((self.enemy) ? RANGES_NORMAL * 0.8 : RANGES_NEARSIGHTED) : RANGES_NORMAL;
	
	if (r < ranges_x)
		return RANGE_MELEE;
	
	if (r < ranges_y)	
		return RANGE_NEAR;

	if (r < ranges_z)	
		return RANGE_MID;

	return RANGE_FAR;	
};	

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)	
		return TRUE;
	return FALSE;	
};	


/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/

float(entity targ) infront =
{
	local vector	vec;
	local float		dot, dottarget;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	dottarget = (self.spawnflags & SPAWNFLAG_NEARSIGHTED) ? VISIONCONE_NEARSIGHTED : VISIONCONE_NORMAL;
	if ( dot > dottarget)
	{
		return TRUE;
	}
	if (self.classname == "monster_orb")
	{
		if ((dot * -1) > dottarget)
		{
			dprint("spotted by second eye!\n");
			return TRUE;
		}
	}
	return FALSE;
};


//============================================================================

void() HuntTarget =
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished (1);	// wait a while before first attack
};

void() SightSound =
{
local float	rsnd;

	if (self.classname == "monster_ogre")
		// CG: Check if it's a rocket ogre
		if(self.aflag)
			sound (self, CHAN_VOICE, "armagon/sight.wav", 1, ATTN_NORM);
			//sound (self, CHAN_VOICE, "rogre/ogwake.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_knight")
		sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shambler")
		sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_demon1")
		sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_wizard")
		sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_zombie")
		sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_dog")
		sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_hell_knight")
	{
		if (!((self.solid == SOLID_NOT) && ((self.spawnflags & CORPSE_FLAG_A) || (self.spawnflags & CORPSE_FLAG_B))))
			sound (self, CHAN_VOICE, "hknight/sight1.wav", 1, ATTN_NORM);
	}
	else if (self.classname == "monster_tarbaby")
		sound (self, CHAN_VOICE, "blob/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_enforcer")
	{
		rsnd = rint(random() * 3);			
		if (rsnd == 1)
			sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
		else if (rsnd == 2)
			sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM);
		else if (rsnd == 0)
			sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM);
	}
	else if (self.classname == "monster_orb")
		sound (self, CHAN_VOICE, "boss2/sight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_army")
		sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shalrath")
		sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_ranged_knight")
	{
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "rknight/sight_01.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "rknight/sight_03.wav", 1, ATTN_NORM);
	}

	
};

/*
void() DelayAggro =
{
	local entity buddy, oself;
	buddy = find(world, targetname, self.target);
	dprint("doing the delay aggro\n");
	while(buddy)
	{
		dprint("entity: ");
		dprint(buddy.classname);
		dprint(" at ");
		dprint(vtos(buddy.origin));
		dprint("\n");

		if (!buddy.enemy)
		{
			oself = self;
			self = buddy;
			buddy.use();
			self = oself;
		}
		else
			dprint("already has an enemy\n");
		buddy = find(buddy, targetname, self.target);
	}

	remove(self);
};
*/

void() FoundTarget =
{
	if (self.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}

	// Special case for when hell knight corpses are rising! AY April 10, 2026
	if ((self.classname == "monster_hell_knight") && ((self.spawnflags & CORPSE_FLAG_A) || (self.spawnflags & CORPSE_FLAG_B)))
	{
		if (self.pain_finished > time)
		{
			return;
		}
	}

	
	// trigger Aggro target, if it exists. AY Aug 13, 2025
	// additional changes Feb 22, 2026 to fix weird edgecases
	/*local entity buddy, oself, t;
	local string aggro_name;

	if (self.aggro_target)
	{
		dprint("checking aggro targets\n");
		aggro_name = self.aggro_target;
		self.aggro_target = string_null;



		// Prevent infinite loop by clearing all linked names
		dprint("cleaning up buddies\n");
		buddy = find(world, aggro_target, aggro_name);
		local float c;
		c = 0;
		while (buddy)
		{
			c++;
			buddy.aggro_target = string_null;
			buddy = find(buddy, aggro_target, aggro_name);
		}
		dprint("cleaned up: ");
		dprint(ftos(c));
		dprint("\n");

		// Spawn an entity to trigger all the aggro'd enemies
		if (c)
		{
			dprint("Spawning delayed Aggro\n");
			t = spawn();
			t.classname = "DelayedAggro";
			t.nextthink = time + 0.1;
			t.think = DelayAggro;
			t.target = aggro_name;
			dprint("self.enemy is : ");
			dprint(self.enemy.classname);
			dprint("\n");
			t.enemy = self.enemy;
		}
		else
			dprint("don't spawn delayed aggro. No valid targets!\n");


	}
	//end AY changes.
	*/
	
	self.show_hostile = time + 1;		// wake up other monsters

	SightSound ();
	HuntTarget ();
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float() FindTarget =
{
	local entity	client;
	local float		r;

	//First, if we are attacking friends, try to find another friend
	if(self.spawnflags & MONSTER_ATTACK_FRIEND)
	{
		entity f = SUB_RandomTarget(self, CanTakedamage);
		if(f)
		{
			self.enemy = f;
			FoundTarget ();
			return TRUE;
		}
	}


	// if the first spawnflag bit is set, the monster will only wake up on
	// really seeing the player, not another monster getting angry

	// spawnflags & 3 is a big hack, because zombie crucified used the first
	// spawn flag prior to the ambush flag, and I forgot about it, so the second
	// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return FALSE;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
	{
		return FALSE;
	}
	
	if (!visible (client))
	{
		return FALSE;
	}
	
	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
		{
			return FALSE;
		}
	}
	else if (r == RANGE_MID)
	{
		if ( !infront (client))
		{
			return FALSE;
		}
	}
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	FoundTarget ();
	return TRUE;
};


//=============================================================================

void(float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

void(float dist) ai_back =
{
	walkmove ( (self.angles_y+180), dist);
};


/*
=============
ai_pain

stagger back a bit
=============
*/
void(float dist) ai_pain =
{
	ai_back (dist);
/*
	local float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void(float dist) ai_painforward =
{
	walkmove (self.ideal_yaw, dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
	RETURN_IF_DIED_FROM_CONTENTS_DAMAGE

	movedist = dist;
	
	// check for noticing a player
	if (FindTarget ())
		return;

	movetogoal (dist);
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() ai_stand =
{
	RETURN_IF_DIED_FROM_CONTENTS_DAMAGE

	if (FindTarget ())
		return;
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn =
{
	if (FindTarget ())
		return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};


//=============================================================================

float()	WizardCheckAttack;
float()	DogCheckAttack;

float() CheckAnyAttack =
{
	if (!enemy_visible)
		return FALSE;
	if (self.classname == "monster_army")
		return SoldierCheckAttack ();
	if (self.classname == "monster_ogre")
		return OgreCheckAttack ();
	if (self.classname == "monster_shambler")
		return ShamCheckAttack ();
	if (self.classname == "monster_demon1")
		return DemonCheckAttack ();
	if (self.classname == "monster_dog")
		return DogCheckAttack ();
	if (self.classname == "monster_wizard")
		return WizardCheckAttack ();
	if (self.classname == "monster_orb")
		return OrbCheckAttack();
	return CheckAttack ();
};


/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
void() ai_run_melee =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void() ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void() ai_run_slide =
{
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, movedist))
		return;
		
	if (self.classname == "monster_orb")
	{
		self.lefty = 1 - self.lefty; // strafe other direction next time
		//dprint("strafe failed, go forward instead\n");
		self.attack_state = AS_STRAIGHT; 
		self.think = self.th_run;
		return;
	}
	else
		self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, movedist);
};

/*
=============
ai_pathtogoal

Advanced movement code that use the bots pathfinder if allowed and conditions are right.
Feel free to add any other conditions needed.
=============
*/
void ai_pathtogoal( float dist ) {
	if ( self.allowPathFind == FALSE ) {
		movetogoal( dist ); // can't use pathfinding, so use normal Quake movement behavior.	
		return;
	}	
	
	if ( enemy_visible ) {
		if ( self.combat_style == CS_RANGED ) {
			// do the normal "shoot, walk, shoot" behavior...
			movetogoal( dist );
			return;
		} else if ( self.combat_style == CS_MELEE ) {
			// path pretty close to the enemy, then let normal Quake movement take over.
			if ( enemy_range > RANGE_NEAR ) {
				if ( walkpathtogoal( dist, self.enemy.origin ) == PATH_IN_PROGRESS ) {
					return;
				}
			}
		} else if ( self.combat_style == CS_MIXED ) {
			// most mixed combat AI have fairly short range attacks, so try to path within mid range.
			if ( enemy_range > RANGE_MID ) {
				if ( walkpathtogoal( dist, self.enemy.origin ) == PATH_IN_PROGRESS ) {
					return;
				}
			}
		}
	} else {
		// we can't see our enemy, let's see if we can path to them
		if ( walkpathtogoal( dist, self.enemy.origin ) == PATH_IN_PROGRESS ) {
			return;
		}
	}

	movetogoal( dist ); // fall back to normal Quake movement behavior.
}

/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) ai_run =
{
	RETURN_IF_DIED_FROM_CONTENTS_DAMAGE

	movedist = dist;
// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget ();
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy
	enemy_visible = visible(self.enemy);
	if (enemy_visible)
		self.search_time = time + 5;

// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			return;
	}

	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
		ai_run_missile ();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
//dprint ("ai_run_melee\n");
		ai_run_melee ();
		return;
	}

	if (CheckAnyAttack ())
		return;					// beginning an attack
		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide ();
		return;
	}

	if ( isHordeMode ) {
		ai_pathtogoal( dist );
	} else {
		// head straight in
		movetogoal( dist );		// done in C code...
	}
};

