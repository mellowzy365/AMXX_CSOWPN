
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <xs>
#include <fun>
#include <cstrike>

#define PLUGIN_NAME    "Quantum Horizon"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR  "Mellowzy"

#define PrecacheSoundsFromModel 1

/*========================= CSW_Data ===================== */
#define CSW_REFERENCE		CSW_M4A1
#define WEAPON_REFERENCE	"weapon_m4a1"
#define WEAPON_TXT			"weapon_revivegun"
#define WEAPON_HOOK			"weapon_revivegun"
#define WEAPON_IMPULSE		0010
#define OLD_REFERENCE		"models/w_m4a1.mdl"
#define WEAPON_EVENTS 		"events/m4a1.sc"
#define BODY_NUM 			0

/*========================= Weapon_Data ===================== */
#define PLAYERMODEL			"models/mellowzy/p_revivegun_a.mdl"
#define VIEWMODELA			"models/mellowzy/v_revivegun_a_fix.mdl"
#define VIEWMODELB			"models/mellowzy/v_revivegun_b_fix.mdl"
#define WORLDMODEL			"models/mellowzy/w_revivegun.mdl"

#define SND_SHOOTA			"weapons/revivegun-1.wav"
#define SND_SHOOTB			"weapons/revivegun-2.wav"
#define SND_EXP				"weapons/revivegun-1_exp.wav"
#define SND_REVIVE			"weapons/revivegun_revive_in1.wav"

#define WEAPON_640_1		"sprites/640hud41.spr"
#define WEAPON_640_2		"sprites/640hud216.spr"
#define WEAPON_GENERIC		"sprites/weapon_revivegun.txt"

#define SPR_EXP				"sprites/mellowzy/ef_revivegun_expA.spr"
#define SPR_EXP2			"sprites/mellowzy/ef_revivegun_expB.spr"
#define LASER_SPR			"sprites/mellowzy/ef_revivegun_laser.spr"

/*========================= Entities ===================== */
#define ENTITY_KEY			5890009

#define MUZZLEFLASH_A		"revivegun_mf_a"
#define MF_A_MODEL			"sprites/mellowzy/muzzleflash224.spr"
#define MF_B_MODEL			"sprites/mellowzy/muzzleflash223.spr"
#define MF_A_FRAMEMAX		15.0

#define EF_REVIVE_CLASSNAME	"ef_revive"
#define EF_REVIVE_MODEL		"sprites/mellowzy/muzzleflash226.spr"
#define EF_REVIVE_FRAMEMAX	32.0
#define EF_REVIVE_COUNT		20		// number of sprites that form the circle
#define EF_REVIVE_RADIUS	120.0	// radius of the circle, the player stands in the middle
#define EF_REVIVE_HEIGHT	10.0	// relative to the player origin (middle of the body), 0.0 = waist
#define EF_REVIVE_SCALE		1.0
#define EF_REVIVE_ROT_SPEED	0.0		// degrees per second, 0.0 = fixed circle (does not rotate)
#define EF_REVIVE_FPS		30.5	// sprite animation speed (frames per second)
#define EF_REVIVE_THINK		0.03

#define EF_FIELD_CLASSNAME	"ef_revive_field"
#define EF_FIELD_MODEL		"models/mellowzy/ef_revivegun_field.mdl"
#define EF_FIELD_SEQ		0
#define EF_FIELD_RENDERMODE kRenderTransAdd
#define EF_FIELD_RENDERAMT  255.0
#define EF_FIELD_REMOVETIME 1.5

/*========================= Weapon_Tunables ===================== */
#define WEAPON_COMMANDS		"give_weapons_revivegun"

#define WP_SPEED_A			2.5
#define WP_SPEED_B			1.5

// Time between the mode B start animation and the first mode B shot
#define WP_SHOOTB_START_TIME	0.45
// Recovery time after mode B is released (fail/end animation)
#define WP_SHOOTB_FAIL_TIME		0.8

#define WP_RECOIL			1.0
#define RADIUS_EXP			180.0

#define WEAPON_LASER_RANGE 900.0
#define WEAPON_LASER_MAX_VICTIMS 5
#define WEAPON_LASER_DAMAGE_TYPE DMG_BULLET | DMG_NEVERGIB

#define WEAPON_LASER_EXP_RADIUS 60.0
#define WEAPON_LASER_EXP_DMGTYPE DMG_BULLET | DMG_NEVERGIB

#define WP_CLIP				60
#define WP_BPAMMO			250
#define WP_RELOAD_TIME		2.0

// Secondary ammo used by mode B
#define WP_SECAMMO_MAX			6
#define WP_SECAMMO_RECHARGE		3.0
// CS uses ammo ids 1-14, so 15 is a free id for the custom secondary ammo
#define WP_SECAMMO_ID			15

#define CHANCE_REVIVE		2

// Health given to the player when the auto revive triggers
#define WP_REVIVE_HEALTH	100
// Time the weapon is locked while the revive animation plays
#define WP_REVIVE_TIME		0.1

// Shots needed to activate the revive state
#define REVIVE_SHOOT_COUNT	30

// Mode B laser beam width. The beam message uses 0.1 unit steps and the value is multiplied by 4
// in UTIL_CreateBeamEntPoint, so it must stay below 64 to fit in a byte (32 = 12.8 units).
#define LASER_BEAM_WIDTH	32

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
#define m_Weapon_iShotsFired					64
#define m_flNextAttack							83
#define m_rgpPlayerItems_slot0					367
#define m_pActiveItem							373
#define m_rgAmmo								376
#define SVC_WEAPONANIM_ID						35

// Same as SF_BREAK_TRIGGER_ONLY in hlsdk_const (defined here to be safe)
#define BREAK_TRIGGER_ONLY						1

// NOTE: no space is allowed between the macro name and (%1,%2)
#define Get_BitVar(%1,%2)						(%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2)						%1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2)						%1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) 							(pev_valid(%0) == 2)

#define HIDEHUD_MONEY  							(1<<5)
#define SET_CUSTOM_HUD 							(HIDEHUD_MONEY)
#define RESET_HUD      							0

