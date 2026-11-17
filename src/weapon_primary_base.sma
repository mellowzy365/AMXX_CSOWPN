#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <xs>
#include <fun>
#include <cstrike>

#define PLUGIN_NAME    "Weapon_Primary_Base"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR  "Mellowzy"

#define PrecacheSoundsFromModel 1

/*========================= CSW_Data ===================== */
#define CSW_REFERENCE		CSW_
#define WEAPON_REFERENCE	"weapon_"
#define WEAPON_TXT			"weapon_"
#define WEAPON_HOOK			"weapon_"
#define WEAPON_IMPULSE		009
#define OLD_REFERENCE		"models/_"
#define WEAPON_EVENTS 		"events/"
#define BODY_NUM 			0

/*========================= Weapon_Data ===================== */
#define PLAYERMODEL			"models/p_.mdl"
#define VIEWMODEL			"models/v_.mdl"
#define WORLDMODEL			"models/w_.mdl"
#define ADDONSMODEL			"models/x_.mdl"

#define WEAPON_GENERIC		"sprites/weapon_.txt"

/*========================= Weapon_Tunables ===================== */
#define WEAPON_COMMANDS		"give_weapons_"

#define WP_SPEED_A			2.5

#define DAMAGE_A			10.0
#define DAMAGE_B			10.0
#define DAMAGE_C			10.0

#define WP_CLIP				10
#define WP_BPAMMO			100
#define WP_RELOAD_TIME		2.0

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
/*========================= Var's ===================== */
new g_ActiveWpn, g_weapon_event, g_HamBot, g_MaxPlayers
new g_Old_Weapon[33], Float:g_Recoil[33][3], g_ReClip[33]

/*========================= Init ===================== */
public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	
	//fakemeta
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", true)
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_SetModel, "fw_SetModel")
	
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
	RegisterHam(Ham_Weapon_SecondaryAttack, WEAPON_REFERENCE, "Ham_CWeapon_SecondaryAttack_Post", true)
	
	RegisterHam(Ham_Spawn, "player", "fw_Spawn_Post", true)
	RegisterHam(Ham_Killed, "player", "fw_Killed_Post", true)
	
	register_clcmd(WEAPON_COMMANDS, "CSOWPN_Give", ADMIN_IMMUNITY)
	register_clcmd(WEAPON_HOOK, "CSOWPN_Hook")
}
/*========================= Precache ===================== */
public plugin_precache()
{
	util_precache_model(PLAYERMODEL)
	util_precache_model(VIEWMODEL)
	util_precache_model(WORLDMODEL)
	util_precache_model(ADDONSMODEL)
	
	util_precache_sounds_from_model(VIEWMODEL)
	
	precache_generic(WEAPON_GENERIC)
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", true)
}
/*========================= Commands ===================== */
public CSOWPN_Give(id)
{
	if(!is_user_alive(id)) return
	
	Set_BitVar(g_ActiveWpn, id)
	fm_give_item(id, WEAPON_REFERENCE)
	
	static wp; wp = fm_get_user_weapon_entity(id, CSW_REFERENCE)
	if(wp > 0)
	{
		cs_set_weapon_ammo(wp, WP_CLIP)
		cs_set_user_bpammo(id, WP_BPAMMO)
		
		message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), _, id)
		write_byte(1)
		write_byte(CSW_REFERENCE)
		write_byte(WP_CLIP)
		message_end()
		
		Ham_CWeapon_Deploy_Post(Ent)
	}
	
	engclient_cmd(id, WEAPON_REFERENCE)
}
public CSOWPN_Remove(id)
{
	UnSet_BitVar(g_ActiveWpn, id)
}
public CSOWPN_Hook(id)
{
	engclient_cmd(id, WEAPON_REFERENCE)
	return PLUGIN_HANDLED
}
public CSOWPN_ResetState(id)
{
	//fill here if you have state like START,LOOP,END
}

/*========================= Curweapon ===================== */
public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return

	new csw = read_data(2)

	if(csw == CSW_REFERENCE && Get_BitVar(g_ActiveWpn, id))
	{
		set_pev(id, pev_viewmodel2, VIEWMODEL)
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
			UnSet_BitVar(g_ActiveWpn, iOwner)

			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}
/*========================= hamsandwich ===================== */
public fw_Spawn_Post(id)
{
	if(!is_user_connected(id))
		return

	CSOWPN_ResetState(id)
}

public fw_Killed_Post(id)
{
	CSOWPN_Remove(id)
}

public Ham_CWeapon_Deploy_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_alive(id) || !Get_BitVar(g_ActiveWpn, id)) return

	set_pev(id, pev_weaponmodel2, PLAYERMODEL)
	set_pev(id, pev_viewmodel2, VIEWMODEL)
	
	util_sendweaponanim(id, ANIM_DRAW)

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

		if(get_user_weapon(id) == CSW_REFERENCE)
			Ham_CWeapon_Deploy_Post(ent)
	}
}

public Ham_CWeapon_Holster_Post(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id)) return

	UnSet_BitVar(g_ActiveWpn, id)
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

	new ibutton = pev(id, pev_button)
	CWeapon_System(id, ent, ibutton)

	return HAM_IGNORED
}

public Ham_CWeapon_Idle_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	if(get_pdata_float(ent, m_Weapon_flTimeWeaponIdle, linux_diff_weapon) > 0.0)
		return HAM_SUPERCEDE

	util_sendweaponanim(id, ANIM_IDLE)

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

	set_pdata_int(ent, m_Weapon_iClip, g_ReClip[id], linux_diff_weapon)
	set_pdata_int(ent, m_Weapon_fInReload, 1, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, WP_RELOAD_TIME + 0.5, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, WP_RELOAD_TIME, linux_diff_player)

	util_sendweaponanim(id, ANIM_RELOAD)

	return HAM_IGNORED
}

public Ham_CWeapon_PrimaryAttack_Pre(ent)
{
	new id = get_pdata_cbase(ent, m_pPlayer, linux_diff_weapon)
	if(!is_user_connected(id) || !Get_BitVar(g_ActiveWpn, id))
		return HAM_IGNORED

	pev(id, pev_punchangle, g_Recoil[id])
	g_Clip[id] = get_pdata_int(ent, m_Weapon_iClip, linux_diff_weapon)
	
	set_pdata_int(ent, 64, 0, linux_diff_weapon)

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
	xs_vec_mul_scalar(Push, WP_RECOIL, Push)
	xs_vec_add(Push, g_Recoil[id], Push)
	set_pev(id, pev_punchangle, Push)
	
	util_sendweaponanim(id, ANIM_SHOOT)
	
	new Float:flDelay = get_pdata_float(ent, m_Weapon_flNextPrimaryAttack, linux_diff_weapon) * WP_SPEED_A
	set_pdata_float(ent, m_Weapon_flNextPrimaryAttack, flDelay, linux_diff_weapon)
	set_pdata_float(id, m_flNextAttack, flDelay, linux_diff_player)
	set_pdata_float(ent, m_Weapon_flNextSecondaryAttack, flDelay, linux_diff_weapon)
	set_pdata_float(ent, m_Weapon_flTimeWeaponIdle, flDelay + 1.0, linux_diff_weapon)
	
	return HAM_IGNORED
}
/*========================= System ===================== */
CWeapon_System(id, ent, button)
{
	if(!is_user_alive(id)) return
	if(!pev_valid(ent)) return
	if(!Get_BitVar(g_ActiveWpn, id) || get_user_weapon(id) != CSW_REFERENCE)) return
	
	//here for add more weapon_skills
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