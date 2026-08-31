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

OLD ONE

==============================================================================
*/
$cd id1/models/oldnew_one
$origin 0 0 24
$base base
$skin skin
$scale 1

void() finale_1;
void() finale_2;
void() finale_3;
void() finale_4;


entity	shub;

$frame old1 old2 old3 old4 old5 old6 old7 old8 old9 
$frame old10 old11 old12 old13 old14 old15 old16 old17 old18 old19 
$frame old20 old21 old22 old23 old24 old25 old26 old27 old28 old29 
$frame old30 old31 old32 old33 old34 old35 old36 old37 old38 old39 
$frame old40 old41 old42 old43 old44 old45 old46 

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
$frame shake9 shake10 shake11 shake12 shake13 shake14
$frame shake15 shake16 shake17 shake18 shake19 shake20

//void() oldnew_stand     =[      $old1,       oldnew_stand    ] {};
void() oldnew_idle1        =[      $old1,  oldnew_idle2       ] {ai_stand();};
void() oldnew_idle2        =[      $old2,  oldnew_idle3       ] {ai_stand();};
void() oldnew_idle3        =[      $old3,  oldnew_idle4       ] {ai_stand();};
void() oldnew_idle4        =[      $old4,  oldnew_idle5       ] {ai_stand();};
void() oldnew_idle5        =[      $old5,  oldnew_idle6       ] {ai_stand();};
void() oldnew_idle6        =[      $old6,  oldnew_idle7       ] {ai_stand();};
void() oldnew_idle7        =[      $old7,  oldnew_idle8       ] {ai_stand();};
void() oldnew_idle8        =[      $old8,  oldnew_idle9       ] {ai_stand();};
void() oldnew_idle9        =[      $old9,  oldnew_idle10      ] {ai_stand();};
void() oldnew_idle10       =[      $old10, oldnew_idle11      ] {ai_stand();};
void() oldnew_idle11       =[      $old11, oldnew_idle12      ] {ai_stand();};
void() oldnew_idle12       =[      $old12, oldnew_idle13      ] {ai_stand();};
void() oldnew_idle13       =[      $old13, oldnew_idle14      ] {ai_stand();};
void() oldnew_idle14       =[      $old14, oldnew_idle15      ] {ai_stand();};
void() oldnew_idle15       =[      $old15, oldnew_idle16      ] {ai_stand();};
void() oldnew_idle16       =[      $old16, oldnew_idle17      ] {ai_stand();};
void() oldnew_idle17       =[      $old17, oldnew_idle18      ] {ai_stand();};
void() oldnew_idle18       =[      $old18, oldnew_idle19      ] {ai_stand();};
void() oldnew_idle19       =[      $old19, oldnew_idle20      ] {ai_stand();};
void() oldnew_idle20       =[      $old20, oldnew_idle21      ] {ai_stand();};
void() oldnew_idle21       =[      $old21, oldnew_idle22      ] {ai_stand();};
void() oldnew_idle22       =[      $old22, oldnew_idle23      ] {ai_stand();};
void() oldnew_idle23       =[      $old23, oldnew_idle24      ] {ai_stand();};
void() oldnew_idle24       =[      $old24, oldnew_idle25      ] {ai_stand();};
void() oldnew_idle25       =[      $old25, oldnew_idle26      ] {ai_stand();};
void() oldnew_idle26       =[      $old26, oldnew_idle27      ] {ai_stand();};
void() oldnew_idle27       =[      $old27, oldnew_idle28      ] {ai_stand();};
void() oldnew_idle28       =[      $old28, oldnew_idle29      ] {ai_stand();};
void() oldnew_idle29       =[      $old29, oldnew_idle30      ] {ai_stand();};
void() oldnew_idle30       =[      $old30, oldnew_idle31      ] {ai_stand();};
void() oldnew_idle31       =[      $old31, oldnew_idle32      ] {ai_stand();};
void() oldnew_idle32       =[      $old32, oldnew_idle33      ] {ai_stand();};
void() oldnew_idle33       =[      $old33, oldnew_idle34      ] {ai_stand();};
void() oldnew_idle34       =[      $old34, oldnew_idle35      ] {ai_stand();};
void() oldnew_idle35       =[      $old35, oldnew_idle36      ] {ai_stand();};
void() oldnew_idle36       =[      $old36, oldnew_idle37      ] {ai_stand();};
void() oldnew_idle37       =[      $old37, oldnew_idle38      ] {ai_stand();};
void() oldnew_idle38       =[      $old38, oldnew_idle39      ] {ai_stand();};
void() oldnew_idle39       =[      $old39, oldnew_idle40      ] {ai_stand();};
void() oldnew_idle40       =[      $old40, oldnew_idle41      ] {ai_stand();};
void() oldnew_idle41       =[      $old41, oldnew_idle42      ] {ai_stand();};
void() oldnew_idle42       =[      $old42, oldnew_idle43      ] {ai_stand();};
void() oldnew_idle43       =[      $old43, oldnew_idle44      ] {ai_stand();};
void() oldnew_idle44       =[      $old44, oldnew_idle45      ] {ai_stand();};
void() oldnew_idle45       =[      $old45, oldnew_idle46      ] {ai_stand();};
void() oldnew_idle46       =[      $old46, oldnew_idle1       ] {ai_stand();};

//============================================================================

