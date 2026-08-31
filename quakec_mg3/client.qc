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


// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void(entity attacker, float damage) player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float	modelindex_eyes, modelindex_player;

const float NO_INTERMISSION = 1;

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

float	intermission_running;
float	intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
	if (RemovedRuneCheck()) return;
};


void intermission_clear_powerups(entity e)
{
	e.items (-) IT_QUAD | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT;
	e.super_damage_finished = 0;
	e.super_time = 0;
	e.invisible_finished = 0;
	e.invisible_time = 0;
	e.invincible_finished = 0;
	e.invincible_time = 0;
	e.radsuit_finished = 0;
	e.rad_time = 0;
}


float reset_flag;
 
void() SetChangeParms =
{
    if(reset_flag)
    {
        setspawnparms(self);
        return;
	}
	
	if (self.health <= 0 || deathmatch)
	{
		SetNewParms ();
		return;
	}

	if (world.worldtype == WORLDTYPE_HUB)
	{
		SetNewParms ();
		return;
	}

// remove items
	self.items = self.items - (self.items & 
	(IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	
	// cap super health
	if (self.health > self.max_health)
			self.health = self.max_health;
	if (self.health < self.max_health / 2)
			self.health = self.max_health / 2;
	// replenish ammo
	if (self.ammo_shells < 25)
	{
		self.ammo_shells = 25;
	}
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
};

void() SetNewParms =
{
	parm1 = IT_SHOTGUN | IT_AXE;
	/*
	if (skill == 3 && !deathmatch)
		parm2 = 50;
	else
		parm2 = 100;
	*/
	if (!deathmatch)
		parm2 = BASE_HEALTH;
	else
		parm2 = 100;
	
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
};

void() DecodeLevelParms =
{
	if (world.model == "maps/start.bsp" || world.worldtype == WORLDTYPE_HUB)
	{
		SetNewParms ();		// take away all stuff on starting new episode
	}

	// forcibly activate bloody nightmare if you load into boss2 on skill 3 through level select
	if ((world.model == "maps/boss2.bsp") && (skill == 3))
	{
		serverflags = serverflags | BLOODY_NIGHTMARE_ACTIVE | BLOODY_NIGHTMARE_DISCOVERED; 
	}

	self.items = parm1;
	if (serverflags & BLOODY_NIGHTMARE_ACTIVE)
	{
		if (skill != 3)
		{
			dprint("skill was changed. Remove serverflags & BLOODY_NIGHTMARE_ACTIVE\n");
			serverflags = serverflags - (serverflags & BLOODY_NIGHTMARE_ACTIVE);
		}
		else
		{
			dprint("Do 'bloody nightmare' item reset!\n");
			self.items = IT_SHOTGUN | IT_AXE;
			if (parm1 & IT_MJOLNIR)
				self.items = self.items | IT_MJOLNIR;
			if (parm15 & BLOODY_SSG)
				self.items = self.items | IT_SUPER_SHOTGUN;

			if (parm1 & IT_ARMOR3)
				self.items = self.items | IT_ARMOR3;
			else if (parm1 & IT_ARMOR2)
				self.items = self.items | IT_ARMOR2;
			else if (parm1 & IT_ARMOR1)
				self.items = self.items | IT_ARMOR1;

			parm1 = self.items;

			if (!(parm8 & (IT_AXE | IT_MJOLNIR | IT_SHOTGUN)))
				parm8 = IT_SHOTGUN;
		}
	}

	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
	
	// AY Nov1 2025, setting weapon maxes 
	//local float count;
	//count = parm
	if (!deathmatch)
	{
		self.max_health = GetCurrentUpgradedMaxValue(UpgradeType_Health, BASE_HEALTH);
		ammo_shells_max = GetCurrentUpgradedMaxValue(UpgradeType_Shells, BASE_SHELLS);
		ammo_nails_max = GetCurrentUpgradedMaxValue(UpgradeType_Nails, BASE_NAILS);
		ammo_rockets_max = GetCurrentUpgradedMaxValue (UpgradeType_Rockets, BASE_ROCKETS);
		ammo_cells_max = GetCurrentUpgradedMaxValue (UpgradeType_Cells, BASE_CELLS);
	}
	else // deathmatch values
	{
		self.max_health = 100;
		ammo_shells_max = 100;
		ammo_nails_max = 200;
		ammo_rockets_max = 100;
		ammo_cells_max = 200;
	}

	if(self.health > self.max_health)
	{
		self.health = self.max_health;
	}	
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
	return world;
};

string nextmap;
void() GotoNextMap =
{
	if (cvar("samelevel"))	// if samelevel is set, stay on same level
		changelevel (mapname);
	else
	{
		changelevel (nextmap);
	}
};


string intermissiontext;
void() ExitIntermission =
{
// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			if (!cvar("registered"))
			{
				intermissiontext = "$qc_finale_e1_shareware";
			}
			else
			{
				intermissiontext = "$qc_finale_e1";
			}
		}
		else if (world.model == "maps/e2m6.bsp")
		{
			intermissiontext = "$qc_finale_e2";
		}
		else if (world.model == "maps/e3m6.bsp")
		{
			intermissiontext = "$qc_finale_e3";
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			intermissiontext = "$qc_finale_e4";
		}
		else if (world.endtext)
		{
			intermissiontext = world.endtext;
		}

		if (intermissiontext)
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, intermissiontext);
			intermissiontext = string_null;
			return;
		}

		if ( nextmap == "start" && !coop)
		{
			localcmd("menu_credits\n");
			localcmd("disconnect\n");
		} 
		else 
		{
			GotoNextMap();
		}

	}
	
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		
		//if ( (serverflags & SIGIL_ALL) == SIGIL_ALL) 
		//{
		//	WriteByte (MSG_ALL, SVC_FINALE);
		//	WriteString (MSG_ALL, "$qc_mg1_endtext_all_runes");
		//	return;
		//}
		
	}

	if ( nextmap == "start" && !coop)
	{
		localcmd("menu_credits\n");
		localcmd("disconnect\n");
	} 
	else 
	{
		GotoNextMap();
	}
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	ExitIntermission ();
};

