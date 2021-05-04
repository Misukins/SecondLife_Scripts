integer walking = FALSE;

float Walking_Sound_Speed = 1.0;
float seconds_to_check_when_avatar_walks = 0.01;

soundsOFF(){
    walking = FALSE;
    llSetTimerEvent(seconds_to_check_when_avatar_walks);
}

key llGetObjectOwner(){
    list details = llGetObjectDetails(llGetKey(), [OBJECT_OWNER]);
    return (key)llList2CSV(details);
}

default
{
    state_entry()
    {
        if(llGetAttached() != 0)
            llSetTimerEvent(seconds_to_check_when_avatar_walks);
        else
            llSetTimerEvent(0);
    }

    timer()
    {
        if(llGetAgentInfo(llGetObjectOwner()) & AGENT_WALKING){
            llSetTimerEvent(Walking_Sound_Speed);
            if(walking == FALSE){
                llSetColor(<llFrand(1.0),llFrand(1.0),llFrand(1.0)>, 2);
                llSetPrimitiveParams([PRIM_FULLBRIGHT, 2, TRUE]);
                llSetPrimitiveParams([PRIM_GLOW, 2, 0.25]);
                walking = TRUE;
                llSetTimerEvent(Walking_Sound_Speed);
            }
            else
                soundsOFF();
        }
    }
}