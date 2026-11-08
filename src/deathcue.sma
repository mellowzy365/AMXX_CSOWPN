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

//#define USE_METADRAWER
#define MD_USE_IMAGE
#define USE_ZBHEROEX

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

/* ==================================================
------------------ HAM Player Hook's --------------
================================================== */
public HamC_TraceAttack_World(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_DEATHCUE || !Get_BitVar(g_Had_DeathCue, Attacker))
		return HAM_IGNORED
	if(g_iMode[Attacker] == MODE_C)
		return HAM_SUPERCEDE

	static Float:flEnd[3]
	get_tr2(Ptr, TR_vecEndPos, flEnd)

	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Ptr)

	SetHamParamFloat(3, random_float(A_DAMAGE, A_DAMAGE * 2.0))

	return HAM_IGNORED
}

public HamC_TraceAttack_Player(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_DEATHCUE || !Get_BitVar(g_Had_DeathCue, Attacker))
		return HAM_IGNORED
	if(g_iMode[Attacker] == MODE_C)
		return HAM_SUPERCEDE

	if(get_user_team(Victim) == get_user_team(Attacker))
		return HAM_IGNORED

	SetHamParamFloat(3, random_float(A_DAMAGE, A_DAMAGE * 2.0))

	return HAM_IGNORED
}

public HamC_Player_Killed_Post(victim)
{
	if(victim < 1 || victim > g_MaxPlayers) return
	UTIL_SetHud(victim, RESET_HUD)
	UnSet_BitVar(g_Had_DeathCue, victim)
	Reset_DeathCue(victim)
	UpdateBModeAmmo(victim)
}

public HamC_TakeDamage_Pre(victim, inflictor, attacker, Float:damage, damagebits)
{
	if(!is_user_alive(victim))
		return HAM_IGNORED

	if(g_shieldActive[victim])
		return HAM_SUPERCEDE

	// only DeathCue owners, once per round
	if(g_shieldUsed[victim] || !Get_BitVar(g_Had_DeathCue, victim) || damage <= 0.0)
		return HAM_IGNORED

	new Float:flHP, Float:flMaxHP
	pev(victim, pev_health, flHP)
	pev(victim, pev_max_health, flMaxHP)
	if(flMaxHP <= 0.0) flMaxHP = 100.0

	// HP after this hit
	if((flHP - damage) / flMaxHP * 100.0 >= HP_THRESHOLD)
		return HAM_IGNORED

	g_shieldUsed[victim]   = true
	g_shieldActive[victim] = true
	g_shieldEnd[victim]    = get_gametime() + SHIELD_DURATION
	set_pev(victim, pev_takedamage, DAMAGE_NO)

	// remove movement impediments
	set_pdata_float(victim, 108, 1.0, OFFSET_LINUX_PLAYER)    // m_flVelocityModifier (hit slowdown)
	set_pev(victim, pev_flags, pev(victim, pev_flags) & ~FL_FROZEN)

	// a hit that would kill is cancelled, other hits go through
	return (flHP - damage <= 0.0) ? HAM_SUPERCEDE : HAM_IGNORED
}

public HamC_Player_Spawn_Post(id)
{
	if(id < 1 || id > g_MaxPlayers || !is_user_alive(id)) return

	Reset_DeathCue(id)
	UpdateBModeAmmo(id)
}

/* ==================================================
------------------ HAM Weapon Hook's --------------
================================================== */

public HamC_Weapon_Deploy_Post(ent)
{
	new id = get_pdata_cbase(ent, OFFSET_WEAPON_OWNER, OFFSET_LINUX_WEAPONS)
	if(id < 1 || id > 32)
		return

	if(!Get_BitVar(g_Had_DeathCue, id))
	{
		if(g_bCustomHud[id]) UpdateWeaponList(id, false)
		return
	}

	set_pev(id, pev_viewmodel2, V_MODEL)
	set_pev(id, pev_weaponmodel2, P_MODEL)
	UpdateWeaponList(id, true)
	UpdateBModeAmmo(id)
	UTIL_SetHud(id, SET_CUSTOM_HUD)

	send_weapon_anim(id, ANIM_DRAW)
	Gauge_Show(id)   // draw the gauge on deploy (PostThink keeps empty/full in sync)

	set_pdata_float(ent, OFFSET_IDLE, 1.0, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_NEXT_PRIMARY, 0.4, OFFSET_LINUX_WEAPONS)
	set_pdata_float(id, OFFSET_PLAYER_NEXTATTACK, 0.4, OFFSET_LINUX_PLAYER)
	set_pdata_float(ent, OFFSET_NEXT_SECONDARY, 0.4, OFFSET_LINUX_WEAPONS)
}

public HamC_Item_AddToPlayer_Post(ent, id)
{
	if(!IsValidPev(ent) || id < 1 || id > g_MaxPlayers)
		return

	if(pev(ent, pev_impulse) == WEAPON_CODE)
	{
		Set_BitVar(g_Had_DeathCue, id)
		UpdateWeaponList(id, true)
		UpdateBModeAmmo(id)
	}
}

public HamC_Weapon_Holster_Post(ent)
{
	if(!IsValidPev(ent) || pev(ent, pev_impulse) != WEAPON_CODE)
		return

	new id = get_pdata_cbase(ent, OFFSET_WEAPON_OWNER, OFFSET_LINUX_WEAPONS)
	if(id < 1 || id > g_MaxPlayers)
		return

	Gauge_Remove(id)   // remove the gauge on holster

	// only end C mode (cooldown starts so swapping weapons can't skip it), keep B ammo etc.
	if(g_iMode[id] == MODE_C){
		End_ModeC(id)
		CMode_Screen_Remove(id)
	}
}