/* =============================================================================  */
/*========================= Var's ===================== */
new g_ActiveWpn, g_ActiveRevive, g_weapon_event, g_MaxPlayers
new g_Old_Weapon[33], Float:g_Recoil[33][3], g_ReClip[33], g_Clip[33], g_ShootCount[33], g_AttackState[33]
new Float:g_SavedOrigin[33][3], g_HasSavedOrigin
new Float:g_LastDamageTime[33], g_ChanceRevive[33], g_ReviveEnt[33][EF_REVIVE_COUNT]
new g_RevivePosSaved
new g_SecAmmo[33], Float:g_SecAmmoTime[33]
new g_msgWeaponList, g_msgAmmoX
new g_iLaser;

new cvar_dmg_exp, cvar_dmg_laser, cvar_kb_exp, cvar_kb_laser

enum
{
	ANIM_IDLE = 0,
	ANIM_RELOAD,
	ANIM_DRAW,
	ANIM_SHOOTA,
	ANIM_SHOOTB_START,
	ANIM_SHOOTB_FAIL,
	ANIM_SHOOTB,
	ANIM_REVIVE_IDLE,
	ANIM_REVIVE_RELOAD,
	ANIM_REVIVE_DRAW,
	ANIM_REVIVE_SHOOTA,
	ANIM_REVIVE_SHOOTB_START,
	ANIM_REVIVE_SHOOTB_FAIL,
	ANIM_REVIVE_SHOOTB,
	ANIM_REVIVE
}

enum
{
	STATE_SHOOTB_START = 0,
	STATE_SHOOTB,
	STATE_SHOOTB_FAIL
}

/*========================= Init ===================== */
public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")

	g_MaxPlayers = get_maxplayers()
	g_msgWeaponList = get_user_msgid("WeaponList")
	g_msgAmmoX = get_user_msgid("AmmoX")
	
	//fakemeta
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", true)
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_Think, "fw_Entity_Think")
	
	RegisterHam(Ham_Item_Deploy, WEAPON_REFERENCE, "Ham_CWeapon_Deploy_Post", true)
	RegisterHam(Ham_Item_AddToPlayer, WEAPON_REFERENCE, "Ham_CWeapon_AddToPlayer_Post", true)
	RegisterHam(Ham_Item_Holster, WEAPON_REFERENCE, "Ham_CWeapon_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame, WEAPON_REFERENCE, "Ham_CWeapon_PostFrame_Pre")
	RegisterHam(Ham_Weapon_WeaponIdle, WEAPON_REFERENCE, "Ham_CWeapon_Idle_Pre")
	RegisterHam(Ham_Weapon_Reload, WEAPON_REFERENCE, "Ham_CWeapon_Reload_Pre")
	RegisterHam(Ham_Weapon_Reload, WEAPON_REFERENCE, "Ham_CWeapon_Reload_Post", true)
	RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_PrimaryAttack_Pre")
	RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_PrimaryAttack_Post", true)
	RegisterHam(Ham_Weapon_SecondaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_SecondaryAttack_Pre")
	
	RegisterHam(Ham_Spawn, "player", "fw_Spawn_Post", true)
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage_Pre")
	RegisterHam(Ham_Killed, "player", "fw_Killed_Pre")
	RegisterHam(Ham_Killed, "player", "fw_Killed_Post", true)
	
	cvar_dmg_exp = register_cvar("revivegun_damage_exp", "250.0")
	cvar_dmg_laser = register_cvar("revivegun_damage_laser", "750.0")
	cvar_kb_exp = register_cvar("revivegun_knockback_exp", "200.0")
	cvar_kb_laser = register_cvar("revivegun_knockback_laser", "300.0")
	
	register_clcmd(WEAPON_COMMANDS, "CSOWPN_Give", ADMIN_IMMUNITY)
	register_clcmd(WEAPON_HOOK, "CSOWPN_Hook")
}
/*========================= Precache ===================== */
public plugin_precache()
{
	util_precache_model(PLAYERMODEL)
	util_precache_model(VIEWMODELA)
	util_precache_model(VIEWMODELB)
	util_precache_model(WORLDMODEL)
	util_precache_model(WEAPON_640_1)
	util_precache_model(WEAPON_640_2)
	util_precache_model(SPR_EXP)
	util_precache_model(SPR_EXP2)
	util_precache_model(MF_A_MODEL)
	util_precache_model(MF_B_MODEL)
	util_precache_model(EF_REVIVE_MODEL)
	util_precache_model(EF_FIELD_MODEL)
	
	g_iLaser = util_precache_model(LASER_SPR)
	
	util_precache_sounds_from_model(VIEWMODELA)
	util_precache_sounds_from_model(VIEWMODELB)
	util_precache_sound(SND_SHOOTA)
	util_precache_sound(SND_SHOOTB)
	util_precache_sound(SND_EXP)
	util_precache_sound(SND_REVIVE)
	
	precache_generic(WEAPON_GENERIC)
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", true)
}
/*========================= Commands ===================== */
public CSOWPN_Give(id)
{
	if(!is_user_alive(id)) return
	
	Stock_DropSlot(id, 1)
	
	Set_BitVar(g_ActiveWpn, id)
	fm_give_item(id, WEAPON_REFERENCE)
	
	CSOWPN_ResetState(id)
	
	g_ChanceRevive[id] = CHANCE_REVIVE
	g_SecAmmo[id] = WP_SECAMMO_MAX
	
	static wp; wp = fm_get_user_weapon_entity(id, CSW_REFERENCE)
	if(wp > 0)
	{
		cs_set_weapon_ammo(wp, WP_CLIP)
		cs_set_user_bpammo(id, CSW_REFERENCE, WP_BPAMMO)
		
		message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), _, id)
		write_byte(1)
		write_byte(CSW_REFERENCE)
		write_byte(WP_CLIP)
		message_end()
		
		Ham_CWeapon_Deploy_Post(wp)
	}
	
	engclient_cmd(id, WEAPON_REFERENCE)
}
public CSOWPN_Remove(id)
{
	UnSet_BitVar(g_ActiveWpn, id)
	
	// Back to the default m4a1 HUD data
	if(is_user_connected(id))
		WeaponList_Restore(id)
}
public CSOWPN_Hook(id)
{
	engclient_cmd(id, WEAPON_REFERENCE)
	return PLUGIN_HANDLED
}
public CSOWPN_ResetState(id)
{
	g_ShootCount[id] = 0
	ModeB_Cancel(id)
	UnSet_BitVar(g_ActiveRevive, id)
	UnSet_BitVar(g_RevivePosSaved, id)
}

