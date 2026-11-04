/* =========================================
-------- Plugin Datas and Headers ----------
========================================= */
#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <xs>
#include <engine>

#define USE_ZBHEROEX //zbheroex from Dias Ultimate plugins pack https://forums.alliedmods.net/showthread.php?t=294818

#if defined USE_ZBHEROEX
	#include <zombie_theheroex>
#endif

#define PLUGIN  "[CSO] Gravity & Abyss Repulsor"
#define VERSION "1.0"
#define AUTHOR  "Mellowzy"

/* ==================== switching models between gravity and abyss repulsor ================= */
//#define USE_GRAVITY_REPULSOR //just comment this if you want use abyss repulsor
/* ========================================================================================== */

/* ============================ weapon_data ================================================= */
#define CSW_LEAPSTRIKEGUN CSW_DEAGLE
#define weapon_leapstrikegun "weapon_deagle"
#define leapstrikegun_event "events/deagle.sc"
#define old_w_model "models/w_deagle.mdl"

/* ========================= Gravity Repulsor Data ========================================== */
#if defined USE_GRAVITY_REPULSOR

#define weapon_spr "weapon_leapstrikegun"
#define MAX_MF_FRAME 8.0

#define P_MODEL "models/repulsor/p_leapstrikegun.mdl"
#define V_MODEL "models/repulsor/vf_leapstrikegun.mdl"
#define W_MODEL "models/repulsor/w_leapstrikegun.mdl"

#define SND_FIRE		"weapons/leapstrikegun-1.wav"
#define SND_FIRE_EX		"weapons/leapstrikegun-1.wav"
#define SND_EXP			"weapons/leapstrikegun-1_exp.wav"
#define SND_EXP_EX		"weapons/leapstrikegun-1_exp.wav"
#define SND_CHARGE_READY	"weapons/leapstrikegun_change_start.wav"
#define SND_LEAP		"weapons/leapstrikegun_change_end.wav"
#define SND_FLY			"weapons/leapstrikegun_change_fly_idle.wav"
#define SND_SLAM		"weapons/leapstrikegun_change_fly_exp.wav"

#define LANDING_MDL "models/repulsor/ef_leapstrikegun_landing.mdl"
#define LANDING_SPR "sprites/repulsor/ef_leapstrikegun_landexplo_ground.spr"
#define PROJECTILE_SPR "sprites/repulsor/ef_leapstrikegun_projectile.spr"
#define EXPLO_GROUND_SPR "sprites/repulsor/ef_leapstrikegun_landexplo_ground.spr"
#define FLY_SPR "sprites/repulsor/ef_leapstrikegun_fly.spr"
#define EF_EXPLO_SPR "sprites/repulsor/ef_leapstrikegun_explo.spr"
#define EF_HIT_SPR "sprites/repulsor/ef_leapstrikegun_hit.spr"
#define MF_SPR "sprites/muzzleflash315.spr"

new const ExtraSounds[][] =
{
	"weapons/blaster_clipin.wav",
	"weapons/blaster_clipout.wav",
	"weapons/leapstrikegun_change_end.wav",
	"weapons/leapstrikegun_change_fly_exp.wav",//3
	"weapons/leapstrikegun_change_fly_idle.wav",
	"weapons/leapstrikegun_change_start.wav",
	"weapons/leapstrikegun_cliin.wav",
	"weapons/leapstrikegun_clipout.wav",
	"weapons/leapstrikegun_draw.wav",
	"weapons/leapstrikegun_reload1.wav",
	"weapons/leapstrikegun-1.wav",
	"weapons/leapstrikegun-1_exp.wav",
	"weapons/leapstrikegunex_change_end.wav",
	"weapons/leapstrikegunex_change_fly_idle.wav",
	"weapons/leapstrikegunex_change_start.wav",
	"weapons/leapstrikegunex-1.wav",
	"weapons/leapstrikegunex-1_exp.wav",
	"weapons/leapstrikegun_change_idle.wav"
}

new const ExtraSprites[][] =
{
	"sprites/640hud41.spr",
	"sprites/640hud231.spr",
	"sprites/640hud255.spr",
	"sprites/weapon_leapstrikegun.txt"
}

enum _:WeaponAnim
{
	ANIM_IDLE = 0,
	ANIM_IDLE_CHARGE,
	ANIM_SHOOT1,
	ANIM_SHOOT1_CHARGE,
	ANIM_SHOOT2,
	ANIM_SHOOT2_CHARGE,
	ANIM_DRAW,
	ANIM_DRAW_CHARGE,
	ANIM_RELOAD,
	ANIM_RELOAD_CHARGE,
	ANIM_CHANGE_START,
	ANIM_CHANGE,
	ANIM_CHANGE_END,
	ANIM_DUMMY
}

#endif
/* ========================= End of Gravity Repulsor Data ======================================= */

/* ============================ Abyss Repulsor Data ============================================= */
#if !defined USE_GRAVITY_REPULSOR

#define weapon_spr "weapon_leapstrikegunex"
#define MAX_MF_FRAME 9.0

#define P_MODEL "models/repulsor_abyss/p_leapstrikegunex.mdl"
#define V_MODEL "models/repulsor_abyss/v_leapstrikegunex.mdl"
#define W_MODEL "models/repulsor_abyss/w_leapstrikegunex.mdl"

#define SND_FIRE		"weapons/leapstrikegun-1.wav"
#define SND_FIRE_EX		"weapons/leapstrikegunex-1.wav"
#define SND_EXP			"weapons/leapstrikegun-1_exp.wav"
#define SND_EXP_EX		"weapons/leapstrikegunex-1_exp.wav"
#define SND_CHARGE_READY	"weapons/leapstrikegunex_change_start.wav"
#define SND_LEAP		"weapons/leapstrikegunex_change_end.wav"
#define SND_FLY			"weapons/leapstrikegunex_change_fly_idle.wav"
#define SND_SLAM		"weapons/leapstrikegun_change_fly_exp.wav"

#define LANDING_MDL "models/repulsor_abyss/ef_leapstrikegunex_landing.mdl"
#define LANDING_SPR "sprites/repulsor_abyss/ef_leapstrikegunex_landexplo_ground.spr"
#define PROJECTILE_SPR "sprites/repulsor_abyss/ef_leapstrikegunex_projectile.spr"
#define EXPLO_GROUND_SPR "sprites/repulsor_abyss/ef_leapstrikegunex_landexplo_ground.spr"
#define FLY_SPR "sprites/repulsor_abyss/ef_leapstrikegunex_fly.spr"
#define EF_EXPLO_SPR "sprites/repulsor_abyss/ef_leapstrikegunex_explo.spr"
#define EF_HIT_SPR "sprites/repulsor_abyss/ef_leapstrikegunex_hit.spr"
#define MF_SPR "sprites/muzzleflash408.spr"

new const ExtraSounds[][] =
{
	"weapons/blaster_clipin.wav",
	"weapons/blaster_clipout.wav",
	"weapons/leapstrikegun_change_end.wav",
	"weapons/leapstrikegun_change_fly_exp.wav",//3
	"weapons/leapstrikegun_change_fly_idle.wav",
	"weapons/leapstrikegun_change_start.wav",
	"weapons/leapstrikegun_cliin.wav",
	"weapons/leapstrikegun_clipout.wav",
	"weapons/leapstrikegun_draw.wav",
	"weapons/leapstrikegun_reload1.wav",
	"weapons/leapstrikegun-1.wav",
	"weapons/leapstrikegun-1_exp.wav",
	"weapons/leapstrikegunex_change_end.wav",
	"weapons/leapstrikegunex_change_fly_idle.wav",
	"weapons/leapstrikegunex_change_start.wav",
	"weapons/leapstrikegunex-1.wav",
	"weapons/leapstrikegunex-1_exp.wav",
	"weapons/leapstrikegun_change_idle.wav"
}