public HamC_Weapon_PostFrame_Pre(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	if(get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS) && get_pdata_float(id, OFFSET_PLAYER_NEXTATTACK, OFFSET_LINUX_PLAYER) <= 0.0)
	{
		new iClip = get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS)
		new iBp = cs_get_user_bpammo(id, CSW_DEATHCUE)
		new j = min(CLIP - iClip, iBp)

		set_pdata_int(ent, OFFSET_CLIP, iClip + j, OFFSET_LINUX_WEAPONS)
		
		cs_set_user_bpammo(id, CSW_DEATHCUE, iBp - j)
		set_pdata_int(ent, OFFSET_IN_RELOAD, 0, OFFSET_LINUX_WEAPONS)
	}

	WE_DeathCue(id, ent, pev(id, pev_button))
	return HAM_IGNORED
}

public HamC_Weapon_Idle_Pre(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	if(get_pdata_float(ent, OFFSET_IDLE, OFFSET_LINUX_WEAPONS) > 0.0)
		return HAM_IGNORED

	send_weapon_anim(id, g_iMode[id] == MODE_C ? ANIM_IDLE_MODEC : ANIM_IDLE)
	set_pdata_float(ent, OFFSET_IDLE, 20.0, OFFSET_LINUX_WEAPONS)
	return HAM_SUPERCEDE
}

public HamC_Weapon_Reload_Pre(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	if(get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS))
		return HAM_IGNORED

	if(get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS) >= CLIP || cs_get_user_bpammo(id, CSW_DEATHCUE) <= 0)
		return HAM_IGNORED

	set_pdata_int(ent, OFFSET_IN_RELOAD, 1, OFFSET_LINUX_WEAPONS)
	set_pdata_float(id, OFFSET_PLAYER_NEXTATTACK, RELOAD_TIME, OFFSET_LINUX_PLAYER)
	set_pdata_float(ent, OFFSET_NEXT_PRIMARY, RELOAD_TIME, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_NEXT_SECONDARY, RELOAD_TIME, OFFSET_LINUX_WEAPONS)
	set_pdata_float(ent, OFFSET_IDLE, RELOAD_TIME, OFFSET_LINUX_WEAPONS)

	send_weapon_anim(id, ANIM_RELOAD)
	
	if(g_iMode[id])
		Reset_DeathCue(id)
	
	return HAM_SUPERCEDE
}

