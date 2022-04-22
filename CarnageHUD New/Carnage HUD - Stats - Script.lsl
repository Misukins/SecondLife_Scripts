float volume = 1.0;

integer listenChannel = -458790;

string clicksound = "aa12c98d-7ffe-f521-10cc-fd4ba3a63275";

default
{
    state_entry()
    {
        llPreloadSound(clicksound);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner()){
            llTriggerSound(clicksound, volume);
            llSay(listenChannel, "STATS");
        }
    }
}