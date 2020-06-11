string pokeSound            = "f6d4dd62-c5ff-5007-b8f4-2603e3692b9c";
string particleTexture      = "419c3949-3f56-6115-5f1c-1f3aa85a4606";

integer dlgHandle = -1;
integer dlgChannel;
integer listenChannel = 0;
integer range = 4096;

list avatarList = [];
list avatarUUIDs = [];

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
    }
    
    touch_start(integer total_number)
    {
        llOwnerSay("Scanning...");
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, range, PI);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "poke"){
            llOwnerSay("Scanning...");
            avatarList = [];
            avatarUUIDs = [];
            llSensor("", NULL_KEY, AGENT, range, PI);
        }
    }

    //NEW SENSOR START--
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
            llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        }
        if (llGetListLength(avatarList) > 0)
          state dialog;
    }
    //NEW SENSOR END--
}
 
state dialog
{
    state_entry()
    {
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar.", avatarList, dlgChannel);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                string origName = llGetObjectName();
                list targetName = [];
                key targetKey;
                key ownerKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                ownerKey = llGetOwnerKey(llGetKey());
                llSetObjectName("");
                llInstantMessage(targetKey, llGetDisplayName(llGetOwner()) + " is trying to reach at you and poke you.\nWell hello there " + llGetDisplayName(targetKey) + "!\n I " + llGetDisplayName(llGetOwner()) + " just wanted to say you look amazing <3!\nSay hi to them @ secondlife:///app/agent/" + (string)ownerKey + "/im");
                llOwnerSay("Message sent to " + llGetDisplayName(targetKey));
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