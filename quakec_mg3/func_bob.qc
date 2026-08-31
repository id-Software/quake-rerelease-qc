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

const float FUNC_BOB_NONSOLID = 1;
const float FUNC_BOB_START_ON = 2;

const float FUNC_BOB_THINKINTERVAL = 0.05;

vector func_bob_GetPositionForAngle(float an)
{
    self.count += (an);
    self.count = mod(self.count, 360);

    float dd = sin(self.count);
    vector offs = self.dest * dd;
    if(self.dest2)
    {   
        float ddc = cos(self.count);
        offs+= (self.dest2 * ddc);
    }

    return offs;
}

void func_bob_blocked()
{
    if(self.attack_finished > time) return;
    T_Damage(other, self, self, self.dmg);
    self.attack_finished = time + 0.5;
}

/*
    We have two different strategies for movement here.
    For solid bobbers, we use the think function and set a velocity. This allows us to stand smoothly on the bobber and be blocked by it.
    For non solid bobbers, the engine does not like having something nonsolid that moves apparently, so instead we just set its position each frame. 
*/

// Used by non-solid bobbers
void func_bob_tick(float dt)
{
    vector offs = func_bob_GetPositionForAngle(self.avelocity_x * dt);
    setorigin(self, offs);
}

// Used by solid bobbers
void func_bob_think()
{
    vector offs = func_bob_GetPositionForAngle(self.avelocity_x * FUNC_BOB_THINKINTERVAL);

    vector diff = offs - self.origin;
    self.velocity = diff * (1/FUNC_BOB_THINKINTERVAL);

    self.nextthink = self.ltime + FUNC_BOB_THINKINTERVAL;
}

void func_bob_use()
{
    if(self.state)
    {
        if(self.solid)
        {
            self.velocity = '0 0 0';
            self.nextthink = -1;
        }
        else
        {
            RemoveFrameTickEntity(self);
        }
    }
    else
    {
        if(self.solid)
        {
            func_bob_think();
        }
        else
        {
            RegisterFrameTickEntity(self);
        }
    }

    self.state = 1 - self.state;
}

void func_bob()
{
     setmodel(self, self.model);
     setorigin(self, self.origin);

     if(!self.dest) self.dest = '0 0 64';
     if(!self.wait) self.wait = 10;
     if(!self.dmg) self.dmg = 1;
     
     self.avelocity_x = 360 / self.wait;
     self.count = 360 * self.delay;
 
     self.use = func_bob_use;
     self.tick = func_bob_tick;
     self.think = func_bob_think;
     self.blocked = func_bob_blocked;
         

    if(self.spawnflags & FUNC_BOB_NONSOLID)
    {
        self.movetype = MOVETYPE_NONE;
        self.solid = SOLID_NOT;
    }
    else
    {
        self.movetype = MOVETYPE_PUSH;
        self.solid = SOLID_BSP;
    }
    
    if(self.spawnflags & FUNC_BOB_START_ON)
    {
        func_bob_use();
    }
}