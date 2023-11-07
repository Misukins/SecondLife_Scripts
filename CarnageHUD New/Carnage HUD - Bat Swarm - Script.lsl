key chokehigh = "01c5340e-654e-cd38-39db-b9569609f98a";
key vamplaugh = "1be7ea61-d7a4-414b-b745-8d48c0cc2a7b";

integer listenChannel   = -458790;
integer llChan          = -458703;
integer batsON          = FALSE;
integer gotPermission   = FALSE;
integer draw            = FALSE;
integer meterON;
integer HUD_ON;

string desc_          = "(c)Vanessa (meljonna Resident) - ";

vector color_OFF        = <0.876, 0, 0>;
vector color_ON         = <0, 0.876, 0>;

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        llListen(listenChannel, "", "", "");
        llListen(llChan, "", "", "");
        llPreloadSound(vamplaugh);
        llPreloadSound(chokehigh);
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
        if((batsON) && (gotPermission) && (!draw)){
            if(HUD_ON){
                draw = TRUE;
                llStartAnimation("fist_idle");
                llTriggerSound(vamplaugh, 1.0);
                llSetTimerEvent(5.0);
                llSay(listenChannel, "draw bats");
                llSetLinkColor(LINK_THIS, color_ON, ALL_SIDES);
            }
            else{
                llOwnerSay("You have to be in COMBAT+RP mode!");
            }
        }
        else if((batsON) && (gotPermission) && (draw)){
            draw = FALSE;
            llStartAnimation("whistle");  
            llTriggerSound(chokehigh, 1.0);
            llSetTimerEvent(5.0);
            llSay(listenChannel, "sheath bats");
            llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
        }
        else
            llOwnerSay("Didn't find attachment: Carnage Bat Swarm");
        
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("fist_idle");
            llStopAnimation("whistle");
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == llChan){
            if(llGetOwnerKey(id) == llGetOwner()){
                if(msg == "batsON")
                    batsON = TRUE;
                else if(msg == "batsOFF")
                    batsON = FALSE;
                else if(msg == "meterON")
                    meterON = TRUE;
                else if(msg == "meterON")
                    meterON = FALSE;
            }
        }
        else if(chan == listenChannel){
            if(llGetOwnerKey(id) == llGetOwner()){
                if(msg == "Bats_Active"){
                    llSetLinkColor(LINK_THIS, color_ON, ALL_SIDES);
                    draw = TRUE;
                }
                else if(msg == "Bats_Deactive"){
                    llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
                    draw = FALSE;
                }
                else if(msg == "HUD_ON")
                    HUD_ON = TRUE;
                else if(msg == "HUD_OFF")
                    HUD_ON = FALSE;
            }
        }
    }

    timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation("fist_idle");
        llStopAnimation("whistle");
        llStopSound();
     }
}
