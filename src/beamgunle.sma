#include <amxmodx>
#include <engine>
#include <amxmisc>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <fun>
#include <xs>

//zbheroex from Dias Ultimate plugins pack https://forums.alliedmods.net/showthread.php?t=294818
#define USE_ZBHEROEX

#if defined USE_ZBHEROEX
	#include <zombie_theheroex>
#endif

#define PLUGIN  "Gigabreak"
#define VERSION "1.0"
#define AUTHOR  "Mellowzy"

/* ================= CONFIG ================= */
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) (pev_valid(%0) == 2)

#define GetSecondaryAmmo(%0)       get_pdata_int(%0, m_rgAmmo + WeaponSecondaryAmmoIndex, linux_diff_player)
#define SetSecondaryAmmo(%0,%1)    set_pdata_int(%0, m_rgAmmo + WeaponSecondaryAmmoIndex, %1, linux_diff_player)
#define HIDEHUD_MONEY  (1<<5)
#define SET_CUSTOM_HUD (HIDEHUD_MONEY)
#define RESET_HUD      0

#if !defined SF_SPRITE_STARTON
	#define SF_SPRITE_STARTON (1<<0)
#endif

#define CSW_BEAMGUN		CSW_M4A1
#define weapon_beamgunle	"weapon_m4a1"
#define weapon_spr		"weapon_beamgunle"
#define WEAPON_EVENT 		"events/m4a1.sc"
#define OLD_W_MODEL 		"models/w_m4a1.mdl"
#define WEAPON_SECRETCODE 	25685122
#define BODY_NUM		0

#define V_MODEL			"models/beamgun/v_beamgun.mdl"
#define P_MODEL			"models/beamgun/p_beamgun.mdl"
#define W_MODEL			"models/beamgun/w_beamgun.mdl"

#define SND_SHOOT		"weapons/beamgun-1.wav"
#define SND_LASER		"weapons/beamgun_charge_shootA.wav"
#define SND_ORB			"weapons/beamgun-5.wav"

#define CLIP			90
#define BPAMMO			240
#define SPEED_A			3.7
#define RECOIL			0.75
#define RECOIL_B_PITCH		2.0
#define RECOIL_B_YAW		0.8
#define RELOAD_TIME		2.0

#define CHARGE_MAX		100
#define CHARGE_START		20
#define CHARGE_TIMES		20.0
#define LEAP_CONSUME		20

/* ~ [ Offset's ] ~ */
#define linux_diff_weapon			4
#define linux_diff_player			5

#define m_pPlayer				41
#define m_pNext					42
#define m_Weapon_flNextPrimaryAttack		46
#define m_Weapon_flNextSecondaryAttack		47
#define m_Weapon_flTimeWeaponIdle		48
#define m_Weapon_iPrimaryAmmoType		49
#define m_Weapon_iSecondaryAmmoType		50
#define m_Weapon_iClip				51
#define m_Weapon_fInReload			54
#define m_Weapon_flAccuracy			62
#define m_flNextAttack				83
#define m_rgpPlayerItems_slot0			367
#define m_pActiveItem				373
#define m_rgAmmo				376
#define SVC_WEAPONANIM_ID			35

#define TASK_LEAP		1024
#define TASK_RESET		2048

/*========================= Damage Config ==================== */
#if defined USE_ZBHEROEX
	#define DAMAGE_A		150.0
	#define DAMAGE_EXP		350.0
	#define BLACKHOLE_DAMAGE  	250.0
	#define AREA_DAMAGE		1750.0
	#define LASER_DAMAGE		150.0
	#define WINGMAN_DAMAGE		95.0
	#define PROJ_RADIUS_DAMAGE  	25.0       // [NEW] damage at the center of the explosion
#endif

#if !defined USE_ZBHEROEX
	#define DAMAGE_A		20.0
	#define DAMAGE_EXP		85.0
	#define BLACKHOLE_DAMAGE  	15.0
	#define AREA_DAMAGE		90.0
	#define LASER_DAMAGE		5.0
	#define WINGMAN_DAMAGE		5.0
	#define PROJ_RADIUS_DAMAGE  	15.0       // [NEW] damage at the center of the explosion
#endif
/*========================= End of Damage Config ==================== */

/*========================= Entities ==================== */
#define MZ_CLASSNAME			"brimstone"
#define BLACKHOLE_CLASSNAME		"sova"
#define WINGMAN_CLASSNAME		"jett"
#define BAR_CLASSNAME			"killjoy"
#define LEAPUP_CLASSNAME		"chamber"
#define LEAPDOWN_CLASSNAME		"sage"
#define SLASHFX_CLASSNAME		"phoenix"
#define SCREEN_CLASSNAME		"yoru"
#define PROJ_CLASSNAME      		"raze"

#define JUMP_MODEL			"models/beamgun/ef_beamgun_jump.mdl"
#define JUMPLAND_MODEL			"models/beamgun/ef_beamgun_jump_land1x.mdl"
#define JUMPLAND_MODEL2			"models/beamgun/ef_beamgun_jump_landx.mdl"
#define SPR_LASER			"sprites/beamgun/ef_beamgun_charge_shootA.spr"
#define WINGMAN_MODEL			"models/beamgun/ef_beamgun_wingman.mdl"
#define SPR_HIT_A			"sprites/beamgun/ef_beamgun_ShootA_hit.spr"
#define SPR_HIT_CHARGE			"sprites/beamgun/ef_beamgun_chargeshootAhit.spr"
#define B_SLASH_MDL			"models/beamgun/ef_beamgun_shootB.mdl"

#define CHARGE_TIMER			2.0
#define START_COUNT			2
#define NEXT_ATTACK_DELAY		1.0
#define LEAP_STEP_DELAY			0.8
#define LASER_RANGE			2000.0
#define LASER_SHOT_DELAY		1.5
#define LASER_OFS_FWD			16.0
#define LASER_OFS_RIGHT			8.0
#define LASER_OFS_UP			8.0
#define AREA_RADIUS			360.0
#define LEAP_MAX_HEIGHT			180.0
#define LEAP_DOWN_SPEED			1680.0

// [FIX] Horizontal speed of the leap (units/sec) applied along the movement input direction.
// Tune this: 250 = short hop, 320 = default, 450 = long jump.
#define LEAP_HORIZ_SPEED		320.0

#define WE_LEAP_MAX			2
#define COMBO_LEAP_MAX			5
#define ACC_SPREAD_STAND		0.004
#define ACC_SPREAD_MOVE			0.04
#define ACC_SPREAD_AIR			0.10
#define ACC_SPEED_LIMIT			140.0
#define WE_LEAP_DELAY			0.6
#define WE_SLAM_DELAY			0.8
#define WE_STEP_DELAY			1.0
#define WE_END_DELAY			0.56

#define COMBO_STEP_DELAY		1.0
#define COMBO_LEAP_DELAY		0.6
#define COMBO_SLAM_DELAY		0.8
#define ENTER_B_GRACE			3.0
#define COMBO_GRACE			7.5
#define BAR_MAGIC			74126
#define BAR_FRAME_FULL			39.0
#define BAR_THINK			0.02
#define BAR_FORWARD			40.0
#define BAR_RIGHT			-3.0
#define BAR_UP				-1.0
#define BAR_SCALE			0.15
#define WINGMAN_MAGIC			74125
#define WINGMAN_HEIGHT			60.0
#define WINGMAN_RANGE			500.0
#define WINGMAN_ATTACK_DELAY		0.4
#define WINGMAN_BEAM_LIFE		30
#define WINGMAN_BEAM_SIDE		8.0
#define TASK_WINGMAN			4000
#define WINGMAN_ZAP_GAP			0.15
#define WINGMAN_COLOR_R			255
#define WINGMAN_COLOR_G			255
#define WINGMAN_COLOR_B			255
#define WINGMAN_SEQ_IDLE		0
#define WINGMAN_SEQ_ATTACK		0
#define WINGMAN_ATTACK_ANIM_TIME	0.5
#define HIT_A_SCALE			10
#define HIT_CHARGE_SCALE		15
#define HIT_FRAMERATE			20
#define BLACKHOLE_RADIUS  		180.0
#define BLACKHOLE_FORCE   		450.0
#define BLACKHOLE_LIFE    		8.0
#define BLACKHOLE_KILLDIST 		60.0
#define FX_FADE_TIME			0.3
#define FX_RENDERMODE			kRenderTransAdd

#define SCREEN_MAGIC			74127
#define SCALE				0.08
#define HOLD_FRAME			29.0
#define FADE_FPS			35.0

// ---- Wingman projectile  ----
#define PROJ_MAGIC          		74128
#define PROJ_MODEL          		"models/w_hegrenade.mdl"
#define PROJ_SPEED          		4096.0
#define PROJ_SCALE          		0.01
#define PROJ_LIFE           		1          
#define PROJ_HIT_RADIUS     		64.0       
#define PROJ_SPHERE_RADIUS  		96.0      
#define PROJ_RADIUS_DMG     		160.0      
#define PROJ_TRAIL_LIFE     		2            
#define PROJ_TRAIL_WIDTH    		8

/*========================= End of Entities ==================== */
const WeaponSecondaryAmmoIndex         = 18;
const WeaponSecondaryAmmoMax           = 100;

new const iWeaponList[] =
{
	4, 90, -1, -1, 0, 6, CSW_M4A1, 0
};

enum
{
	ANIM_IDLE = 0,
	ANIM_SHOOTA,
	ANIM_SHOOTB1,
	ANIM_SHOOTB2,
	ANIM_RELOAD,
	ANIM_DRAW,
	ANIM_CHARGE_IDLE_CHARGE,
	ANIM_CHARGE_IDLE_REVERSE,
	ANIM_CHARGE_IDLE,
	ANIM_CHARGE_SHOOTA,
	ANIM_CHARGE_SHOOTA_IDLE,
	ANIM_CHARGE_SHOOTB_START,
	ANIM_CHARGE_SHOOTB_LOOP,
	ANIM_CHARGE_SHOOTB_END,
	ANIM_CHARGE_SHOOTB_END_IDLE,
	ANIM_CHARGE_RELOAD,
	ANIM_CHARGE_DRAW
}