public Ham_CWeapon_PrimaryAttack_Pre(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id)
		return HAM_IGNORED

	g_PreClip[id] = get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS)
	Stock_SetAccuracy(id, ent)
	set_pdata_int(ent, OFFSET_SHOTSFIRED, 0, OFFSET_LINUX_WEAPONS)
	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Post(ent)
{
	new id = Get_WeaponOwner(ent)
	if(!id) 
		return HAM_IGNORED
	
	// C mode never consumes ammo
	if(g_iMode[id] == MODE_C)
	{
		if(get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS) >= g_PreClip[id])
			return HAM_IGNORED

		set_pdata_int(ent, OFFSET_CLIP, g_PreClip[id], OFFSET_LINUX_WEAPONS)
	}
	else if(get_pdata_int(ent, OFFSET_CLIP, OFFSET_LINUX_WEAPONS) >= g_PreClip[id])
		return HAM_IGNORED
	
	if(g_iMode[id] != MODE_C)
	{
		send_weapon_anim(id, random_num(ANIM_SHOOTA,ANIM_SHOOTA2))
		
		emit_sound(id, CHAN_WEAPON, ExtraSounds[7], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		
		Stock_Muzzle(id, MF_CLASSNAME, MF_SPRITES)
		
		set_pdata_float(ent, OFFSET_NEXT_PRIMARY,   A_SPEED, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_NEXT_SECONDARY, A_SPEED, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_IDLE, 2.0, OFFSET_LINUX_WEAPONS)
		
		g_ShootCount[id] ++
		
		if(g_ShootCount[id] >= 15)
		{
			DeathQue_Shockwave(id)
			DeathQue_ProjectileB(id)
			emit_sound(id, CHAN_ITEM, ExtraSounds[8], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			if(g_BModeAmmo[id] < B_MAX_AMMO)
			{
				g_BModeAmmo[id]++
				UpdateBModeAmmo(id)
			}
			
			g_ShootCount[id] = 0
		}
	}else{
		send_weapon_anim(id, ANIM_SHOOTC)
		
		DeathQue_ProjectileC(id)
		Stock_Muzzle(id, MF_CLASSNAME, MF_SPRITES_C)
		
		g_ShootCount[id] += 1
		
		if(g_ShootCount[id] >= 6){
			DeathQue_Shockwave(id)
			emit_sound(id, CHAN_ITEM, ExtraSounds[8], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			g_ShootCount[id] = 0;
		}
		
		emit_sound(id, CHAN_WEAPON, ExtraSounds[11], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		
		set_pdata_float(ent, OFFSET_NEXT_PRIMARY,   C_SPEED, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_NEXT_SECONDARY, C_SPEED, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_IDLE, 2.0, OFFSET_LINUX_WEAPONS)
	}
	
	static Float:punch[3]
	punch[0] = random_float(-1.2, -0.6)
	punch[1] = 0.0
	punch[2] = 0.0
	set_pev(id, pev_punchangle, punch)
	
	return HAM_IGNORED
}

public Ham_CWeapon_OnPostThink(id)
{
	if(!is_user_alive(id) || !Get_BitVar(g_Had_DeathCue, id))
		return HAM_IGNORED

	Gauge_Update(id)   // fill / drain animation or full sprite, depending on the charge

	// C mode drains the charge 1 per second; it ends when the charge is empty
	if(g_iMode[id] == MODE_C && get_gametime() - g_ModeCStart[id] >= g_Charge[id])
	{
		// C mode ended -> charge starts refilling
		End_ModeC(id)

		if(get_user_weapon(id) == CSW_DEATHCUE)
		{
			send_weapon_anim(id, ANIM_MODEC_END)

			new ent = get_pdata_cbase(id, OFFSET_PLAYER_ACTIVEITEM, OFFSET_LINUX_PLAYER)
			if(ent > 0 && pev_valid(ent)){
				set_pdata_float(ent, OFFSET_NEXT_PRIMARY, 0.5, OFFSET_LINUX_WEAPONS)
				set_pdata_float(ent, OFFSET_NEXT_SECONDARY, 0.5, OFFSET_LINUX_WEAPONS)
				set_pdata_float(ent, OFFSET_IDLE, 1.5, OFFSET_LINUX_WEAPONS)
			}
		}
	}

#if !defined USE_METADRAWER
	// keep the real origin of the frame sprites at the eye (PVS)
	if(g_iMode[id] == MODE_C)
		Aim_Update(id)
#endif

	return HAM_IGNORED
}

/* ==================================================
------------------ DeathCue Systems -----------------
================================================== */
#if defined USE_METADRAWER

// Draws the 4 corner sprites on the owner's screen
Aim_Create(id)
{
	Aim_Remove(id)

	if(!is_user_connected(id))
		return

	// stretch each corner to a quarter of the screen (0 = original sprite size)
	new sw = md_getscreenwidth(), sh = md_getscreenheight()
	new w = 0, h = 0
	if(sw > 0 && sh > 0)
	{
		w = floatround((float(sw) / 2.0) * AIM_COVER, floatround_ceil)
		h = floatround((float(sh) / 2.0) * AIM_COVER, floatround_ceil)
	}

	for(new i = 0; i < AIM_COUNT; i++)
	{
	#if defined MD_USE_IMAGE
		md_drawimage(id, AIM_CHANNEL + i, 0, AimFrameImages[i], 0.0, 0.0, 0, 0, 255, 255, 255, 255, 0.0, 0.0, 0.0, AimAlign[i], w, h)
	#else
		md_drawsprite(id, AIM_CHANNEL + i, 0, AimFrameSprites[i], 0.0, 0.0, 0, 0, 255, 255, 255, 255, 0.0, 0.0, 0.0, SPR_ADDITIVE, AimAlign[i], w, h)
	#endif
	}

	g_bAimDrawn[id] = true
}

Aim_Remove(id)
{
	if(!g_bAimDrawn[id])
		return

	g_bAimDrawn[id] = false

	if(!is_user_connected(id))
		return

	for(new i = 0; i < AIM_COUNT; i++)
	{
	#if defined MD_USE_IMAGE
		md_removedrawing(id, 1, AIM_CHANNEL + i)    // 1 = md_drawimage
	#else
		md_removedrawing(id, 2, AIM_CHANNEL + i)    // 2 = md_drawsprite
	#endif
	}
}

#else

// Creates the 4 corner sprites of the C mode screen frame
Aim_Create(id)
{
	Aim_Remove(id)

	for(new i = 0; i < AIM_COUNT; i++)
	{
		new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
		if(ent <= 0 || !pev_valid(ent)) continue

		set_pev(ent, pev_classname, AIM_CLASSNAME)
		set_pev(ent, pev_impulse, AIM_IMPULSE)
		set_pev(ent, pev_owner, id)
		set_pev(ent, pev_iuser2, i)               // corner index: 0 TL, 1 TR, 2 BL, 3 BR

		engfunc(EngFunc_SetModel, ent, AimFrameSprites[i])
		set_pev(ent, pev_solid, SOLID_NOT)
		set_pev(ent, pev_movetype, MOVETYPE_NONE)
		set_pev(ent, pev_rendermode, kRenderTransAdd)
		set_pev(ent, pev_renderamt, 255.0)
		set_pev(ent, pev_scale, AIM_SIZE / 256.0)
		set_pev(ent, pev_frame, 0.0)

		if(ent < MAX_ENTITIES) g_bIsAimFrame[ent] = true
		g_AimEnt[id][i] = ent
	}

	Aim_Update(id)
}

Aim_Remove(id)
{
	for(new i = 0; i < AIM_COUNT; i++)
	{
		new ent = g_AimEnt[id][i]
		g_AimEnt[id][i] = 0

		if(ent <= 0 || !pev_valid(ent) || pev(ent, pev_impulse) != AIM_IMPULSE)
			continue

		if(ent < MAX_ENTITIES) g_bIsAimFrame[ent] = false
		engfunc(EngFunc_RemoveEntity, ent)
	}
}

Aim_Update(id)
{
	static Float:eye[3]
	GetEyePos(id, eye)

	for(new i = 0; i < AIM_COUNT; i++)
	{
		new ent = g_AimEnt[id][i]
		if(ent > 0 && pev_valid(ent))
			engfunc(EngFunc_SetOrigin, ent, eye)
	}
}

public fw_AddToFullPack_Aim_Post(es, e, ent, host, hostflags, player, pSet)
{
	if(player || ent < 0 || ent >= MAX_ENTITIES || !g_bIsAimFrame[ent])
		return FMRES_IGNORED

	if(pev(ent, pev_impulse) != AIM_IMPULSE)
	{
		g_bIsAimFrame[ent] = false   // stale flag (entity was freed/reused)
		return FMRES_IGNORED
	}

	if(pev(ent, pev_owner) != host)
	{
		set_es(es, ES_Effects, get_es(es, ES_Effects) | EF_NODRAW)
		return FMRES_IGNORED
	}

	// corner order: top-left, top-right, bottom-left, bottom-right
	static const Float:sx[4] = {-1.0, 1.0, -1.0, 1.0}
	static const Float:sy[4] = {1.0, 1.0, -1.0, -1.0}

	static Float:eye[3], Float:ang[3], Float:vel[3]
	static Float:fwd[3], Float:right[3], Float:up[3]
	static Float:org[3], Float:tmp[3]

	new corner = pev(ent, pev_iuser2)
	if(corner < 0 || corner >= AIM_COUNT)
		return FMRES_IGNORED

	GetEyePos(host, eye)
	pev(host, pev_v_angle, ang)

#if AIM_PING_COMP
	new ping, loss
	get_user_ping(host, ping, loss)
	pev(host, pev_velocity, vel)
	xs_vec_mul_scalar(vel, float(ping) * 0.001, tmp)
	xs_vec_add(eye, tmp, eye)
#endif

	angle_vector(ang, ANGLEVECTOR_FORWARD, fwd)
	angle_vector(ang, ANGLEVECTOR_RIGHT, right)
	angle_vector(ang, ANGLEVECTOR_UP, up)

	xs_vec_mul_scalar(fwd, AIM_DIST, tmp)
	xs_vec_add(eye, tmp, org)
	xs_vec_mul_scalar(right, sx[corner] * (AIM_HALF_W - AIM_SIZE / 2.0), tmp)
	xs_vec_add(org, tmp, org)
	xs_vec_mul_scalar(up, sy[corner] * (AIM_HALF_H - AIM_SIZE / 2.0), tmp)
	xs_vec_add(org, tmp, org)

	set_es(es, ES_Origin, org)
	set_es(es, ES_Effects, get_es(es, ES_Effects) | EF_NOINTERP)

	return FMRES_IGNORED
}

#endif

// Current charge in seconds (drains in C mode, refills outside of it)
Float:Get_Charge(id)
{
	new Float:flNow = get_gametime()

	if(g_iMode[id] == MODE_C)
		return floatmax(0.0, g_Charge[id] - (flNow - g_ModeCStart[id]))

	return floatmin(C_CHARGE_MAX, g_Charge[id] + (flNow - g_ChargeStamp[id]) * C_CHARGE_RATE)
}

#if defined USE_METADRAWER

// Forces a redraw (used on deploy)
Gauge_Show(id)
{
	g_iGauge[id] = GAUGE_STATE_NONE
	Gauge_Update(id)
}

// Frame rate so that the GAUGE_FRAMES animation lasts flSeconds (21 frames over 7 s = 3 fps)
Gauge_Fps(Float:flSeconds)
{
	if(flSeconds < 0.1)
		flSeconds = 0.1

	return max(1, floatround(float(GAUGE_FRAMES) / flSeconds))
}

// Starts / switches the gauge animation depending on the charge state.
// MetaDrawer can't pick a frame, so the whole 21 frame animation is played over the time the
// charge needs to fill / drain (exact when it runs from empty to full or full to empty).
// Only talks to the client when the state changes.
Gauge_Update(id)
{
	if(!is_user_connected(id) || is_user_bot(id))
		return
	if(get_user_weapon(id) != CSW_DEATHCUE)
		return

	new Float:flCharge = Get_Charge(id)
	new iWant

	if(g_iMode[id] == MODE_C)
		iWant = GAUGE_STATE_DRAIN
	else if(flCharge >= C_CHARGE_MAX)
		iWant = GAUGE_STATE_FULL
	else
		iWant = GAUGE_STATE_FILL

	if(iWant == g_iGauge[id])
		return

	g_iGauge[id] = iWant

	md_removedrawing(id, 2, GAUGE_CHANNEL)    // clear the previous state first

	switch(iWant)
	{
		case GAUGE_STATE_FULL:
		{
			md_drawsprite(id, GAUGE_CHANNEL, 0, GAUGE_FULL_SPR, GAUGE_X, GAUGE_Y, 1, 1, 255, 255, 255, 255, 0.0, 0.0, 0.0, SPR_ADDITIVE)
		}
		case GAUGE_STATE_FILL:
		{
			new iFps = Gauge_Fps((C_CHARGE_MAX - flCharge) / C_CHARGE_RATE)
			md_playsprite(id, GAUGE_CHANNEL, GAUGE_FILL_SPR, GAUGE_X, GAUGE_Y, 1, 1, 255, 255, 255, 255, SPR_ADDITIVE, iFps, 0)
		}
		case GAUGE_STATE_DRAIN:
		{
			new iFps = Gauge_Fps(flCharge)
			md_playsprite(id, GAUGE_CHANNEL, GAUGE_DRAIN_SPR, GAUGE_X, GAUGE_Y, 1, 1, 255, 255, 255, 255, SPR_ADDITIVE, iFps, 0)
		}
	}
}

Gauge_Remove(id)
{
	if(g_iGauge[id] == GAUGE_STATE_NONE)
		return

	g_iGauge[id] = GAUGE_STATE_NONE

	if(is_user_connected(id))
		md_removedrawing(id, 2, GAUGE_CHANNEL)    // 2 = md_drawsprite
}

#else

// no MetaDrawer: gauge is not drawn
Gauge_Show(id)
{
	#pragma unused id
}

Gauge_Update(id)
{
	#pragma unused id
}

Gauge_Remove(id)
{
	#pragma unused id
}

#endif

// Ends C mode, restores FOV and starts refilling the charge (bar is sent once, it fills by itself)
End_ModeC(id)
{
	new Float:flCharge = Get_Charge(id)

	g_iMode[id] = MODE_NONE
	g_ModeCStart[id] = 0.0
	g_Charge[id] = flCharge
	g_ChargeStamp[id] = get_gametime()

	Aim_Remove(id)
	Set_Fov(id, 90)
	
#if !defined USE_METADRAWER
	CMode_Screen_Remove(id)
	BarTime2(id, floatround((C_CHARGE_MAX - flCharge) / C_CHARGE_RATE), floatround(flCharge / C_CHARGE_MAX * 100.0))
#endif
}

WE_DeathCue(id, ent, iButton)
{
	if(!IsValidPev(ent)) return
	if(!is_user_alive(id)) return
	if(!Get_BitVar(g_Had_DeathCue, id)) return
	if(get_pdata_int(ent, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS)) return

	// both buttons -> enter C mode (only when the cooldown is over)
	if((iButton & IN_ATTACK) && (iButton & IN_ATTACK2) && g_iMode[id] == MODE_NONE)
	{
		// not enough charge; return so the B shot doesn't fire while both keys are held
		new Float:flCharge = Get_Charge(id)
		if(flCharge <= C_CHARGE_MIN)
			return

		g_iMode[id] = MODE_C
		g_Charge[id] = flCharge
		g_ModeCStart[id] = get_gametime()
		g_ShootCount[id] = 0

		Set_Fov(id, 75)
#if !defined USE_METADRAWER
		BarTime2(id, floatround(flCharge), 0)
		CMode_Screen_Draw(id)
#endif
		Aim_Create(id)

		send_weapon_anim(id, ANIM_MODEC_START)
		emit_sound(id, CHAN_ITEM, ExtraSounds[5], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

		set_pdata_float(ent, OFFSET_NEXT_PRIMARY, 0.6, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_NEXT_SECONDARY, 0.6, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_IDLE, B_SPEED + 0.6, OFFSET_LINUX_WEAPONS)
		return
	}

	// B shot (green missile)
	if((g_iMode[id] != MODE_C && iButton & IN_ATTACK2) && g_BModeAmmo[id] > 0 && get_pdata_float(ent, OFFSET_NEXT_SECONDARY, OFFSET_LINUX_WEAPONS) <= 0.0)
	{
		g_BModeAmmo[id]--
		UpdateBModeAmmo(id)

		send_weapon_anim(id, ANIM_SHOOTB)

		DeathQue_Projectile_Green(id)
		Stock_Muzzle(id, MF_CLASSNAME, MF_SPRITES_GREEN)

		emit_sound(id, CHAN_WEAPON, ExtraSounds[9], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

		set_pdata_float(ent, OFFSET_NEXT_PRIMARY, B_SPEED, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_NEXT_SECONDARY, B_SPEED, OFFSET_LINUX_WEAPONS)
		set_pdata_float(ent, OFFSET_IDLE, B_SPEED + 0.6, OFFSET_LINUX_WEAPONS)

		fake_recoil(id, 3.0)
	}
}

/* ==================================================
------------------ ALL Entities --------------------
================================================== */
DeathQue_Shockwave(id)
{
	RemoveShockwaveEntity(id)
	
	new Float:vAim[3], Float:vGround[3], Float:vAbsMin[3]
	pev(id, pev_v_angle, vAim)
	pev(id, pev_origin, vGround)
	pev(id, pev_absmin, vAbsMin)
	vGround[2] = vAbsMin[2] + 1.0
	
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!IsValidPev(ent))
		return
	
	set_pev(ent, pev_classname, SHOCKWAVE_CLASSNAME)
	set_pev(ent, pev_impulse, SHOCKWAVE_IMPULSE)
	set_pev(ent, pev_owner, id)
	
	if(ent < MAX_ENTITIES)
		g_bIsTrackedEntity[ent] = true
	
	engfunc(EngFunc_SetModel, ent, SHOCKWAVE_SPRITES)
	engfunc(EngFunc_SetOrigin, ent, vGround)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_movetype, MOVETYPE_NONE)  // FOLLOW onto the player hides the sprite: follow manually in think instead

	set_pev(ent, pev_effects, 0)
	set_pev(ent, pev_framerate, 0.0)
	
	new Float:vAng[3]
	vAng[0] = 90.0
	vAng[1] = vAim[1]
	vAng[2] = 0.0
	set_pev(ent, pev_angles, vAng)

	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	set_pev(ent, pev_scale, Float:SHOCKWAVE_SCALE_START)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_nextthink, get_gametime() + 0.05)
	
	do_damages(id, CSW_DEATHCUE, vGround, SHOCKWAVE_RADIUS, SHOCKWAVE_DAMAGE, SHOCKWAVE_KNOCKBACK, (DMG_NEVERGIB | DMG_BULLET))
}

RemoveShockwaveEntity(owner)
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", SHOCKWAVE_CLASSNAME)) != 0)
	{
		if(pev(ent, pev_owner) == owner)
		{
			if(ent < MAX_ENTITIES) g_bIsTrackedEntity[ent] = false
			set_pev(ent, pev_flags, FL_KILLME)
		}
	}
}

// Generic missile creator
Missile_Create(id, const szClass[], const szSprite[], iImpulse)
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

	xs_vec_mul_scalar(fwd, 2048.0, vel)
	vector_to_angle(vel, angles)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(ent <= 0 || !pev_valid(ent)) return

	set_pev(ent, pev_classname, szClass)
	set_pev(ent, pev_impulse, iImpulse)
	set_pev(ent, pev_movetype, MOVETYPE_BOUNCE)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_iuser1, g_iMode[id])

	engfunc(EngFunc_SetModel, ent, szSprite)
	engfunc(EngFunc_SetSize, ent, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0})
	engfunc(EngFunc_SetOrigin, ent, org)

	set_pev(ent, pev_angles, angles)
	set_pev(ent, pev_velocity, vel)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	set_pev(ent, pev_scale, 0.25)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_fuser1, get_gametime() + 3.0)
	set_pev(ent, pev_nextthink, get_gametime() + 0.03)
	
	// laserbeam trail (width in 0.1 unit steps, life in 0.1s steps)
	if(equal(szClass, MISSILE_GREEN_CLASSNAME))
		CreateEntTrail(ent, 3, 10, 0, 255, 80)     // green
	else
		CreateEntTrail(ent, 3, 10, 0, 150, 255)    // blue
}

