/* =========================================
-------- Plugin Datas and Headers ----------
========================================= */
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <engine>
#include <hamsandwich>
#include <cstrike>
#include <xs>

#define PLUGIN  "[CSO] Viperfang T3"
#define VERSION "1.0"
#define AUTHOR  "Mellowzy"

/* ================= Mode Switch ================= */
#define ZB_Mode

/* ================= CSWPN Data ================= */
#define CSW_VIPERFANG3 CSW_KNIFE
#define weapon_viperfang3 "weapon_knife"
#define VIPERFANG3_SPR "knife_viperfang3"
#define VIPERFANG3_AMMO_ID  15
#define OFFSET_AMMO_SLOT   376
#define m_flTimeNextPrimaryAttack      46
#define m_flTimeNextSecondaryAttack    47
#define m_flTimeWeaponIdle             48
#define OFFSET_LINUX_WEAPONS    4
#define OFFSET_LINUX_PLAYER     5
#define m_pPlayer                        41
#define m_iClip                          51
#define m_fInReload                      54
#define m_flNextAttack                   83
#define m_pActiveItem                    373
#define m_rgAmmo                         376

#define get_weapon_owner(%1)            get_pdata_cbase(%1, m_pPlayer, OFFSET_LINUX_WEAPONS)
#define get_player_active_item(%1)      get_pdata_cbase(%1, m_pActiveItem, OFFSET_LINUX_PLAYER)
#define set_player_next_attack(%1,%2)   set_pdata_float(%1, m_flNextAttack, %2, OFFSET_LINUX_PLAYER)
#define set_weapon_next_pri(%1,%2)      set_pdata_float(%1, m_flTimeNextPrimaryAttack, %2, OFFSET_LINUX_WEAPONS)
#define set_weapon_next_sec(%1,%2)      set_pdata_float(%1, m_flTimeNextSecondaryAttack, %2, OFFSET_LINUX_WEAPONS)
#define get_weapon_next_pri(%1)         get_pdata_float(%1, m_flTimeNextPrimaryAttack, OFFSET_LINUX_WEAPONS)
#define set_weapon_idle(%1,%2)          set_pdata_float(%1, m_flTimeWeaponIdle, %2, OFFSET_LINUX_WEAPONS)
#define get_weapon_idle(%1)             get_pdata_float(%1, m_flTimeWeaponIdle, OFFSET_LINUX_WEAPONS)
#define get_player_ammo(%1,%2)          get_pdata_int(%1, m_rgAmmo + %2, OFFSET_LINUX_PLAYER)
#define set_player_ammo(%1,%2,%3)       set_pdata_int(%1, m_rgAmmo + %2, %3, OFFSET_LINUX_PLAYER)

#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
#define IsValidPev(%0) (pev_valid(%0) == 2)

#if !defined OBS_IN_EYE
	#define OBS_IN_EYE 4
#endif
#if !defined MAX_PLAYERS
	#define MAX_PLAYERS 32
#endif

/* ================= End of CSWPN Data ================= */
/* ================= Resources ================= */
#define VIPERFANG3_V_MODEL "models/cso-latam/v_viperfang3.mdl"
#define VIPERFANG3_P_MODEL "models/cso-latam/p_viperfang3.mdl"
#define VIPERFANG3_TXT "sprites/knife_viperfang3.txt"

#define EF_GLOBAL_MDL "models/cso-latam/xs_global_viperfangx3.mdl"
#define SHOCKWAVE_SPRITES "sprites/cso-latam/ef_viperfang3_Bmode_2.spr"
#define C_MODE_SPR "sprites/cso-latam/ef_viperfang3_Cmode_Hit.spr"

#define EF_SHOOTA1 "sprites/cso-latam/ef_viperfang3_shootA1.spr"
#define EF_SHOOTA2 "sprites/cso-latam/ef_viperfang3_shootA2.spr"
#define EF_SHOOTB1 "sprites/cso-latam/ef_viperfang3_shootB1.spr"
#define EF_IDLE "sprites/cso-latam/ef_viperfang3_idle_wind.spr"

/*================== Weapon_Tunable =======================*/

#define VF_MAX_PLAYERS   32

#define SLOW_ENABLE      1
#define SLOW_DURATION    2.0      // duration
#define SLOW_FACTOR      0.5      // 0.5 = 50% of normal speed

#define HITC_ACTIVATE_BUFF_MULT 10
#define BUFF_MULT 2.0
#define BUFF_LIMIT_WHILE_NO_ATTACK 5.0
#define INVICIBLE_DURATION 5.0

#if defined ZB_Mode

#include <zombie_theheroex> //<==== you can change related to zombie modes (zp, zbheroex, etc...)

#endif

#if defined ZB_Mode

#define MAX_CHARGE 100
#define CHARGE_CONSUME 35
#define CHARGE_PER_SEC 2

#define ATTACK_DELAY 0.38
#define ATTACK_DELAY2 1.2
#define ATTACK_DELAY3 1.4
#define END_DELAY    0.8

#define DAMAGE_STATEA_1 55.0
#define DAMAGE_STATEA_2 65.0
#define DAMAGE_STATEA_3 85.0
#define RADIUS_STATEA 280.0
#define KNOCKBACK_STATEA 10.0

#define DAMAGE_STATEB 175.0
#define RADIUS_STATEB 280.0
#define KNOCKBACK_STATEB 15.0

#define DAMAGE_STATEC 185.0
#define RADIUS_STATEC 280.0
#define KNOCKBACK_STATEC 20.0

#endif

#if !defined ZB_Mode

#define MAX_CHARGE 100
#define CHARGE_CONSUME 35
#define CHARGE_PER_SEC 2

#define ATTACK_DELAY 0.38
#define ATTACK_DELAY2 1.2
#define ATTACK_DELAY3 1.4
#define END_DELAY    0.8

#define DAMAGE_STATEA_1 5.0
#define DAMAGE_STATEA_2 10.0
#define DAMAGE_STATEA_3 15.0
#define RADIUS_STATEA 280.0
#define KNOCKBACK_STATEA 5.0

#define DAMAGE_STATEB 25.0
#define RADIUS_STATEB 280.0
#define KNOCKBACK_STATEB 15.0

#define DAMAGE_STATEC 30.0
#define RADIUS_STATEC 280.0
#define KNOCKBACK_STATEC 15.0

#endif

/*================== Entity_Data =======================*/
#define ENT_CLASSNAME_STATEA "efx_state_a"
#define ENT_CLASSNAME_STATEB "efx_state_b"
#define ENT_CLASSNAME_STATEC "efx_state_c"
#define SHOCKWAVE_CLASSNAME "efx_shockwave"

#define SHOOTA1_CLASSNAME "shoota1_ef"
#define SHOOTA2_CLASSNAME "shoota2_ef"
#define SHOOTB1_CLASSNAME "shootb1_ef"

#define EF_IDLE_CLASSNAME "idle_ef"

#define SHOCKWAVE_IMPULSE "1122345"
#define SHOCKWAVE_SCALE_START    2.5
#define SHOCKWAVE_SCALE_END      5.0
#define SHOCKWAVE_SCALE_SPEED    0.3
#define SHOCKWAVE_FADE_SPEED     25.0
#define SHOCKWAVE_ANIMATED       0

#define MAX_ENTITIES 8192

// trace distance used to check for walls (hit wall sound)
#define HIT_WALL_RANGE    60.0

// pev_impulse marker: the only way fw_Entity_Think recognises our effects
#define FX_IMPULSE        77123

#define FX_SPRITE_CLASS   "env_sprite"   // entity used for the C sprite (set to "info_target" if env_sprite ever gives trouble)

#define FX_THINK          0.02           // think interval of every effect
#define FX_FADE_TIME      0.3            // fade-out time at the end of the C sprite's life
#define FX_RENDERMODE     kRenderTransAdd // used by the sprites
#define FX_RENDERAMT      255.0