enum
{
	MODE_NONE = 0,
	MODE_1,
	MODE_2,
	MODE_SLASH,
	ENTER_B_MODE,
	LEAP_JUMP,
	LEAP_DOWN
}

new const ExtraSounds[][] =
{
	"weapons/beamgun_charge_draw.wav",
	"weapons/beamgun_charge_idle.wav",
	"weapons/beamgun_charge_shootA.wav",
	"weapons/beamgun_charge_shootB_end.wav",
	"weapons/beamgun_charge_shootB_end.wav",
	"weapons/beamgun_charge_shootB_end_idle.wav",
	"weapons/beamgun_draw.wav",
	"weapons/beamgun_idle_charge.wav",
	"weapons/beamgun_idle_charge_FX.wav",
	"weapons/beamgun_idle1.wav",
	"weapons/beamgun_idle2.wav",
	"weapons/beamgun_idle3.wav",
	"weapons/beamgun_jump.wav",
	"weapons/beamgun_jump_end.wav",
	"weapons/beamgun_reload1.wav",
	"weapons/beamgun_reload2.wav",
	"weapons/beamgun_shootB1.wav",
	"weapons/beamgun_shootB2.wav",
	"weapons/beamgun-1.wav",
	"weapons/beamgun-1_exp1.wav",
	"weapons/beamgun-1_exp2.wav",
	"weapons/beamgun-2.wav",
	"weapons/beamgun-3.wav",
	"weapons/beamgun-4.wav",
	"weapons/beamgun-4_exp.wav",
	"weapons/beamgun-5.wav"
}

new const ExtraSprites[][] =
{
	"sprites/beamgun/muzzleflash504.spr",
	"sprites/beamgun/muzzleflash506.spr",
	"sprites/beamgun/ef_beamgun_bar_fix.spr",
	"sprites/beamgun/ef_beamgun_charge_shootA.spr",
	"sprites/beamgun/ef_beamgun_chargeshootAhit.spr",
	"sprites/beamgun/ef_beamgun_shootB2_exp2.spr",
	"sprites/beamgun/screen1x.spr"
}

new g_iMode[33], g_iModeCount[33], Float:g_NextCharge[33]
new g_iOldButtons[33], g_iBloodSpray, g_iBloodDrop;
new Float:g_flNextAttack[33]
new g_ActiveWeapon, bool:g_bLeaping[33]
new Float:g_Recoil[33][3], g_Clip[33], g_ReClip[33], g_Old_Weapon[33]
new g_sprLaser, g_SmokePuff_SprId
new g_MaxPlayers, g_Msg_CurWeapon
new g_HamBot, g_weapon_event
new g_Orb[33],g_OrbTarget[33]

new g_iShootCount[33],g_iLeapChance[33], g_iEnt[33],g_Proj[33] 
new g_sprHitA, g_sprHitCharge

new bool:g_bGod[33]
new Float:g_flFallImmune[33]
new Float:g_flLeapZ[33]
new Float:g_flBarEnd[33]
new Float:g_flBarDur[33]

new g_Bar[33]
new g_BarMask
new g_LeapFx[33]
new bool:isCombo[33]
new g_iRightHand[33]

#if defined USE_ZBHEROEX
new g_beamgun
#endif

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")

	g_MaxPlayers = get_maxplayers()
	g_Msg_CurWeapon = get_user_msgid("CurWeapon")

	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_Think, "fw_Entity_Think")
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink")
	register_forward(FM_AddToFullPack, "fw_AddToFullPack")

	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player")

	RegisterHam(Ham_Item_Deploy, weapon_beamgunle, "Ham_CWeapon_Deploy_Post", true)
	RegisterHam(Ham_Item_AddToPlayer, weapon_beamgunle, "Ham_CWeapon_AddToPlayer_Post", true)
	RegisterHam(Ham_Item_Holster, weapon_beamgunle, "Ham_CWeapon_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame, weapon_beamgunle, "Ham_CWeapon_PostFrame_Pre")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_beamgunle, "Ham_CWeapon_Idle_Pre")
	RegisterHam(Ham_Weapon_Reload, weapon_beamgunle, "Ham_CWeapon_Reload_Pre")
	RegisterHam(Ham_Weapon_Reload, weapon_beamgunle, "Ham_CWeapon_Reload_Post", true)
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_beamgunle, "Ham_CWeapon_PrimaryAttack_Pre")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_beamgunle, "Ham_CWeapon_PrimaryAttack_Post", true)
	RegisterHam(Ham_Weapon_SecondaryAttack, weapon_beamgunle, "Ham_CWeapon_SecondaryAttack_Pre")

	RegisterHam(Ham_Spawn, "player", "fw_Spawn_Post", true)
	RegisterHam(Ham_Killed, "player", "fw_Killed_Post", true)
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage_Pre")
	
	register_clcmd(weapon_spr, "CSOWPN_Hook")
	
#if defined USE_ZBHEROEX
	g_beamgun = zbheroex_register_weapon("Gigabreak LE", WEAPON_PRIMARY, CSW_BEAMGUN, 0)
#endif

#if !defined USE_ZBHEROEX
	register_clcmd("get_beamgun", "CSOWPN_Give")
#endif

}

public plugin_precache()
{
	precache_model(W_MODEL)
	precache_model(V_MODEL)
	precache_model(P_MODEL)
	precache_model(WINGMAN_MODEL)
	precache_model(JUMP_MODEL)
	precache_model(JUMPLAND_MODEL)
	precache_model(JUMPLAND_MODEL2)
	precache_model(B_SLASH_MDL)
	precache_model(PROJ_MODEL)
	
	UTIL_PrecacheWeaponList(weapon_spr)
	g_sprLaser = precache_model(SPR_LASER)
	g_SmokePuff_SprId = engfunc(EngFunc_PrecacheModel, "sprites/wall_puff1.spr")

	g_sprHitA = precache_model(SPR_HIT_A)
	g_sprHitCharge = precache_model(SPR_HIT_CHARGE)
	
	g_iBloodSpray = precache_model("sprites/bloodspray.spr");
	g_iBloodDrop  = precache_model("sprites/blood.spr");

	for(new i = 0; i < sizeof(ExtraSounds); i++)
		precache_sound(ExtraSounds[i])
	for(new i = 0; i < sizeof(ExtraSprites); i++)
		precache_model(ExtraSprites[i])

	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)
}

#if defined USE_ZBHEROEX
public zbheroex_weapon_bought(id, ItemID)
{
	if(ItemID == g_beamgun) CSOWPN_Give(id)
}

public zbheroex_weapon_remove(id, ItemID)
{
	if(ItemID == g_beamgun) CSOWPN_Remove(id)
}
#endif

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(WEAPON_EVENT, name))
		g_weapon_event = get_orig_retval()
}

public client_putinserver(id)
{
	g_iRightHand[id] = 1
	RightHand_Query(id)

	if(!g_HamBot && is_user_bot(id))
	{
		g_HamBot = 1
		set_task(0.1, "Do_RegisterHam_Bot", id)
	}
}

public Do_RegisterHam_Bot(id)
{
	RegisterHamFromEntity(Ham_Spawn, id, "fw_Spawn_Post", 1)
	RegisterHamFromEntity(Ham_Killed, id, "fw_Killed_Post", 1)
	RegisterHamFromEntity(Ham_TakeDamage, id, "fw_TakeDamage_Pre")
}

public client_disconnected(id)
{
	g_iRightHand[id] = 1
	UnSet_BitVar(g_ActiveWeapon,id)
	ResetPlayer(id)
}

RightHand_Query(id)
{
	if(!is_user_connected(id) || is_user_bot(id))
		return

	query_client_cvar(id, "cl_righthand", "RightHand_Result")
}

public RightHand_Result(id, const cvar[], const value[])
{
	if(!is_user_connected(id))
		return

	if(equal(value, "Bad CVAR request"))
	{
		g_iRightHand[id] = 1
		return
	}

	g_iRightHand[id] = (str_to_num(value) != 0) ? 1 : 0
}

public CSOWPN_Give(id)
{
	if(!is_user_alive(id)) return

	Stock_DropSlot(id, 1)

	Set_BitVar(g_ActiveWeapon,id)
	fm_give_item(id, weapon_beamgunle)
	isCombo[id] = false
	Start_Charge(id)

	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_BEAMGUN)
	if(pev_valid(Ent))
	{
		cs_set_weapon_ammo(Ent, CLIP)

		if(get_user_weapon(id) == CSW_BEAMGUN)
			Ham_CWeapon_Deploy_Post(Ent)
	}

	cs_set_user_bpammo(id, CSW_BEAMGUN, BPAMMO)

	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_Msg_CurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_BEAMGUN)
	write_byte(CLIP)
	message_end()
}

public CSOWPN_Hook(id)
{
	engclient_cmd(id, weapon_beamgunle)
	return PLUGIN_HANDLED
}

public CSOWPN_Remove(id)
{
	if(is_user_connected(id))
	{
		UTIL_SetHud(id, RESET_HUD)
	}

	UnSet_BitVar(g_ActiveWeapon, id)
	g_Old_Weapon[id] = 0
	isCombo[id] = false
	Orb_RemoveProjectile(id)
	ResetPlayer(id)
	ResetMode(id)
}

public message_DeathMsg(msg_id, msg_dest, msg_ent)
{
	static szWeapon[64]
	get_msg_arg_string(4, szWeapon, charsmax(szWeapon))

	if(!equal(szWeapon, "m4a1"))
		return PLUGIN_CONTINUE

	static iKiller; iKiller = get_msg_arg_int(1)
	if(!is_user_connected(iKiller))
		return PLUGIN_CONTINUE
	if(!Get_BitVar(g_ActiveWeapon, iKiller) || get_user_weapon(iKiller) != CSW_BEAMGUN)
		return PLUGIN_CONTINUE

	set_msg_arg_string(4, "beamgun")
	return PLUGIN_CONTINUE
}

