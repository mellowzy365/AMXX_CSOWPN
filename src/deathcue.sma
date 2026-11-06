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

#define PLUGIN  "[CSO] DeathCue"
#define VERSION "1.0"
#define AUTHOR  "Mellowzy"

/*==================== custom modules ===============================
* 1. MetaDrawer version 1.2.5
* https://ouo.io/27uF0G
*
* 2. Zombie The HeroEx by Dias
* https://ouo.io/t0ZyUc
*
* for both custom modules you can disable it by comments 
/===================================================================*/

#define USE_METADRAWER
#define MD_USE_IMAGE
//#define USE_ZBHEROEX

#if defined USE_METADRAWER
	#include <metadrawer>
#endif

#if defined USE_ZBHEROEX
	#include <zombie_theheroex>
#endif
//==================== weapon_data===============================
#define CSW_DEATHCUE CSW_M249
#define weapon_deathcue "weapon_m249"
#define weapon_spr "weapon_deathcue"
#define deathcue_event "events/m249.sc"
#define WEAPON_CODE 1882991
#define old_w_model "models/w_m249.mdl"
#define d_oldhud "m249"
#define d_customkill "deathcue"
//==================== weapon_info_and_entities=================
#define CLIP 100
#define BPAMMO 250
#define B_MAX_AMMO 5
#define A_SPEED 0.095
#define B_SPEED 1.15
#define C_SPEED 0.25
#define RELOAD_TIME 2.8

#define ACC_SPREAD_STAND		0.004
#define ACC_SPREAD_MOVE			0.04
#define ACC_SPREAD_AIR			0.10
#define ACC_SPEED_LIMIT			140.0

#define C_CHARGE_MAX 7.0       // full charge = 7s of C mode
#define C_CHARGE_MIN 0.0       // charge must be above this to enter C mode (0 = any charge)
#define C_CHARGE_RATE 1.0      // charge regained per second outside C mode (drain in C mode is 1 per second)

#define EXPLO_BLUE_A_RADIUS 120.0
#define EXPLO_BLUE_B_RADIUS 180.0
#define EXPLO_GREEN_RADIUS 180.0

#define MISSILE_A_IMPULSE 89877
#define MISSILE_B_IMPULSE 89878
#define SHOCKWAVE_IMPULSE 89879

#define MISSILE_A_CLASSNAME "missile_a"
#define MISSILE_B_CLASSNAME "missile_b"
#define MISSILE_GREEN_CLASSNAME "missile_green"
#define SHOCKWAVE_CLASSNAME "deathcue_shockwave"
#define MF_CLASSNAME "deathcue_mf"
#define GAUGE_CLASSNAME "deathcue_gauge"
#define FRAME_IDLE_CLASSNAME "deathcue_frame"

#define SHOCKWAVE_RADIUS 280.0
#define SHOCKWAVE_SCALE_START    2.5
#define SHOCKWAVE_SCALE_END      5.0
#define SHOCKWAVE_SCALE_SPEED    0.3
#define SHOCKWAVE_FADE_SPEED     25.0
#define SHOCKWAVE_ANIMATED       0

#define MAX_ENTITIES 8192

// WeaponList data (M249 uses 556natobox ammo)
#define WPN_AMMO_ID  3
#define WPN_AMMO_MAX 200
#define WPN_SLOT     0
#define WPN_SLOT_POS 4

// Secondary ammo (B mode counter). Must be an ammo type no real weapon uses.
#define WPN_AMMO2_ID 15

//==================== weapon_tunables=============
#define HP_THRESHOLD     50.0
#define SHIELD_DURATION  3.0

#if !defined USE_ZBHEROEX
#define A_DAMAGE 55.0

#define EXPLO_BLUE_A_DAMAGE 75.0
#define EXPLO_BLUE_B_DAMAGE 250.0
#define EXPLO_KNOCKBACK 5.0

#define EXPLO_GREEN_DAMAGE 185.0
#define EXPLO_GREEN_HEALING 25.0
#define EXPLO_GREEN_MAX_HP 100.0

#define SHOCKWAVE_DAMAGE 175.0
#define SHOCKWAVE_KNOCKBACK 6.0
#endif

#if defined USE_ZBHEROEX
#define A_DAMAGE 15.0

#define EXPLO_BLUE_A_DAMAGE 250.0
#define EXPLO_BLUE_B_DAMAGE 370.0
#define EXPLO_KNOCKBACK 8.0

