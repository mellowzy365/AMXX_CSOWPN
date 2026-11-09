/* ====================================== NoReAPI Version ============================  */
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <xs>
#include <fun>
#include <cstrike>

#define PLUGIN_NAME    "Naberius and Naberius SP"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR  "Mellowzy"

//autoprecachesound from .mdl (5004)
#define PrecacheSoundsFromModel 1

//using naberius <comment it if you want using arcane naberius>
#define UsingNaberius

#if !defined NULLENT
	#define NULLENT -1
#endif
/* =============================================================================  */
/* ========================== CSOWPN_Data =======================================  */
#define CSW_SOULREAPEREX CSW_M4A1
#define WEAPON_REFERENCE "weapon_m4a1"
#define WEAPON_IMPULSE 3399012
#define WEAPON_EVENTS "events/m4a1.sc"
#define OLD_MDL_REFERENCE "models/w_m4a1.mdl"
#define REFERENCE_BODY_NUM		0
/* =============================================================================  */
/* ========================== Soulreaperex_Resources ============================  */

/* ============================== Naberius ===================================  */
// weapons
#if defined UsingNaberius
#define P_MDL "models/mellowzy/p_soulreaper.mdl"
#define V_MDL "models/mellowzy/v_soulreaper_a.mdl"
#define V_MDL_S "models/mellowzy/v_soulreaper_c.mdl"
#define W_MDL "models/mellowzy/w_soulreaper.mdl"

//sounds
#define SND_SHOOTA "weapons/soulreaper-1.wav"
#define SND_SHOOTB "weapons/soulreaper-2.wav"
#define SND_SHOOTC "weapons/soulreaper-3.wav"
#define SND_SHOOTB_EXP "weapons/soulreaper-2_exp.wav"
#define SND_BALLS_APPEAR "weapons/soulreaper_bmod_start.wav"

//entities
#define HELIX_MDL1 "models/mellowzy/ef_soulreaper_shoot_c_fx.mdl"
#define HELIX_MDL2 "models/mellowzy/ef_soulreaper_shoot_c02_fx.mdl"
#define EXPLOSION_MDL "sprites/mellowzy/ef_soulreaper_exp.spr"
#define AOE_SPR "sprites/mellowzy/ef_soulreaper_p.spr"
#define SPHERE_SPR "sprites/mellowzy/ef_soulreaper_sphere.spr"
#define SPHERE_SPR2 "sprites/mellowzy/ef_soulreaper_sphere02.spr"
#define HELIX_SPR_LASER "sprites/mellowzy/ef_soulreaper_laser.spr"
#define EF_B_SPR "sprites/mellowzy/ef_soulreaper_bmode.spr"
#define EF_GAUGE_SPR "sprites/mellowzy/ef_soulreaper_gauge.spr"
#define MUZZ_A_SPR "sprites/mellowzy/muzzleflash356.spr"
#define MUZZ_C_SPR "sprites/mellowzy/muzzleflash361.spr"

#define EF_DRAW_SPR "sprites/mellowzy/ef_soulreaper_draw.spr"
#define EF_IDLEA_SPR "sprites/mellowzy/ef_soulreaper_amode.spr"
#define EF_IDLEC_SPR "sprites/mellowzy/ef_soulreaper_cmode.spr"
#define EF_RELOAD_SPR "sprites/mellowzy/muzzleflash357.spr"
#define EF_SHOOTB_SPR "sprites/mellowzy/muzzleflash359.spr"

#define SMOKE_SPR "sprites/wall_puff1.spr"

#define WEAPON_SPR "weapon_soulreaper"
#define WEAPON_TXT "sprites/weapon_soulreaper.txt"

#define MUZZLEFLASH_MAX_FRAMES 8.0
#define MAX_SHOOT_COUNT 10

new const ExtraSprites[][] =
{
	"sprites/640hud224.spr",
	"sprites/640hud241.spr"
}

enum
{
	ANIM_IDLE = 0,
	ANIM_IDLEC,
	ANIM_DRAW,
	ANIM_RELOADA,
	ANIM_RELOADC,
	ANIM_SHOOTA,
	ANIM_SHOOTBA,
	ANIM_SHOOTC,
	ANIM_CHANGECA
}

#endif

/* ============================== Arcane Naberius ===================================  */

#if !defined UsingNaberius
#define P_MDL "models/mellowzy/p_soulreaperex.mdl"
#define V_MDL "models/mellowzy/v_soulreaperex_a.mdl"
#define V_MDL_S "models/mellowzy/v_soulreaperex_c.mdl"
#define W_MDL "models/mellowzy/w_soulreaperex.mdl"

//sounds
#define SND_SHOOTA "weapons/soulreaper-1.wav"
#define SND_SHOOTB "weapons/soulreaper-2.wav"
#define SND_SHOOTC "weapons/soulreaperex-3.wav"
#define SND_SHOOTB_EXP "weapons/soulreaper-2_exp.wav"
#define SND_BALLS_APPEAR "weapons/soulreaper_bmod_start.wav"

//entities
#define HELIX_MDL1 "models/mellowzy/ef_soulreaperex_shoot_c_fx.mdl"
#define HELIX_MDL2 "models/mellowzy/ef_soulreaperex_shoot_c02_fx.mdl"
#define EXPLOSION_MDL "sprites/mellowzy/ef_soulreaperex_exp.spr"
#define AOE_SPR "sprites/mellowzy/ef_soulreaperex_p.spr"
#define SPHERE_SPR "sprites/mellowzy/ef_soulreaperex_sphere.spr"
#define SPHERE_SPR2 "sprites/mellowzy/ef_soulreaperex_sphere02.spr"
#define HELIX_SPR_LASER "sprites/mellowzy/ef_soulreaperex_laser.spr"
#define EF_B_SPR "sprites/mellowzy/ef_soulreaperex_bmode.spr"
#define EF_GAUGE_SPR "sprites/mellowzy/ef_soulreaperex_gauge.spr"
#define MUZZ_A_SPR "sprites/mellowzy/muzzleflash449.spr"
#define MUZZ_C_SPR "sprites/mellowzy/muzzleflash453.spr"

#define EF_DRAW_SPR "sprites/mellowzy/ef_soulreaperex_draw.spr"
#define EF_IDLEA_SPR "sprites/mellowzy/ef_soulreaperex_amode.spr"
#define EF_IDLEC_SPR "sprites/mellowzy/ef_soulreaperex_cmode.spr"
#define EF_RELOAD_SPR "sprites/mellowzy/muzzleflash450.spr"
#define EF_SHOOTB_SPR "sprites/mellowzy/muzzleflash452.spr"

#define SMOKE_SPR "sprites/wall_puff1.spr"

#define WEAPON_SPR "weapon_soulreaperex"
#define WEAPON_TXT "sprites/weapon_soulreaperex.txt"

#define MUZZLEFLASH_MAX_FRAMES 15.0
#define MAX_SHOOT_COUNT 9

new const ExtraSprites[][] =
{
	"sprites/640hud224.spr",
	"sprites/640hud260.spr"
}

enum
{
	ANIM_IDLE = 0,
	ANIM_SHOOTA,
	ANIM_RELOADA,
	ANIM_DRAW,
	ANIM_SHOOTBA,
	ANIM_SHOOTBC,
	ANIM_IDLEC,
	ANIM_SHOOTC,
	ANIM_RELOADC,
	ANIM_CHANGECA
}

#endif
/* =============================================================================  */
/* ========================== Soulreaperex_Tunables ============================  */
#define ACC_SPREAD_STAND		0.004
#define ACC_SPREAD_MOVE			0.04
#define ACC_SPREAD_AIR			0.10
#define ACC_SPEED_LIMIT			140.0

#define SPEED_A					1.95
#define SPEED_B					1.2
#define SPEED_C					1.5
#define RECOIL					0.75

#define DAMAGEA					15.0
#define DAMAGE_EXP				25.0
#define AOE_DAMAGE 				15.0
#define AOE_KNOCKBACK 			5.0
#define HELIX_FRAMEMAX 			44.0
#define HELIX_RANGE 			450.0
#define HELIX_DAMAGE 			15.0
#define HELIX_BEAM_DAMAGE 		15.0
#define HELIX_BEAM_PULL 		6500.0
#define HELIX_BEAM_RADIUS 		450.0
#define HELIX_BEAM_LENGTH 		800.0
#define HELIX_KNOCKBACK 		5.0

#define RELOAD_TIME 			2.0
#define CLIP 					80
#define BPAMMO 					240

// Arcane Armor (passive)
#define ARMOR_HITS_TO_ACTIVATE	20		// Bullet hits on enemies needed to activate the armor
#define ARMOR_RADIUS			250.0	// Blast radius when the armor triggers
#define ARMOR_DAMAGE			100.0	// Blast damage per enemy
#define ARMOR_KNOCKBACK			800.0	// Horizontal knockback speed
#define ARMOR_KNOCKUP			250.0	// Vertical knockback speed
#define ARMOR_HEAL_PER_ENEMY	20.0	// HP restored per enemy knocked back
#define ARMOR_HEAL_MAX			60.0	// Max HP restored by a single trigger
#define ARMOR_MAX_HEALTH		100.0	// Healing never raises HP above this
#define ARMOR_COOLDOWN			30.0	// Re-activation lock (sec) once it was used more than once in a round
#define ARMOR_GLOW_R			255
#define ARMOR_GLOW_G			100
#define ARMOR_GLOW_B			200
/* =============================================================================  */
/* ========================== Soulreaperex_Entities_Data ========================  */
//Classnames
#define SPHERE_CLASSNAME "EF_Soulreaperex_sphere"
#define HELIX_CLASSNAME "EF_Soulreaperex_helix"
#define MUZZLE_A_CLS "EF_Soulreaperex_muzzleflashA"
#define MUZZLE_C_CLS "EF_Soulreaperex_muzzleflashC"
#define EF_GAUGE_CLAS "EF_Soulreaperex_gauge"

#define EF_IDLE_CLS "EF_Soulreaperex_idle"
#define EF_DRAW_CLS "EF_Soulreaperex_draw"
#define EF_RELOAD_CLASSNAME "EF_Soulreaperex_reloadef"
#define SHOOTA_CLASSNAME "EF_Soulreaperex_aoe"
#define SHOOTB_CLASSNAME "EF_Soulreaperex_shootb"

#if !defined EF_NOINTERP
	#define EF_NOINTERP         32
#endif
#if !defined SF_SPRITE_ONCE
	#define SF_SPRITE_ONCE      2
#endif

#define ENTITY_MARGIN           100
#define RADIAN_CONV     		0.0174532925
//Tunables