public fw_Spawn_Post(id)
{
	CSOWPN_Remove(id)
	ResetPlayer(id)
}

public fw_Killed_Post(id)
{
	CSOWPN_Remove(id)
	ResetPlayer(id)
}

ResetMode(id)
{
	remove_task(id + TASK_LEAP)
	remove_task(id + TASK_RESET)
	Orb_Remove(id)
	Bar_Remove(id)
	Fx_RemoveLeapUp(id)

	if(g_bGod[id]) WE_SetGod(id, false)
	g_flBarEnd[id] = 0.0
	g_flBarDur[id] = ENTER_B_GRACE
	isCombo[id] = false

	g_iLeapChance[id] = 0
	g_iMode[id] = MODE_NONE
	g_iModeCount[id] = 0
	g_bLeaping[id] = false
	g_flNextAttack[id] = 0.0

	g_iShootCount[id] = 0

	if(is_user_alive(id))
		set_pev(id, pev_takedamage, DAMAGE_AIM)
}

ResetPlayer(id)
{
	ResetMode(id)
	g_iOldButtons[id] = 0
	g_Clip[id] = 0
	g_ReClip[id] = -1
	g_Old_Weapon[id] = 0
	g_iLeapChance[id] = 0
	g_flFallImmune[id] = 0.0
	isCombo[id] = false
	Screen_Remove(id)
	Orb_RemoveProjectile(id)
}

bool:IsHoldingBeam(id)
{
	return bool:(Get_BitVar(g_ActiveWeapon,id) && is_user_alive(id) && get_user_weapon(id) == CSW_BEAMGUN)
}

SetWeaponIdle(id, Float:fTime)
{
	new ent = get_pdata_cbase(id, m_pActiveItem, linux_diff_player)
	if(pev_valid(ent))
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, fTime, linux_diff_weapon)
}

public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return

	new csw = read_data(2)

	if(csw == CSW_BEAMGUN && Get_BitVar(g_ActiveWeapon,id))
	{
		set_pev(id, pev_viewmodel2, V_MODEL)
		set_pev(id, pev_weaponmodel2, P_MODEL)
		UTIL_SetHud(id, SET_CUSTOM_HUD);
	}

	g_Old_Weapon[id] = csw
}

public Ham_CWeapon_Deploy_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWeapon,id)) return

	set_pev(id, pev_viewmodel2, V_MODEL)
	set_pev(id, pev_weaponmodel2, P_MODEL)

	ResetMode(id)
	Orb_Create(id)
	set_weapon_anim(id, g_iMode[id] != MODE_NONE ? ANIM_CHARGE_DRAW : ANIM_DRAW)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5, linux_diff_weapon)

	RightHand_Query(id)
}

public Ham_CWeapon_AddToPlayer_Post(ent, id)
{
	if(!pev_valid(ent) || !is_user_connected(id))
		return

	if(pev(ent, pev_impulse) == WEAPON_SECRETCODE)
	{
		Set_BitVar(g_ActiveWeapon,id)
		set_pev(ent, pev_impulse, 0)

		if(get_user_weapon(id) == CSW_BEAMGUN)
			Ham_CWeapon_Deploy_Post(ent)
	}

	if(Get_BitVar(g_ActiveWeapon, id))
	{
		set_pdata_int(ent, m_Weapon_iSecondaryAmmoType, WeaponSecondaryAmmoIndex, linux_diff_weapon)
		UTIL_WeaponList(id, true)
	}
	else
	{
		UTIL_WeaponList(id, false)
	}
}

public Ham_CWeapon_Holster_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id)) return

	ResetMode(id)
	StopSoundFile_Beamgun(id, ExtraSounds[11], CHAN_ITEM)
	UTIL_SetHud(id, RESET_HUD);
}

public Ham_CWeapon_Idle_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED

	if(get_pdata_float(ent, m_Weapon_flTimeWeaponIdle, linux_diff_weapon) > 0.0)
		return HAM_SUPERCEDE

	set_weapon_anim(id, g_iMode[id] != MODE_NONE ? ANIM_CHARGE_IDLE : ANIM_IDLE)

	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 20.0, linux_diff_weapon)
	return HAM_SUPERCEDE
}

public fw_TakeDamage_Pre(victim, inflictor, attacker, Float:damage, damagebits)
{
	if(!(1 <= victim <= g_MaxPlayers))
		return HAM_IGNORED

	if((damagebits & DMG_FALL) && (g_bGod[victim] || get_gametime() < g_flFallImmune[victim]))
		return HAM_SUPERCEDE

	return HAM_IGNORED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if(eventid != g_weapon_event)
		return FMRES_IGNORED
	if(!(1 <= invoker <= g_MaxPlayers) || !Get_BitVar(g_ActiveWeapon,invoker))
		return FMRES_IGNORED
	if(get_user_weapon(invoker) != CSW_BEAMGUN)
		return FMRES_IGNORED

	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)

	return FMRES_SUPERCEDE
}

public fw_SetModel(entity, model[])
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

	if(equal(model, OLD_W_MODEL))
	{
		static weapon; weapon = fm_find_ent_by_owner(-1, weapon_beamgunle, entity)

		if(!pev_valid(weapon))
			return FMRES_IGNORED

		if(Get_BitVar(g_ActiveWeapon,iOwner))
		{
			set_pev(weapon, pev_impulse, WEAPON_SECRETCODE)
			engfunc(EngFunc_SetModel, entity, W_MODEL)
			set_pev(entity, pev_body, BODY_NUM)

			UnSet_BitVar(g_ActiveWeapon,iOwner)
			ResetMode(iOwner)

			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

public fw_TraceAttack_World(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_BEAMGUN || !Get_BitVar(g_ActiveWeapon,Attacker))
		return HAM_IGNORED

	if(g_iMode[Attacker] == ENTER_B_MODE)
		return HAM_SUPERCEDE

	static Float:flEnd[3]
	get_tr2(Ptr, TR_vecEndPos, flEnd)

	Shoot_CheckExplosion(Attacker, Ptr)
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, random_float(DAMAGE_A, DAMAGE_A * 2.0))

	return HAM_IGNORED
}

public fw_TraceAttack_Player(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_BEAMGUN || !Get_BitVar(g_ActiveWeapon,Attacker))
		return HAM_IGNORED

	if(g_iMode[Attacker] == ENTER_B_MODE)
		return HAM_SUPERCEDE

	if(get_user_team(Victim) == get_user_team(Attacker))
		return HAM_IGNORED

	Shoot_CheckExplosion(Attacker, Ptr)
	SetHamParamFloat(3, random_float(DAMAGE_A, DAMAGE_A * 2.0))

	return HAM_IGNORED
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED

	if(get_user_weapon(id) == CSW_BEAMGUN && Get_BitVar(g_ActiveWeapon,id))
	{
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001)
		return FMRES_HANDLED
	}

	return FMRES_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED

	if(isCombo[id])
		return HAM_IGNORED

	pev(id, pev_punchangle, g_Recoil[id])
	Stock_SetAccuracy(id, ent)
	g_Clip[id] = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)

	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED

	if(g_Clip[id] <= get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon))
		return HAM_IGNORED
	if(isCombo[id])
		return HAM_IGNORED

	new Float:Push[3]
	pev(id, pev_punchangle, Push)
	xs_vec_sub(Push, g_Recoil[id], Push)
	xs_vec_mul_scalar(Push, g_iMode[id] == ENTER_B_MODE? RECOIL_B_PITCH :RECOIL, Push)
	xs_vec_add(Push, g_Recoil[id], Push)
	set_pev(id, pev_punchangle, Push)

	if(g_iMode[id] == ENTER_B_MODE)
	{
		DoLaser(id)
		Stock_Muzzle(id, MZ_CLASSNAME, ExtraSprites[random_num(0,1)])
		emit_sound(id, CHAN_WEAPON, ExtraSounds[23], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		set_weapon_anim(id, ANIM_CHARGE_SHOOTA)

		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, LASER_SHOT_DELAY, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, LASER_SHOT_DELAY, linux_diff_weapon)
		
		StopSoundFile_Beamgun(id, ExtraSounds[11], CHAN_ITEM)
	}else{
		g_iShootCount[id]++
		if(g_iShootCount[id] >= 10)
			g_iShootCount[id] = 0

		set_weapon_anim(id, ANIM_SHOOTA)
		Stock_Muzzle(id, MZ_CLASSNAME, ExtraSprites[random_num(0,1)])
		emit_sound(id, CHAN_WEAPON, SND_SHOOT, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

		new Float:flDelay = get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) * SPEED_A
		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, flDelay, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, flDelay, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, flDelay + 1.0, linux_diff_weapon)
		
		StopSoundFile_Beamgun(id, ExtraSounds[11], CHAN_ITEM)
	}

	return HAM_IGNORED
}

public Ham_CWeapon_SecondaryAttack_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED

	return HAM_SUPERCEDE
}

public Ham_CWeapon_Reload_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED

	g_ReClip[id] = -1

	if(cs_get_user_bpammo(id, CSW_BEAMGUN) <= 0)
		return HAM_SUPERCEDE

	new iClip = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
	if(iClip >= CLIP)
		return HAM_SUPERCEDE

	g_ReClip[id] = iClip
	return HAM_IGNORED
}

public Ham_CWeapon_Reload_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED
	if(g_ReClip[id] == -1)
		return HAM_IGNORED

	set_pdata_int(ent, m_Weapon_iClip, g_ReClip[id], linux_diff_weapon)
	set_pdata_int(ent, m_Weapon_fInReload, 1, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, RELOAD_TIME + 0.5, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, RELOAD_TIME, linux_diff_player)
	if(g_iShootCount[id])
		g_iShootCount[id] = 0
	set_weapon_anim(id, g_iMode[id] != MODE_NONE ? ANIM_CHARGE_RELOAD : ANIM_RELOAD)

	return HAM_IGNORED
}

