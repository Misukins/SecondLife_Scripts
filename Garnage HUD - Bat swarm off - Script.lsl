integer listenChannel   = -458790;
integer llChan          = -458702;
integer batsON          = FALSE;
integer gotPermission   = FALSE;

default
{
    state_entry()
    {
        llListen(llChan, "", "", "");
        llPreloadSound("chokehigh");
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    touch_start(integer detected)
    {
        if((batsON) && (gotPermission)){
            llStartAnimation("whistle");  
            llTriggerSound("chokehigh", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "sheath sword");
        }
        else
            llOwnerSay("no Bat Swarm (Add)");
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("whistle");
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == llChan){
            if(msg == "batsON")
                batsON = TRUE;
            else if(msg == "batsOFF")
                batsON = FALSE;
        }
    }

    timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation("whistle");  
        llStopSound();
     }
}