//sphere
#define SPHERE_RADIUS        250.0      // General radius (currently unused, kept for reference)
#define SPHERE_DETECT_RADIUS 220.0      // Radius to detect enemies
#define SPHERE_MAX           3          // Max hovering spheres
#define SPHERE_HOVER_HEIGHT  20.0      // Height of the ring center above the player origin
#define SPHERE_BACK_DIST     35.0      // Distance of the ring behind the player's back
#define SPHERE_HOVER_RADIUS  20.0      // Radius of the orbit circle
#define SPHERE_ORBIT_GAP     120.0      // Angle (deg) between 2 spheres on the ring (360 / SPHERE_MAX = evenly spaced)
#define SPHERE_ORBIT_SPEED   100.0      // Orbit rotation speed (deg/sec), clockwise seen from behind
#define SPHERE_MISSILE_SPEED 2048.0      // Speed when launched manually (ATTACK2)
#define SPHERE_TRACK_SPEED   2048.0      // Speed when auto tracking an enemy (no ATTACK2)
#define SPHERE_THINK_RATE    0.03       // Think interval (~33 FPS)
#define SPHERE_SCALE         0.06       // Sprite scale
#define SPHERE_LIFETIME      3.0        // Max flight time after ATTACK2 launch (sec)

// Newer float.inc already defines M_PI -> guard against redefinition
#if !defined M_PI
	#define M_PI 3.14159265358979323846
#endif

//gauge
#define EF_GAUGE_DISTANCE     12.0    // Distance in front of the eyes
#define EF_GAUGE_OFFSET_DOWN  0.8     // How far below the crosshair
#define EF_GAUGE_OFFSET_RIGHT 0.0     // Sideways offset
#define EF_GAUGE_SCALE        0.05    // Sprite scale
#define EF_GAUGE_THINK        0.01    // Think interval

//bmode
//ef_back
#define EF_BACK_CLS "ef_back"
#define EF_BACK_NEXTTHINK 0.04
#define EF_BACK_FRAMEMAX 25.0
#define EF_BACK_FRAME 0.8
#define EF_BACK_SCALE 0.15

//bmode
#define EF_B_CLASSNAME "SoulReaper_ef_b_mode"
#define EF_B_FRAME_MAX 30

//sprites attached to the view model (draw / idle / bmode)
#define EF_FX_FPS          15.0   // Animation speed (frames per second)
#define EF_FX_THINK        0.04   // Think interval
#define EF_FX_IMPULSE      10029310   // Marks the attached sprites so AddToFullPack can recognise them
#define SR_OBS_IN_EYE      4      // pev_iuser1 value of a spectator watching in first person
#define EF_DRAW_FRAMEMAX   33.0   // Frame count of the draw sprite
#define EF_IDLE_FRAMEMAX   44.0   // Frame count of the idle sprites (loop length)

//aoe
#define AOE_FRAMEMAX 44.0
#define AOE_RANGE 180.0

#define AOE_DISTANCE   40.0     // Distance in front of the player (damage center)
#define AOE_VISUAL_DISTANCE 190.0 // Distance in front of the player where the sprite entity is placed (visual only)
#define AOE_VISUAL_OFFSET_Z -20.0   // Vertical offset of the sprite (about -34.0 puts it near the player's feet)
#define AOE_ANIM_FPS   30.0     // Sprite animation speed (frames per second)
#define AOE_KILL_FRAME 14.0     // The sprite is removed once it passes this frame
#define AOE_DAMAGE_INTERVAL 1.0 // Seconds between two damage ticks
#define AOE_OFFSET_Z   -30.0    // Lower it a bit so it doesn't cover the camera
#define AOE_MAX_FRAME  44.0     // Maximum frame of the sprite
#define AOE_SPEED      1.5      // Animation speed per think tick
#define AOE_THINK_RATE 0.03     // Update rate (~33 FPS)

//helix

#define HELIX_MAX_CHARGE 110		// secondary ammo (charge) capacity
#define HELIX_MIN_CHARGE 30	// charge needed to activate helix (full by default)
#define HELIX_REFILL_TIME 1.5		// seconds between each refill tick
#define HELIX_REFILL_AMOUNT 5		// charge restored per refill tick
#define HELIX_CONSUME_TIME 0.6		// seconds between each consume tick
#define HELIX_CONSUME_AMOUNT 10		// charge consumed per consume tick
#define HELIX_CHANGE_TIME 1.0		// attack lock while switching to helix mode
#define HELIX_BEAM_DELAY 0.8
#define HELIX_BEAM_WIDTH        50.0
#define HELIX_ANIM_FRAMERATE    20.0

/* =============================================================================  */
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

#define GetSecondaryAmmo(%0)       				get_pdata_int(%0, m_rgAmmo + WeaponSecondaryAmmoIndex, linux_diff_player)
#define SetSecondaryAmmo(%0,%1)    				set_pdata_int(%0, m_rgAmmo + WeaponSecondaryAmmoIndex, %1, linux_diff_player)
#define HIDEHUD_MONEY  							(1<<5)
#define SET_CUSTOM_HUD 							(HIDEHUD_MONEY)
#define RESET_HUD      							0

/* =============================================================================  */
/* ============================== variables ===================================  */
const WeaponSecondaryAmmoIndex         = 18;
const WeaponSecondaryAmmoMax           = HELIX_MAX_CHARGE;

new const iWeaponList[] =
{
	4, 90, -1, -1, 0, 6, CSW_M4A1, 0
};

new g_ActiveWpn, g_ActiveHelix, g_ArmorActive, g_LeftHand, g_weapon_event, g_HamBot
new g_Old_Weapon[33], g_Clip[33], g_ReClip[33]
new g_ShootCount[33], g_Sphere[33]

new g_MaxPlayers, g_SmokePuff_SprId,g_iExplosionSprite,g_iSpriteLaser
new bool:isCombo[33]
new Float:g_Recoil[33][3]
new Float:g_NextConsume[33], Float:g_NextCharge[33]

// Arcane Armor state
new g_ArmorHits[33], g_ArmorUses[33]
new Float:g_ArmorCooldownEnd[33]
new Float:g_flNextTrace[33];
new Float:g_flIdleHideUntil[33]
new g_pcvFriendlyFire

//ent
new g_sphereEnt[33][SPHERE_MAX];       // Entity indices of hovering spheres
new g_sphereCount[33];                 // How many spheres currently exist
new g_sphereTarget[33][SPHERE_MAX];    // Locked target per sphere (0 = none)
new g_sphereLaunched[33][SPHERE_MAX];  // 1 = in missile mode
new Float:g_orbitAngle[33][SPHERE_MAX];
new Float:g_sphereLaunchTime[33][SPHERE_MAX]; // gametime when the sphere was launched
/* =============================================================================  */
/* ========================== Soulreaperex_Init ============================  */
public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0")

	g_MaxPlayers = get_maxplayers()

	//fakemeta
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", true)
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", true)
	register_forward(FM_Think, "fw_Entity_Think")
	register_forward(FM_Touch, "fw_Entity_Touch")

	//hamsandwich
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player")

	RegisterHam(Ham_Item_Deploy, WEAPON_REFERENCE, "Ham_CWeapon_Deploy_Post", true)
	RegisterHam(Ham_Item_AddToPlayer, WEAPON_REFERENCE, "Ham_CWeapon_AddToPlayer_Post", true)
	RegisterHam(Ham_Item_Holster, WEAPON_REFERENCE, "Ham_CWeapon_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame, WEAPON_REFERENCE, "Ham_CWeapon_PostFrame_Pre")
	RegisterHam(Ham_Weapon_WeaponIdle, WEAPON_REFERENCE, "Ham_CWeapon_Idle_Pre")
	RegisterHam(Ham_Weapon_Reload, WEAPON_REFERENCE, "Ham_CWeapon_Reload_Pre")
	RegisterHam(Ham_Weapon_Reload, WEAPON_REFERENCE, "Ham_CWeapon_Reload_Post", true)
	RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_PrimaryAttack_Pre")
	RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_PrimaryAttack_Post", true)

	RegisterHam(Ham_Spawn, "player", "fw_Spawn_Post", true)
	RegisterHam(Ham_Killed, "player", "fw_Killed_Post", true)
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage_Pre")

	g_pcvFriendlyFire = get_cvar_pointer("mp_friendlyfire")

	register_clcmd(WEAPON_SPR, "CSOWPN_Hook")
	register_clcmd("get_soulreaperex", "CSOWPN_Give")
}

/* =============================================================================  */
/* ========================== Soulreaperex_Precache ============================  */
public plugin_precache()
{
	util_precache_model(P_MDL)
	util_precache_model(V_MDL)
	util_precache_model(V_MDL_S)
	util_precache_model(W_MDL)
	util_precache_model(HELIX_MDL1)
	util_precache_model(HELIX_MDL2)
	util_precache_model(MUZZ_A_SPR)
	util_precache_model(MUZZ_C_SPR)
	util_precache_model(EF_B_SPR)
	util_precache_model(EF_RELOAD_SPR)
	util_precache_model(EF_SHOOTB_SPR)
	util_precache_model(EF_GAUGE_SPR)
	
	g_iExplosionSprite = util_precache_model(EXPLOSION_MDL)
	g_iSpriteLaser = util_precache_model(HELIX_SPR_LASER)

	util_precache_sound(SND_SHOOTA)
	util_precache_sound(SND_SHOOTB)
	util_precache_sound(SND_SHOOTC)
	util_precache_sound(SND_SHOOTB_EXP)
	util_precache_sound(SND_BALLS_APPEAR)

	util_precache_model(AOE_SPR)
	util_precache_model(SPHERE_SPR)
	util_precache_model(SPHERE_SPR2)
	util_precache_model(EF_DRAW_SPR)
	util_precache_model(EF_IDLEA_SPR)
	util_precache_model(EF_IDLEC_SPR)

#if PrecacheSoundsFromModel == 1
	util_precache_sounds_from_model(V_MDL);
	util_precache_sounds_from_model(V_MDL_S);
#endif

	engfunc(EngFunc_PrecacheGeneric, WEAPON_TXT)
	for(new i = 0; i < sizeof ExtraSprites; i++)
		engfunc(EngFunc_PrecacheModel, ExtraSprites[i])

	g_SmokePuff_SprId = engfunc(EngFunc_PrecacheModel, SMOKE_SPR)

	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", true)
}

/* =============================================================================  */
/* ========================== Soulreaperex_CurWeapon ============================  */
public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return

	new csw = read_data(2)

	if(csw == CSW_SOULREAPEREX && Get_BitVar(g_ActiveWpn, id))
	{
		SetViewModel(id)
		set_pev(id, pev_weaponmodel2, P_MDL)
		UTIL_SetHud(id, SET_CUSTOM_HUD);
	}

	g_Old_Weapon[id] = csw
}

// New round: reset the per-round Arcane Armor usage and cooldown
public Event_NewRound()
{
	for(new i = 1; i <= g_MaxPlayers; i++)
	{
		g_ArmorUses[i] = 0
		g_ArmorCooldownEnd[i] = 0.0
	}
}