new const ExtraSprites[][] =
{
	"sprites/640hud41.spr",
	"sprites/640hud231.spr",
	"sprites/640hud255.spr",
	"sprites/weapon_leapstrikegunex.txt"
}

enum _:WeaponAnim
{
	ANIM_IDLE = 0,
	ANIM_IDLE_CHARGE,
	ANIM_SHOOT1,
	ANIM_SHOOT1_CHARGE,
	ANIM_SHOOT2,
	ANIM_SHOOT2_CHARGE,
	ANIM_DRAW,
	ANIM_DRAW_CHARGE,
	ANIM_RELOAD,
	ANIM_RELOAD_CHARGE,
	ANIM_CHANGE_START,
	ANIM_CHANGE_END,
	ANIM_DUMMY
}

#endif

/* =================================== End of Abyss Repulsor Data =========================== */

/* ======================================== weapon_info ===================================== */
#define CLIP 50
#define AMMO 250
#define LEAP_AMMO_MAX 100
#define LEAP_AMMO_START 25
#define LEAP_AMMO_TIME_REFILL 0.4
#define LEAP_AMMO_TYPE 15	// secondary ammo id used by the native CS ammo HUD (ammo2 icon)
#define A_SPEED 1.75
#define AOE_RADIUS 560.0
#define SLAM_RADIUS 360.0
#define HITFX_RADIUS 180.0

#define FLY_AURA_IMPULSE 82040
#define FLY_DURATION 5.0
#define LEAP_MAX_HEIGHT 3500.0
#define RELOAD_TIME 2.0

#define HIDEHUD_MONEY  (1<<5)
#define SET_CUSTOM_HUD (HIDEHUD_MONEY)
#define RESET_HUD      0

/* ====================================== extra tunables =================================== */

/* ======================================== For zombies ===================================== */

#if defined USE_ZBHEROEX

#define A_DAMAGE 65.0
#define AOE_DAMAGE 125.0
#define SLAM_DAMAGE 255.0
#define SLAM_KNOCKBACK 250.0

#endif

/* ======================================== For normal ===================================== */
#if !defined USE_ZBHEROEX

#define A_DAMAGE 5.0
#define AOE_DAMAGE 15.0
#define SLAM_DAMAGE 25.0
#define SLAM_KNOCKBACK 8.0

#endif

#define DRAW_TIME 1.0
#define PROJ_SPEED 2000.0
#define PROJ_LIFETIME 3.0
#define PROJ_SCALE 0.25
#define AREA_SCALE 1.5
#define FLY_SCALE 0.4
#define AOE_CONE_DOT 0.70
#define LEAP_SPEED 450.0
#define LEAP_MIN_UP 0.5
#define FLY_GRAVITY 0.0
#define DIVE_SPEED 2000.0
#define HIT_SPR_SCALE 12
#define GROUND_SPR_SCALE 40
#define SLAM_MDL_LIFE 1.2

/* leap rise tunables (initial climb before the glide starts)
   approx. peak height = LEAP_RISE_SPEED * LEAP_RISE_TIME * 0.7 */
#define LEAP_RISE_SPEED 850.0
#define LEAP_RISE_TIME 0.9

/* leap steering tunables */
#define LEAP_STEER_INPUT_SPEED 750.0
#define LEAP_STEER_BLEND 0.15
#define GLIDE_SPEED_FORWARD 300.0

/* fly loop sound: set FLY_SND_INTERVAL to the length (seconds) of SND_FLY wav
   so it restarts seamlessly while flying */
#define FLY_SND_INTERVAL 2.0

/* ==================== entities ================= */
#define MAX_ENTITIES 8192

#define AOE_CLASSNAME "leapstrike_aoe"
#define PROJ_CLASSNAME "leapstrike_projectile"
#define SLAM_CLASSNAME "leapstrike_slam"
#define SLAM2_CLASSNAME "leapstrike_slam2"
#define FLY_CLASSNAME "leapstrike_fly"
#define MF_CLASSNAME "leapstrike_mf"

#define PROJ_FRAMEMAX 14.0
#define AREA_FRAMEMAX 8.0
#define FLY_FRAMEMAX 29.0

#define AOEFX_RADIUS         270.0
#define AOEFX_SCALE_START    2.5
#define AOEFX_SCALE_END      5.0
#define AOEFX_SCALE_SPEED    0.3
#define AOEFX_FADE_SPEED     25.0
#define AOEFX_ANIMATED       0
#define AOEFX_IMPULSE        82038
#define AOEFX2_IMPULSE       82039

/* ==================== variables_and_some_sht ================= */
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) (pev_valid(%0) == 2)

// pdata offsets
#define OFFSET_LINUX_WEAPONS 4
#define OFFSET_LINUX_PLAYER 5
#define OFFSET_WEAPON_OWNER 41
#define OFFSET_WEAPON_ID 43
#define OFFSET_NEXT_PRIMARY 46
#define OFFSET_NEXT_SECONDARY 47
#define OFFSET_IDLE 48
#define OFFSET_CLIP 51
#define OFFSET_IN_RELOAD 54
#define OFFSET_SHOTSFIRED 64
#define OFFSET_WEAPONBOX_ITEMS 34
#define OFFSET_PLAYER_NEXTATTACK 83
#define OFFSET_PLAYER_ACTIVEITEM 373

#define SF_NORESPAWN (1<<30)
#define WEAPON_KEY 20261027
#define DMGTYPE_BULLET (1<<1)
#define DMGTYPE_FALL (1<<5)
#define DMGTYPE_BLAST (1<<6)
#define RENDER_TRANSALPHA 4
#define RENDER_ADDITIVE 5

new g_Had_Leapstrike,g_iBloodSpray, g_iBloodDrop;
new g_iMode[33], g_LeapAmmo[33], g_PreClip[33]
new Float:g_NextRefill[33], Float:g_NextFlySnd[33]
new bool:g_bCustomHud[33]

enum
{
	FLY_NONE = 0,
	FLY_UP,
	FLY_DIVE
}

enum _:CLeapstrikemode
{
	MODE_NONE = 0,
	MODE_LEAP
}

new g_FlyState[33], g_FlyAuraEnt[33]
new Float:g_FlyBegin[33], Float:g_FlyEnd[33], Float:g_FlyStartZ[33], Float:g_DiveTimeout[33], Float:g_NoFall[33]
new bool:g_bIsTrackedEntity[MAX_ENTITIES]
new g_iInfoTarget, g_sprHit, g_sprGround, g_msgScreenShake, g_msgWeaponList, g_msgAmmoX
new g_usEvent

#if defined USE_ZBHEROEX
new g_leapstrikegun
#endif

