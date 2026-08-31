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
==============================================================================

BOSS-ONE

==============================================================================
*/
$cd id1/models/boss1
$origin 0 0 -15
$base base
$skin skin
$scale 5

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10

float BOSS_KILLABLE = 2;

void(vector p) boss_final_missile;

void(entity attacker, float damage) boss_final_pain; // Yoder add, September 9 2020
void() SUB_Freeze; // Yoder add, Dec 16 2020
void() SUB_Unfreeze; // Yoder add, Dec 16 2020
void() boss_final_missile1; // yoder add, Jan 20 2020
void() boss_final_face =
{
// go for another player if multi player
	if (self.enemy.health <= 0 || random() < 0.02)
	{
		self.enemy = find(self.enemy, classname, "player");
		if (!self.enemy)
			self.enemy = find(self.enemy, classname, "player");
	}
	if (self.enemy.health > 0) // yoder add Jan 20 2020 to stop Chthon from twitching each idle step.
		ai_face();
};

void() boss_final_rise1	=[	$rise1, boss_final_rise2 ] {
sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);
};
void() boss_final_rise2	=[	$rise2, boss_final_rise3 ] {
sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
};
void() boss_final_rise3	=[	$rise3, boss_final_rise4 ] {};
void() boss_final_rise4	=[	$rise4, boss_final_rise5 ] {};
void() boss_final_rise5	=[	$rise5, boss_final_rise6 ] {};
void() boss_final_rise6	=[	$rise6, boss_final_rise7 ] {};
void() boss_final_rise7	=[	$rise7, boss_final_rise8 ] {};
void() boss_final_rise8	=[	$rise8, boss_final_rise9 ] {};
void() boss_final_rise9	=[	$rise9, boss_final_rise10 ] {};
void() boss_final_rise10	=[	$rise10, boss_final_rise11 ] {};
void() boss_final_rise11	=[	$rise11, boss_final_rise12 ] {};
void() boss_final_rise12	=[	$rise12, boss_final_rise13 ] {};
void() boss_final_rise13	=[	$rise13, boss_final_rise14 ] {};
void() boss_final_rise14	=[	$rise14, boss_final_rise15 ] {};
void() boss_final_rise15	=[	$rise15, boss_final_rise16 ] {};
void() boss_final_rise16	=[	$rise16, boss_final_rise17 ] {};
void() boss_final_rise17	=[	$rise17, boss_final_missile1 ] {};

void() boss_final_idle1	=[	$walk1, boss_final_idle2 ]
{
// look for other players
};
void() boss_final_idle2	=[	$walk2, boss_final_idle3 ] {boss_final_face();};
void() boss_final_idle3	=[	$walk3, boss_final_idle4 ] {boss_final_face();};
void() boss_final_idle4	=[	$walk4, boss_final_idle5 ] {boss_final_face();};
void() boss_final_idle5	=[	$walk5, boss_final_idle6 ] {boss_final_face();};
void() boss_final_idle6	=[	$walk6, boss_final_idle7 ] {boss_final_face();};
void() boss_final_idle7	=[	$walk7, boss_final_idle8 ] {boss_final_face();};
void() boss_final_idle8	=[	$walk8, boss_final_idle9 ] {boss_final_face();};
void() boss_final_idle9	=[	$walk9, boss_final_idle10 ] {boss_final_face();};
void() boss_final_idle10	=[	$walk10, boss_final_idle11 ] {boss_final_face();};
void() boss_final_idle11	=[	$walk11, boss_final_idle12 ] {boss_final_face();};
void() boss_final_idle12	=[	$walk12, boss_final_idle13 ] {boss_final_face();};
void() boss_final_idle13	=[	$walk13, boss_final_idle14 ] {boss_final_face();};
void() boss_final_idle14	=[	$walk14, boss_final_idle15 ] {boss_final_face();};
void() boss_final_idle15	=[	$walk15, boss_final_idle16 ] {boss_final_face();};
void() boss_final_idle16	=[	$walk16, boss_final_idle17 ] {boss_final_face();};
void() boss_final_idle17	=[	$walk17, boss_final_idle18 ] {boss_final_face();};
void() boss_final_idle18	=[	$walk18, boss_final_idle19 ] {boss_final_face();};
void() boss_final_idle19	=[	$walk19, boss_final_idle20 ] {boss_final_face();};
void() boss_final_idle20	=[	$walk20, boss_final_idle21 ] {boss_final_face();};
void() boss_final_idle21	=[	$walk21, boss_final_idle22 ] {boss_final_face();};
void() boss_final_idle22	=[	$walk22, boss_final_idle23 ] {boss_final_face();};
void() boss_final_idle23	=[	$walk23, boss_final_idle24 ] {boss_final_face();};
void() boss_final_idle24	=[	$walk24, boss_final_idle25 ] {boss_final_face();};
void() boss_final_idle25	=[	$walk25, boss_final_idle26 ] {boss_final_face();};
void() boss_final_idle26	=[	$walk26, boss_final_idle27 ] {boss_final_face();};
void() boss_final_idle27	=[	$walk27, boss_final_idle28 ] {boss_final_face();};
void() boss_final_idle28	=[	$walk28, boss_final_idle29 ] {boss_final_face();};
void() boss_final_idle29	=[	$walk29, boss_final_idle30 ] {boss_final_face();};
void() boss_final_idle30	=[	$walk30, boss_final_idle31 ] {boss_final_face();};
//void() boss_final_idle31	=[	$walk31, boss_final_idle1 ] {boss_final_face();}; 
// Yoder change, Jan 20 2020 so that Chthon can re-aquire a target 
// CURRENT BUG: Boss looks back and forth between dead player corpses each idle step, looks twitchy!
void() boss_final_idle31 =[ $walk31, boss_final_idle1 ]
{
	boss_final_face();
	if (self.enemy)
		boss_final_missile1();
	else
		boss_final_idle1();
}