public client_putinserver(id)
{
	UnSet_BitVar(g_LeftHand, id)
	Query_RightHand(id)

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
	UnSet_BitVar(g_LeftHand, id)
	CSOWPN_Remove(id)
}

public CSOWPN_Give(id)
{
	if(!is_user_alive(id)) return

	Stock_DropSlot(id, 1)

	Set_BitVar(g_ActiveWpn, id)
	UnSet_BitVar(g_ActiveHelix, id)
	fm_give_item(id, WEAPON_REFERENCE)
	Start_Charge(id)
	ResetMode(id)
	
	g_flIdleHideUntil[id] = get_gametime() + 1.5

	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_SOULREAPEREX)
	if(pev_valid(Ent))
	{
		cs_set_weapon_ammo(Ent, CLIP)

		if(get_user_weapon(id) == CSW_SOULREAPEREX)
			Ham_CWeapon_Deploy_Post(Ent)
	}

	cs_set_user_bpammo(id, CSW_SOULREAPEREX, BPAMMO)

	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), _, id)
	write_byte(1)
	write_byte(CSW_SOULREAPEREX)
	write_byte(CLIP)
	message_end()
}

CSOWPN_Remove(id)
{
	UnSet_BitVar(g_ActiveWpn, id)
	UnSet_BitVar(g_ActiveHelix, id)

	ResetPlayer(id)
}

public CSOWPN_Hook(id)
{
	engclient_cmd(id, WEAPON_REFERENCE)
	return PLUGIN_HANDLED
}

// Fill the helix charge (secondary ammo) and restart its timers
public Start_Charge(id)
{
	new Float:flTime = get_gametime()

	SetSecondaryAmmo(id, 10)
	g_NextCharge[id] = flTime + HELIX_REFILL_TIME
	g_NextConsume[id] = flTime + HELIX_CONSUME_TIME
}

public ResetMode(id)
{
	UnSet_BitVar(g_ActiveHelix, id)
	g_ShootCount[id] = 0
	g_Sphere[id] = 0
	isCombo[id] = false
}

ResetPlayer(id)
{
	ResetMode(id)
	remove_all_spheres(id)
	g_Clip[id] = 0
	g_Sphere[id] = 0
	g_ReClip[id] = -1
	g_Old_Weapon[id] = 0
	g_NextConsume[id] = 0.0
	g_NextCharge[id] = 0.0
	g_flIdleHideUntil[id] = 0.0
	Armor_Reset(id)
	g_ArmorUses[id] = 0
	g_ArmorCooldownEnd[id] = 0.0
	
	Gauge_Remove(id)
}

SetViewModel(id)
{
	if(Get_BitVar(g_ActiveHelix, id))
		set_pev(id, pev_viewmodel2, V_MDL_S)
	else
		set_pev(id, pev_viewmodel2, V_MDL)
}

/* =============================================================================  */
/* ========================== Soulreaperex_Fakemeta ============================  */
public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(WEAPON_EVENTS, name))
		g_weapon_event = get_orig_retval()
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED

	if(get_user_weapon(id) == CSW_SOULREAPEREX && Get_BitVar(g_ActiveWpn, id))
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
	if(get_user_weapon(invoker) != CSW_SOULREAPEREX)
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

	if(equal(model, OLD_MDL_REFERENCE))
	{
		static weapon; weapon = fm_find_ent_by_owner(-1, WEAPON_REFERENCE, entity)

		if(!pev_valid(weapon))
			return FMRES_IGNORED

		if(Get_BitVar(g_ActiveWpn, iOwner))
		{
			set_pev(weapon, pev_impulse, WEAPON_IMPULSE)
			engfunc(EngFunc_SetModel, entity, W_MDL)
			set_pev(entity, pev_body, REFERENCE_BODY_NUM)

			UnSet_BitVar(g_ActiveWpn, iOwner)
			UnSet_BitVar(g_ActiveHelix, iOwner)
			Armor_Reset(iOwner)

			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

// Attached sprites (draw / idle / bmode) are only meant for the owner's view model:
// hide them for everybody else, per client, without touching the entity itself
public fw_AddToFullPack_Post(es, e, ent, host, flags, player, pSet)
{
	if(player || !pev_valid(ent))
		return FMRES_IGNORED

	if(pev(ent, pev_impulse) != EF_FX_IMPULSE)
		return FMRES_IGNORED

	new id = pev(ent, pev_owner)

	// The owner
	if(host == id)
		return FMRES_IGNORED

	// A dead player watching the owner in first person sees the same view model
	if(is_user_connected(host) && !is_user_alive(host) && pev(host, pev_iuser1) == OBS_IN_EYE && pev(host, pev_iuser2) == id)
		return FMRES_IGNORED

	set_es(es, ES_RenderAmt, 0.0)
	set_es(es, ES_Effects, get_es(es, ES_Effects) | EF_NODRAW)

	return FMRES_IGNORED
}

public fw_Entity_Think(ent)
{
	if(!pev_valid(ent))
		return FMRES_IGNORED

	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))

	static iOwner; iOwner = pev(ent, pev_owner)
	
	if(equal(classname, EF_GAUGE_CLAS))
	{
		Entity_Think_EF_Gauge(ent)
		return FMRES_SUPERCEDE
	}

	if(equal(classname, EF_BACK_CLS))
	{
		Entity_Think_EF_Back(ent)
		return FMRES_IGNORED
	}

	if(equal(classname, HELIX_CLASSNAME))
	{
		Entity_Think_Helix(ent)
		return FMRES_IGNORED
	}

	if(equal(classname, SPHERE_CLASSNAME))
	{
		Entity_Think_Sphere_Projectile(ent)
		return FMRES_IGNORED
	}

	if(equal(classname, EF_DRAW_CLS))
	{
		Entity_Think_EF_Draw(ent)
		return FMRES_SUPERCEDE
	}

	if(equal(classname, EF_IDLE_CLS))
	{
		Entity_Think_EF_ACMode(ent)
		return FMRES_SUPERCEDE
	}

	if(equal(classname, EF_B_CLASSNAME))
	{
		Entity_Think_EF_BMode(ent)
		return FMRES_SUPERCEDE
	}

	if(equal(classname, MUZZLE_A_CLS))
	{
		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_SOULREAPEREX)
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
		if(Frame >= MUZZLEFLASH_MAX_FRAMES)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.0
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)

		return FMRES_IGNORED
	}

	if(equal(classname, MUZZLE_C_CLS))
	{
		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_SOULREAPEREX)
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
		if(Frame > 30.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.0
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)

		return FMRES_IGNORED
	}

	if(equal(classname, SHOOTA_CLASSNAME))
	{
		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_SOULREAPEREX)
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

		// Time based animation, so the speed does not depend on the think interval
		static Float:flTime, Float:flStart, Float:flFrame
		flTime = get_gametime()
		pev(ent, pev_fuser2, flStart)
		flFrame = (flTime - flStart) * AOE_ANIM_FPS

		if(flFrame > AOE_KILL_FRAME)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		set_pev(ent, pev_frame, flFrame)

		// Keep the sprite in front of the owner
		Aoe_UpdatePosition(ent, iOwner)

		// Damage tick (center is AOE_DISTANCE in front of the player, not where the sprite is drawn)
		static Float:flNextDamage
		pev(ent, pev_fuser1, flNextDamage)

		if(flTime >= flNextDamage)
		{
			new Float:pOrigin[3], Float:pAngles[3], Float:fForward[3], Float:newOrigin[3]
			pev(iOwner, pev_origin, pOrigin)

			// Use v_angle to include pitch (looking up/down)
			pev(iOwner, pev_v_angle, pAngles)
			angle_vector(pAngles, ANGLEVECTOR_FORWARD, fForward)

			newOrigin[0] = pOrigin[0] + (fForward[0] * AOE_DISTANCE)
			newOrigin[1] = pOrigin[1] + (fForward[1] * AOE_DISTANCE)
			newOrigin[2] = pOrigin[2] + (fForward[2] * AOE_DISTANCE) + AOE_OFFSET_Z

			Radius_Damage(iOwner, iOwner, newOrigin, AOE_RANGE, AOE_DAMAGE, DMG_BULLET | DMG_NEVERGIB)
			set_pev(ent, pev_fuser1, flTime + AOE_DAMAGE_INTERVAL)
		}

		set_pev(ent, pev_nextthink, flTime + 0.04)

		return FMRES_IGNORED
	}
	
	if(equal(classname, SHOOTB_CLASSNAME))
	{
		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_SOULREAPEREX)
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
		if(Frame > 22.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.5
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)

		return FMRES_IGNORED
	}
	
	if(equal(classname, EF_RELOAD_CLASSNAME))
	{
		if(!is_user_alive(iOwner) || get_user_weapon(iOwner) != CSW_SOULREAPEREX)
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
		if(Frame > 43.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		Frame += 1.5
		set_pev(ent, pev_frame, Frame)
		set_pev(ent, pev_nextthink, get_gametime() + 0.04)

		return FMRES_IGNORED
	}

	return FMRES_IGNORED
}

public fw_Entity_Touch(ent, other)
{
	if (!IsValidPev(ent))
		return FMRES_IGNORED

	static classname[32]
	pev(ent, pev_classname, classname, charsmax(classname))

	if(equal(classname, SPHERE_CLASSNAME))
	{
		Entity_Touch_SPHERE(ent, other)
	}

	return FMRES_IGNORED
}

/* =============================================================================  */
/* ========================== Soulreaperex_Hamsandwich ============================  */
public fw_TraceAttack_World(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_SOULREAPEREX || !Get_BitVar(g_ActiveWpn, Attacker))
		return HAM_IGNORED
	if(Get_BitVar(g_ActiveHelix, Attacker))
		return HAM_IGNORED

	static Float:flEnd[3]
	get_tr2(Ptr, TR_vecEndPos, flEnd)

	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, random_float(DAMAGEA, DAMAGEA * 2.0))

	return HAM_IGNORED
}

public fw_TraceAttack_Player(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_SOULREAPEREX || !Get_BitVar(g_ActiveWpn, Attacker))
		return HAM_IGNORED
	if(get_user_team(Victim) == get_user_team(Attacker))
		return HAM_IGNORED
	if(Get_BitVar(g_ActiveHelix, Attacker))
		return HAM_IGNORED

	// Every bullet that hits an enemy charges the Arcane Armor
	Armor_AddHit(Attacker)

	SetHamParamFloat(3, random_float(DAMAGEA, DAMAGEA * 2.0))

	return HAM_IGNORED
}

