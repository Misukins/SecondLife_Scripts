integer listenChannel   = 4;
integer llChan          = -458703;
integer meterON         = FALSE;
integer gotPermission   = FALSE;

default
{
    state_entry()
    {
        llListen(llChan, "", "", "");
        llPreloadSound("vampsleep1");
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    touch_start(integer detected)
    {
        if((meterON) && (gotPermission)){
            llStartAnimation("vampsleep");  
            llTriggerSound("vampsleep1", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "off");
        }
        else
            llOwnerSay("no Meter");
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("vampsleep");
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == llChan){
            if(msg == "meterON")
                meterON = TRUE;
            else if(msg == "meterOFF")
                meterON = FALSE;
        }
    }

    timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation("vampsleep");  
        llStopSound();
     }
}
