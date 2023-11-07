integer listenChannel   = -458790;
integer llChan          = -458701;
integer biterON         = FALSE;
integer gotPermission   = FALSE;
integer toggle          = FALSE;

string desc_          = "(c)Vanessa (meljonna Resident) - ";

vector color_OFF        = <0.876, 0, 0>;
vector color_ON         = <0, 0.876, 0>;

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        llListen(llChan, "", "", "");
        llPreloadSound("vamplaugh");
        llPreloadSound("chokehigh");
        llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        llResetScript();
    }
    
    touch_start(integer detected)
    {
        if(!toggle){
            if((biterON) && (gotPermission)){
                llStartAnimation("laugh_short");
                llTriggerSound("vamplaugh",1.0);
                llSetTimerEvent(5.0);
                llSay(listenChannel, "draw sword");
                llSetLinkColor(LINK_THIS, color_ON, ALL_SIDES);
                toggle = TRUE;
            }
            else
                llOwnerSay("Didn't find attachment: Carnage Claws");
        }
        else{
            llStartAnimation("whistle");  
            llTriggerSound("chokehigh", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "sheath sword");
            llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
            toggle = FALSE;
        }
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("laugh_short");
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
        llStopAnimation("laugh_short");
        llStopAnimation("whistle");
        llStopSound();
    }
}
