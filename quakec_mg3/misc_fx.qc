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

.float storednextthink;
.void() storedthink;

//============================================================================
// SCREENSHAKE
//============================================================================
float SILENT_SHAKE = 1;

void() T_Shake =
{
	local entity t;
	local float starttime;
	local float hit;

	starttime = self.storednextthink - self.wait;
	
	// early out if intermission is running
	if (intermission_running)
		return;
	
	// Completed, cleanup!
	if (time > self.storednextthink)
	{
		if (!(self.spawnflags & SILENT_SHAKE))
			sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
		
		t = find( world, classname, "player" );
		while (t)
		{
			t.v_angle_z = 0;
			t = find( t, classname, "player" );
		}
		return;
	}
	
	// Ramp up? 
	if (time < self.delay)
		hit = (time - starttime) / (self.wait/3);
		
	else
		hit = 1;
	
	// dprint("intensity: ");
	// dprint(ftos(hit));
	// dprint("\n");
	
	hit = self.dmg * hit;
	
	// for each player
	t = find( world, classname, "player" );
	while (t)
	{
		// do the shake!
		t.punchangle_x = random() * hit;
		t.punchangle_y = crandom() * hit;
		t.punchangle_z = random() * hit;
		
		t = find( t, classname, "player" );
	}

	self.nextthink = time + 0.05;
};

void() screenshake_use =
{
	self.storednextthink = time + self.wait; // when to end
	self.delay = time + (self.wait / 3); // how long to ramp up
	
	if (!(self.spawnflags & SILENT_SHAKE))
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	self.think = T_Shake;
	self.nextthink = time + 0.05;
};

/*QUAKED trigger_screenshake

wait is duration of the shake
dmg is the intensity of the shake
*/
void() trigger_screenshake =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;

	// wait is sustain time
	// dmg is intensity
	if (!(self.spawnflags & SILENT_SHAKE))
	{
		self.noise = "misc/quake.wav";
		self.noise1 = "misc/quakeend.wav";
		precache_sound(self.noise);
		precache_sound(self.noise1);
	}
	
	if (!self.wait) // no duration!
		self.wait = 2;
		
	if (!self.dmg) // no intensity!
		self.dmg = 3;

	self.use = screenshake_use;
}

//============================================================================
// SOUND TRIGGER
//============================================================================

void() trigger_sound_play =
{
	if (!self.noise)
		return;
	
	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
};
/*QUAKED trigger_sound
*/
void() trigger_sound = 
{
	if (!self.noise)
		remove(self);
	
	precache_sound (self.noise);
	self.use = trigger_sound_play;
	
};

//============================================================================
// TRIGGER LIGHTNING
//============================================================================

const float LIGHTNING_RANDOM_TARGET = 1;
const float LIGHTNING_TRACE_BACKWARDS = 2;
const float LIGHTNING_NO_ACTIVATE_TARGET = 4;
const float LIGHTNING_TRIGGER_TARGETS_ONCE = 8;
const float LIGHTNING_SILENT = 16;
void() play_lightning =
{
	if (!self.target)
	{
		dprint("lightning has no target!\n");
		return;
	}

	float rt = 0;
	if(self.spawnflags & LIGHTNING_RANDOM_TARGET)
	{
		float cnt = SUB_CountTargets(self);
		if(cnt == 0) return;
		rt = floor(cnt * random());
	}
	float triggertwice = (self.spawnflags & LIGHTNING_TRIGGER_TARGETS_ONCE) ? FALSE : TRUE; //Note boolean reversal
	float activatetargets = (self.spawnflags & LIGHTNING_NO_ACTIVATE_TARGET) ? FALSE : TRUE; //Note boolean reversal
	
	local entity t, oself;
	
	float i = 0;
	t = find(world, targetname, self.target);
	while(t)
	{
		if(self.spawnflags & LIGHTNING_RANDOM_TARGET)
		{
			if (i < rt){
				t = find(t, targetname, self.target);
				i++;
				continue;
			} 
			if (i > rt) return;
			i++;
		}

		vector endpos, startpos;
		if(self.spawnflags & LIGHTNING_TRACE_BACKWARDS)
		{
			traceline(t.origin, self.origin, TRUE, self);
			endpos = trace_endpos;
			startpos = t.origin;
		}
		else
		{
			traceline(self.origin, t.origin, TRUE, self);
			endpos = trace_endpos;
			startpos = self.origin;
		}
	
		if (!(self.spawnflags & LIGHTNING_SILENT))
			sound (t, CHAN_AUTO, self.noise, self.volume, ATTN_NORM); //Changed to CHAN_AUTO to allow more overlapping sounds

		// create the temp lightning entity
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, self.style);
		WriteEntity (MSG_BROADCAST, t);
		WriteCoord (MSG_BROADCAST, startpos_x);
		WriteCoord (MSG_BROADCAST, startpos_y);
		WriteCoord (MSG_BROADCAST, startpos_z);
		WriteCoord (MSG_BROADCAST, endpos_x);
		WriteCoord (MSG_BROADCAST, endpos_y);
		WriteCoord (MSG_BROADCAST, endpos_z);

		if(self.dmg)
		{
			LightningDamage (startpos, endpos, self, self.dmg);
		}
		
		//If activatetargets and t has a target, activate it.
		if(activatetargets && t.target)
		{
			oself = self;
			self = t;
			SUB_UseTargets();
			if(triggertwice)
			{
				float odelay = self.delay;
				self.delay = odelay + 0.2;
				SUB_UseTargets(); //Quickly turn on and off
				self.delay = odelay;
			}
			self = oself;
		}

		t = find(t, targetname, self.target);
	}
};