// A / B mode: model effect (xs_global_viperfangx3.mdl), follows the player.
// pev_skin 0..26 is a texture flipbook (the last frames are already faded out inside the textures),
// so the model needs NO render mode. The effect is removed when the last skin frame has played.
#define FX_MDL_SKINS      27             // skin families inside the model
#define FX_MDL_FPS        30.0           // flipbook speed (frames per second)
#define FX_A_SCALE        10.5           // scale of the A mode model (pev_scale, 1.0 = original size)
#define FX_B_SCALE        10.5           // scale of the B mode model (pev_scale, 1.0 = original size)
#define FX_FOLLOW_GAIN    10.0           // how hard the effect is pulled to the owner
#define FX_FOLLOW_SNAP    80.0           // farther than this from the owner = the effect is teleported to it

// C mode: sprite placed where the player aims. Frames go 0..FX_C_MAXFRAME (frame_max=37)
#define FX_C_LIFE         1.6
#define FX_C_SCALE        1.5
#define FX_C_MAXFRAME     37
#define FX_C_FPS          30.0
#define FX_C_RANGE        400.0          // max distance of the aim trace
#define FX_C_SURFACE_GAP  4.0            // pull the sprite off the wall so it doesn't z-fight

new const g_szFXClasses[][] =
{
	ENT_CLASSNAME_STATEA,
	ENT_CLASSNAME_STATEB,
	ENT_CLASSNAME_STATEC
}

enum
{
	FX_TYPE_A = 0,   // index of g_szFXClasses[]
	FX_TYPE_B,
	FX_TYPE_C
}

// body / sequence inside xs_global_viperfangx3.mdl
// body = a_mode * 1 + a_280b * 4 + b_mode * 8
// A mode: 180 / 230 / 280 (280 also shows the a_280b part)
new const g_iFXA_Sub[3]  = { 1, 2, 3 }
new const g_iFXA_Sub2[3] = { 0, 0, 1 }
new const g_iFXA_Seq[3]  = { 0, 1, 2 }
// B mode: b_mode sub-model + b_idle sequence
new const g_iFXB_Sub[3]  = { 1, 3, 5 }
new const g_iFXB_Seq[3]  = { 3, 4, 5 }

new const ExtraSounds[][] =
{
	"weapons/viperfang_chage.wav",
	"weapons/viperfang_draw.wav",
	"weapons/viperfang_idle.wav",
	"weapons/viperfang_shoot_fx1.wav",
	"weapons/viperfang_shoot_fx2.wav",
	"weapons/viperfang_shoot_fx3.wav",
	"weapons/viperfang_shootA_end.wav",
	"weapons/viperfang_shootA1.wav",
	"weapons/viperfang_shootA1_end.wav",
	"weapons/viperfang_shootA2.wav",
	"weapons/viperfang_shootA3.wav",
	"weapons/viperfang_shootB.wav",
	"weapons/viperfang_shootB_end.wav",
	"weapons/viperfang_shootB_exp.wav",
	"weapons/viperfang_shootC_exp.wav",
	"weapons/viperfang_shootC_FX_loop.wav",
	"weapons/viperfang_shootC1.wav",
	"weapons/viperfang_shootC2.wav",
	"weapons/tomahawk_slash1_hit.wav",
	"weapons/tomahawk_wall.wav"
}

enum
{
	SND_CHARGE = 0,
	SND_DRAW,
	SND_IDLE,
	SND_SHOOT_FX1,
	SND_SHOOT_FX2,
	SND_SHOOT_FX3,
	SND_SHOOTA_END,
	SND_SHOOTA1,
	SND_SHOOTA1_END,
	SND_SHOOTA2,
	SND_SHOOTA3,
	SND_SHOOTB,
	SND_SHOOTB_END,
	SND_SHOOTB_EXP,
	SND_SHOOTC_EXP,
	SND_SHOOTC_FX_LOOP,
	SND_SHOOTC1,
	SND_SHOOTC2,
	SND_HITENEMY,
	SND_HITWALL
}

enum
{
	ANIM_IDLE = 0,
	ANIM_DRAW,
	ANIM_SHOOTA1,
	ANIM_SHOOTA1_END,
	ANIM_SHOOTA2,
	ANIM_SHOOTA3,
	ANIM_SHOOTA_END,
	ANIM_SHOOTB,
	ANIM_SHOOTC,
	ANIM_SHOOTC_CHARGE
}

enum
{
	STATE_A1 = 0,
	STATE_A2,
	STATE_A3,
	STATE_B
}

enum
{
	HIT_NOTHING = 0,
	HIT_ENEMY,
	HIT_WALL
}

new const ExtraSprites[][] =
{
	"sprites/cso-latam/640hud278.spr"
}

new g_iBloodSpray, g_iBloodDrop
new g_bitsHasWeapon, g_msgAmmoX, g_msgWeaponList
new g_AttackState[33], g_Charge[33], Float:g_flLastRegen[33], g_WillBeHit[33]
new bool:g_bHolding[33]
new Float:g_fSlowUntil[VF_MAX_PLAYERS + 1], bool:g_bIsSlowed[VF_MAX_PLAYERS + 1]
new g_pcvFriendlyFire, g_MaxPlayers
new g_iFXAllocModel, g_iFXAllocSprite

new g_bIsAttacking, g_BuffActive, g_InvisActive, g_BuffHC[33], Float:g_BuffDuration[33], Float:g_InvisDuration[33]

#if defined ZB_Mode
new g_ViperFang3
#endif

/* ================= End of Resources ================= */

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)

	/*======================== FAKEMETA =================================*/
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", true)
	register_forward(FM_EmitSound, "fw_Forward_EmitSound")
	register_forward(FM_Think, "fw_Entity_Think")
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")

	/*======================== HAMSANDWICH =============================*/
	RegisterHam(Ham_Item_Deploy,       weapon_viperfang3, "fw_Forward_Knife_Deploy_Post", true)
	RegisterHam(Ham_Item_Holster,      weapon_viperfang3, "fw_Forward_Knife_Holster_Post", true)
	RegisterHam(Ham_Item_PostFrame,    weapon_viperfang3, "fw_Forward_Knife_PostFrame_Pre")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_viperfang3, "fw_Forward_Knife_WeaponIdle_Post", true)
	RegisterHam(Ham_Item_AddToPlayer,  weapon_viperfang3, "fw_Forward_Knife_AddToPlayer_Post", true)

	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled_Post", true)
	RegisterHam(Ham_Spawn,  "player", "fw_PlayerSpawn_Post", true)
	RegisterHam(Ham_CS_Player_ResetMaxSpeed, "player", "fw_ResetMaxSpeed_Post", true)
	RegisterHam(Ham_Item_PreFrame, "player", "fw_Item_PreFrame")
	
	/*======================== COMMANDS ===============================*/
	register_clcmd("give_viperfang3", "CSOWPN_Give")
	register_clcmd(VIPERFANG3_SPR, "CSOWPN_Hook")

	g_msgWeaponList = get_user_msgid("WeaponList")
	g_msgAmmoX = get_user_msgid("AmmoX")
	g_pcvFriendlyFire = get_cvar_pointer("mp_friendlyfire")
	g_MaxPlayers = get_maxplayers()

	g_iFXAllocModel  = engfunc(EngFunc_AllocString, "info_target")
	g_iFXAllocSprite = engfunc(EngFunc_AllocString, FX_SPRITE_CLASS)

#if defined ZB_Mode
	g_ViperFang3 = zbheroex_register_weapon("Viperfang T3", WEAPON_MELEE, CSW_VIPERFANG3, 0)
#endif
}

