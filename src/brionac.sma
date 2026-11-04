/* =========================================
-------- Plugin Datas and Headers ----------
========================================= */
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <engine>
#include <hamsandwich>
#include <cstrike>

//zbheroex from Dias Ultimate plugins pack https://forums.alliedmods.net/showthread.php?t=294818
#define USE_ZBHEROEX

#if defined USE_ZBHEROEX

#include <zombie_theheroex>

#endif

#define PLUGIN  "[CSO] Brionac"
#define VERSION "1.0"
#define AUTHOR  "Mellowzy"

/* ================= CSWPN Data ================= */
#define CSW_DIVINESPEAR CSW_KNIFE
#define weapon_divinespear "weapon_knife"
#define BRIONAC_AMMO_ID  15
#define OFFSET_AMMO_SLOT   376   // CBasePlayer::m_rgAmmo
#define OFFSET_LINUX_PLAYER 5
#define m_flTimeWeaponIdle      48
#define OFFSET_LINUX_WEAPONS    4

#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) (pev_valid(%0) == 2)

/* ================= End of CSWPN Data ================= */

/* ================= Resources ================= */
#define BRIONAC_V_MODEL "models/cso/v_divinespear.mdl"
#define BRIONAC_P_MODEL "models/cso/p_divinespear.mdl"
#define BRIONAC_TORNADO_MODEL "models/cso/ef_divinespear_tornado.mdl"
#define BRIONAC_SPEAR_MODEL "models/cso/ef_divinespear_spear.mdl"
#define BRIONAC_CHARGE_MODEL "models/cso/ef_divinespear_charge.mdl"
#define BRIONAC_CHARGE_MODEL2 "models/cso/ef_divinespear_chrg.mdl"
#define BRIONAC_MARK_SPR "sprites/cso/ef_divinespear_mark.spr"

new const ExtraSounds[][] =
{
	"weapons/divinespear_attack1.wav",
	"weapons/divinespear_attack4.wav",
	"weapons/divinespear_charging_end.wav",
	"weapons/divinespear_charging_start.wav",
	"weapons/beamgun_charge_shootB_end.wav",
	"weapons/beamgun_charge_shootB_end_idle.wav",
	"weapons/divinespear_draw.wav",
	"weapons/divinespear_end_shoot.wav",
	"weapons/divinespear_exp.wav",
	"weapons/divinespear_idle2.wav",
	"weapons/divinespear_idle2_2.wav",
	"weapons/divinespear_throw.wav",
	"weapons/divinespear_win1.wav",
	"weapons/mastercombat_wall.wav"
}

new const ExtraSprites[][] =
{
	"sprites/cso/640hud247.spr",
	"sprites/cso/ef_divinespear_exp.spr"
}

#define SND_SLASH      0
#define SND_SLASH4     1
#define SND_WALL       13

/* ================= End of Resources ================= */

/* ================= Multiplier ================= */
#define ALL_AOE_KNOCKBACK  5.0

#if defined USE_ZBHEROEX

#define BRIONAC_DAMAGE     190.0
#define BRIONAC_AOE_RADIUS 150.0
#define BRIONAC_AOE_DAMAGE 180.0

#define SPEAR_SPEED        2000.0
#define SPEAR_DAMAGE       180.0
#define SPEAR_RADIUS       65.0
#define SPEAR_AOE_RADIUS   300.0
#define SPEAR_AOE_DAMAGE   180.0

#define TORNADO_PULL_RADIUS     500.0
#define TORNADO_PULL_FORCE      550.0   // max horizontal pull speed (at the center)
#define TORNADO_PULL_MIN        220.0   // min pull speed at the edge (tornado moves at 255)
#define TORNADO_PULL_LIFT       30.0    // small hop for grounded victims outside the lift radius (beats ground friction)
#define TORNADO_PULL_HEIGHT     300.0   // victims further than this above/below the tornado base are ignored
#define TORNADO_LIFT_RADIUS     300.0   // horizontal range in which victims are lifted up
#define TORNADO_LIFT_SPEED      260.0   // upward speed while lifting
#define TORNADO_LIFT_HEIGHT     130.0   // lift until this high above the tornado base, then hover
#define TORNADO_DAMAGE_RADIUS   130.0
#define TORNADO_DAMAGE          60.0

#define TORNADO_SPEED           255.0
#define TORNADO_TURN_STR        0.12    // how fast the tornado turns toward the owner's aim per think (0.0 = never, 1.0 = instant)
#define TORNADO_LIFETIME        4.0
#define TORNADO_THINK_DELAY     0.05    // pull update rate (smooth)
#define TORNADO_DAMAGE_INTERVAL 0.1     // damage tick rate

// Damage over time (applied by spear explosion + tornado)
#define DOT_DURATION            4.0     // seconds the DoT lasts (refreshed while still being hit)
#define DOT_TICK_INTERVAL       0.5     // seconds between DoT ticks
#define DOT_DAMAGE              25.0     // damage per tick

#endif

#if !defined USE_ZBHEROEX

#define BRIONAC_DAMAGE     5.0
#define BRIONAC_AOE_RADIUS 80.0
#define BRIONAC_AOE_DAMAGE 15.0

#define SPEAR_SPEED        2000.0
#define SPEAR_DAMAGE       15.0
#define SPEAR_RADIUS       8.0
#define SPEAR_AOE_RADIUS   300.0
#define SPEAR_AOE_DAMAGE   15.0

#define TORNADO_PULL_RADIUS     500.0
#define TORNADO_PULL_FORCE      550.0   // max horizontal pull speed (at the center)
#define TORNADO_PULL_MIN        220.0   // min pull speed at the edge (tornado moves at 255)
#define TORNADO_PULL_LIFT       30.0    // small hop for grounded victims outside the lift radius (beats ground friction)
#define TORNADO_PULL_HEIGHT     300.0   // victims further than this above/below the tornado base are ignored
#define TORNADO_LIFT_RADIUS     300.0   // horizontal range in which victims are lifted up
#define TORNADO_LIFT_SPEED      260.0   // upward speed while lifting
#define TORNADO_LIFT_HEIGHT     130.0   // lift until this high above the tornado base, then hover
#define TORNADO_DAMAGE_RADIUS   130.0
#define TORNADO_DAMAGE          15.0

#define TORNADO_SPEED           255.0
#define TORNADO_TURN_STR        0.12    // how fast the tornado turns toward the owner's aim per think (0.0 = never, 1.0 = instant)
#define TORNADO_LIFETIME        4.0
#define TORNADO_THINK_DELAY     0.05    // pull update rate (smooth)
#define TORNADO_DAMAGE_INTERVAL 0.1     // damage tick rate

// Damage over time (applied by spear explosion + tornado)
#define DOT_DURATION            4.0     // seconds the DoT lasts (refreshed while still being hit)
#define DOT_TICK_INTERVAL       0.5     // seconds between DoT ticks
#define DOT_DAMAGE              2.0     // damage per tick

#endif

// Mark sprite above enemies that are burning (its lifetime = DOT_DURATION)
#define MARK_FRAMES             29.0    // number of frames in the sprite
#define MARK_FPS                30.0    // animation speed (frames per second)
#define MARK_SCALE              0.15    // sprite size
#define MARK_OFFSET_Z           15.0    // distance above the victim's head
#define MARK_THINK_DELAY        0.05    // follow + animation update rate

/* ================= End of Multiplier ================= */

/* ================= Entities ================= */
#define CLASSNAME_SPEAR    "brionac_spear"
#define CLASSNAME_TORNADO  "brionac_tornado"
#define CLASSNAME_CHARGE   "brionac_charge"
#define CLASSNAME_CHARGE2   "brionac_charge2"
#define CLASSNAME_DOT      "brionac_dot"      
#define CLASSNAME_MARK     "brionac_mark"

/* ================= End of Entities ================= */
#define CHARGE_TIME        3.0
#define COMBO_AMMO_REQ     25      // ammo needed to fire the combo
#define COMBO_AMMO_COST    25      // ammo spent by the combo
#define AMMO_MAX           100
#define AMMO_REGEN_PER_SEC 5
#define RELOAD_AMMO_COST   20
#define COMBO_DELAY        1.2     // also the combo cooldown
#define RELOAD_DELAY       0.8
#define RELOAD_IDLE        0.8
#define DEPLOY_TIME        0.8
#define ATTACK_DELAY       0.5
#define CHAIN_RESET_TIME   0.6
#define BRIONAC_REACH      180.0

#define BRIONAC_CONE_DOT   0.5
#define SPEAR_LIFETIME     3.0

#define SPEAR_TRACK_RADIUS 300.0   // enemy must be this close to be locked on
#define SPEAR_HOMING_STR   0.15    // steering blend PER THINK (0.0 = off, higher = sharper turns)
#define SPEAR_CONE_DOT     0.5     // lock-on cone vs. flight direction (0.5 = 60 deg half-angle)
#define SPEAR_THINK_DELAY  0.02    // smaller = smoother tracking (spear moves 2000 u/s)

#define CHARGE_RADIUS_DMG       8.0     // damage per tick while attached
#define CHARGE_RADIUS_RANGE     360.0    // damage radius around the charge entity
#define CHARGE_TICK_INTERVAL    0.1     // damage every 0.1s (10 ticks/sec)
#define CHARGE_OFFSET_Z         1.0     // vertical offset (float at chest height)
#define CHARGE2_PULSE_TIME      0.8     // one full fade in/out cycle of the second charge model
#define CHARGE2_THINK           0.03    // pulse update rate (smaller = smoother fade)
#define CHARGE2_ALPHA_MIN       30.0    // faintest point of the pulse
#define CHARGE2_ALPHA_MAX       200.0   // brightest point of the pulse

#define TORNADO_FADE_TIME       1.5
#define TORNADO_RENDER_AMT      200.0

