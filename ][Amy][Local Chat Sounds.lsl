key send_sound      = "92a8cf55-a572-d44f-839a-c11b7ef9791b";
key TypingSound     = "089ad0c9-9899-bf81-a73d-f1e3471b5373";

float send_volume   = 10.0;
float Volume        = 0.8;

integer ll_channel          = 664;
integer globalListenHandle  = -0;
integer SoundsOn;

default
{
    state_entry()
    {
        llListen(0, "", "", "");
        globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
        send_volume = send_volume/20;
        llPreloadSound(TypingSound);
        llPreloadSound(send_sound);
        if(SoundsOn)
            llSetTimerEvent(0.2);
        else
            llSetTimerEvent(0);
    }

    listen(integer ch, string nm, key id, string ms)
    {
        if(id == llGetOwner()){
            if (ch == ll_channel){
                if (ms == "menu"){
                    if(!SoundsOn){
                        SoundsOn = TRUE;
                        llOwnerSay("Sounds are On!");
                        llSetTimerEvent(0.2);
                    }
                    else{
                        SoundsOn = FALSE;
                        llOwnerSay("Sounds are Off!");
                        llSetTimerEvent(0);
                    }
                    !SoundsOn = SoundsOn;
                }
            }
            if(SoundsOn)
                llTriggerSound(send_sound, send_volume);
        }
    }

    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
            llResetScript();
    }

    timer()
    {
        if(SoundsOn){
            if (llGetAgentInfo(llGetOwner()) & AGENT_TYPING)
                llLoopSound(TypingSound, Volume);
            else
                llStopSound();
        }
    }
}