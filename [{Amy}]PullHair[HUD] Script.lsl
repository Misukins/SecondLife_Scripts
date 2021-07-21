integer dlgHandle = -1;
integer dlgChannel;
integer listenChannel = 1;

integer channel;
integer listen_handle;

string origName = "[{Amy}]PullHair[HUD]";

list avatarList = [];
list avatarUUIDs = [];

list main_menu      = [ "PullHair", "PlayHair", "Reset", "Exit" ];

menu()
{
    key detectedKey = llDetectedKey(0);
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, channel);
}

reset()
{
    llSetTimerEvent(0.0);
    llListenRemove(dlgHandle);
    dlgHandle = -1;
    llSetObjectName(origName);
}

resetInfo()
{
    llOwnerSay("Resetting: please what for few secs..");
    llSleep(3.0);
    llOwnerSay("I'm done now, please continue.");
    llResetScript();
}

default
{
    state_entry()
    {
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        llParticleSystem([]);
        llListen(listenChannel, "", llGetOwner(), "");
    }
    
    attach(key attached)
    {
        if(attached != NULL_KEY){
            llResetScript();
        }
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "PullHair")
            state Pull;
        else if (id == llGetOwner() && message == "PlayHair")
            state Play;
        else if (message == "Reset")
            reset();
        else if (message == "Exit")
            return;
    }
}

state Pull
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 15.0, PI);
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
          state PullDialog;
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "PullHair")
            state Pull;
        else if (id == llGetOwner() && message == "Reset")
            resetInfo();
        else if (id == llGetOwner() && message == "Exit")
            return;
    }
}
 
state PullDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to sctart over!");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " pulls " + llGetDisplayName(targetKey) + " ponytail!");
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

state Play
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 15.0, PI);
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
          state PlayDialog;
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "PlayHair")
            state Play;
        else if (id == llGetOwner() && message == "Reset")
            resetInfo();
        else if (id == llGetOwner() && message == "Exit")
            return;
    }
}
 
state PlayDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to sctart over!");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " plays with " + llGetDisplayName(targetKey) + " hair!");
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