/* =========================================
------------- Init / Precache --------------
========================================= */
public plugin_precache()
{
	precache_model(P_MODEL)
	precache_model(V_MODEL)
	precache_model(W_MODEL)

	for(new i = 0; i < sizeof ExtraSounds; i++)
		precache_sound(ExtraSounds[i])

	for(new i = 0; i < sizeof ExtraSprites; i++)
	{
		if(containi(ExtraSprites[i], ".txt") != -1) precache_generic(ExtraSprites[i])
		else precache_model(ExtraSprites[i])
	}

	precache_model(PROJECTILE_SPR)
	precache_model(FLY_SPR)
	precache_model(EF_EXPLO_SPR)
	precache_model(LANDING_MDL)
	precache_model(LANDING_SPR)
	precache_model(MF_SPR)
	g_sprGround = precache_model(EXPLO_GROUND_SPR)
	g_sprHit = precache_model(EF_HIT_SPR)
	g_iBloodSpray = precache_model("sprites/bloodspray.spr");
	g_iBloodDrop  = precache_model("sprites/blood.spr");

	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd(weapon_spr, "CSOWPN_Hook")

	RegisterHam(Ham_Item_Deploy, weapon_leapstrikegun, "HamC_Weapon_Deploy_Post", true)
	RegisterHam(Ham_Item_AddToPlayer, weapon_leapstrikegun, "HamC_Item_AddToPlayer_Post", true)
	RegisterHam(Ham_Item_Holster, weapon_leapstrikegun, "HamC_Weapon_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame, weapon_leapstrikegun, "HamC_Weapon_PostFrame")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_leapstrikegun, "HamC_Weapon_Idle")
	RegisterHam(Ham_Weapon_Reload, weapon_leapstrikegun, "HamC_Weapon_Reload")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_leapstrikegun, "Ham_CWeapon_PrimaryAttack_Pre")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_leapstrikegun, "Ham_CWeapon_PrimaryAttack_Post", true)

	RegisterHam(Ham_TakeDamage, "player", "HamC_Player_TakeDamage")
	RegisterHam(Ham_Killed, "player", "HamC_Player_Killed_Post", true)
	RegisterHam(Ham_Spawn, "player", "HamC_Player_Spawn_Post", true)

	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_Touch, "fw_Touch")
	register_forward(FM_Think, "fw_Think")
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink")
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", true)
	register_forward(FM_UpdateClientData, "FW_UpdateClientData_Post", true);

	g_iInfoTarget = engfunc(EngFunc_AllocString, "info_target")
	g_msgScreenShake = get_user_msgid("ScreenShake")
	g_msgWeaponList = get_user_msgid("WeaponList")
	g_msgAmmoX = get_user_msgid("AmmoX")
	
#if defined USE_ZBHEROEX

    #if defined USE_GRAVITY_REPULSOR
        g_leapstrikegun = zbheroex_register_weapon("Gravity Repulsor", WEAPON_SECONDARY, CSW_LEAPSTRIKEGUN, 0);
    #else
        g_leapstrikegun = zbheroex_register_weapon("Abyss Repulsor", WEAPON_SECONDARY, CSW_LEAPSTRIKEGUN, 0);
    #endif

#endif

#if !defined USE_ZBHEROEX
	register_clcmd("give_leapstrike", "CSOWPN_Give")
#endif
}

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(leapstrikegun_event, name))
		g_usEvent = get_orig_retval()
}

public client_disconnected(id)
{
	if(id < 1 || id > 32) return
	Leap_Reset(id)
	UnSet_BitVar(g_Had_Leapstrike, id)
	g_bCustomHud[id] = false
	g_iMode[id] = MODE_NONE
	g_LeapAmmo[id] = 0
}

/* =========================================
------------- Give / Select ----------------
========================================= */

#if defined USE_ZBHEROEX
public zbheroex_weapon_bought(id, ItemID)
{
	if(ItemID == g_leapstrikegun) CSOWPN_Give(id)
}

public zbheroex_weapon_remove(id, ItemID)
{
	if(ItemID == g_leapstrikegun) CSOWPN_Remove(id)
}
#endif

public CSOWPN_Give(id)
{
	if(id < 1 || id > 32 || !is_user_alive(id))
		return PLUGIN_HANDLED

	Stock_Drop_Slot(id, 2)

	Set_BitVar(g_Had_Leapstrike, id)
	g_iMode[id] = MODE_NONE
	g_LeapAmmo[id] = LEAP_AMMO_START
	g_NextRefill[id] = get_gametime() + LEAP_AMMO_TIME_REFILL

	new ent = fm_give_item(id, weapon_leapstrikegun)
	if(ent > 0)
	{
		set_pev(ent, pev_impulse, WEAPON_KEY)
		set_pdata_int(ent, OFFSET_CLIP, CLIP, OFFSET_LINUX_WEAPONS)
		cs_set_user_bpammo(id, CSW_LEAPSTRIKEGUN, AMMO)
	}

	UpdateWeaponList(id, true)
	engclient_cmd(id, weapon_leapstrikegun)
	return PLUGIN_HANDLED
}

public CSOWPN_Remove(id)
{
	UnSet_BitVar(g_Had_Leapstrike, id)
	g_bCustomHud[id] = false
	g_iMode[id] = MODE_NONE
	g_LeapAmmo[id] = 0
	Leap_Reset(id)
	UTIL_SetHud(id, RESET_HUD)
}

public CSOWPN_Hook(id)
{
	engclient_cmd(id, weapon_leapstrikegun)
	return PLUGIN_HANDLED
}

public HamC_Item_AddToPlayer_Post(ent, id)
{
	if(!IsValidPev(ent) || id < 1 || id > 32)
		return

	if(pev(ent, pev_impulse) == WEAPON_KEY)
	{
		Set_BitVar(g_Had_Leapstrike, id)
		UpdateWeaponList(id, true)
	}
}

public HamC_Weapon_Holster_Post(ent)
{
	if(!IsValidPev(ent) || pev(ent, pev_impulse) != WEAPON_KEY)
		return

	new id = get_pdata_cbase(ent, OFFSET_WEAPON_OWNER, OFFSET_LINUX_WEAPONS)
	if(id < 1 || id > 32)
		return

	UTIL_SetHud(id, RESET_HUD)
}

public fw_SetModel(ent, const model[])
{
	if(!IsValidPev(ent))
		return FMRES_IGNORED

	static szClassName[33]
	entity_get_string(ent, EV_SZ_classname, szClassName, charsmax(szClassName))

	if(!equal(szClassName, "weaponbox"))
		return FMRES_IGNORED

	static iOwner
	iOwner = entity_get_edict(ent, EV_ENT_owner)

	if(equal(model, old_w_model))
	{
		static at4cs
		at4cs = find_ent_by_owner(-1, weapon_leapstrikegun, ent)

		if(!is_valid_ent(at4cs))
			return FMRES_IGNORED

		if(iOwner >= 1 && iOwner <= 32 && Get_BitVar(g_Had_Leapstrike, iOwner))
		{
			entity_set_int(at4cs, EV_INT_impulse, WEAPON_KEY)
			UnSet_BitVar(g_Had_Leapstrike, iOwner)
			UTIL_SetHud(iOwner, RESET_HUD)
			entity_set_model(ent, W_MODEL)
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if(!g_usEvent)
		return FMRES_IGNORED
	if(eventid != g_usEvent)
		return FMRES_IGNORED
	if(invoker < 1 || invoker > 32)
		return FMRES_IGNORED
	if(get_user_weapon(invoker) != CSW_LEAPSTRIKEGUN || !Get_BitVar(g_Had_Leapstrike, invoker))
		return FMRES_IGNORED

	return FMRES_SUPERCEDE
}

public FW_UpdateClientData_Post(iPlayer, iSendWeapons, iClientData)
{
    if(!is_user_alive(iPlayer))
        return FMRES_IGNORED

    new iActiveItem = get_pdata_cbase(iPlayer, 373, 5)

    if(pev_valid(iActiveItem) == 2 && pev(iActiveItem, pev_impulse) == WEAPON_KEY)
    {
        set_cd(iClientData, CD_flNextAttack, A_SPEED)
    }

    return FMRES_IGNORED
}


/* =========================================
------------- Weapon Hooks -----------------
========================================= */
public HamC_Weapon_Deploy_Post(ent)
{
	new id = get_pdata_cbase(ent, OFFSET_WEAPON_OWNER, OFFSET_LINUX_WEAPONS)
	if(id < 1 || id > 32)
		return

	if(!Get_BitVar(g_Had_Leapstrike, id))
	{
		if(g_bCustomHud[id]) UpdateWeaponList(id, false)
		return
	}

	set_pev(id, pev_viewmodel2, V_MODEL)
	set_pev(id, pev_weaponmodel2, P_MODEL)
	UpdateWeaponList(id, true)
	UTIL_SetHud(id, SET_CUSTOM_HUD)

	send_weapon_anim(id, g_iMode[id] == MODE_LEAP ? ANIM_DRAW_CHARGE : ANIM_DRAW)

	set_pdata_float(ent, OFFSET_IDLE, DRAW_TIME, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_NEXT_PRIMARY, 0.4, OFFSET_LINUX_WEAPONS)
	set_pdata_float(id, OFFSET_PLAYER_NEXTATTACK, 0.4, OFFSET_LINUX_PLAYER)
	set_pdata_float(ent, OFFSET_NEXT_SECONDARY, 0.4, OFFSET_LINUX_WEAPONS)
}

public HamC_Weapon_Idle(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	if(get_pdata_float(ent, OFFSET_IDLE, OFFSET_LINUX_WEAPONS) > 0.0)
		return HAM_IGNORED

	send_weapon_anim(id, g_iMode[id] == MODE_LEAP ? ANIM_IDLE_CHARGE : ANIM_IDLE)
	set_pdata_float(ent, OFFSET_IDLE, 20.0, OFFSET_LINUX_WEAPONS)
	return HAM_SUPERCEDE
}

public HamC_Weapon_Reload(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	Leapstrike_DoReload(ent, id)
	return HAM_SUPERCEDE
}

Leapstrike_DoReload(ent, id)
{
	if(get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS))
		return

	if(get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS) >= CLIP || cs_get_user_bpammo(id, CSW_LEAPSTRIKEGUN) <= 0)
		return

	set_pdata_int(ent, OFFSET_IN_RELOAD, 1, OFFSET_LINUX_WEAPONS)
	set_pdata_float(id, OFFSET_PLAYER_NEXTATTACK, RELOAD_TIME, OFFSET_LINUX_PLAYER)
	set_pdata_float(ent, OFFSET_NEXT_PRIMARY, RELOAD_TIME, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_NEXT_SECONDARY, RELOAD_TIME, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_IDLE, RELOAD_TIME + 0.5, OFFSET_LINUX_WEAPONS)

	send_weapon_anim(id, g_iMode[id] == MODE_LEAP ? ANIM_RELOAD_CHARGE : ANIM_RELOAD)
}