void() oldnew_walk1        =[      $old1,  oldnew_walk2       ] {ai_face(); self.boss_immune = 0;};
void() oldnew_walk2        =[      $old2,  oldnew_walk3       ] {ai_face();};
void() oldnew_walk3        =[      $old3,  oldnew_walk4       ] {ai_face();};
void() oldnew_walk4        =[      $old4,  oldnew_walk5       ] {ai_face();};
void() oldnew_walk5        =[      $old5,  oldnew_walk6       ] {ai_face();};
void() oldnew_walk6        =[      $old6,  oldnew_walk7       ] {ai_face();};
void() oldnew_walk7        =[      $old7,  oldnew_walk8       ] {ai_face();};
void() oldnew_walk8        =[      $old8,  oldnew_walk9       ] {ai_face();};
void() oldnew_walk9        =[      $old9,  oldnew_walk10      ] {ai_face();};
void() oldnew_walk10       =[      $old10, oldnew_walk11      ] {ai_face();};
void() oldnew_walk11       =[      $old11, oldnew_walk12      ] {ai_face();};
void() oldnew_walk12       =[      $old12, oldnew_walk13      ] {ai_face();};
void() oldnew_walk13       =[      $old13, oldnew_walk14      ] {ai_face();};
void() oldnew_walk14       =[      $old14, oldnew_walk15      ] {ai_face();oldnew_attack();};
void() oldnew_walk15       =[      $old15, oldnew_walk16      ] {ai_face();};
void() oldnew_walk16       =[      $old16, oldnew_walk17      ] {ai_face();};
void() oldnew_walk17       =[      $old17, oldnew_walk18      ] {ai_face();};
void() oldnew_walk18       =[      $old18, oldnew_walk19      ] {ai_face();};
void() oldnew_walk19       =[      $old19, oldnew_walk20      ] {ai_face();};
void() oldnew_walk20       =[      $old20, oldnew_walk21      ] {ai_face();};
void() oldnew_walk21       =[      $old21, oldnew_walk22      ] {ai_face();oldnew_autogun_check(1, 0.05, 1);};
void() oldnew_walk22       =[      $old22, oldnew_walk23      ] {ai_face();oldnew_autogun_check(1, 0, 2);};
void() oldnew_walk23       =[      $old23, oldnew_walk24      ] {ai_face();spawn_szombie();oldnew_autogun_check(1, -0.05, 3);};
void() oldnew_walk24       =[      $old24, oldnew_walk25      ] {ai_face();oldnew_autogun_check(1, -0.1, 4);};
void() oldnew_walk25       =[      $old25, oldnew_walk26      ] {ai_face();oldnew_autogun_check(1, -0.15, 5);};
void() oldnew_walk26       =[      $old26, oldnew_walk27      ] {ai_face();};
void() oldnew_walk27       =[      $old27, oldnew_walk28      ] {ai_face();};
void() oldnew_walk28       =[      $old28, oldnew_walk29      ] {ai_face();};
void() oldnew_walk29       =[      $old29, oldnew_walk30      ] {ai_face();oldnew_attack();};
void() oldnew_walk30       =[      $old30, oldnew_walk31      ] {ai_face();};
void() oldnew_walk31       =[      $old31, oldnew_walk32      ] {ai_face();};
void() oldnew_walk32       =[      $old32, oldnew_walk33      ] {ai_face();};
void() oldnew_walk33       =[      $old33, oldnew_walk34      ] {ai_face();};
void() oldnew_walk34       =[      $old34, oldnew_walk35      ] {ai_face();};
void() oldnew_walk35       =[      $old35, oldnew_walk36      ] {ai_face();};
void() oldnew_walk36       =[      $old36, oldnew_walk37      ] {ai_face();oldnew_autogun_check(-1, -0.05, 1);};
void() oldnew_walk37       =[      $old37, oldnew_walk38      ] {ai_face();oldnew_autogun_check(-1, 0, 2);};
void() oldnew_walk38       =[      $old38, oldnew_walk39      ] {ai_face();oldnew_autogun_check(-1, 0.05, 3);};
void() oldnew_walk39       =[      $old39, oldnew_walk40      ] {ai_face();oldnew_autogun_check(-1, 0.1, 4);};
void() oldnew_walk40       =[      $old40, oldnew_walk41      ] {ai_face();oldnew_autogun_check(-1, 0.15, 5);};
void() oldnew_walk41       =[      $old41, oldnew_walk42      ] {ai_face();};
void() oldnew_walk42       =[      $old42, oldnew_walk43      ] {ai_face();};
void() oldnew_walk43       =[      $old43, oldnew_walk44      ] {ai_face();};
void() oldnew_walk44       =[      $old44, oldnew_walk45      ] {ai_face();oldnew_attack();};
void() oldnew_walk45       =[      $old45, oldnew_walk46      ] {ai_face();spawn_szombie();};
void() oldnew_walk46       =[      $old46, oldnew_walk1       ] {
	ai_face();
};

void() oldnew_attack =
{
	if (self.boss_immune)
		return;
	if (self.cnt % 3 != 0)
	{
		if (self.boss_phase <= 3)
			spawn_sphere_chunk_manager(1);
		else
			spawn_sphere_chunk_manager(2);
	}
	else
	{
		if (self.boss_phase == 0) // prelude
		{
			spawn_sphere_chunk_manager(1);
		}
		else if (self.boss_phase == 1) // phase 1
		{
			dprint("PHASE 1!!!\n");
			if (self.count == 0)
			{
				spawn_spammer();
			}
			else if (self.count == 1)
			{
				spawn_swiper();
			}
			self.count++; 
			if (self.count > 1)
				self.count = 0;
		}
		else if (self.boss_phase == 2) // phase 2
		{
			dprint("PHASE 2!!!\n");
			if (self.count == 0)
				spawn_vortex();
			else if (self.count == 1)
				spawn_swiper();
			else if (self.count == 2)
				spawn_spammer();
			self.count++;
			if (self.count > 2)
				self.count = 0;
		}
		else if (self.boss_phase == 3) // phase 3
		{
			dprint("PHASE 3!!!\n");
			if (self.count == 0)
				spawn_blaster();
			else if (self.count == 1)
				spawn_swiper();
				//spawn_eye();
			else if (self.count == 2)
				spawn_swiper();
			else if (self.count == 3)
				spawn_swiper();
			self.count++;
			if (self.count > 3)
				self.count = 0;
		}
		else if (self.boss_phase >= 4) // phase 4
		{
			dprint("PHASE 4!!!\n");
			if (self.count == 0)
				spawn_spammer(); // hardcore version
			else if (self.count == 1)
				spawn_eye();
			else if (self.count == 2)
				spawn_swiper();
			else if (self.count == 3)
				spawn_blaster();
			self.count++;
			if (self.count > 3)
				self.count = 0;

		}

	}
	self.cnt++;

}
//============================================================================

void() oldnew_thrash1        =[ $shake1,  oldnew_thrash2       ] {};
void() oldnew_thrash2        =[      $shake2,  oldnew_thrash3       ] {};
void() oldnew_thrash3        =[      $shake3,  oldnew_thrash4       ] {};
void() oldnew_thrash4        =[      $shake4,  oldnew_thrash5       ] {pain_lightning('0 0 100');};
void() oldnew_thrash5        =[      $shake5,  oldnew_thrash6       ] {};
void() oldnew_thrash6        =[      $shake6,  oldnew_thrash7       ] {};
void() oldnew_thrash7        =[      $shake7,  oldnew_thrash8       ] {pain_lightning('0 0 100');};
void() oldnew_thrash8        =[      $shake8,  oldnew_thrash9       ] {};
void() oldnew_thrash9        =[      $shake9,  oldnew_thrash10      ] {};
void() oldnew_thrash10       =[      $shake10, oldnew_thrash11      ] {};
void() oldnew_thrash11       =[      $shake11, oldnew_thrash12      ] {pain_lightning('0 0 100');};
void() oldnew_thrash12       =[      $shake12, oldnew_thrash13      ] {};
void() oldnew_thrash13       =[      $shake13, oldnew_thrash14      ] {};
void() oldnew_thrash14       =[      $shake14, oldnew_thrash15      ] {
	self.boss_immune = 1;
	//actual_sphere();
	if (skill > 2)
		spawn_sphere_manager(self.boss_phase);
	else
		spawn_sphere_manager(1);
};
void() oldnew_thrash15       =[      $shake15, oldnew_walk1      ] {self.boss_immune = 0;};
//============================================================================