#define TORNADO_SEQUENCE        0
#define TORNADO_FRAMERATE       2.0
#define TORNADO_SPIN_SPEED      720.0

/* ================= Config and Variables ================= */
enum
{
	ANIM_IDLE = 0,
	ANIM_DRAW,
	ANIM_SLASH1,
	ANIM_SLASH2,
	ANIM_SLASH3,
	ANIM_SLASH4,
	ANIM_STAB,
	ANIM_CHARGE_START,
	ANIM_RELEASE_LOOP,
	ANIM_RELEASE_SHOOT,
	ANIM_RELEASE_END,
	ANIM_RELEASE_SHOOT2,
	ANIM_THROW
}

enum
{
	MODE_NONE = 0,
	MODE_ATTACK,
	MODE_ATTACK1,
	MODE_ATTACK2,
	MODE_ATTACK3
}

enum
{
	STATE_NONE = 0,
	STATE_CHARGE_START,
	STATE_CHARGE_READY
}


new g_iMode[33]
new g_iCharge[33]
new g_iAnim[33]
new g_iWeapon[33]
new g_iOldButtons[33]
new g_iAmmo[33]
new g_bHasBrionac
new bool:g_bWaitRelease[33]
new bool:g_bComboFired[33]
new Float:g_flChargeStart[33]
new Float:g_flChainEnd[33]
new Float:g_flNextAttack[33]
new Float:g_flLastRegen[33]
new Float:g_flLastBrionacHit[33]
new g_msgAmmoX, g_msgWeaponList
new g_pcvFriendlyFire,g_iBloodSpray,g_iBloodDrop
new g_iChargeEnt[33], g_iCharge2Ent[33], g_iTornadoEnt[33], g_iDotEnt[33], g_iMarkEnt[33]

#if defined USE_ZBHEROEX
new g_divinespear
#endif

/* ================= End of Config and Variables ================= */


public plugin_precache()
{
	precache_model(BRIONAC_V_MODEL)
	precache_model(BRIONAC_P_MODEL)
	precache_model(BRIONAC_CHARGE_MODEL)
	precache_model(BRIONAC_CHARGE_MODEL2)
	precache_model(BRIONAC_SPEAR_MODEL)
	precache_model(BRIONAC_TORNADO_MODEL)
	precache_model(BRIONAC_MARK_SPR)
	
	precache_generic("sprites/knife_divinespear.txt")
	
	precache_model("sprites/cso/ef_divinespear_throw.spr")

	for(new i = 0; i < sizeof(ExtraSounds); i++)
		precache_sound(ExtraSounds[i])
	for(new i = 0; i < sizeof(ExtraSprites); i++)
		precache_model(ExtraSprites[i])
	
	g_iBloodSpray = precache_model("sprites/bloodspray.spr");
	g_iBloodDrop  = precache_model("sprites/blood.spr");
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_event("HLTV", "Event_RoundStart", "a", "1=0", "2=0");

	RegisterHam(Ham_Item_Deploy,       weapon_divinespear, "fw_Knife_Deploy_Post", 1)
	RegisterHam(Ham_Item_Holster,      weapon_divinespear, "fw_Knife_Holster_Post", 1)
	RegisterHam(Ham_Item_PostFrame,    weapon_divinespear, "fw_Knife_PostFrame")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_divinespear, "fw_Knife_WeaponIdle_Post", 1)
	RegisterHam(Ham_Item_AddToPlayer, weapon_divinespear, "fw_Knife_AddToPlayer_Post", 1)
	
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled_Post", 1)
	RegisterHam(Ham_Spawn,  "player", "fw_PlayerSpawn_Post", 1)

	register_forward(FM_CmdStart,         "fw_CmdStart")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_Think, "fw_Entity_Think")
	register_forward(FM_Touch, "fw_Entity_Touch")

	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")
	register_clcmd("get_brionac", "cmd_GiveBrionac")
	register_clcmd("knife_divinespear", "cmd_HookBrionac")

	g_pcvFriendlyFire = get_cvar_pointer("mp_friendlyfire")

	g_msgWeaponList = get_user_msgid("WeaponList")
	g_msgAmmoX = get_user_msgid("AmmoX")
	
#if defined USE_ZBHEROEX
 	g_divinespear = zbheroex_register_weapon("Brionac", WEAPON_MELEE, CSW_DIVINESPEAR, 0)
#endif
}

/* =========================================
----- End of Plugin Datas and Headers ------
========================================= */

/* =========================================
---------- Plugin Core Function ------------
========================================= */
public message_DeathMsg(msg_id, msg_dest, msg_ent)
{
	static szWeapon[64]
	get_msg_arg_string(4, szWeapon, charsmax(szWeapon))

	if (!equal(szWeapon, "knife"))
		return PLUGIN_CONTINUE

	static iKiller; iKiller = get_msg_arg_int(1)
	if (!is_user_connected(iKiller))
		return PLUGIN_CONTINUE

	if (!Get_BitVar(g_bHasBrionac, iKiller))
		return PLUGIN_CONTINUE

	new bool:bRecentHit = (g_flLastBrionacHit[iKiller] > 0.0
		&& get_gametime() - g_flLastBrionacHit[iKiller] <= 1.0)

	if (get_user_weapon(iKiller) != CSW_DIVINESPEAR && !bRecentHit)
		return PLUGIN_CONTINUE

	set_msg_arg_string(4, "knife")
	return PLUGIN_CONTINUE
}

#if defined USE_ZBHEROEX
public zbheroex_weapon_bought(id, ItemID)
{
	if(ItemID == g_divinespear) cmd_GiveBrionac(id)
}

public zbheroex_weapon_remove(id, ItemID)
{
	if(ItemID == g_divinespear) cmd_RemoveBrionac(id)
}
#endif

public Event_RoundStart()
{
	DeleteEntityByClassnames(CLASSNAME_SPEAR)
	DeleteEntityByClassnames(CLASSNAME_TORNADO)
	DeleteEntityByClassnames(CLASSNAME_CHARGE)
	DeleteEntityByClassnames(CLASSNAME_CHARGE2)
	DeleteEntityByClassnames(CLASSNAME_MARK)
	DeleteEntityByClassnames(CLASSNAME_DOT)	
}

public cmd_GiveBrionac(id)
{
	if (!is_user_alive(id))
		return PLUGIN_HANDLED

	new knife = find_ent_by_owner(-1, weapon_divinespear, id)
	if (!knife)
		return PLUGIN_HANDLED

	ResetState(id)
	Set_BitVar(g_bHasBrionac, id)
	g_iWeapon[id]     = knife
	g_iAmmo[id]       = 5
	g_flLastRegen[id] = get_gametime()
	
	SendBrionacWeaponList(id)
	SyncAmmoX(id)

	if (get_user_weapon(id) == CSW_DIVINESPEAR)
		ExecuteHamB(Ham_Item_Deploy, knife)
	else
		engclient_cmd(id, weapon_divinespear)

	return PLUGIN_HANDLED
}

public cmd_RemoveBrionac(id)
{
	UnSet_BitVar(g_bHasBrionac, id)
	ResetState(id)
}

public cmd_HookBrionac(id)
{
	engclient_cmd(id, weapon_divinespear)
	return PLUGIN_HANDLED
}

public fw_PlayerKilled_Post(id, attacker, shouldgib)
{
	if (Get_BitVar(g_bHasBrionac, id))
		SendDefaultKnifeWeaponList(id)

	ClearDot(id)
	ResetState(id)
}

public fw_PlayerSpawn_Post(id)
{
	ClearDot(id)
}

public client_disconnected(id)
{
	ClearDot(id)
	ResetState(id)
}

