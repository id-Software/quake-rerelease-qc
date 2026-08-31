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


/*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for spotlights, etc.
*/
void() info_null =
{
	remove(self);
};

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void() info_notnull =
{
};

//============================================================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
Lava Balls
*/

void() fire_fly;
void() fire_touch;
void() misc_fireball =
{
	if (!self.speed)
	{
		self.speed = 1000;
	}
	if(self.noise)
	{
		precache_sound(self.noise);
	}
	if(self.noise2)
	{
		precache_sound(self.noise2);
	}
	
	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";

	if(self.targetname)
	{
		self.use = fire_fly;
	}
	else
	{
		self.nextthink = time + (random() * 5);
		self.think = fire_fly;
	}
};

void() fire_fly =
{
local entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	if(self.movedir)
	{
		fireball.velocity = self.movedir;
		fireball.velocity_x += crandom() * 20;
		fireball.velocity_y += crandom() * 20;
		fireball.velocity_z += crandom() * 20;
	}
	else
	{
		fireball.velocity_x = (random() * 100) - 50;
		fireball.velocity_y = (random() * 100) - 50;
		fireball.velocity_z = self.speed + (random() * 200);
	}
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	
	if(self.noise)
	{
		sound (self, CHAN_VOICE, self.noise, 1.0, ATTN_NORM);
	}
	fireball.noise2 = self.noise2;

	self.nextthink = time + (random() * 5) + 3;
	self.think = fire_fly;
};


void() fire_touch =
{
	T_Damage (other, self, self, 20);
	if(self.noise2)
	{
		sound (self, CHAN_VOICE, self.noise2, 0.8, ATTN_NORM);
	}
	remove(self);
};

//============================================================================


void() barrel_explode =
{
	self.origin_z = self.origin_z + 32;
	
	// did say self.owner
	T_RadiusDamage (self, self, 160, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	particle (self.origin, '0 0 0', 75, 255);
	
	
	// yoder add, 27/09/2020 to make barrels fire targets on explode
	activator = self.enemy;
	dprint("enemy name: ");
	dprint(self.enemy.classname);
	dprint("\n");
	SUB_UseTargets ();
	
	BecomeExplosion ();
};

void() barrel_detonate =
{
	self.takedamage = DAMAGE_NO;
	self.think = barrel_explode;
	self.nextthink = self.ltime + 0.15;
}


/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)

*/

void() misc_explobox =
{
	local float	oldz;
	
	if(!self.mdl) self.mdl = "maps/b_explob.bsp";

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	precache_model (self.mdl);
	setmodel (self, self.mdl);
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_detonate;
	self.takedamage = DAMAGE_AIM;

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("explobox fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
	self.classname = "explo_box"; // Used by ClientObituary to print death message
};




/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void() misc_explobox2 =
{
	self.mdl = "maps/b_exbox2.bsp";
	misc_explobox();
};

//============================================================================

void func_explode_detonate()
{
	vector pos = self.mins + (self.size * 0.5);
	pos_z -= 32;
	setmodel(self, string_null);
	setorigin(self, pos);

	barrel_explode();
}

void() func_explode_die =
{
	self.takedamage = DAMAGE_NO;
	self.think = func_explode_detonate;
	self.nextthink = self.ltime + 0.15;
}


/*QUAKED func_explode (0 .5 .8) (0 0 0) (32 32 64)
Custom exploding box
*/

void func_explode() =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel (self, self.model);

	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = func_explode_die;
	self.takedamage = DAMAGE_AIM;

	
};

//============================================================================

float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;

void(vector org, vector vec) LaunchLaser;

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser (self.origin, self.movedir);
	}
	else
	{
		sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
			newmis.touch = superspike_touch;
	}
};

void() shooter_think =
{
	spikeshooter_use ();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

void() trap_spikeshooter =
{
	SetMovedir ();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2 ("progs/laser.mdl");
		
		precache_sound2 ("enforcer/enfire.wav");
		precache_sound2 ("enforcer/enfstop.wav");
	}
	else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();
	
	if (self.wait == 0)
		self.wait = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};



/*
===============================================================================


===============================================================================
*/


void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)

testing air bubbles
*/

void() air_bubbles =