// DEATH
void() oldnew_death1        =[ $shake1,  oldnew_death2       ] {
	sound (self, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
};
void() oldnew_death2        =[      $shake2,  oldnew_death3       ] {};
void() oldnew_death3        =[      $shake3,  oldnew_death4       ] {};
void() oldnew_death4        =[      $shake4,  oldnew_death5       ] {pain_lightning('0 0 100');};
void() oldnew_death5        =[      $shake5,  oldnew_death6       ] {};
void() oldnew_death6        =[      $shake6,  oldnew_death7       ] {};
void() oldnew_death7        =[      $shake7,  oldnew_death8       ] {pain_lightning('0 0 100');};
void() oldnew_death8        =[      $shake8,  oldnew_death9       ] {};
void() oldnew_death9        =[      $shake9,  oldnew_death10      ] {};
void() oldnew_death10       =[      $shake10, oldnew_death11      ] {pain_lightning('0 0 100');};
void() oldnew_death11       =[      $shake11, oldnew_death12      ] {};
void() oldnew_death12       =[      $shake12, oldnew_death13      ] {};
void() oldnew_death13       =[      $shake13, oldnew_death14      ] {};
void() oldnew_death14       =[      $shake14, oldnew_death15      ] {};
void() oldnew_death15       =[      $shake15, oldnew_death16      ] {
self.cnt = self.cnt + 1;
if (self.cnt != 3)
	self.think = oldnew_death1;
};
void() oldnew_death16       =[      $shake16, oldnew_death17      ] {
	
	lightstyle(0, "g");
};
void() oldnew_death17       =[      $shake17, oldnew_death18      ] {lightstyle(0, "c");};
void() oldnew_death18       =[      $shake18, oldnew_death19      ] {lightstyle(0, "b");};
void() oldnew_death19       =[      $shake19, oldnew_death20      ] {lightstyle(0, "a");};
void() oldnew_death20       =[      $shake20, oldnew_death20      ] {oldnew_finale_4();};

//============================================================================

void() oldnew_finale_1 =
{
	self.takedamage = DAMAGE_NO;
	self.boss_immune = 1;

	self.cnt = 0;
	oldnew_death1();
	oldnew_cleanup();
	if (skill > 2)
		spawn_sphere_manager(self.boss_phase);
	else
		spawn_sphere_manager(1);
	//actual_sphere();
	//remove(self); return;
};

void(vector org, vector vec) ThrowGibVec =
{
	local	entity new;
	local float r, speed;

	new = spawn();
	new.origin = org;
	r = random();
	speed = 800 + crandom()*200;
	if (r < 0.3)
		setmodel (new, "progs/gib1.mdl");
	else if (r < 0.6)
		setmodel (new, "progs/gib2.mdl");
	else
		setmodel (new, "progs/gib3.mdl");
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = vec * speed;
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

void() oldnew_finale_4 =
{
	// throw tons of meat chunks	
	local	vector	org, vec;
	local	float	i;
	local entity p;
	//local entity	n;

	sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);

	
	if ( !coop)
	{
		p = find(world, classname, "player");
		if (p.health <= 0)
		{
			dprint("don't trigger completion after death!\n");
			oldnew_idle1();
			return;
		}
	}
	
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
	/*
	z = 16;
	while (z <= 144)
	{
		x = -64;
		while (x <= 64)
		{
			y = -64;
			while (y <= 64)
			{
				self.origin_x = oldo_x + x;
				self.origin_y = oldo_y + y;
				self.origin_z = oldo_z + z;

				r = random();
				if (r < 0.3)				
					ThrowGib ("progs/gib1.mdl", -999);
				else if (r < 0.6)
					ThrowGib ("progs/gib2.mdl", -999);
				else
					ThrowGib ("progs/gib3.mdl", -999);
				y = y + 32;
			}
			x = x + 32;
		}
		z = z + 96;
	}
	*/
	// start the end text
	//WriteByte (MSG_ALL, SVC_FINALE);
	//WriteString (MSG_ALL, "$qc_finale_end");

// put a player model down
//	n = spawn();
//	setmodel (n, "progs/player.mdl");
//	oldo = oldo - '32 264 0';
//	setorigin (n, oldo);
//	n.angles = '0 290 0';
//	n.frame = 1;

	remove (self);

// switch cd track
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	lightstyle(0, "m");	

	oldnew_credits();
};

void() oldnew_credits =
{
	intermission_exittime = time + 10000000;	// never allow exit
	intermission_running = 1;

	nextmap = "start";
	intermissiontext = "$map_dopa_endtext_final";

	execute_changelevel();
}


//============================================================================
void() oldnew_cleanup =
{
	local entity f;
	f = find(world, classname, "oldnew_child");
	while (f)
	{
		f.nextthink = time + 0.1;
		f.think = oldnew_cleanup_think;
		f = find(f, classname, "oldnew_child");
	}

	f = find(world, classname, "oldnew_eye");
	while (f)
	{
		f.think = oldnew_cleanup_think;
		f.nextthink = time + 0.1;
		f = find(f, classname, "oldnew_eye");
	}

	f = spawn();
	f.think = oldnew_cleanup_zombies;
	f.nextthink = time+2;
};
//============================================================================
void () oldnew_cleanup_think =
{
	T_Damage(self, self, self, 5000);
};
.float boss_phase;
.float boss_immune;

void (entity attacker, float damage) oldnew_pain =
{
	local float trigger_pain;
	local string otarget;
	//	self.health = 40000;
	if (self.boss_immune)
	{
		dprint("boss is immune during pain anim\n");
		return;
	}

	dprint("took damage! Remaining is: ");
	dprint(ftos(self.health));
	dprint("\n");


	if (self.boss_phase == 0) // check for first blood
	{
			//SUB_UseTargets();
			trigger_pain = 1;
			self.boss_phase = 1;
	}
	if (self.boss_phase == 1) // check for 3/4 threshold
	{
		if (self.health < self.max_health * 0.75)
		{
			//SUB_UseTargets();
			trigger_pain = 1;
			self.boss_phase = 2;
			spawn_eye();
			if (self.wave1)
			{
				otarget = self.target;
				self.target = self.wave1;
				SUB_UseTargets();
				self.target = otarget;
			}
		}
	}
	if (self.boss_phase == 2) // check for 2/4 threshold
	{
		if (self.health < self.max_health * 0.5)
		{
			//SUB_UseTargets();
			trigger_pain = 1;
			self.boss_phase = 3;

			if (self.wave2)
			{
				otarget = self.target;
				self.target = self.wave2;
				SUB_UseTargets();
				self.target = otarget;
			}
		}
	}
	if (self.boss_phase == 3) // check for 1/4 threshold
	{
		if (self.health < self.max_health * 0.25)
		{
			//SUB_UseTargets();
			trigger_pain = 1;
			self.boss_phase = 4;

			if (self.wave2)
			{
				otarget = self.target;
				self.target = self.wave2;
				SUB_UseTargets();
				self.target = otarget;
			}
		}
	}

	if (trigger_pain)
	{
		self.boss_immune = 1;
		sound(self, CHAN_VOICE, "orb/orb_pain.wav", 1, ATTN_NORM);
		self.pain_finished = time + 2.1;
		oldnew_thrash1();
	}
};

//============================================================================


/*QUAKED monster_oldone (1 0 0) (-16 -16 -24) (16 16 32)
*/
void() monster_oldone_new =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model2 ("progs/oldone.mdl");

	
	// projectiles
	precache_model ("progs/rogue/plasma.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("maps/bmodel/b_splash.bsp");
	precache_model ("progs/rogue/sphere.mdl");
	precache_model ("progs/teleport.mdl");
	precache_model ("progs/teleporter_eye.mdl");
	//precache_model ("maps/bmodel/b_shot2.bsp");
	precache_model("progs/diamond.mdl");

	precache_sound2 ("boss2/death.wav");
	precache_sound2 ("boss2/idle.wav");
	precache_sound2 ("boss2/sight.wav");
	precache_sound2 ("boss2/pop2.wav");
	precache_sound2 ("misc/power.wav");
	precache_sound2 ("orb/orb_pain.wav");
	precache_sound2 ("orb/orb_death.wav");
	//precache_sound2 ("weapons/rocket1i.wav")
	precache_sound2 ("weapons/spike2.wav");
	precache_sound2 ("weapons/grenade.wav");

	precache_sound("misc/power.wav");
	precache_sound ("weapons/lhit.wav");
	precache_sound ("weapons/lstart.wav");


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/oldone.mdl");

	if ((self.spawnflags & 128))
		setsize (self, '1 1 -24', '1 1 0');
	else
		//setsize (self, '-160 -128 -24', '160 128 256');
	setsize (self, '-128 -128 -24', '128 128 256');

	//self.health = 40000;		// kill by telefrag
	self.health = 12000;
	self.max_health = self.health;
	self.think = oldnew_idle1;
	self.nextthink = time + 0.1;	
	self.takedamage = DAMAGE_AIM;
	self.flags = FL_MONSTER;
	self.team = TEAM_MONSTERS;
	self.view_ofs = '0 0 24';
	self.th_pain = oldnew_pain;
	self.th_die = oldnew_finale_1;
	self.th_walk = SUB_Null;
	self.use = monster_use;
	self.th_run = oldnew_walk1;
	self.yaw_speed = 10;
	self.ideal_yaw = self.angles * '0 1 0';
	//shub = self;
	total_monsters++;
	WriteByte(MSG_ALL, SVC_UPDATESTAT);
	WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
	WriteLong(MSG_ALL, total_monsters);
};

void() spawn_spammer =
{
	local entity spammer;
	spammer = spawn();
	spammer.classname = "oldnew_child";
	setorigin(spammer, self.origin);
	//spammer.think = spammer_think;
	spammer.think = spammer_think;
	spammer.owner = self;
	if (self.enemy)
		spammer.enemy = self.enemy;
	else
		spammer.enemy = find(world, classname, "player");
	spammer.nextthink = time + 0.1;
}



void() spammer_think =
{
	if (self.owner)
		self.angles = self.owner.angles; 
	switch(self.count)
	{
		// GOD I SHOULD JUST DO A SPIRAL SINE WAVE
		case 0 :
			oldnew_spam_shot('0 0 0');
			break;
		case 1 :
			oldnew_spam_shot('0 1 0');
			break;
		case 2 :
			oldnew_spam_shot('0 -3 0');
			break;
		case 3 :
			oldnew_spam_shot('0 2 0');
			break;
		case 4 :
			oldnew_spam_shot('0 -2 0');
			break;
		case 5 :
			oldnew_spam_shot('0 3 0');
			break;
		case 6 :
			oldnew_spam_shot('0 -1 0');
			break;
		case 7 :
			oldnew_spam_shot('0 4 0');
			break;
		case 8 :
			oldnew_spam_shot('0 2 0');
			break;
		case 9 :
			oldnew_spam_shot('0 -1 0');
			break;
		case 10 :
			oldnew_spam_shot('0 -3 0');
			break;
		case 11 :
			oldnew_spam_shot('0 2 0');
			break;
		case 12 :
			oldnew_spam_shot('0 -4 0');
			break;
		default :
			remove(self);
			break;
	}
	self.nextthink = time + 0.1;
}

void(vector offset) oldnew_spam_shot =
{
	local vector vec;
	local float oomph, dist;
	vec = self.angles;
	vec_y += offset_y * 6;
	makevectors(vec);

	newmis = spawn();
	newmis.owner = self.owner;
	newmis.classname = "spam";
	setmodel(newmis, "progs/rogue/plasma.mdl");
	setorigin(newmis, self.origin + '0 0 50' + v_forward * 48);
	//setorigin(newmis, self.origin + '0 0 100' + v_forward * 32 * offset_x + v_right * 32 * offset_y + v_up * 32 * offset_z);
	setsize(newmis, '0 0 0', '0 0 0');
	newmis.touch = oldnew_spam_touch;
	//newmis.think = spam_solidify;
	newmis.effects (+) EF_CANDLELIGHT;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	newmis.solid = SOLID_BBOX;
	newmis.movetype = MOVETYPE_TOSS;

	vec = (self.enemy.origin - self.origin);
	dist = vlen(vec);
	oomph = dist * 0.8;
	if (oomph < 200)
		oomph = 200;
	/*
	if (dist < 250)
		oomph = 200;
	else if (dist < 480)
		oomph = 200;
	else if (dist < 700)
		oomph = 300;
	else
		oomph = 400;
	*/
	newmis.velocity = v_forward * (oomph + (25 * self.count)); // This works good, but needs more range if player is far away
	//newmis.velocity = v_forward * (300 + (25 * self.count)); // This works good, but needs more range if player is far away
	newmis.velocity_z = 200; // was 200;
	self.count++;
}

void() oldnew_spam_touch =
{
	if (other == self.owner)
		return;
	if (other == world)
	{
		self.velocity = '0 0 0';
		self.angles = '0 1 0' * 360 * random();
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_NOT;
		setmodel(self, "maps/bmodel/b_splash.bsp");
		self.touch = SUB_Null;

		self.think = oldnew_spam_think;
		self.nextthink = time + 2;
	}
	else
	{
		if (other.health)
		{
			T_Damage(other, self.owner, self, 10);
			remove(self);
		}
	}
};

void() oldnew_spam_think = 
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z + 500);

	self.think = oldnew_spam_think2;
	self.nextthink = time + 0.1;
}