public Ham_CWeapon_Deploy_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id)) return

	// Restart helix timers so the time spent holstered is not counted
	new Float:flTime = get_gametime()
	g_NextConsume[id] = flTime + HELIX_CONSUME_TIME
	g_NextCharge[id] = flTime + HELIX_REFILL_TIME

	SetViewModel(id)
	set_pev(id, pev_weaponmodel2, P_MDL)

	util_sendweaponanim(id, ANIM_DRAW)
	
	g_flIdleHideUntil[id] = get_gametime() + 1.5

	// The idle effect lives as long as the weapon is held, so rebuild it on every deploy
	Idle_Remove(id)
	SoulReaperFX(id, 4, EF_IDLE_CLS, EF_IDLEA_SPR, 0.15)
	SoulReaperFX(id, 3, EF_DRAW_CLS, EF_DRAW_SPR, 0.15)
	
	do_EF_Gauge(id)

	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5, linux_diff_weapon)
}

public Ham_CWeapon_AddToPlayer_Post(ent, id)
{
	if(!pev_valid(ent) || !is_user_connected(id))
		return

	if(pev(ent, pev_impulse) == WEAPON_IMPULSE)
	{
		Set_BitVar(g_ActiveWpn, id)
		set_pev(ent, pev_impulse, 0)

		if(get_user_weapon(id) == CSW_SOULREAPEREX)
			Ham_CWeapon_Deploy_Post(ent)
	}

	if(Get_BitVar(g_ActiveWpn, id))
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
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id)) return

	g_ShootCount[id] = 0
	UTIL_SetHud(id, RESET_HUD)
	Gauge_Remove(id)
}

public Ham_CWeapon_PostFrame_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	if(get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon) && get_pdata_float(id, m_flNextAttack, linux_diff_player) <= 0.0)
	{
		new iClip = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
		new iBp = cs_get_user_bpammo(id, CSW_SOULREAPEREX)
		new j = min(CLIP - iClip, iBp)

		set_pdata_int(ent, m_Weapon_iClip, iClip + j, linux_diff_weapon)
		cs_set_user_bpammo(id, CSW_SOULREAPEREX, iBp - j)
		set_pdata_int(ent, m_Weapon_fInReload, 0, linux_diff_weapon)
	}

	// Helix charge: consume while active, refill while inactive
	CWeapon_HelixThink(id, ent)

	new ibutton = pev(id, pev_button)
	CWeapon_Soulreaperex(id, ent, ibutton)

	return HAM_IGNORED
}

public Ham_CWeapon_Idle_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	if(get_pdata_float(ent, m_Weapon_flTimeWeaponIdle, linux_diff_weapon) > 0.0)
		return HAM_SUPERCEDE

	util_sendweaponanim(id, Get_BitVar(g_ActiveHelix, id) ? ANIM_IDLEC : ANIM_IDLE)

	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 20.0, linux_diff_weapon)
	return HAM_SUPERCEDE
}

public Ham_CWeapon_Reload_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	g_ReClip[id] = -1

	if(cs_get_user_bpammo(id, CSW_SOULREAPEREX) <= 0)
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
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED
	if(g_ReClip[id] == -1)
		return HAM_IGNORED
	
	g_flIdleHideUntil[id] = get_gametime() + RELOAD_TIME

	set_pdata_int(ent, m_Weapon_iClip, g_ReClip[id], linux_diff_weapon)
	set_pdata_int(ent, m_Weapon_fInReload, 1, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, RELOAD_TIME + 0.5, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, RELOAD_TIME, linux_diff_player)
	if(g_ShootCount[id])
		g_ShootCount[id] = 0

	util_sendweaponanim(id, Get_BitVar(g_ActiveHelix, id) ? ANIM_RELOADC : ANIM_RELOADA)
	SoulReaperFX(id, 3, EF_RELOAD_CLASSNAME, EF_RELOAD_SPR, 0.15)

	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
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
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	if(g_Clip[id] <= get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon))
		return HAM_IGNORED

	new Float:Push[3]
	pev(id, pev_punchangle, Push)
	xs_vec_sub(Push, g_Recoil[id], Push)
	xs_vec_mul_scalar(Push, RECOIL, Push)
	xs_vec_add(Push, g_Recoil[id], Push)
	set_pev(id, pev_punchangle, Push)

	if(Get_BitVar(g_ActiveHelix, id))
	{
		util_sendweaponanim(id, ANIM_SHOOTC)
		Stock_Muzzle(id, MUZZLE_C_CLS, MUZZ_C_SPR, 0.16)
		emit_sound(id, CHAN_WEAPON, SND_SHOOTC, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		do_Helix(id)

		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, SPEED_C, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, SPEED_C, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, SPEED_C, linux_diff_weapon)
	}
	else
	{
		// Every 10 shots spawns one hovering sphere (up to SPHERE_MAX)
		if(g_sphereCount[id] < SPHERE_MAX)
		{
			g_ShootCount[id]++
			if(g_ShootCount[id] >= MAX_SHOOT_COUNT)
			{
				g_ShootCount[id] = 0
				do_Sphere_Ent(id)
				SoulReaperFX(id, 3, EF_B_CLASSNAME, EF_B_SPR, 0.15)
				do_EF_Back(id)
				
				emit_sound(id, CHAN_ITEM, SND_BALLS_APPEAR, 1.0, ATTN_NORM, 0, PITCH_NORM)
			}
		}

		util_sendweaponanim(id, ANIM_SHOOTA)
		Armor_AddHit(id)
		do_ShootAoe(id)
		Stock_Muzzle(id, MUZZLE_A_CLS, MUZZ_A_SPR, 0.15)
		emit_sound(id, CHAN_WEAPON, SND_SHOOTA, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

		new Float:flDelay = get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) * SPEED_A
		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, flDelay, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, flDelay, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, flDelay + 1.0, linux_diff_weapon)
	}

	return HAM_IGNORED
}

public fw_Spawn_Post(id)
{
	if(!is_user_connected(id))
		return

	CSOWPN_Remove(id)
}

public fw_Killed_Post(id)
{
	CSOWPN_Remove(id)
}


public fw_TakeDamage_Pre(victim, inflictor, attacker, Float:damage, damagebits)
{
	if(!(1 <= victim <= g_MaxPlayers))
		return HAM_IGNORED

	if(!Get_BitVar(g_ActiveWpn, victim))
		return HAM_IGNORED

	if(Get_BitVar(g_ArmorActive, victim) && damagebits & DMG_FALL)
		return HAM_SUPERCEDE

	// Arcane Armor only reacts while it is active
	if(!Get_BitVar(g_ArmorActive, victim))
		return HAM_IGNORED

	new Float:flHealth
	pev(victim, pev_health, flHealth)

	if(flHealth <= 0.0)
		return HAM_IGNORED

	// Only intervene when this hit would bring HP down to 0 or below
	if(flHealth - damage > 0.0)
		return HAM_IGNORED

	// Block the lethal hit and release the armor blast
	Armor_Trigger(victim)
	return HAM_SUPERCEDE
}

/* ========================== Soulreaperex_WpnSys ============================  */
CWeapon_Soulreaperex(id, ent, button)
{
	if(!IsValidPev(ent)) return
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id)) return

	// Weapon is not ready yet (deploy / reload animation)
	if(get_pdata_float(id, m_flNextAttack, linux_diff_player) > 0.0) return

	// Combo: IN_ATTACK + IN_ATTACK2 activates helix mode
	if((button & IN_ATTACK) && (button & IN_ATTACK2) && !Get_BitVar(g_ActiveHelix, id))
	{
		if(!get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon))
		{
			if(get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) <= 0.0)
			{
				if(GetSecondaryAmmo(id) >= HELIX_MIN_CHARGE)
				{
					// Remove both buttons: no bullet is fired and the silencer is not toggled
					set_pev(id, pev_button, button & ~(IN_ATTACK | IN_ATTACK2))

					CWeapon_StartHelix(id, ent)
					return
				}
			}
		}
		// Not ready for helix: fall through and behave like a normal IN_ATTACK2
	}

	if(button & IN_ATTACK2)
	{
		set_pev(id, pev_button, button & ~IN_ATTACK2)

		if(get_pdata_int(ent, m_Weapon_fInReload, linux_diff_weapon)) return
		if(get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) > 0.0) return

		// Launch one hovering sphere at its locked enemy (returns 0 if nothing to launch)
		if(!launch_sphere(id)) return
		if (!g_sphereCount[id]) return
		
		SoulReaperFX(id, 2, SHOOTB_CLASSNAME, EF_SHOOTB_SPR, 0.1)

		util_sendweaponanim(id, Get_BitVar(g_ActiveHelix, id) ? ANIM_SHOOTC : ANIM_SHOOTBA)
		emit_sound(id, CHAN_WEAPON, SND_SHOOTB, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

		set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, SPEED_B, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, SPEED_B, linux_diff_weapon)
		set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, SPEED_B + 0.5, linux_diff_weapon)
	}
}

// Switch to helix mode and start consuming the charge
CWeapon_StartHelix(id, ent)
{
	Set_BitVar(g_ActiveHelix, id)
	g_ShootCount[id] = 0

	// The first consume tick happens HELIX_CONSUME_TIME after activation
	g_NextConsume[id] = get_gametime() + HELIX_CONSUME_TIME

	SetViewModel(id)
	do_Helix(id)
	util_sendweaponanim(id, ANIM_SHOOTC)
	emit_sound(id, CHAN_WEAPON, SND_SHOOTC, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	Stock_Muzzle(id, MUZZLE_C_CLS, MUZZ_C_SPR, 0.16)

	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, 1.5, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, 1.5, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5 + 0.5, linux_diff_weapon)
}

// Called every frame from PostFrame_Pre.
// Helix active   : consume charge every HELIX_CONSUME_TIME, leave helix mode when it reaches 0.
// Helix inactive : refill charge every HELIX_REFILL_TIME until HELIX_MAX_CHARGE.
CWeapon_HelixThink(id, ent)
{
	new Float:flTime = get_gametime()
	new iCharge = GetSecondaryAmmo(id)

	if(Get_BitVar(g_ActiveHelix, id))
	{
		if(flTime >= g_NextConsume[id])
		{
			iCharge = max(iCharge - HELIX_CONSUME_AMOUNT, 0)
			SetSecondaryAmmo(id, iCharge)

			g_NextConsume[id] = flTime + HELIX_CONSUME_TIME
		}

		if(iCharge <= 0)
		{
			UnSet_BitVar(g_ActiveHelix, id)
			g_ShootCount[id] = 0

			SetViewModel(id)
			util_sendweaponanim(id, ANIM_CHANGECA)
			set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, 1.5, linux_diff_weapon)

			// Start refilling after the full refill delay
			g_NextCharge[id] = flTime + HELIX_REFILL_TIME
		}
	}
	else if(iCharge < HELIX_MAX_CHARGE)
	{
		if(flTime >= g_NextCharge[id])
		{
			SetSecondaryAmmo(id, min(iCharge + HELIX_REFILL_AMOUNT, HELIX_MAX_CHARGE))

			g_NextCharge[id] = flTime + HELIX_REFILL_TIME
		}
	}
}