void() execute_changelevel =
{
	local entity	pos;

	intermission_running = 1;
	
// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		intermission_clear_powerups(other);
		setorigin (other, pos.origin);
		FogPushSettingsFrom(other, pos, 0);

		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);

	if (campaign && world.model == "maps/e5end.bsp")
 	{
 		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
 		WriteString(MSG_ALL, "ACH_COMPLETE_E5END");
 		if (skill == 3)
 		{
	 		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
	 		WriteString(MSG_ALL, "ACH_COMPLETE_E5END_NIGHTMARE"); 			
 		}
 	}
	else if (campaign && world.model == "maps/mgend.bsp")
 	{
 		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
 		WriteString(MSG_ALL, "ACH_COMPLETE_MGEND");
 		if (skill == 3)
 		{
	 		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
	 		WriteString(MSG_ALL, "ACH_COMPLETE_MGEND_NIGHTMARE"); 			
 		}
 	}

 	if (world.model == "maps/e5m6.bsp" && nextmap == "e5sm2")
 	{
 		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
 		WriteString(MSG_ALL, "ACH_FIND_E5M8"); 	
 	}
 	if (world.model == "maps/mge1m1.bsp" && nextmap == "mge1m3")
 	{
 		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
 		WriteString(MSG_ALL, "ACH_FIND_MGE1M3"); 	
 	}

	if ((world.model == "maps/hub.bsp") && (serverflags & BLOODY_NIGHTMARE_NEWGAME) && (serverflags & BLOODY_NIGHTMARE_ACTIVE) && (nextmap == "secret2"))
	{
		nextmap = "boss2";
	}

	if ((campaign && world.model == "maps/boss.bsp") && (nextmap == "start" || nextmap == "map1"))
	{
		WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
		WriteString(MSG_ALL, "ACH_COMPLETE_MG3"); 	
		if (skill == 3)
		{
			WriteByte (MSG_ALL, SVC_ACHIEVEMENT);
			WriteString(MSG_ALL, "ACH_COMPLETE_MG3_NIGHTMARE"); 	
		}
	}
	
	if(self.spawnflags & NO_INTERMISSION)
	{
		//Go directly to intermission text.
		ExitIntermission();
	}
};