void() oldnew_spam_think2 =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);

	T_RadiusDamage (self, self, 100, world);
	remove(self);
}
//============================================================================
void() oldnew_cleanup_zombies =
{
	local entity f;
	f = find(world, classname, "monster_szombie");
	if (f != world)
	{
		T_Damage(f, world, world, 500);
		self.nextthink = time + 0.2 + random() * 0.5;
	}
	else
	{
		self.nextthink= time + 1.5;
	}
}
//============================================================================
void() spawn_swiper =
{
	local entity swiper;
	swiper = spawn();
	swiper.classname = "oldnew_child";
	swiper.think = oldnew_swipe;
	swiper.nextthink = time + 0.025;
	swiper.count = 0;
	setorigin(swiper, self.origin);
	swiper.angles = self.angles; 
	swiper.owner = self;

	sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);

	swiper.aflag = self.aflag;
	self.aflag = !self.aflag;
}

void() oldnew_swipe =
{
	local float a;
	local vector ang;
	local vector org, org2;

	a = self.count / 50;
	a *= a; 
	if (!self.aflag)
	{
		a = -60 + (a * 180);
	}
	else
	{
		a = 60 + (a * -180);
	}

	ang = self.angles;
	ang_y += a; 
	makevectors(ang);

	org = self.origin + v_forward * 130;
	org2 = self.origin + v_forward * 1000;

	traceline(org, org2, FALSE, self);

	if (trace_ent && trace_ent.health)
	{
		if (trace_ent.classname == "monster_szombie")
			T_Damage(trace_ent, self.owner, self.owner, 100);
		else
			T_Damage(trace_ent, self.owner, self.owner, 25);
	}

	if (self.count % 2 == 0)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING3);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);

		//sound (self, CHAN_AUTO, "misc/power.wav", 1, ATTN_NORM); //Changed to CHAN_AUTO to allow more overlapping sounds
		
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}

	self.count++;
	if (self.count > 50)
		self.think = SUB_Remove;
	self.nextthink = time + 0.025;


}
//============================================================================
void() spawn_blaster =
{
	local entity blaster;
	local float i, offset;
	local vector org;
	i = 0;
	offset = 1;
	while (i < 2)
	{
		blaster = spawn();
		blaster.classname = "oldnew_child";
		makevectors(self.angles);
		org = self.origin + v_right * offset * 300 + v_up * 80 + v_forward * 200;
		setorigin(blaster, org);
		setmodel(blaster, "progs/teleporter_eye.mdl");
		blaster.solid = SOLID_SLIDEBOX;
		blaster.th_die = eye_die;
		blaster.th_run = blast;
		blaster.movetype = MOVETYPE_STEP;
		blaster.flags = FL_MONSTER | FL_FLY;
		setsize(blaster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		spawn_boss_tdeath(org, blaster);
		blaster.health = 120;
		blaster.takedamage = DAMAGE_AIM;

		total_monsters++;
		WriteByte(MSG_ALL, SVC_UPDATESTAT);
		WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
		WriteLong(MSG_ALL, total_monsters);
		

		
		
		blaster.owner = self;
		blaster.angles = self.angles;
		
		spawn_tfog(org);
		blaster.effects = EF_CANDLELIGHT;

		if (i == 0)
		{
			blaster.aflag = 1;
			//blaster.dmg = -1; 
			blaster.count = 0;
		}
		else
		{
			blaster.aflag = -1;
			//blaster.dmg = 1;
			blaster.count = 0;
		}

		blaster.dmg = offset * -1;
		//blaster.aflag = i;

		blaster.think = blast;
		blaster.nextthink = time + 2;

		offset *= -1;
		i++;
	}
};
//============================================================================
void() blast =
{
	local vector org, vec, cross;

	org = self.origin; 
	
	//if (self.count % 10 == 0)
		//max = 7;
	if (self.enemy && self.enemy.classname == "monster_oldone_new")
	{
		dprint("accidentally set itself as its enemy!\n");
		self.enemy = world;
	}
	if (!(self.enemy) || (self.enemy.classname != "player"))
	{
		self.enemy = find(world, classname, "player");
	}
	
	//dprint("cross of '0 0 1' and '1 0 0' is "); dprint(vtos(cross_product('0 0 1', '1 0 0'))); dprint("\n");


	vec = normalize(self.enemy.origin - self.origin);
	
	//makevectors(self.angles);
	cross = cross_product(vec, '0 0 1');
	vec = normalize(vec + (cos(self.count * 15)*0.5 *self.aflag * cross));
	self.angles = vectoangles(vec);
	//makevectors(self.angles + (sin(self.count * 10)*30 * self.aflag * '0 1 0') + ('0 1 0' * step * size));
	//makevectors(self.owner.angles + ('0 1 0' * step * size * self.aflag) + '0 1 0' * self.dmg);
	//org = self.origin + '0 0 0' + v_forward * 110;
	org = self.origin + vec * 8;
	launch_spike (org, vec);
	newmis.touch = blast_touch;
	newmis.owner = self;
	setmodel(newmis, "progs/rogue/sphere.mdl");
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	newmis.effects = EF_CANDLELIGHT;
	setsize(newmis, '0 0 0', '0 0 0');
	//newmis.think = blast_accel;
	//newmis.nextthink = time + 0.4;

	newmis.velocity = vec * 500;
	newmis.avelocity = '300 300 300' * crandom();

	self.nextthink = time + 0.2; 
	self.count++;

	if (self.count > 72)
	{
		T_Damage(self, world, world, 500);
		//spawn_tfog(self.origin);
		//remove(self);
	}
}

void() blast_touch =
{
	if (other == world)
	{
		remove(self);
		return;
	}
	if (other.classname == "sphere")
		return;
	if (other == self.owner)
		return;
	if (other.classname == "monster_oldone_new")
	{
		remove(self);
		return;
	}

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (other.health)
	{
		T_Damage(other, self, self.owner, 15);
		remove(self);
		return;
	}

	remove(self);
};


//============================================================================
vector (vector a, vector b) cross_product =
{
	local vector c;
	c_x = (a_y * b_z) - (a_z * b_y);
	c_y = (a_z * b_x) - (a_x * b_z);
	c_z = (a_x * b_y) - (a_y * b_x);
	return c;
}
//============================================================================
void() spawn_eye =
{
	local entity eye;
	eye = spawn();
	eye.classname = "oldnew_eye";
	spawn_tfog(self.origin + '0 0 300');
	setorigin(eye, self.origin + '0 0 300');
	setmodel(eye, "progs/teleporter_eye.mdl");
	setsize(eye, VEC_HULL2_MIN, VEC_HULL2_MAX);
	eye.solid = SOLID_SLIDEBOX;
	eye.movetype = MOVETYPE_FLY;
	
	eye.takedamage = DAMAGE_AIM;
	eye.think = eye_chase;
	eye.th_run = eye_chase;
	eye.nextthink = time + 0.1;
	eye.th_pain = eye_pain;
	eye.owner = self;
	eye.speed = 100;
	eye.health = 300;
	eye.th_die = eye_die;
	eye.touch = eye_touch;

	eye.enemy = find(world, classname, "player");
}

void() eye_chase =
{
	local vector v;
	self.speed = vlen(self.velocity);
	if (self.speed < 300)
		self.speed = self.speed + 10;

	v = normalize(self.enemy.origin - self.origin);
	self.velocity = v * 0.3 + normalize(self.velocity) * 0.7;
	if (self.origin_z < self.enemy.origin_z + 32)
	{
		self.velocity_z = 0;
		self.velocity = normalize(self.velocity);
	}

	self.angles = vectoangles(self.velocity);
	

	self.velocity*= self.speed;

	self.nextthink = time + 0.1;

	if (self.count % 2 == 0)
	{
		self.effects (+) EF_MUZZLEFLASH;
		sound(self, CHAN_VOICE, "misc/power.wav", 1, ATTN_NORM);
	}
	self.count++;
}

void(entity attacker, float take) eye_pain =
{
	local vector v;
	v = (self.origin - attacker.origin);
	v_z = 0;
	v = normalize(v);
	v = v * 0.8 + '0 0 .2';
	v = v*take*10; 
	dprint("pain!\n");
	self.velocity += v; 
}

void() eye_touch =
{
	if (other == world)
		return;
	if (other == self.owner)
		return;
	if (other.health)
		T_Damage(other, self, self.owner, 500);
}

void() eye_die =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);

	//T_RadiusDamage (self, self, 100, world);
	remove(self);
}
//============================================================================
void() spawn_vortex =
{
	local entity vortex;
	local vector org;
	vortex = spawn();
	vortex.classname = "oldnew_child";
	makevectors(self.angles);
	if (self.ammo_cells)
		org = self.origin + v_right * 300 + v_up * 80 + v_forward * 200;
	else
		org = self.origin + v_right * -1 * 300 + v_up * 80 + v_forward * 200;

	
	//org = self.origin + v_forward * 250 + '0 0 128';

	/*if (self.enemy && vlen(self.enemy.origin - org) < 300)
	{
		dprint("get a better spot!\n");
		if (random()>0.5)
			org = self.origin + v_right * 250 + '0 0 90';
		else
			org = self.origin + v_right * -250 + '0 0 90';
		org += v_forward * 100;
	}*/
	setorigin(vortex, org);
	vortex.owner = self;

	setmodel(vortex, "progs/teleporter_eye.mdl");
	vortex.solid = SOLID_SLIDEBOX;
	vortex.th_die = eye_die;
	
	vortex.movetype = MOVETYPE_STEP;
	vortex.flags = FL_MONSTER | FL_FLY;
	setsize(vortex, VEC_HULL2_MIN, VEC_HULL2_MAX);
	spawn_boss_tdeath(org, vortex);
	vortex.health = 120;
	vortex.takedamage = DAMAGE_AIM;

	total_monsters++;
	WriteByte(MSG_ALL, SVC_UPDATESTAT);
	WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
	WriteLong(MSG_ALL, total_monsters);
		
	vortex.owner = self;
	vortex.angles = self.angles;

	spawn_tfog(org);
	vortex.effects = EF_CANDLELIGHT;

	//vortex.think = vortex_think;
	vortex.th_run = vortex_think_alt;
	vortex.think = vortex_think_alt;
	vortex.nextthink = time + 2;
	vortex.count = 0;

	if (self.ammo_cells)
		vortex.aflag = 1;
	else
		vortex.aflag = -1;
	self.ammo_cells = 1 - self.ammo_cells;

	vortex.enemy = self.enemy;
}

