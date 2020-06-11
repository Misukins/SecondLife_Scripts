float g_fVolume     = 0.1;
float g_fVolumeStep = 0.1;

float g_fSpeed      = 1.5;
float g_fSpeedStep  = 0.5;
float g_fSpeedMin   = 0.5;
float g_fSpeedMax   = 5.0;

float g_fNextRing;

integer g_iHasControl   = FALSE;
integer g_iBellOn       = FALSE;
integer channel;
integer listen_handle;

string BellSound = "23e2a7d9-6dd1-6549-942c-feb4d591cc08";
string BellWalkSound = "5c6dd6bc-1675-c57e-0847-5144e5611ef9";

/*
list g_listBellSounds=[
    "7b04c2ee-90d9-99b8-fd70-8e212a72f90d",
    "b442e334-cb8a-c30e-bcd0-5923f2cb175a",
    "1acaf624-1d91-a5d5-5eca-17a44945f8b0",
    "5ef4a0e7-345f-d9d1-ae7f-70b316e73742",
    "da186b64-db0a-bba6-8852-75805cb10008",
    "d4110266-f923-596f-5885-aaf4d73ec8c0",
    "5c6dd6bc-1675-c57e-0847-5144e5611ef9",
    "1dc1e689-3fd8-13c5-b57f-3fedd06b827a"
    ];
*/

list main_menu = [ "On", "Off", "Vol +", "Vol -", "Delay +", "Delay -", "Ring", "Reset", "Exit" ];

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
        llPreloadSound(BellSound);
        llPreloadSound(BellWalkSound);
        llSleep(0.5);
        llResetTime();
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key agent)
    {
        llRequestPermissions(agent, PERMISSION_TAKE_CONTROLS);
        if (agent){
            if(g_iBellOn == FALSE)
                g_iBellOn = TRUE;
            else
                g_iBellOn = FALSE;
        }
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu(id);
        integer i;
        for (i = 0;i < total_number;i += 1){
            string origName = llGetObjectName();
            list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
            list username = llParseString2List(llGetDisplayName(id), [""], []);
            if (id == llGetOwner()){
                llSetObjectName("");
                llSay(0, (string)owner_name + " plays with the trinket on her collar.");
                llSetObjectName(origName);
            }
            else{
                llSetObjectName("");
                llSay(0, (string)username + " plays with the trinket on " + (string)owner_name + "'s collar.");
                llSetObjectName(origName);
            }
            llPlaySound(BellSound, g_fVolume);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        key owner = llGetOwner();
        if (id == owner){
            if (message == "Exit")
                return;
            else if (message == "On"){
                if (g_iBellOn == FALSE){
                    if (!g_iHasControl){
                        llRequestPermissions(owner,PERMISSION_TAKE_CONTROLS);
                        llOwnerSay("The bell rings now.");
                        g_iBellOn = TRUE;
                    }
                }
            }
            else if (message=="Off"){
                if (g_iBellOn == TRUE){
                    g_iBellOn = FALSE;
                    if (g_iHasControl){
                        llReleaseControls();
                        g_iHasControl = FALSE;
                   }
                    llOwnerSay("The bell is now quiet.");
                }
            }
            else if (message == "Vol +")
            {
                g_fVolume+=g_fVolumeStep;
                if (g_fVolume>1.0)
                    g_fVolume=1.0;
                llOwnerSay("The volume of the bell is now: "+(string)((integer)(g_fVolume*10))+"/10.");
            }
            else if (message == "Vol -")
            {
                g_fVolume-=g_fVolumeStep;
                if (g_fVolume<0.1)
                    g_fVolume=0.1;
                llOwnerSay("The volume of the bell is now: "+(string)((integer)(g_fVolume*10))+"/10.");
            }
            else if (message == "Delay +")
            {
                g_fSpeed+=g_fSpeedStep;
                if (g_fSpeed>g_fSpeedMax)
                    g_fSpeed=g_fSpeedMax;
                llOwnerSay("The bell rings every " + llGetSubString((string)g_fSpeed,0,2) + " seconds when moving.");
            }
            else if (message == "Delay -")
            {
                g_fSpeed-=g_fSpeedStep;
                if (g_fSpeed<g_fSpeedMin)
                    g_fSpeed=g_fSpeedMin;
                llOwnerSay("The bell rings every " + llGetSubString((string)g_fSpeed,0,2) + " seconds when moving.");
            }
            else if (message=="Ring")
            {
                g_fNextRing=llGetTime()+g_fSpeed;
                llPlaySound(BellWalkSound,g_fVolume);
            }
            else if (message == "Reset")
                llResetScript();
        }
        else
            return;
    }

    control(key kID, integer nHeld, integer nChange)
    {
        if (!g_iBellOn)
            return;
        if (nHeld & (CONTROL_LEFT|CONTROL_RIGHT|CONTROL_DOWN|CONTROL_UP|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_FWD|CONTROL_BACK)){
            if (llGetTime()>g_fNextRing){
                g_fNextRing=llGetTime()+g_fSpeed;
                llPlaySound(BellWalkSound,g_fVolume);
            }
        }
    }

    run_time_permissions(integer nParam)
    {
        if(nParam & PERMISSION_TAKE_CONTROLS){
            llTakeControls( CONTROL_DOWN|CONTROL_UP|CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT, TRUE, TRUE);
            g_iHasControl=TRUE;
        }
    }
}