void() boss_final_mg1 = [$attack1, boss_final_mg2] {boss_final_face();};
void() boss_final_mg2 = [$attack2, boss_final_mg3] {boss_final_face();};
void() boss_final_mg3 = [$attack3, boss_final_mg4] {boss_final_face();};
void() boss_final_mg4 = [$attack4, boss_final_mg5] {boss_final_face();};
void() boss_final_mg5 = [$attack5, boss_final_mg6] {boss_final_face();};
void() boss_final_mg6 = [$attack6, boss_final_mg7] {boss_final_face();};
void() boss_final_mg7 = [$attack7, boss_final_mg8] {
	// vary max number of projectiles based on skill
	self.ammo_shells = ((skill+3)/6) * 30; // set base value by skill
	self.ammo_shells += floor(crandom()*10 + 0.5); // add random +/- 10
	self.ammo_nails = self.ammo_shells; // nails tracks number of shots remaining in the volley
	
	if (skill > 0)
		self.attack_finished = time + 5; // prevent interrupt

	boss_final_face();
};
void() boss_final_mg8 = [$attack8, boss_final_missile1] {
	local float fx, spread;
	
	spread = 1 - (self.ammo_nails/self.ammo_shells); // start at 0, end up at 1, linear
	spread *= spread; // make exponential 
	
	if (self.ammo_nails % 2 == 0)
	{
		fx = 1;
		spread *= 1; // go wide
	}
	else
		spread *= 0.5; // focused

	boss_final_missile_blast('270 60 210', spread, fx);
	if (self.ammo_nails)
		self.think = boss_final_mg8;

	self.ammo_nails--;
	boss_final_face();	
};




void() boss_final_missile1	=[	$attack1, boss_final_missile2 ] {self.boss_immune = 0; boss_final_face();};
void() boss_final_missile2	=[	$attack2, boss_final_missile3 ] {boss_final_face();};
void() boss_final_missile3	=[	$attack3, boss_final_missile4 ] {boss_final_face();};
void() boss_final_missile4	=[	$attack4, boss_final_missile5 ] {boss_final_face();};
void() boss_final_missile5	=[	$attack5, boss_final_missile6 ] {boss_final_face();};
void() boss_final_missile6	=[	$attack6, boss_final_missile7 ] {boss_final_face();};
void() boss_final_missile7	=[	$attack7, boss_final_missile8 ] {boss_final_face();};
void() boss_final_missile8	=[	$attack8, boss_final_missile9 ] {boss_final_face();};
void() boss_final_missile9	=[	$attack9, boss_final_missile10 ] {boss_final_face();};
void() boss_final_missile10	=[	$attack10, boss_final_missile11 ] {boss_final_missile('200 100 60');};
void() boss_final_missile11	=[	$attack11, boss_final_missile12 ] {boss_final_face();};
void() boss_final_missile12	=[	$attack12, boss_final_missile13 ] {boss_final_face();};
void() boss_final_missile13	=[	$attack13, boss_final_missile14 ] {boss_final_face();};
void() boss_final_missile14	=[	$attack14, boss_final_missile15 ] {boss_final_face();};
void() boss_final_missile15	=[	$attack15, boss_final_missile16 ] {boss_final_face();};
void() boss_final_missile16	=[	$attack16, boss_final_missile17 ] {boss_final_face();};
void() boss_final_missile17	=[	$attack17, boss_final_missile18 ] {boss_final_face();};
void() boss_final_missile18	=[	$attack18, boss_final_missile19 ] {boss_final_face();};
void() boss_final_missile19	=[	$attack19, boss_final_missile20 ] {boss_final_face();};
void() boss_final_missile20	=[	$attack20, boss_final_missile21 ] {boss_final_face();};
void() boss_final_missile21	=[	$attack21, boss_final_missile22 ] {boss_final_missile('200 -100 60');};
void() boss_final_missile22	=[	$attack22, boss_final_missile23 ] {boss_final_face();};
void() boss_final_missile23	=[	$attack23, boss_final_decide ] {boss_final_face();};

void() boss_final_decide = {
	if ((self.wait > 0) && (random() < 0.3))
		boss_final_mg1();
	else
		boss_final_missile1();
}


void() boss_final_shocka1 =[	$shocka1, boss_final_shocka2 ] {};
void() boss_final_shocka2 =[	$shocka2, boss_final_shocka3 ] {pain_lightning('0 0 100');};
void() boss_final_shocka3 =[	$shocka3, boss_final_shocka4 ] {};
void() boss_final_shocka4 =[	$shocka4, boss_final_shocka5 ] {};
void() boss_final_shocka5 =[	$shocka5, boss_final_shocka6 ] {pain_lightning('0 0 100');};
void() boss_final_shocka6 =[	$shocka6, boss_final_shocka7 ] {};
void() boss_final_shocka7 =[	$shocka7, boss_final_shocka8 ] {};
void() boss_final_shocka8 =[	$shocka8, boss_final_shocka9 ] {pain_lightning('0 0 100');};
void() boss_final_shocka9 =[	$shocka9, boss_final_shocka10 ] {};
void() boss_final_shocka10 =[	$shocka10, boss_final_missile1 ] {
	boss_final_upgrade();
};