void () vortex_think_alt =
{
	local vector org, vec, cross;

	org = self.origin; 
	
	//if (self.count % 10 == 0)
		//max = 7;
	if ((!self.enemy) || (self.enemy.classname != "player"))
	{
		self.enemy = find(world, classname, "player");
	}

	vec = normalize(self.enemy.origin - self.origin);
	
	//makevectors(self.angles);
	cross = cross_product(vec, '0 0 1');
	vec = normalize(vec + (cos(self.count * 15)*0.5 *self.aflag * cross));
	self.angles = vectoangles(vec);
	org = self.origin + vec * 8;
	launch_spike (org, vec);
	newmis.touch = blast_touch;
	newmis.owner = self;
	setmodel(newmis, "progs/rogue/sphere.mdl");
	//setmodel(newmis, "maps/bmodel/b_shot2.bsp");
	newmis.effects = EF_CANDLELIGHT;
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	setsize(newmis, '0 0 0', '0 0 0');
	//newmis.think = blast_accel;
	//newmis.nextthink = time + 0.4;

	newmis.velocity = vec * 500;
	newmis.avelocity = '300 300 300' * crandom();

	self.nextthink = time + 0.2; 
	self.count++;

	if (self.count > 72)
	{
		T_Damage(self, world, world, 500);
	}
}
//============================================================================