public fw_CmdStart(id, uc_handle, seed)
{
	if (!is_user_alive(id) || !Get_BitVar(g_bHasBrionac, id))
		return FMRES_IGNORED

	if (get_user_weapon(id) != CSW_DIVINESPEAR)
		return FMRES_IGNORED

	new buttons = get_uc(uc_handle, UC_Buttons)
	new pressed = buttons & ~g_iOldButtons[id]
	g_iOldButtons[id] = buttons

	if (buttons & (IN_ATTACK | IN_ATTACK2))
		set_uc(uc_handle, UC_Buttons, buttons & ~(IN_ATTACK | IN_ATTACK2))

	new bool:bAttack  = (buttons & IN_ATTACK)  != 0
	new bool:bAttack2 = (buttons & IN_ATTACK2) != 0
	new Float:gt = get_gametime()

	if (!bAttack2)
		g_bWaitRelease[id] = false

	if ((pressed & IN_RELOAD)
		&& g_iCharge[id] == STATE_NONE
		&& gt >= g_flNextAttack[id]
		&& g_iAmmo[id] >= RELOAD_AMMO_COST)
	{
		Brionac_Reload(id)
		return FMRES_IGNORED
	}

	// Combo: hold right-click (charging) + left-click. Has its own cooldown (COMBO_DELAY).
	if (bAttack && bAttack2
		&& g_iCharge[id] == STATE_CHARGE_START
		&& gt >= g_flNextAttack[id]
		&& g_iAmmo[id] >= COMBO_AMMO_REQ)
	{
		Brionac_Combo(id)
		return FMRES_IGNORED
	}

	if (bAttack2)
	{
		switch (g_iCharge[id])
		{
			case STATE_NONE:
			{
				if (!g_bWaitRelease[id] && gt >= g_flNextAttack[id])
				{
					g_iCharge[id]       = STATE_CHARGE_START
					g_bComboFired[id]   = false
					g_flChargeStart[id] = gt
					WE_Divinespear(id, ANIM_CHARGE_START)
					Set_Weapon_Idle(id, 20.0)
					emit_sound(id, CHAN_ITEM, ExtraSounds[10], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
					
					SpawnChargeEntity(id)
					SpawnCharge2Entity(id)
				}
			}
			case STATE_CHARGE_START:
			{
				// after a combo the charge must not turn into a free "ready" shot
				if (!g_bComboFired[id] && gt - g_flChargeStart[id] >= CHARGE_TIME)
				{
					g_iCharge[id] = STATE_CHARGE_READY
					WE_Divinespear(id, ANIM_RELEASE_END)
					emit_sound(id, CHAN_ITEM, ExtraSounds[9], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				}
			}
		}
	}
	else if (g_iCharge[id] != STATE_NONE)
	{
		if (g_bComboFired[id])
		{
			// combo already used this charge: releasing does nothing extra
			g_bComboFired[id] = false
			g_iMode[id]       = MODE_NONE
		}
		else if (g_iCharge[id] == STATE_CHARGE_READY)
			Brionac_ReleaseShoot(id)
		else
			Brionac_ReleaseStab(id)

		g_iCharge[id] = STATE_NONE
	}

	if (bAttack && !bAttack2 && g_iCharge[id] == STATE_NONE && gt >= g_flNextAttack[id])
	{
		Brionac_Attack(id)
	}

	return FMRES_IGNORED
}

/* =========================================
------- End of Weapon Core Function --------
========================================= */

/* =========================================
---------- Entities and Specials -----------
========================================= */
SpawnSpear(id)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));

	if (!IsValidPev(ent))
		return

	new Float: vecOrigin[3]; UTIL_GetEyePosition(id, vecOrigin);
	new Float: vecDirection[3]; UTIL_GetVectorAiming(id, vecDirection);

	xs_vec_add_scaled(vecOrigin, vecDirection, 15.0, vecOrigin);

	engfunc(EngFunc_SetOrigin, ent, vecOrigin);
	engfunc(EngFunc_SetModel, ent, BRIONAC_SPEAR_MODEL);
	engfunc(EngFunc_SetSize, ent, Float: { -1.0, -1.0, -1.0 }, Float: { 1.0, 1.0, 1.0 });

	set_pev(ent, pev_classname, CLASSNAME_SPEAR);
	set_pev(ent, pev_movetype, MOVETYPE_FLY);
	set_pev(ent, pev_solid, SOLID_TRIGGER);
	set_pev(ent, pev_owner, id);

	xs_vec_mul_scalar(vecDirection, SPEAR_SPEED, vecDirection);
	set_pev(ent, pev_velocity, vecDirection);

	engfunc(EngFunc_VecToAngles, vecDirection, vecDirection);
	set_pev(ent, pev_angles, vecDirection);

	set_pev(ent, pev_rendermode, kRenderTransAdd);
	set_pev(ent, pev_renderamt, 200.0);
	set_pev(ent, pev_renderfx, kRenderFxNone);
	
	SpawnSpearTrail(ent, 3)
}

SpawnChargeEntity(id)
{
	// Kill any existing charge
	RemoveChargeEntity(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if (!IsValidPev(ent))
		return

	set_pev(ent, pev_classname, CLASSNAME_CHARGE)
	engfunc(EngFunc_SetModel, ent, BRIONAC_CHARGE_MODEL)
	set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(ent, pev_solid,     SOLID_NOT)
	set_pev(ent, pev_owner,     id)

	// Animation sequence - charge model's "loop" sequence
	set_pev(ent, pev_animtime,  get_gametime())
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_sequence,  0)
	set_pev(ent, pev_aiment, id)

	// Render - additive glow so it looks like energy
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt,  255.0)

	// Position at player
	new Float:vecOrigin[3]
	pev(id, pev_origin, vecOrigin)
	vecOrigin[2] += CHARGE_OFFSET_Z
	engfunc(EngFunc_SetOrigin, ent, vecOrigin)

	// Start ticks
	set_pev(ent, pev_nextthink, get_gametime() + CHARGE_TICK_INTERVAL)

	g_iChargeEnt[id] = ent
}

// second charge model: same attach as the first one, but pulses (fades in/out) every CHARGE2_PULSE_TIME
SpawnCharge2Entity(id)
{
	RemoveCharge2Entity(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if (!IsValidPev(ent))
		return

	set_pev(ent, pev_classname, CLASSNAME_CHARGE2)
	engfunc(EngFunc_SetModel, ent, BRIONAC_CHARGE_MODEL2)
	set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(ent, pev_solid,     SOLID_NOT)
	set_pev(ent, pev_owner,     id)

	set_pev(ent, pev_animtime,  get_gametime())
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_sequence,  0)
	set_pev(ent, pev_aiment,    id)

	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt,  CHARGE2_ALPHA_MIN)

	new Float:vecOrigin[3]
	pev(id, pev_origin, vecOrigin)
	vecOrigin[2] += CHARGE_OFFSET_Z
	engfunc(EngFunc_SetOrigin, ent, vecOrigin)

	// pev_fuser1 = pulse start time
	set_pev(ent, pev_fuser1, get_gametime())
	set_pev(ent, pev_nextthink, get_gametime() + CHARGE2_THINK)

	g_iCharge2Ent[id] = ent
}

RemoveCharge2Entity(id)
{
	new ent = g_iCharge2Ent[id]
	if (ent && IsValidPev(ent))
		engfunc(EngFunc_RemoveEntity, ent)

	g_iCharge2Ent[id] = 0
}

RemoveChargeEntity(id)
{
	new ent = g_iChargeEnt[id]
	if (ent && IsValidPev(ent))
		engfunc(EngFunc_RemoveEntity, ent)

	g_iChargeEnt[id] = 0
}

SpawnTornado(id)
{
	new Float:vecSrc[3], Float:vecOfs[3], Float:vecAng[3], Float:vecDir[3]

	pev(id, pev_origin,   vecSrc)
	pev(id, pev_view_ofs, vecOfs)
	pev(id, pev_v_angle,  vecAng)

	vecSrc[0] += vecOfs[0]
	vecSrc[1] += vecOfs[1]
	vecSrc[2] += vecOfs[2]

	Brionac_AngleVectors(vecAng, vecDir)

	// Ground position - drop to floor under eyes
	new Float:vecGround[3]
	vecGround[0] = vecSrc[0]
	vecGround[1] = vecSrc[1]
	vecGround[2] = vecSrc[2] - 9999.0

	new tr = create_tr2()
	engfunc(EngFunc_TraceLine, vecSrc, vecGround, IGNORE_MONSTERS, id, tr)
	get_tr2(tr, TR_vecEndPos, vecGround)
	free_tr2(tr)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if (!IsValidPev(ent))
		return

	set_pev(ent, pev_classname, CLASSNAME_TORNADO)
	engfunc(EngFunc_SetModel, ent, BRIONAC_TORNADO_MODEL)
	engfunc(EngFunc_SetOrigin, ent, vecGround)

	// MOVETYPE_FLY - smooth forward, no gravity
	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_solid,     SOLID_NOT)
	set_pev(ent, pev_owner,     id)

	// Forward velocity (flattened - no vertical)
	new Float:vecVel[3]
	vecVel[0] = vecDir[0] * TORNADO_SPEED
	vecVel[1] = vecDir[1] * TORNADO_SPEED
	vecVel[2] = 0.0
	set_pev(ent, pev_velocity, vecVel)

	// Animation loop
	set_pev(ent, pev_sequence,  TORNADO_SEQUENCE)
	set_pev(ent, pev_framerate, TORNADO_FRAMERATE)
	set_pev(ent, pev_animtime,  get_gametime())
	set_pev(ent, pev_body,      0)

	// Rendering
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt,  TORNADO_RENDER_AMT)

	// fuser1 = absolute expire time, fuser2 = next damage tick time
	set_pev(ent, pev_fuser1, get_gametime() + TORNADO_LIFETIME)
	set_pev(ent, pev_fuser2, 0.0)

	set_pev(ent, pev_nextthink, get_gametime() + TORNADO_THINK_DELAY)

	g_iTornadoEnt[id] = ent
	
	emit_sound(ent, CHAN_ITEM, ExtraSounds[12], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
}



/* ========================================
------- End of Entities and Specials ------
=========================================== */

public fw_Entity_Think(ent)
{
	if (!IsValidPev(ent))
		return FMRES_IGNORED

	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))
	
	if(equal(classname, CLASSNAME_SPEAR))
	{
		Entity_Think_Spear(ent)
	}
	else if(equal(classname, CLASSNAME_CHARGE))
	{
		new id = pev(ent, pev_owner)
		if (!id || !is_user_alive(id))
		{
			engfunc(EngFunc_RemoveEntity, ent)
			if (id > 0 && id < 33) g_iChargeEnt[id] = 0
			return FMRES_IGNORED
		}
		
		// Detach if the player is no longer in a charge state
		if (g_iCharge[id] != STATE_CHARGE_START && g_iCharge[id] != STATE_CHARGE_READY)
		{
			engfunc(EngFunc_RemoveEntity, ent)
			g_iChargeEnt[id] = 0
			return FMRES_IGNORED
		}
		
		// Follow the player every tick
		new Float:vecOrigin[3]
		pev(id, pev_origin, vecOrigin)
		vecOrigin[2] += CHARGE_OFFSET_Z
		engfunc(EngFunc_SetOrigin, ent, vecOrigin)
		set_pev(ent,pev_origin, vecOrigin)
		
		do_damages(id, CSW_DIVINESPEAR, vecOrigin, CHARGE_RADIUS_RANGE, CHARGE_RADIUS_DMG, (DMG_NEVERGIB | DMG_BULLET))
		
		
		set_pev(ent, pev_nextthink, get_gametime() + CHARGE_TICK_INTERVAL)
	}
	else if(equal(classname, CLASSNAME_CHARGE2))
	{
		new id = pev(ent, pev_owner)
		if (!(1 <= id <= 32) || !is_user_alive(id)
			|| (g_iCharge[id] != STATE_CHARGE_START && g_iCharge[id] != STATE_CHARGE_READY))
		{
			engfunc(EngFunc_RemoveEntity, ent)
			if (1 <= id <= 32) g_iCharge2Ent[id] = 0
			return FMRES_IGNORED
		}

		// cosine pulse: starts dim, peaks at half a period, dim again -> one fade cycle per CHARGE2_PULSE_TIME
		new Float:flStart
		pev(ent, pev_fuser1, flStart)
		new Float:flPhase = ((get_gametime() - flStart) / CHARGE2_PULSE_TIME) * 6.2831853
		new Float:flMix   = 0.5 - 0.5 * floatcos(flPhase, radian)
		set_pev(ent, pev_renderamt, CHARGE2_ALPHA_MIN + (CHARGE2_ALPHA_MAX - CHARGE2_ALPHA_MIN) * flMix)

		set_pev(ent, pev_nextthink, get_gametime() + CHARGE2_THINK)
	}
	else if(equal(classname, CLASSNAME_TORNADO))
	{
		Entity_Think_Tornado(ent)
	}
	else if(equal(classname, CLASSNAME_DOT))
	{
		Entity_Think_Dot(ent)
	}
	else if(equal(classname, CLASSNAME_MARK))
	{
		Entity_Think_Mark(ent)
	}
	
	return FMRES_IGNORED
}