void() info_boss_teleport_first =
{
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
};

void() info_boss_teleport_second =
{
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
};

void() info_boss_teleport_boss =
{
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	//self.origin = self.origin + '0 0 27';
};

void() trigger_boss_teleport_use =
{
	if (self.spawnflags & 1)
		boss_teleport(TRUE);
	else
		boss_teleport(FALSE);
}

void() trigger_boss_teleport =
{
	self.use = trigger_boss_teleport_use;
};

void(float variant) boss_teleport =
{
	local entity player, telepoint;
	local string tele_name;
	local float success;

	//dprint("doing the teleport\n");
	
	if (variant)
	{
		//dprint("variant is true! teleport boss also\n");
		tele_name = "info_boss_teleport_second";

		// teleport the boss also!
		player = find(world, classname, "monster_boss");

		telepoint = find(world, classname, "info_boss_teleport_boss");
		if (telepoint && player)
		{
			setorigin(player, telepoint.origin);
			//boss_final_awake();
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
			WriteCoord (MSG_BROADCAST, player.origin_x);
			WriteCoord (MSG_BROADCAST, player.origin_y);
			WriteCoord (MSG_BROADCAST, player.origin_z);

			player.think = boss_final_rise1;
			player.nextthink = time + 0.1;
		}
	}	
	else
	{
		tele_name = "info_boss_teleport_first";	
	}


	// set all telepoints valid (wait of 0)
	telepoint = find(world, classname, tele_name);
	while(telepoint)
	{
		telepoint.wait = 0;
		telepoint = find(telepoint, classname, tele_name);
	}

	// for each player, find a telepoint
	player = find(world, classname, "player");
	success = TRUE;
	while((player != world) && success)
	{
		// search for a valid telepoint
		telepoint = find(world, classname, tele_name);
		while (telepoint && (telepoint.wait != 0))
		{
			telepoint = find(telepoint, classname, tele_name);
		}
		if (telepoint == world) // couldn't find a valid telepoint!
		{
			success = FALSE;
			dprint("ERROR: Could not find valid teleport destination!\n");
		}
		else
		{
			telepoint.wait = 1;

			// do the teleport!
			setorigin(player, telepoint.origin);
			player.angles = telepoint.mangle;
			if (player.flags & FL_ONGROUND)
				player.flags = player.flags - FL_ONGROUND;
			player.fixangle = TRUE;
			player.velocity = '0 0 300';

			makevectors(telepoint.mangle);
			spawn_tfog(telepoint.origin + v_forward * 32); //spawn tfog in front of player

			player = find(player, classname, "player");
		}
	}
};

// target names for reinforcement waves
.string wave1;
.string wave2;
.string wave3;
.string tele_target;

void() boss_final_upgrade =
{
	local string oldtarget;
	self.wait++;
	//self.speed+=100;

	self.boss_immune = 0;

	if (self.wait == 2)
	{
		dprint("send in wave1 of reinforcements\n");
		//self.health += 1000; 
		oldtarget = self.target;
		self.target = self.wave1;
		SUB_UseTargets();
		self.target = oldtarget;
		//spawn_spiral();
	}
	else if (self.wait == 3)
	{
		dprint("teleport players to second arena\n");
		self.think = SUB_Null;
		self.frame = 0;
		self.nextthink = time;
		self.boss_immune = 1;

		oldtarget = self.target;
		self.target = self.tele_target;
		SUB_UseTargets();
		self.target = oldtarget;
		
		boss_teleport(FALSE);
	}
	else if (self.wait == 4)
	{
		oldtarget = self.target;
		self.target = self.wave2;
		SUB_UseTargets();
		self.target = oldtarget;
	}
	else if (self.wait == 5)
	{
		oldtarget = self.target;
		self.target = self.wave3;
		SUB_UseTargets();
		self.target = oldtarget;

		spawn_spiral();
	}
	//else if (self.wait > 1)
		//spawn_spiral();
		//boss_final_missile_line2('100 0 200');
}

void() boss_final_shockb1 =[	$shockb1, boss_final_shockb2 ] {};
void() boss_final_shockb2 =[	$shockb2, boss_final_shockb3 ] {pain_lightning('0 0 100');};
void() boss_final_shockb3 =[	$shockb3, boss_final_shockb4 ] {};
void() boss_final_shockb4 =[	$shockb4, boss_final_shockb5 ] {};
void() boss_final_shockb5 =[	$shockb5, boss_final_shockb6 ] {pain_lightning('0 0 100');};
void() boss_final_shockb6 =[	$shockb6, boss_final_shockb7 ] {};
void() boss_final_shockb7 =[	$shockb1, boss_final_shockb8 ] {};
void() boss_final_shockb8 =[	$shockb2, boss_final_shockb9 ] {pain_lightning('0 0 100');};
void() boss_final_shockb9 =[	$shockb3, boss_final_shockb10 ] {};
void() boss_final_shockb10 =[	$shockb4, boss_final_missile1 ] {
		boss_final_upgrade();
};