/* =============================================================================  */

/* ========================== Soulreaperex_ArcaneArmor ============================  */
// Count one bullet hit; activates the armor when enough hits were landed
Armor_AddHit(id)
{
	if(Get_BitVar(g_ArmorActive, id))
		return

	// Re-activation is locked while the cooldown is running
	if(get_gametime() < g_ArmorCooldownEnd[id])
		return

	g_ArmorHits[id]++

	if(g_ArmorHits[id] >= ARMOR_HITS_TO_ACTIVATE)
		Armor_Activate(id)
}

Armor_Activate(id)
{
	Set_BitVar(g_ArmorActive, id)
	g_ArmorHits[id] = 0

	// Glow while the armor is ready
	fm_set_rendering(id, kRenderFxGlowShell, ARMOR_GLOW_R, ARMOR_GLOW_G, ARMOR_GLOW_B, kRenderNormal, 16)
}

// Clears the armor state and glow (the per-round counters are handled by the callers)
Armor_Reset(id)
{
	if(Get_BitVar(g_ArmorActive, id) && is_user_connected(id))
		fm_set_rendering(id)

	UnSet_BitVar(g_ArmorActive, id)
	g_ArmorHits[id] = 0
}

// A lethal hit was blocked: damage and knock back nearby enemies, then heal per enemy hit
Armor_Trigger(id)
{
	new Float:flTime = get_gametime()

	Armor_Reset(id)

	// First use in a round has no lock; from the second use on, re-activation is locked
	g_ArmorUses[id]++
	if(g_ArmorUses[id] >= 2)
		g_ArmorCooldownEnd[id] = flTime + ARMOR_COOLDOWN

	new Float:vOrigin[3]
	pev(id, pev_origin, vOrigin)

	new iHit = 0

	for(new p = 1; p <= g_MaxPlayers; p++)
	{
		if(!sphere_is_enemy(id, p))
			continue

		new Float:vTarget[3]
		pev(p, pev_origin, vTarget)

		if(get_distance_f(vOrigin, vTarget) > ARMOR_RADIUS)
			continue

		// Horizontal push away from the owner
		new Float:vDir[3]
		xs_vec_sub(vTarget, vOrigin, vDir)
		vDir[2] = 0.0

		if(vector_length(vDir) < 1.0)
			vDir[0] = 1.0

		xs_vec_normalize(vDir, vDir)

		new Float:vVel[3]
		vVel[0] = vDir[0] * ARMOR_KNOCKBACK
		vVel[1] = vDir[1] * ARMOR_KNOCKBACK
		vVel[2] = ARMOR_KNOCKUP

		Radius_Damage(id, id, vOrigin, ARMOR_RADIUS, ARMOR_DAMAGE, DMG_BULLET | DMG_NEVERGIB)

		// The victim may have died from the blast; only push the living
		if(is_user_alive(p))
			set_pev(p, pev_velocity, vVel)

		iHit++
	}

	Create_Explosion(vOrigin)

	if(iHit > 0)
	{
		new Float:flHeal = floatmin(float(iHit) * ARMOR_HEAL_PER_ENEMY, ARMOR_HEAL_MAX)
		new Float:flHealth
		pev(id, pev_health, flHealth)

		set_pev(id, pev_health, floatmin(flHealth + flHeal, ARMOR_MAX_HEALTH))
	}
}

/* =============================================================================  */
/* ========================== Soulreaperex_Entities ============================  */
do_EF_Back(id)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent)) return

	set_pev(ent, pev_classname, EF_BACK_CLS)
	engfunc(EngFunc_SetModel, ent, SPHERE_SPR2)

	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)

	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_framerate, 5.0)
	set_pev(ent, pev_scale, EF_BACK_SCALE)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)

	EF_Back_UpdatePosition(ent, id)

	set_pev(ent, pev_nextthink, get_gametime() + EF_BACK_NEXTTHINK)
}

// Keep the effect behind the owner
EF_Back_UpdatePosition(ent, id)
{
	new Float:pOrigin[3], Float:pAngles[3], Float:pVel[3]
	pev(id, pev_origin, pOrigin)
	pev(id, pev_v_angle, pAngles)
	pev(id, pev_velocity, pVel)

	// Convert degrees to radians (floatcos/floatsin expect radians)
	new Float:flYaw = pAngles[1] * (M_PI / 180.0)

	new Float:fDistance = 30.0	// distance behind the player
	new Float:fHeight = 8.0		// extra height

	// Facing is (cos(yaw), sin(yaw)), so behind the player is (-cos(yaw), -sin(yaw))
	pOrigin[0] -= floatcos(flYaw) * fDistance
	pOrigin[1] -= floatsin(flYaw) * fDistance
	pOrigin[2] += fHeight

	set_pev(ent, pev_velocity, pVel)
	set_pev(ent, pev_angles, pAngles)
	engfunc(EngFunc_SetOrigin, ent, pOrigin)
}

public Entity_Think_EF_Back(ent)
{
	if(!IsValidPev(ent)) return FMRES_IGNORED

	new id = pev(ent, pev_owner)

	if(!is_user_alive(id))
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return FMRES_IGNORED
	}

	new Float:fFrame
	pev(ent, pev_frame, fFrame)

	if(fFrame >= EF_BACK_FRAMEMAX)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return FMRES_IGNORED
	}

	EF_Back_UpdatePosition(ent, id)

	fFrame += EF_BACK_FRAME
	set_pev(ent, pev_frame, fFrame)

	set_pev(ent, pev_nextthink, get_gametime() + EF_BACK_NEXTTHINK)

	return FMRES_IGNORED
}

do_ShootAoe(id)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent)) return

	set_pev(ent, pev_classname, SHOOTA_CLASSNAME)
	engfunc(EngFunc_SetModel, ent, AOE_SPR)

	// Positioned by Aoe_UpdatePosition() on every think, no aim entity needed
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)

	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_scale, 1.5)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)

	// fuser1 = next damage tick, fuser2 = spawn time
	set_pev(ent, pev_fuser1, get_gametime())
	set_pev(ent, pev_fuser2, get_gametime())

	// Place it right away so it never shows up at the map origin for one frame
	Aoe_UpdatePosition(ent, id)

	set_pev(ent, pev_nextthink, get_gametime() + 0.04)
}

// Put the AOE sprite in front of its owner and turn it with the owner's view
Aoe_UpdatePosition(ent, id)
{
	new Float:vOrigin[3], Float:vAngle[3], Float:vVel[3]
	new Float:vFwd[3], Float:vPos[3], Float:vSpriteAngles[3]

	pev(id, pev_origin, vOrigin)
	pev(id, pev_v_angle, vAngle)
	pev(id, pev_velocity, vVel)

	angle_vector(vAngle, ANGLEVECTOR_FORWARD, vFwd)

	vPos[0] = vOrigin[0] + vFwd[0] * AOE_VISUAL_DISTANCE
	vPos[1] = vOrigin[1] + vFwd[1] * AOE_VISUAL_DISTANCE
	vPos[2] = vOrigin[2] + vFwd[2] * AOE_VISUAL_DISTANCE + AOE_VISUAL_OFFSET_Z

	vSpriteAngles[0] = 90.0 + vAngle[0]
	vSpriteAngles[1] = vAngle[1]
	vSpriteAngles[2] = -45.0

	engfunc(EngFunc_SetOrigin, ent, vPos)
	set_pev(ent, pev_angles, vSpriteAngles)

	// Same velocity as the owner: the client extrapolates between two think ticks
	set_pev(ent, pev_velocity, vVel)
}

// Spawn one hovering sphere around the player
public do_Sphere_Ent(id)
{
	if (!is_user_alive(id)) return
	if (g_sphereCount[id] >= SPHERE_MAX) return

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if (!pev_valid(ent)) return

	new Float:vOrigin[3]
	pev(id, pev_origin, vOrigin)

	engfunc(EngFunc_SetModel, ent, SPHERE_SPR)
	engfunc(EngFunc_SetOrigin, ent, vOrigin)

	set_pev(ent, pev_classname, SPHERE_CLASSNAME)
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_fuser1, get_gametime() + 1.0)	// fade in starts after this time
	set_pev(ent, pev_scale, SPHERE_SCALE)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 1.0)

	new slot = g_sphereCount[id]
	g_sphereEnt[id][slot] = ent
	g_sphereTarget[id][slot] = 0
	g_sphereLaunched[id][slot] = 0
	g_sphereLaunchTime[id][slot] = 0.0
	g_orbitAngle[id][slot] = (360.0 / float(SPHERE_MAX)) * float(slot)

	g_sphereCount[id]++

	set_pev(ent, pev_nextthink, get_gametime() + 0.01)
}

public Entity_Think_Sphere_Projectile(ent)
{
	if (!pev_valid(ent)) return FMRES_IGNORED

	new id = pev(ent, pev_owner)
	if (!is_user_alive(id))
	{
		engfunc(EngFunc_RemoveEntity, ent)
		return FMRES_HANDLED
	}

	// Find its slot in the array
	new slot = -1
	for (new i = 0; i < SPHERE_MAX; i++)
	{
		if (g_sphereEnt[id][i] == ent)
		{
			slot = i
			break
		}
	}

	// Orphan sphere (not tracked anymore) -> remove it
	if (slot == -1)
	{
		engfunc(EngFunc_RemoveEntity, ent)
		return FMRES_HANDLED
	}

	// Fade the sphere in after its start delay (clamped: a byte render amount above 255 wraps around)
	new Float:flFadeStart; pev(ent, pev_fuser1, flFadeStart)
	if (get_gametime() >= flFadeStart)
	{
		new Float:flRenderAmt
		pev(ent, pev_renderamt, flRenderAmt)

		if (flRenderAmt < 255.0)
			set_pev(ent, pev_renderamt, floatmin(flRenderAmt + 30.0, 255.0))
	}

	// Simple sprite animation
	new Float:fFrame
	pev(ent, pev_frame, fFrame)
	fFrame += 0.8
	if (fFrame > 43.0) fFrame = 0.0
	set_pev(ent, pev_frame, fFrame)

	if (g_sphereLaunched[id][slot])
		update_missile(ent, id, slot)
	else
		update_orbit(ent, id, slot)

	// update_missile() may have removed this entity
	if (pev_valid(ent))
		set_pev(ent, pev_nextthink, get_gametime() + SPHERE_THINK_RATE)

	return FMRES_HANDLED
}