public client_disconnected(id)
{
	UnSet_BitVar(g_ActiveWpn, id)
	CSOWPN_ResetState(id)
	
	g_LastDamageTime[id] = 0.0
	g_ChanceRevive[id] = 0
	g_SecAmmo[id] = 0
	g_SecAmmoTime[id] = 0.0
	
	UnSet_BitVar(g_HasSavedOrigin, id)
	g_SavedOrigin[id][0] = g_SavedOrigin[id][1] = g_SavedOrigin[id][2] = 0.0
}

/*========================= Curweapon ===================== */
public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return

	Revive_TrySaveOrigin(id)

	new csw = read_data(2)

	if(csw == CSW_REFERENCE && Get_BitVar(g_ActiveWpn, id))
	{
		set_pev(id, pev_viewmodel2, VIEWMODELA)
		set_pev(id, pev_weaponmodel2, PLAYERMODEL)
	}

	g_Old_Weapon[id] = csw
}
/*========================= Fakemeta ===================== */
public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(WEAPON_EVENTS, name))
		g_weapon_event = get_orig_retval()
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

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if(eventid != g_weapon_event)
		return FMRES_IGNORED
	if(!(1 <= invoker <= g_MaxPlayers) || !Get_BitVar(g_ActiveWpn, invoker))
		return FMRES_IGNORED
	if(get_user_weapon(invoker) != CSW_REFERENCE)
		return FMRES_IGNORED

	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)

	return FMRES_SUPERCEDE
}

public fw_SetModel(entity, const model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED

	static Classname[32]
	pev(entity, pev_classname, Classname, charsmax(Classname))

	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED

	static iOwner
	iOwner = pev(entity, pev_owner)

	if(!is_user_connected(iOwner))
		return FMRES_IGNORED

	if(equal(model, OLD_REFERENCE))
	{
		static weapon; weapon = fm_find_ent_by_owner(-1, WEAPON_REFERENCE, entity)

		if(!pev_valid(weapon))
			return FMRES_IGNORED

		if(Get_BitVar(g_ActiveWpn, iOwner))
		{
			set_pev(weapon, pev_impulse, WEAPON_IMPULSE)
			engfunc(EngFunc_SetModel, entity, WORLDMODEL)
			set_pev(entity, pev_body, BODY_NUM)
			
			// The player no longer owns the custom weapon: drop the state and restore the default m4a1 HUD
			CSOWPN_Remove(iOwner)

			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

public fw_Entity_Think(ent)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	if(pev(ent, pev_iuser4) != ENTITY_KEY)
		return FMRES_IGNORED

	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))
	
	if(equal(classname, MUZZLEFLASH_A))
	{
		Entity_Think_MuzzA(ent)
		return FMRES_SUPERCEDE
	}
	
	if(equal(classname, EF_REVIVE_CLASSNAME))
	{
		Entity_Think_Revive(ent)
		return FMRES_SUPERCEDE
	}
	
	if(equal(classname, EF_FIELD_CLASSNAME))
	{
		Entity_Think_EF_Field(ent)
		return FMRES_SUPERCEDE
	}
	
	return FMRES_IGNORED
}
/*========================= hamsandwich ===================== */
public fw_Spawn_Post(id)
{
	if(!is_user_connected(id))
		return

	CSOWPN_ResetState(id)
	g_LastDamageTime[id] = 0.0
	
	// Ham_Spawn also fires for dead players (e.g. on team join), so only continue when really alive
	if(!is_user_alive(id))
		return
	
	// A new round gives the revive chances back to whoever still holds the weapon
	if(Get_BitVar(g_ActiveWpn, id))
	{
		g_ChanceRevive[id] = CHANCE_REVIVE
		
		WeaponList_Set(id)
		SecAmmo_UpdateHud(id)
	}
	
	// Fallback origin. It is only used if the player never stands on the ground
	// while the revive state is active (see Revive_TrySaveOrigin).
	pev(id, pev_origin, g_SavedOrigin[id])
	Set_BitVar(g_HasSavedOrigin, id)
}

// Saves the revive origin ONCE per revive state, the first time the player is on the ground.
// No task and no per-frame forward: this is only called from events that already happen
// (revive activation, weapon switch/shot events, the weapon's own PostFrame and damage taken),
// and it exits on a bit check.
stock Revive_TrySaveOrigin(id)
{
	if(!Get_BitVar(g_ActiveRevive, id) || Get_BitVar(g_RevivePosSaved, id))
		return

	if(!is_user_alive(id) || !(pev(id, pev_flags) & FL_ONGROUND))
		return

	pev(id, pev_origin, g_SavedOrigin[id])
	Set_BitVar(g_HasSavedOrigin, id)
	Set_BitVar(g_RevivePosSaved, id)
}

// Remember when a player in revive state takes damage (any type: bullet, fall, explosion, world...).
// If the player dies in this very same frame, fw_Killed_Pre knows the death came from damage.
public fw_TakeDamage_Pre(victim, inflictor, attacker, Float:damage, damagebits)
{
	if(!(1 <= victim <= g_MaxPlayers))
		return HAM_IGNORED
	if(!Get_BitVar(g_ActiveWpn, victim) || !Get_BitVar(g_ActiveRevive, victim))
		return HAM_IGNORED

	// Extra chance to save the origin if the player was in the air until now
	Revive_TrySaveOrigin(victim)

	g_LastDamageTime[victim] = get_gametime()

	return HAM_IGNORED
}

// Auto revive: a fatal hit is cancelled while the revive state is active and a chance is left.
public fw_Killed_Pre(id, attacker, shouldgib)
{
	if(!is_user_connected(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_ActiveWpn, id) || !Get_BitVar(g_ActiveRevive, id))
		return HAM_IGNORED
	if(g_ChanceRevive[id] <= 0)
		return HAM_IGNORED
	
	// Only revive when the death comes from damage, not from suicide ("kill"), slay or team change
	if(g_LastDamageTime[id] != get_gametime())
		return HAM_IGNORED

	Player_AutoRevive(id)

	// Cancel the death
	return HAM_SUPERCEDE
}

public fw_Killed_Post(id)
{
	// Post hooks still run when fw_Killed_Pre returned HAM_SUPERCEDE.
	// If the player is alive here, the death was cancelled by the revive: do nothing.
	if(is_user_alive(id))
		return

	// Real death: the weapon is gone, so drop every weapon state
	CSOWPN_Remove(id)
	CSOWPN_ResetState(id)
	g_ChanceRevive[id] = 0
	g_LastDamageTime[id] = 0.0
}