public plugin_precache()
{
	engfunc(EngFunc_PrecacheModel, VIPERFANG3_V_MODEL)
	engfunc(EngFunc_PrecacheModel, VIPERFANG3_P_MODEL)

	precache_model(EF_GLOBAL_MDL)
	precache_model(SHOCKWAVE_SPRITES)
	precache_model(C_MODE_SPR)

	precache_model(EF_SHOOTA1)
	precache_model(EF_SHOOTA2)
	precache_model(EF_SHOOTB1)
	precache_model(EF_IDLE)

	engfunc(EngFunc_PrecacheGeneric, VIPERFANG3_TXT)

	for(new i = 0; i < sizeof(ExtraSounds); i++)
		precache_sound(ExtraSounds[i])
	for(new i = 0; i < sizeof(ExtraSprites); i++)
		precache_model(ExtraSprites[i])

	g_iBloodSpray = precache_model("sprites/bloodspray.spr")
	g_iBloodDrop  = precache_model("sprites/blood.spr")
}

public client_putinserver(id)
{
	UnSet_BitVar(g_bitsHasWeapon, id)
	Reset_State(id)
}

public client_disconnected(id)
{
	UnSet_BitVar(g_bitsHasWeapon, id)
	Reset_State(id)
	
}

public message_DeathMsg(msg_id, msg_dest, msg_ent)
{
	static szWeapon[64]
	get_msg_arg_string(4, szWeapon, charsmax(szWeapon))

	if (!equal(szWeapon, "knife"))
		return PLUGIN_CONTINUE

	static iKiller; iKiller = get_msg_arg_int(1)
	if (!is_user_connected(iKiller))
		return PLUGIN_CONTINUE

	if (!Get_BitVar(g_bitsHasWeapon, iKiller) || get_user_weapon(iKiller) != CSW_VIPERFANG3)
		return PLUGIN_CONTINUE

	set_msg_arg_string(4, "knife")
	return PLUGIN_CONTINUE
}

#if defined ZB_Mode
public zbheroex_weapon_bought(id, ItemID)
{
	if(ItemID == g_ViperFang3) CSOWPN_Give(id)
}

public zbheroex_weapon_remove(id, ItemID)
{
	if(ItemID == g_ViperFang3) CSOWPN_Remove(id)
}
#endif

public CSOWPN_Give(id)
{
	if(!is_user_alive(id))
		return PLUGIN_HANDLED

	new iKnife = fm_find_ent_by_owner(-1, weapon_viperfang3, id)
	if (!IsValidPev(iKnife))
	{
		fm_give_item(id, weapon_viperfang3)
		iKnife = fm_find_ent_by_owner(-1, weapon_viperfang3, id)
		if (!IsValidPev(iKnife))
			return PLUGIN_HANDLED
	}

	Set_BitVar(g_bitsHasWeapon, id)
	UnSet_BitVar(g_BuffActive, id)
	UnSet_BitVar(g_bIsAttacking, id)
	UnSet_BitVar(g_InvisActive, id)
	
	g_BuffHC[id] = 0
	g_BuffDuration[id] = 0.0
	g_InvisDuration[id] = 0.0
	g_Charge[id] = MAX_CHARGE
	g_AttackState[id] = STATE_A1
	g_bHolding[id] = false
	g_WillBeHit[id] = HIT_NOTHING
	g_flLastRegen[id] = get_gametime()

	UTIL_SendWeaponList(id)
	UTIL_SyncAmmoX(id)

	if (get_user_weapon(id) == CSW_VIPERFANG3)
		ExecuteHamB(Ham_Item_Deploy, iKnife)
	else
		engclient_cmd(id, weapon_viperfang3)

	return PLUGIN_HANDLED
}

public CSOWPN_Hook(id)
{
	engclient_cmd(id, weapon_viperfang3)
	return PLUGIN_HANDLED
}

CSOWPN_Remove(id)
{
	// restore damage if currently invincible (only if still alive)
	if (Get_BitVar(g_InvisActive, id) && is_user_alive(id)){
		set_pev(id, pev_takedamage, DAMAGE_AIM)
		CMode_Screen_Remove(id)
	}

	UnSet_BitVar(g_bitsHasWeapon, id)
	Reset_State(id)

	if (is_user_connected(id))
	{
		UTIL_ResetAmmo(id)
		UTIL_RestoreWeaponList(id)
	}
}

public Reset_State(id)
{
	UnSet_BitVar(g_BuffActive, id)
	UnSet_BitVar(g_bIsAttacking, id)
	UnSet_BitVar(g_InvisActive, id)
	
	g_BuffHC[id] = 0
	g_Charge[id] = 0
	g_WillBeHit[id] = HIT_NOTHING
	g_AttackState[id] = STATE_A1
	g_bHolding[id] = false
	g_bIsSlowed[id] = false
	g_fSlowUntil[id] = 0.0
	g_BuffDuration[id] = 0.0
	g_InvisDuration[id] = 0.0
}


// ==================================================================
// FAKEMETA_HOOK
// ==================================================================
public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if (!is_user_alive(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return FMRES_IGNORED

	if (get_user_weapon(id) != CSW_VIPERFANG3)
		return FMRES_IGNORED

	set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001)
	return FMRES_HANDLED
}

public fw_Forward_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if (!is_user_connected(id))
		return FMRES_IGNORED
	if (!Get_BitVar(g_bitsHasWeapon, id) || get_user_weapon(id) != CSW_VIPERFANG3)
		return FMRES_IGNORED

	if (sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
		return FMRES_SUPERCEDE

	return FMRES_IGNORED
}