public Ham_CWeapon_PostFrame_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWeapon,id))
		return HAM_IGNORED

	if(get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon) && get_pdata_float(id, m_flNextAttack, linux_diff_player) <= 0.0)
	{
		new iClip = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
		new iBp = cs_get_user_bpammo(id, CSW_BEAMGUN)
		new j = min(CLIP - iClip, iBp)

		set_pdata_int(ent, m_Weapon_iClip, iClip + j, linux_diff_weapon)
		cs_set_user_bpammo(id, CSW_BEAMGUN, iBp - j)
		set_pdata_int(ent, m_Weapon_fInReload, 0, linux_diff_weapon)
	}

	new buttons = pev(id, pev_button)

	if(g_iMode[id] == LEAP_JUMP)
	{
		new Float:fOrg[3]
		pev(id, pev_origin, fOrg)

		if(fOrg[2] - g_flLeapZ[id] >= LEAP_MAX_HEIGHT)
		{
			new Float:fVel[3]
			pev(id, pev_velocity, fVel)
			if(fVel[2] > 0.0)
			{
				fVel[2] = 0.0
				set_pev(id, pev_velocity, fVel)
			}
		}
	}

	if(g_bGod[id] && g_iMode[id] != LEAP_JUMP && (pev(id, pev_flags) & FL_ONGROUND))
		WE_SetGod(id, false)

	WE_CheckBTime(id, ent)
	WE_Beamgun(id, ent, buttons)

	return HAM_IGNORED
}

WE_SetDelay(ent, Float:fTime)
{
	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, fTime, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, fTime, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, fTime + 1.5, linux_diff_weapon)
}

WE_SetGod(id, bool:on)
{
	g_bGod[id] = on

	if(!is_user_connected(id))
		return

	if(on)
	{
		set_pev(id, pev_flags, pev(id, pev_flags) | FL_GODMODE)
		set_user_godmode(id, 1)
	}
	else
	{
		set_pev(id, pev_flags, pev(id, pev_flags) & ~FL_GODMODE)
		if(is_user_alive(id))
			set_user_godmode(id, 0)

		g_flFallImmune[id] = get_gametime() + 0.3
	}
}

WE_EnterBMode(id, Float:fDuration)
{
	g_iMode[id] = ENTER_B_MODE
	g_flBarDur[id] = fDuration
	g_flBarEnd[id] = get_gametime() + fDuration
}

WE_CheckBTime(id, ent)
{
	if(g_flBarEnd[id] <= 0.0)
		return

	if(get_gametime() < g_flBarEnd[id])
		return

	switch(g_iMode[id])
	{
		case ENTER_B_MODE:
		{
			g_flBarEnd[id] = 0.0
			g_iMode[id] = MODE_NONE
			g_iLeapChance[id] = 0
			isCombo[id] = false
			WE_SetGod(id, false)
			Bar_Remove(id)
			StopSoundFile_Beamgun(id, ExtraSounds[11], CHAN_ITEM)
			set_weapon_anim(id, ANIM_CHARGE_IDLE_REVERSE)
			set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, 1.0, linux_diff_weapon)
			set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, 1.0, linux_diff_weapon)
			set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5, linux_diff_weapon)
		}
		case LEAP_JUMP:
		{
			WE_Slam(id, ent, true)
		}
	}
}

WE_Slam(id, ent, bool:bForceLast = false)
{
	if(g_iLeapChance[id] > 0)
		g_iLeapChance[id]--

	if(bForceLast)
		g_iLeapChance[id] = 0

	if(g_iLeapChance[id] <= 0)
	{
		g_iMode[id] = LEAP_DOWN
		g_flBarEnd[id] = 0.0
	}
	else
	{
		g_iMode[id] = ENTER_B_MODE
	}

	if(Fx_RemoveLeapUp(id))
	{
		AreaDamage(id)
		fake_recoil(id, -8.0, random_float(-0.6, 0.6))
		CreateBeamgunFx(id, LEAPDOWN_CLASSNAME, JUMPLAND_MODEL, 0, 0.6, 0.8, true)
		CreateBeamgunFx(id, LEAPDOWN_CLASSNAME, JUMPLAND_MODEL2, 0, 0.6, 0.8, true)
		emit_sound(id, CHAN_WEAPON, ExtraSounds[13], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	}

	set_weapon_anim(id, (g_iLeapChance[id] <= 0) ? ANIM_CHARGE_SHOOTB_END_IDLE : ANIM_CHARGE_SHOOTB_END)

	WE_SetDelay(ent, isCombo[id] ? COMBO_SLAM_DELAY : WE_SLAM_DELAY)
	ForceLanding(id)
	WE_SetGod(id, true)
}

CreateBarLeap(id)
{
	if(!is_user_alive(id))
		return

	new ent = g_iEnt[id]

	if(!pev_valid(ent))
	{
		create_screen(id)
		return
	}

	set_pev(ent, pev_iuser2, pev(ent, pev_iuser2) ? 0 : 1)
}

WE_Beamgun(id, ent, button)
{
	new bool:bHold = bool:(button & IN_ATTACK2)
	new bool:bAttack = bool:(button & IN_ATTACK)
	new iCharge = GetSecondaryAmmo(id)

	if(!isCombo[id] && bHold && bAttack && iCharge >= CHARGE_MAX){
		isCombo[id] = true

		g_iLeapChance[id] = COMBO_LEAP_MAX
		WE_EnterBMode(id, COMBO_GRACE)

		SetSecondaryAmmo(id, 0)

		Bar_Create(id)

		set_weapon_anim(id, ANIM_CHARGE_IDLE_CHARGE)
		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, 0.5, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, 0.5, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.0, linux_diff_weapon)

		if(isCombo[id])
			isCombo[id] = false
	}

	if(get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon))
		return
	if(get_pdata_float(ent, m_Weapon_flNextSecondaryAttack, linux_diff_weapon) > 0.0)
		return

	switch(g_iMode[id])
	{
		case MODE_NONE:
		{
			if(!bHold || get_pdata_float(id, m_flNextAttack, linux_diff_player) > 0.0)
				return

			g_iMode[id] = MODE_SLASH
			g_iLeapChance[id] = WE_LEAP_MAX

			isCombo[id] = (bAttack && iCharge >= CHARGE_MAX) ? true : false

			AreaDamage(id)
			set_weapon_anim(id, ANIM_SHOOTB1)
			CreateBeamgunFx(id, SLASHFX_CLASSNAME, B_SLASH_MDL,0, 0.8, 0.6, true)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[22], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			WE_SetDelay(ent, WE_STEP_DELAY)
		}
		case MODE_SLASH:
		{
			if(!bHold)
			{
				g_iMode[id] = MODE_NONE
				isCombo[id] = false
				WE_SetDelay(ent, WE_SLAM_DELAY)
				return
			}

			new Float:porigin[3];
			get_aim_origin(id, porigin, 800.0);
			Stock_Muzzle(id, MZ_CLASSNAME, ExtraSprites[4])
			create_hole(id, porigin)

			if(isCombo[id] && iCharge >= CHARGE_MAX)
			{
				g_iLeapChance[id] = COMBO_LEAP_MAX
				WE_EnterBMode(id, COMBO_GRACE)
			}
			else
			{
				g_iLeapChance[id] = WE_LEAP_MAX
				WE_EnterBMode(id, ENTER_B_GRACE)
			}
			Bar_Create(id)

			set_weapon_anim(id, ANIM_SHOOTB2)
			WE_SetDelay(ent, isCombo[id] ? COMBO_STEP_DELAY : WE_STEP_DELAY)
			AreaDamage(id)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[21], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			PlaySoundFile_Beamgun(id, ExtraSounds[11], VOL_NORM, 4.0, CHAN_ITEM)
		}
		case ENTER_B_MODE:
		{
			if(!bHold)
				return

			g_iMode[id] = LEAP_JUMP
			set_weapon_anim(id, ANIM_CHARGE_SHOOTB_START)
			g_LeapFx[id] = CreateBeamgunFx(id, LEAPUP_CLASSNAME, JUMP_MODEL,0, 0.8, 0.5, true)
			emit_sound(id, CHAN_WEAPON, ExtraSounds[12], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			WE_SetDelay(ent, isCombo[id] ? COMBO_LEAP_DELAY : WE_LEAP_DELAY)

			CreateBarLeap(id)

			// ============================================================
			// [FIX] Leap velocity: based on forward/backward input
			// ============================================================
			new Float:vel[3], Float:org[3], Float:fGrav, Float:fPlGrav
			pev(id, pev_velocity, vel)
			pev(id, pev_origin, org)
			g_flLeapZ[id] = org[2]

			fGrav = get_cvar_float("sv_gravity")
			if(fGrav <= 0.0)
				fGrav = 800.0
			pev(id, pev_gravity, fPlGrav)
			if(fPlGrav > 0.0)
				fGrav *= fPlGrav

			// ---- Build horizontal direction from input keys + view angle ----
			static Float:ang[3], Float:fwd[3], Float:right[3]
			pev(id, pev_v_angle, ang)
			ang[0] = 0.0            // only horizontal forward/right
			engfunc(EngFunc_MakeVectors, ang)
			global_get(glb_v_forward, fwd)
			global_get(glb_v_right, right)

			static Float:horiz[3]
			horiz[0] = 0.0
			horiz[1] = 0.0
			horiz[2] = 0.0

			new iButtons = pev(id, pev_button)
			new bool:bForward = bool:(iButtons & IN_FORWARD)
			new bool:bBack    = bool:(iButtons & IN_BACK)
			new bool:bLeft    = bool:(iButtons & IN_MOVELEFT)
			new bool:bRight   = bool:(iButtons & IN_MOVERIGHT)

			// forward/backward
			if(bForward && !bBack)
			{
				horiz[0] += fwd[0]
				horiz[1] += fwd[1]
			}
			else if(bBack && !bForward)
			{
				horiz[0] -= fwd[0]
				horiz[1] -= fwd[1]
			}

			// strafe (A/D) — comment out this block if you only want W/S to affect the leap
			if(bRight && !bLeft)
			{
				horiz[0] += right[0]
				horiz[1] += right[1]
			}
			else if(bLeft && !bRight)
			{
				horiz[0] -= right[0]
				horiz[1] -= right[1]
			}

			// normalize horizontal direction (if any input)
			new Float:hlen = floatsqroot(horiz[0]*horiz[0] + horiz[1]*horiz[1])
			if(hlen > 0.0001)
			{
				horiz[0] /= hlen
				horiz[1] /= hlen
			}
			else
			{
				horiz[0] = 0.0
				horiz[1] = 0.0
			}

			// apply horizontal speed
			vel[0] = horiz[0] * LEAP_HORIZ_SPEED
			vel[1] = horiz[1] * LEAP_HORIZ_SPEED

			// vertical launch (unchanged)
			vel[2] = floatsqroot(2.0 * fGrav * LEAP_MAX_HEIGHT)
			set_pev(id, pev_velocity, vel)
			// ============================================================

			WE_SetGod(id, true)
		}
		case LEAP_JUMP:
		{
			WE_Slam(id, ent, false)
		}
		case LEAP_DOWN:
		{
			g_iMode[id] = MODE_NONE
			isCombo[id] = false
			WE_SetGod(id, false)

			WE_SetDelay(ent, WE_END_DELAY)
		}
	}
}