#define EXPLO_GREEN_DAMAGE 185.0
#define EXPLO_GREEN_HEALING 50.0
#define EXPLO_GREEN_MAX_HP 254.0

#define SHOCKWAVE_DAMAGE 255.0
#define SHOCKWAVE_KNOCKBACK 9.0
#endif

//==================== weapon_model=================
#define P_MODEL "models/cso/p_deathcue.mdl"
#define V_MODEL "models/cso/v_deathcue.mdl"
#define W_MODEL "models/cso/w_deathcue.mdl"
#define MF_SPRITES "sprites/cso/muzzleflash540.spr"  //spr max frame 4
#define MF_SPRITES_C "sprites/cso/muzzleflash542.spr"  //spr max frame 4
#define MF_SPRITES_GREEN "sprites/cso/muzzleflash543.spr"  //spr max frame 4
#define EXPLO_A_SPRITES "sprites/cso/ef_deathcue_explo_a.spr" //spr max frame 29
#define EXPLO_B_SPRITES "sprites/cso/ef_deathcue_explo_b.spr"//spr max frame 29
#define MISSILE_A_SPRITES "sprites/cso/ef_deathcue_missile_a.spr" //spr max frame 9
#define MISSILE_B_SPRITES "sprites/cso/ef_deathcue_missile_b.spr" //spr max frame 9
#define SHOCKWAVE_SPRITES "sprites/cso/ef_deathcue_shockwave.spr" //spr max frame 14
#define FRAME_IDLE_SPRITES "sprites/cso/ef_deathcue_idle.spr" //spr max frame 28
#define GAUGE_EMPTY_SPRITES "sprites/cso/deathcue_aim_bg.spr" //spr max frame 0
#define GAUGE_FULL_SPRITES "sprites/cso/deathcue_aim_bg_full.spr" //spr max frame 0
#define TRAIL_SPRITES "sprites/laserbeam.spr"
#define AIM_COUNT 4

// spr 256x256: top-left corner + its mirrored copies (tr = flipped horizontally, bl = vertically, br = both)
new const AimFrameSprites[AIM_COUNT][] =
{
	"sprites/cso/deathcue_aim_frame.spr",      // top-left
	"sprites/cso/deathcue_aim_frame_tr.spr",   // top-right
	"sprites/cso/deathcue_aim_frame_bl.spr",   // bottom-left
	"sprites/cso/deathcue_aim_frame_br.spr"    // bottom-right
}

#if defined USE_METADRAWER

#define AIM_CHANNEL 100        // md sprite channel base (uses 100..103), must not clash with other plugins
#define AIM_COVER 1.0          // 1.0 = each corner fills a quarter of the screen, lower = smaller corners

// Gauge (crosshair ring) drawn with md_drawsprite at the screen center
#define GAUGE_CHANNEL 110      // md sprite channel (0 ~ 256), must not clash with other plugins
#define GAUGE_X 0.5            // 0.5 / 0.5 = screen center = CS 1.6 crosshair position
#define GAUGE_Y 0.5
#define GAUGE_STATE_NONE  0
#define GAUGE_STATE_FILL  1    // charge refilling  -> plays GAUGE_FILL_SPR  (empty -> full)
#define GAUGE_STATE_DRAIN 2    // C mode consuming  -> plays GAUGE_DRAIN_SPR (full -> empty)
#define GAUGE_STATE_FULL  3    // charge == C_CHARGE_MAX -> static GAUGE_FULL_SPR

#define GAUGE_FILL_SPR  "sprites/cso/deathcue_aim_fill.spr"    // 21 frames, empty -> full
#define GAUGE_DRAIN_SPR "sprites/cso/deathcue_aim_drain.spr"   // 21 frames, full -> empty
#define GAUGE_FULL_SPR  "sprites/cso/deathcue_aim_full.spr"    // 1 frame, full
#define GAUGE_FRAMES 21        // frames in the fill / drain sprites (21 frames at 3 fps = 7 s = C_CHARGE_MAX)

new const AimAlign[AIM_COUNT] =
{
	ALIGN_NORMAL,
	ALIGN_RIGHT,
	ALIGN_BOTTOM,
	(ALIGN_RIGHT | ALIGN_BOTTOM)
}