public fw_Entity_Think(ent)
{
	if (!IsValidPev(ent))
		return FMRES_IGNORED

	static szClass[32]
	pev(ent, pev_classname, szClass, charsmax(szClass))

	new Float:flNow = get_gametime()

	if (equal(szClass, SHOOTA1_CLASSNAME) || equal(szClass, SHOOTA2_CLASSNAME))
	{
		static iOwnerA; iOwnerA = pev(ent, pev_owner)

		if (!is_user_alive(iOwnerA) || get_user_weapon(iOwnerA) != CSW_VIPERFANG3)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static iActiveItemA; iActiveItemA = get_pdata_cbase(iOwnerA, 373, 5)
		if (!IsValidPev(iActiveItemA))
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		new Float:EfOrigin[3]
		get_position(iOwnerA, 7.5, -6.0, -2.5, EfOrigin)
		set_pev(ent, pev_origin, EfOrigin)

		static Float:FrameA; pev(ent, pev_frame, FrameA)
		if (FrameA > 7.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		FrameA += 1.0
		set_pev(ent, pev_frame, FrameA)
		set_pev(ent, pev_nextthink, flNow + 0.04)

		return FMRES_IGNORED
	}

	if (equal(szClass, EF_IDLE_CLASSNAME))
	{
		static iOwnerI; iOwnerI = pev(ent, pev_owner)

		if (!is_user_alive(iOwnerI) || get_user_weapon(iOwnerI) != CSW_VIPERFANG3)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static iActiveItemI; iActiveItemI = get_pdata_cbase(iOwnerI, 373, 5)
		if (!IsValidPev(iActiveItemI))
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static Float:FrameI; pev(ent, pev_frame, FrameI)
		if (FrameI > 29.0)
			FrameI = 0.0

		FrameI += 1.0
		set_pev(ent, pev_frame, FrameI)
		set_pev(ent, pev_nextthink, flNow + 0.04)

		return FMRES_IGNORED
	}

	if (equal(szClass, SHOOTB1_CLASSNAME))
	{
		static iOwnerB; iOwnerB = pev(ent, pev_owner)
		if (!is_user_alive(iOwnerB))
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static Float:FrameB; pev(ent, pev_frame, FrameB)
		if (FrameB > 17.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		FrameB += 1.0
		set_pev(ent, pev_frame, FrameB)

		FX_FollowOwnerOffset(ent, iOwnerB)
		set_pev(ent, pev_nextthink, flNow + 0.04)

		return FMRES_IGNORED
	}

	if (equal(szClass, SHOCKWAVE_CLASSNAME))
	{
		static iOwnerS; iOwnerS = pev(ent, pev_owner)
		if (!is_user_alive(iOwnerS))
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		static Float:FrameS; pev(ent, pev_frame, FrameS)
		if (FrameS > 29.0)
		{
			set_pev(ent, pev_flags, FL_KILLME)
			return FMRES_IGNORED
		}

		FrameS += 1.0
		set_pev(ent, pev_frame, FrameS)

		FX_FollowOwner(ent, iOwnerS)
		set_pev(ent, pev_nextthink, flNow + 0.04)

		return FMRES_IGNORED
	}

	if (pev(ent, pev_impulse) != FX_IMPULSE)
		return FMRES_IGNORED

	static Float:flStart
	pev(ent, pev_fuser1, flStart)
	static Float:flElapsed
	flElapsed = flNow - flStart

	switch (pev(ent, pev_iuser1))
	{
		case FX_TYPE_A, FX_TYPE_B:
		{
			new iOwner = pev(ent, pev_owner)
			if (!is_user_alive(iOwner))
			{
				FX_Remove(ent)
				return FMRES_SUPERCEDE
			}

			new iSkin = floatround(flElapsed * FX_MDL_FPS, floatround_floor)
			if (iSkin >= FX_MDL_SKINS)
			{
				FX_Remove(ent)
				return FMRES_SUPERCEDE
			}

			if (iSkin != pev(ent, pev_skin))
				set_pev(ent, pev_skin, iSkin)

			FX_FollowOwner(ent, iOwner)
		}
		case FX_TYPE_C:
		{
			if (flElapsed >= FX_C_LIFE)
			{
				FX_Remove(ent)
				return FMRES_SUPERCEDE
			}

			new iFrame = min(floatround(flElapsed * FX_C_FPS, floatround_floor), FX_C_MAXFRAME)
			set_pev(ent, pev_frame, float(iFrame))

			new Float:flLeft = FX_C_LIFE - flElapsed
			if (flLeft < FX_FADE_TIME)
				set_pev(ent, pev_renderamt, FX_RENDERAMT * (flLeft / FX_FADE_TIME))
		}
	}

	set_pev(ent, pev_nextthink, flNow + FX_THINK)

	return FMRES_SUPERCEDE
}


// ==================================================================
// HAMSANDWICH_HOOK
// ==================================================================
public fw_PlayerKilled_Post(victim, attacker, shouldgib)
{
	g_bIsSlowed[victim] = false
	g_fSlowUntil[victim] = 0.0
	
	if (Get_BitVar(g_bitsHasWeapon, victim))
		CSOWPN_Remove(victim)

	return HAM_IGNORED
}

public fw_PlayerSpawn_Post(id)
{
	g_bIsSlowed[id] = false
	g_fSlowUntil[id] = 0.0
	
	if (!is_user_alive(id))
		return HAM_IGNORED

	if (Get_BitVar(g_bitsHasWeapon, id))
		CSOWPN_Remove(id)

	return HAM_IGNORED
}

public fw_ResetMaxSpeed_Post(id)
{
	if (!g_bIsSlowed[id] || !is_user_alive(id))
		return HAM_IGNORED

	static Float:flSpeed
	pev(id, pev_maxspeed, flSpeed)

	if (flSpeed > 1.0)
		set_pev(id, pev_maxspeed, flSpeed * SLOW_FACTOR)

	return HAM_IGNORED
}

public fw_Item_PreFrame(id)
{
	if (!g_bIsSlowed[id])
		return HAM_IGNORED

	if (is_user_alive(id) && get_gametime() < g_fSlowUntil[id])
		return HAM_IGNORED

	g_bIsSlowed[id] = false
	g_fSlowUntil[id] = 0.0

	if (is_user_alive(id))
		ExecuteHamB(Ham_CS_Player_ResetMaxSpeed, id)

	return HAM_IGNORED
}

public fw_Forward_Knife_Deploy_Post(ent)
{
	new id = get_weapon_owner(ent)
	if (!is_user_alive(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return HAM_IGNORED

	set_pev(id, pev_viewmodel2,   VIPERFANG3_V_MODEL)
	set_pev(id, pev_weaponmodel2, VIPERFANG3_P_MODEL)

	UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_DRAW)

	Slashfx(id, 1, 0.02, EF_IDLE_CLASSNAME, EF_IDLE)
	Slashfx(id, 2, 0.02, EF_IDLE_CLASSNAME, EF_IDLE)

	set_weapon_next_pri(ent, 0.8)
	set_weapon_next_sec(ent, 0.8)
	set_weapon_idle(ent, 1.5)

	g_AttackState[id] = STATE_A1
	g_bHolding[id] = false
	g_flLastRegen[id] = get_gametime()
	UTIL_SyncAmmoX(id)

	return HAM_IGNORED
}

public fw_Forward_Knife_Holster_Post(ent)
{
	new id = get_weapon_owner(ent)
	if (!is_user_alive(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return HAM_IGNORED

	g_AttackState[id] = STATE_A1
	g_bHolding[id] = false

	if (Get_BitVar(g_InvisActive, id))
		set_pev(id, pev_takedamage, DAMAGE_AIM)

	UnSet_BitVar(g_InvisActive, id)
	UnSet_BitVar(g_BuffActive, id)
	UnSet_BitVar(g_bIsAttacking, id)
	CMode_Screen_Remove(id)
	
	g_InvisDuration[id] = 0.0
	g_BuffDuration[id] = 0.0
	g_BuffHC[id] = 0

	return HAM_IGNORED
}

public fw_Forward_Knife_WeaponIdle_Post(ent)
{
	if (!IsValidPev(ent))
		return HAM_IGNORED

	new id = get_weapon_owner(ent)
	if (!is_user_alive(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return HAM_IGNORED

	if (get_weapon_idle(ent) <= 0.25)
	{
		UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_IDLE)
		set_weapon_idle(ent, 20.0)
	}

	return HAM_IGNORED
}

public fw_Forward_Knife_AddToPlayer_Post(ent, id)
{
	if (!IsValidPev(ent) || !is_user_connected(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return HAM_IGNORED

	UTIL_SyncAmmoX(id)
	UTIL_SendWeaponList(id)
	return HAM_IGNORED
}

public fw_Forward_Knife_PostFrame_Pre(ent)
{
	new id = get_weapon_owner(ent)
	if (!is_user_alive(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return HAM_IGNORED

	new Float:gt = get_gametime()

	// ---- charge regen ----
	if (g_Charge[id] < MAX_CHARGE)
	{
		if (gt - g_flLastRegen[id] >= 1.0)
		{
			g_flLastRegen[id] = gt
			g_Charge[id] += CHARGE_PER_SEC
			if (g_Charge[id] > MAX_CHARGE)
				g_Charge[id] = MAX_CHARGE

			UTIL_SyncAmmoX(id)
		}
	}

	// ---- buff timer ----
	// g_BuffDuration = expiry time (0.0 = timer not running)
	if (Get_BitVar(g_bIsAttacking, id))
	{
		// currently attacking: timer is stopped / reset
		g_BuffDuration[id] = 0.0
	}
	else if (g_BuffHC[id] > 0 || Get_BitVar(g_BuffActive, id))
	{
		if (g_BuffDuration[id] <= 0.0)
		{
			// stop attacking
			g_BuffDuration[id] = gt + BUFF_LIMIT_WHILE_NO_ATTACK
		}
		else if (gt >= g_BuffDuration[id])
		{
			//buff reset
			if (Get_BitVar(g_BuffActive, id))

			UnSet_BitVar(g_BuffActive, id)
			g_BuffDuration[id] = 0.0
			g_BuffHC[id] = 0
		}
	}

	// ---- invincible timer ----
	if (Get_BitVar(g_InvisActive, id) && gt >= g_InvisDuration[id])
	{
		UnSet_BitVar(g_InvisActive, id)
		g_InvisDuration[id] = 0.0
		set_pev(id, pev_takedamage, DAMAGE_AIM)
	}

	new iButton = pev(id, pev_button)

	WE_Viperfang(id, ent, iButton)

	return HAM_IGNORED
}

WE_Viperfang(id, ent, iButton)
{
	if(!is_user_alive(id)) return
	if(get_user_weapon(id) != CSW_VIPERFANG3 || !Get_BitVar(g_bitsHasWeapon, id))
		return

	if (iButton & IN_RELOAD)
	{
		if (get_weapon_next_pri(ent) > 0.0)
			return
		if(g_Charge[id] < CHARGE_CONSUME)
			return

		// invicible
		if (!Get_BitVar(g_InvisActive, id))
		{
			Set_BitVar(g_InvisActive, id)
			g_InvisDuration[id] = get_gametime() + INVICIBLE_DURATION
			set_pev(id, pev_takedamage, DAMAGE_NO)
		}

		UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTC)
		Set_PlayerAnim(id, "shoot_knife")
		UTIL_PlaySound(id, SND_SHOOTC2)

		g_Charge[id] -= CHARGE_CONSUME

		UTIL_SyncAmmoX(id)

		g_AttackState[id] = STATE_A1
		g_bHolding[id] = false

		new Float:vHit[3]
		FX_CreateStateC(id, vHit)
		new iHits = do_damages(id, CSW_VIPERFANG3, vHit, RADIUS_STATEC, DAMAGE_STATEC, KNOCKBACK_STATEC, DMG_SLASH)
		UTIL_HitSound(id, iHits)

		set_weapon_next_pri(ent, ATTACK_DELAY3)
		set_weapon_next_sec(ent, ATTACK_DELAY3)
		set_weapon_idle(ent, ATTACK_DELAY3 + 0.5)
	}

	if (iButton & IN_ATTACK2)
	{
		if (get_weapon_next_pri(ent) > 0.0)
			return

		UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTB)
		Set_PlayerAnim(id, "shoot_knife")
		UTIL_PlaySound(id, SND_SHOOTB)
		UTIL_PlaySound(id, SND_SHOOTB_EXP, CHAN_ITEM)

		FX_CreateModel(id, FX_TYPE_B, 2)
		VF_Shockwave(id)
		
		Slashfx(id, 1, 0.2, SHOOTA1_CLASSNAME, EF_SHOOTA1)
		Slashfx(id, 2, 0.2, SHOOTA2_CLASSNAME, EF_SHOOTA2)

		g_AttackState[id] = STATE_A1
		g_bHolding[id] = false
		Set_BitVar(g_bIsAttacking, id)
		
		WE_DoDamage(id, Get_BitVar(g_BuffActive, id) ? DAMAGE_STATEB * BUFF_MULT : DAMAGE_STATEB, RADIUS_STATEB, KNOCKBACK_STATEB)
		VF_ShootB1(id)   // keep it AFTER WE_DoDamage: the damage knockback overwrites the victims' velocity
		
		if (g_BuffHC[id] < HITC_ACTIVATE_BUFF_MULT)
			g_BuffHC[id]++

		if (g_BuffHC[id] >= HITC_ACTIVATE_BUFF_MULT && !Get_BitVar(g_BuffActive, id))
		{
			Set_BitVar(g_BuffActive, id)
			CMode_Screen_Draw(id)
		}

		set_weapon_next_pri(ent, ATTACK_DELAY2)
		set_weapon_next_sec(ent, ATTACK_DELAY2)
		set_weapon_idle(ent, ATTACK_DELAY2 + 0.5)
	}

	if (iButton & IN_ATTACK)
	{
		if (get_weapon_next_pri(ent) > 0.0)
			return

		switch (g_AttackState[id])
		{
			case STATE_A1:
			{
				UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTA1)
				Set_PlayerAnim(id, "shoot_knife")
				UTIL_PlaySound(id, SND_SHOOTA1)
				UTIL_PlaySound(id, SND_SHOOT_FX1, CHAN_ITEM)
				VF_Shockwave(id)
				FX_CreateModel(id, FX_TYPE_A, 0)
				WE_DoDamage(id, Get_BitVar(g_BuffActive, id) ? DAMAGE_STATEA_1 * BUFF_MULT : DAMAGE_STATEA_1, RADIUS_STATEA, KNOCKBACK_STATEA)

				Slashfx(id, 1, 0.2, SHOOTA1_CLASSNAME, EF_SHOOTA1)

				g_AttackState[id] = STATE_A2
			}
			case STATE_A2:
			{
				UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTA2)
				Set_PlayerAnim(id, "shoot_knife")
				UTIL_PlaySound(id, SND_SHOOTA2)
				UTIL_PlaySound(id, SND_SHOOT_FX2, CHAN_ITEM)
				FX_CreateModel(id, FX_TYPE_A, 1)
				WE_DoDamage(id, Get_BitVar(g_BuffActive, id) ? DAMAGE_STATEA_2 * BUFF_MULT : DAMAGE_STATEA_2, RADIUS_STATEA, KNOCKBACK_STATEA)
				VF_Shockwave(id)
				Slashfx(id, 2, 0.2, SHOOTA2_CLASSNAME, EF_SHOOTA2)

				g_AttackState[id] = STATE_A3
			}
			case STATE_A3:
			{
				UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTA3)
				Set_PlayerAnim(id, "shoot_knife")
				UTIL_PlaySound(id, SND_SHOOTA3)
				UTIL_PlaySound(id, SND_SHOOT_FX3, CHAN_ITEM)
				VF_Shockwave(id)
				FX_CreateModel(id, FX_TYPE_A, 1)
				WE_DoDamage(id, Get_BitVar(g_BuffActive, id) ? DAMAGE_STATEA_3 * BUFF_MULT : DAMAGE_STATEA_3, RADIUS_STATEA, KNOCKBACK_STATEA)
				Slashfx(id, 2, 0.2, SHOOTA2_CLASSNAME, EF_SHOOTA2)
				g_AttackState[id] = STATE_A1
			}
		}

		g_bHolding[id] = true
		Set_BitVar(g_bIsAttacking, id)
		
		if(Get_BitVar(g_BuffActive, id)){
			WE_DoDamage(id, DAMAGE_STATEA_3, RADIUS_STATEA * 2.0, KNOCKBACK_STATEA * 1.5)
			FX_CreateModel(id, FX_TYPE_A, 2)
		}

		if (g_BuffHC[id] < HITC_ACTIVATE_BUFF_MULT)
			g_BuffHC[id]++

		if (g_BuffHC[id] >= HITC_ACTIVATE_BUFF_MULT && !Get_BitVar(g_BuffActive, id))
		{
			Set_BitVar(g_BuffActive, id)
			CMode_Screen_Draw(id)
		}
		
		set_weapon_next_pri(ent, ATTACK_DELAY)
		set_weapon_next_sec(ent, ATTACK_DELAY)
		set_weapon_idle(ent, ATTACK_DELAY + 0.3)
	}
	else if (g_bHolding[id])
	{
		if (get_weapon_next_pri(ent) > 0.0)
			return

		if (g_AttackState[id] == STATE_A2)
		{
			UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTA1_END)
			UTIL_PlaySound(id, SND_SHOOTA1_END)
		}
		else
		{
			UTIL_SendWeaponAnim(MSG_ONE_UNRELIABLE, id, ent, ANIM_SHOOTA_END)
			UTIL_PlaySound(id, SND_SHOOTA_END)
		}

		g_AttackState[id] = STATE_A1
		g_bHolding[id] = false
		
		if(Get_BitVar(g_bIsAttacking, id))
			UnSet_BitVar(g_bIsAttacking, id)

		set_weapon_next_pri(ent, END_DELAY)
		set_weapon_next_sec(ent, END_DELAY)
		set_weapon_idle(ent, 1.5)
	}
}

// ==================================================================
// ENTITIES
// ==================================================================
VF_ShootB1(id)
{
	REMOVE_ENT(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(!IsValidPev(ent))
		return 0

	engfunc(EngFunc_SetModel, ent, EF_SHOOTB1)
	set_pev(ent, pev_classname, SHOOTB1_CLASSNAME)
	set_pev(ent, pev_owner, id)

	// frame and render
	set_pev(ent, pev_scale, 1.5)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_rendermode, FX_RENDERMODE)
	set_pev(ent, pev_renderamt, FX_RENDERAMT)

	// Tunables: the sprite sits where the player aims
	new Float:flRange = 150.0    // distance from the eyes (raise it to push the sprite further forward)
	new Float:flZOfs  = -6.0     // extra height relative to the aim point (negative = lower)
	new Float:flKnockUp = 300.0  // knockup velocity: must be above ~180 or players stay glued to the ground

	// stored in the entity so the think can keep following the aim with the same values
	set_pev(ent, pev_fuser1, flRange)
	set_pev(ent, pev_fuser2, flZOfs)

	// Owner
	new Float:pOrigin[3], Float:vAngles[3]

	pev(id, pev_v_angle, vAngles)
	FX_GetB1Target(id, flRange, flZOfs, pOrigin)

	vAngles[0] = 90.0
	vAngles[2] = 0.0

	engfunc(EngFunc_SetOrigin, ent, pOrigin)
	set_pev(ent, pev_angles, vAngles)
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)

	// knockup
	new i = -1, Float:vVelocity[3], Float:aOrigin[3]
	pev(id, pev_origin, aOrigin)
	while ((i = fm_find_ent_in_sphere(i, aOrigin, 180.0)) != 0)
	{
		if (i == id) continue
		if (!(1 <= i <= g_MaxPlayers) || !is_user_alive(i)) continue
		if (get_user_team(i) == get_user_team(id)) continue

		pev(i, pev_velocity, vVelocity)
		vVelocity[2] = flKnockUp
		set_pev(i, pev_velocity, vVelocity)

		// make sure the engine lets go of the ground this frame
		set_pev(i, pev_flags, pev(i, pev_flags) & ~FL_ONGROUND)
	}

	// think
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)

	return ent
}

REMOVE_ENT(owner)
{
	#pragma unused owner

	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", SHOOTB1_CLASSNAME)) != 0)
	{
		if(IsValidPev(ent))
			set_pev(ent, pev_flags, FL_KILLME)
	}
}

VF_Shockwave(id)
{
	RemoveShockwaveEntity(id)

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(!IsValidPev(ent))
		return 0

	engfunc(EngFunc_SetModel, ent, SHOCKWAVE_SPRITES)
	set_pev(ent, pev_classname, SHOCKWAVE_CLASSNAME)
	set_pev(ent, pev_owner, id)

	// frame and render
	set_pev(ent, pev_scale, 1.5)
	set_pev(ent, pev_frame, 0.0)
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_rendermode, FX_RENDERMODE)
	set_pev(ent, pev_renderamt, FX_RENDERAMT)

	// Owner
	new Float:pOrigin[3], Float:vAngles[3], Float:viewOfs[3]

	pev(id, pev_origin, pOrigin)
	pev(id, pev_view_ofs, viewOfs)

	pOrigin[2] -= viewOfs[2] + 1.5

	pev(id, pev_v_angle, vAngles)
	vAngles[0] = 90.0
	vAngles[2] = 0.0

	engfunc(EngFunc_SetOrigin, ent, pOrigin)
	set_pev(ent, pev_angles, vAngles)
	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_aiment, id)

	// think
	set_pev(ent, pev_nextthink, get_gametime() + 0.04)

	return ent
}