void() func_breakable =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.health = 10000;
	self.takedamage = DAMAGE_YES;
	self.th_pain = breakable_pain;
	self.th_die = SUB_Remove;

	setorigin (self, self.origin);	
	setmodel (self, self.model);
}

void(entity attacker, float take) breakable_pain =
{setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.health = 10000;
	self.velocity = '0 0 -20';
	self.think = breakable_stop;
	self.nextthink = self.ltime + 1;

}

void() breakable_stop =
{
	self.velocity = '0 0 0';
}
//============================================================================
void(float max) spawn_sphere_manager =
{
	local entity manager;
	local vector vec;
	local float d;
	manager = spawn();
	setorigin(manager, self.origin);
	//manager.aflag = 1;
	manager.owner = self;
	//manager.wait = 22.5;
	//manager.delay = 0.8;
	if (!self.enemy)
		self.enemy = find(world, classname, "player");
	vec = self.enemy.origin - self.origin;
	vec_z = 0;
	vec = normalize(vec); // our forward vector
	
	makevectors(self.angles);
	d = flat_dot(v_right, cross_product(vec, '0 0 1'));
	if (d > 1)
		manager.aflag = 1; // go clockwise
	else
		manager.aflag = 0;

	manager.angles = vectoangles(vec);

	manager.count = max;
	//manager.cnt = max;



	manager.think = actual_sphere;
	manager.nextthink = time + 0.1;
}

