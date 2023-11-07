integer listenChannel   = 4;
integer llChan          = -458703;
integer _llChan         = -458790;
integer meterON         = FALSE;
integer gotPermission   = FALSE;
integer toggle          = FALSE;
integer silentMode      = FALSE;

string desc_          = "(c)Vanessa (meljonna Resident) - ";

vector color_OFF        = <0.876, 0, 0>;
vector color_ON         = <0, 0.876, 0>;

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        llListen(llChan, "", "", "");
        llListen(_llChan, "", "", "");
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
        if((!toggle) && (!silentMode)){
            if((meterON) && (gotPermission)){
                llStartAnimation("rezz");
                llTriggerSound("piano", 1.0);
                llSetTimerEvent(5.0);
                llSay(listenChannel, "on");
                llSay(_llChan, "HUD_ON");
                llSetLinkColor(LINK_THIS, color_ON, ALL_SIDES);
                toggle = TRUE;
            }
            else
                llOwnerSay("Didn't find attachment: Carnage Meter");
        }
        else if(toggle){
            llStartAnimation("vampsleep");  
            llTriggerSound("vampsleep1", 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "off");
            llSay(_llChan, "HUD_OFF");
            llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
            toggle = FALSE;
        }
        else
            llOwnerSay("You need to disable SilentMode!");
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
        else if(chan == _llChan){
            if(msg == "silentModeON")
                silentMode = TRUE;
            else if(msg == "silentModeOFF")
                silentMode = FALSE;
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