Bar_Remove(id)
{
	new ent = g_Bar[id]
	if(ent && pev_valid(ent) && pev(ent, pev_impulse) == BAR_MAGIC)
		engfunc(EngFunc_RemoveEntity, ent)

	g_Bar[id] = 0
	UnSet_BitVar(g_BarMask, id)
}

Bar_UpdateOrigin(id, ent)
{
	static Float:eye[3], Float:ofs[3], Float:ang[3]
	static Float:fwd[3], Float:right[3], Float:up[3], Float:pos[3]

	pev(id, pev_origin, eye)
	pev(id, pev_view_ofs, ofs)
	xs_vec_add(eye, ofs, eye)

	pev(id, pev_v_angle, ang)
	engfunc(EngFunc_MakeVectors, ang)
	global_get(glb_v_forward, fwd)
	global_get(glb_v_right, right)
	global_get(glb_v_up, up)

	xs_vec_mul_scalar(fwd, BAR_FORWARD, fwd)
	xs_vec_mul_scalar(right, BAR_RIGHT, right)
	xs_vec_mul_scalar(up, BAR_UP, up)

	xs_vec_add(eye, fwd, pos)
	xs_vec_add(pos, right, pos)
	xs_vec_add(pos, up, pos)

	engfunc(EngFunc_SetOrigin, ent, pos)
}

public fw_AddToFullPack(es, e, ent, host, hostflags, player, pSet)
{
	if(player)
		return FMRES_IGNORED

	if(!pev_valid(ent))
		return FMRES_IGNORED

	static magic
	magic = pev(ent, pev_impulse)

	if(magic != BAR_MAGIC && magic != SCREEN_MAGIC)
		return FMRES_IGNORED

	if(pev(ent, pev_owner) != host)
	{
		forward_return(FMV_CELL, 0)
		return FMRES_SUPERCEDE
	}

	return FMRES_IGNORED
}

Orb_SetAnim(ent, seq)
{
	set_pev(ent, pev_sequence, seq)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_framerate, 30.0)
}

Orb_Create(id)
{
	Orb_Remove(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent)) return

	new Float:org[3]
	pev(id, pev_origin, org)
	org[2] += WINGMAN_HEIGHT

	set_pev(ent, pev_classname, WINGMAN_CLASSNAME)
	set_pev(ent, pev_impulse, WINGMAN_MAGIC)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)

	engfunc(EngFunc_SetModel, ent, WINGMAN_MODEL)
	engfunc(EngFunc_SetSize, ent, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0})
	engfunc(EngFunc_SetOrigin, ent, org)

	Orb_SetAnim(ent, WINGMAN_SEQ_IDLE)

	set_pev(ent, pev_fuser1, get_gametime() + WINGMAN_ATTACK_DELAY)
	set_pev(ent, pev_fuser2, 0.0)
	set_pev(ent, pev_nextthink, get_gametime() + 0.01)

	g_Orb[id] = ent
}

Orb_Remove(id)
{
	remove_task(id + TASK_WINGMAN)

	new ent = g_Orb[id]
	if(ent && pev_valid(ent) && pev(ent, pev_impulse) == WINGMAN_MAGIC)
		engfunc(EngFunc_RemoveEntity, ent)

	g_Orb[id] = 0
}

public fw_PlayerPreThink(id)
{
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWeapon, id))
		return FMRES_IGNORED

	static iAmmo; iAmmo = GetSecondaryAmmo(id)
	if(iAmmo >= CHARGE_MAX)
		return FMRES_IGNORED

	static Float:fTime; fTime = get_gametime()
	if(fTime < g_NextCharge[id])
		return FMRES_IGNORED

	g_NextCharge[id] = fTime + (CHARGE_TIMES / float(CHARGE_MAX))

	static iNew; iNew = iAmmo + 1
	if(iNew > CHARGE_MAX)
		iNew = CHARGE_MAX
	SetSecondaryAmmo(id, iNew)

	return FMRES_IGNORED
}