RemoveShockwaveEntity(owner)
{
	#pragma unused owner

	new ent = -1
	while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", SHOCKWAVE_CLASSNAME)) != 0)
	{
		if(IsValidPev(ent))
			set_pev(ent, pev_flags, FL_KILLME)
	}
}

// A / B mode: model effect that follows the player
// iType = FX_TYPE_A / FX_TYPE_B, iIdx = 0..2 (A: 180 / 230 / 280)
FX_CreateModel(id, iType, iIdx)
{
	new iBody, iSeq
	new Float:flScale

	if (iType == FX_TYPE_A)
	{
		iBody = g_iFXA_Sub[iIdx] + (g_iFXA_Sub2[iIdx] * 4)
		iSeq  = g_iFXA_Seq[iIdx]
		flScale = FX_A_SCALE
	}
	else
	{
		iBody = g_iFXB_Sub[iIdx] * 8
		iSeq  = g_iFXB_Seq[iIdx]
		flScale = FX_B_SCALE
	}

	new ent = engfunc(EngFunc_CreateNamedEntity, g_iFXAllocModel)
	if (!IsValidPev(ent))
		return 0

	new Float:vOrigin[3], Float:vAngles[3]
	pev(id, pev_origin, vOrigin)
	pev(id, pev_v_angle, vAngles)
	vAngles[0] = 0.0   // yaw only, set once when the effect is created
	vAngles[2] = 0.0

	set_pev(ent, pev_classname, g_szFXClasses[iType])
	engfunc(EngFunc_SetModel, ent, EF_GLOBAL_MDL)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)
	engfunc(EngFunc_SetOrigin, ent, vOrigin)
	set_pev(ent, pev_angles, vAngles)

	set_pev(ent, pev_movetype, MOVETYPE_NOCLIP)   // moved by velocity, see FX_FollowOwner

	set_pev(ent, pev_body, iBody)
	set_pev(ent, pev_skin, 0)
	set_pev(ent, pev_scale, flScale)

	set_pev(ent, pev_sequence, iSeq)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_frame, 0.0)

	set_pev(ent, pev_impulse, FX_IMPULSE)
	set_pev(ent, pev_iuser1, iType)
	set_pev(ent, pev_fuser1, get_gametime())
	set_pev(ent, pev_nextthink, get_gametime() + FX_THINK)

	return ent
}

