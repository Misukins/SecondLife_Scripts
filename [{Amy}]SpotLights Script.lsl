float soundVolume       = 0.5;

integer lampChannel     = -77851641;
integer lampLongRange   = TRUE;
integer ownerOnly       = FALSE;
integer lampState;

string lampCmdOn        = "ON";
string lampCmdOff       = "OFF";

sayToLamps()
{
    string cmd;
    if(lampState){
        cmd=lampCmdOn;
    }
    else{
        cmd=lampCmdOff;
    }

    if(!lampLongRange){
        llSay(lampChannel, cmd);
    }
    else{
        llShout(lampChannel, cmd);
    }
}

setColor()
{
    string cmd;
    if(lampState){
        llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
    }
    else{
        llSetColor(<0.0, 0.0, 0.0>, ALL_SIDES);
    }
}

playSound()
{
    string soundName=llGetInventoryName(INVENTORY_SOUND, 0);
    if(soundName){
        llPlaySound(soundName, soundVolume);
    }
}

default
{
    touch_start(integer total_number)
    {
        if(!ownerOnly || llDetectedKey(0) == llGetOwner()){
            lampState = !lampState;
            sayToLamps();
            playSound();
            setColor();
        }
    }
}