void() trigger_lightning =
{
	if(!self.noise) self.noise = "misc/power.wav";
	precache_sound(self.noise);
	self.use = play_lightning;

	switch(self.style)
	{
		default:
		case 0:
			self.style = TE_LIGHTNING3;
			break;
		case 1:
			self.style = TE_LIGHTNING1;
			break;
		case 2:
			self.style = TE_LIGHTNING2;
			break;
	}

	if(!self.volume)
		self.volume = 1;
	
	if(self.spawnflags & LIGHTNING_SILENT)
		self.volume = 0;
		
};

//============================================================================
// TRIGGER FADE
//============================================================================
/* Checks all targets to see if they are dead. If they are, then it starts a fade
*/
void() SUB_FadeTargets = 
{
	local entity t;
	local float count; // how many entities are being faded
	count = 0;
	
	if (self.target)
	{
		if(!self.state)
		{
			t = world;
			//Initialize all the targets with alpha = 1.0, so the fade out works.
			t = find (t, targetname, self.target);
			while (t)
			{
				t.alpha = 1.0;
				t = find (t, targetname, self.target);
			}
			self.state = 1; // Don't repeat this initialization after the first think.
		}

		t = world;
		t = find (t, targetname, self.target);
		while (t)
		{
			if (t.health <= 0)
			{	
				if (t.alpha > 0)
				{
					t.alpha = t.alpha - (frametime/self.delay);
					count = count + 1;
				}
				else
				{
					dprint("fade complete, removing ");
					dprint(t.classname);
					dprint("\n");
					remove(t);
				}
			}
			else
			{
				dprint ("target is still alive\n");
			}
			t = find (t, targetname, self.target);
		}
	}
	if (count > 0)
	{
		self.nextthink = time;
	}
	else
	{
		remove(self);
		dprint("removed fade manager\n");
	}
};

void() spawn_fade_manager =
{
	local entity fademanager;
	fademanager = spawn();
	dprint("spawn fade manager\n");
	fademanager.think = SUB_FadeTargets;
	fademanager.nextthink = time;
	fademanager.target = self.target;
	fademanager.delay = self.delay; // use delay to determine fade time, default to 1
}

void() trigger_fade =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;

	self.use = spawn_fade_manager;
	
	if (!self.delay)
		self.delay = 1; // delay determines fade time
};

//============================================================================
// TRIGGER FREEZE
//============================================================================
// Yoder Jan 14 2021


void() SUB_Freeze =
{
	self.storednextthink = self.nextthink;
	self.storedthink = self.think;
	self.nextthink = time;
	self.think = SUB_Null;
	self.is_frozen = 1;
};

void() SUB_Unfreeze =
{
	self.nextthink = self.storednextthink;
	self.think = self.storedthink;
	self.storednextthink = -1;
	self.is_frozen = 0;
};

