vector _greenState = <0.000, 0.502, 0.000>;
vector _redState = <0.502, 0.000, 0.000>;

key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";

integer listener;
integer channel;

integer cameraOn            = FALSE;
integer adultcamOn          = FALSE;
integer teencamOn           = FALSE;
integer childcamOn          = FALSE;
integer petitecamOn         = FALSE;
integer cinematiccamOn      = FALSE;
integer sitcamOn            = FALSE;
//integer sitOverride         = FALSE;

integer DEBUG               = TRUE;

string objName = "[{Amy}]Camera Mod v3";

debug(string message)
{
    if(DEBUG == TRUE)
        llOwnerSay("[DEBUG] " + message);
}

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

menu(key id)
{
    if (cameraOn == FALSE){
        list main_menu = [ "■ Off ■", "□ Cinema □", "□ Adult □", "□ Teen □", "□ Child □", "□ Petite □", "† STOP †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if ((adultcamOn == TRUE) && (cameraOn == TRUE)){
        list main_menu = [ "□ Off □", "□ Cinema □", "■ Adult ■", "□ Teen □", "□ Child □", "□ Petite □", "† STOP †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if ((teencamOn == TRUE) && (cameraOn == TRUE)){
        list main_menu = [ "□ Off □", "□ Cinema □", "□ Adult □", "■ Teen ■", "□ Child □", "□ Petite □", "† STOP †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if ((childcamOn == TRUE) && (cameraOn == TRUE)){
        list main_menu = [ "□ Off □", "□ Cinema □", "□ Adult □", "□ Teen □", "■ Child ■", "□ Petite □", "† STOP †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if ((petitecamOn == TRUE) && (cameraOn == TRUE)){
        list main_menu = [ "□ Off □", "□ Cinema □", "□ Adult □", "□ Teen □", "□ Child □", "■ Petite ■", "† STOP †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if ((cinematiccamOn == TRUE) && (cameraOn == TRUE)){
        list main_menu = [ "□ Off □", "■ Cinema ■", "□ Adult □", "□ Teen □", "□ Child □", "□ Petite □", "† STOP †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
}

default_cam()
{
    llClearCameraParams();
    llSetCameraParams([CAMERA_ACTIVE, 1]);
}

off_cam(key agent)
{
    llSetLinkColor(LINK_THIS, _redState, ALL_SIDES);
    llPlaySound(_sound_off, 0.4);
    info("Camera Mod Disabled.");
    llSetCameraParams([CAMERA_ACTIVE, 0]);
    llReleaseCamera(agent);
    cameraOn = FALSE;
}

cinematic_cam()
{
    vector camPos = llGetPos();
    vector camFocus = llGetPos();
    llSetLinkColor(LINK_THIS, _greenState, ALL_SIDES);
    info("Cinematic Camera Enabled.");
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_FOCUS, camFocus,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_POSITION, camPos,
        CAMERA_POSITION_LOCKED, FALSE
    ]);
    cameraOn        = TRUE;
    adultcamOn      = FALSE;
    teencamOn       = FALSE;
    childcamOn      = FALSE;
    petitecamOn     = FALSE;
    sitcamOn        = FALSE;
    cinematiccamOn  = TRUE;
}

adult_cam()
{
    llSetLinkColor(LINK_THIS, _greenState, ALL_SIDES);
    info("Adult Camera Enabled.");
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.0,
        CAMERA_DISTANCE, 1.5,
        CAMERA_FOCUS_LAG, 0.01 ,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,
        CAMERA_PITCH, 10.0,
        CAMERA_POSITION_LAG, 0.1,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0,
        CAMERA_FOCUS_OFFSET, <-0.5,0,0.50>
    ]);
    cameraOn        = TRUE;
    adultcamOn      = TRUE;
    teencamOn       = FALSE;
    childcamOn      = FALSE;
    petitecamOn     = FALSE;
    sitcamOn        = FALSE;
    cinematiccamOn  = FALSE;
}

teen_cam()
{
    llSetLinkColor(LINK_THIS, _greenState, ALL_SIDES);
    info("Teen Camera Enabled.");
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.0,
        CAMERA_DISTANCE, 1.5,
        CAMERA_FOCUS_LAG, 0.01,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,
        CAMERA_PITCH, 5.0,
        CAMERA_POSITION_LAG, 0.1,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0,
        CAMERA_FOCUS_OFFSET, <-0.5,0,0.40>
    ]);
    cameraOn        = TRUE;
    adultcamOn      = FALSE;
    teencamOn       = TRUE;
    childcamOn      = FALSE;
    petitecamOn     = FALSE;
    sitcamOn        = FALSE;
    cinematiccamOn  = FALSE;
}

child_cam()
{
    llSetLinkColor(LINK_THIS, _greenState, ALL_SIDES);
    info("Child Camera Enabled.");
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.0,
        CAMERA_DISTANCE, 1.0,
        CAMERA_FOCUS_LAG, 0.01 ,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,
        CAMERA_PITCH, 10.0,
        CAMERA_POSITION_LAG, 0.1,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0,
        CAMERA_FOCUS_OFFSET, <-0.5,0,0.25>
    ]);
    cameraOn        = TRUE;
    adultcamOn      = FALSE;
    teencamOn       = FALSE;
    childcamOn      = TRUE;
    petitecamOn     = FALSE;
    sitcamOn        = FALSE;
    cinematiccamOn  = FALSE;
}

