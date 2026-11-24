
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <xs>
#include <fun>
#include <cstrike>

//#define USING_SANDALPHON // comment it if you want using belial

#define PLUGIN_NAME    "Sandalphon & belial"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR  "Mellowzy"

#define PrecacheSoundsFromModel 1

#if !defined SF_BREAK_TRIGGER_ONLY
	#define SF_BREAK_TRIGGER_ONLY	1
#endif
#if !defined DAMAGE_NO
	#define DAMAGE_NO				0
#endif

/*========================= CSW_Data ===================== */
#define CSW_REFERENCE		CSW_HEGRENADE
#define WEAPON_REFERENCE	"weapon_hegrenade"

/*========================= Weapon_Data ===================== */
#if defined USING_SANDALPHON
#define WEAPON_TXT			"weapon_divinetitan"		// sprites/weapon_divinetitan.txt
#define WEAPON_HOOK			"weapon_divinetitan"
#define PLAYERMODEL			"models/mellowzy/p_divinetitan.mdl"
#define VIEWMODEL			"models/mellowzy/v_divinetitan.mdl"
#define WORLDMODEL			"models/mellowzy/w_divinetitan.mdl"
#define R_MODEL				"models/mellowzy/divinetitan_missile.mdl"
#define A_MODE_MODEL		"models/mellowzy/ef_divinetitan_amode.mdl"
#define EF_MODEL			"models/mellowzy/ef_divinetitan_summon.mdl"

#define AIM_ON_SPR			"sprites/mellowzy/ef_divinetitan_aim_on.spr"
#define A_MODE_LASER		"sprites/mellowzy/ef_divinetitan_amode.spr"
#define A_MODE_HIT			"sprites/mellowzy/ef_divinetitan_amode_hit.spr"
#define B_MODE_BALLS		"sprites/mellowzy/ef_divinetitan_bmode_explo.spr"
#define B_MODE_EXP			"sprites/mellowzy/ef_divinetitan_bmode_explo.spr"

#define DIVINETITAN_ENT_SUMMONFX "sprites/mellowzy/ef_divinetitan_summon2.spr"
#define DIVINETITAN_SUMMONFX_SCALE		3.0
#define DIVINETITAN_SUMMONFX_FRAMES		60.0

#define WEAPON_640_A		"sprites/640hud61.spr"
#define WEAPON_640_B		"sprites/640hud220.spr"
#define WEAPON_GENERIC		"sprites/weapon_divinetitan.txt"

#define SND_SUMMON			"weapons/divinetitan_exp.wav"
#define SND_SUMMON_READY	"weapons/divinetitan_fx.wav"
#define SND_A_LASER			"weapons/divinetitan_A_mode-1_loop.wav"
#define SND_BALLS			"weapons/divinetitan_B_mode-2.wav"
#define SND_BALLS_EXP		"weapons/divinetitan_B_mode-2_exp.wav"
#endif

#if !defined USING_SANDALPHON
#define WEAPON_TXT			"weapon_divinetitanex"
#define WEAPON_HOOK			"weapon_divinetitanex"
#define PLAYERMODEL			"models/mellowzy/p_divinetitanex.mdl"
#define VIEWMODEL			"models/mellowzy/v_divinetitanex.mdl"
#define WORLDMODEL			"models/mellowzy/w_divinetitanex.mdl"
#define R_MODEL				"models/mellowzy/divinetitanex_missile.mdl"
#define A_MODE_MODEL		"models/mellowzy/ef_divinetitanex_amode.mdl"
#define EF_MODEL			"models/mellowzy/ef_divinetitanex_summon.mdl"

#define DIVINETITANEX_ENT_STORMFX "sprites/mellowzy/ef_divinetitanex_storm.spr"
#define DIVINETITANEX_ENT_GROUNDFX "sprites/mellowzy/ef_divinetitanex_ground.spr"
#define DIVINETITANEX_ENT_SUMMONFX "sprites/mellowzy/ef_divinetitanex_summon2.spr"

#define DIVINETITANEX_STORMFX_FRAMES		50.0
#define DIVINETITANEX_STORMFX_COUNT			20		// flat strips lying side by side on the circle (one layer)
#define DIVINETITANEX_STORMFX_SCALE			1.0		// 128 units wide, small strips follow the curve better
#define DIVINETITANEX_STORMFX_BANDOFFS		50.0		// the fire band sits 50 units (at scale 1.0) below the frame center, compensated so the band lands on the circle
#define DIVINETITANEX_STORMFX_RADIUS		0.5		// circle radius = DIVINETITAN_SUMMON_RANGE * this (225 units)
#define DIVINETITANEX_STORMFX_RENDERAMT		170.0	// lower than 255 because the overlapping additive sprites add up in brightness
#define DIVINETITANEX_SUMMONFX_FRAMES		60.0
#define DIVINETITANEX_SUMMONFX_SCALE		2.0		// 384 units wide, fits inside the storm circle

#define AIM_ON_SPR			"sprites/mellowzy/ef_divinetitanex_aim_on.spr"
#define A_MODE_LASER		"sprites/mellowzy/ef_divinetitanex_amode.spr"
#define A_MODE_HIT			"sprites/mellowzy/ef_divinetitanex_amode_hit.spr"
#define B_MODE_BALLS		"sprites/mellowzy/ef_divinetitan_bmode_explo.spr"
#define B_MODE_EXP			"sprites/mellowzy/ef_divinetitan_bmode_explo.spr"

#define WEAPON_640_A		"sprites/640hud61.spr"
#define WEAPON_640_B		"sprites/640hud243.spr"
#define WEAPON_GENERIC		"sprites/weapon_divinetitanex.txt"

#define SND_SUMMON			"weapons/divinetitanex_exp.wav"
#define SND_SUMMON_READY	"weapons/divinetitan_fx.wav"
#define SND_A_LASER			"weapons/divinetitan_A_mode-1_loop.wav"
#define SND_BALLS			"weapons/divinetitan_B_mode-2.wav"
#define SND_BALLS_EXP		"weapons/divinetitan_B_mode-2_exp.wav"
#endif
/*========================= Weapon_Tunables ===================== */
#define WEAPON_COMMANDS		"give_weapons_divinetitan"

#define LASER_RANGE			350.0
#define LASER_MAX_TARGETS	1		// max enemies locked at the same time by the A mode
#define BALLS_RANGE			180.0	// balls explosion damage radius

#define MAX_AMMO			100		// max backpack ammo (energy gauge)
#define AMMO_REFILL_TIME	0.2
#define AMMO_CONSUME_TIME	0.3
#define AMMO_REFILL_AMOUNT	1
#define AMMO_CONSUME_AMOUNT	5

#define HITCOUNT_MAX		10		// consume ticks needed to charge the missile

#define LASER_INTERVAL		0.3		// A mode: time between two lasers
#define LASER_SOUND_TIME	2.6		// A mode: the wav is 2.69s and has no loop marker, it is restarted a little before its end
#define BALLS_INTERVAL		1.0		// B mode: time between two balls

#define TIME_TRANSITION_IDLE	1.2	// value for m_flTimeWeaponIdle after a state change
#define TIME_TRANSITION_ATTACK	0.5	// value for next primary/secondary attack after a state change
#define TIME_DRAW				1.0	// draw animation length
#define IDLE_REPEAT_TIME		20.0	// the idle animation is not re-sent before this time
#define MISSILE_THROW_TIME		0.5	// ANIM_THROW length, then ANIM_DRAW_DEFAULT is played

/*========================= Weapon list / ammo ===================== */
#define PRIMARY_AMMO_TYPE		12	// HEGrenade ammo index (used as bpammo)
#define SECONDARY_AMMO_TYPE		15	// custom ammo index, unused by CS (used as "missile ready", max 1)
#define SECONDARY_AMMO_MAX		1
#define WEAPON_SLOT				3	// slot 4
#define WEAPON_POSITION			1
#define WEAPON_ITEM_FLAGS		13	// SELECTONEMPTY(1) | NOAUTOSWITCHEMPTY(4) | LIMITINWORLD(8)

/*========================= Entities ===================== */
#define DIVINETITAN_ENT_CLASSNAME 			"divinetitan_ent"
#define DIVINETITAN_ENT_HIT_CLASSNAME		"divinetitan_hit"
#define DIVINETITAN_AREA_CLASSNAME 			"divinetitan_area"
#define DIVINETITAN_SUMMON_CLASSNAME		"divinetitan_summon"
#define DIVINETITAN_MISSILE_CLASSNAME		"divinetitan_missile"
#define DIVINETITAN_BALLS_CLASSNAME			"divinetitan_balls"
#define DIVINETITAN_AIM_ON_CLASSNAME		"divinetitan_aim_on"
#define DIVINETITAN_ENT_SUMMONFX_CLASSNAME	"divinetitan_summonfx"

#define DIVINETITANEX_ENT_STORMFX_CLASSNAME	"divinetitanex_stormfx"
#define DIVINETITANEX_ENT_GROUNDFX_CLASSNAME	"divinetitanex_groundfx"
#define DIVINETITANEX_ENT_SUMMONFX_CLASSNAME	"divinetitanex_summonfx"

#define DIVINETITAN_ENT_HIT_FRAMEMAX		4.0
#define DIVINETITAN_ENT_HIT_RENDERMODE		kRenderTransAdd
#define DIVINETITAN_ENT_HIT_RENDERAMT		255.0
#define DIVINETITAN_ENT_HIT_SCALE			1.0
#define DIVINETITAN_ENT_HIT_RADIUS			350.0	// enemies inside this radius around the hit entity are hit too
#define DIVINETITAN_ENT_HIT_FRAMERATE		10.0	// sprite frames per second
#define DIVINETITAN_ENT_HIT_KEEPTIME		0.6		// the hit entity is removed when the laser did not refresh it for this time

