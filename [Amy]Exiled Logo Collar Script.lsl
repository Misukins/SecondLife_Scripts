integer g_iMychannel = -8888;

string g_sListenfor;
string g_sResponse;

AnnounceLeashHolder()
{
    llSay(g_iMychannel, g_sResponse);
    llOwnerSay("GOT IT");
}

default
{
    state_entry()
    {
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
        if (kAttached == NULL_KEY)
            llSay(g_iMychannel, (string)llGetOwner() + "handle detached");
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
        llSetTimerEvent(0.0);
        AnnounceLeashHolder();
    }
}