// Missile A (small blue, normal mode)
DeathQue_ProjectileB(id)
{
	Missile_Create(id, MISSILE_A_CLASSNAME, MISSILE_A_SPRITES, MISSILE_A_IMPULSE)
}

DeathQue_ProjectileB_Explo(ent)
{
	static Float:origin[3]
	pev(ent, pev_origin, origin)
	new owner = pev(ent, pev_owner)

	Explo_Effect(origin, g_iExploA, 12)
	emit_sound(ent, CHAN_ITEM, ExtraSounds[10], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	do_damages(owner, CSW_DEATHCUE, origin, EXPLO_BLUE_A_RADIUS, EXPLO_BLUE_A_DAMAGE, EXPLO_KNOCKBACK, (DMG_NEVERGIB | DMG_BULLET))
}

// Missile B (big blue, C mode)
DeathQue_ProjectileC(id)
{
	Missile_Create(id, MISSILE_B_CLASSNAME, MISSILE_A_SPRITES, MISSILE_B_IMPULSE)
}

DeathQue_ProjectileC_Explo(ent)
{
	static Float:origin[3]
	pev(ent, pev_origin, origin)
	new owner = pev(ent, pev_owner)

	Explo_Effect(origin, g_iExploA, 20)
	emit_sound(ent, CHAN_ITEM, ExtraSounds[10], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	do_damages(owner, CSW_DEATHCUE, origin, EXPLO_BLUE_B_RADIUS, EXPLO_BLUE_B_DAMAGE, EXPLO_KNOCKBACK, (DMG_NEVERGIB | DMG_BULLET))
}

// Green missile (B shot, heals owner)
DeathQue_Projectile_Green(id)
{
	Missile_Create(id, MISSILE_GREEN_CLASSNAME, MISSILE_B_SPRITES, 0)
}

DeathQue_ProjectileGreen_Explo(ent)
{
	static Float:origin[3]
	pev(ent, pev_origin, origin)
	new owner = pev(ent, pev_owner)

	Explo_Effect(origin, g_iExploB, 20)
	emit_sound(ent, CHAN_ITEM, ExtraSounds[12], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	do_damages(owner, CSW_DEATHCUE, origin, EXPLO_GREEN_RADIUS, EXPLO_GREEN_DAMAGE, EXPLO_KNOCKBACK, (DMG_NEVERGIB | DMG_BULLET))

	// heal the owner if standing inside the explosion
	if(owner >= 1 && owner <= g_MaxPlayers && is_user_alive(owner))
	{
		static Float:oOrg[3]
		pev(owner, pev_origin, oOrg)

		if(get_distance_f(oOrg, origin) <= EXPLO_GREEN_RADIUS)
		{
			new Float:flHealth;                    // <-- baca HP dulu
			pev(owner, pev_health, flHealth);      // <-- isi flHealth

			new Float:flNewHealth = flHealth + EXPLO_GREEN_HEALING;
			if (flNewHealth > EXPLO_GREEN_MAX_HP)
			flNewHealth = EXPLO_GREEN_MAX_HP;

			set_pev(owner, pev_health, flNewHealth);
		}
	}
}

Explo_Effect(Float:origin[3], iSprite, iScale)
{
	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, origin, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, origin[0])
	engfunc(EngFunc_WriteCoord, origin[1])
	engfunc(EngFunc_WriteCoord, origin[2])
	write_short(iSprite)
	write_byte(iScale)
	write_byte(30)
	write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	message_end()
}

Missile_Explode(ent)
{
	static szClass[32]
	pev(ent, pev_classname, szClass, charsmax(szClass))

	if(equal(szClass, MISSILE_A_CLASSNAME))
		DeathQue_ProjectileB_Explo(ent)
	else if(equal(szClass, MISSILE_B_CLASSNAME))
		DeathQue_ProjectileC_Explo(ent)
	else
		DeathQue_ProjectileGreen_Explo(ent)

	engfunc(EngFunc_RemoveEntity, ent)
}

/* ==================================================
------------------ ALL Entities Think ---------------
================================================== */
public fw_Forward_Think(ent)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	static szClass[32]
	pev(ent, pev_classname, szClass, charsmax(szClass))

	new Float:flNow = get_gametime()

	// ---- muzzleflash ----
	if(equal(szClass, MF_CLASSNAME))
	{
		new iOwner = pev(ent, pev_owner)

		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_DEATHCUE)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		new Float:Frame
		pev(ent, pev_frame, Frame)
		if(Frame > 4.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.0
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, flNow + 0.04)
		return FMRES_IGNORED
	}
	
	// ---- gauge (only used if Stock_Bar is enabled) ----
	if(equal(szClass, GAUGE_CLASSNAME))
	{
		new iOwner = pev(ent, pev_owner)

		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_DEATHCUE)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}
		
		// MOVETYPE_FOLLOW positions the sprite, don't call SetOrigin here
		if(Get_Charge(iOwner) > C_CHARGE_MIN)
			engfunc(EngFunc_SetModel, ent, GAUGE_EMPTY_SPRITES)
		else
			engfunc(EngFunc_SetModel, ent, GAUGE_FULL_SPRITES)

		set_pev(ent, pev_nextthink, flNow + 0.04)
		return FMRES_IGNORED
	}

	// ---- missiles ----
	if(equal(szClass, MISSILE_A_CLASSNAME) || equal(szClass, MISSILE_B_CLASSNAME) || equal(szClass, MISSILE_GREEN_CLASSNAME))
	{
		new Float:flDeadline, Float:flFrame
		pev(ent, pev_fuser1, flDeadline)

		if(flNow >= flDeadline)
		{
			Missile_Explode(ent)
			return FMRES_IGNORED
		}

		pev(ent, pev_frame, flFrame)
		flFrame += 1.0
		if(flFrame >= 9.0) flFrame = 0.0
		set_pev(ent, pev_frame, flFrame)
		set_pev(ent, pev_nextthink, flNow + 0.03)
		return FMRES_IGNORED
	}
	
	else if(equal(szClass, SHOCKWAVE_CLASSNAME))
	{
		new Float:scale, Float:amt, Float:frame
		pev(ent, pev_scale, scale)
		pev(ent, pev_renderamt, amt)
		pev(ent, pev_frame, frame)

		if(scale < Float:SHOCKWAVE_SCALE_END)
		{
			scale += Float:SHOCKWAVE_SCALE_SPEED
			if(scale > Float:SHOCKWAVE_SCALE_END) scale = Float:SHOCKWAVE_SCALE_END
		}

		amt -= Float:SHOCKWAVE_FADE_SPEED

		if(amt <= 0.0)
		{
			if(ent < MAX_ENTITIES) g_bIsTrackedEntity[ent] = false
			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_IGNORED
		}

		// follow the owner's feet
		new iOwner = pev(ent, pev_owner)
		if(iOwner >= 1 && iOwner <= g_MaxPlayers && is_user_alive(iOwner))
		{
			new Float:vFeet[3], Float:vOwnerMin[3]
			pev(iOwner, pev_origin, vFeet)
			pev(iOwner, pev_absmin, vOwnerMin)
			vFeet[2] = vOwnerMin[2] + 1.0
			engfunc(EngFunc_SetOrigin, ent, vFeet)
		}

		// advance sprite frames (frame 0 may be blank), clamp at last frame (max frame 14)
		frame += 1.4
		if(frame > 14.0) frame = 14.0

		set_pev(ent, pev_frame, frame)
		set_pev(ent, pev_scale, scale)
		set_pev(ent, pev_renderamt, amt)
		set_pev(ent, pev_nextthink, flNow + 0.05)
	}

	return FMRES_IGNORED
}

