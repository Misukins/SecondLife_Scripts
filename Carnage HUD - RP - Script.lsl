integer listenChannel   = 4;
integer llChan          = -458703;
integer meterON         = FALSE;
integer gotPermission   = FALSE;
integer toggle          = FALSE;

vector color_OFF        = <0.876, 0, 0>;
vector color_ON         = <0, 0.876, 0>;

default
{
    state_entry()
    {
        llListen(llChan, "", "", "");
        llPreloadSound("piano");
        llPreloadSound("vampsleep1");
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
            if((meterON) && (gotPermission)){
                llStartAnimation("rezz");  
                llTriggerSound("piano", 1.0);
                llSetTimerEvent(5.0);
                llSay(listenChannel, "on");
                llSay(-458790, "HUD_ON");
                llSetLinkColor(LINK_THIS, color_ON, ALL_SIDES);
                toggle = TRUE;
            }
            else
                llOwnerSay("Didn't find attachment: Carnage Meter");
        }
        else{
            llStartAnimation("vampsleep");  
            llTriggerSound("vampsleep1", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "off");
            llSay(-458790, "HUD_OFF");
            llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
            toggle = FALSE;
        }
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("rezz");
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
        llStopAnimation("rezz");
        llStopAnimation("vampsleep");
        llStopSound();
     }
}