void() boss_final_shockc1 =[	$shockc1, boss_final_shockc2 ] {};
void() boss_final_shockc2 =[	$shockc2, boss_final_shockc3 ] {pain_lightning('0 0 100');};
void() boss_final_shockc3 =[	$shockc3, boss_final_shockc4 ] {};
void() boss_final_shockc4 =[	$shockc4, boss_final_shockc5 ] {};
void() boss_final_shockc5 =[	$shockc5, boss_final_shockc6 ] {pain_lightning('0 0 100');};
void() boss_final_shockc6 =[	$shockc6, boss_final_shockc7 ] {};
void() boss_final_shockc7 =[	$shockc7, boss_final_shockc8 ] {};
void() boss_final_shockc8 =[	$shockc8, boss_final_shockc9 ] {pain_lightning('0 0 100');};
void() boss_final_shockc9 =[	$shockc9, boss_final_shockc10 ] {};
void() boss_final_shockc10 =[	$shockc10, boss_final_death1 ] {};

void() boss_final_death1 = [$death1, boss_final_death2] {
	sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
	spawn_circle_thinker(1);
	spawn_circle_thinker(3);
	spawn_circle_thinker(5);
//boss_final_missile_line2('100 0 200');
};
void() boss_final_death2 = [$death2, boss_final_death3] {};
void() boss_final_death3 = [$death3, boss_final_death4] {};
void() boss_final_death4 = [$death4, boss_final_death5] {};
void() boss_final_death5 = [$death5, boss_final_death6] {};//boss_final_missile_line2('100 0 200');};
void() boss_final_death6 = [$death6, boss_final_death7] {};
void() boss_final_death7 = [$death7, boss_final_death8] {};
void() boss_final_death8 = [$death8, boss_final_death9] {};
void() boss_final_death9 = [$death9, boss_final_death10]
{
	//boss_final_missile_line2('100 0 200');
	sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
};

void() boss_final_death10 = [$death9, boss_final_death10]
{
	killed_monsters = killed_monsters + 1; 
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER);	

	self.frags++; // Targets were already used once from monster_death_use! 
	while(self.frags < 5)
	{
		SUB_UseTargets ();
		self.frags++;
	}
	chthon_finale();
	
	remove (self);
};

/* ======================================================================
Alternate Boss Missiles, January 17 2026

// ====================================================================== */
/*
void() T_RockTouch =
{
	local float damg;

	if (other == self.owner)
		return;		// don't explode on owner
	if (other.owner && other.owner.classname == "player")
		return;		
	if (other.classname == "hiplaser" && self.health == 0)
	{
		remove(other);
		return;
	}
	if ((other.classname == "rock") || (other.classname == "spike") ||
		(other.classname == "missile") || (other.classname == "grenade"))
		return; // ignore other rocks


	if (other.health)
	{
		//damg = 100 + random()*20;
		damg = 20;
		T_Damage (other, self, self.owner, damg );
	}
	
	self.origin = self.origin - 8*normalize(self.velocity);
	self.solid = SOLID_NOT;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);

	BecomeExplosion ();
};
*/

void() Rock_Death =
{
	local entity thing;

	thing = findradius(self.origin, 96);
	while (thing != world)
	{
		if (thing.classname == "rock")
		{
			thing.nextthink = time + 0.1;
			thing.think = Rock_Death;
		}
		thing = thing.chain;
	}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	remove(self);

	//BecomeExplosion ();
};
/*
void(vector p, float alt) boss_final_missile_wall =
{
	local float projectile_count, projectile_count_max, projectile_random;
	local float offset_amount;
	local vector offset, temp_offset;
	local vector vec, org, offang, temp_org;
	local vector jitter;
	projectile_count_max = 6;
	projectile_count = projectile_count_max;
	projectile_random = floor(random() * (projectile_count_max-1) + 0.5)+1; // get a value between 1 and 9
	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	offang = vectoangles(self.enemy.origin - self.origin);
	offang_z = 0;
	makevectors(offang);
	vec = v_forward;
	vec_z = 0;
	vec = (normalize(vec));




	spawn_tfog(org);
	offset = '0 0 0';
	offset_amount = 48;

	while (projectile_count)
	{

		jitter = '4 4 4';
		jitter *= crandom();
		temp_offset = offset * offset_amount;
		temp_offset_z = offset_z * offset_amount - 96;
		temp_offset += jitter;
		temp_org = org + temp_offset_x*v_forward + temp_offset_y*v_right + temp_offset_z*v_up;
		if (offset_y == -2)
		{
			offset_y = 0;
			offset_z--;
		}
		else
			offset_y--;

		
		launch_spike (temp_org, vec);
		newmis.angles = '0 0 0';

		if (projectile_count == projectile_random)
		{
			setmodel (newmis, "progs/rogue/sphere.mdl");
			newmis.takedamage = DAMAGE_YES;
			newmis.health = 10;
		}
		else
			setmodel (newmis, "progs/rogue/rubble.mdl");


		newmis.th_die = Rock_Death;
		newmis.classname = "rock";
		setsize (newmis, '-12 -12 -12', '12 12 12');		
		//newmis.solid = SOLID_SLIDEBOX; 
		//newmis.avelocity = '1 0 0';
		//newmis.avelocity *= crandom()*100;
		newmis.velocity = vec* (300+self.speed);
		
		newmis.solid = SOLID_NOT;
		newmis.think = boss_final_missile_think;
		newmis.nextthink = time + 0.2;	
		//newmis.touch = T_MissileTouch; // rocket explosion
		newmis.touch = T_RockTouch;
		sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

		projectile_count--;
	}
};
*/
void() boss_final_melee_check = {
	local vector delta;
	local float ldmg;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 300)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	ldmg = (random() + random() + random()) * 40;
	T_Damage (self.enemy, self, self, ldmg);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	SpawnMeatSpray (self.origin + v_forward*100, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*100, crandom() * 100 * v_right);
};
/*
void(vector p) boss_final_missile_line2 =
{
	local vector offang;
	local vector vec, org;
	local float projectile_count, projectile_count_max, offset, is_start;
	local vector temp_angle;
	projectile_count_max = 16;
	projectile_count = projectile_count_max;
	
	offang = vectoangles (self.enemy.origin - self.origin);	
	offset = 5; 


	is_start = floor(random() + 0.5);
	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';	
	spawn_tfog(org);

	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
	
	while (projectile_count)
	{
		temp_angle = offang;
		temp_angle_y += (projectile_count_max/2-projectile_count)*offset;
		makevectors (temp_angle);	
		org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
		org_z += -128;

		vec = v_forward; // normalize (self.enemy.origin - org);
		vec_z = 0;
		vec = (normalize(vec));

		launch_spike (org, vec);

		setmodel (newmis, "progs/rogue/plasma.mdl");


		newmis.th_die = Rock_Death;
		newmis.classname = "rock";
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		

		newmis.velocity = vec * 25; // vec*(400+self.speed/2);
		newmis.think = Rock_Accelerate;
		newmis.nextthink = time + 0.1;
		newmis.avelocity = '300 300 300';
		newmis.avelocity *= crandom();
		//newmis.touch = T_MissileTouch; // rocket explosion
		newmis.touch = T_RockTouch2;
		if (projectile_count % 4 == 0)
			newmis.frags = 1;
		

		projectile_count--;
	}

}
*/
/*
void() boss_final_missile_think =
{
	self.solid = SOLID_BBOX;
}
*/
void() T_RockTouch2 ={
	if (other == self.owner)
		return;

	if (other.classname == "monster_orb")
	{
		remove(self);
		return;
	}
	if (other.classname == "monster_lava_man")
	{
		remove(self);
		return;
	}

	if (other.classname == self.classname)
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
	else if (self.frags)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);
		

}