petite_cam()
{
    llSetLinkColor(LINK_THIS, _greenState, ALL_SIDES);
    info("Petite Camera Enabled.");
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.0,
        CAMERA_DISTANCE, 1.0,
        CAMERA_FOCUS_LAG, 0.01 ,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,
        CAMERA_PITCH, 10.0,
        CAMERA_POSITION_LAG, 0.1,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0,
        CAMERA_FOCUS_OFFSET, <-0.1,0,0.0001>
    ]);
    cameraOn        = TRUE;
    adultcamOn      = FALSE;
    teencamOn       = FALSE;
    childcamOn      = FALSE;
    petitecamOn     = TRUE;
    sitcamOn        = FALSE;
    cinematiccamOn  = FALSE;
}

sitting()
{
    string curAnimState = llGetAnimation(llGetOwner());
    if (curAnimState == "Sitting"){
        debug("Sitting");
        sit_cam();
    }
}

sit_cam()
{
    llSetLinkColor(LINK_THIS, _redState, ALL_SIDES);
    info("Sitting Camera Enabled.");
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.0,
        CAMERA_DISTANCE, 1.5,
        CAMERA_FOCUS_LAG, 0.01 ,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,
        CAMERA_PITCH, 10.0,
        CAMERA_POSITION_LAG, 0.1,
        CAMERA_POSITION_LOCKED, TRUE,
        CAMERA_POSITION_THRESHOLD, 0.0,
        CAMERA_FOCUS_OFFSET, <-0.5,0,0.50>
    ]);
    cameraOn        = TRUE;
    adultcamOn      = FALSE;
    teencamOn       = FALSE;
    childcamOn      = FALSE;
    petitecamOn     = FALSE;
    sitcamOn        = TRUE;
    cinematiccamOn  = FALSE;
}

reset_cam()
{
    info("Camera Reset.");
    llResetScript();
}

default
{
    state_entry()
    {
        llSetObjectName(objName);
        llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);
        llPreloadSound(_sound_on);
        llPreloadSound(_sound_off);
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner())
            menu(llGetOwner());
    }

    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(channel);
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (message == "□ Adult □"){
                adult_cam();
                llTriggerSound(_sound_on, 0.4);
                return;
            }
            else if (message == "□ Teen □"){
                teen_cam();
                llTriggerSound(_sound_on, 0.4);
                return;
            }
            else if (message == "□ Child □"){
                child_cam();
                llTriggerSound(_sound_on, 0.4);
                return;
            }
            else if (message == "□ Petite □"){
                petite_cam();
                llTriggerSound(_sound_on, 0.4);
                return;
            }
            else if (message == "□ Cinema □"){
                cinematic_cam();
                llTriggerSound(_sound_on, 0.4);
                return;
            }
            else if (message == "□ Off □"){
                off_cam(id);
                llTriggerSound(_sound_on, 0.4);
                return;
            }
            else if (message == "† Reset †"){
                llMessageLinked(LINK_SET, 0, "RESET", NULL_KEY);
                llTriggerSound(_sound_on, 0.4);
                reset_cam();
            }
            else if (message == "† STOP †"){
                llTriggerSound(_sound_on, 0.4);
                state stopAnims;
            }
            else{
                llTriggerSound(_sound_on, 0.4);
                return;
            }
        }
        else
            return;
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_CONTROL_CAMERA)
            llSetCameraParams([CAMERA_ACTIVE, 1]);
        else{
           llResetScript();
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
        if (change & CHANGED_LINK){
            key agent = llAvatarOnSitTarget();
            if (agent){
                llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
                sit_cam();
            }
            else{
                llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
                if(adultcamOn == TRUE)
                    adult_cam();
                else if (teencamOn == TRUE)
                    teen_cam();
                else if (childcamOn == TRUE)
                    child_cam();
                else if (petitecamOn == TRUE)
                    petite_cam();
                else if(cinematiccamOn == TRUE)
                    cinematic_cam();
                else
                    off_cam(agent);
            }
        }
    }

    attach(key agent)
    {
        if (agent){
            llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
            if(adultcamOn == TRUE)
                adult_cam();
            else if (teencamOn == TRUE)
                teen_cam();
            else if (childcamOn == TRUE)
                child_cam();
            else if (petitecamOn == TRUE)
                petite_cam();
            else if(cinematiccamOn == TRUE)
                cinematic_cam();
            else
                off_cam(agent);
        }
    }
}

state stopAnims
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            list anims = llGetAnimationList(llGetOwner());
            integer n;
            for(n = 0; n < llGetListLength(anims) ;n++){
                llStopAnimation(llList2String(anims, n));
                llSleep(0.2);
            }
            llOwnerSay((string)n + " Animations Stopped");
            state default;
        }
        else{
            llOwnerSay("Sorry, i need permission to be able to stop the animations");
            state default;
        }
    }
}