void() changelevel_touch =
{
	if (other.classname != "player")
		return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		bprint("$qc_exited", other.netname);
	}
	
	nextmap = self.map;
	intermissiontext = self.endtext;

	if(world.model == "maps/mgend.bsp")
	{
		//Finished the whole pack, clear the runes. 
		serverflags = 0;
	}

	SUB_UseTargets ();

	if ( (self.spawnflags & NO_INTERMISSION) && (deathmatch == 0) && (self.endtext == string_null))
	{	
		GotoNextMap();
		return;
	}
	
	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void LoadGame()
{
	dprint("\n\nLoadGame: self.classname = ");
	dprint(self.classname);
	dprint("\n\n");

	//For each player...
	entity cl = find(world, classname, "player");
	while(cl)
	{
		if(cl.fog_density)
		{
			//Restore fog
			SetFog(cl, cl.fog_density, cl.fog_color, 0.0);
		}
		cl = find(cl, classname, "player");
	}
}

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	self.velocity = '0 0 0';
	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		//setspawnparms (self); // disabled for mg3, AY April 16, 2026
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// set default spawn parms
		SetNewParms ();
		// respawn		
		PutClientInServer ();
	}
	else
	{	// restart the entire server
		// put serverflags back to map's initial setting
		serverflags = startingserverflags;
		// request a reset to the parms
		reset_flag = TRUE;
		// "change" to the same level
		localcmd ("changelevel ");
		localcmd(mapname);
		localcmd("\n");
	}
};

void PlayerDie(); 
/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	bprint("$qc_suicides", self.netname);
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	self.frags = self.frags - 2;	// extra penalty
	respawn ();
};

float(vector v) CheckSpawnPoint =
{
	return FALSE;
};

/*
============
PlayerVisibleToSpawnPoint

Returns true if player can see this point
============
*/
float PlayerVisibleToSpawnPoint( entity point ) {
	local vector spot1, spot2;
	local entity player = find( world, classname, "player" );
	while ( player ) {
		if ( player.health > 0 ) {
			spot1 = point.origin + player.view_ofs;
			spot2 = player.origin + player.view_ofs;

			traceline( spot1, spot2, TRUE, point );
			if ( trace_fraction >= 1.0f ) {
				return TRUE;
			}
		}

		player = find( player, classname, "player" );
	}

	return FALSE;
}

float IDEAL_DIST_FROM_DM_SPAWN_POINT = 384;
float MIN_DIST_FROM_DM_SPAWN_POINT = 84;

float predicate_is_active_spawnpoint(entity e)
{
	return (e.state == COOP_SPAWN_ACTIVE);
}

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity SelectSpawnPoint(float forceSpawn) {
	local   entity spot, thing;
	local   float   numspots, totalspots;
	local   float   pcount;
	local entity spots;
	
	numspots = 0;
	totalspots = 0;

	// testinfo_player_start is only found in regioned levels
	spot = find( world, classname, "testplayerstart" );
	if ( spot )
		return spot;

   
    if ( coop ) {
		// choose a info_player_coop point that is active
		entity startedAt = lastspawn;
		lastspawn = find( lastspawn, classname, "info_player_coop" );
		while( lastspawn.state != COOP_SPAWN_ACTIVE ) {
			if ( lastspawn == startedAt ) {
				break;
			}
			lastspawn = find(lastspawn, classname, "info_player_coop");
		}

		if ( lastspawn != world ) {
			return lastspawn;
		}
	} else if ( deathmatch ) {

		// find all spots that don't have visible players nearby
		spots = world;
		spot = find( world, classname, "info_player_deathmatch" );       

		while( spot ) {
			totalspots = totalspots + 1;

			thing = findradius( spot.origin, IDEAL_DIST_FROM_DM_SPAWN_POINT );
			pcount = 0;               

			while( thing ) {
				if ( thing.classname == "player" && thing.health > 0 ) {
					pcount = pcount + 1;                      
				}

				thing = thing.chain;      
			}

			if ( pcount == 0 ) {
				if ( PlayerVisibleToSpawnPoint( spot ) ) {
					pcount = pcount + 1;
				}
			}

			if ( pcount == 0 ) { // good spot!
				spot.goalentity = spots;
				spots = spot;
				numspots = numspots + 1;
			}

			// Get the next spot in the chain
			spot = find( spot, classname, "info_player_deathmatch" );                
		}

		totalspots = totalspots - 1;

		// on small maps with few spawn points, our "ideal" spawn conditions may not be possible to meet
		// so fallback to just trying to pick a point without a player on top of it, so we don't start
		// a spawn frag loop
		if ( numspots == 0 ) {
			spot = find( world, classname, "info_player_deathmatch" );

			while( spot ) {
				thing = findradius( spot.origin, MIN_DIST_FROM_DM_SPAWN_POINT );
				pcount = 0;               

				while( thing ) {
					if ( thing.classname == "player" && thing.health > 0 ) {
						pcount = pcount + 1;                      
					}

					thing = thing.chain;      
				}

				if ( pcount == 0 ) { // good spot!
					spot.goalentity = spots;
					spots = spot;
					numspots = numspots + 1;
				}

				// Get the next spot in the chain
				spot = find( spot, classname, "info_player_deathmatch" );                
			}             
		}

		// uncomment to force a deferred spawn
		// if (forceSpawn == FALSE) return world;

		if ( !numspots ) {
			if (forceSpawn == FALSE) {
				return world;
			} 

			// no spots available so just pick one at random
			totalspots = rint( ( random() * totalspots ) );
			spot = find( world, classname, "info_player_deathmatch" );       

			while( totalspots > 0 ) {
				totalspots = totalspots - 1;
				spot = find( spot, classname, "info_player_deathmatch" );
			}
			return spot;
		}
		
		// Generate a random number between 1 and numspots
		numspots = numspots - 1;
	
		numspots = rint( ( random() * numspots ) );

		spot = spots;
		while( numspots > 0 ) {
			spot = spot.goalentity;
			numspots = numspots - 1;
		}
	
		return spot;
	}

	/*
	if (serverflags)
	{	// return with a rune to start
		float lastPickup = sigil_getLastPickup();
		if(lastPickup)
		{
			string spname = string_null;
			if(lastPickup & SIGIL_E1) spname = "start_1";
			else if(lastPickup & SIGIL_E2) spname = "start_2";
			else if(lastPickup & SIGIL_E3) spname = "start_3";
			else if(lastPickup & SIGIL_E4) spname = "start_4";
			else if(lastPickup & SIGIL_E5) spname = "start_5";
			else if(lastPickup & SIGIL_E6) spname = "start_6";
			if(spname)
			{
				spot = find (world, netname, spname);
				if(spot)
				{
					if(spot.classname == "info_player_start_hub")
					{
						sigil_clearLastPickup();
						return spot;
					}
				}
			}
		}
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
	*/
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};