/* =========================================
---- PrimaryAttack: engine owns the clip ---
   Pre  : remember the clip before the engine fires
   Post : if the clip dropped, a real shot happened -> play our anim/sound/FX
          (dry-fire / blocked attacks leave the clip untouched -> ignored)
========================================= */

public Ham_CWeapon_PrimaryAttack_Pre(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	g_PreClip[id] = get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS)

	// deagle is semi-auto: the engine skips the shot while m_iShotsFired > 0.
	// Resetting it every attack lets holding LMB fire continuously.
	set_pdata_int(ent, OFFSET_SHOTSFIRED, 0, OFFSET_LINUX_WEAPONS)
	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Post(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	// no bullet consumed by the engine = no shot was fired
	if(get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS) >= g_PreClip[id])
		return HAM_IGNORED

	send_weapon_anim(id, g_iMode[id] == MODE_LEAP ? ANIM_SHOOT2_CHARGE : ANIM_SHOOT2)
	emit_sound(id, CHAN_WEAPON, g_iMode[id] == MODE_LEAP ? SND_FIRE_EX : SND_FIRE, 1.0, ATTN_NORM, 0, PITCH_NORM)

	set_pdata_float(ent, OFFSET_NEXT_PRIMARY,   0.4 / A_SPEED, OFFSET_LINUX_WEAPONS)
	set_pdata_float(id,  OFFSET_PLAYER_NEXTATTACK, 0.4 / A_SPEED, OFFSET_LINUX_PLAYER)
	set_pdata_float(ent, OFFSET_NEXT_SECONDARY, 0.4 / A_SPEED, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_IDLE,           2.0,           OFFSET_LINUX_WEAPONS)

	Stock_Muzzle(id, MF_CLASSNAME, MF_SPR)
	Leapstrikegun_Projectile(id)
	Leapstrikegun_Area(id)

	static Float:punch[3]
	punch[0] = random_float(-1.2, -0.6)
	punch[1] = 0.0
	punch[2] = 0.0
	set_pev(id, pev_punchangle, punch)

	return HAM_IGNORED
}

/* =========================================
---------- PostFrame / RMB leap -----------
========================================= */
public HamC_Weapon_PostFrame(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	if(get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS) && get_pdata_float(id, OFFSET_PLAYER_NEXTATTACK, OFFSET_LINUX_PLAYER) <= 0.0)
	{
		new iClip = get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS)
		new iBp = cs_get_user_bpammo(id, CSW_LEAPSTRIKEGUN)
		new j = min(CLIP - iClip, iBp)

		set_pdata_int(ent, OFFSET_CLIP, iClip + j, OFFSET_LINUX_WEAPONS)
		cs_set_user_bpammo(id, CSW_LEAPSTRIKEGUN, iBp - j)
		set_pdata_int(ent, OFFSET_IN_RELOAD, 0, OFFSET_LINUX_WEAPONS)
	}

	WE_Leapstrikegun(id, ent, pev(id, pev_button))
	return HAM_IGNORED
}

WE_Leapstrikegun(id, ent, iButton)
{
	if(!(iButton & IN_ATTACK2) || g_iMode[id] != MODE_LEAP)
		return
	if(g_FlyState[id] != FLY_NONE || get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS))
		return

	send_weapon_anim(id, ANIM_CHANGE_END)
	set_pdata_float(ent, OFFSET_NEXT_PRIMARY, 0.6, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_NEXT_SECONDARY, 0.6, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_IDLE, 1.5, OFFSET_LINUX_WEAPONS)

	g_LeapAmmo[id] = 0
	UpdateLeapAmmoHud(id)
	g_iMode[id] = MODE_NONE
	g_NextRefill[id] = get_gametime() + LEAP_AMMO_TIME_REFILL

	// leap start sound + fly loop are handled inside Leapstrike_LeapUp
	emit_sound(id, CHAN_WEAPON, ExtraSounds[3], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	Leapstrike_LeapUp(id)
}

/* =========================================
----------- Projectile / Area / FX ---------
========================================= */

Leapstrikegun_Projectile(id)
{
	static Float:eye[3], Float:ang[3], Float:fwd[3], Float:right[3], Float:up[3]
	static Float:org[3], Float:tmp[3], Float:vel[3], Float:angles[3]

	GetEyePos(id, eye)
	pev(id, pev_v_angle, ang)
	engfunc(EngFunc_MakeVectors, ang)
	global_get(glb_v_forward, fwd)
	global_get(glb_v_right, right)
	global_get(glb_v_up, up)

	xs_vec_copy(eye, org)
	xs_vec_mul_scalar(fwd, 32.0, tmp);	xs_vec_add(org, tmp, org)
	xs_vec_mul_scalar(right, 6.0, tmp);	xs_vec_add(org, tmp, org)
	xs_vec_mul_scalar(up, -5.0, tmp);	xs_vec_add(org, tmp, org)

	xs_vec_mul_scalar(fwd, PROJ_SPEED, vel)
	vector_to_angle(vel, angles)

	new ent = engfunc(EngFunc_CreateNamedEntity, g_iInfoTarget)
	if(!pev_valid(ent)) return

	set_pev(ent, pev_classname, PROJ_CLASSNAME)
	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_iuser1, g_iMode[id])

	engfunc(EngFunc_SetModel, ent, PROJECTILE_SPR)
	engfunc(EngFunc_SetSize, ent, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0})
	engfunc(EngFunc_SetOrigin, ent, org)

	set_pev(ent, pev_angles, angles)
	set_pev(ent, pev_velocity, vel)
	set_pev(ent, pev_rendermode, RENDER_ADDITIVE)
	set_pev(ent, pev_renderamt, 255.0)
	set_pev(ent, pev_scale, PROJ_SCALE)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_fuser1, get_gametime() + PROJ_LIFETIME)
	set_pev(ent, pev_nextthink, get_gametime() + 0.03)
}

