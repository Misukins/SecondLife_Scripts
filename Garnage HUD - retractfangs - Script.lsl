integer listenChannel   = -458789;
integer llChan          = -458701;
integer biterON         = FALSE;
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
        if((biterON) && (gotPermission)){
            llStartAnimation("whistle");  
            llTriggerSound("chokehigh", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "sheath sword");
        }
        else
            llOwnerSay("no Carnage Biter  v8.6(Add)");
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
            if(msg == "biterON")
                biterON = TRUE;
            else if(msg == "biterOFF")
                biterON = FALSE;
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation("whistle");  
        llStopSound();
     }
}