// DEFAULT (no ATTACK2) = AUTO TRACKING:
// chase an enemy inside SPHERE_DETECT_RADIUS and hit it, otherwise orbit behind the player.
update_orbit(ent, id, slot)
{
	new Float:origin[3]
	pev(id, pev_origin, origin)

	// Drop the lock if the target died or walked out of range
	new target = g_sphereTarget[id][slot]
	if (target > 0)
	{
		new bool:bDrop = !is_user_alive(target)
		if (!bDrop)
		{
			new Float:tpos[3]
			pev(target, pev_origin, tpos)
			if (get_distance_f(origin, tpos) > SPHERE_DETECT_RADIUS)
				bDrop = true
		}

		if (bDrop)
		{
			target = 0
			g_sphereTarget[id][slot] = 0
		}
	}

	// Look for a new enemy not locked by another sphere
	if (target <= 0)
	{
		target = find_free_target(id)
		g_sphereTarget[id][slot] = target
	}

	// Enemy found -> auto track
	if (target > 0)
	{
		sphere_chase(ent, id, slot, target, SPHERE_TRACK_SPEED)

		return
	}

	// No enemy -> orbit on a VERTICAL ring behind the player's back,
	// clockwise when seen from behind the player.
	set_pev(ent, pev_velocity, Float:{ 0.0, 0.0, 0.0 })

	// Time based angle, so the gap between spheres stays constant even when a sphere
	// is chasing / removed. Each slot trails the previous one by SPHERE_ORBIT_GAP degrees.
	new Float:flAngle = get_gametime() * SPHERE_ORBIT_SPEED
	flAngle -= 360.0 * float(floatround(flAngle / 360.0, floatround_floor))
	flAngle -= SPHERE_ORBIT_GAP * float(slot)

	new Float:radAngle = flAngle * M_PI / 180.0

	// Yaw only, so the ring stays behind the player and does not tilt with the pitch
	new Float:angles[3]
	pev(id, pev_v_angle, angles)
	angles[0] = 0.0

	new Float:fwd[3], Float:right[3]
	angle_vector(angles, ANGLEVECTOR_FORWARD, fwd)
	angle_vector(angles, ANGLEVECTOR_RIGHT, right)

	// Ring plane = (right, up). a = 0 is the top of the ring.
	// right * sin(a) + up * cos(a)  ->  clockwise seen from behind. Use -sin for counter-clockwise.
	new Float:flSide = SPHERE_HOVER_RADIUS * floatsin(radAngle)
	new Float:flUp = SPHERE_HOVER_RADIUS * floatcos(radAngle)

	new Float:newpos[3]
	newpos[0] = origin[0] - fwd[0] * SPHERE_BACK_DIST + right[0] * flSide
	newpos[1] = origin[1] - fwd[1] * SPHERE_BACK_DIST + right[1] * flSide
	newpos[2] = origin[2] + SPHERE_HOVER_HEIGHT + flUp

	engfunc(EngFunc_SetOrigin, ent, newpos)
}

// ATTACK2 = launched sphere: flies straight along the aim direction right away,
// and switches to chasing an enemy as soon as one comes into range.
update_missile(ent, id, slot)
{
	// Expire after SPHERE_LIFETIME
	if (get_gametime() >= g_sphereLaunchTime[id][slot] + SPHERE_LIFETIME)
	{
		emit_sound(ent, CHAN_ITEM, SND_SHOOTB_EXP, 1.0, ATTN_NORM, 0, PITCH_NORM)
		remove_sphere(id, slot)
		return
	}

	new target = g_sphereTarget[id][slot]
	if (target > 0 && !is_user_alive(target))
	{
		target = 0
		g_sphereTarget[id][slot] = 0
	}

	// No lock yet -> pick up an enemy that comes in range while flying
	if (target <= 0)
	{
		target = find_free_target(id)
		g_sphereTarget[id][slot] = target
	}

	// Enemy in range -> chase at full speed
	if (target > 0)
	{
		sphere_chase(ent, id, slot, target, SPHERE_MISSILE_SPEED)
		return
	}

	// No enemy in range -> keep flying straight (velocity was set on launch)
	new Float:pos[3], Float:vel[3], Float:vEnd[3]
	pev(ent, pev_origin, pos)
	pev(ent, pev_velocity, vel)

	// Hit any enemy touching the sphere
	for (new p = 1; p <= g_MaxPlayers; p++)
	{
		if (!sphere_is_enemy(id, p))
			continue

		new Float:ppos[3]
		pev(p, pev_origin, ppos)
		if (get_distance_f(pos, ppos) < 40.0)
		{
			sphere_hit(ent, id, slot, p)
			return
		}
	}

	// Explode on walls
	vEnd[0] = pos[0] + vel[0] * SPHERE_THINK_RATE * 2.0
	vEnd[1] = pos[1] + vel[1] * SPHERE_THINK_RATE * 2.0
	vEnd[2] = pos[2] + vel[2] * SPHERE_THINK_RATE * 2.0

	new tr = create_tr2()
	new Float:flFraction
	engfunc(EngFunc_TraceLine, pos, vEnd, IGNORE_MONSTERS, ent, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	free_tr2(tr)

	if (flFraction < 1.0)
	{
		emit_sound(ent, CHAN_ITEM, SND_SHOOTB_EXP, 1.0, ATTN_NORM, 0, PITCH_NORM)
		new Float:eOrigin[3]
		pev(ent, pev_origin, eOrigin)

		Create_Explosion(eOrigin)
		do_Sphere_Damage(id, eOrigin, SPHERE_RADIUS, DAMAGE_EXP)
		remove_sphere(id, slot)
	}
}

// Deal damage to the target, play the explosion sound and remove the sphere
sphere_hit(ent, id, slot, target)
{
	new Float:eOrigin[3]
	pev(ent, pev_origin, eOrigin)

	Create_Explosion(eOrigin)

	do_Sphere_Damage(id, eOrigin, SPHERE_RADIUS, DAMAGE_EXP)

	emit_sound(ent, CHAN_ITEM, SND_SHOOTB_EXP, 1.0, ATTN_NORM, 0, PITCH_NORM)
	remove_sphere(id, slot)
}

// Move towards the target and hit it on proximity
sphere_chase(ent, id, slot, target, Float:speed)
{
	new Float:tpos[3], Float:pos[3]
	pev(target, pev_origin, tpos)
	hook_ent(ent, tpos, speed)

	pev(ent, pev_origin, pos)
	if (get_distance_f(pos, tpos) < 40.0)
		sphere_hit(ent, id, slot, target)
}

// 1 if p is a living enemy of id (respects mp_friendlyfire)
sphere_is_enemy(id, p)
{
	if (p == id || !is_user_alive(p))
		return 0

	if (get_user_team(p) == get_user_team(id))
	{
		if (!g_pcvFriendlyFire || !get_pcvar_num(g_pcvFriendlyFire))
			return 0
	}

	return 1
}

// ATTACK2: launch the first sphere that has not been launched yet.
// It leaves the muzzle immediately along the aim direction, no enemy detection needed.
// Returns 1 on success, 0 if there is no sphere to launch.
launch_sphere(id)
{
	for (new s = 0; s < g_sphereCount[id]; s++)
	{
		new ent = g_sphereEnt[id][s]
		if (g_sphereLaunched[id][s] || !pev_valid(ent))
			continue

		new Float:vecOrigin[3], Float:vecDir[3], Float:vecVel[3]
		UTIL_GetEyePosition(id, vecOrigin)
		UTIL_GetVectorAiming(id, vecDir)

		// start slightly in front of the eyes
		xs_vec_add_scaled(vecOrigin, vecDir, 15.0, vecOrigin)
		engfunc(EngFunc_SetOrigin, ent, vecOrigin)

		xs_vec_mul_scalar(vecDir, SPHERE_MISSILE_SPEED, vecVel)
		set_pev(ent, pev_velocity, vecVel)

		g_sphereLaunched[id][s] = 1
		g_sphereLaunchTime[id][s] = get_gametime()

		return 1
	}

	return 0
}

// Find a target not already locked by another sphere
find_free_target(id)
{
	new players[32], num
	get_players(players, num, "a")

	new Float:origin[3]
	pev(id, pev_origin, origin)

	new bool:friendlyFire = false
	if (g_pcvFriendlyFire)
		friendlyFire = (get_pcvar_num(g_pcvFriendlyFire) != 0)

	new id_team = get_user_team(id)

	for (new i = 0; i < num; i++)
	{
		new p = players[i]

		// 1. Skip self
		if (p == id) continue

		// 2. Skip teammates (only when friendly fire is OFF)
		if (!friendlyFire && get_user_team(p) == id_team) continue

		// 3. Check distance
		new Float:pos[3]
		pev(p, pev_origin, pos)
		if (get_distance_f(origin, pos) > SPHERE_DETECT_RADIUS) continue

		// 4. Skip if already locked by another sphere of this player
		new bool:taken = false
		for (new s = 0; s < SPHERE_MAX; s++)
		{
			if (g_sphereTarget[id][s] == p)
			{
				taken = true
				break
			}
		}
		if (taken) continue

		return p
	}

	return 0
}

Entity_Touch_SPHERE(ent, other)
{
	if (!IsValidPev(ent))
		return

	if (other == pev(ent, pev_owner))
		return

	emit_sound(ent, CHAN_ITEM, SND_SHOOTB_EXP, 1.0, ATTN_NORM, 0, PITCH_NORM)

	Entity_Remove(ent)
}

Entity_Remove(ent)
{
	if (!IsValidPev(ent))
		return

	new Float:eOrigin[3]
	pev(ent, pev_origin, eOrigin)

	Create_Explosion(eOrigin)

	engfunc(EngFunc_RemoveEntity, ent)
}

remove_sphere(id, slot)
{
	new ent = g_sphereEnt[id][slot]
	if (ent > 0 && pev_valid(ent))
		engfunc(EngFunc_RemoveEntity, ent)

	g_sphereEnt[id][slot] = 0
	g_sphereTarget[id][slot] = 0
	g_sphereLaunched[id][slot] = 0

	// Compact the array: shift remaining spheres down so the orbit looks right
	for (new i = slot; i < SPHERE_MAX - 1; i++)
	{
		g_sphereEnt[id][i]      = g_sphereEnt[id][i + 1]
		g_sphereTarget[id][i]   = g_sphereTarget[id][i + 1]
		g_sphereLaunched[id][i] = g_sphereLaunched[id][i + 1]
		g_orbitAngle[id][i]     = g_orbitAngle[id][i + 1]
		g_sphereLaunchTime[id][i] = g_sphereLaunchTime[id][i + 1]
	}
	g_sphereEnt[id][SPHERE_MAX - 1] = 0
	g_sphereTarget[id][SPHERE_MAX - 1] = 0
	g_sphereLaunched[id][SPHERE_MAX - 1] = 0
	g_sphereLaunchTime[id][SPHERE_MAX - 1] = 0.0

	if (g_sphereCount[id] > 0) g_sphereCount[id]--
}

remove_all_spheres(id)
{
	// remove_sphere() shifts the array, so always remove slot 0 until empty
	while (g_sphereCount[id] > 0)
		remove_sphere(id, 0)
}

do_Sphere_Damage(id, Float:vecOrigin[3], Float:Rad, Float:Dmg)
{
	if(!IsValidPev(id)) return

	Radius_Damage(id, id, vecOrigin, Rad, Dmg, DMG_BULLET | DMG_NEVERGIB)
}

public do_Helix(id) {
	if (!CanCreateEntity()) return
	new Float:vOrigin[3], Float:vAngle[3], Float:vForward[3]
	pev(id, pev_origin, vOrigin);
	pev(id, pev_v_angle, vAngle)
	engfunc(EngFunc_MakeVectors, vAngle); global_get(glb_v_forward, vForward)

	new Float:vSpawnOrigin[3]
	vSpawnOrigin[0] = vOrigin[0];
	vSpawnOrigin[1] = vOrigin[1]; vSpawnOrigin[2] = vOrigin[2] + 15.0

	new Float:vBeamAngles[3]
	vBeamAngles[0] = -vAngle[0];
	vBeamAngles[1] = vAngle[1]; vBeamAngles[2] = vAngle[2]

	new Float:vTarget[3], Float:vEnd[3]
	vEnd[0] = vOrigin[0] + vForward[0] * HELIX_BEAM_LENGTH
	vEnd[1] = vOrigin[1] + vForward[1] * HELIX_BEAM_LENGTH
	vEnd[2] = vOrigin[2] + vForward[2] * HELIX_BEAM_LENGTH

	for (new i = 0; i < 2; i++) {
		new helixA = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
		if (pev_valid(helixA)) {
			engfunc(EngFunc_SetModel, helixA, HELIX_MDL2)
			set_pev(helixA, pev_classname, HELIX_CLASSNAME)
			set_pev(helixA, pev_spawnflags, SF_SPRITE_ONCE)
			dllfunc(DLLFunc_Spawn, helixA)
			set_pev(helixA, pev_solid, SOLID_NOT)
			set_pev(helixA, pev_movetype, MOVETYPE_NONE)

			new Float:flOffset = 60.0 + (float(i) * 250.0), Float:vPos[3]
			vPos[0] = vSpawnOrigin[0] + vForward[0] * flOffset
			vPos[1] = vSpawnOrigin[1] + vForward[1] * flOffset
			vPos[2] = vSpawnOrigin[2] + vForward[2] * flOffset
			engfunc(EngFunc_SetOrigin, helixA, vPos)

			Radius_Damage(id, id, vPos, HELIX_BEAM_RADIUS, HELIX_DAMAGE, DMG_BULLET | DMG_NEVERGIB)
			OnHelixEffect(id, helixA, HELIX_RANGE, HELIX_BEAM_PULL)

			set_pev(helixA, pev_angles, vBeamAngles)
			set_pev(helixA, pev_rendermode, kRenderTransAdd)
			set_pev(helixA, pev_renderamt, 255.0)
			set_pev(helixA, pev_skin, 0); set_pev(helixA, pev_iuser1, 0); set_pev(helixA, pev_iuser2, 1)
			set_pev(helixA, pev_owner, id)
			set_pev(helixA, pev_nextthink, get_gametime() + (1.0 / HELIX_ANIM_FRAMERATE))
		}
	}

	new helixB = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if (pev_valid(helixB)) {
		engfunc(EngFunc_SetModel, helixB, HELIX_MDL1)
		set_pev(helixB, pev_classname, HELIX_CLASSNAME)
		set_pev(helixB, pev_spawnflags, SF_SPRITE_ONCE)
		dllfunc(DLLFunc_Spawn, helixB)
		set_pev(helixB, pev_solid, SOLID_NOT);
		set_pev(helixB, pev_movetype, MOVETYPE_NONE)

		new Float:flOffset = 60.0 + (2.0 * 250.0), Float:vPos[3]
		vPos[0] = vSpawnOrigin[0] + vForward[0] * flOffset
		vPos[1] = vSpawnOrigin[1] + vForward[1] * flOffset
		vPos[2] = vSpawnOrigin[2] + vForward[2] * flOffset
		engfunc(EngFunc_SetOrigin, helixB, vPos)

		Radius_Damage(id, id, vPos, HELIX_BEAM_RADIUS, HELIX_DAMAGE, DMG_BULLET | DMG_NEVERGIB)
		OnHelixEffect(id, helixB, HELIX_RANGE, HELIX_BEAM_PULL)

		set_pev(helixB, pev_angles, vBeamAngles)
		set_pev(helixB, pev_rendermode, kRenderTransAdd);
		set_pev(helixB, pev_renderamt, 255.0)
		set_pev(helixB, pev_skin, 0); set_pev(helixB, pev_iuser1, 0);
		set_pev(helixB, pev_iuser2, 2)
		set_pev(helixB, pev_owner, id)
		set_pev(helixB, pev_nextthink, get_gametime() + (1.0 / HELIX_ANIM_FRAMERATE))
	}

	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, vSpawnOrigin, 0)
	write_byte(0)
	engfunc(EngFunc_WriteCoord, vSpawnOrigin[0]);
	engfunc(EngFunc_WriteCoord, vSpawnOrigin[1]); engfunc(EngFunc_WriteCoord, vSpawnOrigin[2])
	engfunc(EngFunc_WriteCoord, vEnd[0]); engfunc(EngFunc_WriteCoord, vEnd[1]);
	engfunc(EngFunc_WriteCoord, vEnd[2])
	write_short(g_iSpriteLaser)
	write_byte(0); write_byte(30); write_byte(10); write_byte(180)
	write_byte(0); write_byte(255); write_byte(255);
	write_byte(255)
	write_byte(255); write_byte(20)
	message_end()

	for (new i = 1; i <= 32; i++) {
		if (!sphere_is_enemy(id, i)) continue
		pev(i, pev_origin, vTarget)

		new Float:vDirToTarget[3]
		vDirToTarget[0] = vTarget[0] - vOrigin[0]
		vDirToTarget[1] = vTarget[1] - vOrigin[1]
		vDirToTarget[2] = vTarget[2] - vOrigin[2]

		new Float:flDistanceAlongBeam = xs_vec_dot(vDirToTarget, vForward)

		if (flDistanceAlongBeam > 0.0 && flDistanceAlongBeam < HELIX_BEAM_LENGTH) {
			new Float:vProj[3]
			vProj[0] = vOrigin[0] + vForward[0] * flDistanceAlongBeam
			vProj[1] = vOrigin[1] + vForward[1] * flDistanceAlongBeam
			vProj[2] = vOrigin[2] + vForward[2] * flDistanceAlongBeam

			new Float:flDistToBeam = get_distance_f(vTarget, vProj)

			if (flDistToBeam <= HELIX_BEAM_RADIUS) {
				ExecuteHamB(Ham_TakeDamage, i, id, id, HELIX_BEAM_DAMAGE, DMG_ENERGYBEAM)
				new Float:vPull[3]
				vPull[0] = vProj[0] - vTarget[0];
				vPull[1] = vProj[1] - vTarget[1]; vPull[2] = vProj[2] - vTarget[2]
				vPull[0] -= vForward[0] * 0.5 * flDistToBeam;
				vPull[1] -= vForward[1] * 0.5 * flDistToBeam
				xs_vec_normalize(vPull, vPull)

				new Float:flPullStrength = HELIX_BEAM_PULL * (1.0 - (flDistToBeam / HELIX_BEAM_RADIUS))
				new Float:vVel[3];
				pev(i, pev_velocity, vVel)
				vVel[0] = vVel[0] * 0.2 + vPull[0] * flPullStrength
				vVel[1] = vVel[1] * 0.2 + vPull[1] * flPullStrength
				vVel[2] = vVel[2] * 0.2 + vPull[2] * flPullStrength * 0.2
				set_pev(i, pev_velocity, vVel)
			}
		}
	}
}