#define DIVINETITAN_ENT_HEAD_OFFSET			50.0	// above the head when standing (ducking: -18.0)

#define DIVINETITAN_AREA_SEQUENCE			0
#define DIVINETITAN_AREA_RENDERMODE			kRenderTransAdd
#define DIVINETITAN_AREA_RENDERAMT			255.0
#define DIVINETITAN_AREA_SCALE_MULT			1.0		// extra size multiplier of the area effect (1.0 = ring exactly at LASER_RANGE)
#define DIVINETITAN_AIM_ON_SCALE			0.03	// size of the aim on indicator
#define DIVINETITAN_AREA_SCALE				1.0

#define DIVINETITAN_BALLS_FRAME				3.0
#define DIVINETITAN_BALLS_FRAMERATE			5.0
#define DIVINETITAN_BALLS_SPEED				4096.0

#if defined USING_SANDALPHON
#define DIVINETITAN_SUMMON_SEQUENCE			0
#define DIVINETITAN_SUMMON_RENDERMODE		kRenderTransAdd
#define DIVINETITAN_SUMMON_RENDERAMT		255.0
#define DIVINETITAN_SUMMON_REMOVETIME		2.5
#define DIVINETITAN_SUMMON_DAMAGE_INTERVAL	0.5		// time between two damage ticks of the summon
#define DIVINETITAN_SUMMON_RANGE			450.0	// enemies inside this range are pulled to the center of the summon
#define DIVINETITAN_SUMMON_PULL_SPEED		750.0	// pull speed (units per second)
#define DIVINETITAN_SUMMON_HOLD_RADIUS		40.0	// closer than this to the center the victim is held in place
#endif

#if !defined USING_SANDALPHON
#define DIVINETITAN_SUMMON_SEQUENCE			0
#define DIVINETITAN_SUMMON_RENDERMODE		kRenderTransAdd
#define DIVINETITAN_SUMMON_RENDERAMT		255.0
#define DIVINETITAN_SUMMON_REMOVETIME		1.8
#define DIVINETITAN_SUMMON_DAMAGE_INTERVAL	0.5		// time between two damage ticks of the summon
#define DIVINETITAN_SUMMON_RANGE			450.0	// enemies inside this range are pulled to the center of the summon
#define DIVINETITAN_SUMMON_PULL_SPEED		750.0	// pull speed (units per second)
#define DIVINETITAN_SUMMON_HOLD_RADIUS		40.0	// closer than this to the center the victim is held in place
#endif

// TE_EXPLOSION flags: 1 = no additive, 2 = no dlight, 4 = no sound, 8 = no particles
#define EXPLOSION_FLAGS_QUIET				(2|4|8)
#define EXPLOSION_FLAGS_NOSOUND				(4|8)

/* ========================== Offset_and_macro's ============================  */
#define linux_diff_weapon						4
#define linux_diff_player						5

#define m_pPlayer								41
#define m_pNext									42
#define m_Weapon_flNextPrimaryAttack			46
#define m_Weapon_flNextSecondaryAttack			47
#define m_Weapon_flTimeWeaponIdle				48
#define m_Weapon_iPrimaryAmmoType				49
#define m_Weapon_iSecondaryAmmoType				50
#define m_Weapon_iClip							51
#define m_Weapon_fInReload						54
#define m_Weapon_flAccuracy						62
#define m_flNextAttack							83
#define m_rgpPlayerItems_slot0					367
#define m_pActiveItem							373
#define m_rgAmmo								376
#define SVC_WEAPONANIM_ID						35

// NOTE: no space is allowed between the macro name and (%1,%2)
#define Get_BitVar(%1,%2)						(%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2)						%1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2)						%1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) 							(pev_valid(%0) == 2)

#define GetPrimaryAmmo(%0)       				get_pdata_int(%0, m_rgAmmo + PRIMARY_AMMO_TYPE, linux_diff_player)
#define GetSecondaryAmmo(%0)       				get_pdata_int(%0, m_rgAmmo + SECONDARY_AMMO_TYPE, linux_diff_player)
#define HIDEHUD_MONEY  							(1<<5)
#define SET_CUSTOM_HUD 							(HIDEHUD_MONEY)
#define RESET_HUD      							0

/* =============================================================================  */
/*========================= Var's ===================== */
new g_ActiveWpn, g_SummonReady
new DivineTitanMode[33], DivineTitanHitC[33]
new g_iLaser
new g_MaxPlayers, g_iMsgWeaponList, g_iMsgAmmoX
new cvar_damage_laser, cvar_damage_exp, cvar_damage_summon, cvar_damage_summon_slam
new cvar_slow_time, cvar_slow_speed

new Float:g_flSlowEnd[33]		// the victim is slowed until this time
new bool:g_bSlowed[33]

new Float:g_flNextAmmoTime[33]	// next bpammo consume/refill tick
new Float:g_flNextAction[33]	// next time a mode switch / missile is allowed
new Float:g_flNextIdle[33]		// next time the idle animation may be sent
new Float:g_flDrawTime[33]		// time to play ANIM_DRAW_DEFAULT after the missile throw (0.0 = none)
new g_iOldButtons[33]			// own copy of the buttons, used for press detection
new bool:g_bFakeAmmo[33]		// bpammo is temporarily 1 during Holster (see Holster_Pre)

enum
{
	STATE_NONE = 0,
	STATE_A,
	STATE_B
}

enum
{
	ANIM_IDLE_DEFAULT = 0,
	ANIM_PULLPIN = 1,
	ANIM_IDLE_PULPIN = 2,
	ANIM_THROW = 3,
	ANIM_DRAW_DEFAULT = 4,
	ANIM_DEFAULT_TO_A_MODE = 5,
	ANIM_IDLE_A_MODE = 6,
	ANIM_A_MODE_TO_DEFAULT = 7,
	ANIM_DRAW_A_MODE = 8,
	ANIM_A_MODE_TO_B_MODE = 9,
	ANIM_IDLE_B_MODE = 10,
	ANIM_MODE_B_TO_DEFAULT = 11,
	ANIM_DRAW_B_MODE = 12,
	ANIM_B_MODE_TO_A_MODE = 13,
	ANIM_DEFAULT_TO_B_MODE = 14
}

/*========================= Init ===================== */
public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	
	g_MaxPlayers = get_maxplayers()
	g_iMsgWeaponList = get_user_msgid("WeaponList")
	g_iMsgAmmoX = get_user_msgid("AmmoX")
	
	//fakemeta
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", true)
	register_forward(FM_Think, "fw_Entity_Think")
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink")
	register_forward(FM_Touch, "fw_Entity_Touch")
	
	RegisterHam(Ham_Item_Deploy, WEAPON_REFERENCE, "Ham_CWeapon_Deploy_Post", true)
	RegisterHam(Ham_Item_CanDeploy, WEAPON_REFERENCE, "Ham_CWeapon_CanDeploy_Pre")
	RegisterHam(Ham_Item_AddToPlayer, WEAPON_REFERENCE, "Ham_CWeapon_AddToPlayer_Post", true)
	RegisterHam(Ham_Item_Holster, WEAPON_REFERENCE, "Ham_CWeapon_Holster_Pre")
	RegisterHam(Ham_Item_Holster, WEAPON_REFERENCE, "Ham_CWeapon_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame, WEAPON_REFERENCE, "Ham_CWeapon_PostFrame_Pre")
	RegisterHam(Ham_Weapon_WeaponIdle, WEAPON_REFERENCE, "Ham_CWeapon_Idle_Pre")
	
	RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_BlockAttack_Pre")
	RegisterHam(Ham_Weapon_SecondaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_BlockAttack_Pre")
	
	RegisterHam(Ham_Spawn, "player", "fw_Spawn_Post", true)
	RegisterHam(Ham_Killed, "player", "fw_Killed_Post", true)
	
	register_clcmd(WEAPON_COMMANDS, "CSOWPN_Give", ADMIN_IMMUNITY)
	register_clcmd(WEAPON_HOOK, "CSOWPN_Hook")
	
	cvar_damage_laser = register_cvar("sandalphon_damage_laser", "25.0")
	cvar_damage_exp = register_cvar("sandalphon_damage_exp", "80.0")
	cvar_damage_summon = register_cvar("sandalphon_damage_summon", "50.0")
	cvar_damage_summon_slam = register_cvar("sandalphon_damage_summon_slam", "250.0")
	
	// Every damage of the weapon slows the enemy down for a short time
	cvar_slow_time = register_cvar("sandalphon_slow_time", "2.0")		// slow duration in seconds, refreshed by every damage (0 = no slow)
	cvar_slow_speed = register_cvar("sandalphon_slow_speed", "0.5")	// speed multiplier while slowed (0.5 = half speed)
}
/*========================= Precache ===================== */
public plugin_precache()
{
	util_precache_model(PLAYERMODEL)
	util_precache_model(VIEWMODEL)
	util_precache_model(WORLDMODEL)
	util_precache_model(R_MODEL)
	util_precache_model(A_MODE_MODEL)
	util_precache_model(EF_MODEL)
	
	util_precache_model(WEAPON_640_A)
	util_precache_model(WEAPON_640_B)
	util_precache_model(B_MODE_BALLS)
	util_precache_model(AIM_ON_SPR)

#if defined USING_SANDALPHON	
	util_precache_model(DIVINETITAN_ENT_SUMMONFX)
#endif

#if !defined USING_SANDALPHON
	util_precache_model(DIVINETITANEX_ENT_GROUNDFX)
	util_precache_model(DIVINETITANEX_ENT_STORMFX)
	util_precache_model(DIVINETITANEX_ENT_SUMMONFX)
#endif
	
	util_precache_sound(SND_SUMMON)
	util_precache_sound(SND_SUMMON_READY)
	util_precache_sound(SND_A_LASER)
	util_precache_model(A_MODE_HIT)
	util_precache_sound(SND_BALLS)
	util_precache_sound(SND_BALLS_EXP)
	
	util_precache_sounds_from_model(VIEWMODEL)
	
	precache_generic(WEAPON_GENERIC)
	
	g_iLaser = engfunc(EngFunc_PrecacheModel, A_MODE_LASER)
}

public client_disconnected(id)
{
	CWeapon_Reset(id)
	Slow_Reset(id)
}

/*========================= Commands ===================== */
public CSOWPN_Give(id)
{
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	
	CWeapon_Reset(id)
	
	Set_BitVar(g_ActiveWpn, id)
	UnSet_BitVar(g_SummonReady, id)
	fm_give_item(id, WEAPON_REFERENCE)
	
	DivineTitanMode[id] = STATE_NONE
	DivineTitanHitC[id] = 0
	
	g_flNextAmmoTime[id] = get_gametime() + AMMO_REFILL_TIME
	g_flNextAction[id] = 0.0
	g_flNextIdle[id] = 0.0
	g_iOldButtons[id] = 0
	
	UTIL_SetAmmo(id, PRIMARY_AMMO_TYPE, 50)
	UTIL_SetAmmo(id, SECONDARY_AMMO_TYPE, 0)
	
	UTIL_WeaponList(id, true)
	
	return PLUGIN_HANDLED
}

public CSOWPN_Remove(id)
{
	CWeapon_Reset(id)
}

public CSOWPN_Hook(id)
{
	engclient_cmd(id, WEAPON_REFERENCE)
	return PLUGIN_HANDLED
}

CWeapon_Reset(id)
{
	UnSet_BitVar(g_ActiveWpn, id)
	UnSet_BitVar(g_SummonReady, id)
	
	DivineTitanMode[id] = STATE_NONE
	DivineTitanHitC[id] = 0
	g_bFakeAmmo[id] = false
	g_iOldButtons[id] = 0
	
	g_flDrawTime[id] = 0.0
	
	Remove_Ent_Sandalphone(id)
	Remove_Ent_Area_Sandalphone(id)
	Remove_Ent_AimOn(id)
}

public fw_Spawn_Post(id)
{
	if(!is_user_alive(id)) return
	
	Slow_Reset(id)
	
	if(Get_BitVar(g_ActiveWpn, id) && !user_has_weapon(id, CSW_REFERENCE))
		CSOWPN_Remove(id)
}

public fw_Killed_Post(id)
{
	CSOWPN_Remove(id)
	Slow_Reset(id)
}

public Event_CurWeapon(id)
{
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id))
		return
	
	if(read_data(2) != CSW_REFERENCE)
		return
	
	set_pev(id, pev_viewmodel2, VIEWMODEL)
	set_pev(id, pev_weaponmodel2, PLAYERMODEL)
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED

	if(get_user_weapon(id) == CSW_REFERENCE && Get_BitVar(g_ActiveWpn, id))
	{
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001)
		return FMRES_HANDLED
	}

	return FMRES_IGNORED
}