Leapstrikegun_Explode(ent, skip = 0)
{
	static Float:origin[3]
	pev(ent, pev_origin, origin)

	new owner = pev(ent, pev_owner)
	new bEx = pev(ent, pev_iuser1) == MODE_LEAP

	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, origin, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, origin[0])
	engfunc(EngFunc_WriteCoord, origin[1])
	engfunc(EngFunc_WriteCoord, origin[2])
	write_short(g_sprHit)
	write_byte(HIT_SPR_SCALE)
	write_byte(30)
	write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	message_end()

	engfunc(EngFunc_EmitSound, ent, CHAN_WEAPON, bEx ? SND_EXP_EX : SND_EXP, 1.0, ATTN_NORM, 0, PITCH_NORM)

	do_damages(owner, CSW_LEAPSTRIKEGUN, origin, HITFX_RADIUS, AOE_DAMAGE, (DMG_NEVERGIB | DMG_BULLET))
}

/* AoE entity: env_sprite spawned at the player's feet, follows via aiment.
   The visual origin is offset per-client in fw_AddToFullPack_Post.
   The damage cone is computed once here in the player's forward direction. */
Leapstrikegun_Area(id)
{
	// Kill only THIS player's old AoE
	RemoveAoeEntity(id)

	new Float:vOrigin[3]
	pev(id, pev_origin, vOrigin)

	new Float:vEnd[3]
	vEnd[0] = vOrigin[0]
	vEnd[1] = vOrigin[1]
	vEnd[2] = vOrigin[2] - 1000.0

	engfunc(EngFunc_TraceLine, vOrigin, vEnd, IGNORE_MONSTERS, id, 0)
	new Float:vGround[3]
	get_tr2(0, TR_vecEndPos, vGround)
	vGround[2] += 1.0

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(ent > 0)
	{
		set_pev(ent, pev_classname, AOE_CLASSNAME)
		set_pev(ent, pev_impulse, AOEFX_IMPULSE)
		set_pev(ent, pev_owner, id)

		if(ent < MAX_ENTITIES)
			g_bIsTrackedEntity[ent] = true

		engfunc(EngFunc_SetModel, ent, EF_EXPLO_SPR)
		set_pev(ent, pev_origin, vGround)
		set_pev(ent, pev_solid, SOLID_NOT)
		set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
		set_pev(ent, pev_aiment, id)

		new Float:vAng[3]
		vAng[0] = 90.0
		vAng[1] = 0.0
		vAng[2] = 0.0
		set_pev(ent, pev_angles, vAng)

		set_pev(ent, pev_effects, 0)
		set_pev(ent, pev_renderfx, kRenderFxNone)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, 255.0)
		set_pev(ent, pev_scale, Float:AOEFX_SCALE_START)
		set_pev(ent, pev_frame, 0.0)
		set_pev(ent, pev_framerate, 20.0)
		set_pev(ent, pev_spawnflags, 1)
		dllfunc(DLLFunc_Spawn, ent)
		set_pev(ent, pev_nextthink, get_gametime() + 0.05)
	}

	// damage cone (once per shot, in front of the player)
	static Float:eye[3], Float:ang[3], Float:fwd[3], Float:vOrg[3], Float:dir[3]
	GetEyePos(id, eye)
	pev(id, pev_v_angle, ang)
	angle_vector(ang, ANGLEVECTOR_FORWARD, fwd)

	new victim = -1
	while((victim = engfunc(EngFunc_FindEntityInSphere, victim, eye, AOE_RADIUS)) != 0)
	{
		if(!is_user_alive(victim) || !IsEnemy(id, victim)) continue

		pev(victim, pev_origin, vOrg)
		xs_vec_sub(vOrg, eye, dir)
		xs_vec_normalize(dir, dir)
		if(xs_vec_dot(fwd, dir) < AOE_CONE_DOT) continue
		if(!IsVisible(id, eye, vOrg, victim)) continue

		do_damages(id, CSW_LEAPSTRIKEGUN, vOrigin, AOE_RADIUS, AOE_DAMAGE, (DMG_NEVERGIB | DMG_BULLET))
	}
}

RemoveAoeEntity(owner)
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", AOE_CLASSNAME)) != 0)
	{
		if(pev(ent, pev_owner) == owner)
		{
			if(ent < MAX_ENTITIES) g_bIsTrackedEntity[ent] = false
			engfunc(EngFunc_RemoveEntity, ent)
		}
	}
}

/* =========================================
-------------- Leap / Fly / Slam -----------
========================================= */

CreateFlyAura(id)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(ent > 0)
	{
		set_pev(ent, pev_classname, FLY_CLASSNAME)
		set_pev(ent, pev_impulse, FLY_AURA_IMPULSE)
		set_pev(ent, pev_owner, id)

		if(ent < MAX_ENTITIES)
			g_bIsTrackedEntity[ent] = true

		engfunc(EngFunc_SetModel, ent, FLY_SPR)
		set_pev(ent, pev_effects, 0)
		set_pev(ent, pev_renderfx, kRenderFxNone)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, 255.0)
		set_pev(ent, pev_scale, Float:FLY_SCALE)
		set_pev(ent, pev_framerate, 20.0)
		set_pev(ent, pev_spawnflags, 1)
		dllfunc(DLLFunc_Spawn, ent)
		set_pev(ent, pev_movetype, MOVETYPE_NONE)
		
		emit_sound(ent, CHAN_AUTO, SND_FLY, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		
		set_pev(ent, pev_nextthink, get_gametime() + 0.03)

		g_FlyAuraEnt[id] = ent
	}
}

RemoveFlyAura(id)
{
	if(g_FlyAuraEnt[id] && pev_valid(g_FlyAuraEnt[id]))
	{
		if(g_FlyAuraEnt[id] < MAX_ENTITIES) g_bIsTrackedEntity[g_FlyAuraEnt[id]] = false
		engfunc(EngFunc_RemoveEntity, g_FlyAuraEnt[id])
	}
	g_FlyAuraEnt[id] = 0
}

/* Fly loop sound lives on its own channel (CHAN_STREAM) so it can be
   restarted/stopped reliably. CHAN_STATIC can't be stopped per-entity. */
PlayFlySound(id)
{
	emit_sound(id, CHAN_AUTO, SND_FLY, 1.0, ATTN_NORM, 0, PITCH_NORM)
	g_NextFlySnd[id] = get_gametime() + FLY_SND_INTERVAL
}

StopFlySound(id)
{
	emit_sound(id, CHAN_AUTO, SND_FLY, 1.0, ATTN_NORM, SND_STOP, PITCH_NORM)
	g_NextFlySnd[id] = 0.0
}

