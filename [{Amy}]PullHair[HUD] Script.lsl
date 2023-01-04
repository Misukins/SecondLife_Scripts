integer dlgHandle = -1;
integer dlgChannel;
integer listenChannel = 1;

integer channel;
integer listen_handle;

string origName = "[{Amy}]PullHair[HUD]";
string desc_    = "(c)Amy (meljonna Resident) -";

list avatarList = [];
list avatarUUIDs = [];

list main_menu      = [ "※MessHair", "※PullHair", "※PlayHair", "※Panties", "※Reset", "※Quit" ];

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
        llSetObjectDesc(desc_);
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        llParticleSystem([]);
        llListen(listenChannel, "", llGetOwner(), "");
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }

    listen(integer _channel, string name, key id, string message)
    {
        if (message == "※MessHair")
            state MessUp;
        else if (message == "※PullHair")
            state Pull;
        else if (message == "※PlayHair")
            state Play;
        else if (message == "※Panties")
            state Panties;
        else if (message == "※Reset")
            reset();
        else if (message == "※Quit")
            return;
    }
}

state MessUp
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
            state MessUpDialog;
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }

    listen(integer _channel, string name, key id, string message)
    {
        if (message == "※MessHair")
            state MessUpDialog;
        else if (message == "※Reset")
            resetInfo();
        else if (message == "※Quit")
            return;
    }
}

state MessUpDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["※Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to start over!");
    }

    listen(integer _channel, string name, key id, string message)
    {
        if ((_channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "※Cancel"){
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " messes up " + llGetDisplayName(targetKey) + "'s hair!");
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

    listen(integer _channel, string name, key id, string message)
    {
        if (message == "※PullHair")
            state PullDialog;
        else if (message == "※Reset")
            resetInfo();
        else if (message == "※Quit")
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
        avatarList += ["※Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to start over!");
    }

    listen(integer _channel, string name, key id, string message)
    {
        if ((_channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "※Cancel"){
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " pulls " + llGetDisplayName(targetKey) + "'s ponytail!");
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

    listen(integer _channel, string name, key id, string message)
    {
        if (message == "※PlayHair")
            state PlayDialog;
        else if (message == "※Reset")
            resetInfo();
        else if (message == "※Quit")
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
        avatarList += ["※Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to start over!");
    }

    listen(integer _channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "※Cancel"){
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " plays with " + llGetDisplayName(targetKey) + "'s hair!");
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

state Panties
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

    listen(integer _channel, string name, key id, string message)
    {
        if (message == "※Panties")
            state PantiesDialog;
        else if (message == "※Reset")
            resetInfo();
        else if (message == "※Quit")
            return;
    }
}

state PantiesDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["※Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to start over!");
    }

    listen(integer _channel, string name, key id, string message)
    {
        if ((_channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "※Cancel"){
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " steals " + llGetDisplayName(targetKey) + "'s panties!");
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