//==================================================================
// STOCKS
// =================================================================
// damage around the player (A / B mode), plays hit / wall sound
// return: number of targets hit (used for the buff hit counter)
stock WE_DoDamage(id, Float:fDmg, Float:fRadius, Float:flkb)
{
	new Float:vOrigin[3]
	pev(id, pev_origin, vOrigin)

	new iHits = do_damages(id, CSW_VIPERFANG3, vOrigin, fRadius, fDmg, flkb, DMG_SLASH)
	UTIL_HitSound(id, iHits)

	return iHits
}

// iHits > 0: enemy hit sound. Otherwise trace forward and play wall sound if a wall is close
stock UTIL_HitSound(id, iHits)
{
	if (iHits > 0)
	{
		UTIL_PlaySound(id, SND_HITENEMY, CHAN_BODY)
		return
	}

	new Float:vStart[3], Float:vAim[3], Float:vEnd[3], Float:flFraction
	UTIL_GetEyePosition(id, vStart)
	UTIL_GetVectorAiming(id, vAim)

	xs_vec_mul_scalar(vAim, HIT_WALL_RANGE, vEnd)
	xs_vec_add(vStart, vEnd, vEnd)

	engfunc(EngFunc_TraceLine, vStart, vEnd, IGNORE_MONSTERS, id, 0)
	get_tr2(0, TR_flFraction, flFraction)

	if (flFraction < 1.0)
		UTIL_PlaySound(id, SND_HITWALL, CHAN_BODY)
}