Leapstrike_LeapUp(id)
{
	static Float:ang[3], Float:fwd[3], Float:vel[3], Float:org[3]

	pev(id, pev_v_angle, ang)
	angle_vector(ang, ANGLEVECTOR_FORWARD, fwd)
	if(fwd[2] < LEAP_MIN_UP)
		fwd[2] = floatmax(-fwd[2], LEAP_MIN_UP)
	xs_vec_normalize(fwd, fwd)
	xs_vec_mul_scalar(fwd, LEAP_SPEED, vel)

	// guarantee a strong vertical launch, even when starting from the ground
	if(vel[2] < LEAP_RISE_SPEED)
		vel[2] = LEAP_RISE_SPEED

	pev(id, pev_origin, org)
	g_FlyStartZ[id] = org[2]
	g_FlyBegin[id] = get_gametime()
	g_FlyEnd[id] = g_FlyBegin[id] + FLY_DURATION
	g_FlyState[id] = FLY_UP

	set_pev(id, pev_flags, pev(id, pev_flags) & ~FL_ONGROUND)
	set_pev(id, pev_velocity, vel)
	set_pev(id, pev_gravity, FLY_GRAVITY)

	emit_sound(id, CHAN_ITEM, SND_LEAP, 1.0, ATTN_NORM, 0, PITCH_NORM)
	emit_sound(id, CHAN_ITEM, SND_FLY, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	PlayFlySound(id)

	CreateFlyAura(id)
}

public fw_PlayerPreThink(id)
{
	if(id < 1 || id > 32)
		return FMRES_IGNORED

	if(!is_user_alive(id))
	{
		if(g_FlyState[id] != FLY_NONE) Leap_Reset(id)
		return FMRES_IGNORED
	}

	if(Get_BitVar(g_Had_Leapstrike, id))
		Leapstrike_Charge(id)

	if(g_FlyState[id] == FLY_NONE)
		return FMRES_IGNORED

	static Float:flNow, Float:org[3], Float:vel[3]
	flNow = get_gametime()

	// --- steerable leap: enforce gravity 0 + steer by aim ---
	if(g_FlyState[id] == FLY_UP)
	{
		static Float:ang[3], Float:fwd[3], Float:right[3]
		pev(id, pev_velocity, vel)
		pev(id, pev_v_angle, ang)
		angle_vector(ang, ANGLEVECTOR_FORWARD, fwd)
		angle_vector(ang, ANGLEVECTOR_RIGHT,   right)

		new button = pev(id, pev_button)
		new Float:fm = 0.0, Float:sm = 0.0
		if(button & IN_FORWARD)   fm += 1.0
		if(button & IN_BACK)      fm -= 1.0
		if(button & IN_MOVELEFT)  sm -= 1.0
		if(button & IN_MOVERIGHT) sm += 1.0

		new Float:tx = fwd[0] * LEAP_SPEED + right[0] * sm * LEAP_STEER_INPUT_SPEED + fwd[0] * fm * LEAP_STEER_INPUT_SPEED
		new Float:ty = fwd[1] * LEAP_SPEED + right[1] * sm * LEAP_STEER_INPUT_SPEED + fwd[1] * fm * LEAP_STEER_INPUT_SPEED

		vel[0] = vel[0] * (1.0 - LEAP_STEER_BLEND) + tx * LEAP_STEER_BLEND
		vel[1] = vel[1] * (1.0 - LEAP_STEER_BLEND) + ty * LEAP_STEER_BLEND

		new Float:flElapsed = flNow - g_FlyBegin[id]

		if(flElapsed < LEAP_RISE_TIME)
		{
			// rise phase: keep climbing, slowly easing off toward the glide
			vel[2] = LEAP_RISE_SPEED * (1.0 - 0.6 * (flElapsed / LEAP_RISE_TIME))
		}
		else
		{
			// glide phase: look-direction forward, z=0
			vel[0] = fwd[0] * GLIDE_SPEED_FORWARD
			vel[1] = fwd[1] * GLIDE_SPEED_FORWARD
			vel[2] = 0.0
		}

		set_pev(id, pev_velocity, vel)
		set_pev(id, pev_gravity, 0.0)

		// keep the fly loop sound going
		if(flNow >= g_NextFlySnd[id])
			PlayFlySound(id)
	}

	switch(g_FlyState[id])
	{
		case FLY_UP:
		{
			if(flNow >= g_FlyEnd[id])
			{
				Leapstrike_StartDive(id)
				return FMRES_IGNORED
			}

			if((pev(id, pev_flags) & FL_ONGROUND) && flNow > g_FlyBegin[id] + 0.4)
			{
				Leapstrike_Slam(id)
				return FMRES_IGNORED
			}

			pev(id, pev_origin, org)
			if(org[2] - g_FlyStartZ[id] >= LEAP_MAX_HEIGHT)
			{
				pev(id, pev_velocity, vel)
				if(vel[2] > 0.0)
				{
					vel[2] = 0.0
					set_pev(id, pev_velocity, vel)
				}
			}
		}
		case FLY_DIVE:
		{
			if((pev(id, pev_flags) & FL_ONGROUND) || flNow >= g_DiveTimeout[id])
				Leapstrike_Slam(id)
		}
	}
	return FMRES_IGNORED
}

/* Charge refill. The leap charge is shown on the native CS 1.6 ammo HUD
   (secondary ammo / ammo2 icon from weapon_leapstrikegun.txt) via AmmoX. */
Leapstrike_Charge(id)
{
	new Float:flNow = get_gametime()
	new bool:bActive = (get_user_weapon(id) == CSW_LEAPSTRIKEGUN)

	if(g_LeapAmmo[id] < LEAP_AMMO_MAX && flNow >= g_NextRefill[id])
	{
		g_LeapAmmo[id]++
		g_NextRefill[id] = flNow + LEAP_AMMO_TIME_REFILL
		if(bActive) UpdateLeapAmmoHud(id)
	}

	if(bActive && g_LeapAmmo[id] >= LEAP_AMMO_MAX && g_iMode[id] == MODE_NONE)
	{
		g_iMode[id] = MODE_LEAP
		emit_sound(id, CHAN_ITEM, SND_CHARGE_READY, 1.0, ATTN_NORM, 0, PITCH_NORM)

		new ent = get_pdata_cbase(id, OFFSET_PLAYER_ACTIVEITEM, OFFSET_LINUX_PLAYER)
		if(IsValidPev(ent) && !get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS))
		{
			send_weapon_anim(id, ANIM_CHANGE_START)
			set_pdata_float(ent, OFFSET_IDLE, 1.5, OFFSET_LINUX_WEAPONS)
		}
	}
}

Leapstrike_StartDive(id)
{
	static Float:vel[3]
	g_FlyState[id] = FLY_DIVE
	g_DiveTimeout[id] = get_gametime() + 3.0

	vel[0] = 0.0
	vel[1] = 0.0
	vel[2] = -DIVE_SPEED
	set_pev(id, pev_velocity, vel)
	set_pev(id, pev_gravity, 1.0)

	StopFlySound(id)
}

Leapstrike_Slam(id)
{
	static Float:org[3], Float:end[3], Float:gnd[3], Float:vOrg[3], Float:dir[3], Float:vel[3]

	Leap_Reset(id)
	Leapstrike_Slam_Explo(id)
	g_NoFall[id] = get_gametime() + 0.6

	pev(id, pev_origin, org)
	xs_vec_copy(org, end)
	end[2] -= 120.0
	engfunc(EngFunc_TraceLine, org, end, IGNORE_MONSTERS, id, 0)
	get_tr2(0, TR_vecEndPos, gnd)
	gnd[2] += 2.0

	new ent = engfunc(EngFunc_CreateNamedEntity, g_iInfoTarget)
	if(pev_valid(ent))
	{
		set_pev(ent, pev_classname, SLAM_CLASSNAME)
		set_pev(ent, pev_movetype, MOVETYPE_NONE)
		set_pev(ent, pev_solid, SOLID_NOT)
		set_pev(ent, pev_owner, id)

		engfunc(EngFunc_SetModel, ent, LANDING_MDL)
		engfunc(EngFunc_SetOrigin, ent, gnd)

		set_pev(ent, pev_sequence, 0)
		set_pev(ent, pev_animtime, get_gametime())
		set_pev(ent, pev_framerate, 25.0)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, 255.0)
		set_pev(ent, pev_fuser1, get_gametime() + SLAM_MDL_LIFE)
		set_pev(ent, pev_nextthink, get_gametime() + SLAM_MDL_LIFE)
	}

	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, gnd, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, gnd[0])
	engfunc(EngFunc_WriteCoord, gnd[1])
	engfunc(EngFunc_WriteCoord, gnd[2])
	write_short(g_sprGround)
	write_byte(GROUND_SPR_SCALE)
	write_byte(30)
	write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	message_end()

	engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, SND_SLAM, 1.0, ATTN_NORM, 0, PITCH_NORM)

	new victim = -1
	while((victim = engfunc(EngFunc_FindEntityInSphere, victim, gnd, SLAM_RADIUS)) != 0)
	{
		if(!is_user_alive(victim) || victim == id) continue

		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, victim)
		write_short(1<<13)
		write_short(1<<13)
		write_short(1<<13)
		message_end()

		if(!IsEnemy(id, victim)) continue

		do_damages(id, CSW_LEAPSTRIKEGUN, org, SLAM_RADIUS, SLAM_DAMAGE, (DMG_NEVERGIB | DMG_BULLET))

		pev(victim, pev_origin, vOrg)
		xs_vec_sub(vOrg, gnd, dir)
		dir[2] = 0.0
		xs_vec_normalize(dir, dir)
		xs_vec_mul_scalar(dir, SLAM_KNOCKBACK, vel)
		vel[2] = 200.0
		set_pev(victim, pev_velocity, vel)
	}
}