#if defined MD_USE_IMAGE
// 512x512 32-bit TGA, same corner layout as the sprites (put them in cstrike/gfx/deathcue/)
new const AimFrameImages[AIM_COUNT][] =
{
	"gfx/cso/deathcue_aim_frame.tga",      // top-left
	"gfx/cso/deathcue_aim_frame_tr.tga",   // top-right
	"gfx/cso/deathcue_aim_frame_bl.tga",   // bottom-left
	"gfx/cso/deathcue_aim_frame_br.tga"    // bottom-right
}
#endif

#else

#define AIM_CLASSNAME "deathcue_aimframe"
#define AIM_IMPULSE 89880
#define AIM_DIST 12.0          // distance in front of the eye
#define AIM_HALF_W 9.8         // visible half width at AIM_DIST is 9.2 (fov 75); +6% overscan hides cl_bob movement
#define AIM_HALF_H 5.5         // visible half height at AIM_DIST is 5.2 (16:9); +6% overscan
#define AIM_SIZE 5.0           // world size of one corner sprite (square)
#define AIM_PING_COMP 1        // 1 = lead the eye by velocity * ping, 0 = off

#endif

//==================== weapon_sound=================
new const ExtraSounds[][] =
{
	"weapons/deathcue_b.wav",
	"weapons/deathcue_charge.wav",
	"weapons/deathcue_clipin.wav",
	"weapons/deathcue_clipout.wav",
	"weapons/deathcue_cmode_end.wav",   //4
	"weapons/deathcue_cmode_start.wav", //5
	"weapons/deathcue_draw.wav",
	"weapons/deathcue-1.wav", //7
	"weapons/deathcue-1_2.wav",//8
	"weapons/deathcue-2.wav",//9
	"weapons/deathcue-2_exp.wav", //10
	"weapons/deathcue-3.wav",//11
	"weapons/deathcue-3_exp.wav"//12
}

new const ExtraSprites[][] =
{
	"sprites/640hud40.spr",
	"sprites/640hud271.spr",
	"sprites/weapon_deathcue.txt"
}

//==================== variables =================
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) (pev_valid(%0) == 2)

#define HIDEHUD_MONEY  (1<<5)
#define SET_CUSTOM_HUD (HIDEHUD_MONEY)
#define RESET_HUD      0

// pdata offsets
#define OFFSET_LINUX_WEAPONS 4
#define OFFSET_LINUX_PLAYER 5
#define OFFSET_WEAPON_OWNER 41
#define OFFSET_NEXT_PRIMARY 46
#define OFFSET_NEXT_SECONDARY 47
#define OFFSET_IDLE 48
#define OFFSET_CLIP 51
#define OFFSET_IN_RELOAD 54
#define OFFSET_SHOTSFIRED 64
#define OFFSET_PLAYER_NEXTATTACK 83
#define OFFSET_PLAYER_ACTIVEITEM 373
#define SVC_WEAPONANIM_ID 35

#define PRIMARY_WEAPONS_BIT_SUM ((1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90))

enum
{
	ANIM_IDLE = 0,
	ANIM_IDLE_MODEC,
	ANIM_SHOOTA,
	ANIM_SHOOTA2,
	ANIM_SHOOTB,
	ANIM_SHOOTC,
	ANIM_RELOAD,
	ANIM_DRAW,
	ANIM_MODEC_START,
	ANIM_MODEC_END
}

enum
{
	MODE_NONE = 0,
	MODE_C
}

new g_Had_DeathCue, g_BModeAmmo[33], g_iMode[33], g_ShootCount[33],Float:g_shieldEnd[33],bool:g_shieldActive[33],bool:g_shieldUsed[33]
new Float:g_ModeCStart[33], Float:g_Charge[33], Float:g_ChargeStamp[33]
new g_MaxPlayers, g_msgWeaponList, g_msgAmmoX, g_usEvent, g_PreClip[33]
new g_iBloodSpray, g_iBloodDrop, g_SmokePuff_SprId, g_iExploA, g_iExploB, g_iTrailSpr
new bool:g_bCustomHud[33], bool:g_bIsTrackedEntity[MAX_ENTITIES]
#if defined USE_METADRAWER
new bool:g_bAimDrawn[33]
new g_iGauge[33]
#else
new g_AimEnt[33][AIM_COUNT], bool:g_bIsAimFrame[MAX_ENTITIES]
#endif

#if defined USE_ZBHEROEX
new g_deathcue
#endif

