key gOwner;
key unlocked    = "521c27d6-3ade-04bd-646f-22e84ce85947";
key locked      = "5571b284-297a-ce9a-f588-922cfdbbd129";

integer gUseMoveLock;
integer gRelockMoveLockAfterMovement;
integer gRelockIsUserMoving;

vector _redState    = <0.502, 0.000, 0.000>;
vector _whiteState  = <1.000, 1.000, 1.000>;

movelockMe(integer lock)
{
    if (lock){
        llMoveToTarget(llGetPos() - <0, 0, 0.1>, 0.05);
        llSetVehicleType(VEHICLE_TYPE_SLED);
        llSetVehicleFloatParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, 0.05);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 0.05);
        llOwnerSay("Movelock Activated!");
        llSetLinkColor(LINK_THIS, _redState, ALL_SIDES);
        llSetLinkTexture(LINK_THIS, locked, ALL_SIDES);
    }
    else{
        llStopMoveToTarget();
        llSetVehicleType(VEHICLE_TYPE_NONE);
        llOwnerSay("Movelock Deactivated!");
        llSetLinkColor(LINK_THIS, _whiteState, ALL_SIDES);
        llSetLinkTexture(LINK_THIS, unlocked, ALL_SIDES);
    }
}

default
{
    state_entry()
    {
        llSetLinkColor(LINK_THIS, _whiteState, ALL_SIDES);
        llSetLinkTexture(LINK_THIS, unlocked, ALL_SIDES);
    }
    
    touch_start(integer total_number)
    {
        if(!gUseMoveLock){
            gUseMoveLock = TRUE;
            movelockMe(TRUE);
        }
        else{
            gUseMoveLock = FALSE;
            movelockMe(FALSE);
        }
    }

    attach(key k)
    {
        if (k){
            gOwner = llGetOwner();
            llRequestPermissions(gOwner, PERMISSION_TAKE_CONTROLS);
            gUseMoveLock = FALSE;
            movelockMe(FALSE);
        }
    }

    run_time_permissions(integer i)
    {
        if (i & PERMISSION_TAKE_CONTROLS){
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN, TRUE, TRUE);
        }
    }

    control(key id, integer level, integer edge)
    {
        if (gUseMoveLock && gRelockMoveLockAfterMovement){
            if (level & (CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN)){
                if (!gRelockIsUserMoving){
                    gRelockIsUserMoving = TRUE;
                    movelockMe(FALSE);
                }
            }
            else if (gRelockIsUserMoving){
                gRelockIsUserMoving = FALSE;
                movelockMe(TRUE);
            }
        }
    }

    changed(integer change)
    {
        if (change & (CHANGED_INVENTORY)){
            movelockMe(gUseMoveLock);
        }
        else if (change & CHANGED_OWNER){
            llResetScript();
        }
    }
}
