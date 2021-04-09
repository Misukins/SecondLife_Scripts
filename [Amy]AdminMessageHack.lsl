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
            state Scan;
    }
}

state Scan
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 20.0, PI);
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llDetectedName(i)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
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
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
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
                llTextBox(targetID, "This is your Princess speaking, and i'm the law here" + llGetDisplayName(targetKey) + "!", channel);
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