public Ham_CWeapon_Deploy_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id)) return

	set_pev(id, pev_viewmodel2, VIEWMODELA)
	set_pev(id, pev_weaponmodel2, PLAYERMODEL)
	
	// HUD: custom weapon list + secondary ammo (it keeps recharging while the weapon is not held)
	WeaponList_Set(id)
	SecAmmo_Update(id)
	SecAmmo_UpdateHud(id)
	
	util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ?  ANIM_REVIVE_DRAW : ANIM_DRAW)

	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, 1.5, linux_diff_weapon)
}

public Ham_CWeapon_AddToPlayer_Post(ent, id)
{
	if(!pev_valid(ent) || !is_user_connected(id))
		return

	if(pev(ent, pev_impulse) == WEAPON_IMPULSE)
	{
		Set_BitVar(g_ActiveWpn, id)
		set_pev(ent, pev_impulse, 0)
		
		// A picked up weapon comes with full secondary ammo
		g_SecAmmo[id] = WP_SECAMMO_MAX
		WeaponList_Set(id)
		SecAmmo_UpdateHud(id)

		if(get_user_weapon(id) == CSW_REFERENCE)
			Ham_CWeapon_Deploy_Post(ent)
	}
}

public Ham_CWeapon_Holster_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id)) return
	
	// Switching weapons does NOT cancel the revive state, only mode B and the shot counter
	g_ShootCount[id] = 0
	ModeB_Cancel(id)
	
	Revive_TrySaveOrigin(id)
}

public Ham_CWeapon_PostFrame_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	if(get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon) && get_pdata_float(id, m_flNextAttack, linux_diff_player) <= 0.0)
	{
		new iClip = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
		new iBp = cs_get_user_bpammo(id, CSW_REFERENCE)
		new j = min(WP_CLIP - iClip, iBp)

		set_pdata_int(ent, m_Weapon_iClip, iClip + j, linux_diff_weapon)
		cs_set_user_bpammo(id, CSW_REFERENCE, iBp - j)
		set_pdata_int(ent, m_Weapon_fInReload, 0, linux_diff_weapon)
	}

	// Runs every frame, but only while this weapon is held, and exits on a bit check
	Revive_TrySaveOrigin(id)

	CWeapon_System(id, ent, pev(id, pev_button))

	return HAM_IGNORED
}

public Ham_CWeapon_Idle_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	if(get_pdata_float(ent, m_Weapon_flTimeWeaponIdle, linux_diff_weapon) > 0.0)
		return HAM_SUPERCEDE

	util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ? ANIM_REVIVE_IDLE : ANIM_IDLE)

	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 20.0, linux_diff_weapon)
	return HAM_SUPERCEDE
}

public Ham_CWeapon_Reload_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	g_ReClip[id] = -1

	if(cs_get_user_bpammo(id, CSW_REFERENCE) <= 0)
		return HAM_SUPERCEDE

	new iClip = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
	if(iClip >= WP_CLIP)
		return HAM_SUPERCEDE

	g_ReClip[id] = iClip
	return HAM_IGNORED
}

public Ham_CWeapon_Reload_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED
	if(g_ReClip[id] == -1)
		return HAM_IGNORED

	// Reloading cancels any ongoing mode B sequence (beams removed, normal viewmodel back)
	ModeB_Cancel(id, true)

	set_pdata_int(ent, m_Weapon_iClip, g_ReClip[id], linux_diff_weapon)
	set_pdata_int(ent, m_Weapon_fInReload, 1, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, WP_RELOAD_TIME + 0.5, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, WP_RELOAD_TIME, linux_diff_player)

	util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ? ANIM_REVIVE_RELOAD : ANIM_RELOAD)

	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	pev(id, pev_punchangle, g_Recoil[id])
	g_Clip[id] = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
	
	set_pdata_int(ent, m_Weapon_iShotsFired, 0, linux_diff_weapon)

	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	// no bullet was fired
	if(g_Clip[id] <= get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon))
		return HAM_IGNORED

	new Float:Push[3]
	pev(id, pev_punchangle, Push)
	xs_vec_sub(Push, g_Recoil[id], Push)
	xs_vec_mul_scalar(Push, WP_RECOIL, Push)
	xs_vec_add(Push, g_Recoil[id], Push)
	set_pev(id, pev_punchangle, Push)
	
	util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ? ANIM_REVIVE_SHOOTA : ANIM_SHOOTA)
	emit_sound(id, CHAN_WEAPON, SND_SHOOTA, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	// Count shots toward the revive state, only while a chance is left and the state is not active yet
	if(g_ChanceRevive[id] > 0 && !Get_BitVar(g_ActiveRevive, id))
	{
		if(++g_ShootCount[id] >= REVIVE_SHOOT_COUNT)
		{
			Set_BitVar(g_ActiveRevive, id)
			
			// The revive origin is saved once, the next time the player is on the ground
			UnSet_BitVar(g_RevivePosSaved, id)
			Revive_TrySaveOrigin(id)
		}
	}
	
	new Float:aimOrigin[3]
	fm_get_aim_origin(id, aimOrigin)
	
	UTIL_Explosion(aimOrigin, SPR_EXP, 7, 20, TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES | TE_EXPLFLAG_NODLIGHTS)
	Radius_Damage(id, id, aimOrigin, RADIUS_EXP, get_pcvar_float(cvar_dmg_exp), WEAPON_LASER_EXP_DMGTYPE, get_pcvar_float(cvar_kb_exp))
	EmitSound_FromPos(aimOrigin, SND_EXP, VOL_NORM, ATTN_NORM)
	
	CreateEntityMuzzleFlash(id, 1, MUZZLEFLASH_A, MF_A_MODEL, 0.06)
	
	new Float:flDelay = get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) * WP_SPEED_A
	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, flDelay, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, flDelay, linux_diff_player)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, flDelay, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, flDelay + 1.0, linux_diff_weapon)
	
	return HAM_IGNORED
}

