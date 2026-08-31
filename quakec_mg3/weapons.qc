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
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;


// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun

	// hipnotic addition, AY Jan 17 2026
	precache_sound ("hipweap/laserg.wav");	// laser cannon
	precache_sound ("hipweap/laserric.wav");	// laser cannon ricochet
	precache_sound ("enforcer/enfstop.wav");
	precache_sound ("hipweap/mjolslap.wav");
	precache_sound ("hipweap/mjolhit.wav");
	precache_sound ("hipweap/mjoltink.wav");
	precache_sound ("hipweap/mjolwam.wav");
	
};

float() crandom =
{
	return 2*(random() - 0.5);
};


/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;
	
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		//sound (self, CHAN_WEAPON, "hipweap/mjolwam.wav", 1, ATTN_NORM); // AY Feb 8, adding sfx feedback on ax hit
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, 20);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);
		
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);	

	self.punchangle_x = -2;
	
	if (!self.infiniteammo)
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	self.punchangle_x = -4;
	
	if (!self.infiniteammo)
	{
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	}
	dir = aim (self, 100000);
	if (parm15 & BLOODY_SSG)
		FireBullets (28, dir, '0.3 0.08 0');
	else
		FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100 + random()*20;
	
	if (other.health)
	{
		if ((other.classname == "monster_shambler") || (other.classname == "monster_super_shambler"))
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity missile;
	
	if (!self.infiniteammo)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_MissileTouch;
	
// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 246, damage*4);// particle was 225
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 246, damage*4);// particle was 225
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 246, damage*4); // particle was 225
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.ammo_cells < 1)
	{
		respawn_ammo(IT_LIGHTNING); // AY Feb 21, added since this bypasses client prethink
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		if (!self.infiniteammo)
			self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	if (!self.infiniteammo)
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, self.dmg, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

// Alternate version where the radius damage ignores other, because damage was already dealt on contact
void() GrenadeExplode_IgnoreOther = 
{
	T_RadiusDamage (self, self.owner, self.dmg, other);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
}

void GrenadeThink()
{
	self.cnt += 1;
	// Count to 50 at 20 ticks per second = 2.5 seconds until explosion
	if(self.cnt == 50)
	{
		GrenadeExplode();
		return;
	}
	float oldVel = vlen(self.oldorigin);
	float vel = vlen(self.velocity);
	if(vel == 0) //Stuck on downward slope?
	{
		if(oldVel > 120 && self.oldorigin_z < 0) //Were we moving downwards at a decent speed last tick?
		{
			// Trace straight down and find the normal of the surface it bounced off
			traceline(self.origin + '0 0 4', self.origin - '0 0 8', TRUE, self);
			if(trace_fraction < 1.0) // Hit something...
			{
				// dprint("reflected grenade bounce\n");
				// Reflect the previous velocity off that normal
				vector reflected = self.oldorigin - 2 * (self.oldorigin * trace_plane_normal) * trace_plane_normal;
	
				self.flags &~= FL_ONGROUND; //Remove FL_ONGROUND
				self.velocity = reflected * 0.6; // Scale it down a bit so it feels better
				self.avelocity = '400 400 400'; // Roll that sucker around
			}
		}
	}
	self.oldorigin = self.velocity;
	self.nextthink = time + 0.05;
}

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		if (other.classname && ((other.classname == "monster_boss") || (other.classname == "monster_oldone_new")))
		{
			T_Damage(other, self, self.owner, self.dmg);
			GrenadeExplode_IgnoreOther();
		}
		else
			GrenadeExplode();
		return;
	}
	if(self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
	}
	if(self.attack_finished < time)
		sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	self.attack_finished = time + 0.1;
};

/*
================
W_FireGrenade
================
*/
void W_FireGrenade(float damage, vector direction);
void W_FireGrenadeLauncher() 
{
	float damage = 120;
	makevectors (self.v_angle);

	vector velocity;
	if (self.v_angle_x)
		velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		velocity = aim(self, 10000);
		velocity = velocity * 600;
		velocity_z = 200;
	}
	W_FireGrenade(damage, velocity) ;
}