void() SUB_FreezeTargets =
{
	local entity t;
	
	if (self.target)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t)
				return;
			
			if (!(t.is_frozen)) // check if already frozen
			{
				// freeze
				t.storednextthink = t.nextthink;
				t.storedthink = t.think;
				t.nextthink = time;
				t.think = SUB_Null;
				t.is_frozen = 1;
				
			}
			else
			{
				// unfreeze
				t.nextthink = t.storednextthink;
				t.think = t.storedthink;
				t.storednextthink = -1;
				t.is_frozen = 0;
			}
		} while (1);
	}
};

/* Define the entity, trigger_freeze
	Works like a trigger relay
*/
void() trigger_freeze =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;
	
	self.use = SUB_FreezeTargets;
};

//============================================================================
// particle_embers
//============================================================================
void() particle_embers_think =
{
	local vector pos;
	local vector speed;
	speed = '0 0 2' * random() + '0 0 2';
	speed_x = crandom() * self.velocity_x;
	speed_y = crandom() * self.velocity_y;
	speed_z = speed_z * self.velocity_z;
	pos = self.origin;
	pos_x = pos_x + self.size_x * crandom();
	pos_y = pos_y + self.size_y * crandom();
	//pos = crandom() * self.size + self.origin;
	particle(pos, speed, 234, 2);
	self.nextthink = time + self.wait + self.delay * random();
}

void() particle_embers =
{
	// size determines the box the particles can spawn within
	if (!self.size)
		self.size = '128 128 0';
	// delay is random time added per loop
	if (!self.delay)
		self.delay = 0.1;
	
	// wait is time always added per loop
	if (!self.wait)
		self.wait = 0.05;
	
	// velocity is used as a scalar on speed
	if (!self.velocity)
		self.velocity = '1 1 1';
	
	self.think = particle_embers_think;
	self.nextthink = time + self.wait + self.delay * random();
};

void() particle_embers_tall =
{
	if (!self.size)
		self.size = '40 40 0';
	if (!self.delay)
		self.delay = 0.1;
	if (!self.wait)
		self.wait = 0.05;
	if (!self.velocity) // scalar for speed
		self.velocity = '1 1 2';
	self.think = particle_embers_think;
	self.nextthink = time + self.wait + self.delay * random();
};

//============================================================================
// particle_tele
//============================================================================
void() particle_tele_think =
{
	local vector pos; // where to spawn
	local float dist; // scalar from org, used for speed too
	local vector rando;
	
	rando_x = crandom() * 10;
	rando_y = crandom() * 10;
	rando_z = crandom() * 5;
	rando = normalize(rando);
	
	dist = 64;
	if (self.distance)
		dist = self.distance;
	
	pos = self.origin + (rando * dist);
	
	// spawn particle
	particle(pos, rando * dist * -.125, 3, 3);
	self.nextthink = time + self.wait + self.delay * random();
}


void() particle_tele =
{
	/*
	1. get origin
	2. get a random vector, then normalize it. Save it for later
	3. scale a copy of the vector by distance
	4. spawn the particle at vector + origin
	5. set the particle's velocity to the old normalized vector * -scalar.
	*/
	// size determines the box the particles can spawn within
	if (!self.size)
		self.size = '128 128 0';
	if (!self.distance)
		self.distance = 64;
	// delay is random time added per loop
	if (!self.delay)
		self.delay = 0.1;
	
	// wait is time always added per loop
	if (!self.wait)
		self.wait = 0;
	
	self.think = particle_tele_think;
	self.nextthink = time + self.wait + self.delay * random();
}

void() particle_tele_fountain_think =
{
	local vector dir;
	dir_x = crandom() * self.velocity_x;
	dir_y = crandom() * self.velocity_y;
	dir_z = self.velocity_z;
	particle(self.origin, dir, 13, 2);
	self.nextthink = time + self.wait + self.delay * random();
};
void() particle_tele_fountain_use =
{
	self.think = particle_tele_fountain_think;
	self.nextthink = time + 0.1;
};
void() particle_tele_fountain =
{
	if (!self.delay)
		self.delay = 0.1;
	
	if (!self.wait)
		self.wait = 0.05;
	
	if (!self.velocity)
		self.velocity = '1 1 6';
	
	if (self.spawnflags & START_OFF)
		self.use = particle_tele_fountain_use;
	else
	{
		self.think = particle_tele_fountain_think;
		self.nextthink = time + self.wait + self.delay * random();
	}
};