public Ham_CWeapon_SecondaryAttack_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	// Block the default m4a1 secondary attack (silencer toggle).
	// Mode B is handled manually in CWeapon_System.
	return HAM_SUPERCEDE
}
/*========================= System ===================== */
// Handles weapon mode B (IN_ATTACK2). Called every frame from Ham_Item_PostFrame.
// Flow: IN_ATTACK2 pressed -> START animation -> repeated SHOOTB shots while held (1 secondary ammo each)
//       -> on release, or when the secondary ammo is empty -> FAIL (end) animation + short recovery time.
public CWeapon_System(id, ent, button)
{
	if(!is_user_alive(id)) return
	if(!pev_valid(ent)) return
	if(!Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_REFERENCE) return
	
	// Secondary ammo recharge (timestamp based, no task)
	SecAmmo_Update(id)
	
	// Do nothing while reloading (the reload hook already cancels mode B)
	if(get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon)) return
	
	if(button & IN_ATTACK2)
	{
		// Out of ammo: mode B already ended, it stays locked until attack2 is released
		if(g_AttackState[id] == STATE_SHOOTB_FAIL)
			return
		
		// Wait until the weapon and the player are ready again
		if(get_pdata_float(id, m_flNextAttack, linux_diff_player) > 0.0 
		|| get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) > 0.0)
			return
		
		// Mode B can only be used while there is secondary ammo left.
		// Empty: go straight to the FAIL animation (once) and wait for the button to be released.
		if(g_SecAmmo[id] <= 0)
		{
			g_AttackState[id] = STATE_SHOOTB_FAIL
			ModeB_End(id, ent)
			return
		}
		
		new Float:flDelay
		
		switch(g_AttackState[id])
		{
			case STATE_SHOOTB_START:
			{
				g_AttackState[id] = STATE_SHOOTB
				flDelay = WP_SHOOTB_START_TIME
				
				util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ? ANIM_REVIVE_SHOOTB_START : ANIM_SHOOTB_START)
			}
			default: // STATE_SHOOTB
			{
				flDelay = 0.8
				
				SecAmmo_Consume(id)
				do_Laser_Shoot(id)
				CreateEntityMuzzleFlash(id, 1, MUZZLEFLASH_A, MF_B_MODEL, 0.04)
				CreateEntityMuzzleFlash(id, 2, MUZZLEFLASH_A, MF_B_MODEL, 0.04)
				CreateEntityMuzzleFlash(id, 3, MUZZLEFLASH_A, MF_B_MODEL, 0.04)
				CreateEntityMuzzleFlash(id, 4, MUZZLEFLASH_A, MF_B_MODEL, 0.04)
				util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ? ANIM_REVIVE_SHOOTB : ANIM_SHOOTB)
				set_pev(id, pev_viewmodel2, VIEWMODELB)
				emit_sound(id, CHAN_WEAPON, SND_SHOOTB, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			}
		}
		
		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, flDelay, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, flDelay, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, flDelay + 0.5, linux_diff_weapon)
	}
	else if(g_AttackState[id] != STATE_SHOOTB_START)
	{
		// The button was just released. Do this only once, not every frame.
		new iOldState = g_AttackState[id]
		g_AttackState[id] = STATE_SHOOTB_START
		
		Laser_RemoveBeams(id)
		
		// After running out of ammo the FAIL animation was already played
		if(iOldState == STATE_SHOOTB)
			ModeB_End(id, ent)
	}
}

do_Laser_Shoot(iPlayer)
{
	new Float:vecOrigin[3]
	pev(iPlayer, pev_origin, vecOrigin)

	new iVictim = -1
	new iVictimCounter

	while((iVictim = fm_find_ent_in_sphere(iVictim, vecOrigin, WEAPON_LASER_RANGE)) != 0)
	{
		if(iVictim == iPlayer) continue
		if(!Laser_IsValidTarget(iPlayer, iVictim)) continue

		new Float:vecVictim[3]
		pev(iVictim, pev_origin, vecVictim)

		Laser_DrawBeams(iPlayer, vecVictim)
		UTIL_Explosion(vecVictim, SPR_EXP2, 1, 20, TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES | TE_EXPLFLAG_NODLIGHTS)
		ExecuteHamB(Ham_TakeDamage, iVictim, iPlayer, iPlayer, get_pcvar_float(cvar_dmg_laser), WEAPON_LASER_DAMAGE_TYPE)
		Stock_KnockBack(iVictim, iPlayer, get_pcvar_float(cvar_kb_laser))

		if(++iVictimCounter >= WEAPON_LASER_MAX_VICTIMS) break
	}

	// At least one victim was hit, nothing else to do
	if(iVictimCounter)
		return

	new Float:vecAim[3]
	fm_get_aim_origin(iPlayer, vecAim)

	Laser_DrawBeams(iPlayer, vecAim)
	UTIL_Explosion(vecAim, SPR_EXP2, 1, 20, TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES | TE_EXPLFLAG_NODLIGHTS)

	iVictim = -1
	while((iVictim = fm_find_ent_in_sphere(iVictim, vecAim, WEAPON_LASER_EXP_RADIUS)) != 0)
	{
		if(iVictim == iPlayer) continue
		if(!Laser_IsValidTarget(iPlayer, iVictim)) continue

		ExecuteHamB(Ham_TakeDamage, iVictim, iPlayer, iPlayer, get_pcvar_float(cvar_dmg_exp), WEAPON_LASER_EXP_DMGTYPE)
		Stock_KnockBack(iVictim, iPlayer, get_pcvar_float(cvar_kb_laser))
	}
}

Player_AutoRevive(id)
{
	EF_Revive_Field(id)
	Revive_Screen_Draw(id)
	
	if(g_ChanceRevive[id] > 0)
		g_ChanceRevive[id]--

	// Health is <= 0 at this point, restore it first so the player counts as alive again
	set_pev(id, pev_health, float(WP_REVIVE_HEALTH))
	set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})

	// Move the player back to the origin saved while the revive state was active
	if(Get_BitVar(g_HasSavedOrigin, id))
	{
		new Float:ReviveOrigin[3]
		xs_vec_copy(g_SavedOrigin[id], ReviveOrigin)
		ReviveOrigin[2] += 2.0

		engfunc(EngFunc_SetOrigin, id, ReviveOrigin)
	}

	// The revive state is consumed. A new one needs REVIVE_SHOOT_COUNT shots again
	UnSet_BitVar(g_ActiveRevive, id)
	UnSet_BitVar(g_RevivePosSaved, id)
	g_ShootCount[id] = 0
	ModeB_Cancel(id)
	g_LastDamageTime[id] = 0.0
	
	EF_Revive(id)

	emit_sound(id, CHAN_ITEM, SND_REVIVE, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	if(get_user_weapon(id) != CSW_REFERENCE)
		return

	// Back to the normal viewmodel (mode B may have been active) and play the revive animation
	set_pev(id, pev_viewmodel2, VIEWMODELA)
	util_sendweaponanim(id, ANIM_REVIVE)

	new ent = fm_get_user_weapon_entity(id, CSW_REFERENCE)
	if(!pev_valid(ent))
		return

	// Lock the weapon while the revive animation plays
	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, WP_REVIVE_TIME, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, WP_REVIVE_TIME, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, WP_REVIVE_TIME, linux_diff_player)
}