/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;


void RunPostPutClientInServer() 
{
	entity oself = self;
	self = self.owner;
	entity spot = oself.enemy;
	

	// Fog settings sometimes (?) need to be set a frame after the client has spawned.
	// Not sure why, or why it sometimes works on the same frame.
	if(!FogPushSettingsFrom(self, spot, 0))
	{
		FogPushSettingsFrom(self, world, 0);
	}

	remove(oself);
}

void() PutClientInServer =
{
	local	entity spot;

	self.classname = "player";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	/* 
	if (skill == 3 && !deathmatch) // DOMA approach
		self.max_health = 50;
	else
		self.max_health = 100;
	*/

	self.max_health = BASE_HEALTH; // AY, Nov1 2025
	
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	if ( coop ) { 
		self.team = TEAM_HUMANS;
	}

	DecodeLevelParms ();
	
	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;


	local float shouldTelefrag;

	if (self.spawn_deferred > 0 && time >= self.spawn_deferred) {
		dprint("forcing telefrag on this spawn\n");
		shouldTelefrag = TRUE;
	} else {
		shouldTelefrag = FALSE;
	}
	spot = SelectSpawnPoint(shouldTelefrag);
	if (spot == world) {
		self.takedamage = DAMAGE_NO;
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;
		self.deadflag = DEAD_DEAD;
		setmodel(self, "");
		self.view_ofs = '0 0 1'; // not 0 because PlayerPreThink would return out
		self.velocity = '0 0 0';

		if (self.spawn_deferred == 0) {
			dprint("no spawns available! deferring\n");
			self.spawn_deferred = time + 5;
		}

		spot = FindIntermission();
		self.angles = self.v_angle = spot.mangle;
		self.fixangle = TRUE;
		self.origin = spot.origin;
		self.weaponmodel = "";
		self.weaponframe = 0;
		self.weapon = 0;

		return;
	}

	self.spawn_deferred = 0;
	
	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately


#ifdef COOP_RESPAWN_KEEP_WEAPONS
	if(coop)
	{ 
		// In coop we want to give back the players the weapons they progressed with
		self.items |= (spot.items & IT_ALL_WEAPONS);
		if(self.items & (IT_NAILGUN | IT_SUPER_NAILGUN)) self.ammo_nails = 30;
		if(self.items & (IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER)) self.ammo_rockets = 4;
		if(self.items & IT_LIGHTNING) self.ammo_cells = 12;

		W_SetCurrentAmmo (); // need to set ammo a second time in case we're running the above
	}
#endif
	

	// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

	player_stand1 ();

	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin, self);

	entity postSpawn = spawn();
	postSpawn.owner = self;
	postSpawn.enemy = spot;
	postSpawn.think = RunPostPutClientInServer;
	postSpawn.nextthink = time + 0.05;
    
    stuffcmd(self, "-attack\n"); // prevent shooting after respawning
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
	self.netname = "info_player_start"; // for bot nav support.
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
	self.netname = "info_player_start2"; // for bot nav support.
};