float(vector a, vector b) flat_dot =
{
	a_z = 0;
	b_z = 0;
	a = normalize(a);
	b = normalize(b);
	return (a * b);
}

void() spawn_sphere =
{
	local float num_points;
	local float step, radius;
	local float x, y;
	local vector org, vec;
	local vector exclude_vec, exclude_vec2;
	num_points = 45; // per row
	step = 8; //

	makevectors(self.angles);
	exclude_vec = v_forward;
	exclude_vec2 = v_right;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);

	if (!self.enemy)
		self.enemy = find(world, classname, "player");
	
		radius = 64;

	y = -1; // used for vertical offset
	while (y < 2)
	{
		x = 0;
		if (y == 0)
			num_points = 44;
		else
			num_points = 45;
		while (x < num_points)
		{
			makevectors(self.angles + '0 1 0' * x * step);
			if ((fabs(flat_dot(v_forward, exclude_vec)) < 0.9) && (fabs(flat_dot(v_forward, exclude_vec2)) < 0.9))
			{
				org = self.origin + v_forward * radius + (v_up * y * 16) + '0 0 24';
				vec = v_forward * 200;
				launch_spike(org, vec);
				newmis.owner = self.owner;
				//setmodel(newmis, "progs/rogue/sphere.mdl");
				//setmodel(newmis, "maps/bmodel/b_shot2.bsp");
				setmodel(newmis, "progs/diamond.mdl");
				newmis.touch = sphere_mis_touch;
				if ((y == -1) && (x % 2 == 0))
					newmis.effects = EF_CANDLELIGHT;
				setsize(newmis, '0 0 0', '0 0 0');
				newmis.velocity = normalize(newmis.velocity)*400;
				newmis.avelocity = '0 0 -100';
				//newmis.speed = 200;
			}

			x++;
		}
		self.angles_y += step/2;
		y++;

	}
	self.angles = self.angles + '0 1 0' * self.aflag * self.wait;
	self.nextthink = time + self.delay;
	self.count++;
	if (self.count > self.cnt)
	{
		if (self.owner.boss_immune)
			self.owner.boss_immune = 0;
		remove(self);

	}

}


void() sphere_mis_touch =
{
	if (other == self.owner)
		return;

	if (other.classname == "oldnew_child" || other.classname == "oldnew_eye" || other.classname == "monster_szombie")
	{
		remove(self);
		return;
	}

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
		T_Damage (other, self, self.owner, 18);
	}

	remove(self);
};
//============================================================================
void(float max) spawn_sphere_chunk_manager =
{
	local entity manager;
	manager = spawn();
	setorigin(manager, self.origin);
	manager.aflag = 1;
	manager.owner = self;
	manager.wait = 22.5;
	manager.delay = 0.8;
	manager.angles = self.angles;
	manager.count = 0;
	manager.cnt = max;
	if (self.enemy)
		manager.enemy = self.enemy;
	else	
		manager.enemy = find(world, classname, "player");

	manager.think = sphere_chunk;
	manager.nextthink = time + 0.1;
}

void() sphere_chunk =
{
	local float num_points;
	local float step, radius;
	local float x, y;
	local vector org, vec;
	local vector attack_vec;
	local vector exclude_vec, exclude_vec2;
	num_points = 45; // per row
	step = 8; //

	
	attack_vec = (self.enemy.origin - self.origin);
	attack_vec_z = 0;
	attack_vec = normalize(attack_vec);
	self.angles = vectoangles(attack_vec);

	makevectors(self.angles + '0 1 0' * 22.5);
	exclude_vec = v_forward;
	makevectors(self.angles + '0 1 0' * -22.5);
	exclude_vec2 = v_forward;

	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);

	radius = 64;

	y = -1; // used for vertical offset
	while (y < 1)
	{
		x = 0;
		while (x < num_points)
		{
			makevectors(self.angles + '0 1 0' * x * step);
			if ((flat_dot(v_forward, attack_vec) > 0.5) &&
				!((flat_dot(v_forward, exclude_vec) > 0.985) ||
				((flat_dot(v_forward, exclude_vec2) > 0.985))))
			{
				org = self.origin + v_forward * radius + (v_up * y * 16) + '0 0 8';
				vec = v_forward * 200;
				launch_spike(org, vec);
				newmis.owner = self.owner;
				newmis.touch = sphere_mis_touch;
				//setmodel(newmis, "progs/rogue/sphere.mdl");
				//setmodel(newmis, "maps/bmodel/b_shot2.bsp");
				setmodel(newmis, "progs/diamond.mdl");
				if ((y == 0) && (x % 2 == 0))
					newmis.effects = EF_CANDLELIGHT;
				setsize(newmis, '0 0 0', '0 0 0');
				newmis.velocity = normalize(newmis.velocity)*400;
				newmis.avelocity = '0 0 -100';
				//newmis.speed = 200;
			}

			x++;
		}
		self.angles_y += step/2;
		y++;

	}
	self.count++;
	if (self.count > self.cnt)
		remove(self);
}

//============================================================================
void(vector org, entity death_owner) spawn_boss_tdeath =
{
local entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_boss_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	
	force_retouch = 2;		// make sure even still objects get hit
};

void() tdeath_boss_touch =
{
	if (other == self.owner)
		return;

// frag anyone who teleports in on top of an invincible player
	if ((other.classname == "player") || (other.classname == "monster_oldone_new"))
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, 50000);
			return;
		}
		
	}

	if (other.health)
	{
		T_Damage (other, self, self, 50000);
	}
};

void(float b, float a, float c) oldnew_autogun_check =
{
	//self.boss_immune = 1;
	if (self.boss_immune)
		return;

	if (c > self.boss_phase + 2)
		return;
	
	if (skill == 0)
		return;
	if (c > skill + 1)
		return;

	makevectors(self.angles);
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	//if (a == 1)
	if (b == 1)
		auto_gun(self.origin + '0 0 80' + v_right * 64, a);
	else
		auto_gun(self.origin + '0 0 80' + v_right * -64, a);
}
void(vector org, float a) auto_gun =
{
	local vector vec;
	local entity p;
	p = find(world, classname, "player");

	vec = normalize(p.origin - org);
	if (a != 0)
		vec = (cross_product(vec, '0 0 1') * a) + vec * (1 - fabs(a));
	launch_spike(org, vec);
	newmis.owner = self;
	newmis.touch = sphere_mis_touch;
	if (a == 0)
		newmis.velocity = vec * 600;
	else
		newmis.velocity = vec * 800;
	setmodel(newmis, "progs/rogue/sphere.mdl");
	newmis.effects = EF_CANDLELIGHT;
	setsize(newmis, '0 0 0', '0 0 0');
}