Entity_Think_Tornado(ent)
{
	new id = pev(ent, pev_owner)
	new Float:fExpire, Float:fNextDmg
	new Float:gt = get_gametime()

	pev(ent, pev_fuser1, fExpire)
	pev(ent, pev_fuser2, fNextDmg)

	// Expired -> remove
	if (gt >= fExpire)
	{
		engfunc(EngFunc_RemoveEntity, ent)
		if (id > 0 && id < 33) g_iTornadoEnt[id] = 0
		return
	}

	// Fade out in the last TORNADO_FADE_TIME seconds
	new Float:fadeMult = 1.0
	if (gt >= fExpire - TORNADO_FADE_TIME)
	{
		fadeMult = (fExpire - gt) / TORNADO_FADE_TIME
		if (fadeMult < 0.0) fadeMult = 0.0
		if (fadeMult > 1.0) fadeMult = 1.0

		set_pev(ent, pev_renderamt, TORNADO_RENDER_AMT * fadeMult)
	}

	new bool:bHasOwner = (id > 0 && id < 33 && is_user_connected(id))

	// Damage ticks at its own (slower) rate than the pull
	new bool:bDoDamage = (gt >= fNextDmg)
	if (bDoDamage)
		set_pev(ent, pev_fuser2, gt + TORNADO_DAMAGE_INTERVAL)

	new inflictor = 0
	if (bHasOwner)
	{
		inflictor = fm_get_user_weapon_entity(id, CSW_DIVINESPEAR)
		if (!IsValidPev(inflictor))
			inflictor = 0
	}

	// --- Steer toward the owner's aim (horizontal only) ---
	if (bHasOwner && is_user_alive(id))
	{
		new Float:vecAng[3], Float:vecAim[3], Float:vecVel[3], Float:newDir[3]
		pev(id, pev_v_angle, vecAng)
		vecAng[0] = 0.0   // ignore pitch, the tornado stays on the ground
		Brionac_AngleVectors(vecAng, vecAim)

		pev(ent, pev_velocity, vecVel)
		vecVel[2] = 0.0
		new Float:curSpeed = vecLen(vecVel)

		if (curSpeed > 1.0)
		{
			newDir[0] = (vecVel[0] / curSpeed) * (1.0 - TORNADO_TURN_STR) + vecAim[0] * TORNADO_TURN_STR
			newDir[1] = (vecVel[1] / curSpeed) * (1.0 - TORNADO_TURN_STR) + vecAim[1] * TORNADO_TURN_STR
			newDir[2] = 0.0
			vecNormalize(newDir)
		}
		else
		{
			// stopped (hit a wall?) -> head straight where the owner looks
			newDir[0] = vecAim[0]
			newDir[1] = vecAim[1]
			newDir[2] = 0.0
		}

		vecVel[0] = newDir[0] * TORNADO_SPEED
		vecVel[1] = newDir[1] * TORNADO_SPEED
		vecVel[2] = 0.0
		set_pev(ent, pev_velocity, vecVel)
	}

	new Float:vecOrigin[3]
	pev(ent, pev_origin, vecOrigin)

	new maxplayers = get_maxplayers()
	for (new i = 1; i <= maxplayers; i++)
	{
		if (!is_user_alive(i))
			continue
		if (i == id)
			continue

		// Skip teammates if FF off
		if (bHasOwner && get_user_team(i) == get_user_team(id)
			&& !get_pcvar_num(g_pcvFriendlyFire))
			continue

		new Float:vecVicOrigin[3], Float:vecVicOfs[3]
		pev(i, pev_origin, vecVicOrigin)
		pev(i, pev_view_ofs, vecVicOfs)
		vecVicOrigin[2] += vecVicOfs[2] * 0.5

		new Float:height = vecVicOrigin[2] - vecOrigin[2]

		// horizontal vector victim -> tornado center
		new Float:vecPull[3]
		vecPull[0] = vecOrigin[0] - vecVicOrigin[0]
		vecPull[1] = vecOrigin[1] - vecVicOrigin[1]
		vecPull[2] = 0.0

		new Float:hDist = vecLen(vecPull)

		// --- Pull + Lift ---
		if (hDist <= TORNADO_PULL_RADIUS && floatabs(height) <= TORNADO_PULL_HEIGHT)
		{
			new Float:vecVicVel[3]
			pev(i, pev_velocity, vecVicVel)

			// horizontal pull (set directly, small additions get eaten by friction)
			if (hDist > 1.0)
			{
				vecNormalize(vecPull)

				new Float:pullStrength = TORNADO_PULL_FORCE * (1.0 - (hDist / TORNADO_PULL_RADIUS))
				if (pullStrength < TORNADO_PULL_MIN)
					pullStrength = TORNADO_PULL_MIN

				// slow down near the center so they don't jitter back and forth
				if (hDist < 60.0)
					pullStrength *= (hDist / 60.0)

				vecVicVel[0] = vecPull[0] * pullStrength
				vecVicVel[1] = vecPull[1] * pullStrength
			}

			// vertical: lift up inside the lift radius, then hover at TORNADO_LIFT_HEIGHT
			if (hDist <= TORNADO_LIFT_RADIUS)
			{
				if (height < TORNADO_LIFT_HEIGHT)
					vecVicVel[2] = TORNADO_LIFT_SPEED
				else
					vecVicVel[2] = 0.0
			}
			else if (pev(i, pev_flags) & FL_ONGROUND)
			{
				vecVicVel[2] = TORNADO_PULL_LIFT
			}

			set_pev(i, pev_velocity, vecVicVel)
		}

		// --- Damage (victims lifted up are still inside the tornado column) ---
		if (bDoDamage && bHasOwner && hDist <= TORNADO_DAMAGE_RADIUS
			&& height <= TORNADO_LIFT_HEIGHT + 80.0)
		{
			g_flLastBrionacHit[id] = gt
			ExecuteHamB(Ham_TakeDamage, i, inflictor, id, TORNADO_DAMAGE * fadeMult, (DMG_NEVERGIB | DMG_BULLET))
			Stock_Fake_KnockBack(id, i, ALL_AOE_KNOCKBACK)

			// start / refresh the damage over time + mark (DOT_DURATION seconds)
			Brionac_ApplyDot(i, id)
		}
	}

	set_pev(ent, pev_nextthink, get_gametime() + TORNADO_THINK_DELAY)
}

public fw_Entity_Touch(ent, other)
{
	if (!IsValidPev(ent))
		return FMRES_IGNORED

	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))

	if(equal(classname, CLASSNAME_SPEAR))
	{
		Entity_Touch_Spear(ent)
	}

	return FMRES_IGNORED
}

Entity_Think_Spear(ent)
{
    new Float:fExpire
    pev(ent, pev_dmgtime, fExpire)

    if (get_gametime() >= fExpire)
    {
        Entity_Remove(ent)
        return
    }

    new owner = pev(ent, pev_owner)

    new Float:vecOrigin[3], Float:vecCurVel[3]
    pev(ent, pev_origin, vecOrigin)
    pev(ent, pev_velocity, vecCurVel)

    new Float:curSpeed = vecLen(vecCurVel)

    if (curSpeed > 1.0 && SPEAR_HOMING_STR > 0.0)
    {
        new Float:oldDir[3]
        oldDir[0] = vecCurVel[0] / curSpeed
        oldDir[1] = vecCurVel[1] / curSpeed
        oldDir[2] = vecCurVel[2] / curSpeed

        new Float:vecAim[3]
        new target = pev(ent, pev_iuser2)
        new bool:bKeep = false

        // keep the current lock only while it is still an enemy, in range and not behind a wall
        if (target > 0 && Spear_IsEnemy(owner, target))
        {
            Spear_GetAimPos(target, vecAim)
            if (get_distance_f(vecOrigin, vecAim) <= SPEAR_TRACK_RADIUS
                && Spear_CanSee(ent, vecOrigin, vecAim))
                bKeep = true
        }

        // otherwise look for a new enemy in range
        if (!bKeep)
        {
            target = Spear_FindTarget(ent, owner, vecOrigin, oldDir)
            set_pev(ent, pev_iuser2, target)
        }

        if (target > 0)
        {
            Spear_GetAimPos(target, vecAim)

            new Float:vecToTarget[3]
            vecToTarget[0] = vecAim[0] - vecOrigin[0]
            vecToTarget[1] = vecAim[1] - vecOrigin[1]
            vecToTarget[2] = vecAim[2] - vecOrigin[2]
            vecNormalize(vecToTarget)

            new Float:newDir[3]
            newDir[0] = oldDir[0] * (1.0 - SPEAR_HOMING_STR) + vecToTarget[0] * SPEAR_HOMING_STR
            newDir[1] = oldDir[1] * (1.0 - SPEAR_HOMING_STR) + vecToTarget[1] * SPEAR_HOMING_STR
            newDir[2] = oldDir[2] * (1.0 - SPEAR_HOMING_STR) + vecToTarget[2] * SPEAR_HOMING_STR
            vecNormalize(newDir)

            new Float:vel[3]
            vel[0] = newDir[0] * curSpeed
            vel[1] = newDir[1] * curSpeed
            vel[2] = newDir[2] * curSpeed
            set_pev(ent, pev_velocity, vel)
        }
    }

    new Float:vecVel[3], Float:vecAng[3]
    pev(ent, pev_velocity, vecVel)
    if (vecLen(vecVel) > 0.1)
    {
        vecVel[0] *= -1.0
        vecVel[1] *= -1.0
        vecVel[2] *= -1.0
        engfunc(EngFunc_VecToAngles, vecVel, vecAng)
        vecAng[0] = -vecAng[0]
        set_pev(ent, pev_angles, vecAng)
    }

    set_pev(ent, pev_nextthink, get_gametime() + SPEAR_THINK_DELAY)
}