/*========================= System Weapon =====================*/
GetWeaponOwner(ent)
{
	if(!IsValidPev(ent))
		return 0
	
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!(1 <= id <= g_MaxPlayers) || !Get_BitVar(g_ActiveWpn, id))
		return 0
	
	return id
}

CWeapon_SetTime(id, ent)
{
	new Float:flGameTime = get_gametime()
	
	g_flNextAction[id] = flGameTime + TIME_TRANSITION_ATTACK
	g_flNextIdle[id] = flGameTime + TIME_TRANSITION_IDLE
	
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, TIME_TRANSITION_IDLE, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, TIME_TRANSITION_ATTACK, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, TIME_TRANSITION_ATTACK, linux_diff_weapon)
}

CWeapon_PlayIdle(id)
{
	switch(DivineTitanMode[id])
	{
		case STATE_NONE: util_sendweaponanim(id, ANIM_IDLE_DEFAULT)
		case STATE_A: util_sendweaponanim(id, ANIM_IDLE_A_MODE)
		case STATE_B: util_sendweaponanim(id, ANIM_IDLE_B_MODE)
	}
	
	g_flNextIdle[id] = get_gametime() + IDLE_REPEAT_TIME
}

public Ham_CWeapon_Deploy_Post(ent)
{
	new id = GetWeaponOwner(ent)
	if(!id) return
	
	set_pev(id, pev_viewmodel2, VIEWMODEL)
	set_pev(id, pev_weaponmodel2, PLAYERMODEL)
	
	if(Get_BitVar(g_SummonReady, id))
		do_Sandalphon_AimOn(id)
	
	g_flDrawTime[id] = 0.0
	
	switch(DivineTitanMode[id])
	{
		case STATE_NONE: util_sendweaponanim(id, ANIM_DRAW_DEFAULT)
		case STATE_A: util_sendweaponanim(id, ANIM_DRAW_A_MODE)
		case STATE_B: util_sendweaponanim(id, ANIM_DRAW_B_MODE)
	}
	
	new Float:flGameTime = get_gametime()
	g_flNextAction[id] = flGameTime + TIME_DRAW
	g_flNextIdle[id] = flGameTime + TIME_DRAW
	g_flNextAmmoTime[id] = flGameTime + AMMO_REFILL_TIME
	
	// A button that is already held while deploying must not trigger anything
	g_iOldButtons[id] = pev(id, pev_button)
}

// CHEGrenade::CanDeploy fails when the grenade ammo is 0, which is our normal start state
public Ham_CWeapon_CanDeploy_Pre(ent)
{
	if(!GetWeaponOwner(ent))
		return HAM_IGNORED
	
	SetHamReturnInteger(1)
	return HAM_SUPERCEDE
}

public Ham_CWeapon_AddToPlayer_Post(ent, id)
{
	if(!IsValidPev(ent))
		return
	
	if(!(1 <= id <= g_MaxPlayers) || !Get_BitVar(g_ActiveWpn, id))
		return
	
	UTIL_WeaponList(id, true)
}

public Ham_CWeapon_Holster_Pre(ent)
{
	new id = GetWeaponOwner(ent)
	if(!id) return HAM_IGNORED
	
	if(GetPrimaryAmmo(id) <= 0)
	{
		set_pdata_int(id, m_rgAmmo + PRIMARY_AMMO_TYPE, 1, linux_diff_player)
		g_bFakeAmmo[id] = true
	}
	
	return HAM_IGNORED
}

public Ham_CWeapon_Holster_Post(ent)
{
	new id = GetWeaponOwner(ent)
	if(!id) return
	
	// Ammo ticks are paused while holstered (the timer is also restarted on deploy)
	g_flNextAmmoTime[id] = get_gametime() + AMMO_REFILL_TIME
	
	if(g_bFakeAmmo[id])
	{
		set_pdata_int(id, m_rgAmmo + PRIMARY_AMMO_TYPE, 0, linux_diff_player)
		g_bFakeAmmo[id] = false
	}
}

public Ham_CWeapon_BlockAttack_Pre(ent)
{
	if(!GetWeaponOwner(ent))
		return HAM_IGNORED
	
	return HAM_SUPERCEDE
}

public Ham_CWeapon_Idle_Pre(ent)
{
	new id = GetWeaponOwner(ent)
	if(!id) return HAM_IGNORED
	
	if(get_gametime() >= g_flNextIdle[id])
		CWeapon_PlayIdle(id)
	
	return HAM_SUPERCEDE
}