Leapstrike_Slam_Explo(id)
{
	// Kill only THIS player's old AoE
	RemoveAoeEntity(id)

	new Float:vOrigin[3]
	pev(id, pev_origin, vOrigin)

	new Float:vEnd[3]
	vEnd[0] = vOrigin[0]
	vEnd[1] = vOrigin[1]
	vEnd[2] = vOrigin[2] - 1000.0

	engfunc(EngFunc_TraceLine, vOrigin, vEnd, IGNORE_MONSTERS, id, 0)
	new Float:vGround[3]
	get_tr2(0, TR_vecEndPos, vGround)
	vGround[2] += 1.0

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(ent > 0)
	{
		set_pev(ent, pev_classname, SLAM2_CLASSNAME)
		set_pev(ent, pev_impulse, AOEFX2_IMPULSE)
		set_pev(ent, pev_owner, id)

		if(ent < MAX_ENTITIES)
			g_bIsTrackedEntity[ent] = true

		engfunc(EngFunc_SetModel, ent, LANDING_SPR)
		set_pev(ent, pev_origin, vGround)
		set_pev(ent, pev_solid, SOLID_NOT)
		set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
		set_pev(ent, pev_aiment, id)

		new Float:vAng[3]
		vAng[0] = 90.0
		vAng[1] = 0.0
		vAng[2] = 0.0
		set_pev(ent, pev_angles, vAng)

		set_pev(ent, pev_effects, 0)
		set_pev(ent, pev_renderfx, kRenderFxNone)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, 255.0)
		set_pev(ent, pev_scale, Float:AOEFX_SCALE_START)
		set_pev(ent, pev_frame, 0.0)
		set_pev(ent, pev_framerate, 20.0)
		set_pev(ent, pev_spawnflags, 1)
		dllfunc(DLLFunc_Spawn, ent)
		set_pev(ent, pev_nextthink, get_gametime() + 0.05)
	}

	// damage cone (once per shot, in front of the player)
	static Float:eye[3], Float:ang[3], Float:fwd[3], Float:vOrg[3], Float:dir[3]
	GetEyePos(id, eye)
	pev(id, pev_v_angle, ang)
	angle_vector(ang, ANGLEVECTOR_FORWARD, fwd)

	new victim = -1
	while((victim = engfunc(EngFunc_FindEntityInSphere, victim, eye, AOE_RADIUS)) != 0)
	{
		if(!is_user_alive(victim) || !IsEnemy(id, victim)) continue

		pev(victim, pev_origin, vOrg)
		xs_vec_sub(vOrg, eye, dir)
		xs_vec_normalize(dir, dir)
		if(xs_vec_dot(fwd, dir) < AOE_CONE_DOT) continue
		if(!IsVisible(id, eye, vOrg, victim)) continue

		do_damages(id, CSW_LEAPSTRIKEGUN, vOrigin, AOE_RADIUS, AOE_DAMAGE, (DMG_NEVERGIB | DMG_BULLET))
	}
}

Leap_Reset(id)
{
	if(id < 1 || id > 32)
		return

	if(g_FlyState[id] != FLY_NONE)
	{
		set_pev(id, pev_gravity, 1.0)
		StopFlySound(id)
	}
	g_FlyState[id] = FLY_NONE

	RemoveFlyAura(id)
}

/* =========================================
------------- Entity Touch / Think ---------
========================================= */
public fw_Touch(ent, ptr)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	static szClass[32]
	pev(ent, pev_classname, szClass, charsmax(szClass))
	if(!equal(szClass, PROJ_CLASSNAME))
		return FMRES_IGNORED

	new owner = pev(ent, pev_owner)
	if(ptr == owner)
		return FMRES_IGNORED

	new skip = 0, Float: vOrigin[3]
	pev(ent, pev_origin, vOrigin)
	if(ptr >= 1 && ptr <= 32 && is_user_alive(ptr) && IsEnemy(owner, ptr))
	{
		do_damages(owner, CSW_LEAPSTRIKEGUN, vOrigin, 80.0, A_DAMAGE, (DMG_NEVERGIB | DMG_BULLET))
		skip = ptr
	}

	Leapstrikegun_Explode(ent, skip)
	engfunc(EngFunc_RemoveEntity, ent)
	return FMRES_SUPERCEDE
}

public fw_Think(ent)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	static szClass[32], Float:flFrame, Float:flNow
	pev(ent, pev_classname, szClass, charsmax(szClass))

	if(szClass[0] != 'l' || szClass[1] != 'e' || szClass[2] != 'a')
		return FMRES_IGNORED

	flNow = get_gametime()

	if(equal(szClass, MF_CLASSNAME))
	{
		static iOwner; iOwner = pev(ent, pev_owner)

		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_LEAPSTRIKEGUN)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static iActiveItem; iActiveItem = get_pdata_cbase(iOwner, 373, 5)
		if(!IsValidPev(iActiveItem))
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static Float:Frame; pev(ent, pev_frame, Frame)
		if(Frame > MAX_MF_FRAME - 1.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.0
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)

		return FMRES_IGNORED
	}

	if(equal(szClass, PROJ_CLASSNAME))
	{
		static Float:flDeadline
		pev(ent, pev_fuser1, flDeadline)
		if(flNow >= flDeadline)
		{
			Leapstrikegun_Explode(ent)
			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_IGNORED
		}

		pev(ent, pev_frame, flFrame)
		flFrame += 1.0
		if(flFrame >= PROJ_FRAMEMAX) flFrame = 0.0
		set_pev(ent, pev_frame, flFrame)
		set_pev(ent, pev_nextthink, flNow + 0.03)
	}
	else if(equal(szClass, AOE_CLASSNAME))
	{
		new Float:scale, Float:amt, Float:frame
		pev(ent, pev_scale, scale)
		pev(ent, pev_renderamt, amt)
		pev(ent, pev_frame, frame)

		if(scale < Float:AOEFX_SCALE_END)
		{
			scale += Float:AOEFX_SCALE_SPEED
			if(scale > Float:AOEFX_SCALE_END) scale = Float:AOEFX_SCALE_END
		}

		amt -= Float:AOEFX_FADE_SPEED

		if(amt <= 0.0)
		{
			if(ent < MAX_ENTITIES) g_bIsTrackedEntity[ent] = false
			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_IGNORED
		}

		set_pev(ent, pev_frame, frame)
		set_pev(ent, pev_scale, scale)
		set_pev(ent, pev_renderamt, amt)
		set_pev(ent, pev_nextthink, flNow + 0.05)
	}
	else if(equal(szClass, SLAM2_CLASSNAME))
	{
		new Float:scale, Float:amt, Float:frame
		pev(ent, pev_scale, scale)
		pev(ent, pev_renderamt, amt)
		pev(ent, pev_frame, frame)

		if(scale < Float:AOEFX_SCALE_END)
		{
			scale += Float:AOEFX_SCALE_SPEED
			if(scale > Float:AOEFX_SCALE_END) scale = Float:AOEFX_SCALE_END
		}

		amt -= Float:AOEFX_FADE_SPEED

		if(amt <= 0.0)
		{
			if(ent < MAX_ENTITIES) g_bIsTrackedEntity[ent] = false
			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_IGNORED
		}

		set_pev(ent, pev_frame, frame)
		set_pev(ent, pev_scale, scale)
		set_pev(ent, pev_renderamt, amt)
		set_pev(ent, pev_nextthink, flNow + 0.05)
	}
	else if(equal(szClass, FLY_CLASSNAME))
	{
		pev(ent, pev_frame, flFrame)
		flFrame += 1.0
		if(flFrame >= FLY_FRAMEMAX) flFrame = 0.0
		set_pev(ent, pev_frame, flFrame)
		set_pev(ent, pev_nextthink, flNow + 0.03)
	}
	else if(equal(szClass, SLAM_CLASSNAME))
	{
		static Float:flAmt
		pev(ent, pev_renderamt, flAmt)
		flAmt -= 15.0
		if(flAmt <= 0.0)
		{
			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_IGNORED
		}
		set_pev(ent, pev_renderamt, flAmt)
		set_pev(ent, pev_nextthink, flNow + 0.05)
	}
	return FMRES_IGNORED
}