public fw_Forward_Touch(ent, ptr)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	static szClass[32]
	pev(ent, pev_classname, szClass, charsmax(szClass))

	if(!equal(szClass, MISSILE_A_CLASSNAME) && !equal(szClass, MISSILE_B_CLASSNAME) && !equal(szClass, MISSILE_GREEN_CLASSNAME))
		return FMRES_IGNORED

	if(ptr == pev(ent, pev_owner))
		return FMRES_IGNORED

	// the explosion radius already covers whatever the missile hit
	Missile_Explode(ent)
	return FMRES_SUPERCEDE
}

/* ==================================================
------------------ Weapon Stocks --------------
================================================== */
Get_WeaponOwner(ent)
{
	if(!IsValidPev(ent))
		return 0

	if(pev(ent, pev_impulse) != WEAPON_CODE)
		return 0

	new id = get_pdata_cbase(ent, OFFSET_WEAPON_OWNER, OFFSET_LINUX_WEAPONS)
	if(id < 1 || id > g_MaxPlayers || !Get_BitVar(g_Had_DeathCue, id))
		return 0
	return id
}

GetEyePos(id, Float:out[3])
{
	static Float:o[3], Float:v[3]
	pev(id, pev_origin, o)
	pev(id, pev_view_ofs, v)
	xs_vec_add(o, v, out)
}

