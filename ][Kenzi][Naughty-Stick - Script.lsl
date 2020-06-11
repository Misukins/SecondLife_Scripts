string pokeSound            = "f6d4dd62-c5ff-5007-b8f4-2603e3692b9c";
string spankSound           = "475a3e83-6801-49c6-e7ad-d6386b2ecc29";
string particleTexture      = "419c3949-3f56-6115-5f1c-1f3aa85a4606";

integer dlgHandle = -1;
integer dlgChannel;
integer listenChannel = 1;

integer channel;
integer listen_handle;

integer DEBUG = FALSE;

list avatarList = [];
list avatarUUIDs = [];

list main_menu = [ "poke", "spank", "smack", "boss", "fakedom", "reset", "exit" ];

menu()
{
    key detectedKey = llDetectedKey(0);
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, channel);
}

MakeParticles(key targetKey)
{
    llParticleSystem([
        PSYS_PART_FLAGS,            0,
        PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
        PSYS_PART_START_COLOR,      <1, 1, 1>,
        PSYS_PART_END_COLOR,        <1, 1, 1>,
        PSYS_PART_START_ALPHA,      0.8,
        PSYS_PART_END_ALPHA,        0.3,
        PSYS_PART_START_SCALE,      <0.05, 0.05, 0.05>,
        PSYS_PART_END_SCALE,        <0.01, 0.01, 0.01>,    
        PSYS_PART_MAX_AGE,          1.5,
        PSYS_SRC_ACCEL,             <1.05, 1.05, 1.05>,
        PSYS_SRC_TEXTURE,           particleTexture,
        PSYS_SRC_BURST_RATE,        5.0,
        PSYS_SRC_INNERANGLE,        0,
        PSYS_SRC_OUTERANGLE,        0,
        PSYS_SRC_BURST_PART_COUNT,  5,      
        PSYS_SRC_BURST_RADIUS,      0.5,
        PSYS_SRC_BURST_SPEED_MIN,   1.05,
        PSYS_SRC_BURST_SPEED_MAX,   1.1, 
        PSYS_SRC_MAX_AGE,           0.0,
        PSYS_SRC_TARGET_KEY,        targetKey,
        PSYS_SRC_OMEGA,             <0, 0, 1>   ]);
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
        llParticleSystem([]);
        llListen(listenChannel, "", llGetOwner(), "");
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: default");
    }
    
    attach(key attached)
    {
        if(attached != NULL_KEY){
            llOwnerSay("Touch the Stick or type /1poke /1spank /1smack /1boss /1fakedom");
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
        if (id == llGetOwner() && message == "poke")
            state Poke;
        else if (id == llGetOwner() && message == "spank")
            state Spank;
        else if (id == llGetOwner() && message == "smack")
            state Smack;
        else if (id == llGetOwner() && message == "fakedom")
            state fakeDom;
        else if (id == llGetOwner() && message == "boss")
            state Boss;
        else if (id == llGetOwner() && message == "reset")
            llResetScript();
        else if (id == llGetOwner() && message == "exit")
            return;
    }
}

state Poke
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        llOwnerSay("Scanning...");
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 15.0, PI);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Poke");
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
          state PokeDialog;
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "poke")
            state Poke;
        else if (id == llGetOwner() && message == "spank")
            state Spank;
        else if (id == llGetOwner() && message == "smack")
            state Smack;
        else if (id == llGetOwner() && message == "fakedom")
            state fakeDom;
        else if (id == llGetOwner() && message == "boss")
            state Boss;
        else if (id == llGetOwner() && message == "reset")
            llResetScript();
        else if (id == llGetOwner() && message == "exit")
            return;
    }
}
 
state PokeDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want to poke", avatarList, dlgChannel);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: PokeDialog");
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
                llTriggerSound(pokeSound, 1.0);
                llSay(0, llGetDisplayName(llGetOwner()) + " pokes " + llGetDisplayName(targetKey) + " with their stick!");
                MakeParticles(targetKey);
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

state Spank
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        llOwnerSay("Scanning...");
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
          state SpankDialog;
        else
            llOwnerSay("There is nobody around you!");
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "poke")
            state Poke;
        else if (id == llGetOwner() && message == "spank")
            state Spank;
        else if (id == llGetOwner() && message == "smack")
            state Smack;
        else if (id == llGetOwner() && message == "fakedom")
            state fakeDom;
        else if (id == llGetOwner() && message == "boss")
            state Boss;
        else if (id == llGetOwner() && message == "reset")
            llResetScript();
        else if (id == llGetOwner() && message == "exit")
            return;
    }
}

state SpankDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want to spank.", avatarList, dlgChannel);
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
                llTriggerSound(spankSound, 0.7);
                llSay(0, llGetDisplayName(llGetOwner()) + " spanks " + llGetDisplayName(targetKey) + "'s ass with their stick, making it go red!");
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

state Smack
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        llOwnerSay("Scanning...");
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
          state SmackDialog;
        else
            llOwnerSay("There is nobody around you!");
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "poke")
            state Poke;
        else if (id == llGetOwner() && message == "spank")
            state Spank;
        else if (id == llGetOwner() && message == "smack")
            state Smack;
        else if (id == llGetOwner() && message == "fakedom")
            state fakeDom;
        else if (id == llGetOwner() && message == "boss")
            state Boss;
        else if (id == llGetOwner() && message == "reset")
            llResetScript();
        else if (id == llGetOwner() && message == "exit")
            return;
    }
}

state SmackDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want to smack.", avatarList, dlgChannel);
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
                llTriggerSound(spankSound, 0.7);
                llSay(0, llGetDisplayName(llGetOwner()) + " smacks hard " + llGetDisplayName(targetKey) + "'s face with their stick!");
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

state fakeDom
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        llOwnerSay("Scanning...");
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
          state fakeDomDialog;
        else
            llOwnerSay("There is nobody around you!");
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "poke")
            state Poke;
        else if (id == llGetOwner() && message == "spank")
            state Spank;
        else if (id == llGetOwner() && message == "smack")
            state Smack;
        else if (id == llGetOwner() && message == "fakedom")
            state fakeDom;
        else if (id == llGetOwner() && message == "boss")
            state Boss;
        else if (id == llGetOwner() && message == "reset")
            llResetScript();
        else if (id == llGetOwner() && message == "exit")
            return;
    }
}

state fakeDomDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar to fakeDom them.", avatarList, dlgChannel);
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
                llTriggerSound(spankSound, 0.7);
                llSay(0, "a real boss bitch " + llGetDisplayName(llGetOwner()) + ", knocks the fake off from " + llGetDisplayName(targetKey) + ", this sad pathetic wanna be fake dom.");
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

state Boss
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        llOwnerSay("Scanning...");
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
          state bossDialog;
        else
            llOwnerSay("There is nobody around you!");
    }
    
    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "poke")
            state Poke;
        else if (id == llGetOwner() && message == "spank")
            state Spank;
        else if (id == llGetOwner() && message == "smack")
            state Smack;
        else if (id == llGetOwner() && message == "fakedom")
            state fakeDom;
        else if (id == llGetOwner() && message == "boss")
            state Boss;
        else if (id == llGetOwner() && message == "reset")
            llResetScript();
        else if (id == llGetOwner() && message == "exit")
            return;
    }
}

state bossDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar to fakeDom them.", avatarList, dlgChannel);
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
                llTriggerSound(spankSound, 0.7);
                llSay(0, llGetDisplayName(llGetOwner()) + " slaps " + llGetDisplayName(targetKey) + " the boss wanna be with her real boss bitch stick ... sit down ho, I got you!!!!!!!!");
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