Entity_Touch_Spear(ent)
{
	if (!IsValidPev(ent))
		return

	new id = pev(ent, pev_owner)
	if (!is_user_alive(id) || !is_user_connected(id))
	{
		Entity_Remove(ent)
		return
	}

	Entity_Remove(ent)
}

Entity_Remove(ent)
{
	if (!IsValidPev(ent))
		return

	new Float:vecOrigin[3]
	pev(ent, pev_origin, vecOrigin)

	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, vecOrigin[0])
	engfunc(EngFunc_WriteCoord, vecOrigin[1])
	engfunc(EngFunc_WriteCoord, vecOrigin[2])
	write_short(engfunc(EngFunc_ModelIndex, ExtraSprites[1]))
	write_byte(20)
	write_byte(15)
	write_byte(TE_EXPLFLAG_NOSOUND)
	message_end()

	emit_sound(ent, CHAN_ITEM, ExtraSounds[8], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	new id = pev(ent, pev_owner)

	// only do the AoE damage if the owner is still a connected player,
	// but ALWAYS remove the entity below
	if (1 <= id <= 32 && is_user_connected(id))
	{
		new i = -1
		while ((i = fm_find_ent_in_sphere(i, vecOrigin, SPEAR_AOE_RADIUS)) != 0)
		{
			if (i == id) continue
			if (pev(i, pev_takedamage) == DAMAGE_NO) continue
			if (pev(i, pev_spawnflags) & SF_BREAK_TRIGGER_ONLY) continue
			
			if (1 <= i <= get_maxplayers())
			{
				if (!is_user_alive(i)) continue
				if (get_user_team(id) == get_user_team(i) && !get_pcvar_num(g_pcvFriendlyFire)) continue
			}
			
			ExecuteHamB(Ham_TakeDamage, i, id, id, SPEAR_AOE_DAMAGE, DMG_GENERIC)
			Stock_Fake_KnockBack(id, i, ALL_AOE_KNOCKBACK)

			// players hit by the explosion burn + get marked for DOT_DURATION seconds
			if (1 <= i <= 32)
			{
				g_flLastBrionacHit[id] = get_gametime()
				Brionac_ApplyDot(i, id)
			}
		}
	}

	engfunc(EngFunc_RemoveEntity, ent)
}

Brionac_ApplyDot(victim, attacker)
{
	if (!(1 <= victim <= 32) || victim == attacker)
		return
	if (!is_user_alive(victim) || !is_user_connected(attacker))
		return

	new Float:gt = get_gametime()
	new ent = g_iDotEnt[victim]

	// the mark above the head lives exactly as long as the DoT
	Brionac_ApplyMark(victim, gt + DOT_DURATION)

	// already burning -> just refresh the duration and the owner
	if (ent && IsValidPev(ent) && Dot_IsEntity(ent, victim))
	{
		set_pev(ent, pev_fuser1, gt + DOT_DURATION)
		set_pev(ent, pev_iuser2, attacker)
		return
	}

	ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if (!IsValidPev(ent))
		return

	set_pev(ent, pev_classname, CLASSNAME_DOT)
	set_pev(ent, pev_movetype,  MOVETYPE_NONE)
	set_pev(ent, pev_solid,     SOLID_NOT)

	set_pev(ent, pev_iuser1, victim)                  // who is burning
	set_pev(ent, pev_iuser2, attacker)                // who gets the kill
	set_pev(ent, pev_fuser1, gt + DOT_DURATION)       // when it ends
	set_pev(ent, pev_nextthink, gt + DOT_TICK_INTERVAL)

	g_iDotEnt[victim] = ent
}

// make sure a stored entity index still is OUR dot entity for that victim


// remove the DoT (and the mark) of a player (death, spawn, disconnect)
ClearDot(id)
{
	new ent = g_iDotEnt[id]
	g_iDotEnt[id] = 0

	if (ent && IsValidPev(ent) && Dot_IsEntity(ent, id))
		engfunc(EngFunc_RemoveEntity, ent)

	ClearMark(id)
}

// one tick of the DoT entity
Entity_Think_Dot(ent)
{
	new victim   = pev(ent, pev_iuser1)
	new attacker = pev(ent, pev_iuser2)
	new Float:fEnd
	new Float:gt = get_gametime()
	pev(ent, pev_fuser1, fEnd)

	// expired / victim dead / attacker left -> remove
	if (gt >= fEnd
		|| !(1 <= victim <= 32) || !is_user_alive(victim)
		|| !(1 <= attacker <= 32) || !is_user_connected(attacker))
	{
		if (1 <= victim <= 32)
		{
			if (g_iDotEnt[victim] == ent)
				g_iDotEnt[victim] = 0

			ClearMark(victim)
		}

		engfunc(EngFunc_RemoveEntity, ent)
		return
	}

	new inflictor = fm_get_user_weapon_entity(attacker, CSW_DIVINESPEAR)
	if (!IsValidPev(inflictor))
		inflictor = 0

	// keeps the "divinespear" kill icon for kills made by the DoT
	g_flLastBrionacHit[attacker] = gt

	ExecuteHamB(Ham_TakeDamage, victim, inflictor, attacker, DOT_DAMAGE, (DMG_NEVERGIB | DMG_BULLET))
	
	new Float: vicOri[3]
	pev(victim,pev_origin, vicOri)
	
	FX_Blood(vicOri, 77, 10)

	// the victim may have died from this tick (the Killed hook already cleaned up)
	if (!IsValidPev(ent) || !is_user_alive(victim))
	{
		ClearDot(victim)
		return
	}

	set_pev(ent, pev_nextthink, gt + DOT_TICK_INTERVAL)
}

// ==================================================================
// Mark: animated sprite above the head of burning enemies
// ==================================================================
// create the mark, or just extend its lifetime if it already exists
Brionac_ApplyMark(victim, Float:fEnd)
{
	new ent = g_iMarkEnt[victim]

	if (ent && IsValidPev(ent) && Mark_IsEntity(ent, victim))
	{
		set_pev(ent, pev_fuser1, fEnd)
		return
	}

	ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if (!IsValidPev(ent))
		return

	set_pev(ent, pev_classname, CLASSNAME_MARK)
	engfunc(EngFunc_SetModel, ent, BRIONAC_MARK_SPR)

	set_pev(ent, pev_movetype,   MOVETYPE_NONE)
	set_pev(ent, pev_solid,      SOLID_NOT)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt,  200.0)
	set_pev(ent, pev_scale,      MARK_SCALE)
	set_pev(ent, pev_frame,      0.0)

	set_pev(ent, pev_iuser1, victim)    // who wears the mark
	set_pev(ent, pev_fuser1, fEnd)      // when it disappears

	// first position: above the head
	new Float:vecOrigin[3], Float:vecMaxs[3]
	pev(victim, pev_origin, vecOrigin)
	pev(victim, pev_maxs, vecMaxs)
	vecOrigin[2] += vecMaxs[2] + MARK_OFFSET_Z
	engfunc(EngFunc_SetOrigin, ent, vecOrigin)

	set_pev(ent, pev_nextthink, get_gametime() + MARK_THINK_DELAY)

	g_iMarkEnt[victim] = ent
}

ClearMark(id)
{
	new ent = g_iMarkEnt[id]
	g_iMarkEnt[id] = 0

	if (ent && IsValidPev(ent) && Mark_IsEntity(ent, id))
		engfunc(EngFunc_RemoveEntity, ent)
}

Entity_Think_Mark(ent)
{
	new victim = pev(ent, pev_iuser1)
	new Float:fEnd
	new Float:gt = get_gametime()
	pev(ent, pev_fuser1, fEnd)

	// time is over or the victim is gone -> remove
	if (gt >= fEnd || !(1 <= victim <= 32) || !is_user_alive(victim))
	{
		if (1 <= victim <= 32 && g_iMarkEnt[victim] == ent)
			g_iMarkEnt[victim] = 0

		engfunc(EngFunc_RemoveEntity, ent)
		return
	}

	// follow: stay above the victim's head (maxs.z is lower when ducking)
	new Float:vecOrigin[3], Float:vecMaxs[3]
	pev(victim, pev_origin, vecOrigin)
	pev(victim, pev_maxs, vecMaxs)
	vecOrigin[2] += vecMaxs[2] + MARK_OFFSET_Z
	engfunc(EngFunc_SetOrigin, ent, vecOrigin)

	// animate: loop through the sprite frames
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	fFrame += MARK_FPS * MARK_THINK_DELAY
	if (fFrame >= MARK_FRAMES)
		fFrame -= MARK_FRAMES
	set_pev(ent, pev_frame, fFrame)

	set_pev(ent, pev_nextthink, gt + MARK_THINK_DELAY)
}

