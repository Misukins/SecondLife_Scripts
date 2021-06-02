integer g_iMychannel = -8888;
integer DEBUG = FALSE;

string g_sListenfor;
string g_sResponse;

AnnounceLeashHolder()
{
    llSay(g_iMychannel, g_sResponse);
    if(DEBUG)
        llOwnerSay("DEBUG: AnnounceLeashHolder() - heard (" + (string)g_iMychannel + ", " + (string)g_sResponse + ")");
}

default
{
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        g_sListenfor = (string)llGetOwner() + "handle";
        g_sResponse = (string)llGetOwner() + "handle ok";
        llListen(g_iMychannel, "", NULL_KEY, g_sListenfor);
        AnnounceLeashHolder();
        llSetTimerEvent(2.0);
        if(DEBUG)
            llOwnerSay("DEBUG: state_entry() - heard");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        AnnounceLeashHolder();
        llSetTimerEvent(2.0);
        if(DEBUG)
            llOwnerSay("DEBUG: listen() - heard");
    }

    attach(key kAttached)
    {
        if (kAttached == NULL_KEY){
            llSay(g_iMychannel, (string)llGetOwner() + "handle detached");
        }
        if(DEBUG)
            llOwnerSay("DEBUG: attach() - heard");
    }

    changed(integer change)
    {
        if (change & CHANGED_TELEPORT){
            AnnounceLeashHolder();
            llSetTimerEvent(2.0);
        }
        if(DEBUG)
            llOwnerSay("DEBUG: changed() - heard");
    }

    timer()
    {
        llSetTimerEvent(0.0);
        AnnounceLeashHolder();
    }
}