/* =========================================
------------- Init / Precache --------------
========================================= */
public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")
	register_event("DeathMsg", "event_death", "a");
	register_event("HLTV", "event_newround", "a", "1=0", "2=0")   // shield: once per round

#if defined USE_METADRAWER
	// MetaDrawer: load the images in plugin_init (same as the module's example plugin)
	for(new i = 0; i < AIM_COUNT; i++)
	{
	#if defined MD_USE_IMAGE
		md_loadimage(AimFrameImages[i])
	#else
		md_loadsprite(AimFrameSprites[i])
	#endif
	}
#endif

#if defined USE_METADRAWER
	md_loadsprite(GAUGE_FILL_SPR)
	md_loadsprite(GAUGE_DRAIN_SPR)
	md_loadsprite(GAUGE_FULL_SPR)
#endif

	g_MaxPlayers = get_maxplayers()
	g_msgWeaponList = get_user_msgid("WeaponList")
	g_msgAmmoX = get_user_msgid("AmmoX")

	register_forward(FM_SetModel, "fw_Forward_SetModel")
	register_forward(FM_PlayerPostThink, "fw_Forward_PostThink", true);
	register_forward(FM_PlaybackEvent, "fw_Forward_PlaybackEvent")
	register_forward(FM_UpdateClientData, "fw_Forward_UpdateClientData_Post", true)
#if !defined USE_METADRAWER
	register_forward(FM_AddToFullPack, "fw_AddToFullPack_Aim_Post", true)
#endif

	register_forward(FM_Think, "fw_Forward_Think")
	register_forward(FM_Touch, "fw_Forward_Touch")

	RegisterHam(Ham_TraceAttack, "worldspawn", "HamC_TraceAttack_World")
	RegisterHam(Ham_TraceAttack, "player", "HamC_TraceAttack_Player")

	RegisterHam(Ham_Killed, "player", "HamC_Player_Killed_Post", true)
	RegisterHam(Ham_Spawn, "player", "HamC_Player_Spawn_Post", true)
	RegisterHam(Ham_TakeDamage, "player", "HamC_TakeDamage_Pre", 0);

	RegisterHam(Ham_Item_Deploy, weapon_deathcue, "HamC_Weapon_Deploy_Post", true)
	RegisterHam(Ham_Item_AddToPlayer, weapon_deathcue, "HamC_Item_AddToPlayer_Post", true)
	RegisterHam(Ham_Item_Holster, weapon_deathcue, "HamC_Weapon_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame, weapon_deathcue, "HamC_Weapon_PostFrame_Pre")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_deathcue, "HamC_Weapon_Idle_Pre")
	RegisterHam(Ham_Weapon_Reload, weapon_deathcue, "HamC_Weapon_Reload_Pre")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_deathcue, "Ham_CWeapon_PrimaryAttack_Pre")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_deathcue, "Ham_CWeapon_PrimaryAttack_Post", true)
	RegisterHam(Ham_Player_PostThink, "player", "Ham_CWeapon_OnPostThink")

	register_clcmd("give_deathcue", "CSOWPN_Give")
	register_clcmd(weapon_spr, "CSOWPN_Hook")

	#if defined USE_ZBHEROEX
	g_deathcue = zbheroex_register_weapon("DeathCue", WEAPON_PRIMARY, CSW_DEATHCUE, 0)
#endif
}

#if defined USE_ZBHEROEX
public zbheroex_weapon_bought(id, ItemID)
{
	if(ItemID == g_deathcue) CSOWPN_Give(id)
}

public zbheroex_weapon_remove(id, ItemID)
{
	if(ItemID == g_deathcue) CSOWPN_Remove(id)
}
#endif

