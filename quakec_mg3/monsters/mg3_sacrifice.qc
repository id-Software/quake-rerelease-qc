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

void() sacrifice_gib =
{
	//ThrowHead ("progs/h_player.mdl", self.health);
	self.origin += '0 0 -32';
	ThrowGib ("progs/gib1.mdl", -10);
	ThrowGib ("progs/gib2.mdl", -10);
	ThrowGib ("progs/gib3.mdl", -10);
	
		
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
		
	SUB_UseTargets();
	
	remove(self);
};


void() misc_sacrifice =
{
	
	//precache_model ("progs/h_player.mdl");
	precache_sound ("player/gib.wav");
	precache_sound ("player/udeath.wav");
	self.use = sacrifice_gib;
	self.th_die = sacrifice_gib;
	
	self.health = 100;
	self.solid = SOLID_SLIDEBOX;
	
	

	if (self.spawnflags & 1) // cannot be killed
		self.takedamage = DAMAGE_NO;
	else
		self.takedamage = DAMAGE_AIM;

	if (self.spawnflags & 2) // bouncing animation
	{
		precache_model ("progs/player_hanging.mdl");
		setmodel(self, "progs/player_hanging.mdl");	
		self.count = 0;
		self.think = sacrifice_think;
		self.nextthink = time + 0.1;
		self.avelocity = '0 36 0';
		self.movetype = MOVETYPE_STEP;
		self.dest = self.origin;
	}
	else
	{
		self.count = 5 + floor((random() * 65 + 0.5));
		precache_model ("progs/player_hanging_animated.mdl");
		setmodel(self, "progs/player_hanging_animated.mdl");	
		self.frame = self.count; 
		self.think = sacrifice_animate;
		self.nextthink = time + 0.1;
		self.movetype = MOVETYPE_STEP;
	}
	setsize (self, VEC_HULL_MIN - '0 0 32', VEC_HULL_MAX - '0 0 32');
};

void() sacrifice_animate =
{
	self.count++;
	if (self.count > 75)
		self.count = 5;
	self.frame = self.count;
	self.nextthink = time + 0.1;
}

void() sacrifice_think =
{
	self.count += 0.1;
	//self.velocity = cos(self.count * 90) * '0 0 16';
	setorigin(self, self.dest + cos(self.count * 90) * '0 0 16');
	self.angles += '0 36 0' * 0.1;
	self.nextthink = time + 0.1;
};