void W_FireGrenade(float damage, vector direction) 
{
	local	entity missile;
	
	if (!self.infiniteammo)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	missile.dmg = damage;
		
	// set missile speed	

	missile.velocity = direction;
	missile.oldorigin = direction;
	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenadeTouch;
	
	#ifdef GRENADE_BOUNCE_FIX
	// set missile duration
	missile.nextthink = time + 0.05;
	missile.think = GrenadeThink;
	#else
	// Uncomment this to go back to old grenade behaviour with no slope bounce fix.
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;
	#endif //GRENADE_BOUNCE_FIX
	

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
};


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector	dir;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (!self.infiniteammo)
		self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	local vector	dir;
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		respawn_ammo(IT_NAILGUN); // AY Feb 21, added since this bypasses client prethink
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (!self.infiniteammo)
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
};



.float hit_z;
void() spike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_MJOLNIR)
	{
		self.weaponmodel = "progs/v_hammer.mdl";
		self.weaponframe = 0;
		self.currentammo = self.ammo_cells;
		self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		if (parm15 & BLOODY_SG)
			self.weaponmodel = "progs/v_bloodshot.mdl";
		else
			self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		if (parm15 & BLOODY_SSG)
			self.weaponmodel = "progs/v_bloodshot2.mdl";
		else
			self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == IT_LASER_CANNON)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_laserg.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = string_null;
		self.weaponframe = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
			return IT_LIGHTNING;
	if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
	if(it & IT_MJOLNIR)
		return IT_MJOLNIR;
	if(it & IT_AXE)
		return IT_AXE;
	//No weapon
	return 0;
};

float(entity playerEnt, float old, float new) W_WantsToChangeWeapon =
{
	float playerFlags = CheckPlayerEXFlags(playerEnt);
	if((playerFlags & PEF_CHANGENEVER) != 0)
	{
		return 0;
	}
	
	if(((playerFlags & PEF_CHANGEONLYNEW) != 0) && old == new)
	{
		return 0;
	}

	return 1;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE || self.weapon == IT_MJOLNIR)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;

void() player_laser1; // Hipnotic add, Jan 17 2026

void() W_Attack =
{
	local	float	r;

	if (!self.weapon) 
		return;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();

		if (r < 0.25)
		{
			player_axe1 ();
		}
		else if (r<0.5)
		{
			player_axeb1 ();
		}
		else if (r<0.75)
		{
			player_axec1 ();
		}
		else
		{
			player_axed1 ();
		}
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.ammo_cells < 30)
		{
			player_hammer1();
		}
		else
			player_mjolnir1();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();

		if (parm15 & BLOODY_SG)
			self.attack_finished = time + 0.28;
		else
			self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenadeLauncher();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
	// hipnotic addition, AY Jan 17 2026
	else if (self.weapon == IT_LASER_CANNON) 
	{
		player_laser1();
	}
};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
	local	float	it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		if (it & IT_MJOLNIR)
			fl = IT_MJOLNIR;
		else
			fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}		
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}
	// Hipnotic add, Jan 17 2026
	else if (self.impulse == 225) 
	{
		fl = IT_LASER_CANNON;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "$qc_no_weapon");
		return;
	}
	
	if (am)
	{	// don't have the ammo
		sprint (self, "$qc_not_enough_ammo");
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = fl;		
	W_SetCurrentAmmo ();
};

