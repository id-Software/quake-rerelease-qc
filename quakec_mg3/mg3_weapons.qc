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

.entity     lastvictim;

/*
================
HIPNOTIC WEAPONS

Taken directly from the hipnotic qc. AY, January 17 2026
================
*/
void() HIP_LaserTouch =
{
	local vector org;
   local vector spot1,spot2;
   local vector oldvel;
   //local float mag;
   local float r;

   self.owner = world;
   self.cnt = self.cnt + 1;
   if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
   oldvel = normalize(self.old_velocity);
   spot1 = self.origin - (16*oldvel);
   spot2 = self.origin + (16*oldvel);
   traceline (spot1, spot2, FALSE, self);  // see through other monsters
   self.origin = trace_endpos;

   org = self.origin;

	if (other.health)
      {
      if (self.lastvictim == other)
         {
         self.dmg = self.dmg / 2;
         }
      spawn_touchblood (self.dmg);
      T_Damage (other, self, self.lastvictim, self.dmg);
      }
   else if ((self.cnt == 3) || (random()<0.15))
      {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
      }
   else
      {
//      self.dmg = 0.66 * self.dmg;
      self.dmg = 0.9 * self.dmg;
//      self.speed = 0.95 * self.speed;
      self.velocity = oldvel+(2*trace_plane_normal);
      self.velocity = normalize(self.velocity);
      self.velocity = self.speed * self.velocity;
      self.old_velocity = self.velocity;
      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;
      r = random();
      sound (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC);
/*
      if (r<0.33)
         sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
      else if (r<0.66)
         sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
      else
         sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/
      return;
      }
   sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
   remove(self);

};
void() HIP_LaserThink =
   {
   //local float delta;


   if (time>self.attack_finished)
      {
      remove(self);
      return;
      }
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;
   self.velocity = self.old_velocity;
   self.angles = vectoangles(self.velocity);
   self.nextthink = time+0.1;
   };

void(vector org, vector vec, float light) HIP_LaunchLaser =
{
//   sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
   sound (self ,CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);

   vec = normalize(vec);

	newmis = spawn();
   newmis.owner = self;
   newmis.classname = "hiplaser";
   newmis.lastvictim = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   if (light)
      newmis.effects = EF_DIMLIGHT;

   setmodel (newmis, "progs/lasrspik.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

   newmis.speed = 1000;
   //newmis.dmg = 18;
   newmis.dmg = 15;
   newmis.velocity = vec * newmis.speed;
   newmis.old_velocity = newmis.velocity;
   newmis.angles = vectoangles(newmis.velocity);
   newmis.avelocity = '0 0 400';

   newmis.nextthink = time;
   newmis.attack_finished = time + 5;
   newmis.think = HIP_LaserThink;
   newmis.touch = HIP_LaserTouch;
   newmis.count = 0;

};

/*
=================
HIP_FireLaser
=================
*/
void(float stat) HIP_FireLaser =
   {
	local vector org;
   local vector dir;
   local vector out;
   local float ofs;
   local float aofs;

   if (!self.button0)
      {
      player_run ();
      return;
      }
   if (self.ammo_cells < 1)
      {
         respawn_ammo(IT_LASER_CANNON); // AY Feb 21, added since this bypasses client prethink
	   	self.weapon = W_BestWeapon ();
	   	W_SetCurrentAmmo ();
   		return;
      }
   SuperDamageSound();
   self.effects = self.effects | EF_MUZZLEFLASH;
   makevectors (self.v_angle);

   ofs = 6;
   out = v_forward;
   out_z = 0;
   out = normalize(out);
   org = self.origin + ((12-ofs) * v_up) + (12*out);
//   org = self.origin + (1*v_forward);
   dir = aim (self, 1000);
   aofs = ofs * 0.707;
   if (stat == 0)
   {
      if (!self.infiniteammo)
         self.currentammo = self.ammo_cells = self.ammo_cells - 1;
      org = org + (aofs*v_right);
      org = org - (aofs*v_up);
      HIP_LaunchLaser(org, dir, 0);
      org = org - (2*aofs*v_right);
      HIP_LaunchLaser(org, dir, 0);
      }
   else if (stat == 1)
      {
      if (!self.infiniteammo)
         self.currentammo = self.ammo_cells = self.ammo_cells - 1;
      org = org + (ofs*v_up);
      if (random()<0.1)
         {
         HIP_LaunchLaser(org, dir, 1);
         //newmis.dmg = 25;
         newmis.dmg = 20;
         }
      else
         HIP_LaunchLaser(org, dir, 0);
      }
   self.punchangle_x = -1;
   };

   // End of Hipnotic section, AY Jan 17 2026

/*
=================
HIP_Mjolnir
=================
*/
/*
=================
HIP_HammerDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage =
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

   if (trace_ent == self.owner)
   {
      dprint("avoid self-damage\n");
      return; 
   }

//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};

//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void() HIP_LightningThink =
   {
   local vector org, end;
   local vector dst;
   local entity head;
   local entity selected;
   local float cur_dist;
   local float head_dist;
   local vector vec;
   local float dot;
   local float oldstate;
   local float dam;


   if (time > self.delay)
      {
      if (self.enemy != world)
         self.enemy.struck_by_mjolnir = 0;
      remove(self);
      return;
      }
   oldstate = self.state;
   if (self.state==0)
      {
      // look in our immediate vicinity
      self.enemy = world;
      selected = world;
      cur_dist = self.distance;
      head = findradius(self.owner.origin, self.distance);
      while(head)
         {
         if(!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT)))
            {
//            if (visible(head) && (head!=self.owner.owner) && (head.health>0))
            if ((visible(head)) && (head!=self.owner.owner) && (head.health>0))
               {
               head_dist = vlen(head.origin - self.lastvictim.origin);
               if ((head_dist<cur_dist) && (head.struck_by_mjolnir==0))
                  {
                  selected = head;
                  cur_dist = head_dist;
                  }
               }
            }
         head = head.chain;
         }
      if (selected != world)
      {
         self.state = 1;
         self.enemy = selected;
         self.enemy.struck_by_mjolnir = 1;
      }
      else
      {

         makevectors(self.v_angle);
         org = self.owner.origin;
         end = org + v_forward*200;
         end = end + (((400*random()) - 200) * v_right);

         traceline (org, end, TRUE, self);

         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
         WriteEntity (MSG_BROADCAST, self);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
         WriteCoord (MSG_BROADCAST, trace_endpos_x);
         WriteCoord (MSG_BROADCAST, trace_endpos_y);
         WriteCoord (MSG_BROADCAST, trace_endpos_z);

         self.nextthink = time + 0.1;
//         self.think = HIP_DiversionLightningThink;
//         self.nextthink = time;
//         self.delay = time + 0.30;
//         self.origin = self.owner.origin;
//         self.think();
         return;
         }
      }
   org = self.lastvictim.origin;
   dst = self.enemy.absmin + 0.25*(self.enemy.absmax-self.enemy.absmin);
   dst = dst + (random()*0.5*(self.enemy.absmax-self.enemy.absmin));
   traceline (org, dst, TRUE, self.owner.owner);

   if (trace_fraction != 1.0 || self.enemy.health<=0)
      {
      self.enemy.struck_by_mjolnir = 0;
      self.state = 0;
      self.nextthink = time + 0.1;
      return;
      }
   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST, self);
   WriteCoord (MSG_BROADCAST, org_x);
   WriteCoord (MSG_BROADCAST, org_y);
   WriteCoord (MSG_BROADCAST, org_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);
   vec = normalize(self.enemy.origin - self.owner.origin);
   dot = vec * self.owner.movedir;
   head = self;
   self = self.owner.owner;
   if (oldstate==0)
      dam = 80;
   else
      dam = 30;
   if (dot>0.3)
      HIP_HammerDamage (org, trace_endpos, self, dam);
   else
      HIP_HammerDamage (org, trace_endpos, self, dam*0.5);
   self = head;

   self.nextthink = time + 0.2;
   };

void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning =
   {
   local entity light;
   // spawn actual lightning
   light = spawn();
   light.delay = time + 0.8;
   light.state = 0;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = 0;
   light.v_angle_z = 0;
   light.origin = own.origin;
   light.think = HIP_LightningThink;
   light.nextthink = time;
   };

void() HIP_SpawnMjolnirBase =
   {
   local entity light;
   // spawn lightning base
   light = spawn();
//   light.origin = self.origin - '0 0 24' + (32*v_forward);
   light.origin = trace_endpos;
   light.flags = 0;
   light.owner = self;
   light.struck_by_mjolnir = 1;
   light.think = SUB_Remove;
   light.nextthink = time + 1;
   sound (light, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
   sound (light, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
   makevectors(self.v_angle);
   light.movedir = v_forward;
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   };

void() HIP_FireMjolnirLightning =
{

	//local	float		cells;

//   if (self.t_width < time)
//   {
//      sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
//      self.t_width = time + 0.6;
//   }
//   self.punchangle_x = 12;

   if (!self.infiniteammo)
      self.currentammo = self.ammo_cells = self.ammo_cells - 15;

   HIP_SpawnMjolnirBase();
};

void() HIP_FireMjolnir =
{
   local vector   org;
   local float    damage;
   local vector   source;
   local vector   offset;

   self.attack_finished = time + 0.4;
   source = self.origin + '0 0 16';
   // ang = self.angles;
   // ang_x = 0;
   // ang_y = 0;
   makevectors(self.v_angle);
   traceline (source, source + v_forward*64, FALSE, self);
   /* How it works in hipnotic
   if (trace_fraction == 1.0 && (self.ammo_cells >= 15))
   {
      source = source + v_forward*32;
      traceline (source , source - v_up*50, FALSE, self);
      // dprint("fraction = ");
      // dprint(ftos(trace_fraction));
      // dprint("\n");
      if (trace_fraction > 0.3 && trace_fraction< 1.0)
      {
         if (self.waterlevel < 1) // only fire lightning if above water 
         {
            HIP_FireMjolnirLightning();
            return;
         }
      }
   }
   */

   org = trace_endpos - v_forward*4;

   if (trace_ent.takedamage)
   {
      sound (self, CHAN_WEAPON, "hipweap/mjolslap.wav", 1, ATTN_NORM); // AY Feb 8, adding sfx feedback on ax hit
      damage = 40; // AY
     // damage = 50;
      trace_ent.axhitme = 1;
      SpawnBlood (org, v_forward, damage);

      if ((trace_ent.classname == "monster_zombie") || (trace_ent.classname == "monster_szombie"))
         damage = 120;
      else if (trace_ent.health - damage < 0)
         damage *= 2; // make sure to gib on axe kill

      // check for double-hit
      if (self.last_mjolnir_hit_time > time)
      {
         //source = source + v_forward*32;
         if (self.last_mjolnir_hit == trace_ent)
         {
            if (self.waterlevel < 2 && self.ammo_cells >= 15)
            {
               if (self.waterlevel < 1)
                  offset = v_up * 30;
               else
                  offset = v_up * 15;
               traceline (source , source - offset, FALSE, self);
               HIP_FireMjolnirLightning();
            }
            else
            {
               //damage = 70;
               T_Damage (trace_ent, self, self, damage);
               
               //self.last_mjolnir_hit_time = time + 0.5;
            }
         }
         else // different target, do normal damage, but still long wait
         {
            //damage = 40;
            T_Damage (trace_ent, self, self, damage);
         }
         self.last_mjolnir_hit_time = time; 
         self.attack_finished = time + 0.5;

      }
      else // track for second hit
      {
         self.last_mjolnir_hit_time = time + 0.5; 
         self.attack_finished = time + 0.2;
         self.last_mjolnir_hit = trace_ent;
         if (self.ammo_cells >= 15)
            self.weaponmodel = "progs/v_hammer_glow.mdl";
         T_Damage (trace_ent, self, self, damage);
      }
   }
   else
   {  // hit wall
      if (trace_fraction != 1.0)
      {
         // sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
         sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
      }
      else
      {
         // whiff sfx
         sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
        // sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
      }
      self.last_mjolnir_hit = world; // null out
   }
   //self.attack_finished = time + 0.4;
};

.float wetsuit_finished;
.float struck_by_mjolnir;

.entity last_mjolnir_hit; // last entity the player hit with mjolnir
.float last_mjolnir_hit_time;