/*QUAKED info_player_start_hub (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start_hub =
{
};


/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
	if(!deathmatch) 
	{
		remove(self);
		return;
	}
	self.netname = "info_player_deathmatch"; // for bot nav support.
};

//////////////////////////////////////////////////////////////////////////

void trigger_activate_coop_spawns_use()
{
	float it = 0;

#ifdef COOP_RESPAWN_KEEP_WEAPONS
	entity p = find (world, classname, "player");
	while (p != world)
	{
		it |= p.items;
		p = find (p, classname, "player");
	}	
	it &= IT_ALL_WEAPONS;

	dprint("Activating coop spawn \"");
	dprint(self.target);
	dprint("\": Collected ");
	dprint(ftos(it));
	dprint(" from players.\n");
#endif

	entity s = find(world, classname, "info_player_coop");
	while(s)
	{
		if(s.targetname == self.target)
		{
			s.state = COOP_SPAWN_ACTIVE;
			s.items = it;
		}
		else
		{
			s.state = 0;
			s.items = 0;
		}
		s = find(s, classname, "info_player_coop");
	}
}

/*QUAKED trigger_activate_coop_spawns (1 0 1) (-8 -8 -8) (8 8 8)
Activates a set of coop spawnpoints.
*/
void trigger_activate_coop_spawns()
{
	if(!coop)
	{
		remove(self);
		return;
	}
	self.use = trigger_activate_coop_spawns_use;
}

const float COOP_SPAWN_START_ACTIVE = 1;
/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
	if(!coop)
	{
		remove(self);
		return;
	}
	self.netname = "info_player_coop"; // for bot nav support.
	if(!self.targetname) self.state = COOP_SPAWN_ACTIVE;
	if(self.spawnflags & COOP_SPAWN_START_ACTIVE) self.state = COOP_SPAWN_ACTIVE;
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
only called if a time or frag limit has expired
*/
void() NextLevel =
{
	local entity o;

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}

		o = spawn();
		o.map = mapname;
	}
	else if (world.model == "maps/mgdm1.bsp")
	{
		o = spawn();
		o.map = "mgdm2";
	}
	else if (world.model == "maps/mgdm2.bsp")
	{
		o = spawn();
		o.map = "mgdm3";
	}
	else if (world.model == "maps/mgdm3.bsp")
	{
		o = spawn();
		o.map = "mgdm4";
	}
	else if (world.model == "maps/mgdm4.bsp")
	{
		o = spawn();
		o.map = "mgdm1";
	}
	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");
	
		// Stay on same level if no changelevel is found
		if (!o)
		{
			o = spawn();
			o.map = mapname;
		}
	}
	
	nextmap = o.map;
	gameover = TRUE;
	
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{
	local	float		timelimit;
	local	float		fraglimit;
	
	if (gameover)	// someone else quit the game already
		return;
		
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	
	if (timelimit && time >= timelimit)
	{
		NextLevel ();
		return;
	}
	
	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel ();
		return;
	}	
};

//============================================================================

void() PlayerDeathThink =
{
	local float		forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

	if (self.spawn_deferred)
	{
		local entity spot;
		
		spot = SelectSpawnPoint(FALSE);
		//dprint("time {} >= self.spawn_deferred {}\n", ftos(time), ftos(self.spawn_deferred));
		if (spot != world || time >= self.spawn_deferred) {
			respawn();
		}

		return;
	}


// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	
	respawn();	
};


void() PlayerJump =
{
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
// player jumping sound
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};