public fw_Entity_Think(ent)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))

	new id = pev(ent, pev_owner)

	if(equal(classname, MZ_CLASSNAME))
	{
		static iOwner; iOwner = pev(ent, pev_owner)

		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_BEAMGUN)
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
		if(Frame > 23.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.0
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)

		return FMRES_IGNORED
	}

	if(equal(classname, BAR_CLASSNAME))
	{
		if(pev(ent, pev_impulse) != BAR_MAGIC)
			return FMRES_IGNORED

		if(!(1 <= id <= g_MaxPlayers) || !IsHoldingBeam(id) || g_Bar[id] != ent)
		{
			if(1 <= id <= g_MaxPlayers && g_Bar[id] == ent)
			{
				g_Bar[id] = 0
				UnSet_BitVar(g_BarMask, id)
			}

			set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			return FMRES_SUPERCEDE
		}

		if(g_iMode[id] != ENTER_B_MODE && g_iMode[id] != LEAP_JUMP)
		{
			g_Bar[id] = 0
			UnSet_BitVar(g_BarMask, id)
			set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			return FMRES_SUPERCEDE
		}

		static Float:now, Float:flFrame
		now = get_gametime()

		flFrame = BAR_FRAME_FULL * (g_flBarEnd[id] - now) / g_flBarDur[id]
		if(flFrame < 0.0) flFrame = 0.0
		if(flFrame > BAR_FRAME_FULL) flFrame = BAR_FRAME_FULL

		set_pev(ent, pev_frame, flFrame)
		Bar_UpdateOrigin(id, ent)

		set_pev(ent, pev_nextthink, now + BAR_THINK)
		return FMRES_SUPERCEDE
	}

	if(equal(classname, SLASHFX_CLASSNAME) || equal(classname, LEAPUP_CLASSNAME) || equal(classname, LEAPDOWN_CLASSNAME))
	{
		static Float:fNow, Float:fTimeRemove, Float:fLeft
		fNow = get_gametime()
		pev(ent, pev_fuser1, fTimeRemove)

		if(!(1 <= id <= g_MaxPlayers) || !is_user_connected(id))
		{
			set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			return FMRES_IGNORED
		}

		if(!IsHoldingBeam(id) && fTimeRemove > fNow + FX_FADE_TIME)
		{
			fTimeRemove = fNow + FX_FADE_TIME
			set_pev(ent, pev_fuser1, fTimeRemove)
		}

		fLeft = fTimeRemove - fNow
		if(fLeft <= 0.0)
		{
			set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			return FMRES_IGNORED
		}

		if(fLeft < FX_FADE_TIME)
		{
			set_pev(ent, pev_renderamt, 255.0 * fLeft / FX_FADE_TIME)
			set_pev(ent, pev_nextthink, fNow + 0.02)
		}
		else
			set_pev(ent, pev_nextthink, fNow + 0.05)

		return FMRES_IGNORED
	}

	if(equal(classname, WINGMAN_CLASSNAME))
	{
		if(pev(ent, pev_impulse) != WINGMAN_MAGIC)
			return FMRES_IGNORED

		if(!(1 <= id <= g_MaxPlayers) || !IsHoldingBeam(id) || g_Orb[id] != ent)
		{
			if(1 <= id <= g_MaxPlayers && g_Orb[id] == ent)
				g_Orb[id] = 0

			set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			return FMRES_SUPERCEDE
		}

		static Float:now, Float:org[3], Float:ang[3], Float:flNext, Float:flAnimEnd
		now = get_gametime()

		pev(id, pev_origin, org)
		org[2] += WINGMAN_HEIGHT + floatsin(now * 3.0, radian) * 4.0
		engfunc(EngFunc_SetOrigin, ent, org)

		pev(id, pev_v_angle, ang)
		ang[0] = 0.0
		set_pev(ent, pev_angles, ang)

		pev(ent, pev_fuser2, flAnimEnd)
		if(flAnimEnd > 0.0 && now >= flAnimEnd)
		{
			Orb_SetAnim(ent, WINGMAN_SEQ_IDLE)
			set_pev(ent, pev_fuser2, 0.0)
		}

		static Float:fFrame
		pev(ent, pev_frame, fFrame)

		fFrame += 1.0
		if(fFrame > 255.0) fFrame = 0.0
		set_pev(ent, pev_frame, fFrame)

		pev(ent, pev_fuser1, flNext)
		if(now >= flNext)
		{
			if(Orb_Attack(id, ent, org))
			{
				set_pev(ent, pev_fuser1, now + WINGMAN_ATTACK_DELAY)
				set_pev(ent, pev_fuser2, now + WINGMAN_ATTACK_ANIM_TIME)
			}
			else
				set_pev(ent, pev_fuser1, now + 0.1)
		}

		set_pev(ent, pev_nextthink, now + 0.02)
		return FMRES_SUPERCEDE
	}

	if(equal(classname, BLACKHOLE_CLASSNAME))
	{
		static Float:Frame; pev(ent, pev_frame, Frame)
		if(Frame > 13.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.0
		set_pev(ent, pev_frame, Frame)

		new Float:hole[3], Float:pOrg[3], Float:dir[3], Float:dist;
		pev(ent, pev_origin, hole);
		new owner = pev(ent, pev_owner);

		new victim = -1;
		while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, hole, BLACKHOLE_RADIUS)) != 0)
		{
			if (victim < 1 || victim > get_maxplayers()) continue;
			if (!is_user_alive(victim) || victim == owner) continue;

			pev(victim, pev_origin, pOrg);
			xs_vec_sub(hole, pOrg, dir);
			dist = xs_vec_len(dir);

			if (dist < BLACKHOLE_KILLDIST)
			{
				ExecuteHamB(Ham_TakeDamage, victim, ent, owner, BLACKHOLE_DAMAGE, DMG_GENERIC);
				continue;
			}

			xs_vec_normalize(dir, dir);
			xs_vec_mul_scalar(dir, BLACKHOLE_FORCE * (1.0 + (1.0 - dist / BLACKHOLE_RADIUS)), dir);
			set_pev(victim, pev_velocity, dir);
		}
	}

	if(equal(classname, SCREEN_CLASSNAME))
	{
		if(pev(ent, pev_impulse) != SCREEN_MAGIC)
			return FMRES_IGNORED

		if(!(1 <= id <= g_MaxPlayers) || !IsHoldingBeam(id))
		{
			if(1 <= id <= g_MaxPlayers && g_iEnt[id] == ent)
				g_iEnt[id] = 0

			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_SUPERCEDE
		}

		new Float:now = get_gametime()
		new Float:last
		pev(ent, pev_fuser1, last)
		new Float:step = (now - last) * FADE_FPS
		set_pev(ent, pev_fuser1, now)

		new Float:frame
		pev(ent, pev_frame, frame)

		if(pev(ent, pev_iuser2))
		{
			frame -= step
			if(frame <= 0.0)
			{
				g_iEnt[id] = 0
				engfunc(EngFunc_RemoveEntity, ent)
				return FMRES_SUPERCEDE
			}
		}
		else
		{
			frame += step
			if(frame >= HOLD_FRAME)
			{
				frame = HOLD_FRAME
				set_pev(ent, pev_iuser2, 1)
			}
		}

		set_pev(ent, pev_frame, frame)

		set_pev(ent, pev_nextthink, now + 0.01)
		return FMRES_SUPERCEDE
	}
	
	// ---- Wingman projectile (NOCLIP grenade + laser trail + sphere hit) ----
	if(equal(classname, PROJ_CLASSNAME))
	{
		if(pev(ent, pev_impulse) != PROJ_MAGIC)
			return FMRES_IGNORED

		static Float:pnow, Float:expire
		pnow = get_gametime()
		pev(ent, pev_fuser1, expire)

		if(pnow >= expire)
		{
			Proj_Explode(ent)
			return FMRES_IGNORED
		}

		static Float:origin[3], Float:vel[3], Float:trailEnd[3]
		pev(ent, pev_origin, origin)
		pev(ent, pev_velocity, vel)

		// --- laser trail ---
		trailEnd[0] = origin[0] - vel[0] * 0.01
		trailEnd[1] = origin[1] - vel[1] * 0.01
		trailEnd[2] = origin[2] - vel[2] * 0.01
		
		g_Proj[id] = ent;

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_BEAMFOLLOW)
		write_short(ent)            // entity to follow
		write_short(g_sprLaser)     // sprite
		write_byte(PROJ_TRAIL_LIFE)              // life (tenths)
		write_byte(PROJ_TRAIL_WIDTH)
		write_byte(WINGMAN_COLOR_R)
		write_byte(WINGMAN_COLOR_G)
		write_byte(WINGMAN_COLOR_B)
		write_byte(200)             // brightness
		message_end()

		// --- [NEW] sphere hit detection (NOCLIP ignores the world) ---
		new owner = pev(ent, pev_owner)
		new target = pev(ent, pev_enemy)

		// 1) If the projectile got close to any enemy, it detonates.
		//    Also covers the case where the original target moved away.
		new victim = -1
		while((victim = engfunc(EngFunc_FindEntityInSphere, victim, origin, PROJ_SPHERE_RADIUS)) != 0)
		{
			if(!(1 <= victim <= g_MaxPlayers) || victim == owner)
				continue
			if(!is_user_alive(victim))
				continue
			if(cs_get_user_team(victim) == cs_get_user_team(owner))
				continue

			Proj_Explode(ent)
			return FMRES_SUPERCEDE
		}

		// 2) If it got close enough to the intended target (who may have been
		//    skipped by the loop above due to timing), detonate anyway.
		if(1 <= target <= g_MaxPlayers && is_user_alive(target))
		{
			static Float:torg[3]
			pev(target, pev_origin, torg)

			if(get_distance_f(origin, torg) <= PROJ_HIT_RADIUS)
			{
				Proj_Explode(ent)
				return FMRES_SUPERCEDE
			}
		}

		set_pev(ent, pev_nextthink, pnow + 0.02)
		return FMRES_SUPERCEDE
	}

	return FMRES_IGNORED
}

Proj_Explode(ent)
{
	if(!pev_valid(ent))
		return

	new owner = pev(ent, pev_owner)

	if(1 <= owner <= g_MaxPlayers && g_Proj[owner] == ent)
		g_Proj[owner] = 0

	static Float:origin[3]
	pev(ent, pev_origin, origin)

	// radius damage only — no explosion sprite, no tempentity
	Radius_Damage(owner, ent, origin, PROJ_RADIUS_DMG, PROJ_RADIUS_DAMAGE, DMG_ENERGYBEAM)
	FX_Blood(origin, 77, 10);
	engfunc(EngFunc_RemoveEntity, ent)
}

create_hole(owner, Float:origin[3])
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"));
	if (!pev_valid(ent)) return;

	set_pev(ent, pev_classname, BLACKHOLE_CLASSNAME);
	set_pev(ent, pev_spawnflags, SF_SPRITE_STARTON);
	set_pev(ent, pev_solid, SOLID_NOT);
	set_pev(ent, pev_movetype, MOVETYPE_NONE);
	set_pev(ent, pev_owner, owner);
	set_pev(ent, pev_rendermode, kRenderTransAdd);
	set_pev(ent, pev_renderamt, 255.0);
	set_pev(ent, pev_scale, 0.65);
	set_pev(ent, pev_framerate, 15.0);
	set_pev(ent, pev_fuser1, get_gametime() + BLACKHOLE_LIFE);

	engfunc(EngFunc_SetModel, ent, ExtraSprites[5]);
	dllfunc(DLLFunc_Spawn, ent);
	engfunc(EngFunc_SetOrigin, ent, origin);
}

CreateBeamgunFx(id, SzClassname[], SzModel[], iAnim, Float:fTime, Float:fScale,  bool:bFollow = true)
{
	new Float:vVector[3], Float:vAngle[3]
	pev(id, pev_origin, vVector)
	pev(id, pev_angles, vAngle)
	vVector[2] += 12.0
	vAngle[0] = -vAngle[0]

	new iEf = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(iEf)) return 0

	set_pev(iEf, pev_classname, SzClassname)
	set_pev(iEf, pev_owner, id)
	engfunc(EngFunc_SetModel, iEf, SzModel)

	if(bFollow)
	{
		set_pev(iEf, pev_movetype, MOVETYPE_FOLLOW)
		set_pev(iEf, pev_aiment, id)
	}
	else
	{
		set_pev(iEf, pev_movetype, MOVETYPE_NONE)
		set_pev(iEf, pev_aiment, 0)
		set_pev(iEf, pev_angles, vAngle)
		engfunc(EngFunc_SetOrigin, iEf, vVector)
	}

	set_pev(iEf, pev_animtime, get_gametime())
	set_pev(iEf, pev_framerate, 1.0)
	set_pev(iEf, pev_sequence, iAnim)
	set_pev(iEf, pev_scale, fScale)

	set_pev(iEf, pev_rendermode, FX_RENDERMODE)
	set_pev(iEf, pev_renderamt, 255.0)

	set_pev(iEf, pev_fuser1, get_gametime() + fTime)
	set_pev(iEf, pev_nextthink, get_gametime() + 0.05)

	dllfunc(DLLFunc_Spawn, iEf)
	engfunc(EngFunc_SetSize, iEf, Float:{-0.1, -0.1, -0.1}, Float:{0.1, 0.1, 0.1})

	return iEf
}

bool:Fx_RemoveLeapUp(id)
{
	new ent = g_LeapFx[id]
	g_LeapFx[id] = 0

	if(ent <= 0 || !IsValidPev(ent))
		return false

	static cls[32]
	pev(ent, pev_classname, cls, charsmax(cls))
	if(!equal(cls, LEAPUP_CLASSNAME) || pev(ent, pev_owner) != id)
		return false

	new Float:fNow = get_gametime()
	new Float:fEnd
	pev(ent, pev_fuser1, fEnd)

	if(fEnd > fNow + FX_FADE_TIME)
		set_pev(ent, pev_fuser1, fNow + FX_FADE_TIME)

	set_pev(ent, pev_nextthink, fNow + 0.01)
	return true
}

bool:Orb_Attack(id, ent, Float:src[3])
{
	if(!pev_valid(ent)) return false
	
	new target, Float:best = WINGMAN_RANGE, Float:dist, Float:vorg[3]

	for(new i = 1; i <= g_MaxPlayers; i++)
	{
		if(i == id || !is_user_alive(i)) continue
		if(cs_get_user_team(i) == cs_get_user_team(id)) continue

		pev(i, pev_origin, vorg)
		dist = get_distance_f(src, vorg)
		if(dist >= best) continue

		engfunc(EngFunc_TraceLine, src, vorg, DONT_IGNORE_MONSTERS, id, 0)
		if(get_tr2(0, TR_pHit) != i) continue

		best = dist
		target = i
	}

	if(!target) return false

	g_OrbTarget[id] = target
	Orb_FireProjectile(id, target)

	return true
}

