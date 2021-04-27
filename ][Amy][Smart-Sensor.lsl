/*

//FIX - IDEA IS THERE BUT NOT COMPLETED YET!!!

*/
key sub;
key ONsound  = NULL_KEY;//"";
key Offsound = NULL_KEY;//"";

float soundVolume = 1.0;

integer On;
integer inRange = FALSE;
integer channel;
integer listener;
integer DEBUG = TRUE;

lightsON()
{
    if(DEBUG)
        llOwnerSay("DEBUG: Funtion:lightsON()");
    On = TRUE;
    inRange = TRUE;
    llSetTimerEvent(30);
    //NOTE - FOR TESTING
    llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
}

lightsOFF()
{
    if(DEBUG)
        llOwnerSay("DEBUG: Funtion:lightsOFF()");
    On = FALSE;
    inRange = FALSE;
    llSetTimerEvent(1);
    //NOTE - FOR TESTING
    llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        llSetTimerEvent(1);
    }

    sensor(integer num)
    {
        /* integer x=0;
        for(x;x<num;x++)
        {
            sub = llDetectedKey(x);
            if(sub != llGetOwner()){
                //TODO - >.<
            }
            else{ */
                if(!On){
                    lightsON();
                    //NOTE - TURN ON SOUND
                }
                else{
                    lightsOFF();
                    //NOTE - TURN OFF SOUND
                }
        /*         !On = On;
            }
        } */
    }

    listen(integer chan, string name, key id, string msg)
    {
        /* if(msg == "spotted"){
            if(!On){
                lightsON();
                //NOTE - TURN ON SOUND
            }
            else{
                lightsOFF();
                //NOTE - TURN OFF SOUND
            }
            !On = On;
        } */
    }

    timer()
    {
        llSensor("", "", AGENT, 10, PI);
    }
}