// single-target damage + knockback
stock Damage_Victim(attacker, victim, Float:fDmg, Float:flkb, dmgbits)
{
	if(!is_user_connected(attacker))
		return

	new inflictor = fm_get_user_weapon_entity(attacker, CSW_DEATHCUE)
	if(inflictor <= 0 || !IsValidPev(inflictor))
		inflictor = attacker

	static Float:vOrigin[3]
	pev(victim, pev_origin, vOrigin)

	ExecuteHamB(Ham_TakeDamage, victim, inflictor, attacker, fDmg, dmgbits)
	Stock_Fake_KnockBack(attacker, victim, flkb, 100.0, random_float(5.0, 25.0))
	FX_Blood(vOrigin)
}

stock do_damages(id, CSWPN, Float:Origin[3], Float:Radius, Float:fDmg, Float:flkb, dmgbits)
{
	if(!is_user_connected(id))
		return

	new inflictor = fm_get_user_weapon_entity(id, CSWPN)
	if(inflictor <= 0 || !IsValidPev(inflictor))
		inflictor = id

	Radius_Damage(id, inflictor, Origin, Radius, fDmg, flkb, dmgbits)
}

stock Radius_Damage(id, inflictor, Float:vicOri[3], Float:fRadius, Float:fDamage, Float:flkb, dmgbits)
{
	new i = -1
	static Float:vOrigin[3]

	while((i = fm_find_ent_in_sphere(i, vicOri, fRadius)) != 0)
	{
		if(i == id) continue
		if(pev(i, pev_takedamage) == DAMAGE_NO) continue

		// func_breakable with TRIGGER_ONLY flag - skip (bitmask, not equality)
		if(pev(i, pev_spawnflags) & SF_BREAK_TRIGGER_ONLY) continue

		pev(i, pev_origin, vOrigin)

		if(i <= g_MaxPlayers)
		{
			if(!is_user_alive(i)) continue

			// skip teammates
			if(get_user_team(i) == get_user_team(id))
				continue
		}

		ExecuteHamB(Ham_TakeDamage, i, inflictor, id, fDamage, dmgbits)

		if(i <= g_MaxPlayers)
		{
			Stock_Fake_KnockBack(id, i, flkb, 100.0, random_float(5.0, 25.0))
			FX_Blood(vOrigin)
		}
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

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM_ID, _, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

stock Stock_Muzzle(iPlayer, const szcls[], const szmodel[])
{
	new Ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(Ent <= 0 || !pev_valid(Ent)) return

	set_pev(Ent, pev_classname, szcls)

	set_pev(Ent, pev_owner, iPlayer)
	set_pev(Ent, pev_body, 1)
	set_pev(Ent, pev_skin, iPlayer)
	set_pev(Ent, pev_aiment, iPlayer)
	set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)

	set_pev(Ent, pev_scale, 0.1)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 20.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)

	set_pev(Ent, pev_nextthink, get_gametime() + 0.04)
}

