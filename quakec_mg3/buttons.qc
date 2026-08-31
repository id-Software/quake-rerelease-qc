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

// button and multiple button

float BUTTON_KEY_ALWAYS_REQUIRED = 32;

void() button_wait;
void() button_return;

void() button_wait =
{
	self.state = STATE_TOP;
	self.nextthink = self.ltime + self.wait;
	self.think = button_return;
	activator = self.enemy;
	SUB_UseTargets();
	self.frame = 1;			// use alternate textures
};

void() button_done =
{
	self.state = STATE_BOTTOM;
};

void() button_return =
{
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, button_done);
	self.frame = 0;			// use normal textures
	if (self.health)
		self.takedamage = DAMAGE_YES;	// can be shot again
};


void() button_blocked =
{	// do nothing, just don't ome all the way back out
};


void() button_fire =
{
	if (self.state == STATE_UP || self.state == STATE_TOP)
		return;

	if(self.items)
	{
		sound (self, CHAN_ITEM, self.noise4, 1, ATTN_NORM);
		if(!(self.spawnflags & BUTTON_KEY_ALWAYS_REQUIRED))
		{
			self.items = 0;
		}
	}

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, button_wait);
};


void() button_use =
{
	self.enemy = activator;
	button_fire ();
};

void() button_touch =
{
	if (other.classname != "player")
	{
		return;
	}

	
	if ( (self.items & other.items) != self.items )
	{
		if(time < self.attack_finished)
		{
			return;
		}
		self.attack_finished = time + 2;
		
		sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		if (self.items == IT_KEY1)
		{
			if (self.worldtype == WORLDTYPE_BASE)
			{
				centerprint (other, "$qc_need_silver_keycard");
			}
			else if (self.worldtype == WORLDTYPE_METAL)
			{
				centerprint (other, "$qc_need_silver_runekey");
			}
			else if (self.worldtype == WORLDTYPE_MEDIEVAL || self.worldtype == WORLDTYPE_HUB)
			{
				centerprint (other, "$qc_need_silver_key");
			}
		}
		else if (self.items == IT_KEY2)
		{
			if (self.worldtype == WORLDTYPE_BASE)
			{
				centerprint (other, "$qc_need_gold_keycard");
			}
			else if (self.worldtype == WORLDTYPE_METAL)
			{
				centerprint (other, "$qc_need_gold_runekey");
			}
			else if (self.worldtype == WORLDTYPE_MEDIEVAL || self.worldtype == WORLDTYPE_HUB)
			{
				centerprint (other, "$qc_need_gold_key");
			}
		}
		return;
	}
	else
	{
		other.items = other.items - self.items;
	}
		
	self.enemy = other;
	button_fire ();
};

void() button_killed =
{
	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	button_fire ();
};


/*QUAKED func_button (0 .5 .8) ?
When a button is touched, it moves some distance in the direction of it's angle, triggers all of it's targets, waits some time, then returns to it's original position where it can be triggered again.

"angle"		determines the opening direction
"target"	all entities with a matching targetname will be used
"speed"		override the default 40 speed
"wait"		override the default 1 second wait (-1 = never return)
"lip"		override the default 4 pixel lip remaining at end of move
"health"	if set, the button must be killed instead of touched
"sounds"
0) steam metal
1) wooden clunk
2) metallic click
3) in-out
*/
void() func_button =
{
	self.netname = "func_button"; // for bot nav support.
	SUB_SetWorldtype();
	if (self.worldtype ==  WORLDTYPE_MEDIEVAL || self.worldtype == WORLDTYPE_HUB)
	{
		precache_sound ("doors/medtry.wav");
		precache_sound ("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (self.worldtype == WORLDTYPE_METAL)
	{
		precache_sound ("doors/runetry.wav");
		precache_sound ("doors/runeuse.wav");
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (self.worldtype == WORLDTYPE_BASE)
	{
		precache_sound ("doors/basetry.wav");
		precache_sound ("doors/baseuse.wav");
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}

	if (self.sounds == 0)
	{
		precache_sound ("buttons/airbut1.wav");
		self.noise = "buttons/airbut1.wav";
	}
	if (self.sounds == 1)
	{
		precache_sound ("buttons/switch21.wav");
		self.noise = "buttons/switch21.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("buttons/switch02.wav");
		self.noise = "buttons/switch02.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("buttons/switch04.wav");
		self.noise = "buttons/switch04.wav";
	}
	
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel (self, self.model);

	self.blocked = button_blocked;
	self.use = button_use;

	if (self.spawnflags & DOOR_SILVER_KEY)
		self.items = IT_KEY1;
	if (self.spawnflags & DOOR_GOLD_KEY)
		self.items = IT_KEY2;

	if (self.health)
	{
		self.max_health = self.health;
		self.th_die = button_killed;
		self.takedamage = DAMAGE_YES;
	}
	else
		self.touch = button_touch;

	if (!self.speed)
		self.speed = 40;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 4;

	self.state = STATE_BOTTOM;

	if(self.movedir)
	{
		self.pos1 = self.origin;
		self.pos2 = self.pos1 + self.movedir;
		self.angles = '0 0 0';
	}
	else
	{
		SetMovedir();
		self.pos1 = self.origin;
		self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
	}

};

void() func_axe_button =
{
	self.health = 1;
	func_button();
};