/*
===========
WaterMove

============
*/
.float	dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		else if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{	
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.lavasuit_finished > time)
			{
				//dprint("don't take lava damage with lavasuit active!\n");
				// immune to damage!
			}
			else if (self.radsuit_finished > time)
			{
				self.dmgtime = time + 1;
				T_Damage (self, world, world, 10*self.waterlevel);
			}
			else
			{
				self.dmgtime = time + 0.2;
				T_Damage (self, world, world, 10*self.waterlevel);
			}
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && (self.radsuit_finished < time) && (self.lavasuit_finished < time)) // lava suit works with slime too
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{	

// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used

	CheckRules ();
	WaterMove ();

	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	if(time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE && self.weapon != IT_MJOLNIR)
	{
		// TODO: respawn flagged ammo by type because current weapon is depleted
		respawn_ammo(self.weapon);
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint(self, "$qc_ring_fade");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		
	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
		self.modelindex = modelindex_player;	// don't use eyes

// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, "$qc_protection_fade");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_PENTLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_PENTLIGHT);
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				sprint (self, "$qc_quad_fade");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_QUADLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_QUADLIGHT);
	}	

// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "$qc_biosuit_fade");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}
	
	// lava suit
	if (self.lavasuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.lavasuit_finished < time + 3)
		{
			if (self.lavasuit_time == 1)
			{
				sprint (self, "$mg3_qc_lavasuit_wearing_out");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.lavasuit_time = time + 1;
			}
			
			if (self.lavasuit_time < time)
			{
				self.lavasuit_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.lavasuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.lavasuit_time = 0;
			self.lavasuit_finished = 0;
		}
	}

};


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{

	if ((self.lore_active != -1) && (time > self.lore_active))
	{
		self.lore_active = -1;
		centerprint(self, "");
	}
	
	// CG: Squished by two special crusher doors?
	if(self.cnt >= 2)
	{
		T_Damage (self, door_block_entity, door_block_entity, door_block_entity.dmg);
	}
	self.cnt = 0;

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale
	if (self.deadflag)
		return;
		
// do weapon stuff

	W_WeaponFrame ();

	if ((self.weapon & IT_MJOLNIR) && (self.weaponmodel == "progs/v_hammer_glow.mdl"))
	{
		if (self.last_mjolnir_hit_time <= time)
			self.weaponmodel = "progs/v_hammer.mdl";
	}

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5); 
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;
		
	// AY Feb7 2026
	if (self.secrethunter)
		check_secrets();
	if (self.exithunter)
		check_exits();
	if (self.monsterhunter)
		check_monsters();
	// END AY Feb7 2026

	CheckPowerups ();
};

/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
	bprint("$qc_entered", self.netname);
	
	num_players++;

	// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving
	if (gameover)
	{
		return;
	}

	num_players--;
	
	// let everyone else know
	bprint("$qc_left_game", self.netname, ftos(self.frags));
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame ();
};

