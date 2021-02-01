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

default
{
    state_entry()
    {
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }

    touch_start(integer tnum)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            state ScanUserScripts;
    }
    
    link_message(integer from,integer to,string msg,key id)
    {
        if (msg == "reset_all")
            llResetScript();
    }
}

state ScanUserScripts
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
/*{
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
            llDialog(llGetOwner(), "Please select an avatar you want to Scan", avatarList, dlgChannel);
        }
        if (llGetListLength(avatarList) > 0)
          state Dialog;
    }
    
    link_message(integer from,integer to,string msg,key id)
    {
        if (msg == "reset_all")
            llResetScript();
    }
}
*/

state Dialog
{
    state_entry()
    {
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want to Scan", avatarList, dlgChannel);
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
                llOwnerSay(llGetDisplayName(llGetOwner()) + " rubs " + llGetDisplayName(targetKey) + "'s cheek with her soft Papi Paddle and whispers, this is just a taste papi.");
                llSetObjectName(origName);
            }
            reset();
            state default;
        }
    }
    
    link_message(integer from,integer to,string msg,key id)
    {
        if (msg == "reset_all")
            llResetScript();
    }
    
    timer()
    {
        reset();
        state default;
    }
}