public Entity_Think_Helix(ent) {
	if (!pev_valid(ent)) return
	new id = pev(ent, pev_owner)
	if (id < 1 || id > 32 || !is_user_alive(id)) { engfunc(EngFunc_RemoveEntity, ent); return; }

	new iSkin = pev(ent, pev_iuser1)
	if (iSkin >= 14) { engfunc(EngFunc_RemoveEntity, ent); return; }

	set_pev(ent, pev_skin, iSkin); set_pev(ent, pev_iuser1, iSkin + 1)
	set_pev(ent, pev_nextthink, get_gametime() + (1.0 / HELIX_ANIM_FRAMERATE))
}

// cl_righthand is a client cvar, so the server has to ask for it
Query_RightHand(id)
{
	if(is_user_connected(id) && !is_user_bot(id))
		query_client_cvar(id, "cl_righthand", "Cvar_RightHand_Result")
}

public Cvar_RightHand_Result(id, const cvar[], const value[])
{
	if(!is_user_connected(id))
		return

	// cl_righthand 0 = left-handed view model
	if(str_to_num(value) == 0)
		Set_BitVar(g_LeftHand, id)
	else
		UnSet_BitVar(g_LeftHand, id)
}

// Sprite attached to a view model attachment:
// aiment/skin = owner, body = attachment index + 1. Animated by its own think function (time based).
public SoulReaperFX(id, attachment, const szClassname[], const szMdl[], Float:fScale)
{
	if(!CanCreateEntity()) return

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(!pev_valid(ent)) return

	// Entity data
	set_pev(ent, pev_classname, szClassname)
	set_pev(ent, pev_impulse, EF_FX_IMPULSE)
	engfunc(EngFunc_SetModel, ent, szMdl)

	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_movetype, MOVETYPE_NONE)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_gravity, 0.0)
	set_pev(ent, pev_aiment, id)
	set_pev(ent, pev_body, attachment)
	set_pev(ent, pev_skin, id)

	// Render
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)
	set_pev(ent, pev_scale, fScale)

	// Frames: no SF_SPRITE_ONCE, the sprite's own animation would turn it off at its last frame
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_framerate, 5.0)

	dllfunc(DLLFunc_Spawn, ent)

	// fuser1 = spawn time, used for the time based frame
	set_pev(ent, pev_fuser1, get_gametime())
	set_pev(ent, pev_nextthink, get_gametime() + EF_FX_THINK)
}

// Remove the idle effect of this player (Deploy_Post can run more than once)
Idle_Remove(id)
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", EF_IDLE_CLS)) > 0)
	{
		if(pev(ent, pev_owner) == id)
			set_pev(ent, pev_flags, FL_KILLME)
	}
}

public Entity_Think_EF_BMode(ent)
{
	if(!IsValidPev(ent)) return

	new id = pev(ent, pev_owner)

	// The attachment belongs to the weapon's view model, so it only lives while the weapon is held
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_SOULREAPEREX)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}

	new Float:flStart
	pev(ent, pev_fuser1, flStart)

	new Float:flFrame = (get_gametime() - flStart) * EF_FX_FPS
	if(flFrame >= float(EF_B_FRAME_MAX))
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}

	set_pev(ent, pev_frame, flFrame)
	set_pev(ent, pev_nextthink, get_gametime() + EF_FX_THINK)
}

