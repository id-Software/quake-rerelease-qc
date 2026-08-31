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

void(string name) infected_set_enemy =
{
	local entity f;
	
	if (self.enemy && self.enemy.classname == name)
	{
		// prevent infighting after transformation
		f = find(world, classname, "player");
		while ((f != world) && (f.health <= 0))
		{
			f = find(f, classname, "player");
		}
		if (f != world)
		{
			// check if the enemy's enemy is also stuck infighting
			if (self.enemy.enemy && (self.enemy.enemy == self))
				self.enemy.enemy = f;
			self.enemy = f;
		}
	}
};