public fw_Knife_Deploy_Post(ent)
{
	new id = pev(ent, pev_owner)
	if (!is_user_alive(id) || !Get_BitVar(g_bHasBrionac, id))
		return HAM_IGNORED

	set_pev(id, pev_viewmodel2,   BRIONAC_V_MODEL)
	set_pev(id, pev_weaponmodel2, BRIONAC_P_MODEL)

	g_iWeapon[id]       = ent
	g_iMode[id]         = MODE_NONE
	g_iCharge[id]       = STATE_NONE
	g_bComboFired[id]   = false
	g_bWaitRelease[id]  = true
	g_flNextAttack[id]  = get_gametime() + DEPLOY_TIME
	g_flLastRegen[id]   = get_gametime()

	WE_Divinespear(id, ANIM_DRAW)
	
	
	set_pdata_float(ent, 46, 0.8, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, 47, 0.8, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, m_flTimeWeaponIdle, DEPLOY_TIME, OFFSET_LINUX_WEAPONS)
	
	SyncAmmoX(id)

	return HAM_IGNORED
}

public fw_Knife_Holster_Post(ent)
{
	new id = pev(ent, pev_owner)
	if (!is_user_alive(id) || !Get_BitVar(g_bHasBrionac, id))
		return HAM_IGNORED

	g_iMode[id]       = MODE_NONE
	g_iCharge[id]     = STATE_NONE
	g_bComboFired[id] = false
	return HAM_IGNORED
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if (!is_user_alive(id) || !Get_BitVar(g_bHasBrionac, id))
		return FMRES_IGNORED

	if (get_user_weapon(id) != CSW_DIVINESPEAR)
		return FMRES_IGNORED

	set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001)
	return FMRES_HANDLED
}

public fw_Knife_WeaponIdle_Post(ent)
{
	if (!IsValidPev(ent))
		return HAM_IGNORED

	new id = pev(ent, pev_owner)
	if (!is_user_alive(id) || !Get_BitVar(g_bHasBrionac, id))
		return HAM_IGNORED

	if (g_iCharge[id] != STATE_NONE)
		return HAM_IGNORED

	if (get_pdata_float(ent, m_flTimeWeaponIdle, OFFSET_LINUX_WEAPONS) <= 0.25)
	{
		WE_Divinespear(id, ANIM_IDLE)
		set_pdata_float(ent, m_flTimeWeaponIdle, 20.0, OFFSET_LINUX_WEAPONS)
	}

	return HAM_IGNORED
}

public fw_Knife_AddToPlayer_Post(ent, id)
{
	if (!IsValidPev(ent) || !is_user_connected(id) || !Get_BitVar(g_bHasBrionac, id))
		return HAM_IGNORED

	SendBrionacWeaponList(id)
	SyncAmmoX(id)
	return HAM_IGNORED
}

public fw_Knife_PostFrame(ent)
{
	new id = pev(ent, pev_owner)
	if (!is_user_alive(id) || !Get_BitVar(g_bHasBrionac, id))
		return HAM_IGNORED

	new Float:gt = get_gametime()

	if (g_iAmmo[id] < AMMO_MAX)
	{
		if (gt - g_flLastRegen[id] >= 1.0)
		{
			g_flLastRegen[id] = gt
			g_iAmmo[id] += AMMO_REGEN_PER_SEC
			if (g_iAmmo[id] > AMMO_MAX){
				g_iAmmo[id] = AMMO_MAX
			}
			
			SyncAmmoX(id)
		}
	}

	if (g_iCharge[id] != STATE_NONE)
		return HAM_IGNORED

	if (gt < g_flNextAttack[id])
	{
		if (pev(id, pev_weaponanim) != g_iAnim[id])
			Weap_anim(id, g_iAnim[id])
		return HAM_IGNORED
	}

	if (g_iAnim[id] != ANIM_IDLE)
		WE_Divinespear(id, ANIM_IDLE)

	if (IsAttackMode(g_iMode[id]) && gt >= g_flChainEnd[id])
		g_iMode[id] = MODE_NONE

	return HAM_IGNORED
}



/* ======================================
------------------- Stocks --------------
========================================= */
stock ResetState(id)
{
	g_iMode[id]            = MODE_NONE
	g_iCharge[id]          = STATE_NONE
	g_iAnim[id]            = ANIM_IDLE
	g_iWeapon[id]          = 0
	g_iOldButtons[id]      = 0
	g_iAmmo[id]            = 0
	UnSet_BitVar(g_bHasBrionac, id)
	g_bWaitRelease[id]     = false
	g_bComboFired[id]      = false
	g_flChargeStart[id]    = 0.0
	g_flChainEnd[id]       = 0.0
	g_flNextAttack[id]     = 0.0
	g_flLastRegen[id]      = 0.0
	g_flLastBrionacHit[id] = 0.0
	g_iChargeEnt[id] = 0
	g_iCharge2Ent[id] = 0
	g_iTornadoEnt[id] = 0
	//RemoveTornado(id)
	
	if (is_user_connected(id))
		set_pdata_int(id, OFFSET_AMMO_SLOT + BRIONAC_AMMO_ID, 0, OFFSET_LINUX_PLAYER)
}

stock Brionac_Attack(id)
{
	switch (g_iMode[id])
	{
		case MODE_NONE, MODE_ATTACK:
		{
			g_iMode[id] = MODE_ATTACK1
			WE_Divinespear(id, ANIM_SLASH1)
			
			Brionac_DoDamage(id, BRIONAC_DAMAGE + 4.0)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[SND_SLASH], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			SetAttackDelay(id, 0.4)
		}
		case MODE_ATTACK1:
		{
			g_iMode[id] = MODE_ATTACK2
			WE_Divinespear(id, ANIM_SLASH2)
			
			Brionac_DoDamage(id, BRIONAC_DAMAGE + 2.0)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[SND_SLASH], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			SetAttackDelay(id, 0.4)
		}
		case MODE_ATTACK2:
		{
			g_iMode[id] = MODE_ATTACK3
			WE_Divinespear(id, ANIM_SLASH3)
			Brionac_DoDamage(id, BRIONAC_DAMAGE + 3.0)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[SND_SLASH], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			SetAttackDelay(id, 0.45)
		}
		case MODE_ATTACK3:
		{
			g_iMode[id] = MODE_ATTACK
			WE_Divinespear(id, ANIM_SLASH4)
			Brionac_DoDamage(id, BRIONAC_DAMAGE + 4.0)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[SND_SLASH4], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			SetAttackDelay(id, 0.55)
		}
	}
}

stock Brionac_NormalDamage(id, Float:fDamage)
{
	new Float:vecOrigin[3]
	pev(id, pev_origin, vecOrigin)
	
	do_damages(id, CSW_DIVINESPEAR, vecOrigin, 350.0, fDamage, (DMG_NEVERGIB | DMG_BULLET))
}