/*========================= Mode B helpers ===================== */
// Ends mode B: removes the laser beams, plays the FAIL animation and applies the recovery time.
// The caller sets g_AttackState.
stock ModeB_End(id, ent)
{
	Laser_RemoveBeams(id)
	
	util_sendweaponanim(id, Get_BitVar(g_ActiveRevive, id) ? ANIM_REVIVE_SHOOTB_FAIL : ANIM_SHOOTB_FAIL)
	set_pev(id, pev_viewmodel2, VIEWMODELA)
	
	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, WP_SHOOTB_FAIL_TIME, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, WP_SHOOTB_FAIL_TIME, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, WP_SHOOTB_FAIL_TIME + 0.5, linux_diff_weapon)
}

// Silently cancels mode B (no animation): reload, weapon switch, revive, death...
stock ModeB_Cancel(id, bool:bRestoreModel = false)
{
	if(g_AttackState[id] == STATE_SHOOTB_START)
		return
	
	g_AttackState[id] = STATE_SHOOTB_START
	Laser_RemoveBeams(id)
	
	if(bRestoreModel && is_user_alive(id))
		set_pev(id, pev_viewmodel2, VIEWMODELA)
}

// TE_KILLBEAM removes every beam attached to the player entity
stock Laser_RemoveBeams(id)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_KILLBEAM)
	write_short(id)
	message_end()
}

/*========================= Secondary ammo / WeaponList ===================== */
// Recharges 1 ammo every WP_SECAMMO_RECHARGE seconds.
// No task and no PreThink: the elapsed time is evaluated when needed (every frame while the weapon
// is held, and on deploy), so the ammo also recharges while another weapon is held.
stock SecAmmo_Update(id)
{
	if(g_SecAmmo[id] >= WP_SECAMMO_MAX)
		return
	
	new iGain = floatround((get_gametime() - g_SecAmmoTime[id]) / WP_SECAMMO_RECHARGE, floatround_floor)
	if(iGain <= 0)
		return
	
	g_SecAmmoTime[id] += float(iGain) * WP_SECAMMO_RECHARGE
	g_SecAmmo[id] = min(g_SecAmmo[id] + iGain, WP_SECAMMO_MAX)
	
	SecAmmo_UpdateHud(id)
}

stock SecAmmo_Consume(id)
{
	if(g_SecAmmo[id] <= 0)
		return
	
	// The recharge timer starts when the ammo leaves the full state
	if(g_SecAmmo[id] >= WP_SECAMMO_MAX)
		g_SecAmmoTime[id] = get_gametime()
	
	g_SecAmmo[id]--
	SecAmmo_UpdateHud(id)
}

// Sends the secondary ammo count to the vanilla CS 1.6 HUD
stock SecAmmo_UpdateHud(id)
{
	if(!is_user_connected(id))
		return
	
	message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoX, _, id)
	write_byte(WP_SECAMMO_ID)
	write_byte(g_SecAmmo[id])
	message_end()
}

// Custom WeaponList: HUD data from WEAPON_GENERIC (sprites/weapon_revivegun.txt)
stock WeaponList_Set(id)
{
	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string(WEAPON_TXT)
	write_byte(4)					// primary ammo id (556nato, same as the m4a1)
	write_byte(WP_BPAMMO)			// primary ammo max
	write_byte(WP_SECAMMO_ID)		// secondary ammo id
	write_byte(WP_SECAMMO_MAX)		// secondary ammo max
	write_byte(0)					// slot (0 = primary weapons)
	write_byte(6)					// position in the slot (same as the m4a1)
	write_byte(CSW_REFERENCE)		// weapon id
	write_byte(0)					// flags
	message_end()
}

// Default m4a1 WeaponList, used when the custom weapon is removed from the player
stock WeaponList_Restore(id)
{
	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string(WEAPON_REFERENCE)
	write_byte(4)
	write_byte(90)
	write_byte(-1)
	write_byte(-1)
	write_byte(0)
	write_byte(6)
	write_byte(CSW_REFERENCE)
	write_byte(0)
	message_end()
}

/*========================= Entities ===================== */
public Entity_Think_MuzzA(ent)
{
	if(!pev_valid(ent)) return FMRES_IGNORED
	
	new id; id = pev(ent, pev_owner)
	
	if(!Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_REFERENCE)
	{
		util_kill_entity(ent)
		return FMRES_IGNORED
	}
	
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	
	if(fFrame >= MF_A_FRAMEMAX)
	{
		util_kill_entity(ent)
		return FMRES_IGNORED
	}
	
	fFrame += 0.8
	set_pev(ent, pev_frame, fFrame)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return FMRES_IGNORED
}

EF_Revive(id)
{
	EF_Revive_RemoveAll(id)
	
	new Float:fTime = get_gametime()
	new Float:pOrigin[3], Float:pAngles[3], Float:vStart[3]
	pev(id, pev_origin, pOrigin)
	pev(id, pev_v_angle, pAngles)
	
	for(new i = 0; i < EF_REVIVE_COUNT; i++)
	{
		new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
		if(!pev_valid(ent)) continue
		
		engfunc(EngFunc_SetModel, ent, EF_REVIVE_MODEL)
		
		dllfunc(DLLFunc_Spawn, ent)
		
		new Float:fBase = pAngles[1] + (360.0 / float(EF_REVIVE_COUNT)) * float(i)
		EF_Revive_GetPosition(id, fBase, vStart)
		
		set_pev(ent, pev_classname, EF_REVIVE_CLASSNAME)
		set_pev(ent, pev_iuser4, ENTITY_KEY)
		set_pev(ent, pev_iuser1, i)								
		set_pev(ent, pev_owner, id)
		set_pev(ent, pev_fuser1, fTime + 0.0 * float(i))	
		set_pev(ent, pev_fuser2, fBase)
		
		engfunc(EngFunc_SetOrigin, ent, vStart)
		
		//movetype
		set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
		set_pev(ent, pev_solid, SOLID_NOT)
		
		//frames render, and scale
		set_pev(ent, pev_frame, 0.0)
		set_pev(ent, pev_scale, EF_REVIVE_SCALE)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, 255.0)
		
		// hidden until its turn
		set_pev(ent, pev_effects, EF_NODRAW)
		
		set_pev(ent, pev_nextthink, fTime + EF_REVIVE_THINK)
		
		g_ReviveEnt[id][i] = ent
	}
}