public plugin_precache()
{
	precache_model(P_MODEL)
	precache_model(V_MODEL)
	precache_model(W_MODEL)

	precache_model(MF_SPRITES)
	precache_model(MF_SPRITES_C)
	precache_model(MF_SPRITES_GREEN)
	g_iExploA = precache_model(EXPLO_A_SPRITES)
	g_iExploB = precache_model(EXPLO_B_SPRITES)
	precache_model(MISSILE_A_SPRITES)
	precache_model(MISSILE_B_SPRITES)
	precache_model(SHOCKWAVE_SPRITES)
	precache_model(FRAME_IDLE_SPRITES)
	precache_model(GAUGE_EMPTY_SPRITES)
	precache_model(GAUGE_FULL_SPRITES)
	for(new i = 0; i < AIM_COUNT; i++)
	{
	#if defined USE_METADRAWER
		#if defined MD_USE_IMAGE
			precache_generic(AimFrameImages[i])    // clients download the TGA (md_loadimage is done in plugin_init)
		#else
			precache_model(AimFrameSprites[i])
		#endif
	#else
		precache_model(AimFrameSprites[i])
	#endif
	}
#if defined USE_METADRAWER
	precache_model(GAUGE_FILL_SPR)
	precache_model(GAUGE_DRAIN_SPR)
	precache_model(GAUGE_FULL_SPR)
#endif
	g_iTrailSpr = precache_model(TRAIL_SPRITES)

	g_iBloodSpray = precache_model("sprites/bloodspray.spr")
	g_iBloodDrop = precache_model("sprites/blood.spr")
	g_SmokePuff_SprId = precache_model("sprites/wall_puff1.spr")

	for(new i = 0; i < sizeof ExtraSounds; i++)
		precache_sound(ExtraSounds[i])

	for(new i = 0; i < sizeof ExtraSprites; i++)
	{
		if(containi(ExtraSprites[i], ".txt") != -1) precache_generic(ExtraSprites[i])
		else precache_model(ExtraSprites[i])
	}

	register_forward(FM_PrecacheEvent, "fw_Forward_PrecacheEvent_Post", 1)
}

public message_DeathMsg(msg_id, msg_dest, msg_ent)
{
	static szWeapon[64]
	get_msg_arg_string(4, szWeapon, charsmax(szWeapon))

	if(!equal(szWeapon, d_oldhud))
		return PLUGIN_CONTINUE

	static iKiller; iKiller = get_msg_arg_int(1)
	if(!is_user_connected(iKiller))
		return PLUGIN_CONTINUE
	if(!Get_BitVar(g_Had_DeathCue, iKiller) || get_user_weapon(iKiller) != CSW_DEATHCUE)
		return PLUGIN_CONTINUE

	set_msg_arg_string(4, d_customkill)
	return PLUGIN_CONTINUE
}

public event_death()
{
    new victim = read_data(2);
    if (victim >= 1 && victim <= 32 && g_shieldActive[victim])
    {
        g_shieldActive[victim] = false;
        g_shieldEnd[victim]    = 0.0;
        if (is_user_connected(victim))
            set_pev(victim, pev_takedamage, DAMAGE_AIM);
    }
}

public event_newround()
{
	for(new i = 1; i <= g_MaxPlayers; i++)
		g_shieldUsed[i] = false
}

public fw_Forward_PrecacheEvent_Post(type, const name[])
{
	if(equal(deathcue_event, name))
		g_usEvent = get_orig_retval()
}

public client_disconnected(id)
{
	UnSet_BitVar(g_Had_DeathCue, id)
	g_bCustomHud[id] = false
	Reset_DeathCue(id)
	g_shieldActive[id] = false;
	g_shieldEnd[id]    = 0.0;
	g_shieldUsed[id]   = false;
}

public CSOWPN_Give(id)
{
	if(id < 1 || id > 32 || !is_user_alive(id)) return PLUGIN_HANDLED

	Stock_Drop_Slot(id, 1)
	Set_BitVar(g_Had_DeathCue, id)

	g_BModeAmmo[id] = B_MAX_AMMO
	g_iMode[id] = MODE_NONE
	g_ShootCount[id] = 0
	g_ModeCStart[id] = 0.0
	g_Charge[id] = C_CHARGE_MAX
	g_ChargeStamp[id] = get_gametime()
	
	new ent = fm_give_item(id, weapon_deathcue)
	if(ent > 0)
	{
		set_pev(ent, pev_impulse, WEAPON_CODE)
		set_pdata_int(ent, OFFSET_CLIP, CLIP, OFFSET_LINUX_WEAPONS)
		cs_set_user_bpammo(id, CSW_DEATHCUE, BPAMMO)
	}
	
	if(Get_BitVar(g_Had_DeathCue, id) && cs_get_user_bpammo(id, CSW_DEATHCUE) < BPAMMO)
		cs_set_user_bpammo(id, CSW_DEATHCUE, BPAMMO)
	
	UpdateWeaponList(id, true)
	UpdateBModeAmmo(id)
	engclient_cmd(id, weapon_deathcue)

	return PLUGIN_HANDLED
}

