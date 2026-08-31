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


const float FUNC_FADE_STATE_HIDDEN = 0;
const float FUNC_FADE_STATE_VISIBLE = 1;

const float FUNC_FADE_DISTANCE_MAXSPEED = 320; 

float func_fade_get_shortest_playerdistance()
{
    float dist = 32767;
    float d;

    vector vpos;

    entity pl = find (world, classname, "player");
	while (pl != world)
	{
        vpos = pl.origin + pl.view_ofs;
        d = vlen(self.oldorigin - vpos);
        if(d < dist) dist = d;
        pl = find (pl, classname, "player");
    }
    return dist;
}

void func_fade_set_nextthink_for_distance(float dist)
{
    self.nextthink = self.ltime + Clamp(dist / FUNC_FADE_DISTANCE_MAXSPEED, 0.05, 2.0);
}

void func_fade_set_alpha(float a, float force=FALSE)
{
    a = Clamp(a, 0, 1);
    if( !force && fabs(a - self.alpha) < 0.001) return;
    if (self.state == FUNC_FADE_STATE_HIDDEN && a > 0)
    {
        self.state = FUNC_FADE_STATE_VISIBLE;
        self.model = self.mdl;
    }
    else if (self.state == FUNC_FADE_STATE_VISIBLE && a == 0)
    {
        self.state = FUNC_FADE_STATE_HIDDEN;
        self.model = string_null;
    }
    self.alpha = a;
}

void func_fade_think()
{
    float dist = func_fade_get_shortest_playerdistance();
    float diff = dist - self.distance;

    if (diff < 0)
    {
        //Outside the transition zone, inside the circle
        func_fade_set_alpha(1);
        dist = -diff;
        func_fade_set_nextthink_for_distance(dist);
    }
    else if(diff > self.lip)
    {
        //Outside the transition zone, outside the circle
        func_fade_set_alpha(0);
        dist = diff - self.lip;
        func_fade_set_nextthink_for_distance(dist);
    }
    else
    {
        //In the transition zone
        diff/= self.lip;
        func_fade_set_alpha(1 - diff);
        self.nextthink = self.ltime + 0.05;
    }
}

void func_fade()
{
    if(TRUE)
    {
        dprint("WARNING: A func_fade was spawned. This entity is obsolete, and was converted to a func_wall instead.\n")
        func_wall();
        return;
    }

    if(!self.distance) self.distance = 2048; //Radius of fade circle
    if(!self.lip) self.lip = 256; // Lip around fade circle

    self.waitmax = self.distance + self.lip;

    self.solid = SOLID_BSP;
    self.movetype = MOVETYPE_PUSH;

    setmodel(self, self.model);
    self.mdl = self.model;
    self.oldorigin = self.mins + ((self.maxs - self.mins) * 0.5);

    self.state = FUNC_FADE_STATE_VISIBLE;

    self.think = func_fade_think;
    self.nextthink = self.ltime + 0.2 + random() * 0.2;

    func_fade_set_alpha(0, TRUE);
}