public Ham_CWeapon_PostFrame_Pre(ent)
{
	new id = GetWeaponOwner(ent)
	if(!id || !is_user_alive(id))
		return HAM_IGNORED
	
	// PostFrame can also run for a weapon that is in the inventory but not in the hand (holstered):
	// no ammo consume / refill, no hit count and no input handling in that case
	if(get_pdata_cbase(id, m_pActiveItem, linux_diff_player) != ent)
		return HAM_IGNORED
	
	new Float:flGameTime = get_gametime()
	new iButton = pev(id, pev_button)
	new iPressed = iButton & ~g_iOldButtons[id]
	g_iOldButtons[id] = iButton
	
	new iAmmo = GetPrimaryAmmo(id)
	
	// Energy is empty while a mode is active: back to the default state
	if(iAmmo <= 0 && DivineTitanMode[id] != STATE_NONE)
	{
		util_sendweaponanim(id, ANIM_DRAW_DEFAULT)
		DivineTitanMode[id] = STATE_NONE
		
		Remove_Ent_Sandalphone(id)
		Remove_Ent_Area_Sandalphone(id)
		
		CWeapon_SetTime(id, ent)
		return HAM_SUPERCEDE
	}
	
	if(flGameTime >= g_flNextAmmoTime[id])
	{
		if(DivineTitanMode[id] != STATE_NONE)
		{
			// bpammo consume
			if(DivineTitanMode[id] != STATE_B)iAmmo -= 1
			else iAmmo -= 2
			
			if(iAmmo < 0) iAmmo = 0
			UTIL_SetAmmo(id, PRIMARY_AMMO_TYPE, iAmmo)
			
			if(DivineTitanHitC[id] < HITCOUNT_MAX)
			{
				DivineTitanHitC[id]++
				if(DivineTitanHitC[id] >= HITCOUNT_MAX){
					UTIL_SetAmmo(id, SECONDARY_AMMO_TYPE, 1)
					Set_BitVar(g_SummonReady, id)
					do_Sandalphon_AimOn(id)	// created now, not only on deploy
					
					emit_sound(id, CHAN_BODY, SND_SUMMON_READY, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				}
			}
			
			g_flNextAmmoTime[id] = flGameTime + AMMO_CONSUME_TIME
		}
		else
		{
			// bpammo refill
			if(iAmmo < MAX_AMMO)
			{
				iAmmo += AMMO_REFILL_AMOUNT
				if(iAmmo > MAX_AMMO) iAmmo = MAX_AMMO
				UTIL_SetAmmo(id, PRIMARY_AMMO_TYPE, iAmmo)
			}
			
			g_flNextAmmoTime[id] = flGameTime + AMMO_REFILL_TIME
		}
	}
	
	// Second part of the missile sequence: ANIM_DRAW_DEFAULT after ANIM_THROW
	if(g_flDrawTime[id] > 0.0 && flGameTime >= g_flDrawTime[id])
	{
		g_flDrawTime[id] = 0.0
		if(DivineTitanMode[id] == STATE_NONE)
			util_sendweaponanim(id, ANIM_DRAW_DEFAULT)
	}
	
	CWeapon_System(id, ent, iPressed)
	
	// The original PostFrame (which calls WeaponIdle) is superseded, so the idle animation is handled here
	if(flGameTime >= g_flNextIdle[id])
		CWeapon_PlayIdle(id)
	
	return HAM_SUPERCEDE
}

// iPressed = buttons pressed during this frame (not held)
CWeapon_System(id, ent, iPressed)
{
	if(get_gametime() < g_flNextAction[id])
		return
	
	// Reload : launch the missile when the secondary ammo is charged
	if((iPressed & IN_RELOAD) && GetSecondaryAmmo(id) > 0 && Get_BitVar(g_SummonReady, id))
	{
		UnSet_BitVar(g_SummonReady, id)
		Remove_Ent_AimOn(id)
		
		// ANIM_THROW then ANIM_DRAW_DEFAULT
		util_sendweaponanim(id, ANIM_THROW)
		g_flDrawTime[id] = get_gametime() + MISSILE_THROW_TIME
		
		UTIL_SetAmmo(id, SECONDARY_AMMO_TYPE, 0)
		DivineTitanHitC[id] = 0
		
		Remove_Ent_Sandalphone(id)
		Remove_Ent_Area_Sandalphone(id)
		
		do_Sandalphon_Missile(id)
		DivineTitanMode[id] = STATE_NONE
		
		CWeapon_SetTime(id, ent)
		return
	}
	
	// Left click
	if(iPressed & IN_ATTACK)
	{
		switch(DivineTitanMode[id])
		{
			case STATE_NONE:
			{
				if(GetPrimaryAmmo(id) <= 0) return
				
				util_sendweaponanim(id, ANIM_DEFAULT_TO_A_MODE)
				DivineTitanMode[id] = STATE_A
				CWeapon_SetTime(id, ent)
				
				Ent_Sandalphone(id)
				Ent_Area_Sandalphone(id)
			}
			case STATE_A:
			{
				util_sendweaponanim(id, ANIM_A_MODE_TO_DEFAULT)
				DivineTitanMode[id] = STATE_NONE
				CWeapon_SetTime(id, ent)
				
				Remove_Ent_Sandalphone(id)
				Remove_Ent_Area_Sandalphone(id)
			}
			case STATE_B:
			{
				util_sendweaponanim(id, ANIM_B_MODE_TO_A_MODE)
				DivineTitanMode[id] = STATE_A
				CWeapon_SetTime(id, ent)
				
				Ent_Sandalphone(id)
				Ent_Area_Sandalphone(id)
			}
		}
		return
	}
	
	// Right click
	if(iPressed & IN_ATTACK2)
	{
		switch(DivineTitanMode[id])
		{
			case STATE_NONE:
			{
				if(GetPrimaryAmmo(id) <= 0) return
				
				util_sendweaponanim(id, ANIM_DEFAULT_TO_B_MODE)
				DivineTitanMode[id] = STATE_B
				CWeapon_SetTime(id, ent)
				
				Ent_Sandalphone(id)
				Remove_Ent_Area_Sandalphone(id)
			}
			case STATE_A:
			{
				util_sendweaponanim(id, ANIM_A_MODE_TO_B_MODE)
				DivineTitanMode[id] = STATE_B
				CWeapon_SetTime(id, ent)
				
				Ent_Sandalphone(id)
				Remove_Ent_Area_Sandalphone(id)
			}
			case STATE_B:
			{
				util_sendweaponanim(id, ANIM_MODE_B_TO_DEFAULT)
				DivineTitanMode[id] = STATE_NONE
				CWeapon_SetTime(id, ent)
				
				Remove_Ent_Sandalphone(id)
			}
		}
	}
}

/*========================= Entity ===================== */
// Generic dispatcher, only our classnames are handled
public fw_Entity_Think(ent)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED
	
	static szClassName[32]
	pev(ent, pev_classname, szClassName, charsmax(szClassName))
	
	if(equal(szClassName, DIVINETITAN_ENT_CLASSNAME))
		Entity_Think_Sandalphone(ent)
	else if(equal(szClassName, DIVINETITAN_AREA_CLASSNAME))
		Entity_Think_Area(ent)
	else if(equal(szClassName, DIVINETITAN_SUMMON_CLASSNAME))
		Entity_Think_Summon(ent)
	else if(equal(szClassName, DIVINETITAN_AIM_ON_CLASSNAME))
		Entity_Think_Aim_On(ent)
	else if(equal(szClassName, DIVINETITAN_ENT_HIT_CLASSNAME))
		Entity_Think_Hit(ent)
#if defined USING_SANDALPHON
	else if(equal(szClassName, DIVINETITAN_ENT_SUMMONFX_CLASSNAME))
		Entity_Think_Summonfx(ent)
#endif
#if !defined USING_SANDALPHON
	else if(equal(szClassName, DIVINETITANEX_ENT_STORMFX_CLASSNAME))
		Entity_Think_Stormfx2(ent)
	else if(equal(szClassName, DIVINETITANEX_ENT_SUMMONFX_CLASSNAME))
		Entity_Think_Summonfx2(ent)
	else if(equal(szClassName, DIVINETITANEX_ENT_GROUNDFX_CLASSNAME))
		Entity_Think_Groundfx2(ent)
#endif
	
	return FMRES_IGNORED
}

public fw_Entity_Touch(ent, other)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED
	
	static szClassName[32]
	pev(ent, pev_classname, szClassName, charsmax(szClassName))
	
	if(equal(szClassName, DIVINETITAN_BALLS_CLASSNAME))
		Entity_Touch_Balls(ent, other)
	else if(equal(szClassName, DIVINETITAN_MISSILE_CLASSNAME))
		Entity_Touch_Missile(ent, other)
	
	return FMRES_IGNORED
}

// Creates an info_target with a classname and a model
CreateTargetEntity(const szClassName[], const szModel[])
{
	static iszInfoTarget
	if(!iszInfoTarget)
		iszInfoTarget = engfunc(EngFunc_AllocString, "info_target")
	
	new ent = engfunc(EngFunc_CreateNamedEntity, iszInfoTarget)
	if(!pev_valid(ent))
		return 0
	
	set_pev(ent, pev_classname, szClassName)
	engfunc(EngFunc_SetModel, ent, szModel)
	
	return ent
}

// Kills every entity with this classname owned by the player
RemoveEntitiesByOwner(id, const szClassName[])
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", szClassName)) > 0)
	{
		if(pev(ent, pev_owner) == id)
			util_kill_entity(ent)
	}
}

// Returns true when the owner of a follow entity is still valid, otherwise the entity is removed
bool:Entity_CheckOwner(ent, &id)
{
	if(pev(ent, pev_flags) & FL_KILLME)
		return false
	
	id = pev(ent, pev_owner)
	
	if(!(1 <= id <= g_MaxPlayers) || !is_user_alive(id))
	{
		util_kill_entity(ent)
		return false
	}
	
	// The weapon was dropped / lost (no check on Holster, the entity must stay)
	if(!Get_BitVar(g_ActiveWpn, id) || !user_has_weapon(id, CSW_REFERENCE))
	{
		CSOWPN_Remove(id)
		return false
	}
	
	return true
}

/* ----- 1. Sandalphone entity (follows the head of the player) ----- */
Ent_Sandalphone(id)
{
	Remove_Ent_Sandalphone(id)
	
	new ent = CreateTargetEntity(DIVINETITAN_ENT_CLASSNAME, WORLDMODEL)
	if(!ent) return 0
	
	new Float:vOrigin[3], Float:vAngles[3]
	pev(id, pev_origin, vOrigin)
	pev(id, pev_angles, vAngles)
	vOrigin[2] += (pev(id, pev_flags) & FL_DUCKING) ? (DIVINETITAN_ENT_HEAD_OFFSET - 18.0) : DIVINETITAN_ENT_HEAD_OFFSET
	
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_angles, vAngles)
	
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_iuser1, DivineTitanMode[id])
	set_pev(ent, pev_fuser1, get_gametime())	// next laser / balls time
	
	set_pev(ent, pev_fuser2, get_gametime())	// next laser sound time (A mode)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return ent
}

Remove_Ent_Sandalphone(id)
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", DIVINETITAN_ENT_CLASSNAME)) > 0)
	{
		if(pev(ent, pev_owner) != id)
			continue
		
		emit_sound(ent, CHAN_WEAPON, SND_A_LASER, VOL_NORM, ATTN_NORM, SND_STOP, PITCH_NORM)
		util_kill_entity(ent)
	}
	
	// The hit entities of this attacker follow the laser, so they go away with it
	RemoveEntitiesByOwner(id, DIVINETITAN_ENT_HIT_CLASSNAME)
}