void(vector p, float spread, float fx) boss_final_missile_blast =
{
	local vector org, vec, offang, new_vec;
	local float orbs, t;
	local vector spread_vec, d;
	local float base_speed;
	base_speed = 400;
	if (skill > 2)
		base_speed = 500;
	else if (skill > 0)
		base_speed = 450;
	spread_vec = '0.15 0.15 0';
	spread_vec += '0.2 0.2 0' * fabs(spread);
	//spread_vec = '0.5 0.25 0';
	orbs = floor(random() * 6 +0.5);

	offang = vectoangles(self.enemy.origin - self.origin);

	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

		// lead the player on hard mode
	t = vlen(self.enemy.origin - org) / base_speed;
	vec = self.enemy.velocity;
	vec_z = 0;
	d = self.enemy.origin + t/4 * vec;		
	
	vec = normalize (d - org);
	//vec = normalize(vec) + (v_right * spread) + (v_up * spread * .2);

	if (fx)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}

	while (orbs)
	{
		new_vec = normalize(vec + crandom()*spread_vec_x*v_right + crandom()*spread_vec_y*v_up);


		//vec_z = 0; // remove the z element to keep the line on the ground
		//vec = normalize(vec);

		launch_spike (org + new_vec * 8, new_vec);
		newmis.classname = "rock";

			//if (projectile_count == random_projectile)
		setmodel (newmis, "progs/rogue/sphere.mdl");
		//setmodel (newmis, "progs/rogue/plasma.mdl");
			//else
			//	setmodel (newmis, "progs/rogue/rubble.mdl");
		setsize (newmis, '0 0 0', '0 0 0');	
		//newmis.velocity = vec * 25;
		newmis.velocity = new_vec * (base_speed + crandom() * 100);
		//newmis.think = Rock_Accelerate;
		//newmis.nextthink = time + 0.1;

		newmis.avelocity = '300 300 300';
		newmis.avelocity_x *= crandom();
		newmis.avelocity_y *= crandom();
		newmis.avelocity_z *= crandom();

		newmis.touch = T_RockTouch2;

		if (orbs % 2 == 0)
			newmis.effects (+) EF_CANDLELIGHT;

		orbs--;
	}
}

void() spawn_spiral =
{
	local entity spiral;
	spiral = spawn();
	setorigin(spiral, self.origin + '0 0 60');
	local vector vec;
	vec = (self.enemy.origin - self.origin);
	vec_z = 0;
	vec = normalize(vec);
	spiral.angles = vectoangles(vec);
	spiral.owner = self;

	spiral.think = spiral_single;
	spiral.delay = 0.15;
	if (skill <= 2)
		spiral.delay = 0.2;

	spiral.nextthink = time + spiral.delay; //time + 0.1;
	spiral.count = 50;


}



void() spiral_single =
{
	local vector org;
	org = self.origin;
	self.angles += '0 5 0';
	makevectors(self.angles);
	local float t;
	
	t = 3;

	if (skill < 2)
	{
		if ((self.count % 10) < 5)
		{
			//dprint("spiral: early exit\n");
			self.nextthink = time + self.delay;
			self.count--;
			return;
		}
	}


	while (t >= 0)
	{
		makevectors(self.angles + '0 1 0' * 90 * t);
		launch_spike (org + v_forward * 100, v_forward);
		newmis.classname = "rock";
		newmis.owner = self.owner;

		setmodel (newmis, "progs/rogue/plasma.mdl");
		setsize (newmis, '0 0 0', '0 0 0');	
		newmis.velocity = v_forward * 100;
		newmis.avelocity = '300 300 300';
		newmis.avelocity_x *= crandom();
		newmis.avelocity_y *= crandom();
		newmis.avelocity_z *= crandom();
		newmis.nextthink = time + 30;

		newmis.touch = T_RockTouch2;

		t--;
	}
	self.count--;

	if ((!self.owner) || (self.owner.health <= 0))
		remove(self);

	self.nextthink = time + self.delay;
	/*
	if (self.count)
	{
		self.nextthink = time + 0.1;
	}
	else
		remove(self); 
		*/
};