{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles =
{
local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
local entity	bubble;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = 10;
	if (self.waterlevel != 3)
		remove (self);
};

void() bubble_remove =
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void() bubble_bob =
{
local float		rnd1, rnd2, rnd3;

	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;
		
	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;
		
	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
		
	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/

void() viewthing =

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
};


/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};


/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =

{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic (self);
};

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void() func_episodegate =

{
	if (!(serverflags & self.spawnflags))
		return;			// can still enter episode

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*QUAKED func_bossgate (0 .5 .8) ?
This bmodel appears unless players have all of the episode sigils.
*/
const float BOSSGATE_INVERSE = 64;
void() func_bossgate =
{
	float inverse = self.spawnflags & BOSSGATE_INVERSE ? TRUE : FALSE;
	self.spawnflags (-) BOSSGATE_INVERSE;
	if(!self.spawnflags)
	{
		self.spawnflags = SIGIL_E1 | SIGIL_E2 | SIGIL_E3 | SIGIL_E4;
	}
	self.spawnflags&= SIGIL_ALL;
	
	if ( (serverflags & self.spawnflags) == self.spawnflags) //All runes collected
	{
		if(!inverse)
		{
			remove(self);
			return;
		}
	}
	else //Still missing some runes
	{
		if(inverse)
		{
			remove(self);
			return;
		}	
	}
	
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);

	if(self.target || self.killtarget)
	{
		self.think = SUB_UseTargets;
		self.nextthink = time + 0.2;
	}
};

//============================================================================

const float FUNC_HURT_START_ON = 1;

void func_hurt_touch()
{
	if(!self.state) return;
	if(other.health <= 0) return;
	if(!other.takedamage) return;
	if(!(other.flags & (FL_CLIENT | FL_MONSTER))) return;
	if(self.attack_finished > time) return;
	
	T_Damage(other, self, world, self.dmg);
	self.attack_finished = time + self.wait;
}

void func_hurt_use()
{
	self.state = 1 - self.state;
	self.attack_finished = 0;
}

/*QUAKED func_hurt (0 .5 .8) ?
Hurts alive things when they touch it
*/
void func_hurt()
{
	setmodel(self, self.model);
	setorigin(self, self.origin);
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.touch = func_hurt_touch;
	self.use = func_hurt_use;

	if(!self.dmg) self.dmg = 10;
	if(!self.wait) self.wait = 0.2;

	if(self.spawnflags & FUNC_HURT_START_ON)
	{
		self.state = 1;
	}
}

//============================================================================

void trigger_changetarget_use()
{
	SUB_SwitchTargets(target, self.target, self.killtarget);
}

void trigger_changetarget()
{
	if(!self.target) objerror("Missing target.");
	if(!self.killtarget) objerror("Missing target to change to.");
	self.use = trigger_changetarget_use;
}

//============================================================================
// Cleanup
void trigger_cleanup_corpses_use()
{
    entity e = nextent(world);
    while(e)
    {
        if(e.flags & FL_MONSTER)
        {
            if(e.health <= 0)
            {
                remove(e);
            }
        }
        e = nextent(e);
    }
    remove(self);
}

void trigger_cleanup_corpses()
{
    if(coop == 0) { remove(self); return; }
    self.use = trigger_cleanup_corpses_use;
}

//============================================================================
/*QUAKED ambient_suck_wind (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_suck_wind =
{
	precache_sound ("ambience/suck1.wav");
	ambientsound (self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
	makestatic(self);
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drone =
{
	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
	makestatic(self);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_flouro_buzz =
{
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
	makestatic(self);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drip =
{
	precache_sound ("ambience/drip1.wav");
	ambientsound (self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
	makestatic(self);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_comp_hum =
{
	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
	makestatic(self);
};
/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
	makestatic(self);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_light_buzz =
{
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
	makestatic(self);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp1 =
{
	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
	makestatic(self);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp2 =
{
	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
	makestatic(self);
};

/*QUAKED ambient_generic (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_generic =
{
	if(!self.noise)
	{
		dprint("ambient_generic with no noise. Removing.\n");
		remove(self);
	}
	if(!self.volume) self.volume = 0.5;
	if(!self.delay) self.delay = 3;
	
	precache_sound (self.noise);
	ambientsound (self.origin, self.noise, self.volume, self.delay);
	makestatic(self);
};

//============================================================================


