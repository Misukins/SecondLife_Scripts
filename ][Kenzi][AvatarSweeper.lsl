float distance = 5;
float speed = 4;
float seconds_per_clear = 5;

integer sweepedRight = FALSE;

vector starting_pos;

integer DEBUG = TRUE;

default
{
    state_entry()
    {
        llSetText("Setting up...", <0.58,0,0.83>, 1.0);
        state loadSettings;
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_exit()
    {
        llSetTimerEvent(0);
        llOwnerSay("Initialized.");
    }
}

state loadSettings
{
    state_entry()
    {
        llOwnerSay("Ready for Service!");
        llSetText("All Done!", <0.58,0,0.83>, 1.0);
        llSleep(1.0);
        llSetText("", <0.58,0,0.83>, 1.0);
        if (DEBUG)
           llOwnerSay("DEBUG: Stading by....");
        state ready;
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

        if(change & INVENTORY_NOTECARD)
            llResetScript();
    }
}

state ready
{
    state_entry()
    {
        if (DEBUG)
           llOwnerSay("DEBUG: RDY for another one!");
    }
    
    collision_start(integer num)
    {
        if(llDetectedType(0) & AGENT){
            sweepedRight = !sweepedRight;
            state start_moving;
        }
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
}

state start_moving
{
    on_rez(integer num)
    {
        llResetScript();
    }

    state_entry()
    {
        if (DEBUG)
            llOwnerSay("start_moving!");
        if(sweepedRight){
            llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_PRIM]);
            starting_pos = llGetPos();
            vector v = <-1.0, 0.0, 0.0>*llGetRot();
            vector destination = ZERO_VECTOR + v * distance;
            float dist = llVecDist(ZERO_VECTOR,destination);
            float speed = .2 + (dist / speed);
            llSetKeyframedMotion([destination,speed],[KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
            llSetTimerEvent(speed);
        }
        else{
            llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_PRIM]);
            starting_pos = llGetPos();
            vector v = <1.0, 0.0, 0.0>*llGetRot();
            vector destination = ZERO_VECTOR + v * distance;
            float dist = llVecDist(ZERO_VECTOR,destination);
            float speed = .2 + (dist / speed);
            llSetKeyframedMotion([destination,speed],[KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
            llSetTimerEvent(speed);
        }
    }

    timer()
    {
        state returnhome;
    }
}

state returnhome
{
    state_entry()
    {
        if (DEBUG)
            llOwnerSay("Returning home!");
        llSetKeyframedMotion([],[KFM_COMMAND, KFM_CMD_STOP]);
        llSetRegionPos(starting_pos);
        llSetTimerEvent(seconds_per_clear);
    }
    
    timer()
    {
        state ready;
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
}