void() circle_think =
{
	spawn_circle(self.origin);
	remove(self);
}
void(float wait) spawn_circle_thinker =
{
	local entity thinker;
	thinker = spawn();
	thinker.nextthink = time + wait;
	thinker.think = circle_think;
	thinker.origin = self.origin + '0 0 60';
};

void(vector org) spawn_circle =
{
	local vector tang;
	float ang_step, steps;
	ang_step = 5;
	steps = floor(360/ang_step);
	//org = self.origin + '0 0 60';
	tang = '0 0 0';

	while(steps)
	{
		makevectors(tang);
		launch_spike (org, v_forward); 
		newmis.classname = "rock";
		newmis.owner = self;

		//setmodel (newmis, "progs/rogue/plasma.mdl");
		setmodel (newmis, "progs/rogue/sphere.mdl");
		setsize (newmis, '0 0 0', '0 0 0');	
		//newmis.velocity = v_forward * (300 + (crandom() * 100));
		newmis.velocity = v_forward * (250 + (crandom() * 100));
		newmis.avelocity = '300 300 300';
		newmis.avelocity_x *= crandom();
		newmis.avelocity_y *= crandom();
		newmis.avelocity_z *= crandom();

		newmis.nextthink = time + 20; // set a longer lifetime
		newmis.touch = T_RockTouch2;

		if (steps % 4 == 0)
		{
			newmis.effects (+) EF_DIMLIGHT;
		}
		
		tang += '0 1 0' * ang_step; 
		steps--;
	}
};

void(vector p) boss_final_missile_line_b = 
{
	local vector org, vec, new_vec;
	local float projectile_count, projectile_count_max;
	//local float random_projectile;
	local float offset, spread;
	projectile_count = 0;
	projectile_count_max = 11;
	if (skill == 0)
		projectile_count_max = 4;
	else if (skill == 1)
		projectile_count_max = 8;
	else if (skill == 3)
		projectile_count_max = 15;
	//random_projectile = floor(random() * (projectile_count_max - 1) + 0.5);

	//offang = vectoangles(self.enemy.origin - self.origin);

	//makevectors (offang);
	makevectors(self.angles);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

	vec = self.enemy.origin - org;
	vec_z = 0; // remove the z element to keep the line on the ground
	vec = normalize(vec);

	// do explosion instead of tfog?
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);

	if (p_y < 0) // left hand
	{
		//dprint("left hand\n");
		offset = (1/projectile_count_max) * 4; // number of projectile angles to the right of center
		spread = (1/projectile_count_max) * -2; // increment left
	}
	else
	{
		//dprint("right hand\n");
		offset = (1/projectile_count_max) * -4;
		spread = (1/projectile_count_max) * 2;

	}

	while(projectile_count < projectile_count_max)
	{
		T_BossRadiusDamage(self, self, 10 * random() + 10, self, org);

		new_vec = normalize(vec + (v_right * offset) + (v_right * spread * projectile_count)); // centered version
		new_vec_z = 0;
		new_vec = normalize(new_vec);
		launch_spike (org + new_vec * 8, new_vec);

		setmodel (newmis, "progs/rogue/sphere.mdl");

		setsize (newmis, '0 0 0', '0 0 0');	
		newmis.velocity = new_vec * (300 + crandom() * 100);
		if (random() > 0.5)
			newmis.velocity_z = (random() + 1) * 8;


		newmis.avelocity = '300 300 300';
		newmis.avelocity_x *= crandom();
		newmis.avelocity_y *= crandom();
		newmis.avelocity_z *= crandom();

		newmis.classname = "rock";

		if (projectile_count % 2 == 0)
		{
			newmis.frags = 1;
			newmis.effects (+) EF_CANDLELIGHT;
		}

		newmis.touch = T_RockTouch2;

		projectile_count++;

	}
}

