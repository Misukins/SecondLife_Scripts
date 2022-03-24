integer llChan          = -458704;
integer casterON        = FALSE;
integer gotPermission   = FALSE;

cast()
{
    llPlaySound("fireballcast", 1.0);
    llSay(330, llKey2Name(llGetOwner())+ "shoot");
    llStartAnimation("Attack11");
    llSetTimerEvent(5.0);
}   

default
{
    state_entry()
    {
        llListen(llChan, "", "", "");
        llPreloadSound("fireballcast");
        llPreloadSound("twin");
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    touch_start(integer total_number)
    {
        if((casterON) && (gotPermission))
            cast();
        else
            llOwnerSay("no Caster");
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("Attack11");
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == llChan){
            if(msg == "casterON")
                casterON = TRUE;
            else if(msg == "casterOFF")
                casterON = FALSE;
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation("Attack11");
        llStopSound();
    }
}