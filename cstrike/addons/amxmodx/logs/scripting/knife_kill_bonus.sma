/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <colorchat>
#include <fun>

#define PLUGIN "Knife Kill Bonuses"
#define VERSION "1.0"
#define AUTHOR "Muhammad shehzad"

const TASK_ID = 700

const Float:FAST_SPEED = 380.0 //Your speed bonus

new const g_szSound[] = "f4sounds/knife_bhai_n.mp3"

new g_iSync
new bool:g_bHasSpeed[75]

public plugin_init() {
    register_plugin(PLUGIN, VERSION, AUTHOR)
    
    register_event("DeathMsg", "onDeathMsgEvent", "a")
    register_event("CurWeapon", "onCurWeaponEvent", "be", "1=1")
    
    g_iSync = CreateHudSyncObj()
}

public plugin_precache()
    precache_sound(g_szSound)

public onDeathMsgEvent()
{
    new id = read_data(1)
    
    new szWeapon[32]
    read_data(4, szWeapon, charsmax(szWeapon))
    
    if(equal(szWeapon, "knife") && is_user_alive(id))
    {
        new szName[32], szName2[32]
        get_user_name(id, szName, charsmax(szName))
        get_user_name(read_data(2), szName2, charsmax(szName2))
        
        set_hudmessage(255, 0, 0, 0.02, 0.2, 1, 0.1, 6.0, 0.1, 0.1, -1)
       ColorChat(id, print_chat, "^4[F4 Gamers] Knife ^3%s ^4knived ^3%s ^4and got^3 50HP + 3 Frags + 15 Sec Speed ", szName, szName2)
        set_hudmessage(255, 0, 0, 0.02, 0.2, 1, 0.1, 6.0, 0.1, 0.1, -1)
        ShowSyncHudMsg(0, g_iSync, "Player %s knifed %s Hahahaha", szName, szName2)
        
        client_cmd(id, "mp3 play %s", g_szSound)
        
        set_user_health(id, get_user_health( id ) + 50 )
        
        g_bHasSpeed[id] = true
        remove_task(id + TASK_ID)
        set_task(15.0, "taskRemoveSpeed", id + TASK_ID)
        set_user_maxspeed(id, FAST_SPEED)
        set_user_frags( id, get_user_frags( id ) + 2 )
    }
}

public onCurWeaponEvent(id)
    if(g_bHasSpeed[id])
        set_user_maxspeed(id, FAST_SPEED)

public taskRemoveSpeed(id)
{
    id -= TASK_ID
    g_bHasSpeed[id] = false
    set_user_maxspeed(id, 260.0)
} 