Entity_Think_Sandalphone(ent)
{
	new id
	if(!Entity_CheckOwner(ent, id))
		return
	
	new Float:flGameTime = get_gametime()
	new Float:vOrigin[3], Float:vAngles[3]
	
	// Follow the player (origin and angles, not v_angle)
	pev(id, pev_origin, vOrigin)
	pev(id, pev_angles, vAngles)
	vOrigin[2] += (pev(id, pev_flags) & FL_DUCKING) ? (DIVINETITAN_ENT_HEAD_OFFSET - 18.0) : DIVINETITAN_ENT_HEAD_OFFSET
	
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_angles, vAngles)
	
	new iState = pev(ent, pev_iuser1)
	new Float:flNextTime; pev(ent, pev_fuser1, flNextTime)
	
	if(iState == STATE_A)
	{
		// Looped sound (stopped in Remove_Ent_Sandalphone)
		new Float:flNextSound; pev(ent, pev_fuser2, flNextSound)
		if(flGameTime >= flNextSound)
		{
			set_pev(ent, pev_fuser2, flGameTime + LASER_SOUND_TIME)
			emit_sound(ent, CHAN_WEAPON, SND_A_LASER, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		}
		
		if(flGameTime >= flNextTime)
		{
			set_pev(ent, pev_fuser1, flGameTime + LASER_INTERVAL)
			Sandalphon_Laser(ent, id, vOrigin)
		}
	}
	else if(iState == STATE_B)
	{
		if(flGameTime >= flNextTime)
		{
			set_pev(ent, pev_fuser1, flGameTime + BALLS_INTERVAL)
			do_Sandalphon_Balls(id, vOrigin)
		}
	}
	
	set_pev(ent, pev_nextthink, flGameTime + 0.04)
}

Sandalphon_Laser(ent, id, Float:vOrigin[3])
{
	new Float:flDists[33], Float:vTargets[33][3]
	new Float:vVictim[3], Float:flFraction
	new iCandidates[33], iCount = 0, victim = -1
	
	// 1. Collect every valid enemy
	while((victim = fm_find_ent_in_sphere(victim, vOrigin, LASER_RANGE)) > 0)
	{
		// Players always have the lowest entity indexes
		if(victim > g_MaxPlayers) break
		
		if(victim == id || !is_user_alive(victim))
			continue
		
		if(cs_get_user_team(victim) == cs_get_user_team(id))
			continue
		
		pev(victim, pev_origin, vVictim)
		
		// Line of sight (world only)
		engfunc(EngFunc_TraceLine, vOrigin, vVictim, IGNORE_MONSTERS, ent, 0)
		get_tr2(0, TR_flFraction, flFraction)
		if(flFraction < 1.0)
			continue
		
		flDists[victim] = get_distance_f(vOrigin, vVictim)
		xs_vec_copy(vVictim, vTargets[victim])
		iCandidates[iCount++] = victim
	}
	
	// 2. Fire at the nearest ones first
	new iFired = 0, iBest, iTarget
	new Float:flDamage = get_pcvar_float(cvar_damage_laser)
	while(iFired < LASER_MAX_TARGETS && iCount > 0)
	{
		iBest = 0
		for(new i = 1; i < iCount; i++)
		{
			if(flDists[iCandidates[i]] < flDists[iCandidates[iBest]])
				iBest = i
		}
		
		iTarget = iCandidates[iBest]
		
		UTIL_CreateBeamEntPoint(ent, vTargets[iTarget], g_iLaser, 30, 255, 255, 255)
		UTIL_Explosion(vTargets[iTarget], A_MODE_HIT, 8, 15, EXPLOSION_FLAGS_QUIET)
		
		// Damage of the laser (sandalphon_damage_laser)
		ExecuteHamB(Ham_TakeDamage, iTarget, id, id, flDamage, DMG_BULLET | DMG_NEVERGIB)
		Slow_Player(iTarget)
		
		// Every locked target gets a hit entity (only one per target, refreshed while the laser keeps hitting him)
		if(is_user_alive(iTarget))
		{
			new iHit = FindEntityHit(id, iTarget)
			if(iHit)
				set_pev(iHit, pev_fuser1, get_gametime() + DIVINETITAN_ENT_HIT_KEEPTIME)
			else
				do_Entity_Hit(iTarget, id)
		}
		
		// Remove it from the list
		iCandidates[iBest] = iCandidates[--iCount]
		iFired++
	}
}

/* ----- Hit entity (sticks on the target locked by the laser) ----- */
// Returns the hit entity of this attacker / victim pair, 0 when there is none
FindEntityHit(iAttacker, iVictim)
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", DIVINETITAN_ENT_HIT_CLASSNAME)) > 0)
	{
		if(pev(ent, pev_flags) & FL_KILLME)
			continue
		
		if(pev(ent, pev_owner) == iAttacker && pev(ent, pev_iuser1) == iVictim)
			return ent
	}
	
	return 0
}

// id = the victim hit by the laser, iAttacker = the owner of the weapon
do_Entity_Hit(id, iAttacker)
{
	new ent = CreateTargetEntity(DIVINETITAN_ENT_HIT_CLASSNAME, A_MODE_HIT)
	if(!ent) return 0
	
	new Float:vOrigin[3], Float:vVelocity[3]
	pev(id, pev_origin, vOrigin)
	pev(id, pev_velocity, vVelocity)
	
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_velocity, vVelocity)
	
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	
	set_pev(ent, pev_owner, iAttacker)
	set_pev(ent, pev_iuser1, id)	// the victim
	set_pev(ent, pev_fuser1, get_gametime() + DIVINETITAN_ENT_HIT_KEEPTIME)	// expire time
	set_pev(ent, pev_fuser2, get_gametime())	// next chain tick
	
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_scale, DIVINETITAN_ENT_HIT_SCALE)
	set_pev(ent, pev_rendermode, DIVINETITAN_ENT_HIT_RENDERMODE)
	set_pev(ent, pev_renderamt, DIVINETITAN_ENT_HIT_RENDERAMT)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return ent
}

Entity_Think_Hit(ent)
{
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new iAttacker = pev(ent, pev_owner)
	new iVictim = pev(ent, pev_iuser1)
	new Float:flGameTime = get_gametime()
	new Float:flExpire; pev(ent, pev_fuser1, flExpire)
	
	// Removed when the victim died (so the laser can lock another one), when the laser lost him or the attacker is gone
	if(!(1 <= iVictim <= g_MaxPlayers) || !is_user_alive(iVictim)
	|| !(1 <= iAttacker <= g_MaxPlayers) || !is_user_alive(iAttacker)
	|| flGameTime >= flExpire)
	{
		util_kill_entity(ent)
		return
	}
	
	// Stick on the victim
	new Float:vOrigin[3], Float:vVelocity[3]
	pev(iVictim, pev_origin, vOrigin)
	pev(iVictim, pev_velocity, vVelocity)
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_velocity, vVelocity)
	
	// Sprite animation
	new Float:flFrame; pev(ent, pev_frame, flFrame)
	flFrame += DIVINETITAN_ENT_HIT_FRAMERATE * 0.04
	if(flFrame >= DIVINETITAN_ENT_HIT_FRAMEMAX)
		flFrame = 0.0
	set_pev(ent, pev_frame, flFrame)
	
	// Enemies around the entity are hit by a laser, an explosion and the laser damage
	new Float:flNextTick; pev(ent, pev_fuser2, flNextTick)
	if(flGameTime >= flNextTick)
	{
		set_pev(ent, pev_fuser2, flGameTime + LASER_INTERVAL)
		Entity_Hit_Chain(ent, iAttacker, iVictim, vOrigin)
	}
	
	set_pev(ent, pev_nextthink, flGameTime + 0.04)
}

Entity_Hit_Chain(ent, iAttacker, iVictim, Float:vOrigin[3])
{
	new Float:vTarget[3], Float:flFraction
	new Float:flDamage = get_pcvar_float(cvar_damage_laser)
	new victim = -1
	
	while((victim = fm_find_ent_in_sphere(victim, vOrigin, DIVINETITAN_ENT_HIT_RADIUS)) > 0)
	{
		// Players always have the lowest entity indexes
		if(victim > g_MaxPlayers) break
		
		if(victim == iAttacker || victim == iVictim || !is_user_alive(victim))
			continue
		
		if(cs_get_user_team(victim) == cs_get_user_team(iAttacker))
			continue
		
		pev(victim, pev_origin, vTarget)
		
		// Line of sight (world only)
		engfunc(EngFunc_TraceLine, vOrigin, vTarget, IGNORE_MONSTERS, ent, 0)
		get_tr2(0, TR_flFraction, flFraction)
		if(flFraction < 1.0)
			continue
		
		UTIL_CreateBeamEntPoint(ent, vTarget, g_iLaser, 30, 255, 255, 255)
		UTIL_Explosion(vTarget, A_MODE_HIT, 8, 15, EXPLOSION_FLAGS_QUIET)
		
		ExecuteHamB(Ham_TakeDamage, victim, iAttacker, iAttacker, flDamage, DMG_BULLET | DMG_NEVERGIB)
		Slow_Player(victim)
	}
}

/* ----- 2. Area entity (A mode, follows the feet of the player) ----- */
Ent_Area_Sandalphone(id)
{
	Remove_Ent_Area_Sandalphone(id)
	
	new ent = CreateTargetEntity(DIVINETITAN_AREA_CLASSNAME, A_MODE_MODEL)
	if(!ent) return 0
	
	new Float:vOrigin[3], Float:vAngles[3], Float:vAbsMin[3], Float:vPlayerAngles[3], Float:pVel[3]
	pev(id, pev_origin, vOrigin)
	pev(id, pev_absmin, vAbsMin)
	pev(id, pev_angles, vPlayerAngles)
	
	pev(id, pev_velocity, pVel)
	set_pev(ent, pev_velocity, pVel)
	
	vOrigin[2] = vAbsMin[2] + 1.0	
	vAngles[1] = vPlayerAngles[1]	
	
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_angles, vAngles)
	
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)
	
	set_pev(ent, pev_sequence, DIVINETITAN_AREA_SEQUENCE)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_framerate, 5.0)
	set_pev(ent, pev_scale, DIVINETITAN_AREA_SCALE * DIVINETITAN_AREA_SCALE_MULT)
	
	set_pev(ent, pev_rendermode, DIVINETITAN_AREA_RENDERMODE)
	set_pev(ent, pev_renderamt, DIVINETITAN_AREA_RENDERAMT)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.01)
	
	return ent
}