void() actual_sphere =
{
	local float i;
	//local entity dot;
	local vector org, vec, vec2;
	local float off;
	i = 0;
	if (!self.enemy)
		self.enemy = find(world, classname, "player");
	//vec = normalize(self.enemy.origin - self.origin);
	
	makevectors(self.angles + '0 1 0' * off);
	vec = v_forward;

	while (i < 100)
	{
		org = get_org(i);
		vec2 = vec * 0.65 + normalize(org) * 0.35;

		launch_spike(self.origin + '0 0 32' + org * 32, vec2);
		newmis.owner = self.owner;
		newmis.touch = sphere_mis_touch;
		newmis.velocity = vec2 * 800;
		newmis.dmg = 18;
		setmodel(newmis, "progs/rogue/sphere.mdl");
		if (i % 5 == 0)
			newmis.effects = EF_CANDLELIGHT;
		setsize(newmis, '0 0 0', '0 0 0');

		i++;
	}

	self.count--;
	if (self.count > 0)
	{
		self.nextthink = time + 0.8;
		if (self.aflag)
			self.angles += '0 1 0' * 20;
		else
			self.angles += '0 1 0' * -20;



		//makevectors(self.angles);
		//if (flat_dot(normalize(self.enemy.velocity), v_right) > 0)
		//	self.angles += '0 1 0' * 20;
		//else
		//	self.angles += '0 1 0' * -20;
	}
	else
		remove(self);

	
}

vector(float index) get_org =
{
	switch (index)
	{
		case 1:	return '0.141 0.0 0.99';
		case 2: return '-0.179 -0.164 0.97';
		case 3: return '0.027 0.311 0.95';
		case 4: return '0.224 -0.292 0.93';
		case 5: return '-0.408 0.072 0.91';
		case 6: return '0.385 0.245 0.89';
		case 7: return '-0.128 -0.476 0.87';
		case 8: return '-0.243 0.467 0.85';
		case 9: return '0.524 -0.191 0.83';
		case 10: return '-0.542 -0.224 0.81';
		case 11: return '0.26 0.555 0.79';
		case 12: return '0.191 -0.609 0.77';
		case 13: return '-0.572 0.332 0.75';
		case 14: return '0.668 0.147 0.73';
		case 15: return '-0.405 -0.576 0.71';
		case 16: return '-0.093 0.718 0.69';
		case 17: return '0.568 -0.478 0.67';
		case 18: return '-0.759 -0.031 0.65';
		case 20: return '0.55 0.548 0.63';
		case 21: return '-0.037 -0.791 0.61';
		case 22: return '-0.517 0.62 0.59';
		case 23: return '0.814 -0.11 0.57';
		case 24: return '-0.686 -0.477 0.55';
		case 25: return '0.186 0.827 0.53';
		case 26: return '0.428 -0.746 0.51';
		case 27: return '-0.83 0.265 0.49';
		case 28: return '0.801 0.37 0.47';
		case 29: return '-0.345 -0.824 0.45';
		case 30: return '-0.306 0.85 0.43';
		case 31: return '0.807 -0.424 0.41';
		case 32: return '-0.89 -0.235 0.39';
		case 33: return '0.502 0.781 0.37';
		case 34: return '0.159 -0.923 0.35';
		case 35: return '-0.746 0.578 0.33';
		case 36: return '0.947 0.078 0.31';
		case 37: return '-0.65 -0.703 0.29';
		case 38: return '0.005 0.963 0.27';
		case 39: return '0.651 -0.717 0.25';
		case 40: return '-0.969 0.09 0.23';
		case 41: return '0.779 0.591 0.21';
		case 42: return '-0.176 -0.966 0.19';
		case 43: return '-0.525 0.834 0.17';
		case 44: return '0.954 -0.26 0.15';
		case 45: return '-0.882 -0.453 0.13';
		case 46: return '0.346 0.932 0.11';
		case 47: return '0.376 -0.922 0.09';
		case 48: return '-0.901 0.427 0.07';
		case 49: return '0.954 0.294 0.05';
		case 50: return '-0.505 -0.862 0.03';
		case 51: return '-0.21 0.978 0.01';
		case 52: return '0.815 -0.579 -0.01';
		case 53: return '-0.992 -0.124 -0.03';
		case 54: return '0.647 0.761 -0.05';
		case 55: return '0.036 -0.997 -0.07';
		case 56: return '-0.699 0.709 -0.09';
		case 57: return '0.993 -0.051 -0.11';
		case 58: return '-0.764 -0.632 -0.13';
		case 59: return '0.137 0.979 -0.15';
		case 60: return '0.559 -0.812 -0.17';
		case 61: return '-0.957 0.22 -0.19';
		case 62: return '0.851 0.482 -0.21';
		case 63: return '-0.3 -0.926 -0.23';
		case 64: return '-0.402 0.881 -0.25';
		case 65: return '0.886 -0.376 -0.27';
		case 66: return '-0.902 -0.32 -0.29';
		case 67: return '0.446 0.839 -0.31';
		case 68: return '0.236 -0.914 -0.33';
		case 69: return '-0.785 0.51 -0.35';
		case 70: return '0.916 0.153 -0.37';
		case 71: return '-0.567 -0.725 -0.39';
		case 72: return '-0.071 0.909 -0.41';
		case 73: return '0.66 -0.616 -0.43';
		case 74: return '-0.893 0.009 -0.45';
		case 75: return '0.657 0.599 -0.47';
		case 76: return '-0.085 -0.868 -0.49';
		case 77: return '-0.517 0.688 -0.51';
		case 78: return '0.834 -0.156 -0.53';
		case 79: return '-0.709 -0.441 -0.55';
		case 80: return '0.221 0.791 -0.57';
		case 81: return '0.365 -0.72 -0.59';
		case 82: return '-0.742 0.279 -0.61';
		case 83: return '0.721 0.289 -0.63';
		case 84: return '-0.329 -0.685 -0.65';
		case 85: return '-0.215 0.71 -0.67';
		case 86: return '0.623 -0.369 -0.69';
		case 87: return '-0.689 -0.144 -0.71';
		case 88: return '0.399 0.555 -0.73';
		case 89: return '0.079 -0.657 -0.75';
		case 90: return '-0.484 0.416 -0.77';
		case 91: return '0.613 0.019 -0.79';
		case 92: return '-0.42 -0.41 -0.81';
		case 93: return '0.031 0.557 -0.83';
		case 94: return '0.334 -0.408 -0.85';
		case 95: return '-0.488 0.071 -0.87';
		case 96: return '0.377 0.257 -0.89';
		case 97: return '-0.095 -0.404 -0.91';
		case 98: return '-0.18 0.321 -0.93';
		case 99: return '0.297 -0.098 -0.95';
		case 19: return '-0.222 -0.1 -0.97'; // oops
		case 0: return '0.056 0.13 -0.99';
		default :
			dprint("error!\n");
	}
}