stock Brionac_DoDamage(id, Float:fDamage)
{
	new Float:vecAng[3], Float:vecDir[3], Float:vecSrc[3], Float:vecOfs[3]
	pev(id, pev_v_angle, vecAng)
	pev(id, pev_origin, vecSrc)
	pev(id, pev_view_ofs, vecOfs)

	vecSrc[0] += vecOfs[0]
	vecSrc[1] += vecOfs[1]
	vecSrc[2] += vecOfs[2]

	Brionac_AngleVectors(vecAng, vecDir)

	new bestTarget = 0
	new Float:bestDist = 99999.0
	new Float:bestVicOrigin[3]

	for (new i = 1; i <= get_maxplayers(); i++)
	{
		if (!is_user_alive(i) || i == id)
			continue

		new Float:vecVicOrigin[3]
		pev(i, pev_origin, vecVicOrigin)

		new Float:dist = get_distance_f(vecSrc, vecVicOrigin)
		if (dist > BRIONAC_REACH)
			continue

		new Float:vecToVic[3]
		vecToVic[0] = vecVicOrigin[0] - vecSrc[0]
		vecToVic[1] = vecVicOrigin[1] - vecSrc[1]
		vecToVic[2] = vecVicOrigin[2] - vecSrc[2]
		vecNormalize(vecToVic)

		new Float:dot = vecDir[0]*vecToVic[0] + vecDir[1]*vecToVic[1] + vecDir[2]*vecToVic[2]
		if (dot < BRIONAC_CONE_DOT)
			continue

		new tr = create_tr2()
		engfunc(EngFunc_TraceLine, vecSrc, vecVicOrigin, DONT_IGNORE_MONSTERS, id, tr)
		new pHit = get_tr2(tr, TR_pHit)
		free_tr2(tr)

		if (pHit != i && pHit != 0)
			continue

		if (dist < bestDist)
		{
			bestDist = dist
			bestTarget = i
			bestVicOrigin = vecVicOrigin
		}
	}

	if (bestTarget > 0)
	{
		g_flLastBrionacHit[id] = get_gametime()
		Brionac_NormalDamage(id, fDamage)
		return
	}

	new Float:vecEnd[3]
	vecEnd[0] = vecSrc[0] + vecDir[0] * BRIONAC_REACH
	vecEnd[1] = vecSrc[1] + vecDir[1] * BRIONAC_REACH
	vecEnd[2] = vecSrc[2] + vecDir[2] * BRIONAC_REACH

	new tr = create_tr2()
	new Float:flFraction
	engfunc(EngFunc_TraceLine, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, id, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	new Float:vecHitPos[3]
	get_tr2(tr, TR_vecEndPos, vecHitPos)
	free_tr2(tr)

	if (flFraction < 1.0)
	{
		emit_sound(id, CHAN_ITEM, ExtraSounds[SND_WALL], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		Brionac_NormalDamage(id, fDamage)
	}
}

stock Brionac_ReleaseStab(id)
{
	g_iMode[id] = MODE_NONE
	WE_Divinespear(id, ANIM_STAB)
	Brionac_DoDamage(id, BRIONAC_DAMAGE)
	SetAttackDelay(id, ATTACK_DELAY)
	emit_sound(id, CHAN_WEAPON, ExtraSounds[7], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
}

stock Brionac_ReleaseShoot(id)
{
	g_iMode[id] = MODE_ATTACK
	WE_Divinespear(id, ANIM_RELEASE_SHOOT2)
	Brionac_DoDamage(id, BRIONAC_DAMAGE)
	SetAttackDelay(id, ATTACK_DELAY)
	
	SpawnTornado(id)

	emit_sound(id, CHAN_WEAPON, ExtraSounds[7], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
}

stock Brionac_Combo(id)
{
	g_iAmmo[id] -= COMBO_AMMO_COST
	if (g_iAmmo[id] < 0)
		g_iAmmo[id] = 0

	g_bComboFired[id] = true
	g_iMode[id]       = MODE_NONE
	// g_iCharge stays STATE_CHARGE_START on purpose: the charge effect keeps running

	SyncAmmoX(id)

	WE_Divinespear(id, ANIM_RELEASE_SHOOT)
	SetAttackDelay(id, COMBO_DELAY)   // also acts as the combo cooldown
	SpawnTornado(id)
}

stock Brionac_Reload(id)
{
	g_iAmmo[id] -= RELOAD_AMMO_COST
	if (g_iAmmo[id] < 0)
		g_iAmmo[id] = 0
	
	SyncAmmoX(id)
	
	g_iMode[id] = MODE_NONE

	WE_Divinespear(id, ANIM_THROW)
	emit_sound(id, CHAN_WEAPON, ExtraSounds[11], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	SetAttackDelay(id, RELOAD_DELAY, RELOAD_IDLE)

	SpawnSpear(id)
}

stock SpawnSpearTrail(ent, life)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)       // 22
	write_short(ent)                 // entity to follow
	write_short(engfunc(EngFunc_ModelIndex, "sprites/cso/ef_divinespear_throw.spr"))
	write_byte(life)                   // life in 0.1s units
	write_byte(2)                    // width (units x 0.1)
	write_byte(255)                  // red
	write_byte(255)                  // green
	write_byte(0)                    // blue
	write_byte(200)                  // brightness
	message_end()
}

stock RemoveTornado(id)
{
	new ent = g_iTornadoEnt[id]
	if (ent && IsValidPev(ent))
		engfunc(EngFunc_RemoveEntity, ent)

	g_iTornadoEnt[id] = 0
}

stock bool:Spear_IsEnemy(owner, victim)
{
	if (!(1 <= victim <= 32))
		return false
	if (!is_user_alive(victim) || victim == owner)
		return false

	if (is_user_connected(owner)
		&& cs_get_user_team(victim) == cs_get_user_team(owner)
		&& !get_pcvar_num(g_pcvFriendlyFire))
		return false

	return true
}

// point on the target the spear steers at (upper body)
stock Spear_GetAimPos(target, Float:vecOut[3])
{
	new Float:vecOfs[3]
	pev(target, pev_origin, vecOut)
	pev(target, pev_view_ofs, vecOfs)

	vecOut[0] += vecOfs[0]
	vecOut[1] += vecOfs[1]
	vecOut[2] += vecOfs[2] - 12.0
}

// true when there is no WORLD geometry between the spear and the target
stock bool:Spear_CanSee(ent, Float:vecFrom[3], Float:vecTo[3])
{
	new tr = create_tr2()
	new Float:flFraction

	engfunc(EngFunc_TraceLine, vecFrom, vecTo, IGNORE_MONSTERS, ent, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	free_tr2(tr)

	return (flFraction >= 1.0)
}

// nearest visible enemy inside SPEAR_TRACK_RADIUS and inside the cone in front of the spear
stock Spear_FindTarget(ent, owner, Float:vecOrigin[3], Float:vecDir[3])
{
	new best = 0
	new Float:bestDist = 99999.0

	for (new i = 1; i <= get_maxplayers(); i++)
	{
		if (!Spear_IsEnemy(owner, i))
			continue

		new Float:vecAim[3]
		Spear_GetAimPos(i, vecAim)

		new Float:dist = get_distance_f(vecOrigin, vecAim)
		if (dist > SPEAR_TRACK_RADIUS || dist >= bestDist)
			continue

		new Float:vecTo[3]
		vecTo[0] = vecAim[0] - vecOrigin[0]
		vecTo[1] = vecAim[1] - vecOrigin[1]
		vecTo[2] = vecAim[2] - vecOrigin[2]
		vecNormalize(vecTo)

		new Float:dot = vecDir[0]*vecTo[0] + vecDir[1]*vecTo[1] + vecDir[2]*vecTo[2]
		if (dot < SPEAR_CONE_DOT)
			continue

		if (!Spear_CanSee(ent, vecOrigin, vecAim))
			continue

		bestDist = dist
		best = i
	}

	return best
}

stock bool:Dot_IsEntity(ent, victim)
{
	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))

	return (equal(classname, CLASSNAME_DOT) && pev(ent, pev_iuser1) == victim)
}

// same check for the mark entity
stock bool:Mark_IsEntity(ent, victim)
{
	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))

	return (equal(classname, CLASSNAME_MARK) && pev(ent, pev_iuser1) == victim)
}

stock SetAttackDelay(id, Float:delay, Float:idle = -1.0)
{
	new Float:gt = get_gametime()
	g_flNextAttack[id] = gt + delay
	g_flChainEnd[id]   = gt + delay + CHAIN_RESET_TIME

	if (idle < 0.0)
		idle = delay + 0.5

	Set_Weapon_Idle(id, idle)
}

stock Set_Weapon_Idle(id, Float:idle)
{
	new ent = g_iWeapon[id]
	if (ent && IsValidPev(ent))
		set_pdata_float(ent, m_flTimeWeaponIdle, idle, OFFSET_LINUX_WEAPONS)
}

stock IsAttackMode(mode)
{
	if (mode == MODE_ATTACK  || mode == MODE_ATTACK1 ||
		mode == MODE_ATTACK2 || mode == MODE_ATTACK3)
		return 1
	return 0
}

stock WE_Divinespear(id, anim)
{
	g_iAnim[id] = anim
	Weap_anim(id, anim)
}

stock Weap_anim(id, anim)
{
	set_pev(id, pev_weaponanim, anim)
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(anim)
	write_byte(0)
	message_end()
}

stock Brionac_AngleVectors(const Float:angles[3], Float:vecFwd[3])
{
	new Float:sy = floatsin(angles[1], degrees)
	new Float:cy = floatcos(angles[1], degrees)
	new Float:sp = floatsin(angles[0], degrees)
	new Float:cp = floatcos(angles[0], degrees)

	vecFwd[0] = cp * cy
	vecFwd[1] = cp * sy
	vecFwd[2] = -sp
}

stock Float:vecLen(const Float:v[3])
{
	return floatsqroot(v[0]*v[0] + v[1]*v[1] + v[2]*v[2])
}

stock vecNormalize(Float:v[3])
{
	new Float:len = vecLen(v)
	if (len > 0.0)
	{
		v[0] /= len
		v[1] /= len
		v[2] /= len
	}
}

// ==================================================================
// DPS-style auto-aim-assisted attack
// ==================================================================
stock do_damages(id, CSWPN, Float:Origin[3], Float:Radius, Float:fDmg, dmgbits)
{
	if (!is_user_connected(id))
		return

	new inflictor = fm_get_user_weapon_entity(id, CSWPN)
	if (!IsValidPev(inflictor))
		inflictor = 0

	Radius_Damage(id, inflictor, Origin, Radius, fDmg, dmgbits)
	
}

stock Radius_Damage(id, inflictor, Float:vicOri[3], Float:fRadius, Float:fDamage, dmgbits)
{
	new i = -1, Float:vOrigin[3]

	while ((i = fm_find_ent_in_sphere(i, vicOri, fRadius)) != 0)
	{
		if (i == id) continue
		if (pev(i, pev_takedamage) == DAMAGE_NO) continue

		// func_breakable with TRIGGER_ONLY flag - skip (bitmask, not equality)
		if (pev(i, pev_spawnflags) & SF_BREAK_TRIGGER_ONLY) continue
		
		pev(i, pev_origin, vOrigin)

		if (1 <= i <= get_maxplayers())
		{
			if (!is_user_alive(i)) continue

			// Skip teammates if FF is off
			if (get_user_team(i) == get_user_team(id)
				&& !get_pcvar_num(g_pcvFriendlyFire))
				continue
		}

		ExecuteHamB(Ham_TakeDamage, i, inflictor, id, fDamage, dmgbits)
		Stock_Fake_KnockBack(id, i, ALL_AOE_KNOCKBACK)
		FX_Blood(vOrigin, 77, 10)
	}
}

stock FX_Blood(const Float:origin[3], color = 0, scale = 10)
{
    message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
    write_byte(TE_BLOODSPRITE);
    write_coord(floatround(origin[0]));
    write_coord(floatround(origin[1]));
    write_coord(floatround(origin[2]));
    write_short(g_iBloodSpray);   // sprite1: initial spray
    write_short(g_iBloodDrop);    // sprite2: falling droplets
    write_byte(color);             // palette color index
    write_byte(scale);             // size
    message_end();
}

stock do_attack(Attacker, Victim, Inflictor, Float:fDamage)
{
    fake_player_trace_attack(Attacker, Victim, fDamage)
    fake_take_damage(Attacker, Victim, fDamage, Inflictor)
}

