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


entity frametick_head;
.entity frametick_next;

void RegisterFrameTickEntity(entity ent)
{
    if(!ent.tick)
    {
        entity oself = self;
        self = ent;
        objerror("Registered frame tick entity doesn't have tick function.\n");
        self = oself;
    }
    ent.frametick_next = frametick_head;
    frametick_head = ent;
}

void RemoveFrameTickEntity(entity rem)
{
    if(!rem.tick) return;

    if(rem == frametick_head){
        frametick_head = rem.frametick_next;
        rem.frametick_next = world;
        return;
    }

    entity ent = frametick_head;
    while(ent)
    {
        if(ent.frametick_next == rem)
        {
            ent.frametick_next = rem.frametick_next;
            rem.frametick_next = world;
            return;
        }
        ent = ent.frametick_next;
    }
}

void RunFrameTickEntities(float deltaTime)
{
    entity oself = self;
    entity ent = frametick_head;
    while(ent)
    {
        self = ent;
        ent = self.frametick_next;
        self.tick(deltaTime);
    }
    self = oself;
}
