integer channel;
integer listen_handle;

integer gAttachPart = ATTACH_RHAND;
vector rez_pos = <1.5, 0.0, 0.02>;
float height_offset;
integer gDesiredPerm;
integer gHavePermissions;

float   gBulletSpeed = 15.0;

float   gLastFireTime = 0.01;
float   gTapReloadTime = 0.01;
float   gHoldReloadTime = 0.01;
integer swings;
vector  gEyeOffset = <0.0, 0.0, 0.75>;

key owner;

key smiteSound = "d7a9a565-a013-2a69-797d-5332baa1a947";
key swordSound = "f4a0660f-5446-dea2-80b7-6482a082803c";
//e19b1802-9dab-f9b0-5cbd-b3530e578908 <-- orig

list main_menu = [ "Smite", "Reset", "Exit" ];

integer dlgHandle = -1;
integer dlgChannel;

list avatarList = [];
list avatarUUIDs = [];

reset(){
    string origName = llGetObjectName();
    llSetTimerEvent(0.0);
    llListenRemove(dlgHandle);
    dlgHandle = -1;
    llSetObjectName(origName);
}

menu(key detectedKey){
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, channel);
}

default
{
    state_entry()
    {
        gHavePermissions = FALSE;
        gDesiredPerm = (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        llResetTime();
    }
    
    run_time_permissions(integer perm)
    {
        if ( (perm & gDesiredPerm) == gDesiredPerm )
        {
            gHavePermissions = TRUE;
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
    }
    
    on_rez(integer rez)
    {
        swings = 0;
        vector size = llGetAgentSize(llGetOwner());
        gEyeOffset.z = gEyeOffset.z * (size.z / 2.0);
    }

    attach(key av_key)
    {
        if (av_key != NULL_KEY)
        {
            if ( av_key != llGetOwner() )
                return;
            llRequestPermissions(av_key, gDesiredPerm);
        }
        else
        {
            if ( gHavePermissions )
            {
                llReleaseControls();
                llSetRot(<0.0, 0.0, 0.0, 1.0>);
                gHavePermissions = FALSE;
            }
        }
    }
    
    touch_start(integer tnum)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu(id);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "Smite")
            state Scan;
        else if (id == llGetOwner() && message == "Reset")
            llResetScript();
        else if (id == llGetOwner() && message == "Exit")
            return;
    }
    
    control(key owner, integer level, integer edge)
    {
        float time = llGetTime();
        if ( ( ((edge & level) & CONTROL_ML_LBUTTON) && (time > gTapReloadTime) ) || ( (time > gHoldReloadTime) && (level & CONTROL_ML_LBUTTON) ) )
        {
            if(swings = 3)
                swings = 0;
            llTriggerSound(swordSound, 1.0);
            llResetTime();
            swings = swings + 1;
            state Scan;
       }
    }
}

state Scan
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor( "", NULL_KEY, AGENT_BY_LEGACY_NAME, 20.0, PI );
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llList2String(llParseString2List(llDetectedName(i), [" "], [""]), 0)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
        }
        if (llGetListLength(avatarList) == 0){
            avatarList += ["Cancel"];
            llDialog(llGetOwner(), "Please select an avatar you want to smite", avatarList, dlgChannel);
        }
        if (llGetListLength(avatarList) > 0)
          state Dialog;
    }
}

state Dialog
{
    state_entry()
    {
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want to smite", avatarList, dlgChannel);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                string origName = llGetObjectName();
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " smites " + llGetDisplayName(targetKey) + "!");
                llTriggerSound(smiteSound, 1.0);
                llSetObjectName(origName);
            }
            reset();
            state default;
        }
    }
    
    timer()
    {
        reset();
        state default;
    }
}