/* =========================================
------------- AddToFullPack ----------------
========================================= */
public fw_AddToFullPack_Post(es, e, ent, host, hostflags, player, pSet)
{
	if(player || ent < 0 || ent >= MAX_ENTITIES || !g_bIsTrackedEntity[ent])
		return FMRES_IGNORED

	new impulse = pev(ent, pev_impulse)
	if(impulse == AOEFX_IMPULSE || impulse == FLY_AURA_IMPULSE || impulse == AOEFX2_IMPULSE)
	{
		new id = pev(ent, pev_owner)
		if(id >= 1 && id <= MaxClients && is_user_alive(id))
		{
			new Float:vOrigin[3]
			pev(id, pev_origin, vOrigin)

			new flags = pev(id, pev_flags)
			if(flags & FL_DUCKING) vOrigin[2] -= 18.0
			else                   vOrigin[2] -= 36.0
			vOrigin[2] += 1.0

			set_es(es, ES_Origin, vOrigin)

			new Float:vAng[3]
			vAng[0] = 90.0
			vAng[1] = 0.0
			vAng[2] = 0.0
			set_es(es, ES_Angles, vAng)

			set_es(es, ES_Effects, get_es(es, ES_Effects) | EF_NOINTERP)
		}
	}
	else
	{
		g_bIsTrackedEntity[ent] = false
	}
	return FMRES_IGNORED
}

/* =========================================
------------- Player Hooks -----------------
========================================= */
public HamC_Player_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if(victim < 1 || victim > 32)
		return HAM_IGNORED
	if((damage_type & DMGTYPE_FALL) && (g_FlyState[victim] != FLY_NONE || get_gametime() < g_NoFall[victim]))
		return HAM_SUPERCEDE
	return HAM_IGNORED
}

public HamC_Player_Killed_Post(victim)
{
	if(victim < 1 || victim > 32) return
	Leap_Reset(victim)
	UTIL_SetHud(victim, RESET_HUD)
	UnSet_BitVar(g_Had_Leapstrike, victim)
	g_iMode[victim] = MODE_NONE
}

public HamC_Player_Spawn_Post(id)
{
	if(id < 1 || id > 32 || !is_user_alive(id))
		return
	Leap_Reset(id)
	g_iMode[id] = MODE_NONE
	g_NoFall[id] = 0.0
}

/* =========================================
----------------- Stocks -------------------
   (all helper / stock functions live below)
========================================= */
Get_WeaponOwner(ent)
{
	if(!IsValidPev(ent))
		return 0

	if(pev(ent, pev_impulse) != WEAPON_KEY)
		return 0

	new id = get_pdata_cbase(ent, OFFSET_WEAPON_OWNER, OFFSET_LINUX_WEAPONS)
	if(id < 1 || id > 32 || !Get_BitVar(g_Had_Leapstrike, id))
		return 0
	return id
}

IsEnemy(id, victim)
{
	if(id == victim || id < 1 || id > 32)
		return 0
	return (cs_get_user_team(id) != cs_get_user_team(victim))
}

IsVisible(id, Float:start[3], Float:end[3], victim)
{
	static Float:flFraction
	engfunc(EngFunc_TraceLine, start, end, DONT_IGNORE_MONSTERS, id, 0)
	get_tr2(0, TR_flFraction, flFraction)
	return (flFraction >= 1.0 || get_tr2(0, TR_pHit) == victim)
}

GetEyePos(id, Float:out[3])
{
	static Float:o[3], Float:v[3]
	pev(id, pev_origin, o)
	pev(id, pev_view_ofs, v)
	xs_vec_add(o, v, out)
}

UpdateWeaponList(id, bool:custom)
{
	g_bCustomHud[id] = custom

	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string(custom ? weapon_spr : weapon_leapstrikegun)
	write_byte(8)
	write_byte(AMMO)
	write_byte(custom ? LEAP_AMMO_TYPE : -1)
	write_byte(custom ? LEAP_AMMO_MAX : -1)
	write_byte(1)
	write_byte(1)
	write_byte(CSW_LEAPSTRIKEGUN)
	write_byte(0)
	message_end()

	if(custom) UpdateLeapAmmoHud(id)
}

stock UpdateLeapAmmoHud(id)
{
	message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoX, _, id)
	write_byte(LEAP_AMMO_TYPE)
	write_byte(g_LeapAmmo[id])
	message_end()
}

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
			if (get_user_team(i) == get_user_team(id))
				continue
		}

		ExecuteHamB(Ham_TakeDamage, i, inflictor, id, fDamage, dmgbits)
		Stock_Fake_KnockBack(id, i, 5.0, 100.0, random_float(5.0, 25.0))
		FX_Blood(vOrigin)
	}
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

stock send_weapon_anim(id, anim)
{
	set_pev(id, pev_weaponanim, anim)

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

stock Stock_Muzzle(iPlayer, const szcls[], const szmodel[])
{
	static Ent; Ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(Ent)) return

	set_pev(Ent, pev_classname, szcls)

	set_pev(Ent, pev_owner, iPlayer)
	set_pev(Ent, pev_body, 1)
	set_pev(Ent, pev_skin, iPlayer)
	set_pev(Ent, pev_aiment, iPlayer)
	set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)

	set_pev(Ent, pev_scale, 0.08)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 30.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)

	set_pev(Ent, pev_nextthink, get_gametime() + 0.04)
}

stock ham_strip_weapon(id, const weapon[])
{
	new wid = get_weaponid(weapon)
	if(!wid) return 0

	new ent
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", weapon)) && pev(ent, pev_owner) != id) {}
	if(!ent) return 0

	if(get_user_weapon(id) == wid)
		ExecuteHamB(Ham_Weapon_RetireWeapon, ent)

	if(!ExecuteHamB(Ham_RemovePlayerItem, id, ent))
		return 0

	ExecuteHamB(Ham_Item_Kill, ent)
	set_pev(id, pev_weapons, pev(id, pev_weapons) & ~(1<<wid))
	return 1
}

stock Stock_Drop_Slot(id, iSlot)
{
	new weapons[32], num
	get_user_weapons(id, weapons, num)
	for (new i = 0; i < num; i++)
	{
		const SECONDARY_WEAPONS_BIT_SUM = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE)

		if (iSlot == 2 && SECONDARY_WEAPONS_BIT_SUM & (1<<weapons[i]))
		{
			static wname[32]
			get_weaponname(weapons[i], wname, sizeof wname - 1)
			engclient_cmd(id, "drop", wname)
		}
	}
}

stock UTIL_SetHud(const pPlayer, const iHud)
{
	static iMsgId_HideWeapon
	if(!iMsgId_HideWeapon)
		iMsgId_HideWeapon = get_user_msgid("HideWeapon")

	message_begin(MSG_ONE, iMsgId_HideWeapon, _, pPlayer)
	write_byte(iHud)
	message_end()
}

stock FX_Blood(const Float:origin[3], color = 77, scale = 10)
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