/*
===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	rnum = random();

	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint("$qc_telefragged", targ.netname, attacker.owner.netname);

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint("$qc_satans_power", targ.netname);

			targ.frags = targ.frags - 1;
			return;
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - 1;
				
				if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					if (targ.watertype == CONTENT_SLIME)
						bprint("$qc_discharge_slime", targ.netname);
					 
					else if (targ.watertype == CONTENT_LAVA)
						bprint("$qc_discharge_lava", targ.netname);
					 
					else
						bprint("$qc_discharge_water", targ.netname);

					return;
				}
				if (targ.weapon == IT_GRENADE_LAUNCHER)
				{
					bprint("$qc_suicide_pin", targ.netname);
				}
				else
				{
					bprint("$qc_suicide_bored", targ.netname);
				}
				return;
			}
			else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) )
			{
				if (rnum < 0.25)
					bprint("$qc_ff_teammate", attacker.netname);
				else if (rnum < 0.50)
					bprint("$qc_ff_glasses", attacker.netname);
				else if (rnum < 0.75)
					bprint("$qc_ff_otherteam", attacker.netname);
				else
					bprint("$qc_ff_friend", attacker.netname);
				attacker.frags = attacker.frags - 1;
				return;
			}
			else
			{
				attacker.frags = attacker.frags + 1;

				rnum = attacker.weapon;
				if (rnum == IT_AXE)
				{
					bprint("$qc_death_ax", targ.netname, attacker.netname);
					return;
				}
				if (rnum == IT_SHOTGUN)
				{
					bprint("$qc_death_sg", targ.netname, attacker.netname);
					return;
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
					bprint("$qc_death_dbl", targ.netname, attacker.netname);
					return;
				}
				if (rnum == IT_NAILGUN)
				{
					bprint("$qc_death_nail", targ.netname, attacker.netname);
					return;
				}
				if (rnum == IT_SUPER_NAILGUN)
				{
					bprint("$qc_death_sng", targ.netname, attacker.netname);
					return;
				}
				if (rnum == IT_GRENADE_LAUNCHER)
				{
					if (targ.health < -40)
					{
						bprint("$qc_death_gl1", targ.netname, attacker.netname);
						return;
					}
					else
					{
						bprint("$qc_death_gl2", targ.netname, attacker.netname);
						return;
					}
				}
				if (rnum == IT_ROCKET_LAUNCHER)
				{
					if (targ.health < -40)
					{
						bprint("$qc_death_rl2", targ.netname, attacker.netname);
						return;
					}
					else
					{
						bprint("$qc_death_rl3", targ.netname, attacker.netname);
						return;
					}
				}
				if (rnum == IT_LIGHTNING)
				{
					if (attacker.waterlevel > 1)
					{
						bprint("$qc_death_lg1", targ.netname, attacker.netname);
						if (attacker.invincible_finished)
						{
							msg_entity = attacker;
							WriteByte (MSG_ONE, SVC_ACHIEVEMENT);
							WriteString(MSG_ONE, "ACH_SURVIVE_DISCHARGE");
						}
					}
					else
						bprint("$qc_death_lg2", targ.netname, attacker.netname);
					return;
				}
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_army")
					bprint ("$qc_ks_grunt", targ.netname);
				if (attacker.classname == "monster_demon1")
					bprint ("$qc_ks_fiend", targ.netname);
				if (attacker.classname == "monster_dog")
				{
					if (attacker.aflag)
						bprint ("$mg3_qc_obit_demodog", targ.netname);
					else
						bprint ("$qc_ks_rottweiler", targ.netname);
				}
				if (attacker.classname == "monster_enforcer")
					bprint ("$qc_ks_enforcer", targ.netname);
				if (attacker.classname == "monster_fish")
					bprint ("$qc_ks_rotfish", targ.netname);
				if ((attacker.classname == "monster_hell_knight") || (attacker.classname == "monster_ranged_knight"))
					bprint ("$qc_ks_deathknight", targ.netname);
				if (attacker.classname == "monster_knight")
					bprint ("$qc_ks_knight", targ.netname);
				if (attacker.classname == "monster_ogre")
				{
					if (attacker.aflag)
						bprint("$mg3_qc_obit_rocketogre", targ.netname);
					else
						bprint ("$qc_ks_ogre", targ.netname);
				}
				if (attacker.classname == "monster_shalrath")
					bprint ("$qc_ks_vore", targ.netname);
				if (attacker.classname == "monster_shambler")
					bprint ("$qc_ks_shambler", targ.netname);
				if (attacker.classname == "monster_tarbaby")
				{
					if(attacker.aflag)
						bprint("$mg3_qc_obit_slime", targ.netname);
					else
						bprint ("$qc_ks_spawn", targ.netname);
				}
				if (attacker.classname == "monster_wizard")
					bprint ("$qc_ks_scrag", targ.netname);
				if (attacker.classname == "monster_zombie")
					bprint ("$qc_ks_zombie", targ.netname);
				if (attacker.classname == "monster_super_shambler")
					bprint("$mg3_qc_obit_supershambler", targ.netname);
				if (attacker.classname == "monster_lava_man")
					bprint("$mg3_qc_obit_lavaman", targ.netname);

				return;
			}

			// tricks and traps
			if (attacker.classname == "explo_box") 
			{
				
				bprint ("$qc_ks_blew_up", targ.netname);
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{	
				bprint ("$qc_death_squish", targ.netname);
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint ("$qc_ks_spiked", targ.netname);
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint ("$qc_ks_lavaball", targ.netname);
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint ("$qc_ks_tried_leave", targ.netname);
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint("$qc_death_drown1", targ.netname);
				else
					bprint("$qc_death_drown2", targ.netname);
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint("$qc_death_slime1", targ.netname);
				else
					bprint("$qc_death_slime2", targ.netname);
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint("$qc_death_lava1", targ.netname);
					return;
				}
				if (random() < 0.5)
					bprint("$qc_death_lava2", targ.netname);
				else
					bprint("$qc_death_lava3", targ.netname);
				return;
			}

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				bprint("$qc_death_fall", targ.netname);
				return;
			}

			// hell if I know; he's just dead!!!
			bprint("$qc_death_died", targ.netname);
		}
	}
};

// AY Feb 7 2026
void() check_secrets =
{
	local entity t, marker;
	local float f;
	local vector secretpos, markerpos;

	// first, cleanup existing secret markers
	cleanup_markers("secret_marker");

	// now find them again
	f = 0;
	t = find(world, classname, "trigger_secret");
	while (t)
	{
		secretpos = (t.absmin + t.absmax)/2; // get the midpoint
		marker = spawn();
		// trace line from player's view toward the midpoint, 
		traceline(self.origin + self.view_ofs, secretpos, TRUE, self);
		markerpos = trace_endpos - (normalize(secretpos - (self.origin + self.view_ofs)) * 4); 
		
		setmodel(marker, "progs/s_bubble.spr");
		setorigin (marker, markerpos);
		marker.classname = "secret_marker";
		f++;

		// get next 
		t = find(t, classname, "trigger_secret");
	}
	/*dprint("created ");
	dprint(ftos(f));
	dprint(" secret markers.\n");*/
};