Remove_Ent_Area_Sandalphone(id)
{
	RemoveEntitiesByOwner(id, DIVINETITAN_AREA_CLASSNAME)
}

Entity_Think_Area(ent)
{
	new id
	if(!Entity_CheckOwner(ent, id))
		return
	
	new Float:vOrigin[3], Float:vAngles[3], Float:vAbsMin[3], Float:vPlayerAngles[3], Float:pVel[3]
	pev(id, pev_origin, vOrigin)
	pev(id, pev_absmin, vAbsMin)
	pev(id, pev_angles, vPlayerAngles)
	pev(id, pev_velocity, pVel)
	set_pev(ent, pev_velocity, pVel)
	
	vOrigin[2] = vAbsMin[2] + 1.0
	vAngles[1] = vPlayerAngles[1]
	
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_angles, vAngles)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.01)
}

/* ----- 3. Balls (B mode) ----- */
do_Sandalphon_Balls(id, Float:Origin[3])
{
	new ent = CreateTargetEntity(DIVINETITAN_BALLS_CLASSNAME, B_MODE_BALLS)
	if(!ent) return 0
	
	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_solid, SOLID_TRIGGER)
	set_pev(ent, pev_owner, id)
	engfunc(EngFunc_SetOrigin, ent, Origin)
	
	new Float:vVel[3]
	velocity_by_aim(id, floatround(DIVINETITAN_BALLS_SPEED), vVel)
	set_pev(ent, pev_velocity, vVel)
	
	set_pev(ent, pev_frame, DIVINETITAN_BALLS_FRAME)
	set_pev(ent, pev_framerate, DIVINETITAN_BALLS_FRAMERATE)
	set_pev(ent, pev_scale, 0.45)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	
	engfunc(EngFunc_SetSize, ent, Float:{-0.8, -0.8, -0.8}, Float:{0.8, 0.8, 0.8})
	
	emit_sound(id, CHAN_WEAPON, SND_BALLS, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	return ent
}

Entity_Touch_Balls(ent, other)
{
	new id; id = pev(ent, pev_owner)
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	// Never explode on the owner
	if(other == id) return
	
	new Float:vecOrigin[3]; pev(ent, pev_origin, vecOrigin)
	UTIL_Explosion(vecOrigin, B_MODE_EXP, 10, 15, EXPLOSION_FLAGS_NOSOUND)
	emit_sound(ent, CHAN_BODY, SND_BALLS_EXP, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	Radius_Damage(id, id, vecOrigin, BALLS_RANGE, get_pcvar_float(cvar_damage_exp), DMG_BULLET | DMG_NEVERGIB)
	
	set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
}

/* ----- 4. Missile and Summon ----- */
do_Sandalphon_Missile(id)
{
	new ent = CreateTargetEntity(DIVINETITAN_MISSILE_CLASSNAME, R_MODEL)
	if(!ent) return 0
	
	new Float:vOrigin[3], Float:vViewOfs[3], Float:vForward[3], Float:vVel[3], Float:vAngles[3]
	pev(id, pev_origin, vOrigin)
	pev(id, pev_view_ofs, vViewOfs)
	xs_vec_add(vOrigin, vViewOfs, vOrigin)
	
	// Start a little in front of the player
	velocity_by_aim(id, 32, vForward)
	xs_vec_add(vOrigin, vForward, vOrigin)
	
	velocity_by_aim(id, floatround(DIVINETITAN_BALLS_SPEED), vVel)
	engfunc(EngFunc_VecToAngles, vVel, vAngles)
	
	set_pev(ent, pev_owner, id)
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_angles, vAngles)
	
	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_solid, SOLID_TRIGGER)
	set_pev(ent, pev_velocity, vVel)
	
	set_pev(ent, pev_sequence, 0)
	set_pev(ent, pev_framerate, 5.0)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_scale, 0.95)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	
	engfunc(EngFunc_SetSize, ent, Float:{-0.8, -0.8, -0.8}, Float:{0.8, 0.8, 0.8})
	
	return ent
}

Entity_Touch_Missile(ent, other)
{
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new id = pev(ent, pev_owner)
	
	// Never explode on the owner
	if(other && other == id) return
	
	new Float:EntOrigin[3]; pev(ent, pev_origin, EntOrigin)
	do_Sandalphon_Summon(id, EntOrigin)
	
	set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
}

do_Sandalphon_Summon(id, Float:EntOrigin[3])
{
	new ent = CreateTargetEntity(DIVINETITAN_SUMMON_CLASSNAME, EF_MODEL)
	if(!ent) return 0
	
	set_pev(ent, pev_owner, id)
	engfunc(EngFunc_SetOrigin, ent, EntOrigin)
	
	set_pev(ent, pev_movetype, MOVETYPE_NONE)
	set_pev(ent, pev_solid, SOLID_NOT)
	
	set_pev(ent, pev_sequence, DIVINETITAN_SUMMON_SEQUENCE)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_fuser1, get_gametime() + 0.25)	
	set_pev(ent, pev_fuser2, get_gametime() + DIVINETITAN_SUMMON_REMOVETIME - 1.0)
	set_pev(ent, pev_fuser3, get_gametime() + DIVINETITAN_SUMMON_REMOVETIME - 1.0)
	
#if !defined USING_SANDALPHON
	do_StormFX(EntOrigin)
#endif
	
	set_pev(ent, pev_rendermode, DIVINETITAN_SUMMON_RENDERMODE)
	
#if !defined USING_SANDALPHON
	set_pev(ent, pev_renderamt, 0.0)
#else
	set_pev(ent, pev_renderamt, DIVINETITAN_SUMMON_RENDERAMT)
#endif
	
	emit_sound(ent, CHAN_BODY, SND_SUMMON, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return ent
}

Summon_Pull(ent)
{
	new id = pev(ent, pev_owner)
	new Float:vCenter[3], Float:vVictim[3], Float:vDir[3], Float:vTrace[3], Float:flFraction, Float:flDist
	pev(ent, pev_origin, vCenter)
	
	// Line of sight is checked from a little above the center
	xs_vec_copy(vCenter, vTrace)
	vTrace[2] += 16.0
	
	new victim = -1
	while((victim = fm_find_ent_in_sphere(victim, vCenter, DIVINETITAN_SUMMON_RANGE)) > 0)
	{
		// Players always have the lowest entity indexes
		if(victim > g_MaxPlayers) break
		
		if(victim == id || !is_user_alive(victim))
			continue
		
		// No friendly pull (when the owner left, everybody is an enemy)
		if(1 <= id <= g_MaxPlayers && is_user_connected(id) && cs_get_user_team(victim) == cs_get_user_team(id))
			continue
		
		pev(victim, pev_origin, vVictim)
		
		// World only, so the victims are not pulled through walls
		engfunc(EngFunc_TraceLine, vTrace, vVictim, IGNORE_MONSTERS, ent, 0)
		get_tr2(0, TR_flFraction, flFraction)
		if(flFraction < 1.0)
			continue
		
		xs_vec_sub(vCenter, vVictim, vDir)
		flDist = vector_length(vDir)
		
		if(flDist <= DIVINETITAN_SUMMON_HOLD_RADIUS)
		{
			// Reached the center: held in place
			vDir[0] = 0.0; vDir[1] = 0.0; vDir[2] = 0.0
		}
		else
		{
			xs_vec_normalize(vDir, vDir)
			xs_vec_mul_scalar(vDir, DIVINETITAN_SUMMON_PULL_SPEED, vDir)
			
			// Lift a little so the ground friction does not stop the pull
			if(pev(victim, pev_flags) & FL_ONGROUND)
				vDir[2] += 50.0
		}
		
		set_pev(victim, pev_velocity, vDir)
	}
}

Entity_Think_Summon(ent)
{
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new id = pev(ent, pev_owner)
	new Float:flGameTime = get_gametime()
	new Float:flPullStart, Float:flPullEnd
	pev(ent, pev_fuser1, flPullStart)
	pev(ent, pev_fuser2, flPullEnd)
	
	new Float:vecOrigin[3]; pev(ent, pev_origin, vecOrigin)
	
	new Float:fTimeRemove; pev(ent, pev_fuser3, fTimeRemove)
	
#if !defined USING_SANDALPHON
	// Fade in only until the fade out starts, otherwise this +20 cancels the -15 of the fade out and the summon never disappears
	if(flGameTime < fTimeRemove)
	{
		new Float:flFadeIn; pev(ent, pev_renderamt, flFadeIn)
		flFadeIn += 20.0
		if(flFadeIn >= 255.0)
			flFadeIn = 255.0
		set_pev(ent, pev_renderamt, flFadeIn)
	}
#endif
	
	if(flGameTime >= flPullStart && flGameTime < flPullEnd)
	{
		Summon_Pull(ent)
		
		new Float:flNextTick; pev(ent, pev_fuser4, flNextTick)
		if(flGameTime >= flNextTick)
		{
			set_pev(ent, pev_fuser4, flGameTime + DIVINETITAN_SUMMON_DAMAGE_INTERVAL)
			Radius_Damage(id, id, vecOrigin, DIVINETITAN_SUMMON_RANGE, get_pcvar_float(cvar_damage_summon), DMG_BULLET | DMG_NEVERGIB)
		}
	}
	else if(flGameTime >= flPullEnd && !pev(ent, pev_iuser1))
	{
#if !defined USING_SANDALPHON
		do_Summonfx2(vecOrigin)
		do_Groundfx(vecOrigin)
#endif
#if defined USING_SANDALPHON
		do_Summonfx(vecOrigin)
#endif
		set_pev(ent, pev_iuser1, 1)
		Radius_Damage(id, id, vecOrigin, DIVINETITAN_SUMMON_RANGE, random_float(get_pcvar_float(cvar_damage_summon_slam), get_pcvar_float(cvar_damage_summon_slam) * 4096.0), DMG_BULLET | DMG_NEVERGIB)
	}
	
	// Fade out, then remove the entity when it is fully transparent
	if(flGameTime >= fTimeRemove)
	{
		new Float:RenderAmt
		pev(ent, pev_renderamt, RenderAmt)
		if(RenderAmt <= 0.0)
		{
			set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			return
		}
		
		RenderAmt -= 15.0
		if(RenderAmt < 0.0) RenderAmt = 0.0
		
		set_pev(ent, pev_renderamt, RenderAmt)
	}
	
	set_pev(ent, pev_nextthink, flGameTime + 0.04)
}

