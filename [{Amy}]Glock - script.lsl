key shootSound = "7191b199-0b04-dac0-324b-1d133937b856";

float BULLET_VELOCITY = 30.0;
float REPEAT_DELAY = 0.15;

integer holsterChan = -987544;
integer isHolstered = TRUE;

rotation rot;

vector pos;
vector offset;

HolsteredON()
{
    isHolstered = TRUE;
    llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
    llStopAnimation("hold_R_handgun");
    llReleaseControls();
}

HolsteredOFF()
{
    isHolstered = FALSE;
    llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
    llStartAnimation("hold_R_handgun");
}

default
{
    state_entry() 
    {
        llPreloadSound(shootSound);
        llListen(holsterChan, "", "", "");
    }

    run_time_permissions(integer perm)
    {
        if (perm){
            llAttachToAvatar(ATTACH_RHAND);
            if(!isHolstered)
                HolsteredON();
            else
                HolsteredOFF();
            //llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
    }
    
    attach(key on)
    {
        if (on != NULL_KEY){
            integer perm = llGetPermissions();
            if (perm != (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH))
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH);
            else{
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
                HolsteredOFF();
            }
        }
        else{
            llTakeControls(FALSE, TRUE, FALSE);
            HolsteredON();
        }
    }
        
    control(key owner, integer level, integer edge)
    {
        if ((level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON){
            if ((edge & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON){
                //llLoopSound("gun", 2.0);
                llTriggerSound(shootSound, 1.0);
                pos = llGetPos();
                rot = llGetRot();
                offset = <1.0, 0.0, 0.0>;
                offset *= rot;
                pos += offset;
                llPointAt(pos); 
            }
            pos = llGetPos();
            rot = llGetRot();
            offset = <1.0, 0.0, 0.0>;
            offset *= rot;
            pos += offset;
            llPointAt(pos); 
            vector fwd = llRot2Fwd(rot);
            fwd *= BULLET_VELOCITY; 
            integer i = 5;
            rot *= llEuler2Rot(<0, PI_BY_TWO, 0>);
            llRezObject("Bullet 1.0", pos, fwd, rot, 1);
            llSleep(REPEAT_DELAY);
        }
        else{
            if ((edge & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON){
                //llLoopSound("gun", 0.0);
                llTriggerSound(shootSound, 1.0);
                llStopPointAt();
            }  
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(msg == "holstered"){
            if(!isHolstered)
                HolsteredON();
            else
                HolsteredOFF();
        }
    }
}