stock fake_player_trace_attack(iAttacker, iVictim, &Float:fDamage)
{
    static Float:fAngles[3], Float:fDirection[3]
    pev(iAttacker, pev_angles, fAngles)
    angle_vector(fAngles, ANGLEVECTOR_FORWARD, fDirection)

    static Float:fStart[3], Float:fViewOfs[3]
    pev(iAttacker, pev_origin, fStart)
    pev(iAttacker, pev_view_ofs, fViewOfs)
    xs_vec_add(fViewOfs, fStart, fStart)

    static iAimOrigin[3], Float:fAimOrigin[3]
    get_user_origin(iAttacker, iAimOrigin, 3)
    IVecFVec(iAimOrigin, fAimOrigin)

    static pentru; pentru = create_tr2()
    engfunc(EngFunc_TraceLine, fStart, fAimOrigin, DONT_IGNORE_MONSTERS, iAttacker, pentru)
    static pHit; pHit = get_tr2(pentru, TR_pHit)
    static iHitgroup; iHitgroup = get_tr2(pentru, TR_iHitgroup)
    static Float:fEndPos[3]
    get_tr2(pentru, TR_vecEndPos, fEndPos)

    static iTarget, iBody
    get_user_aiming(iAttacker, iTarget, iBody)

    if (iTarget == iVictim)
    {
        iHitgroup = iBody
    }
    else if (pHit != iVictim)
    {
        static Float:fVicOrigin[3], Float:fVicViewOfs[3], Float:fAimInVictim[3]
        pev(iVictim, pev_origin, fVicOrigin)
        pev(iVictim, pev_view_ofs, fVicViewOfs)
        xs_vec_add(fVicViewOfs, fVicOrigin, fAimInVictim)
        fAimInVictim[2] = fStart[2]
        fAimInVictim[2] += get_distance_f(fStart, fAimInVictim) * floattan(fAngles[0] * 2.0, degrees)

        static iAngleToVictim; iAngleToVictim = get_angle_to_target(iAttacker, fVicOrigin)
        iAngleToVictim = abs(iAngleToVictim)
        static Float:fDis; fDis = 2.0 * get_distance_f(fStart, fAimInVictim) * floatsin(float(iAngleToVictim) * 0.5, degrees)
        static Float:fVicSize[3]
        pev(iVictim, pev_size, fVicSize)
        if (fDis <= fVicSize[0] * 0.5)
        {
            static ptr2; ptr2 = create_tr2()
            engfunc(EngFunc_TraceLine, fStart, fAimInVictim, DONT_IGNORE_MONSTERS, iAttacker, ptr2)
            static pHit2; pHit2 = get_tr2(ptr2, TR_pHit)
            static iHitgroup2; iHitgroup2 = get_tr2(ptr2, TR_iHitgroup)

            if (pHit2 == iVictim && (iHitgroup2 != HIT_HEAD || fDis <= fVicSize[0] * 0.25))
            {
                pHit = iVictim
                iHitgroup = iHitgroup2
                get_tr2(ptr2, TR_vecEndPos, fEndPos)
            }

            free_tr2(ptr2)
        }

        if (pHit != iVictim)
        {
            iHitgroup = HIT_GENERIC

            static ptr3; ptr3 = create_tr2()
            engfunc(EngFunc_TraceLine, fStart, fVicOrigin, DONT_IGNORE_MONSTERS, iAttacker, ptr3)
            get_tr2(ptr3, TR_vecEndPos, fEndPos)

            free_tr2(ptr3)
        }
    }

    set_tr2(pentru, TR_pHit, iVictim)
    set_tr2(pentru, TR_iHitgroup, iHitgroup)
    set_tr2(pentru, TR_vecEndPos, fEndPos)

    fake_trake_attack(iAttacker, iVictim, fDamage, fDirection, pentru)

    free_tr2(pentru)
}

stock fake_trake_attack(iAttacker, iVictim, Float:fDamage, Float:fDirection[3], iTraceHandle, iDamageBit = (DMG_NEVERGIB | DMG_BULLET))
{
    ExecuteHamB(Ham_TraceAttack, iVictim, iAttacker, fDamage, fDirection, iTraceHandle, iDamageBit)
}

stock fake_take_damage(iAttacker, iVictim, Float:fDamage, iInflictor, iDamageBit = (DMG_NEVERGIB | DMG_BULLET))
{
    ExecuteHamB(Ham_TakeDamage, iVictim, iInflictor, iAttacker, fDamage, iDamageBit)
}

stock get_angle_to_target(id, const Float:fTarget[3], Float:TargetSize = 0.0)
{
    static Float:fOrigin[3], iAimOrigin[3], Float:fAimOrigin[3], Float:fV1[3]
    pev(id, pev_origin, fOrigin)
    get_user_origin(id, iAimOrigin, 3)
    IVecFVec(iAimOrigin, fAimOrigin)
    xs_vec_sub(fAimOrigin, fOrigin, fV1)

    static Float:fV2[3]
    xs_vec_sub(fTarget, fOrigin, fV2)

    static iResult; iResult = get_angle_between_vectors(fV1, fV2)

    if (TargetSize > 0.0)
    {
        static Float:fTan; fTan = TargetSize / get_distance_f(fOrigin, fTarget)
        static fAngleToTargetSize; fAngleToTargetSize = floatround(floatatan(fTan, degrees))
        iResult -= (iResult > 0) ? fAngleToTargetSize : -fAngleToTargetSize
    }

    return iResult
}

stock get_angle_between_vectors(const Float:fV1[3], const Float:fV2[3])
{
    static Float:fA1[3], Float:fA2[3]
    engfunc(EngFunc_VecToAngles, fV1, fA1)
    engfunc(EngFunc_VecToAngles, fV2, fA2)

    static iResult; iResult = floatround(fA1[1] - fA2[1])
    iResult = iResult % 360
    iResult = (iResult > 180) ? (iResult - 360) : iResult

    return iResult
}

stock SendBrionacWeaponList(id)
{
	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string("knife_divinespear")
	write_byte(BRIONAC_AMMO_ID)   // primary ammo id
	write_byte(AMMO_MAX)          // primary ammo max
	write_byte(-1)
	write_byte(-1)
	write_byte(2)                 // slot (knife slot)
	write_byte(1)                 // number in slot
	write_byte(CSW_DIVINESPEAR)
	write_byte(0)
	message_end()
}

stock SendDefaultKnifeWeaponList(id)
{
	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string("weapon_knife")
	write_byte(-1)
	write_byte(-1)
	write_byte(-1)
	write_byte(-1)
	write_byte(2)
	write_byte(1)
	write_byte(CSW_KNIFE)
	write_byte(0)
	message_end()
}

stock SyncAmmoX(id)
{
	if (!is_user_connected(id) || !Get_BitVar(g_bHasBrionac, id))
		return

	// real server-side ammo, the engine now keeps the client HUD updated by itself
	set_pdata_int(id, OFFSET_AMMO_SLOT + BRIONAC_AMMO_ID, g_iAmmo[id], OFFSET_LINUX_PLAYER)

	// immediate update, don't wait for the next UpdateClientData
	message_begin(MSG_ONE, g_msgAmmoX, _, id)
	write_byte(BRIONAC_AMMO_ID)
	write_byte(g_iAmmo[id])
	message_end()
}

stock Stock_Muzzle(iPlayer, bodyindex, const szcls[], const szmodel[])
{
	static Ent; Ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!IsValidPev(Ent)) return

	set_pev(Ent, pev_classname, szcls)

	set_pev(Ent, pev_owner, iPlayer)
	set_pev(Ent, pev_body, bodyindex)
	set_pev(Ent, pev_skin, iPlayer)
	set_pev(Ent, pev_aiment, iPlayer)
	set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)

	set_pev(Ent, pev_scale, 0.15)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 5.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)

	set_pev(Ent, pev_nextthink, get_gametime() + 0.04)
}

stock Stock_Fake_KnockBack(attacker, victim, Float:iKb, Float:scalar = 100.0, Float:flUp = 5.0)
{
	if(!is_user_alive(victim))
		return

	static Float:vVictim[3], Float:vAttacker[3], Float:vDir[3], Float:vVel[3]
	pev(victim, pev_origin, vVictim)
	pev(attacker, pev_origin, vAttacker)

	vDir[0] = vVictim[0] - vAttacker[0]
	vDir[1] = vVictim[1] - vAttacker[1]

	new Float:flLen = floatsqroot(vDir[0] * vDir[0] + vDir[1] * vDir[1])
	if(flLen <= 0.0)
		return

	vDir[0] /= flLen
	vDir[1] /= flLen

	new Float:flForce = iKb * scalar

	vVel[0] = vDir[0] * flForce
	vVel[1] = vDir[1] * flForce
	vVel[2] = flUp

	set_pev(victim, pev_velocity, vVel)
}

stock DeleteEntityByClassnames(const szClassname[])
{
	new Entity = FM_NULLENT;
	while((Entity = fm_find_ent_by_class(Entity, szClassname)) > 0)
		if(IsValidPev(Entity)) engfunc(EngFunc_RemoveEntity, Entity)
}

stock UTIL_GetEyePosition(const pPlayer, Float: vecEyeLevel[3])
{
	new Float: vecOrigin[3]; pev(pPlayer, pev_origin, vecOrigin);
	new Float: vecViewOfs[3]; pev(pPlayer, pev_view_ofs, vecViewOfs);

	xs_vec_add(vecOrigin, vecViewOfs, vecEyeLevel);
}

stock UTIL_GetVectorAiming(const pPlayer, Float: vecAiming[3])
{
	new Float: vecViewAngle[3]; pev(pPlayer, pev_v_angle, vecViewAngle);
	new Float: vecPunchangle[3]; pev(pPlayer, pev_punchangle, vecPunchangle);

	xs_vec_add(vecViewAngle, vecPunchangle, vecViewAngle);
	angle_vector(vecViewAngle, ANGLEVECTOR_FORWARD, vecAiming);
}

/* ==============================================
------------------- end of Stocks --------------
================================================ */