Orb_FireProjectile(id, target)
{
	Orb_RemoveProjectile(id)

	new orb = g_Orb[id]
	if(!orb || !pev_valid(orb) || pev(orb, pev_impulse) != WINGMAN_MAGIC)
		return

	new Float:src[3], Float:dst[3], Float:dir[3], Float:len
	pev(orb, pev_origin, src)
	pev(target, pev_origin, dst)
	dst[2] += 16.0

	xs_vec_sub(dst, src, dir)
	len = vector_length(dir)
	if(len < 1.0)
		len = 1.0

	xs_vec_mul_scalar(dir, 1.0 / len, dir)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent))
		return

	set_pev(ent, pev_classname, PROJ_CLASSNAME)
	set_pev(ent, pev_impulse, PROJ_MAGIC)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)

	engfunc(EngFunc_SetModel, ent, PROJ_MODEL)
	engfunc(EngFunc_SetSize, ent, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0})
	engfunc(EngFunc_SetOrigin, ent, src)
	set_pev(ent, pev_rendermode, kRenderTransTexture)
	set_pev(ent, pev_renderamt, 0.0)
	set_pev(ent, pev_scale, PROJ_SCALE)

	xs_vec_mul_scalar(dir, PROJ_SPEED, dir)
	set_pev(ent, pev_velocity, dir)

	set_pev(ent, pev_enemy, target)
	set_pev(ent, pev_fuser1, get_gametime() + PROJ_LIFE)
	set_pev(ent, pev_fuser2, 0.0)
	set_pev(ent, pev_nextthink, get_gametime() + 0.01)

	g_Proj[id] = ent

	PlaySoundFile_Beamgun(id, SND_ORB, VOL_NORM, 4.0, CHAN_ITEM)
}
/* Cleanup helper — safe to call even if none exists */
Orb_RemoveProjectile(id)
{
	new ent = g_Proj[id]
	if(ent && pev_valid(ent) && pev(ent, pev_impulse) == PROJ_MAGIC)
		engfunc(EngFunc_RemoveEntity, ent)

	g_Proj[id] = 0
}

DoLaser(id)
{
	emit_sound(id, CHAN_WEAPON, SND_LASER, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	RightHand_Query(id)

	new Float:start[3], Float:ofs[3], Float:ang[3], Float:vForward[3], Float:vRight[3], Float:end[3], Float:bstart[3]
	pev(id, pev_origin, start)
	pev(id, pev_view_ofs, ofs)
	pev(id, pev_v_angle, ang)
	xs_vec_add(start, ofs, start)

	engfunc(EngFunc_MakeVectors, ang)
	global_get(glb_v_forward, vForward)
	global_get(glb_v_right, vRight)

	end[0] = start[0] + vForward[0] * LASER_RANGE
	end[1] = start[1] + vForward[1] * LASER_RANGE
	end[2] = start[2] + vForward[2] * LASER_RANGE

	engfunc(EngFunc_TraceLine, start, end, DONT_IGNORE_MONSTERS, id, 0)
	new hit = get_tr2(0, TR_pHit)
	get_tr2(0, TR_vecEndPos, end)

	new Float:flSide = g_iRightHand[id] ? 1.0 : -1.0
	bstart[0] = start[0] + vForward[0] * LASER_OFS_FWD + vRight[0] * LASER_OFS_RIGHT * flSide
	bstart[1] = start[1] + vForward[1] * LASER_OFS_FWD + vRight[1] * LASER_OFS_RIGHT * flSide
	bstart[2] = start[2] + vForward[2] * LASER_OFS_FWD + vRight[2] * LASER_OFS_RIGHT * flSide - LASER_OFS_UP

	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMPOINTS)
	engfunc(EngFunc_WriteCoord, bstart[0])
	engfunc(EngFunc_WriteCoord, bstart[1])
	engfunc(EngFunc_WriteCoord, bstart[2])
	engfunc(EngFunc_WriteCoord, end[0])
	engfunc(EngFunc_WriteCoord, end[1])
	engfunc(EngFunc_WriteCoord, end[2])
	write_short(g_sprLaser)
	write_byte(0)
	write_byte(30)
	write_byte(5)
	write_byte(30)
	write_byte(0)
	write_byte(255)
	write_byte(255)
	write_byte(255)
	write_byte(255)
	write_byte(0)
	message_end()

	static Float:normal[3]
	get_tr2(0, TR_vecEndPos, end)
	get_tr2(0, TR_vecPlaneNormal, normal)

	end[0] += normal[0] * 5.0
	end[1] += normal[1] * 5.0
	end[2] += normal[2] * 5.0

	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, end, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, end[0])
	engfunc(EngFunc_WriteCoord, end[1])
	engfunc(EngFunc_WriteCoord, end[2])
	write_short(g_sprHitCharge)
	write_byte(HIT_CHARGE_SCALE)
	write_byte(HIT_FRAMERATE)
	write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	message_end()

	static Inflictor; Inflictor = fm_get_user_weapon_entity(id, CSW_BEAMGUN)
	if(!pev_valid(Inflictor)) Inflictor = id

	Radius_Damage(id, Inflictor, end, 180.0, DAMAGE_EXP, DMG_GENERIC)

	if(1 <= hit <= g_MaxPlayers && is_user_alive(hit) && hit != id && cs_get_user_team(hit) != cs_get_user_team(id))
		ExecuteHamB(Ham_TakeDamage, hit, id, id, LASER_DAMAGE, DMG_ENERGYBEAM)
}

AreaDamage(id)
{
	new Float:org[3]
	pev(id, pev_origin, org)

	static Inflictor; Inflictor = fm_get_user_weapon_entity(id, CSW_BEAMGUN)
	if(!pev_valid(Inflictor)) Inflictor = id

	Radius_Damage(id, Inflictor, org, AREA_RADIUS, AREA_DAMAGE, DMG_GENERIC)
	
	for(new victim = 1; victim <= g_MaxPlayers; victim++)
	{
		if(victim == id || !is_user_alive(victim)) continue
		if(cs_get_user_team(id) == cs_get_user_team(victim)) continue
		
		Stock_Fake_KnockBack(id, victim, 15.0, 100.0,5.0)
	}

	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, org, 0)
	write_byte(TE_BEAMCYLINDER)
	engfunc(EngFunc_WriteCoord, org[0])
	engfunc(EngFunc_WriteCoord, org[1])
	engfunc(EngFunc_WriteCoord, org[2])
	engfunc(EngFunc_WriteCoord, org[0])
	engfunc(EngFunc_WriteCoord, org[1])
	engfunc(EngFunc_WriteCoord, org[2] + AREA_RADIUS)
	write_short(g_sprLaser)
	write_byte(0)
	write_byte(0)
	write_byte(6)
	write_byte(40)
	write_byte(0)
	write_byte(255)
	write_byte(100)
	write_byte(50)
	write_byte(200)
	write_byte(0)
	message_end()
}

public Task_ResetMode(taskid)
{
	new id = taskid - TASK_RESET
	if(!is_user_connected(id)) return

	g_iMode[id] = MODE_NONE
	g_iModeCount[id] = 0

	if(IsHoldingBeam(id))
	{
		set_weapon_anim(id, ANIM_CHARGE_IDLE_REVERSE)
		SetWeaponIdle(id, 1.0)
	}
}

Screen_Remove(id)
{
	new ent = g_iEnt[id]
	if(ent && pev_valid(ent) && pev(ent, pev_impulse) == SCREEN_MAGIC)
		engfunc(EngFunc_RemoveEntity, ent)

	g_iEnt[id] = 0
}

stock set_weapon_anim(id, anim)
{
	if(!is_user_alive(id))
		return

	set_pev(id, pev_weaponanim, anim)

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM_ID, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
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

stock Make_BulletHole(id, Float:Origin[3], Float:Damage)
{
	static Decal; Decal = random_num(41, 45)
	static LoopTime

	if(Damage > 100.0) LoopTime = 2
	else LoopTime = 1

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

Shoot_CheckExplosion(id, Ptr)
{
	new count = g_iShootCount[id] + 1
	new sprite = 0, scale = 0

	switch(count)
	{
		case 2, 4, 6, 8:
		{
			sprite = g_sprHitA
			scale = HIT_A_SCALE
			emit_sound(id, CHAN_ITEM, ExtraSounds[19], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		}
		case 10:
		{
			sprite = g_sprHitCharge
			scale = HIT_CHARGE_SCALE
			DoLaser(id)
			emit_sound(id, CHAN_ITEM, ExtraSounds[20], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		}
		default: return
	}

	static Float:end[3], Float:normal[3]
	get_tr2(Ptr, TR_vecEndPos, end)
	get_tr2(Ptr, TR_vecPlaneNormal, normal)

	end[0] += normal[0] * 5.0
	end[1] += normal[1] * 5.0
	end[2] += normal[2] * 5.0

	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, end, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, end[0])
	engfunc(EngFunc_WriteCoord, end[1])
	engfunc(EngFunc_WriteCoord, end[2])
	write_short(sprite)
	write_byte(scale)
	write_byte(HIT_FRAMERATE)
	write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	message_end()

	static Inflictor; Inflictor = fm_get_user_weapon_entity(id, CSW_BEAMGUN)
	if(!pev_valid(Inflictor)) Inflictor = id

	Radius_Damage(id, Inflictor, end, 180.0, DAMAGE_EXP, DMG_GENERIC)
}

public Make_BulletSmoke(id, TrResult)
{
	static Float:vecSrc[3], Float:vecEnd[3]
	new TE_FLAG = TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES

	get_weapon_attachment(id, vecSrc)
	global_get(glb_v_forward, vecEnd)

	xs_vec_mul_scalar(vecEnd, 8192.0, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecEnd)

	get_tr2(TrResult, TR_vecEndPos, vecSrc)
	get_tr2(TrResult, TR_vecPlaneNormal, vecEnd)

	xs_vec_mul_scalar(vecEnd, 2.5, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecEnd)

	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, vecEnd, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, vecEnd[0])
	engfunc(EngFunc_WriteCoord, vecEnd[1])
	engfunc(EngFunc_WriteCoord, vecEnd[2] - 10.0)
	write_short(g_SmokePuff_SprId)
	write_byte(2)
	write_byte(50)
	write_byte(TE_FLAG)
	message_end()
}

stock get_weapon_attachment(id, Float:output[3], Float:fDis = 40.0)
{
	static Float:vfEnd[3], viEnd[3]
	get_user_origin(id, viEnd, 3)
	IVecFVec(viEnd, vfEnd)

	static Float:fOrigin[3], Float:fAngle[3]

	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, fAngle)

	xs_vec_add(fOrigin, fAngle, fOrigin)

	static Float:fAttack[3]

	xs_vec_sub(vfEnd, fOrigin, fAttack)

	static Float:fRate

	fRate = fDis / vector_length(fAttack)
	xs_vec_mul_scalar(fAttack, fRate, fAttack)

	xs_vec_add(fOrigin, fAttack, output)
}

stock create_screen(id)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(!pev_valid(ent))
		return

	set_pev(ent, pev_classname, SCREEN_CLASSNAME)
	set_pev(ent, pev_impulse, SCREEN_MAGIC)
	set_pev(ent, pev_owner, id)
	engfunc(EngFunc_SetModel, ent, ExtraSprites[6])
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	set_pev(ent, pev_scale, SCALE)
	set_pev(ent, pev_iuser2, 0)
	set_pev(ent, pev_fuser1, get_gametime())

	dllfunc(DLLFunc_Spawn, ent)

	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(ent, pev_body, 3)
	set_pev(ent, pev_skin, id)
	set_pev(ent, pev_aiment, id)
	set_pev(ent, pev_nextthink, get_gametime() + 0.01)

	g_iEnt[id] = ent
}

