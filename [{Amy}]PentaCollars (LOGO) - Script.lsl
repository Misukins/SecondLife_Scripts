integer FACE = 0;
integer g_iMychannel = -8888;

string g_sListenfor;
string g_sResponse;

AnnounceLeashHolder()
{
    llSay(g_iMychannel, g_sResponse);
}

default
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_FULLBRIGHT, FACE, TRUE]);
        llSetPrimitiveParams([PRIM_GLOW, FACE, 0.20]);
        g_sListenfor = (string)llGetOwner() + "handle";
        g_sResponse = (string)llGetOwner() + "handle ok";
        llListen(g_iMychannel, "", NULL_KEY, g_sListenfor);
        AnnounceLeashHolder();
        llSetTimerEvent(2.0);  
    }

    listen(integer channel, string name, key id, string message)
    {
        AnnounceLeashHolder();
        llSetTimerEvent(2.0);
    }

    attach(key kAttached)
    {
        if (kAttached == NULL_KEY){
            llSay(g_iMychannel, (string)llGetOwner() + "handle detached");
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_TELEPORT){
            AnnounceLeashHolder();
            llSetTimerEvent(2.0);
        }
    }

    timer()
    {
        llSetColor(<llFrand(1.0), llFrand(1.0), llFrand(1.0)>, 0);
        llSetTimerEvent(0.0);
        AnnounceLeashHolder();
    }
}