stock Stock_Bar(iPlayer, iBody, Float:szScale, const szcls[], const szmodel[])
{
	new Ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(Ent <= 0 || !pev_valid(Ent)) return

	set_pev(Ent, pev_classname, szcls)

	set_pev(Ent, pev_owner, iPlayer)
	set_pev(Ent, pev_body, iBody)
	set_pev(Ent, pev_skin, iPlayer)
	set_pev(Ent, pev_aiment, iPlayer)
	set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)

	set_pev(Ent, pev_scale, szScale)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 15.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)

	set_pev(Ent, pev_nextthink, get_gametime() + 0.04)
}

stock Stock_Drop_Slot(id, iSlot)
{
	new weapons[32], num
	get_user_weapons(id, weapons, num)

	for(new i = 0; i < num; i++)
	{
		if(iSlot == 1 && (PRIMARY_WEAPONS_BIT_SUM & (1<<weapons[i])))
		{
			static wname[32]
			get_weaponname(weapons[i], wname, charsmax(wname))
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
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BLOODSPRITE)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(g_iBloodSpray)   // sprite1: initial spray
	write_short(g_iBloodDrop)    // sprite2: falling droplets
	write_byte(color)            // palette color index
	write_byte(scale)            // size
	message_end()
}

stock fake_recoil(id, Float:pitch, Float:yaw = 0.0, Float:roll = 0.0)
{
	if(!is_user_alive(id))
		return

	new Float:punch[3]
	punch[0] = pitch
	punch[1] = yaw
	punch[2] = roll

	set_pev(id, pev_punchangle, punch)
}

stock Make_BulletHole(id, Float:Origin[3], Float:Damage)
{
	new Decal = random_num(41, 45)
	new LoopTime = (Damage > 100.0) ? 2 : 1

	for(new i = 0; i < LoopTime; i++)
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_WORLDDECAL)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_byte(Decal)
		message_end()

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_GUNSHOTDECAL)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_short(id)
		write_byte(Decal)
		message_end()
	}
}