public Entity_Think_Revive(ent)
{
	if(!pev_valid(ent)) return FMRES_IGNORED
	
	new id; id = pev(ent, pev_owner)
	
	new Float:fTime = get_gametime()
	new Float:fShow, Float:fBase
	pev(ent, pev_fuser1, fShow)
	pev(ent, pev_fuser2, fBase)
	
	new Float:fElapsed = fTime - fShow
	
	if(fElapsed >= 0.0)
	{
		new Float:fFrame = fElapsed * EF_REVIVE_FPS
		
		if(fFrame >= EF_REVIVE_FRAMEMAX)
		{
			EF_Revive_KillEntity(ent)
			return FMRES_IGNORED
		}
		
		set_pev(ent, pev_frame, fFrame)
		
		new iEffects = pev(ent, pev_effects)
		if(iEffects & EF_NODRAW)
			set_pev(ent, pev_effects, iEffects & ~EF_NODRAW)
	}
	
	new Float:fNext = fElapsed + EF_REVIVE_THINK
	if(fNext < 0.0) fNext = 0.0
	
	new Float:vCur[3], Float:vTarget[3], Float:vPlayerVel[3], Float:vVel[3]
	pev(ent, pev_origin, vCur)
	pev(id, pev_velocity, vPlayerVel)
	
	EF_Revive_GetPosition(id, fBase + fNext * EF_REVIVE_ROT_SPEED, vTarget)
	
	xs_vec_mul_scalar(vPlayerVel, EF_REVIVE_THINK, vPlayerVel)
	xs_vec_add(vTarget, vPlayerVel, vTarget)
	
	if(get_distance_f(vCur, vTarget) > 150.0)
	{
		engfunc(EngFunc_SetOrigin, ent, vTarget)
		set_pev(ent, pev_velocity, Float:{0.0, 0.0, 0.0})
	}
	else
	{
		xs_vec_sub(vTarget, vCur, vVel)
		xs_vec_mul_scalar(vVel, 1.0 / EF_REVIVE_THINK, vVel)
		set_pev(ent, pev_velocity, vVel)
	}
	
	set_pev(ent, pev_nextthink, fTime + EF_REVIVE_THINK)
	
	return FMRES_IGNORED
}

EF_Revive_GetPosition(id, Float:fAngle, Float:vOut[3])
{
	pev(id, pev_origin, vOut)
	
	vOut[0] += floatcos(fAngle, degrees) * EF_REVIVE_RADIUS
	vOut[1] += floatsin(fAngle, degrees) * EF_REVIVE_RADIUS
	vOut[2] += EF_REVIVE_HEIGHT
}

EF_Revive_KillEntity(ent)
{
	new id = pev(ent, pev_owner)
	new idx = pev(ent, pev_iuser1)
	
	if(1 <= id <= g_MaxPlayers && 0 <= idx < EF_REVIVE_COUNT && g_ReviveEnt[id][idx] == ent)
		g_ReviveEnt[id][idx] = 0
	
	util_kill_entity(ent)
}

EF_Revive_RemoveAll(id)
{
	if(!(1 <= id <= g_MaxPlayers)) return
	
	static szClass[32]
	
	for(new i = 0; i < EF_REVIVE_COUNT; i++)
	{
		new ent = g_ReviveEnt[id][i]
		g_ReviveEnt[id][i] = 0
		
		if(ent <= 0 || !pev_valid(ent)) continue
		
		pev(ent, pev_classname, szClass, charsmax(szClass))
		if(!equal(szClass, EF_REVIVE_CLASSNAME) || pev(ent, pev_owner) != id) continue
		
		engfunc(EngFunc_RemoveEntity, ent)
	}
}

EF_Revive_Field(id)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent)) return
	
	set_pev(ent, pev_iuser4, ENTITY_KEY)
	engfunc(EngFunc_SetModel, ent, EF_FIELD_MODEL)
	set_pev(ent, pev_classname, EF_FIELD_CLASSNAME)
	
	//id and movetype
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_scale, 3.0)
	
	//origin (feet of the player)
	new Float:pOrigin[3], Float:pAngles[3], Float:pVel[3]
	EF_Field_GetPos(id, pOrigin, pAngles)
	pev(id, pev_velocity, pVel)

	set_pev(ent, pev_angles, pAngles)
	set_pev(ent, pev_velocity, pVel)
	engfunc(EngFunc_SetOrigin, ent, pOrigin)
	
	//Render and anims
	set_pev(ent, pev_sequence, EF_FIELD_SEQ)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_rendermode, EF_FIELD_RENDERMODE)
	set_pev(ent, pev_renderamt, EF_FIELD_RENDERAMT)
	
	dllfunc(DLLFunc_Spawn, ent)
	
	//removal
	set_pev(ent, pev_fuser1, get_gametime() + EF_FIELD_REMOVETIME)
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}

public Entity_Think_EF_Field(ent)
{
	if(!pev_valid(ent)) return FMRES_IGNORED
	
	new id; id = pev(ent, pev_owner)
	
	if(!Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_REFERENCE)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return HAM_IGNORED
	}
	
	new Float:pOrigin[3], Float:pAngles[3], Float:pVel[3]
	EF_Field_GetPos(id, pOrigin, pAngles)
	pev(id, pev_velocity, pVel)

	set_pev(ent, pev_angles, pAngles)
	set_pev(ent, pev_velocity, pVel)
	engfunc(EngFunc_SetOrigin, ent, pOrigin)

	new Float:fTImeRemove;pev(ent, pev_fuser1, fTImeRemove)
	new Float:RenderAmt;pev(ent, pev_renderamt, RenderAmt)
	
	if(get_gametime() >= fTImeRemove)
	{
		RenderAmt -= 25.0
	}
	
	set_pev(ent, pev_renderamt, RenderAmt)
	
	if(RenderAmt <= 0.0)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return HAM_IGNORED
	}
	
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
	
	return FMRES_IGNORED
}
/*========================= Stocks ===================== */