public CSOWPN_Hook(id)
{
	engclient_cmd(id, weapon_deathcue)
	return PLUGIN_HANDLED
}

public CSOWPN_Remove(id)
{
	if(is_user_connected(id))
		UTIL_SetHud(id, RESET_HUD)

	UnSet_BitVar(g_Had_DeathCue, id)
	Reset_DeathCue(id)
	UpdateBModeAmmo(id)
}

public Reset_DeathCue(id)
{
	g_BModeAmmo[id] = 0
	g_iMode[id] = MODE_NONE
	g_ShootCount[id] = 0
	g_ModeCStart[id] = 0.0
	g_Charge[id] = C_CHARGE_MAX
	g_ChargeStamp[id] = get_gametime()
	Set_Fov(id)
	Remove_BarTime2(id)
	Aim_Remove(id)
	Gauge_Remove(id)
	CMode_Screen_Remove(id)
}

/* ==================================================
------------- Fakemeta's Forward Hook --------------
================================================== */
public fw_Forward_SetModel(ent, const model[])
{
	if(!IsValidPev(ent))
		return FMRES_IGNORED

	static szClassName[33]
	pev(ent, pev_classname, szClassName, charsmax(szClassName))

	if(!equal(szClassName, "weaponbox"))
		return FMRES_IGNORED

	if(!equal(model, old_w_model))
		return FMRES_IGNORED

	new iOwner = pev(ent, pev_owner)
	new wpn = fm_find_ent_by_owner(-1, weapon_deathcue, ent)

	if(wpn <= 0 || !pev_valid(wpn))
		return FMRES_IGNORED

	if(iOwner >= 1 && iOwner <= g_MaxPlayers && Get_BitVar(g_Had_DeathCue, iOwner) && pev(wpn, pev_impulse) == WEAPON_CODE)
	{
		UnSet_BitVar(g_Had_DeathCue, iOwner)
		engfunc(EngFunc_SetModel, ent, W_MODEL)
		return FMRES_SUPERCEDE
	}

	return FMRES_IGNORED
}

public fw_Forward_PostThink(id)
{
    if (!g_shieldActive[id])
        return;

    if (get_gametime() >= g_shieldEnd[id])
    {
        g_shieldActive[id] = false;
        g_shieldEnd[id]    = 0.0;

        if (is_user_alive(id))
        {
            set_pev(id, pev_takedamage, DAMAGE_AIM);
        }
    }
}

public fw_Forward_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if(!g_usEvent)
		return FMRES_IGNORED
	if(eventid != g_usEvent)
		return FMRES_IGNORED
	if(invoker < 1 || invoker > g_MaxPlayers)
		return FMRES_IGNORED
	if(get_user_weapon(invoker) != CSW_DEATHCUE || !Get_BitVar(g_Had_DeathCue, invoker))
		return FMRES_IGNORED

	return FMRES_SUPERCEDE
}

public fw_Forward_UpdateClientData_Post(iPlayer, iSendWeapons, iClientData)
{
    if(!is_user_alive(iPlayer))
        return FMRES_IGNORED

    if(get_user_weapon(iPlayer) == CSW_DEATHCUE && Get_BitVar(g_Had_DeathCue, iPlayer))
    {
        new Float:flNext
        if(g_iMode[iPlayer] == MODE_C)
            flNext = C_SPEED
        else if(get_pdata_float(iPlayer, OFFSET_PLAYER_NEXTATTACK, OFFSET_LINUX_PLAYER) > 0.0)
            flNext = get_pdata_float(iPlayer, OFFSET_PLAYER_NEXTATTACK, OFFSET_LINUX_PLAYER)
        else
            flNext = A_SPEED

        set_cd(iClientData, CD_flNextAttack, flNext)
    }
    return FMRES_IGNORED
}

// not registered (shockwave uses its real entity origin), kept for reference
public fw_AddToFullPack_Post(es, e, ent, host, hostflags, player, pSet)
{
	if(player || ent < 0 || ent >= MAX_ENTITIES || !g_bIsTrackedEntity[ent])
		return FMRES_IGNORED

	new impulse = pev(ent, pev_impulse)
	if(impulse == SHOCKWAVE_IMPULSE)
	{
		new id = pev(ent, pev_owner)
		if(id >= 1 && id <= g_MaxPlayers && is_user_alive(id))
		{
			new Float:vOrigin[3]
			pev(id, pev_origin, vO