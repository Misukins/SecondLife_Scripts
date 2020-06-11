string confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

float soundVolume  = 1.0;

integer dlgHandle = -1;
integer dlgChannel;
integer gMenuPosition;
integer sensorRange = 4096;

list avatarList     = [];
list avatarUUIDs    = [];

integer DEBUG           = FALSE;

Menu()
{
    integer Last;
    list Buttons;
    integer All = llGetListLength(avatarList);
    if(gMenuPosition >= 9){
      Buttons += "◄";
      if((All - gMenuPosition) > 10)
        Buttons += "►";
      else
        Last = TRUE;          
    }    
    else if (All > gMenuPosition+9){
      if((All - gMenuPosition) > 10)
        Buttons += "►";
      else
        Last = TRUE;
    }
    else
      Last = TRUE;
    if (All > 0){
      integer b;
      integer len = llGetListLength(Buttons);     
      for(b = gMenuPosition + len + Last - 1 ; (len < 11)&&(b < All); ++b){
          Buttons = Buttons + [llList2String(avatarList,b)];
          len = llGetListLength(Buttons);
      }
    }
    dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
    llSetTimerEvent(30.0);
    Buttons += ["▼"];
    llDialog(llGetOwner(), "Please select an avatar you want to follow", Buttons, dlgChannel);
}

reset()
{
    string origName = llGetObjectName();
    llSetTimerEvent(0.0);
    llListenRemove(dlgHandle);
    dlgHandle = -1;
    llSetObjectName(origName);
}

default
{
    state_entry()
    {
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        llSetText("", <0.528, 0.528, 0.0>, 1);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: default");
    }

    on_rez(integer x)
    {
        llResetScript();
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            state Spying;
    }
}

state Spying
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, sensorRange, PI);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Spying");
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 64)){
            //if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llList2String(llParseString2List(llDetectedName(i), [""], []), 0)];
                avatarUUIDs += [llDetectedKey(i)];
            //}
            ++i;
        }
        if (llGetListLength(avatarList) > 0)
          state SpyingDialog;
    }
}
 
state SpyingDialog
{
    state_entry()
    {
        gMenuPosition = 0;
        Menu();
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: SpyingDialog");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "▼"){
                key targetKey;
                key ownerKey;
                //list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                string origName = llGetObjectName();
                list targetName = [];
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                ownerKey = llGetOwnerKey(llGetKey());
                list scriptInfo = llGetObjectDetails(targetKey, [OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_RUNNING_SCRIPT_COUNT, OBJECT_SCRIPT_TIME, OBJECT_SCRIPT_MEMORY]);
                string DName = llGetDisplayName(targetKey) + " (" + llKey2Name(targetKey) + ") Scripts: " + llList2String( scriptInfo, 1 ) + "/" + llList2String( scriptInfo, 0 );
                llSetObjectName("");
                if (llList2Integer(scriptInfo, 1) >= 100){
                    llSetText(DName + "\n [SHOULD BE KICKED]\nSending " + llGetDisplayName(targetKey) + " (" + llKey2Name(targetKey) + ") home in 30seconds!", <0.528, 0.528, 0.0>, 1);
                    llPlaySound(accessDeniedSound, soundVolume);
                    llSleep(30.0);
                    //llTeleportAgentHome(targetKey);
                    llSetText("", <1.000, 0.000, 0.000>, 1);
                }
                else{
                    llSetText(DName + "\n [SAFE]", <0.000, 1.00, 0.000>, 1);
                    llPlaySound(confirmedSound, soundVolume);
                    llSleep(5.0);
                    llSetText("", <0.528, 0.528, 0.0>, 1);
                }
                llSetObjectName(origName);
            }
            reset();
            state default;
        }

        if (~llSubStringIndex(message,"►")){
            gMenuPosition += 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Prev");
        }
        else if (~llSubStringIndex(message,"◄")){
            gMenuPosition -= 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Next");
        }
    }
    
    timer()
    {
        reset();
        state default;
    }
}