/*
void(vector p) boss_final_missile_line =
{
	local float projectile_count, projectile_count_max, projectile_random;
	local float offset_amount;
	local vector offset, temp_offset;
	local vector vec, org, offang, temp_org;
	local vector jitter;
	projectile_count_max = 5;
	projectile_count = projectile_count_max;
	projectile_random = floor(random() * (projectile_count_max-1) + 0.5)+1; // get a value between 1 and 5
	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	offang = vectoangles(self.enemy.origin - self.origin);
	offang_z = 0;
	makevectors(offang);
	vec = v_forward;
	vec_z = 0;
	vec = (normalize(vec));
	

	spawn_tfog(org);
	offset = '0 -2 0';
	offset_amount = 48;

	while (projectile_count)
	{

		jitter = '4 4 4';
		jitter *= crandom();
		temp_offset = offset * offset_amount;
		temp_offset_z = offset_z * offset_amount - 128;
		temp_offset += jitter;
		temp_org = org + temp_offset_x*v_forward + temp_offset_y*v_right + temp_offset_z*v_up;
		offset_y++;

		launch_spike (temp_org, vec);
		newmis.angles = '0 0 0';

		if (projectile_count == projectile_random)
		{
			setmodel (newmis, "progs/rogue/sphere.mdl");
			newmis.takedamage = DAMAGE_YES;
			newmis.health = 10;
		}
		else
			setmodel (newmis, "progs/rogue/rubble.mdl");

		newmis.th_die = Rock_Death;
		newmis.classname = "rock";
		setsize (newmis, '-12 -12 -12', '12 12 12');		

		newmis.velocity = vec* (300+self.speed);
		
		newmis.solid = SOLID_NOT;
		newmis.think = boss_final_missile_think;
		newmis.nextthink = time + 0.2;	
		//newmis.touch = T_MissileTouch; // rocket explosion
		newmis.touch = T_RockTouch;
		sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

		projectile_count--;
	}

}
*/
void(vector p) boss_final_missile_alt = 
{
	// note, p is the offset position, where chthon's hand is.
	// this let's this function work for both hands
	local float r;
	r = random();

	boss_final_missile_line_b(p);
};


void(vector p) boss_final_missile_spawner =
{
	local	vector	offang;
	local	vector	org, vec;

	offang = vectoangles (self.enemy.origin - self.origin);	
	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

	launch_spike (org, vec);
	setmodel (newmis, "progs/lavaball.mdl");
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
	newmis.touch = T_MissileTouch; // rocket explosion
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0)
		boss_final_idle1 ();
};
// ======================================================================
void(vector p) boss_final_missile =
{
	if (self.spawnflags & BOSS_KILLABLE)
	{
		boss_final_missile_alt(p);
		return;
	}

	local	vector	offang;
	local	vector	org, vec, d;
	local	float	t;

	offang = vectoangles (self.enemy.origin - self.origin);	
	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	
// lead the player on hard mode

	/*
	if (skill > 1)
	{
		t = vlen(self.enemy.origin - org) / 300;
		vec = self.enemy.velocity;
		vec_z = 0;
		d = self.enemy.origin + t * vec;		
	}
	else
	{
		d = self.enemy.origin;
	}
	*/
	t = vlen(self.enemy.origin - org) / 300;
	vec = self.enemy.velocity;
	vec_z = 0;
	
	// TODO: make consistent across skills 
	/*d = self.enemy.origin + t * vec;
	if (skill < 2)
		d = (d + self.enemy.origin) / 2; // half-lead
	if (skill == 0)
	*/
		d = self.enemy.origin; // don't lead at all
	
	vec = normalize (d - org);

	launch_spike (org, vec);
	setmodel (newmis, "progs/lavaball.mdl");
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
	newmis.touch = T_MissileTouch; // rocket explosion
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0)
		boss_final_idle1 ();
};

void() boss_final_awake =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_NO;
	self.attack_finished = time + 3; // don't allow pain anims to interrupt until fully awake
		
	setmodel (self, "progs/boss.mdl");
	setsize (self, '-128 -128 -24', '128 128 256');

	self.enemy = activator;

	// Yoder add, June 14, 2020
	// Checking a spawnflag to see if chthon is killable
	self.takedamage = DAMAGE_AIM;
	self.th_die = boss_final_death1;
	//self.health = 8000;
	self.health = 12000;
	self.max_health = self.health;
	self.use = monster_use; // prevent from being re-triggered into boss_final_awake state
	self.th_pain = boss_final_pain; // Yoder add, September 9 2020
	// end of Yoder add	
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.yaw_speed = 20;
	boss_final_rise1 ();
};


/*QUAKED monster_boss (1 0 0) (-128 -128 -24) (128 128 256)
*/
void() monster_boss_final =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
    self.classname = "monster_boss";
	self.boss_immune = 1;

	precache_model ("progs/boss.mdl");
	precache_model ("progs/lavaball.mdl");

	precache_model ("progs/rogue/rubble.mdl");
	precache_model ("progs/rogue/sphere.mdl");
	precache_model ("progs/rogue/plasma.mdl");

	precache_sound ("weapons/rocket1i.wav");
	precache_sound ("boss1/out1.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound ("misc/power.wav");
	precache_sound ("boss1/throw.wav");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");
	precache_sound ("boss2/pop2.wav");

	// orb
		precache_model("progs/teleport.mdl");
	precache_model("progs/k_spike.mdl");
	precache_sound("hknight/attack1.wav");

	//total_monsters = total_monsters + 1;
	self.flags = FL_MONSTER;
	self.team = TEAM_MONSTERS;
	total_monsters++;
	WriteByte(MSG_ALL, SVC_UPDATESTAT);
	WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
	WriteLong(MSG_ALL, total_monsters);
	self.th_run = boss_final_missile1; // this is to prevent crash if HuntTarget gets fired

	self.frags = 0;
	self.use = boss_final_awake;
};

//===========================================================================