stock Make_BulletSmoke(TrResult)
{
	static Float:vecEnd[3], Float:vecNormal[3]

	get_tr2(TrResult, TR_vecEndPos, vecEnd)
	get_tr2(TrResult, TR_vecPlaneNormal, vecNormal)

	xs_vec_mul_scalar(vecNormal, 2.5, vecNormal)
	xs_vec_add(vecEnd, vecNormal, vecEnd)

	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, vecEnd, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, vecEnd[0])
	engfunc(EngFunc_WriteCoord, vecEnd[1])
	engfunc(EngFunc_WriteCoord, vecEnd[2] - 10.0)
	write_short(g_SmokePuff_SprId)
	write_byte(2)
	write_byte(50)
	write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	message_end()
}

UpdateWeaponList(id, bool:custom)
{
	g_bCustomHud[id] = custom

	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	if(custom) write_string(weapon_spr)
	else       write_string(weapon_deathcue)
	write_byte(WPN_AMMO_ID)
	write_byte(WPN_AMMO_MAX)
	write_byte(custom ? WPN_AMMO2_ID : -1)   // secondary ammo type (B mode counter)
	write_byte(custom ? B_MAX_AMMO   : -1)   // secondary ammo max
	write_byte(WPN_SLOT)
	write_byte(WPN_SLOT_POS)
	write_byte(CSW_DEATHCUE)
	write_byte(0)
	message_end()
}

// Sends the B mode counter to the client's secondary ammo HUD (ammo2 in weapon_deathcue.txt)
stock UpdateBModeAmmo(id)
{
	if(!is_user_connected(id))
		return

	message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoX, _, id)
	write_byte(WPN_AMMO2_ID)
	write_byte(g_BModeAmmo[id])
	message_end()
}

stock Set_Fov(id, fov = 90)
{
	if(!is_user_connected(id))
		return

	if(fov < 60)  fov = 60
	if(fov > 120) fov = 120

	static msg
	if(!msg) msg = get_user_msgid("SetFOV")

	message_begin(MSG_ONE, msg, _, id)
	write_byte(fov)
	message_end()
}

stock BarTime2(id, times, percent)
{
	if(!is_user_connected(id))
		return

	static msg
	if(!msg) msg = get_user_msgid("BarTime2")

	message_begin(MSG_ONE, msg, _, id)
	write_short(times)
	write_short(percent)
	message_end()
}

stock Remove_BarTime2(id)
{
	BarTime2(id, 0, 0)
}

// laserbeam trail following an entity (life/width in 0.1 steps)
stock CreateEntTrail(ent, life, width, r, g, b)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)
	write_short(ent)
	write_short(g_iTrailSpr)
	write_byte(life)
	write_byte(width)
	write_byte(r)
	write_byte(g)
	write_byte(b)
	write_byte(200)      // brightness
	message_end()
}

stock Stock_SetAccuracy(id, ent)
{
	static Float:flAcc, Float:vecVel[3]
	pev(id, pev_velocity, vecVel)
	vecVel[2] = 0.0

	if(!(pev(id, pev_flags) & FL_ONGROUND))
		flAcc = (ACC_SPREAD_AIR - 0.035) / 0.4
	else if(vector_length(vecVel) > ACC_SPEED_LIMIT)
		flAcc = (ACC_SPREAD_MOVE - 0.035) / 0.07
	else
		flAcc = ACC_SPREAD_STAND / 0.02

	if(flAcc < 0.0) flAcc = 0.0
	set_pdata_float(ent, 62, flAcc, 4)
}

stock CMode_Screen_Draw(id)
{
    if (!is_user_alive(id))
        return PLUGIN_HANDLED;

    message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenFade"), _, id);
    write_short(1<<12);   // duration
    write_short(1<<12);   // holdTime
    write_short(0);       // FFADE_IN
    write_byte(0);        // red
    write_byte(255);      // green
    write_byte(255);      // blue
    write_byte(100);      // alpha
    message_end();

    return PLUGIN_HANDLED;
}

stock CMode_Screen_Remove(id)
{
    if (!is_user_alive(id))
        return PLUGIN_HANDLED;

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
