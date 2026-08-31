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

const float FORCE_SET_FOG = 1;


void stuffcmd_digit( entity client, float f) =
{
	float d;
	d = floor(f);
	d = mod(d, 10);

	if(d == 0)
		stuffcmd(client, "0");
	else if(d == 1)
		stuffcmd(client, "1");
	else if(d == 2)
		stuffcmd(client, "2");
	else if(d == 3)
		stuffcmd(client, "3");
	else if(d == 4)
		stuffcmd(client, "4");
	else if(d == 5)
		stuffcmd(client, "5");
	else if(d == 6)
		stuffcmd(client, "6");
	else if(d == 7)
		stuffcmd(client, "7");
	else if(d == 8)
		stuffcmd(client, "8");
	else if(d == 9)
		stuffcmd(client, "9");	
}

void stuffcmd_int( entity client, float f, float numdigits) =
{
	
	float tmp;

	
	if(f == 0){
		stuffcmd( client, "0");
		return;
	}

	if(f < 0){
		// Yeah sure.
		stuffcmd( client, "-");
		f = fabs(f);
	}
	
	if(numdigits <= 0){
		tmp = f;
		numdigits = 1;
		while(tmp >= 1){
			tmp = tmp / 10;
			numdigits = numdigits * 10;
		}
	}
	//I need to do this to get zero-padding to work.

	while( numdigits > 1 ){
		
		numdigits = numdigits / 10;
		tmp = f / numdigits;
		stuffcmd_digit( client, tmp);
		
	}
	
	
}

void stuffcmd_float( entity client, float f) =
{
	float intpart, decpart, isNegative;
	
	isNegative = FALSE;
	
	if(f == 0){
		stuffcmd( client, "0");
		return;
	}
	
	if(f < 0){
		// easier this way
		isNegative = TRUE;
		f = fabs(f);
	}
	
	
    // 1: stuff the sign.
	if(isNegative) 
    stuffcmd( client, "-");

    // 2: stuff the integer part.
	intpart = floor(f);
	stuffcmd_int( client, intpart, 0);
	
	
	// 3: stuff the decimal point.
	stuffcmd( client, ".");
	
	
	// 4: stuff the decimal part.
	decpart = mod( f, 1);
	decpart = decpart * 10000;
	stuffcmd_int( client, decpart, 10000);
	
}

.float fog_density;
.vector fog_color;
.entity fog_active_fog_trigger;
.string fog_info_entity;

void SetFog(entity client, float density, vector color, float transitionTime = 0)
{
	client.fog_density = density;
	client.fog_color = color;
	stuffcmd(client, "\nfog ");
	stuffcmd_float(client, density);
	stuffcmd(client, " ");
	stuffcmd_float(client, color_x);
	stuffcmd(client, " ");
	stuffcmd_float(client, color_y);
	stuffcmd(client, " ");
	stuffcmd_float(client, color_z);
	if(transitionTime > 0)
	{
		stuffcmd(client, " ");
		stuffcmd_float(client, transitionTime);
	}
	stuffcmd(client, "\n");
}	

entity GetFogInfoEntity(entity e, .string field = fog_info_entity)
{
	if(e.field)
	{
		e = find(world, targetname, e.field);
		if(e.classname == "info_fog")
		{
			return e;
		}
	}
	return world;
}

float FogPushSettingsFrom(entity client, entity source, float transitionTime)
{
	if(client.classname != "player") return FALSE;
	source = GetFogInfoEntity(source);
	if(!source) return FALSE;
	if(source.fog_density || source.fog_color || (source.spawnflags & FORCE_SET_FOG))
	{
		SetFog(client, source.fog_density, source.fog_color, transitionTime);
		return TRUE;
	}
	return FALSE;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

/*QUAKED info_fog (0.5 .5 .8) (-8 -8 -8) (8 8 8)
Fog value definition
wait: fog density
dest: fog color
*/

void info_fog()
{
	if(!self.fog_density) self.fog_density = 0.05;
	else if(self.fog_color_x > 1.0 || self.fog_color_y > 1.0 || self.fog_color_z > 1.0) //Not in 0..1 range?
	{
		self.fog_color = self.fog_color * (1.0 / 255);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

void trigger_fog_activate()
{
    if(self == other.fog_active_fog_trigger) return;
	if (other.classname != "player") // Yoder add, 27/09/2020 to fix crash
		return;
	other.fog_active_fog_trigger = self;
	FogPushSettingsFrom(other, self, self.delay);
}

/*QUAKED trigger_fog (0.5 .5 .8) (? ? ?) (? ? ?)
Trigger to transition fog
fog_info_entity: info_fog that contains values this trigger should use.
delay: time to fade the transition over
*/
void trigger_fog()
{
	// Fog is set on the server, so transitions and triggers work really bad in multiplayer. 
	// Just remove ourself if we're in multiplayer.
	if(coop || deathmatch) 
	{
		remove(self);
		return;
	}

	if(!self.delay) self.delay = 0.5;	
	self.use = trigger_fog_activate;
    if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) )
    {
        self.touch = trigger_fog_activate;
    }
    InitTrigger ();
}


//////////////////////////////////////////////////////////////////////////////////////////////////////

float trigger_fog_transition_touch_get_tween(entity pl)
{
	vector t = pl.origin - self.mins;
	vector b = self.size;
	float tween;

	if(self.style == 0)
	{
		tween = t_x / b_x;
	}
	else if(self.style == 1)
	{
		tween = t_y / b_y;
	}
	else if(self.style == 2)
	{
		tween = t_z / b_z;
	}

	if(tween < 0) tween = 0;
	if(tween > 1) tween = 1;

	return tween;
}

void trigger_fog_transition_touch()
{
	if(other.classname != "player") return;
	
	float tween = trigger_fog_transition_touch_get_tween(other);
	
	entity fog1 = GetFogInfoEntity(self);
	entity fog2 = GetFogInfoEntity(self, target);

	float density = ((1 - tween) * fog1.fog_density) + (tween * fog2.fog_density);
	vector color = ((1 - tween) * fog1.fog_color) + (tween * fog2.fog_color);

	SetFog(other, density, color);
}

/*QUAKED trigger_fog_transition (0.5 .5 .8) (? ? ?) (? ? ?)
Trigger to transition fog between two sides.
fog_info_entity: info_fog that contains values this trigger should use on the 'left' side.
target: info_fog that contains values this trigger should use on the 'right' side.
style: Which axis this trigger fades across. 0 = X, 1 = Y, 2 = Z
*/
void trigger_fog_transition()
{
	// Fog is set on the server, so transitions and triggers work really bad in multiplayer. 
	// Just remove ourself if we're in multiplayer.
	if(coop || deathmatch) 
	{
		remove(self);
		return;
	}

	if(self.style < 0 || self.style > 2)
	{
		objerror("Invalid style for trigger_fog_transition. Needs to be 0, 1 or 2.");
	}
	self.touch = trigger_fog_transition_touch;
    InitTrigger ();
}

