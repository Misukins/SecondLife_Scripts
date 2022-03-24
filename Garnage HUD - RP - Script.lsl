integer listenChannel   = 4;
integer llChan          = -458703;
integer meterON         = FALSE;
integer gotPermission   = FALSE;

default
{
    state_entry()
    {
        llListen(llChan, "", "", "");
        llPreloadSound("piano");
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    touch_start(integer detected)
    {
        if((meterON) && (gotPermission)){
            llStartAnimation("rezz");  
            llTriggerSound("piano", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "on");
        }
        else
            llOwnerSay("no Meter");
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("rezz");
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
        llStopAnimation("rezz");  
        llStopSound();
     }
}
