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

const float MESSAGE_ALL_PLAYERS = 8388608;

void() SUB_Null = {};
float(...) SUB_True = { return TRUE; };
void(entity attacker, float damage) SUB_NullPain = {};

void() SUB_Remove = {remove(self);};


/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
void() SetMovedir =
{
	if (self.movedir)
	{
		self.angles = '0 0 0';
		return;
	}
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	self.angles = '0 0 0';
};


/*
================
RemovedOutsideCoop
Removes self if COOP_ONLY spawnflag is set and we're not in coop.
Returns TRUE if it was removed.
================
*/
float RemovedOutsideCoop()
{
	if (!coop && (self.spawnflags & COOP_ONLY))
	{
		remove(self);
		return TRUE;
	}
	return FALSE;
}

/*
================
RemovedRuneCheck
Checks an item against current rune count 

const float SIGIL_E1 = 1;
const float SIGIL_E2 = 2;
const float SIGIL_E3 = 4;
const float SIGIL_E4 = 8;
const float SIGIL_E5 = 16;
================
*/
float RemovedRuneCheck()
{
	local float rune_count;
	rune_count = 0;
	if (serverflags & SIGIL_E1)
		rune_count++;
	if (serverflags & SIGIL_E2)
		rune_count++;
	if (serverflags & SIGIL_E3)
		rune_count++;
	if (serverflags & SIGIL_E4)
		rune_count++;

	if ((self.spawnflags & NOT_IF_0_RUNES) && rune_count == 0)
	{
		remove(self);
		return TRUE;
	}
	if ((self.spawnflags & NOT_IF_1_RUNES) && rune_count == 1)
	{
		remove(self);
		return TRUE;
	}
	if ((self.spawnflags & NOT_IF_2_RUNES) && rune_count == 2)
	{
		remove(self);
		return TRUE;
	}
	if ((self.spawnflags & NOT_IF_3_RUNES) && rune_count == 3)
	{
		remove(self);
		return TRUE;
	}
	if ((self.spawnflags & NOT_IF_4_RUNES) && rune_count == 4)
	{
		remove(self);
		return TRUE;
	}

	return FALSE;
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
	if (RemovedOutsideCoop()) return;

	if (RemovedRuneCheck()) return;
	
	// trigger angles are used for one-way touches.  An angle of 0 is assumed
	// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
local entity	stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
local vector	vdestdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// calculate length of vector
	len = vlen (vdestdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


/*
=============
SUB_CalcAngleMove

calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating 

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
local entity		stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
local vector	destdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");
		
	// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	
	// calculate length of vector
	len = vlen (destdelta);
	
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

	// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


//=============================================================================
void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/
void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;

	//
	// check for a delay
	//
	if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		t.spawnflags = self.spawnflags & MESSAGE_ALL_PLAYERS;
#ifdef ALLOW_DELAYED_THINK_CANCEL
		t.targetname = self.targetname;
		t.use = SUB_Null;
#endif
		return;
	}
	
	
	//
	// print the message
	//
	if (((activator.classname == "player") || (self.spawnflags & MESSAGE_ALL_PLAYERS)) && (self.message != ""))
	{
		if(self.spawnflags & MESSAGE_ALL_PLAYERS)
		{
			centerprint_all (self.message); //Ingame message, localized
		}
		else
		{
			centerprint (activator, self.message); //Ingame message, localized
		}
		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

	//
	// kill the killtagets
	//
	if (self.killtarget)
	{
		t = find (world, targetname, self.killtarget);
		
		while( t )
		{
			remove (t);
			t = find (t, targetname, self.killtarget);
		}
	}
	
	//
	// fire targets
	//
	if (self.target)
	{
		act = activator;
		t = find (world, targetname, self.target);
		while( t )
		{
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
				self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
			t = find (t, targetname, self.target);
		}
	}
	

};

/* SUB_UseOtherTargets, AY August 13, 2025
Since we are adding other targets that can fire off of monsters (and maybe other thigns?!)
I wanted a function to fire those targets directly, without needing to shuffle around targets,
and also without worrying about firing killtargets as well.
*/
void(string othername) SUB_UseOtherTargets =
{
	local entity t, stemp, otemp, act;
	
	act = activator;
	t = find (world, targetname, othername);
	while( t )
	{
		stemp = self;
		otemp = other;
		self = t;
		other = stemp;
		if (self.use != SUB_Null)
		{
			if (self.use)
			self.use ();
		}
		self = stemp;
		other = otemp;
		activator = act;
		t = find (t, targetname, othername);
	}
};
// End of AY addition, August 13 2025


/*

in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically
update: not anymore! it makes nightmare too easy
*/

void(float normal) SUB_AttackFinished =
{
	self.cnt = 0;		// refire count for nightmare
	//if (skill != 3)
	self.attack_finished = time + normal;
};

float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire =
{
	if (skill != 3)
		return;
	if (self.cnt == 1)
		return;
	if (!visible (self.enemy))
		return;
	self.cnt = 1;
	self.think = thinkst;
};



/*
================
SUB_SwitchTargets
================
*/

void SUB_SwitchTargets(.string field, string oldtarget, string newtarget)
{
	entity e = find(world, targetname, oldtarget);
	while(e)
	{
		e.field = newtarget;
		e = find(e, targetname, oldtarget);
	}
}

/*
================
SUB_FindWithPredicate
================
*/

entity SUB_FindWithPredicate(entity start, .string field, string search, float(entity e) predicate = (float(entity e))SUB_True)
{
	entity t = find(start, field, search);
	while(t && !predicate(t))
	{
		t = find(t, field, search);
	}
	return t;
}

/*
================
SUB_CountTargets
================
*/

float SUB_CountTargets(entity e, float(entity e) predicate = (float(entity e))SUB_True) 
{
	float cnt = 0;
	entity t = SUB_FindWithPredicate(world, targetname, e.target, predicate);
	while(t)
	{
		cnt++;
		t = SUB_FindWithPredicate(t, targetname, e.target, predicate);
	}
	return cnt;
}

/*
================
SUB_RandomTarget
================
*/

entity SUB_RandomTarget(entity e, float(entity e) predicate = (float(entity e))SUB_True) 
{
	float cnt = SUB_CountTargets(e, predicate);
	if (cnt == 0) return world;
	cnt = floor(cnt * random());
	entity t = SUB_FindWithPredicate(world, targetname, e.target, predicate);
	while(cnt--)
	{
		t = SUB_FindWithPredicate(t, targetname, e.target, predicate);
	}
	return t;
}

/*
================
SUB_SetWorldType
================
*/

void SUB_SetWorldtype()
{
	if(self.worldtype) 
	{
		self.worldtype--;
	}
	else
	{
		self.worldtype = world.worldtype;
	}
}