void() check_exits =
{
	local entity t, marker;
	local float f;
	local vector exitpos, markerpos;

	// first, cleanup existing secret markers
	cleanup_markers("exit_marker");
	
	// now find them again
	f = 0;
	t = find(world, classname, "trigger_changelevel");
	while (t)
	{
		exitpos = (t.absmin + t.absmax)/2; // get the midpoint
		marker = spawn();
		// trace line from player's view toward the midpoint, 
		traceline(self.origin + self.view_ofs, exitpos, TRUE, self);
		markerpos = trace_endpos - (normalize(exitpos - (self.origin + self.view_ofs)) * 4); 
		
		//setmodel(marker, "progs/s_light.spr");
		setmodel(marker, "progs/s_bubble.spr");
		setorigin (marker, markerpos);
		marker.classname = "exit_marker";
		f++;

		// get next 
		t = find(t, classname, "trigger_changelevel");
	}
};
void(string marker_name) cleanup_markers =
{
	local entity marker;

	marker = find(world, classname, marker_name);
	while(marker)
	{
		remove(marker);
		marker = find(world, classname, marker_name);
	}
};

void() check_monsters =
{
    entity e = nextent(world);
    while(e)
    {
        if(e.flags & FL_MONSTER && e.health > 0)
        {
			draw_bounds( e.absmin, e.absmax, 251, 0, 0 );
        }
		else if (e.use == StartMonster)
			draw_bounds( e.origin - '16 16 16', e.origin + '16 16 16', 244, 0, 0);

        e = nextent(e);
    }
}

// AY, Feb 21 2026
// if the player runs out of ammo, look for all ammo pickups of that weapon type with the "safety respawn" spawnflag
void(float wep) respawn_ammo =
{
	local entity a;
	local string ammo_name;
	if ((wep == IT_AXE) || (wep == IT_MJOLNIR))
		return;
	else if ((wep == IT_SHOTGUN) || (wep == IT_SUPER_SHOTGUN))
		ammo_name = "item_shells";
	else if ((wep == IT_NAILGUN) || (wep == IT_SUPER_NAILGUN))
		ammo_name = "item_spikes";
	else if ((wep == IT_ROCKET_LAUNCHER) || (wep == IT_GRENADE_LAUNCHER))
		ammo_name = "item_rockets";
	else if ((wep == IT_LIGHTNING) || (wep == IT_LASER_CANNON))
		ammo_name = "item_cells";
	else
	{
		dprint("error! Could not find ammo type\n");
		return;
	}

	a = find (world, classname, ammo_name);
	while (a)
	{
		if ((a.spawnflags & SAFETY_RESPAWN) && a.solid == SOLID_NOT)
		{
			a.think = SUB_regen;
			a.nextthink = time + 0.5 * random();
		}
		a = find(a, classname, ammo_name);
	}
}

float SAFETY_RESPAWN = 8;

.float secrethunter; // cheat state for showing where all secrets are
.float exithunter; // cheat state for showing where all exits are
.float monsterhunter; // cheat state for showing where all monsters are
.float infiniteammo; // cheat state for making ammo costs free
.float buddha;  // cheat state for preventing player's health from hitting 0