/*
============
CheatCommand
============
*/
void(float NoKeys = FALSE) CheatCommand =
{
	if ( ( deathmatch || coop ) && cheats_allowed == 0 ) { // mal: allow impulse 9 IF cheats allowed
		return;
	}

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	if(NoKeys)
	{
		self.items = self.items | 
			IT_AXE |
			IT_SHOTGUN |
			IT_SUPER_SHOTGUN |
			IT_NAILGUN |
			IT_SUPER_NAILGUN |
			IT_GRENADE_LAUNCHER |
			IT_ROCKET_LAUNCHER |
			IT_LASER_CANNON;
	}
	else
	{
		self.items = self.items | 
			IT_AXE |
			IT_SHOTGUN |
			IT_SUPER_SHOTGUN |
			IT_NAILGUN |
			IT_SUPER_NAILGUN |
			IT_GRENADE_LAUNCHER |
			IT_ROCKET_LAUNCHER |
			IT_LASER_CANNON |
			IT_KEY1 | IT_KEY2;
	}

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local	float	it, am, wep;
	
	it = self.items;
	wep = self.weapon;
	self.impulse = 0;

	float cnt = 10;

	while (cnt)
	{
		am = 0;

		if(!wep)
		{
			if (self.items & IT_MJOLNIR)
				wep = IT_MJOLNIR;
			else
				wep = IT_AXE;
		}
		else if (wep == IT_LASER_CANNON)
		{
			if (self.items & IT_MJOLNIR)
				wep = IT_MJOLNIR;
			else
				wep = IT_AXE;
		}
		else if (wep == IT_LIGHTNING)
		{
			wep = IT_LASER_CANNON;
			if (self.ammo_cells <1)
				am = 1;
		}
		else if (wep == IT_AXE || wep == IT_MJOLNIR)
		{
			wep = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (wep == IT_SHOTGUN)
		{
			wep = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (wep == IT_SUPER_SHOTGUN)
		{
			wep = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (wep == IT_NAILGUN)
		{
			wep = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (wep == IT_SUPER_NAILGUN)
		{
			wep = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (wep == IT_GRENADE_LAUNCHER)
		{
			wep = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (wep == IT_ROCKET_LAUNCHER)
		{
			wep = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & wep) && am == 0)
		{
			self.weapon = wep;
			W_SetCurrentAmmo ();
			return;
		}

		cnt--;
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local	float	it, am, wep;
	
	it = self.items;
	wep = self.weapon;
	self.impulse = 0;

	float cnt = 10;

	while (cnt)
	{
		am = 0;

		if(!wep)
		{
			if (self.items & IT_MJOLNIR)
				wep = IT_MJOLNIR;
			else
				wep = IT_AXE;
		}
		else if (wep == IT_LASER_CANNON)
		{
			wep = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (wep == IT_LIGHTNING)
		{
			wep = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (wep == IT_ROCKET_LAUNCHER)
		{
			wep = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (wep == IT_GRENADE_LAUNCHER)
		{
			wep = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (wep == IT_SUPER_NAILGUN)
		{
			wep = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (wep == IT_NAILGUN)
		{
			wep = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (wep == IT_SUPER_SHOTGUN)
		{
			wep = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (wep == IT_SHOTGUN)
		{
			if (self.items & IT_MJOLNIR)
				wep = IT_MJOLNIR;
			else
				wep = IT_AXE;
		}
		else if (wep == IT_AXE || wep == IT_MJOLNIR)
		{
			wep = IT_LASER_CANNON;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & wep) && am == 0)
		{
			self.weapon = wep;
			W_SetCurrentAmmo ();
			return;
		}

		cnt--;
	}

};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	//serverflags = serverflags * 2 + 1;

	if (!(serverflags & SIGIL_E1))
	{
		serverflags = serverflags | SIGIL_E1;
		return;
	}
	if (!(serverflags & SIGIL_E2))
	{
		serverflags = serverflags | SIGIL_E2;
		return;
	}
	if (!(serverflags & SIGIL_E3))
	{
		serverflags = serverflags | SIGIL_E3;
		return;
	}
	if (!(serverflags & SIGIL_E4))
	{
		serverflags = serverflags | SIGIL_E4;
		return;
	}

	dprint("already has all runes!\n");
};

void() QuadCheat =
{
	if (deathmatch || coop)
		return;
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};

void() Omnicide = 
{
	entity oself = self;
	self = nextent(world);
	while(self)
	{
		if(self.flags & (FL_MONSTER | FL_FUTUREMONSTER))
		{
			if(self.target || self.killtarget)
			{
				SUB_UseTargets();
			}

			if(self.classname == "monster_oldone_new")
			{
				WriteByte (MSG_ALL, SVC_CDTRACK);
				WriteByte (MSG_ALL, 3);
				WriteByte (MSG_ALL, 3);
				lightstyle(0, "m");	

				oldnew_credits();
			}
			else if (self.classname == "monster_boss")
			{
				boss_end();
			}

			SUB_Remove();
		}
		self = nextent(self);
	}
	self = oself;

	killed_monsters = total_monsters;
	WriteByte (MSG_ALL, SVC_UPDATESTAT);
	WriteByte(MSG_ALL, 14); // 14 = STAT_MONSTERS
	WriteLong(MSG_ALL, total_monsters);
}

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 225)
		W_ChangeWeapon ();

	else if (self.impulse == 9)
		CheatCommand ();
	else if (self.impulse == 99)
		CheatCommand (TRUE);
	else if (self.impulse == 10)
		CycleWeaponCommand ();
	else if (self.impulse == 11)
		ServerflagsCommand ();
	else if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	else if (self.impulse == 100) 
	{
		// For temporarily undoing the effects of permanent upgrades
		dprint("Resetting to defaults\n");
		self.max_health = 100;
		self.health = 100;
		ammo_shells_max = 100;
		ammo_nails_max = 200;
		ammo_rockets_max = 100;
		ammo_cells_max = 100;
	}
	else if (self.impulse == 101)
	{
		// give rune 1
		serverflags = serverflags | SIGIL_E1;
	}
	else if (self.impulse == 102)
	{
		// give rune 2
		serverflags = serverflags | SIGIL_E2;
	}
	else if (self.impulse == 103)
	{
		// give rune 3
		serverflags = serverflags | SIGIL_E3;
	}
	else if (self.impulse == 104)
	{
		// give rune 4
		serverflags = serverflags | SIGIL_E4;
	}
	else if (self.impulse == 105)
	{
		// give all runes
		serverflags = serverflags | SIGIL_E1 | SIGIL_E2 | SIGIL_E3 | SIGIL_E4;
	}
	else if (self.impulse == 111)
	{
		GiveNextFreeUpgrade(UpgradeType_Health, self);
	}
	else if (self.impulse == 112)
	{
		GiveNextFreeUpgrade(UpgradeType_Shells, self);
	}
	else if (self.impulse == 113)
	{
		GiveNextFreeUpgrade(UpgradeType_Nails, self);
	}
	else if (self.impulse == 114)
	{
		GiveNextFreeUpgrade(UpgradeType_Rockets, self);
	}
	else if (self.impulse == 115)
	{
		GiveNextFreeUpgrade(UpgradeType_Cells, self);
	}
	else if (self.impulse == 116)
	{
		 // AY Feb 7 2026, testing idea for seeing where secrets are at
		if (self.secrethunter)
		{
			self.secrethunter = 0;
			cleanup_markers("secret_marker");
		}
		else
			self.secrethunter = 1;
	}
	else if (self.impulse == 117)
	{
		if (self.exithunter)
		{
			self.exithunter = 0;
			cleanup_markers("exit_marker");
		}
		else
			self.exithunter = 1;
	}
	else if (self.impulse == 118)
	{
		self.items = self.items | IT_MJOLNIR;
	}
	else if (self.impulse == 119)
	{
		dprint("toggling monster visibility\n");
		self.monsterhunter = !self.monsterhunter;
	}
	else if (self.impulse == 121)
	{
		dprint("toggling buddha mode\n"); // down allow player health to hit 0
		self.buddha = !self.buddha;
	}
	else if (self.impulse == 122)
	{
		dprint("$m_inf_ammo"); // shooting no longer consumes ammo
		self.infiniteammo = !self.infiniteammo;
		if (self.infiniteammo)
		{
			// restock 
			self.ammo_shells = 100;
			self.ammo_nails = 200;
			self.ammo_rockets = 100;
			self.ammo_cells = 200;
		}
	}
	else if (self.impulse == 255)
	{		
		QuadCheat ();
	}		
	else if (self.impulse == 219)
	{
		Omnicide ();
	}
	else if (self.impulse == 220)
	{
		self.effects = self.effects | EF_DIMLIGHT;

	}
	else if (self.impulse == 222)
	{
		// reload the map we're currently in without removing progress
		changelevel (mapname);
	}
	else if (self.impulse == 223)
	{
		if (serverflags & BLOODY_NIGHTMARE_ACTIVE)
		{
			dprint("disable 'bloody nightmare' difficulty.\n");
			serverflags = serverflags - (serverflags & BLOODY_NIGHTMARE_ACTIVE);
		}
		else
		{
			dprint("enabled 'blood nightmare' difficulty.\n");
			serverflags = serverflags | BLOODY_NIGHTMARE_ACTIVE;
			if (!(serverflags & BLOODY_NIGHTMARE_DISCOVERED))
				serverflags = serverflags | BLOODY_NIGHTMARE_DISCOVERED;
			if (skill != 3)
			{
				cvar_set("skill", "3");
				skill = 3; 
			}
		}
	}
	else if (self.impulse == 224)
	{
		if (serverflags & BLOODY_NIGHTMARE_NEWGAME)
		{
			dprint("disable NewGame+ flag\n");
			serverflags = serverflags - (serverflags & BLOODY_NIGHTMARE_NEWGAME);
		}
		else
		{
			dprint("enable NewGame+ flag\n");
			serverflags = serverflags | BLOODY_NIGHTMARE_NEWGAME;
		}
	}
	else if (self.impulse == 227)
	{
		if (parm15 & BLOODY_SG)
		{
			parm15 = parm15 - BLOODY_SG;
			dprint("deactivated 'bloody shotgun' upgrade\n");
		}
		else
		{
			parm15 = parm15 | BLOODY_SG;
			dprint("activated 'bloody shotgun' upgrade\n");
		}
	}
	else if (self.impulse == 228)
	{
		if (parm15 & BLOODY_SSG)
		{
			parm15 = parm15 - BLOODY_SSG;
			dprint("deactivated 'bloody Super Shotgun' upgrade\n");
		}
		else
		{
			parm15 = parm15 | BLOODY_SSG;
			dprint("activated 'bloody Super Shotgun' upgrade\n");
		}
	}
	else if (self.impulse != 0)
	{
		dprint(ftos(self.impulse));
		dprint(" is not a valid impulse command!\n");
		dprint("impulse 1-8 changes weapons\n");
		dprint("impulse 255 also changes weapons\n");
		dprint("impulse 9 gives all items EXCEPT runes\n");
		dprint("impulse 99 gives all items EXCEPT keys and runes\n");
		dprint("impulse 10 cycles weapons\n");
		dprint("impulse 11 uses ServerflagsCommand\n");
		dprint("impulse 12 cycles weapons backwards\n");
		dprint("impulse 100 temporarily undoes effects of upgrades\n");
		dprint("impulse 101 gives rune 1\n");
		dprint("impulse 102 gives rune 2\n");
		dprint("impulse 103 gives rune 3\n");
		dprint("impulse 104 gives rune 4\n");
		dprint("impulse 105 gives all runes\n");
		dprint("impulse 111 gives next health upgrade\n");
		dprint("impulse 112 gives next shell upgrade\n");
		dprint("impulse 113 gives next nail upgrade\n");
		dprint("impulse 114 gives next rocket upgrade\n");
		dprint("impulse 115 gives next cell upgrade\n");
		dprint("impulse 116 toggles secret hunter cheat\n");
		dprint("impulse 117 toggles exit hunter cheat\n");
		dprint("impulse 118 gives super axe\n");
		dprint("impulse 119 draws alive enemies\n");
		dprint("impulse 121 toggles buddha mode (health won't drop below 0)\n");
		dprint("impulse 122 toggles infinite ammo\n");
		dprint("impulse 220 enables a dimlight effect\n");
		dprint("impulse 222 reloads the map without removing progression\n");
		dprint("impulse 223 toggles 'bloody nightmare' difficulty\n");
		dprint("impulse 224 toggles Newgame+ flag\n");
		dprint("impulse 227 toggles shotgun upgrade\n");
		dprint("impulse 228 toggles super shotgun upgrade\n");
		dprint("impulse 255 gives quad damage\n");
	}
		
	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	ImpulseCommands ();
	
// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};

void() count_upgrades =
{
	count_upgrade("item_upgrade_health");
	count_upgrade("item_upgrade_shells");
	count_upgrade("item_upgrade_nails");
	count_upgrade("item_upgrade_rockets");
	count_upgrade("item_upgrade_cells");
};

void(string upgrade_name) count_upgrade =
{
	local entity upgrade;
	local float c;

	upgrade = find(world, classname, upgrade_name);
	c = 0;
	while (upgrade)
	{
		c++;
		dprint(upgrade_name);
		dprint(" at: ");
		dprint(vtos(upgrade.origin));
		dprint("\n");
		upgrade = find(upgrade, classname, upgrade_name);
	}
	dprint("total ");
	dprint(upgrade_name);
	dprint(" : ");
	dprint(ftos(c));
	dprint("\n\n");
};