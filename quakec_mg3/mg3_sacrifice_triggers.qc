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

//=============================================================================
void() sacrifice_counter_use =
{
	self.count = self.count -1;
	if (self.count < 0)
		return;
	
	if (self.count != 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			get_sacrifice_count(self);
		}
		return;
	}

	if (activator.classname == "player"	&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
	{
		centerprint_all("$mg3_qc_sacricie_count_complete");
		//centerprint_all("$qc_sequence_completed");
	}
	self.enemy = activator;
	
	multi_trigger ();
};

void(entity counter) get_sacrifice_count =
{
	if (counter.count <= 0)
		return;
	switch (counter.count)
	{
		case 1:
			centerprint_all ("$mg3_qc_sacricie_count_1_more");	
			break;
		case 2:
			centerprint_all ("$mg3_qc_sacricie_count_2_more");
			break;
		case 3:
			centerprint_all ("$mg3_qc_sacricie_count_3_more");
			break;
		case 4:
			centerprint_all ("$mg3_qc_sacricie_count_4_more");
			break;
		case 5:
			centerprint_all ("$mg3_qc_sacricie_count_5_more");
			break;
		case 6:
			centerprint_all ("$mg3_qc_sacricie_count_6_more");
			break;
		case 7:
			centerprint_all ("$mg3_qc_sacricie_count_7_more");
			break;
		case 8:
			centerprint_all ("$mg3_qc_sacricie_count_8_more");
			break;
		default:
			centerprint_all ("$mg3_qc_sacricie_count_more");
			break;
	}
};

void() check_sacrifices_think =
{
	// untouch
	self.wait = 0;
};

void() check_sacrifices_touch =
{
	local entity f;
	local string t;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if (self.wait == 0)
	{
		self.wait = 1; // prevent retouch until time has expired

		// do the work
		t = self.target;
		f = find(world, targetname, t);
		if (f)
			get_sacrifice_count(f);
	}

	self.think = check_sacrifices_think;
	self.nextthink = time + 0.2;
	
};

void() trigger_check_sacrifices =
{
	InitTrigger ();
	self.touch = check_sacrifices_touch;
	self.wait = 0;
}


/*QUAKED trigger_counter (.5 .5 .5) ? nomessage message_all
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_sacrifice_counter =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;
	
	// Yoder Sept24, 2021 Horde Merge
	// .count is decremented each use and fires its targets on 0
	// .wait stores the original .count and restores to this if COUNTER_LOOPS
	if (!self.count)
		self.count = 2;
	
	if (!self.wait)
		self.wait = self.count;

	self.use = sacrifice_counter_use;
};


//=============================================================================