public Entity_Think_EF_Draw(ent)
{
	if(!IsValidPev(ent)) return

	new id = pev(ent, pev_owner)

	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_SOULREAPEREX)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}

	new Float:flStart
	pev(ent, pev_fuser1, flStart)

	new Float:flFrame = (get_gametime() - flStart) * EF_FX_FPS
	if(flFrame >= EF_DRAW_FRAMEMAX)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}

	set_pev(ent, pev_frame, flFrame)
	set_pev(ent, pev_nextthink, get_gametime() + EF_FX_THINK)
}

// Idle effect: loops for as long as the weapon is held, sprite follows the weapon mode
public Entity_Think_EF_ACMode(ent)
{
	if(!IsValidPev(ent)) return

	new id = pev(ent, pev_owner)

	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_SOULREAPEREX)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}
	
	if(get_gametime() < g_flIdleHideUntil[id] || GetSecondaryAmmo(id) <= 39)
	{
		set_pev(ent, pev_effects, pev(ent, pev_effects) | EF_NODRAW)
		set_pev(ent, pev_nextthink, get_gametime() + EF_FX_THINK)
		return
	}
	else
	{
		if(pev(ent, pev_effects) & EF_NODRAW)
		{
			set_pev(ent, pev_effects, pev(ent, pev_effects) & ~EF_NODRAW)
		}
	}

	// Swap the sprite only when the mode changes (pev_iuser1: 0 = A mode, 1 = C mode)
	new iMode = Get_BitVar(g_ActiveHelix, id) ? 1 : 0
	if(pev(ent, pev_iuser1) != iMode)
	{
		engfunc(EngFunc_SetModel, ent, iMode ? EF_IDLEC_SPR : EF_IDLEA_SPR)
		set_pev(ent, pev_iuser1, iMode)
	}

	// Looping, time based frame
	new Float:flStart
	pev(ent, pev_fuser1, flStart)

	new Float:flFrame = (get_gametime() - flStart) * EF_FX_FPS
	flFrame -= EF_IDLE_FRAMEMAX * float(floatround(flFrame / EF_IDLE_FRAMEMAX, floatround_floor))

	set_pev(ent, pev_frame, flFrame)
	set_pev(ent, pev_nextthink, get_gametime() + EF_FX_THINK)
}

do_EF_Gauge(id)
{
	if(!CanCreateEntity()) return

	//Gauge_Remove(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(ent)) return

	set_pev(ent, pev_classname, EF_GAUGE_CLAS)
	engfunc(EngFunc_SetModel, ent, EF_GAUGE_SPR)

	set_pev(ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_gravity, 0.0)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_body, 2)
	set_pev(ent, pev_aiment, id)
	set_pev(ent, pev_skin, id)
	set_pev(ent, pev_impulse, EF_FX_IMPULSE)	// owner only, see fw_AddToFullPack_Post

	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_scale, EF_GAUGE_SCALE)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 255.0)

	set_pev(ent, pev_nextthink, get_gametime() + EF_GAUGE_THINK)
}

Gauge_Remove(id)
{
	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", EF_GAUGE_CLAS)) > 0)
	{
		if(pev(ent, pev_owner) == id)
			set_pev(ent, pev_flags, FL_KILLME)
	}
}

public Entity_Think_EF_Gauge(ent)
{
	if(!IsValidPev(ent)) return

	new id = pev(ent, pev_owner)

	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_SOULREAPEREX)
	{
		set_pev(ent, pev_flags, FL_KILLME)
		return
	}

	set_pev(ent, pev_frame, float(min(g_sphereCount[id], SPHERE_MAX)))
	set_pev(ent, pev_nextthink, get_gametime() + EF_GAUGE_THINK)
}
/* =============================================================================  */
/* =============================================================================  */
/* ========================== Soulreaperex_Stocks ============================  */
stock UTIL_WeaponList(client_index, bool: bEnabled)
{
	static iMsgId_Weaponlist
	if (!iMsgId_Weaponlist)
		iMsgId_Weaponlist = get_user_msgid("WeaponList")

	message_begin(MSG_ONE, iMsgId_Weaponlist, _, client_index)
	write_string(bEnabled ? WEAPON_SPR : WEAPON_REFERENCE)
	write_byte(iWeaponList[0])
	write_byte(iWeaponList[1])
	write_byte(bEnabled ? WeaponSecondaryAmmoIndex : iWeaponList[2])
	write_byte(bEnabled ? WeaponSecondaryAmmoMax   : iWeaponList[3])
	write_byte(iWeaponList[4])
	write_byte(iWeaponList[5])
	write_byte(iWeaponList[6])
	write_byte(iWeaponList[7])
	message_end()
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
	static pEntity; pEntity = NULLENT
	while ((pEntity = engfunc(EngFunc_FindEntityByString, pEntity, "classname", szClassName)) > 0)
		util_kill_entity(pEntity)
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

// Used by Make_BulletSmoke
stock get_weapon_attachment(id, Float:output[3], Float:fDis = 40.0)
{
	new Float:vfEnd[3], viEnd[3]
	get_user_origin(id, viEnd, 3)
	IVecFVec(viEnd, vfEnd)

	new Float:fOrigin[3], Float:fAngle[3]
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, fAngle)
	xs_vec_add(fOrigin, fAngle, fOrigin)

	new Float:fAttack[3]
	xs_vec_sub(vfEnd, fOrigin, fAttack)

	new Float:fLen = vector_length(fAttack)
	if(fLen <= 0.0)
	{
		output[0] = fOrigin[0]
		output[1] = fOrigin[1]
		output[2] = fOrigin[2]
		return
	}

	new Float:fRate = fDis / fLen
	xs_vec_mul_scalar(fAttack, fRate, fAttack)
	xs_vec_add(fOrigin, fAttack, output)
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

stock Make_BulletSmoke(id, TrResult)
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

stock Stock_Muzzle(iPlayer, const szcls[], const szmodel[], Float:fScale)
{
	static Ent; Ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(Ent)) return

	set_pev(Ent, pev_classname, szcls)

	set_pev(Ent, pev_owner, iPlayer)
	set_pev(Ent, pev_body, 1)
	set_pev(Ent, pev_skin, iPlayer)
	set_pev(Ent, pev_aiment, iPlayer)
	set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(Ent, pev_solid, SOLID_NOT)
	set_pev(Ent, pev_animtime, get_gametime())
	set_pev(Ent, pev_scale, fScale)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 5.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)
	dllfunc(DLLFunc_Spawn, Ent)

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
		knockback(i, id, 5.0, 5.0)
	}
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

stock hook_ent(ent, Float:target[3], Float:speed)
{
	new Float:pos[3], Float:vel[3]
	pev(ent, pev_origin, pos)

	new Float:dir[3]
	dir[0] = target[0] - pos[0]
	dir[1] = target[1] - pos[1]
	dir[2] = target[2] - pos[2]

	new Float:len = vector_length(dir)
	if (len < 0.1) return

	vel[0] = dir[0] / len * speed
	vel[1] = dir[1] / len * speed
	vel[2] = dir[2] / len * speed

	set_pev(ent, pev_velocity, vel)
}

stock Create_Explosion(Float:origin[3], iScale = 10, iFramerate = 15)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_EXPLOSION);
	write_coord(floatround(origin[0]));
	write_coord(floatround(origin[1]));
	write_coord(floatround(origin[2]));
	write_short(g_iExplosionSprite);
	write_byte(iScale);
	write_byte(iFramerate);
	write_byte(TE_EXPLFLAG_NOSOUND);

	message_end();
}

stock bool:CanCreateEntity() {
	return (global_get(glb_maxEntities) - engfunc(EngFunc_NumberOfEntities) >= 100)
}

stock knockback(id, attacker, Float:force, Float:zBoost)
{
    if (!is_user_alive(id))
        return;

    new Float:velocity[3];
    pev(id, pev_velocity, velocity);

    // Compute horizontal direction from attacker to victim
    new Float:dir[3];
    if (attacker && is_user_alive(attacker))
    {
        new Float:originA[3], Float:originV[3];
        pev(id, pev_origin, originV);
        pev(attacker, pev_origin, originA);
        dir[0] = originV[0] - originA[0];
        dir[1] = originV[1] - originA[1];
        dir[2] = 0.0;
    }
    else
    {
        // Fallback: push along victim's view direction
        new Float:angles[3];
        pev(id, pev_angles, angles);
        dir[0] = floatcos(angles[1], degrees);
        dir[1] = floatsin(angles[1], degrees);
        dir[2] = 0.0;
    }

    // Normalize direction
    new Float:len = floatsqroot(dir[0]*dir[0] + dir[1]*dir[1]);
    if (len > 0.0)
    {
        dir[0] /= len;
        dir[1] /= len;
    }

    // Apply new velocity
    velocity[0] += dir[0] * force;
    velocity[1] += dir[1] * force;
    velocity[2] = zBoost;

    set_pev(id, pev_velocity, velocity);
}

stock OnHelixEffect(id, ent, Float:fRad, Float:fPullSpeed)
{
	if(!pev_valid(ent)) return
	
	new Float:Origin[3]
	pev(ent, pev_origin, Origin)
	
	new i = -1
	while((i = engfunc(EngFunc_FindEntityInSphere, i, Origin, fRad)) != 0)
	{
		if(id == i) continue
		if(pev(i, pev_takedamage) == DAMAGE_NO) continue
		if(pev(i, pev_spawnflags) == SF_BREAK_TRIGGER_ONLY) continue

		if(1 <= i <= get_maxplayers())
		{
			if(!is_user_alive(i)) continue
			if(get_user_team(i) == get_user_team(id)) continue
		}
		
		new Float:VictimOrigin[3]
		pev(i, pev_origin, VictimOrigin)
		
		// Direction vector from victim to origin
		new Float:Dir[3]
		Dir[0] = Origin[0] - VictimOrigin[0]
		Dir[1] = Origin[1] - VictimOrigin[1]
		Dir[2] = 0.0 // keep it horizontal, don't touch Z
		
		new Float:fDist = vector_length(Dir)
		if(fDist < 1.0) continue // already at origin, skip
		
		// Normalize direction
		Dir[0] /= fDist
		Dir[1] /= fDist
		
		new Float:Velocity[3]
		pev(i, pev_velocity, Velocity)
		
		// Override horizontal velocity toward origin, keep Z so gravity still works
		Velocity[0] = Dir[0] * fPullSpeed
		Velocity[1] = Dir[1] * fPullSpeed
		
		set_pev(i, pev_velocity, Velocity)
	}
}

/* =============================================================================  */
