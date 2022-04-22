float volume = 1.0;

integer listenChannel = -458790;
integer silentMode = FALSE;

string silentOn_Sound  = "f7e33202-446e-0163-5cf4-35ac0be7200c";
string silentOff_Sound = "c2df82df-2246-ec34-29bc-df72b184a77d";

vector color_OFF        = <0.876, 0, 0>;
vector color_ON         = <0, 0.876, 0>;

default
{
    state_entry()
    {
        llPreloadSound(silentOn_Sound);
        llPreloadSound(silentOff_Sound);
        llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key attached)
    {
        if(attached != NULL_KEY){
            //TODO
        }
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner()){
            if(!silentMode){
                llSetLinkColor(LINK_THIS, color_ON, ALL_SIDES);
                llSay(listenChannel, "SILENTON");
                llTriggerSound(silentOn_Sound, volume);
                silentMode = TRUE;
            }
            else{
                llSetLinkColor(LINK_THIS, color_OFF, ALL_SIDES);
                llSay(listenChannel, "SILENTOFF");
                llTriggerSound(silentOff_Sound, volume);
                silentMode = FALSE;
            }
        }
    }
}