/* boss_final_pain
Play the pain animations when health drops below a certain percent

Yoder add, September 9, 2020
*/
void(entity attacker, float damage) boss_final_pain =
{
	if (self.attack_finished > time)
		return; // don't interrupt attack
	if (self.pain_finished > time)
		return;
	if (self.boss_immune)
		return;


	
	
	local void() pain_event;

	local float trigger_pain;
	trigger_pain = 0;

	/* Check health thresholds
	Note: I've rewritten this to handle the case where the boss cross multiple health thresholds simultaneously
	This should only be possible in coop, but it could produce a softlock. 

	Instead, check each threshold one by one, using targets immediately on each setp. 

	If the player somehow manages to kill the boss before the pain can process, 
	we do an extra check on during death_10 to sort it out.

	Should always fire 5 signals! (First pain, 3/4 health, 2/4 health, 1/4 health, death)
	*/
	if (self.frags == 0) // check for first blood
	{
			//SUB_UseTargets();
			trigger_pain = 1;
			pain_event = boss_final_shocka1;
			self.frags = 1;
	}
	if (self.frags == 1) // check for 5/6 threshold
	{
		if (self.health < self.max_health * 0.83)
		{
			//SUB_UseTargets();
			trigger_pain = 1;
			pain_event = boss_final_shocka1;
			self.frags = 2;
		}
	}
	if (self.frags == 2) // check for 4/6 threshold
	{
		if (self.health < self.max_health * 0.66)
		{
			//SUB_UseTargets();
			trigger_pain = 1;
			pain_event = boss_final_shocka1;
			self.frags = 3;
		}
	}
	if (self.frags == 3) // check for 3/6 threshold
	{
		if (self.health < self.max_health * 0.5)
		{
			//SUB_UseTargets();
			trigger_pain = 1;
			pain_event = boss_final_shockb1;
			self.frags = 4;
		}
	}
	if (self.frags == 4) // check for 2/6 threshold)
	{
		if (self.health < self.max_health * 0.33)
		{
			trigger_pain = 1;
			pain_event = boss_final_shocka1;
			self.frags = 5;
		}
	}
	if (self.frags == 5) // check for 1/6
	{
		if (self.health < self.max_health * 0.16)
		{
			trigger_pain = 1;
			pain_event = boss_final_shockb1;
			self.frags = 6;
		}
	}

	if (trigger_pain)
	{
		self.boss_immune = 1;
		sound (self, CHAN_WEAPON, "boss1/pain.wav", 1, ATTN_NORM);
		self.pain_finished = time + 3; 
		pain_event();

	}
};

void() chthon_finale = {
	// throw tons of meat chunks	
	local	vector	org, vec;
	local	float	i;
	//local entity	n;

	sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);
	
	i = 0;
	while (i < 100)
	{
		vec = get_org(i);
		if (vec_z > 0)
		{
			org = self.origin + (vec * 64) + '0 0 48';
			ThrowGibVec (org, vec);
		}
		i++;
	}
	// start the end text
	//WriteByte (MSG_ALL, SVC_FINALE);
	//WriteString (MSG_ALL, "$qc_finale_end");

	/*WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3); // not sure why this is needed twice...
	*/


	local entity t;
	t = spawn();
	t.think = boss_end;
	t.nextthink = time + 8;
}

void() boss_end =
{
	local entity p;
	if ( !coop)
	{
		p = find(world, classname, "player");
		if (p.health <= 0)
		{
			dprint("don't trigger completion after death!\n");
			return;
		}

	}

	// clear items for all players.
	p = find(world, classname, "player");
	while (p)
	{
		p.ammo_shells = 25;
		p.ammo_nails = 0;
		p.ammo_cells = 0;
		p.ammo_rockets = 0;
		p.armortype = 0;
		p.armorvalue = 0;
		p.weapon = IT_SHOTGUN;
		p = find(p, classname, "player");
	}

	if (serverflags & BLOODY_NIGHTMARE_ACTIVE)
	{
		if (serverflags & BLOODY_NIGHTMARE_NEWGAME)
		{
			dprint("This case shouldn't happen!\n");
			nextmap = "boss2";
		}
		else
		{
			nextmap = "map1";
			serverflags = 0; // clear runes
			serverflags = BLOODY_NIGHTMARE_ACTIVE | BLOODY_NIGHTMARE_DISCOVERED | BLOODY_NIGHTMARE_NEWGAME; 
			parm2 = 50; // set health back to min
			parm3 = 0; // set armor back to 0
			parm4 = 25; // set shells back to 25
			parm5 = 0; // nails
			parm6 = 0; // grenades
			parm7 = 0; // cells
			parm8 = IT_SHOTGUN; // selected weapon
			parm9 = 0; // armor type

			parm10 = 0; // clear health upgrades
			parm11 = 0; // clear shell upgrades
			parm12 = 0; // clear spike upgrades
			parm13 = 0; // clear rocket upgrades
			parm14 = 0; // clear cell upgrades
		}
	}
	else
	{
		//intermission_exittime = time + 10000000;	// never allow exit
		//intermission_running = 1;

		nextmap = "start";
		//intermissiontext = "$mg3_qc_boss_finale";
	}
	intermission_exittime = time + 10000000;	// never allow exit
	intermission_running = 1;

	intermissiontext = "$mg3_qc_boss_finale";

	execute_changelevel();
}

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore, vector org) T_BossRadiusDamage =
{
	local	float 	points;
	local	entity	head;
	//local	vector	org;

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage && head.classname != "monster_lava_man")
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{
						T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

void(vector p) pain_lightning =
{
	local vector tang, org;
	tang = '1 1 1';
	tang_x = random() * 180 + 180; // keep a positive pitch, above the horizon
	tang_y = random() * 360;
	tang_z = 0;
	makevectors(tang);
	org = self.origin + p;
	traceline(org, org + v_forward * 1000, TRUE, self);

	sound (self, CHAN_BODY, "misc/power.wav", 1, ATTN_NORM);
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING3);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
};