// FIX: flScale is now Float: (was an untagged "iScale" -> tag mismatch on every call)
stock Slashfx(iPlayer, iBody, Float:flScale, const szcls[], const szmodel[])
{
	static Ent; Ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(Ent)) return

	set_pev(Ent, pev_classname, szcls)

	set_pev(Ent, pev_owner, iPlayer)
	set_pev(Ent, pev_body, iBody)
	set_pev(Ent, pev_skin, iPlayer)
	set_pev(Ent, pev_aiment, iPlayer)
	set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)

	set_pev(Ent, pev_scale, flScale)
	set_pev(Ent, pev_frame, 0.0)
	set_pev(Ent, pev_framerate, 5.0)
	set_pev(Ent, pev_rendermode, kRenderTransAdd)
	set_pev(Ent, pev_renderamt, 255.0)

	engfunc(EngFunc_SetModel, Ent, szmodel)

	set_pev(Ent, pev_nextthink, get_gametime() + 0.04)
}

// C mode: env_sprite placed where the player aims, fades out before it is removed
// vHit receives the sprite origin (the aimed point), used as the damage center
stock FX_CreateStateC(id, Float:vHit[3])
{
	new Float:vStart[3], Float:vAim[3], Float:vEnd[3], Float:vNormal[3], Float:flFraction

	UTIL_GetEyePosition(id, vStart)
	UTIL_GetVectorAiming(id, vAim)

	xs_vec_mul_scalar(vAim, FX_C_RANGE, vEnd)
	xs_vec_add(vStart, vEnd, vEnd)

	engfunc(EngFunc_TraceLine, vStart, vEnd, DONT_IGNORE_MONSTERS, id, 0)
	get_tr2(0, TR_flFraction, flFraction)
	get_tr2(0, TR_vecEndPos, vEnd)
	get_tr2(0, TR_vecPlaneNormal, vNormal)

	// hit a surface: pull the sprite off it so it doesn't z-fight
	if (flFraction < 1.0)
	{
		xs_vec_mul_scalar(vNormal, FX_C_SURFACE_GAP, vNormal)
		xs_vec_add(vEnd, vNormal, vEnd)
	}

	xs_vec_copy(vEnd, vHit)

	new ent = engfunc(EngFunc_CreateNamedEntity, g_iFXAllocSprite)
	if (!IsValidPev(ent))
		return 0

	set_pev(ent, pev_classname, g_szFXClasses[FX_TYPE_C])
	engfunc(EngFunc_SetModel, ent, C_MODE_SPR)
	set_pev(ent, pev_movetype, MOVETYPE_NONE)
	set_pev(ent, pev_solid, SOLID_NOT)
	set_pev(ent, pev_owner, id)
	engfunc(EngFunc_SetOrigin, ent, vEnd)

	set_pev(ent, pev_rendermode, FX_RENDERMODE)
	set_pev(ent, pev_renderamt, FX_RENDERAMT)
	set_pev(ent, pev_scale, FX_C_SCALE)
	set_pev(ent, pev_frame, 0.0)

	set_pev(ent, pev_impulse, FX_IMPULSE)
	set_pev(ent, pev_iuser1, FX_TYPE_C)
	set_pev(ent, pev_fuser1, get_gametime())
	set_pev(ent, pev_nextthink, get_gametime() + FX_THINK)

	return ent
}

stock FX_Remove(ent)
{
	if (pev_valid(ent))
		engfunc(EngFunc_RemoveEntity, ent)
}

// follow the owner with velocity: the engine moves the effect, so it stays smooth on the client
stock FX_FollowOwner(ent, owner)
{
	static Float:vTarget[3], Float:vCur[3], Float:vVel[3]
	pev(owner, pev_origin, vTarget)
	pev(ent, pev_origin, vCur)

	if (get_distance_f(vTarget, vCur) > FX_FOLLOW_SNAP)
	{
		engfunc(EngFunc_SetOrigin, ent, vTarget)
		vVel[0] = vVel[1] = vVel[2] = 0.0
	}
	else
	{
		pev(owner, pev_velocity, vVel)
		vVel[0] += (vTarget[0] - vCur[0]) * FX_FOLLOW_GAIN
		vVel[1] += (vTarget[1] - vCur[1]) * FX_FOLLOW_GAIN
		vVel[2] += (vTarget[2] - vCur[2]) * FX_FOLLOW_GAIN
	}

	set_pev(ent, pev_velocity, vVel)
}

// point flRange units in front of the owner's eyes, following the full aim (yaw + pitch)
stock FX_GetB1Target(owner, Float:flRange, Float:flZOfs, Float:vOut[3])
{
	static Float:vEye[3], Float:vAim[3]
	UTIL_GetEyePosition(owner, vEye)
	UTIL_GetVectorAiming(owner, vAim)

	vOut[0] = vEye[0] + vAim[0] * flRange
	vOut[1] = vEye[1] + vAim[1] * flRange
	vOut[2] = vEye[2] + vAim[2] * flRange + flZOfs
}

// same as FX_FollowOwner, but the target is the point the owner is aiming at (range / height come from the entity)
stock FX_FollowOwnerOffset(ent, owner)
{
	static Float:vTarget[3], Float:vCur[3], Float:vVel[3], Float:flRange, Float:flZOfs
	pev(ent, pev_fuser1, flRange)
	pev(ent, pev_fuser2, flZOfs)
	FX_GetB1Target(owner, flRange, flZOfs, vTarget)
	pev(ent, pev_origin, vCur)

	if (get_distance_f(vTarget, vCur) > FX_FOLLOW_SNAP)
	{
		engfunc(EngFunc_SetOrigin, ent, vTarget)
		vVel[0] = vVel[1] = vVel[2] = 0.0
	}
	else
	{
		pev(owner, pev_velocity, vVel)
		vVel[0] += (vTarget[0] - vCur[0]) * FX_FOLLOW_GAIN
		vVel[1] += (vTarget[1] - vCur[1]) * FX_FOLLOW_GAIN
		vVel[2] += (vTarget[2] - vCur[2]) * FX_FOLLOW_GAIN
	}

	set_pev(ent, pev_velocity, vVel)
}

stock IsWeaponActive(id)
{
	return (is_user_alive(id) && Get_BitVar(g_bitsHasWeapon, id) && get_user_weapon(id) == CSW_VIPERFANG3)
}

stock UTIL_ResetAmmo(id)
{
	set_pdata_int(id, OFFSET_AMMO_SLOT + VIPERFANG3_AMMO_ID, 0, OFFSET_LINUX_PLAYER)

	message_begin(MSG_ONE, g_msgAmmoX, _, id)
	write_byte(VIPERFANG3_AMMO_ID)
	write_byte(0)
	message_end()
}

stock UTIL_SendWeaponList(id)
{
	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string(VIPERFANG3_SPR)
	write_byte(VIPERFANG3_AMMO_ID)   // primary ammo id
	write_byte(MAX_CHARGE)           // primary ammo max
	write_byte(-1)
	write_byte(-1)
	write_byte(2)                    // slot (knife slot)
	write_byte(1)                    // number in slot
	write_byte(CSW_VIPERFANG3)
	write_byte(0)
	message_end()
}

stock UTIL_RestoreWeaponList(id)
{
	message_begin(MSG_ONE, g_msgWeaponList, _, id)
	write_string(weapon_viperfang3)
	write_byte(-1)
	write_byte(-1)
	write_byte(-1)
	write_byte(-1)
	write_byte(2)
	write_byte(1)
	write_byte(CSW_VIPERFANG3)
	write_byte(0)
	message_end()
}