stock Bar_Create(id)
{
	Bar_Remove(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent)) return

	set_pev(ent, pev_classname, BAR_CLASSNAME)
	set_pev(ent, pev_impulse, BAR_MAGIC)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(ent, pev_solid, SOLID_NOT)

	set_pev(ent, pev_body, 2)
	set_pev(ent, pev_skin, id)
	set_pev(ent, pev_aiment, id)

	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	set_pev(ent, pev_scale, BAR_SCALE)
	set_pev(ent, pev_framerate, 0.0)

	engfunc(EngFunc_SetModel, ent, ExtraSprites[2])

	set_pev(ent, pev_frame, BAR_FRAME_FULL)

	Bar_UpdateOrigin(id, ent)

	set_pev(ent, pev_nextthink, get_gametime() + BAR_THINK)

	g_Bar[id] = ent
	Set_BitVar(g_BarMask, id)
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

	set_pev(Ent, pev_scale, 0.15)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 5.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)

	set_pev(Ent, pev_nextthink, get_gametime() + 0.04)
}

stock Radius_Damage(id, inflictor, Float:vicOri[3], Float:fRadius, Float:fDamage, dmgbits)
{
	new i = -1

	while((i = fm_find_ent_in_sphere(i, vicOri, fRadius)) != 0)
	{
		if(id == i) continue
		if(pev(i, pev_takedamage) == DAMAGE_NO) continue
		if(pev(i, pev_spawnflags) == SF_BREAK_TRIGGER_ONLY) continue

		if(1 <= i <= g_MaxPlayers)
		{
			if(!is_user_alive(i)) continue
			if(get_user_team(i) == get_user_team(id)) continue
		}

		ExecuteHamB(Ham_TakeDamage, i, inflictor, id, fDamage, dmgbits)
	}
}

stock UTIL_PrecacheWeaponList(const szWeaponList[])
{
	new szBuffer[128], pFile;

	format(szBuffer, charsmax(szBuffer), "sprites/beamgun/%s.txt", szWeaponList);
	engfunc(EngFunc_PrecacheGeneric, szBuffer);

	if (!(pFile = fopen(szBuffer, "rb")))
		return;

	new szSprName[ 64 ], iPos;
	while (!feof(pFile))
	{
		fgets(pFile, szBuffer, charsmax(szBuffer));
		trim(szBuffer);

		if (!strlen(szBuffer))
			continue;

		if ((iPos = containi(szBuffer, "640")) == -1)
			continue;

		format(szBuffer, charsmax(szBuffer), "%s", szBuffer[ iPos + 3 ]);
		trim(szBuffer);

		strtok(szBuffer, szSprName, charsmax(szSprName), szBuffer, charsmax(szBuffer), ' ', 1);
		trim(szSprName);

		engfunc(EngFunc_PrecacheGeneric, fmt("sprites/beamgun/%s.spr", szSprName));

	}

	fclose(pFile);
}

stock UTIL_SetHud(const pPlayer, const iHud)
{
	static iMsgId_HideWeapon;
	if (!iMsgId_HideWeapon)
		iMsgId_HideWeapon = get_user_msgid("HideWeapon");

	message_begin(MSG_ONE, iMsgId_HideWeapon, _, pPlayer);
	write_byte(iHud);
	message_end();
}

stock Stock_Fake_KnockBack(attacker, victim, Float:iKb, Float:scalar, Float:flUp)
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

stock UTIL_WeaponList(client_index, bool: bEnabled)
{
	static iMsgId_Weaponlist;
	if (!iMsgId_Weaponlist)
		iMsgId_Weaponlist = get_user_msgid("WeaponList");

	message_begin(MSG_ONE, iMsgId_Weaponlist, _, client_index);
	write_string(bEnabled ? weapon_spr : weapon_beamgunle);
	write_byte(iWeaponList[0]);
	write_byte(iWeaponList[1]);
	write_byte(bEnabled ? WeaponSecondaryAmmoIndex : iWeaponList[2]);
	write_byte(bEnabled ? WeaponSecondaryAmmoMax   : iWeaponList[3]);
	write_byte(iWeaponList[4]);
	write_byte(iWeaponList[5]);
	write_byte(iWeaponList[6]);
	write_byte(iWeaponList[7]);
	message_end();
}

stock ForceLanding(id)
{
	static const Float:vecZero[3] = {0.0, 0.0, 0.0}

	new Float:vecOrigin[3], Float:vecEnd[3]
	pev(id, pev_origin, vecOrigin)
	vecEnd = vecOrigin
	vecEnd[2] -= 8192.0

	new iHull = (pev(id, pev_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN

	new tr = create_tr2()
	engfunc(EngFunc_TraceHull, vecOrigin, vecEnd, IGNORE_MONSTERS, iHull, id, tr)

	new Float:flFraction
	get_tr2(tr, TR_flFraction, flFraction)

	if(get_tr2(tr, TR_StartSolid) || get_tr2(tr, TR_AllSolid) || flFraction >= 1.0)
	{
		free_tr2(tr)
		set_pev(id, pev_velocity, vecZero)
		return
	}

	new Float:vecLand[3]
	get_tr2(tr, TR_vecEndPos, vecLand)
	new entGround = get_tr2(tr, TR_pHit)
	free_tr2(tr)

	if(!pev_valid(entGround))
		entGround = 0

	engfunc(EngFunc_SetOrigin, id, vecLand)
	set_pev(id, pev_velocity, vecZero)

	set_pev(id, pev_groundentity, entGround)
	set_pev(id, pev_flags, pev(id, pev_flags) | FL_ONGROUND)
}

stock get_aim_origin(id, Float:origin[3], Float:maxdist = 1000.0)
{
	new Float:start[3], Float:view_ofs[3], Float:angles[3], Float:fwd[3], Float:end[3];

	pev(id, pev_origin, start);
	pev(id, pev_view_ofs, view_ofs);
	xs_vec_add(start, view_ofs, start);

	pev(id, pev_v_angle, angles);
	engfunc(EngFunc_MakeVectors, angles);
	global_get(glb_v_forward, fwd);

	xs_vec_mul_scalar(fwd, maxdist, fwd);
	xs_vec_add(start, fwd, end);

	engfunc(EngFunc_TraceLine, start, end, IGNORE_MONSTERS, id, 0);
	get_tr2(0, TR_vecEndPos, origin);

	new Float:normal[3];
	get_tr2(0, TR_vecPlaneNormal, normal);
	xs_vec_mul_scalar(normal, 30.0, normal);
	xs_vec_add(origin, normal, origin);
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

stock Start_Charge(id)
{
	SetSecondaryAmmo(id, CHARGE_START)
	g_NextCharge[id] = get_gametime() + (CHARGE_TIMES / float(CHARGE_MAX))
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

/* ============================================================
 * PlaySoundFile_Beamgun
 * Plays a specific .wav on ONE player — but ONLY if that
 * player currently owns/holds the beamgun.
 *   Returns true if the sound was sent, false otherwise.
 * ============================================================ */
stock bool:PlaySoundFile_Beamgun(id, const wav[], Float:volume = VOL_NORM, Float:atten = ATTN_NORM, channel = CHAN_ITEM, pitch = PITCH_NORM)
{
	if(!is_user_connected(id))
		return false

	// only players who actually have the beamgun
	if(!Get_BitVar(g_ActiveWeapon, id))
		return false
	if(!is_user_alive(id))
		return false

	// OPTIONAL: require they are holding it right now
	// (comment these two lines out if you want "own it anywhere in inventory")
	if(get_user_weapon(id) != CSW_BEAMGUN)
		return false

	// named-sound route -> stoppable, pitch/atten work
	engfunc(EngFunc_EmitSound, id, channel, wav, volume, atten, 0, pitch)
	return true
}

/* ============================================================
 * StopSoundFile_Beamgun
 * Stops the named sound on that player's channel — only if
 * they still have the beamgun (harmless if they don't).
 * ============================================================ */
stock bool:StopSoundFile_Beamgun(id, const wav[], channel = CHAN_ITEM)
{
	if(!is_user_connected(id))
		return false

	if(!Get_BitVar(g_ActiveWeapon, id))
		return false

	engfunc(EngFunc_EmitSound, id, channel, wav, VOL_NORM, ATTN_NORM, SND_STOP, PITCH_NORM)
	return true
}