// Feet position and yaw-only angles of the player.
// origin Z is the hull center, so adding mins[2] (-36 standing, -18 ducking) gives the floor level.
stock EF_Field_GetPos(id, Float:vOrigin[3], Float:vAngles[3])
{
	new Float:vMins[3]

	pev(id, pev_origin, vOrigin)
	pev(id, pev_mins, vMins)
	vOrigin[2] += vMins[2] + 2.0

	pev(id, pev_angles, vAngles)
	vAngles[0] = 0.0	// no pitch
	vAngles[2] = 0.0	// no roll
}

// Knockback "backward only": pushes the victim straight away from the attacker, on the horizontal
// plane only. There is no vertical push unless flLift is given (optional, 0.0 by default).
// The push is added to the current velocity of the victim. Players only.
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
#else
	stock util_precache_sounds_from_model(const szModelPath[])
	{
		#pragma unused szModelPath
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

stock CreateEntityMuzzleFlash(id, iBody, const szClassname[], const szModel[], Float:fScale)
{
	new s; s = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(s)) return
	
	dllfunc(DLLFunc_Spawn, s)
	
	engfunc(EngFunc_SetModel, s, szModel)
	set_pev(s, pev_classname, szClassname)
	
	// key checked first by fw_Entity_Think
	set_pev(s, pev_iuser4, ENTITY_KEY)
	
	//owner
	set_pev(s, pev_owner, id)
	set_pev(s, pev_skin, id)
	set_pev(s, pev_aiment, id)
	set_pev(s, pev_body, iBody)
	
	//movetype
	set_pev(s, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(s, pev_solid, SOLID_NOT)
	
	//frame and scale
	set_pev(s, pev_frame, 0.0)
	set_pev(s, pev_framerate, 15.0)
	set_pev(s, pev_scale, fScale)
	
	//rendermode
	set_pev(s, pev_rendermode, kRenderTransAdd)
	set_pev(s, pev_renderamt, 255.0)
	
	//nextthink
	set_pev(s, pev_nextthink, get_gametime() + 0.04)
}

// fKnock > 0.0 also pushes the enemy players backward (see Stock_KnockBack)
stock Radius_Damage(id, inflictor, Float:vicOri[3], Float:fRadius, Float:fDamage, dmgbits, Float:fKnock = 0.0)
{
	new i = -1

	while((i = fm_find_ent_in_sphere(i, vicOri, fRadius)) != 0)
	{
		if(id == i) continue
		if(pev(i, pev_takedamage) == DAMAGE_NO) continue
		if(pev(i, pev_spawnflags) & BREAK_TRIGGER_ONLY) continue

		if(1 <= i <= g_MaxPlayers)
		{
			if(!is_user_alive(i)) continue
			if(get_user_team(i) == get_user_team(id)) continue
		}

		ExecuteHamB(Ham_TakeDamage, i, inflictor, id, fDamage, dmgbits)
		Stock_KnockBack(i, id, fKnock)
	}
}

stock UTIL_CreateBeamEntPoint(iPlayer, iAttachment, Float: flOrigin[3], iszModelIndex, iWidth, iRed, iGreen, iBlue)
{
    message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
    write_byte(TE_BEAMENTPOINT);
    write_short(iPlayer | iAttachment);
    engfunc(EngFunc_WriteCoord, flOrigin[0]);
    engfunc(EngFunc_WriteCoord, flOrigin[1]);
    engfunc(EngFunc_WriteCoord, flOrigin[2]);
    write_short(iszModelIndex) // Model index
    write_byte(0); // Framestart
    write_byte(0); // Framerate
    write_byte(9); // Life
    write_byte(iWidth * 4); // Width
    write_byte(6); // Noise
    write_byte(iRed); // Red
    write_byte(iGreen); // Green
    write_byte(iBlue); // Blue
    write_byte(255); // Alpha
    write_byte(60); // Speed
    message_end();
}

stock bool:Laser_IsValidTarget(iPlayer, iEnt)
{
	if(pev(iEnt, pev_takedamage) == DAMAGE_NO)
		return false

	if(1 <= iEnt <= g_MaxPlayers)
	{
		if(!is_user_alive(iEnt)) return false
		if(get_user_team(iEnt) == get_user_team(iPlayer)) return false
	}
	else if(pev(iEnt, pev_solid) == SOLID_BSP)
	{
		if(pev(iEnt, pev_spawnflags) & BREAK_TRIGGER_ONLY) return false
	}

	return true
}

// One beam per viewmodel attachment (1-4)
stock Laser_DrawBeams(iPlayer, Float:vecEnd[3])
{
	UTIL_CreateBeamEntPoint(iPlayer, 0x1000, vecEnd, g_iLaser, LASER_BEAM_WIDTH, 255, 255, 255)
	UTIL_CreateBeamEntPoint(iPlayer, 0x2000, vecEnd, g_iLaser, LASER_BEAM_WIDTH, 255, 255, 255)
	UTIL_CreateBeamEntPoint(iPlayer, 0x3000, vecEnd, g_iLaser, LASER_BEAM_WIDTH, 255, 255, 255)
	UTIL_CreateBeamEntPoint(iPlayer, 0x4000, vecEnd, g_iLaser, LASER_BEAM_WIDTH, 255, 255, 255)
}

stock Revive_Screen_Draw(id)
{

    message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenFade"), _, id);
    write_short(1<<11);   // duration
    write_short(1<<11);   // holdTime
    write_short(0);       // FFADE_IN
    write_byte(0);        // red
    write_byte(255);      // green
    write_byte(255);      // blue
    write_byte(100);      // alpha
    message_end();

    return PLUGIN_HANDLED;
}

stock Revive_Screen_Remove(id)
{
    message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenFade"), _, id);
    write_short(1<<1);
    write_short(0);
    write_short(0);
    write_byte(0);
    write_byte(0);
    write_byte(0);
    write_byte(0);
    message_end();
	
    return PLUGIN_HANDLED;
}

/*==================================================================================================== */