stock UTIL_SyncAmmoX(id)
{
	if (!is_user_connected(id) || !Get_BitVar(g_bitsHasWeapon, id))
		return

	set_pdata_int(id, OFFSET_AMMO_SLOT + VIPERFANG3_AMMO_ID, g_Charge[id], OFFSET_LINUX_PLAYER)

	message_begin(MSG_ONE, g_msgAmmoX, _, id)
	write_byte(VIPERFANG3_AMMO_ID)
	write_byte(g_Charge[id])
	message_end()
}

stock UTIL_PlaySound(id, iSound, iChannel = CHAN_WEAPON)
{
	if (iSound < 0 || iSound >= sizeof(ExtraSounds))
		return

	emit_sound(id, iChannel, ExtraSounds[iSound], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
}

// Plays an animation on the player model (what other players / third-person camera see).
// Standard CS models use "ref_<name>" when standing and "crouch_<name>" when ducking.
stock Set_PlayerAnim(id, const AnimName[], Float:flRate = 1.0)
{
	static iAnim, Float:flFrameRate, Float:flGroundSpeed, bool:bLoops, szAnim[64]

	if (!(pev(id, pev_flags) & FL_DUCKING))
		formatex(szAnim, charsmax(szAnim), "ref_%s", AnimName)
	else
		formatex(szAnim, charsmax(szAnim), "crouch_%s", AnimName)

	if ((iAnim = lookup_sequence(id, szAnim, flFrameRate, bLoops, flGroundSpeed)) == -1)
		iAnim = 0

	if (!bLoops || (bLoops && pev(id, pev_sequence) != iAnim))
	{
		set_pev(id, pev_sequence, iAnim)
		set_pev(id, pev_animtime, get_gametime())
		set_pev(id, pev_framerate, flRate)

		set_pdata_int(id, 40, bLoops, 4)
		set_pdata_int(id, 39, 0, 4)
		set_pdata_float(id, 36, flFrameRate, 4)
		set_pdata_float(id, 37, flGroundSpeed, 4)
		set_pdata_float(id, 38, get_gametime(), 4)
	}

	set_pdata_int(id, 73, 28, 5)
	set_pdata_int(id, 74, 28, 5)
	set_pdata_float(id, 220, get_gametime(), 5)
}

// Sends a weapon animation to the owner and to every spectator watching the owner in first person
stock UTIL_SendWeaponAnim(const iDest, const pPlayer, const pItem, const iAnim)
{
	static iBody; iBody = pev(pItem, pev_body);
	set_pev(pPlayer, pev_weaponanim, iAnim);

	message_begin(iDest, SVC_WEAPONANIM, .player = pPlayer);
	write_byte(iAnim);
	write_byte(iBody);
	message_end();

	// the owner is a spectator himself: nobody to relay to
	if(pev(pPlayer, pev_iuser1))
		return;

	static i, iCount, pSpectator, aSpectators[MAX_PLAYERS];

	get_players(aSpectators, iCount, "bch");

	for(i = 0; i < iCount; i++)
	{
		pSpectator = aSpectators[i];

		// only first-person spectators see the viewmodel
		if(pev(pSpectator, pev_iuser1) != OBS_IN_EYE)
			continue;

		// must be watching this player
		if(pev(pSpectator, pev_iuser2) != pPlayer)
			continue;

		set_pev(pSpectator, pev_weaponanim, iAnim);

		message_begin(iDest, SVC_WEAPONANIM, .player = pSpectator);
		write_byte(iAnim);
		write_byte(iBody);
		message_end();
	}
}

// return: number of targets that took damage
// If the buff is active, damage is multiplied by BUFF_MULT (applies to modes A, B, and C)
stock do_damages(id, CSWPN, Float:Origin[3], Float:Radius, Float:fDmg, Float:flkb, dmgbits)
{
	if (!is_user_connected(id))
		return 0

	if (Get_BitVar(g_BuffActive, id))
		fDmg *= BUFF_MULT

	new inflictor = fm_get_user_weapon_entity(id, CSWPN)
	if (!IsValidPev(inflictor))
		inflictor = 0

	return Radius_Damage(id, inflictor, Origin, Radius, fDmg, flkb, dmgbits)
}

stock Radius_Damage(id, inflictor, Float:vicOri[3], Float:fRadius, Float:fDamage, Float:flkb, dmgbits)
{
	new i = -1, Float:vOrigin[3], Float:fTakeDmg
	new iHits = 0

	while ((i = fm_find_ent_in_sphere(i, vicOri, fRadius)) != 0)
	{
		if (i == id) continue
		if (!IsValidPev(i)) continue

		pev(i, pev_takedamage, fTakeDmg)
		if (fTakeDmg == DAMAGE_NO) continue

		if (pev(i, pev_spawnflags) & SF_BREAK_TRIGGER_ONLY) continue

		pev(i, pev_origin, vOrigin)

		if (1 <= i <= g_MaxPlayers)
		{
			if (!is_user_alive(i)) continue

			if (get_user_team(i) == get_user_team(id)
				&& !get_pcvar_num(g_pcvFriendlyFire))
				continue
		}

		ExecuteHamB(Ham_TakeDamage, i, inflictor, id, fDamage, dmgbits)
		ApplySlow(i)
		Stock_Fake_KnockBack(id, i, flkb)
		FX_Blood(vOrigin, 77, 10)
		iHits++
	}

	return iHits
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

stock FX_Blood(const Float:origin[3], color = 0, scale = 10)
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

stock UTIL_GetEyePosition(const pPlayer, Float:vecEyeLevel[3])
{
	new Float:vecOrigin[3]; pev(pPlayer, pev_origin, vecOrigin)
	new Float:vecViewOfs[3]; pev(pPlayer, pev_view_ofs, vecViewOfs)

	xs_vec_add(vecOrigin, vecViewOfs, vecEyeLevel)
}

stock UTIL_GetVectorAiming(const pPlayer, Float:vecAiming[3])
{
	new Float:vecViewAngle[3]; pev(pPlayer, pev_v_angle, vecViewAngle)
	new Float:vecPunchangle[3]; pev(pPlayer, pev_punchangle, vecPunchangle)

	xs_vec_add(vecViewAngle, vecPunchangle, vecViewAngle)
	angle_vector(vecViewAngle, ANGLEVECTOR_FORWARD, vecAiming)
}

stock get_position(ent, Float:forw, Float:right, Float:up, Float:vStart[])
{
	static Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]

	pev(ent, pev_origin, vOrigin)
	pev(ent, pev_view_ofs, vUp) // for player
	xs_vec_add(vOrigin, vUp, vOrigin)
	pev(ent, pev_v_angle, vAngle) // if normal entity, use pev_angles

	angle_vector(vAngle, ANGLEVECTOR_FORWARD, vForward)
	angle_vector(vAngle, ANGLEVECTOR_RIGHT, vRight)
	angle_vector(vAngle, ANGLEVECTOR_UP, vUp)

	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}

stock ApplySlow(id)
{
#if SLOW_ENABLE
	if (!(1 <= id <= g_MaxPlayers) || !is_user_alive(id))
		return

	new Float:flUntil = get_gametime() + SLOW_DURATION
	if (flUntil > g_fSlowUntil[id])
		g_fSlowUntil[id] = flUntil

	if (!g_bIsSlowed[id])
	{
		g_bIsSlowed[id] = true
		ExecuteHamB(Ham_CS_Player_ResetMaxSpeed, id)
	}
#endif
}

stock CMode_Screen_Draw(id)
{
    if (!is_user_alive(id))
        return PLUGIN_HANDLED;

    message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenFade"), _, id);
    write_short(1<<11);   // duration
    write_short(1<<11);   // holdTime
    write_short(0);       // FFADE_IN
    write_byte(57);        // red
    write_byte(255);      // green
    write_byte(20);      // blue
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