Remove_Ent_AimOn(id)
{
	RemoveEntitiesByOwner(id, DIVINETITAN_AIM_ON_CLASSNAME)
}

do_Sandalphon_AimOn(id)
{
	Remove_Ent_AimOn(id)
	
	new ent = CreateTargetEntity(DIVINETITAN_AIM_ON_CLASSNAME, AIM_ON_SPR)
	if(!ent) return 0
	
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_aiment, id)
	set_pev(ent, pev_body, 2)
	set_pev(ent, pev_skin, id)
	set_pev(ent, pev_scale, DIVINETITAN_AIM_ON_SCALE)
	
	set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(ent, pev_solid, SOLID_NOT)
	
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 0.0)
	
	dllfunc(DLLFunc_Spawn, ent)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	return ent;
}

Entity_Think_Aim_On(ent)
{
	if(!IsValidPev(ent)) return
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new id = pev(ent, pev_owner)
	
	// Removed when the owner is gone, the weapon is holstered or the missile is no longer ready
	if(!(1 <= id <= g_MaxPlayers) || !is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id)
	|| get_user_weapon(id) != CSW_REFERENCE || !Get_BitVar(g_SummonReady, id))
	{
		util_kill_entity(ent)
		return
	}
	
	set_pev(ent, pev_renderamt, 200.0)
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}

#if defined USING_SANDALPHON
do_Summonfx(Float:Origin[3])
{
	new ent = CreateTargetEntity(DIVINETITAN_ENT_SUMMONFX_CLASSNAME, DIVINETITAN_ENT_SUMMONFX)
	if(!ent) return 0
	
	new Float:vOrigin[3]
	xs_vec_copy(Origin, vOrigin)
	vOrigin[2] += 128.0 * DIVINETITAN_SUMMONFX_SCALE + 1.0
	
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	
	set_pev(ent, pev_scale, DIVINETITAN_SUMMONFX_SCALE)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return ent
}

Entity_Think_Summonfx(ent)
{
	if(!IsValidPev(ent)) return
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	
	// The last frame of the sprite is DIVINETITANEX_SUMMONFX_FRAMES - 1
	if(fFrame >= DIVINETITAN_SUMMONFX_FRAMES - 1.0)
	{
		util_kill_entity(ent)
		return
	}
	
	fFrame += 1.0
	set_pev(ent, pev_frame, fFrame)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}
#endif

#if !defined USING_SANDALPHON
do_StormFX(Float:Origin[3])
{
	new Float:vRing[3], Float:vAngles[3]
	new Float:flRadius = DIVINETITAN_SUMMON_RANGE * DIVINETITANEX_STORMFX_RADIUS
	new Float:flCenterRadius = flRadius - DIVINETITANEX_STORMFX_BANDOFFS * DIVINETITANEX_STORMFX_SCALE
	
	for(new i = 0; i < DIVINETITANEX_STORMFX_COUNT; i++)
	{
		new ent = CreateTargetEntity(DIVINETITANEX_ENT_STORMFX_CLASSNAME, DIVINETITANEX_ENT_STORMFX)
		if(!ent) continue
		
		set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
		set_pev(ent, pev_solid, SOLID_NOT)
		
		// Evenly spaced point on the circle (polar coordinates), fixed for the whole life of the sprite
		new Float:flAngle = 360.0 / float(DIVINETITANEX_STORMFX_COUNT) * float(i)
		vRing[0] = Origin[0] + floatcos(flAngle, degrees) * flCenterRadius
		vRing[1] = Origin[1] + floatsin(flAngle, degrees) * flCenterRadius
		vRing[2] = Origin[2] + 1.0
		engfunc(EngFunc_SetOrigin, ent, vRing)
		
		// Pitch 90 = lie flat on the floor (same as the ground effect)
		// Yaw = point angle + 180, so the sprite width follows the tangent of the circle and the sprite height points to the center
		vAngles[0] = 90.0
		vAngles[1] = flAngle + 180.0
		vAngles[2] = 0.0
		set_pev(ent, pev_angles, vAngles)
		
		// All sprites start on the same frame, so the whole ring plays and ends together
		set_pev(ent, pev_frame, 0.0)
		set_pev(ent, pev_scale, DIVINETITANEX_STORMFX_SCALE)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, DIVINETITANEX_STORMFX_RENDERAMT)
		
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	}
	
	return 1
}

Entity_Think_Stormfx2(ent)
{
	if(!IsValidPev(ent)) return
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	
	// The last frame of the sprite is DIVINETITANEX_STORMFX_FRAMES - 1
	if(fFrame >= DIVINETITANEX_STORMFX_FRAMES - 1.0)
	{
		util_kill_entity(ent)
		return
	}
	
	// Only the animation advances, the position never changes
	fFrame += 1.0
	set_pev(ent, pev_frame, fFrame)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}

do_Summonfx2(Float:Origin[3])
{
	new ent = CreateTargetEntity(DIVINETITANEX_ENT_SUMMONFX_CLASSNAME, DIVINETITANEX_ENT_SUMMONFX)
	if(!ent) return 0
	
	new Float:vOrigin[3]
	xs_vec_copy(Origin, vOrigin)
	vOrigin[2] += 128.0 * DIVINETITANEX_SUMMONFX_SCALE + 1.0
	
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	
	set_pev(ent, pev_scale, DIVINETITANEX_SUMMONFX_SCALE)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return ent
}

Entity_Think_Summonfx2(ent)
{
	if(!IsValidPev(ent)) return
	if(pev(ent, pev_flags) & FL_KILLME) return
	
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	
	// The last frame of the sprite is DIVINETITANEX_SUMMONFX_FRAMES - 1
	if(fFrame >= DIVINETITANEX_SUMMONFX_FRAMES - 1.0)
	{
		util_kill_entity(ent)
		return
	}
	
	fFrame += 1.0
	set_pev(ent, pev_frame, fFrame)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}

do_Groundfx(Float:Origin[3])
{
	new ent = CreateTargetEntity(DIVINETITANEX_ENT_GROUNDFX_CLASSNAME, DIVINETITANEX_ENT_GROUNDFX)
	if(!ent) return 0
	
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	
	new Float:Angles[3]
	
	Origin[2] += 1.0
	Angles[0] = 90.0
	
	set_pev(ent, pev_angles, Angles)
	engfunc(EngFunc_SetOrigin, ent, Origin)
	
	//frame and scale
	set_pev(ent, pev_scale, 2.0)
	set_pev(ent, pev_frame, 0)
	set_pev(ent, pev_framerate, 30.0)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return ent
}

Entity_Think_Groundfx2(ent)
{
	if(!IsValidPev(ent)) return
	
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	
	if(fFrame >=  76.0)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}
	
	fFrame += 2.0
	set_pev(ent, pev_frame, fFrame)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}
#endif

/*========================= HUD / Ammo ===================== */
// Sets an ammo slot of the player and updates the client HUD
stock UTIL_SetAmmo(id, iAmmoType, iAmount)
{
	if(iAmount < 0) iAmount = 0
	
	set_pdata_int(id, m_rgAmmo + iAmmoType, iAmount, linux_diff_player)
	
	message_begin(MSG_ONE, g_iMsgAmmoX, _, id)
	write_byte(iAmmoType)
	write_byte(iAmount)
	message_end()
}

// Sends the weapon list. bCustom = false restores the default weapon_hegrenade entry
stock UTIL_WeaponList(id, bool:bCustom)
{
	message_begin(MSG_ONE, g_iMsgWeaponList, _, id)
	if(bCustom)
	{
		write_string(WEAPON_TXT)			// sprites/weapon_divinetitan.txt
		write_byte(PRIMARY_AMMO_TYPE)
		write_byte(MAX_AMMO)
		write_byte(SECONDARY_AMMO_TYPE)
		write_byte(SECONDARY_AMMO_MAX)
		write_byte(WEAPON_SLOT)
		write_byte(WEAPON_POSITION)
		write_byte(CSW_REFERENCE)
		write_byte(WEAPON_ITEM_FLAGS)
	}
	else
	{
		write_string(WEAPON_REFERENCE)
		write_byte(PRIMARY_AMMO_TYPE)
		write_byte(1)
		write_byte(-1)
		write_byte(-1)
		write_byte(WEAPON_SLOT)
		write_byte(WEAPON_POSITION)
		write_byte(CSW_REFERENCE)
		write_byte(24)
	}
	message_end()
}

/*========================= Stocks ===================== */

stock UTIL_SetHud(const pPlayer, const iHud)
{
	static iMsgId_HideWeapon
	if (!iMsgId_HideWeapon)
		iMsgId_HideWeapon = get_user_msgid("HideWeapon")

	message_begin(MSG_ONE, iMsgId_HideWeapon, _, pPlayer)
	write_byte(iHud)
	message_end()
}

stock util_sendweaponanim(id, anim)
{
	if(!is_user_alive(id))
		return

	set_pev(id, pev_weaponanim, anim)

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM_ID, _, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

/* ~ [ Precache (Model) ] ~ */
stock util_precache_model(const szFileName[])
{
	if (file_exists(szFileName))
	{
		return engfunc(EngFunc_PrecacheModel, szFileName)
	}

	set_fail_state("Model/Sprite <%s> not found. The plugin has been stopped.", szFileName)
	return 0
}

/* ~ [ Precache (Sound) ] ~ */
stock util_precache_sound(const szFileName[])
{
	if (file_exists(fmt("sound/%s", szFileName)))
	{
		return engfunc(EngFunc_PrecacheSound, szFileName)
	}

	set_fail_state("Sound <%s> not found. The plugin has been stopped.", szFileName)
	return 0
}

/* ~ [ Precache (Sounds From Model) ] ~ */
// Reads every animation event 5004 (sound) of the model and precaches the sound it plays.
#if PrecacheSoundsFromModel == 1
	stock util_precache_sounds_from_model(const szModelPath[])
	{
		new pFile

		if (!(pFile = fopen(szModelPath, "rb")))
		{
			return
		}

		new szSoundPath[64], szFullPath[128]
		new iNumSeq, iSeqIndex
		new iEvent, iNumEvents, iEventIndex

		fseek(pFile, 164, SEEK_SET)
		fread(pFile, iNumSeq, BLOCK_INT)
		fread(pFile, iSeqIndex, BLOCK_INT)

		for (new i = 0; i < iNumSeq; i++)
		{
			fseek(pFile, iSeqIndex + 48 + 176 * i, SEEK_SET)
			fread(pFile, iNumEvents, BLOCK_INT)
			fread(pFile, iEventIndex, BLOCK_INT)

			for (new k = 0; k < iNumEvents; k++)
			{
				fseek(pFile, iEventIndex + 4 + 76 * k, SEEK_SET)
				fread(pFile, iEvent, BLOCK_INT)
				fseek(pFile, 4, SEEK_CUR)

				if (iEvent != 5004)
				{
					continue
				}

				fread_blocks(pFile, szSoundPath, 64, BLOCK_CHAR)

				if (strlen(szSoundPath))
				{
					strtolower(szSoundPath)
					formatex(szFullPath, charsmax(szFullPath), "sound/%s", szSoundPath)

					// Only precache sounds that really exist (also checks the game's own files)
					if (file_exists(szFullPath, true))
						engfunc(EngFunc_PrecacheGeneric, szFullPath)
				}
			}
		}

		fclose(pFile)
	}
#endif

/* -> Kill Entity <- */
stock util_kill_entity(const pEntity)
{
	set_pev(pEntity, pev_flags, pev(pEntity, pev_flags) | FL_KILLME)
	set_pev(pEntity, pev_nextthink, get_gametime())
}

/* -> Destroy All Entities by ClassName <- */
stock util_destroy_entities_by_classname(const szClassName[])
{
	static pEntity; pEntity = -1
	while ((pEntity = engfunc(EngFunc_FindEntityByString, pEntity, "classname", szClassName)) > 0)
		util_kill_entity(pEntity)
}

stock Stock_SetAccuracy(id, ent)
{
	static Float:flAcc, Float:vecVel[3]
	pev(id, pev_velocity, vecVel)
	vecVel[2] = 0.0

	if(!(pev(id, pev_flags) & FL_ONGROUND))
		flAcc = (0.10 - 0.035) / 0.4
	else if(vector_length(vecVel) > 140.0)
		flAcc = (0.04 - 0.035) / 0.07
	else
		flAcc = 0.004 / 0.02

	if(flAcc < 0.0) flAcc = 0.0
	set_pdata_float(ent, m_Weapon_flAccuracy, flAcc, linux_diff_weapon)
}

stock Stock_DropSlot(iPlayer, Slot)
{
	new item = get_pdata_cbase(iPlayer, m_rgpPlayerItems_slot0 + Slot, linux_diff_player)
	while(pev_valid(item))
	{
		static classname[24]
		pev(item, pev_classname, classname, charsmax(classname))

		new next = get_pdata_cbase(item, m_pNext, linux_diff_weapon)

		engclient_cmd(iPlayer, "drop", classname)
		item = next
	}
}

stock UTIL_CreateBeamEntPoint(ent, Float: flOrigin[3], iszModelIndex, iWidth, iRed, iGreen, iBlue)
{
    message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
    write_byte(TE_BEAMENTPOINT);
    write_short(ent);
    engfunc(EngFunc_WriteCoord, flOrigin[0]);
    engfunc(EngFunc_WriteCoord, flOrigin[1]);
    engfunc(EngFunc_WriteCoord, flOrigin[2]);
    write_short(iszModelIndex) // Model index
    write_byte(0); // Framestart
    write_byte(0); // Framerate
    write_byte(9); // Life
    write_byte(iWidth * 4); // Width
    write_byte(1); // Noise
    write_byte(iRed); // Red
    write_byte(iGreen); // Green
    write_byte(iBlue); // Blue
    write_byte(255); // Alpha
    write_byte(60); // Speed
    message_end();
}

stock Stock_KnockBack(iVictim, iAttacker, Float:flPower, Float:flLift = 0.0)
{
	if(flPower <= 0.0)
		return
	
	if(!(1 <= iVictim <= g_MaxPlayers) || !(1 <= iAttacker <= g_MaxPlayers))
		return
	
	if(iVictim == iAttacker || !is_user_alive(iVictim))
		return
	
	new Float:vecVictim[3], Float:vecAttacker[3], Float:vecDir[3], Float:vecVelocity[3]
	pev(iVictim, pev_origin, vecVictim)
	pev(iAttacker, pev_origin, vecAttacker)
	
	// Direction attacker -> victim, flattened on the horizontal plane
	xs_vec_sub(vecVictim, vecAttacker, vecDir)
	vecDir[2] = 0.0
	
	// Same horizontal position (e.g. victim right above the attacker): there is no "backward" direction
	if(vector_length(vecDir) < 1.0)
		return
	
	xs_vec_normalize(vecDir, vecDir)
	xs_vec_mul_scalar(vecDir, flPower, vecDir)
	
	pev(iVictim, pev_velocity, vecVelocity)
	vecVelocity[0] += vecDir[0]
	vecVelocity[1] += vecDir[1]
	vecVelocity[2] += flLift
	
	set_pev(iVictim, pev_velocity, vecVelocity)
}

stock EmitSound_FromPos(const Float:vecOrigin[3], const szSound[], Float:flVol = VOL_NORM, Float:flAttn = ATTN_NORM, iFlags = 0, iPitch = PITCH_NORM)
{
	engfunc(EngFunc_EmitAmbientSound, 0, vecOrigin, szSound, flVol, flAttn, iFlags, iPitch)
}

stock UTIL_Explosion(const Float:vecOrigin[3], const szSprite[], iScale = 10, iFrameRate = 15, iFlags = 0)
{
	// https://github.com/baso88/SC_AngelScript/wiki/TE_EXPLOSION
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, vecOrigin[0])
	engfunc(EngFunc_WriteCoord, vecOrigin[1])
	engfunc(EngFunc_WriteCoord, vecOrigin[2])
	write_short(engfunc(EngFunc_ModelIndex, szSprite))
	write_byte(iScale)     // scale * 0.1
	write_byte(iFrameRate) // framerate
	write_byte(iFlags)     // flags
	message_end()
}

/*========================= Slow ===================== */
// Called after every damage of this weapon (laser, hit chain, balls, summon, slam). Players only.
stock Slow_Player(victim)
{
	if(!(1 <= victim <= g_MaxPlayers) || !is_user_alive(victim))
		return
	
	new Float:flTime = get_pcvar_float(cvar_slow_time)
	if(flTime <= 0.0)
		return
	
	// Every damage refreshes the duration
	g_flSlowEnd[victim] = get_gametime() + flTime
	g_bSlowed[victim] = true
}

Slow_Reset(id)
{
	if(g_bSlowed[id] && is_user_alive(id))
		ExecuteHamB(Ham_CS_Player_ResetMaxSpeed, id)
	
	g_bSlowed[id] = false
	g_flSlowEnd[id] = 0.0
}

// While slowed the max speed is the normal max speed (of the current weapon) multiplied by sandalphon_slow_speed
public fw_PlayerPreThink(id)
{
	if(!g_bSlowed[id])
		return FMRES_IGNORED
	
	if(!is_user_alive(id))
	{
		g_bSlowed[id] = false
		return FMRES_IGNORED
	}
	
	// Always start from the normal speed, otherwise the multiplier would be applied again every frame
	ExecuteHamB(Ham_CS_Player_ResetMaxSpeed, id)
	
	if(get_gametime() >= g_flSlowEnd[id])
	{
		g_bSlowed[id] = false
		return FMRES_IGNORED
	}
	
	new Float:flMaxSpeed
	pev(id, pev_maxspeed, flMaxSpeed)
	set_pev(id, pev_maxspeed, flMaxSpeed * get_pcvar_float(cvar_slow_speed))
	
	return FMRES_IGNORED
}

stock Radius_Damage(id, inflictor, const Float:vicOri[3], Float:fRadius, Float:fDamage, dmgbits)
{
	// The owner may have left: then everybody is an enemy and the damage has no attacker
	new bool:bOwner = (1 <= id <= g_MaxPlayers && is_user_connected(id))
	new i = -1

	while((i = fm_find_ent_in_sphere(i, vicOri, fRadius)) > 0)
	{
		if(id == i) continue
		if(pev(i, pev_takedamage) == DAMAGE_NO) continue
		if(pev(i, pev_spawnflags) & SF_BREAK_TRIGGER_ONLY) continue

		if(1 <= i <= g_MaxPlayers)
		{
			if(!is_user_alive(i)) continue
			if(bOwner && cs_get_user_team(i) == cs_get_user_team(id)) continue
		}

		ExecuteHamB(Ham_TakeDamage, i, bOwner ? inflictor : 0, bOwner ? id : 0, fDamage, dmgbits)
		
		if(1 <= i <= g_MaxPlayers)
			Slow_Player(i)
		
		if(bOwner)
			Stock_KnockBack(i, id, 5.0, 5.0)
	}
}
/*==============================================*/
