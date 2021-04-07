key owner;
key g_kLeashedTo;
key g_kLeashToPoint;
key g_kParticleTarget;
key targetKey = NULL_KEY;

string Default_Start_Walking_Sound = "";
string Default_Walking_Sound = "";
string Default_Stop_Walking_Sound = "";

string sound_1 = "7b04c2ee-90d9-99b8-fd70-8e212a72f90d";
string sound_2 = "b442e334-cb8a-c30e-bcd0-5923f2cb175a";
string sound_3 = "1acaf624-1d91-a5d5-5eca-17a44945f8b0";
string sound_4 = "5ef4a0e7-345f-d9d1-ae7f-70b316e73742";
string sound_5 = "da186b64-db0a-bba6-8852-75805cb10008";
string sound_6 = "d4110266-f923-596f-5885-aaf4d73ec8c0";
string sound_7 = "5c6dd6bc-1675-c57e-0847-5144e5611ef9";
string sound_8 = "1dc1e689-3fd8-13c5-b57f-3fedd06b827a";
string sound_9 = "23e2a7d9-6dd1-6549-942c-feb4d591cc08";

string blackTexture = "790203ff-6b4f-c15c-70fc-1e95142e7225";
string whiteTexture = "9c6e07c4-52cb-be8f-9ba3-ccfef92ebe7f";

string API_Start_Sound;
string API_Stop_Sound;
string targetName = "";
string objectName = "Collar - Leash";

float DELAY = 0.5;
float RANGE = 3.0;
float TAU = 1.0;
float LIMIT = 60.0;

integer On              = TRUE;
integer sound1          = TRUE;
integer sound2          = FALSE;
integer sound3          = FALSE;
integer sound4          = FALSE;
integer sound5          = FALSE;
integer sound6          = FALSE;
integer sound7          = FALSE;
integer sound8          = FALSE;
integer walking         = FALSE;
integer leshedON        = FALSE;
integer announced       = FALSE;

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
integer g_iLoop;
list g_lLeashPrims;
integer g_bLeashActive = FALSE;
integer tid = 0;

float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float Volume_For_Bell = 0.2;
float seconds_to_check_when_avatar_walks = 0.01;

list main_menu;
list sounds_menu = [ "Bell 1", "Bell 2", "Bell 3", "Bell 4", "Bell 5", "Bell 6", "Bell 7", "Bell 8", "Back" ];
list textures_menu = ["Black", "White"];

key manager1UUID = "92d7a0cf-dbd1-44d1-b4ba-cc495767187a";
key manager2UUID = "1ffac40f-b1ea-41f9-b576-1993b96e36b2";
key manager3UUID = "076144a2-875c-4448-b0e2-ae7e4fa328d4";


menu(key _id)
{
    if (!leshedON){
        main_menu = ["Leash", "Sounds", "On/Off", "Textures", "Exit"];
    }
    else{
        main_menu = ["Unleash", "Sounds", "On/Off", "Textures", "Exit"];
    }
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    integer inv_num = llGetInventoryNumber(INVENTORY_NOTECARD);
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

soundsmenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    integer inv_num = llGetInventoryNumber(INVENTORY_NOTECARD);
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", sounds_menu, channel);
}

texturesmenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    integer inv_num = llGetInventoryNumber(INVENTORY_NOTECARD);
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", textures_menu, channel);
}

FindLinkedPrims()
{
    integer linkcount = llGetNumberOfPrims();
    for (g_iLoop = 2; g_iLoop <= linkcount; g_iLoop++){
        string sPrimDesc = (string)llGetObjectDetails(llGetLinkKey(g_iLoop), [OBJECT_DESC]);
        list lTemp = llParseString2List(sPrimDesc, ["~"], []);
        integer iLoop;
        for (iLoop = 0; iLoop < llGetListLength(lTemp); iLoop++){
            string sTest = llList2String(lTemp, iLoop);
            if (llGetSubString(sTest, 0, 9) == "leashpoint"){
                if (llGetSubString(sTest, 11, -1) == ""){
                    g_lLeashPrims += [sTest, (string)g_iLoop, "1"];
                }
                else{
                    g_lLeashPrims += [llGetSubString(sTest, 11, -1), (string)g_iLoop, "1"];
                }
            }
        }
    }
    /*if (!llGetListLength(g_lLeashPrims)){
        g_lLeashPrims = ["collar", LINK_THIS, "1"];
    }*/
}

string g_sParticleTexture = "chain";
string g_sParticleTextureID;
float g_fLeashLength;
vector g_vLeashColor = <1,1,1>;
vector g_vLeashSize = <0.07, 0.07, 1.0>;
integer g_bParticleGlow = TRUE;
float g_fParticleAge = 1.0;
float g_fParticleAlpha = 1.0;
vector g_vLeashGravity = <0.0,0.0,-1.0>;
integer g_iParticleCount = 1;
float g_fBurstRate = 0.04;
Particles(integer iLink, key kParticleTarget)
{
    if (kParticleTarget == NULL_KEY){
        return;
    }
    integer iFlags = PSYS_PART_FOLLOW_VELOCITY_MASK | PSYS_PART_TARGET_POS_MASK|PSYS_PART_FOLLOW_SRC_MASK;
    if (g_bParticleGlow) iFlags = iFlags | PSYS_PART_EMISSIVE_MASK;
    list lTemp = [
        PSYS_PART_MAX_AGE,g_fParticleAge,
        PSYS_PART_FLAGS,iFlags,
        PSYS_PART_START_COLOR, g_vLeashColor,
        PSYS_PART_START_SCALE,g_vLeashSize,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
        PSYS_SRC_BURST_RATE,g_fBurstRate,
        PSYS_SRC_ACCEL, g_vLeashGravity,
        PSYS_SRC_BURST_PART_COUNT,g_iParticleCount,
        PSYS_SRC_TARGET_KEY,kParticleTarget,
        PSYS_SRC_MAX_AGE, 0,
        PSYS_SRC_TEXTURE, g_sParticleTextureID
    ];
    llLinkParticleSystem(iLink, lTemp);
}

StartParticles(key kParticleTarget)
{
    for (g_iLoop = 0; g_iLoop < llGetListLength(g_lLeashPrims); g_iLoop = g_iLoop + 3){
        if ((integer)llList2String(g_lLeashPrims, g_iLoop + 2)){
            Particles((integer)llList2String(g_lLeashPrims, g_iLoop + 1), kParticleTarget);
        }
    }
    g_bLeashActive = TRUE;
}

StopParticles(integer iEnd)
{
    for (g_iLoop = 0; g_iLoop < llGetListLength(g_lLeashPrims); g_iLoop++){
        llLinkParticleSystem((integer)llList2String(g_lLeashPrims, g_iLoop + 1), []);
    }
    if (iEnd){
        g_bLeashActive = FALSE;
        g_kLeashedTo = NULL_KEY;
        g_kLeashToPoint = NULL_KEY;
        g_kParticleTarget = NULL_KEY;
        llSensorRemove();
    }
}

asLoadSounds()
{
    API_Start_Sound = "";
    API_Stop_Sound = "";
    integer i = 0;
    integer a = llGetInventoryNumber(INVENTORY_SOUND)-1;
    string name;
    do{
        name = llGetInventoryName(INVENTORY_SOUND, i);
        if(llStringLength(name) > 0){
            if(llSubStringIndex(name, sound_1) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_2) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_3) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_4) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_5) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_6) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_7) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_8) != -1)
                API_Start_Sound = name;
            else if(llSubStringIndex(name, sound_9) != -1)
                API_Start_Sound = name;
        }
    }
    while(i++<a);
}

key llGetObjectOwner()
{
    list details = llGetObjectDetails(llGetKey(), [OBJECT_OWNER]);
    return (key)llList2CSV(details);
}

init() 
{
    llListenRemove(listen_handle);
}

soundsOFF()
{
    walking = FALSE;
    llSetTimerEvent(seconds_to_check_when_avatar_walks);
}

stopFollowing()
{
  string origName = llGetObjectName();
  llTargetRemove(tid);
  llStopMoveToTarget();
  llSetTimerEvent(0.0);
  llSetObjectName(objectName);
  llOwnerSay("No longer following.");
  llSetObjectName(origName);
}

startFollowingName(string name)
{
  targetName = name;
  llSensor(targetName,NULL_KEY,AGENT,96.0,PI);
}

startFollowingKey(key id)
{
  string origName = llGetObjectName();
  targetKey = id;
  llSetObjectName(objectName);
  llSetObjectName(origName);
  keepFollowing();
  llSetTimerEvent(DELAY);
}

keepFollowing()
{
  llTargetRemove(tid);  
  llStopMoveToTarget();
  list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
  string origName = llGetObjectName();
  if (llGetListLength(answer)==0) {
    if (!announced){
      llSetObjectName(objectName);
      llOwnerSay(targetName+" seems to be out of range.  Waiting for return...");
      llSetObjectName(origName);
    }
    announced = TRUE;
  }
  else {
    announced = FALSE;
    vector targetPos = llList2Vector(answer,0);
    float dist = llVecDist(targetPos,llGetPos());
    if (dist>RANGE) {
      tid = llTarget(targetPos,RANGE);
      if (dist>LIMIT)
        targetPos = llGetPos() + LIMIT * llVecNorm( targetPos - llGetPos() );
      llMoveToTarget(targetPos,TAU);
    }
  }
}

default
{
    on_rez(integer s) 
    {
        init();
    }
    
    state_entry()
    {
        llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
        if(llGetAttached() != 0){
            llSetTimerEvent(seconds_to_check_when_avatar_walks);
            asLoadSounds();
        }
        else
            llSetTimerEvent(0);
        init();
        if (On)
            llOwnerSay("Bell is now On..");
        else
            llOwnerSay("Bell is now Off..");
    }
    
    changed(integer p)
    {
        if(llGetInventoryNumber(INVENTORY_SOUND) > 0)
            asLoadSounds();
    }
    
    touch_start(integer total_number)
    {
        integer i;
        key toucher_key = llDetectedKey(0);
        list username = llParseString2List(llGetDisplayName(toucher_key), [""], []);
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        for (i = 0;i < total_number;i += 1){
            llPlaySound(sound_9 , Volume_For_Bell);
            llWhisper(0, (string)username + " plays with the trinket on " + (string)owner +"'s collar.");
            if(toucher_key == llGetOwner())
                menu(toucher_key);
            else if(toucher_key == manager1UUID)
                menu(toucher_key);
            else if(toucher_key == manager2UUID)
                menu(toucher_key);
            else if(toucher_key == manager3UUID)
                menu(toucher_key);
            else
                return;
        }
    }

    listen(integer channel, string name, key id, string message) 
    {
        llListenRemove(listen_handle);
        if (message == "Exit")
            return;
        else if ((message == "Leash") || (message == "Unleash")){
            if(id == manager1UUID){
                if(leshedON)
                    stopFollowing();
                else
                    startFollowingKey(id);
                leshedON = !leshedON; //NOTE TRUE or FALSE ALREADY
            }
            else if(id == manager2UUID){
                if(leshedON)
                    stopFollowing();
                else
                    startFollowingKey(id);
                leshedON = !leshedON; //NOTE TRUE or FALSE ALREADY
            }
            else if(id == manager3UUID){
                if(leshedON)
                    stopFollowing();
                else
                    startFollowingKey(id);
                leshedON = !leshedON; //NOTE TRUE or FALSE ALREADY
            }
            else
                llWhisper(0, "no access!! (temp)");
        }
        else if (message == "On/Off")
        {
            if (On){
                llOwnerSay("Bell is now Off..");
                On = FALSE;
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = FALSE;
                sound8 = FALSE;
            }
            else{
                llOwnerSay("Bell is now On..");
                On = TRUE;
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = FALSE;
                sound8 = FALSE;
                menu(id);
            }
        }
        else if (message == "Sounds")
            soundsmenu(id);
        else if (message == "Textures")
            texturesmenu(id);
        else if (message == "Back")
            menu(id);
        else if (message == "Bell 1"){
            llOwnerSay("Bell 1 sound enabled..");
            sound1 = TRUE;
            sound2 = FALSE;
            sound3 = FALSE;
            sound4 = FALSE;
            sound5 = FALSE;
            sound6 = FALSE;
            sound7 = FALSE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 2"){
            llOwnerSay("Bell 2 sound enabled..");
            sound1 = FALSE;
            sound2 = TRUE;
            sound3 = FALSE;
            sound4 = FALSE;
            sound5 = FALSE;
            sound6 = FALSE;
            sound7 = FALSE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 3"){
            llOwnerSay("Bell 3 sound enabled..");
            sound1 = FALSE;
            sound2 = FALSE;
            sound3 = TRUE;
            sound4 = FALSE;
            sound5 = FALSE;
            sound6 = FALSE;
            sound7 = FALSE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 4"){
            llOwnerSay("Bell 4 sound enabled..");
            sound1 = FALSE;
            sound2 = FALSE;
            sound3 = FALSE;
            sound4 = TRUE;
            sound5 = FALSE;
            sound6 = FALSE;
            sound7 = FALSE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 5"){
            llOwnerSay("Bell 5 sound enabled..");
            sound1 = FALSE;
            sound2 = FALSE;
            sound3 = FALSE;
            sound4 = FALSE;
            sound5 = TRUE;
            sound6 = FALSE;
            sound7 = FALSE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 6"){
            llOwnerSay("Bell 6 sound enabled..");
            sound1 = FALSE;
            sound2 = FALSE;
            sound3 = FALSE;
            sound4 = FALSE;
            sound5 = FALSE;
            sound6 = TRUE;
            sound7 = FALSE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 7"){
            llOwnerSay("Bell 7 sound enabled..");
            sound1 = FALSE;
            sound2 = FALSE;
            sound3 = FALSE;
            sound4 = FALSE;
            sound5 = FALSE;
            sound6 = FALSE;
            sound7 = TRUE;
            sound8 = FALSE;
            soundsmenu(id);
        }
        else if (message == "Bell 8"){
            llOwnerSay("Bell 8 sound enabled..");
            sound1 = FALSE;
            sound2 = FALSE;
            sound3 = FALSE;
            sound4 = FALSE;
            sound5 = FALSE;
            sound6 = FALSE;
            sound7 = FALSE;
            sound8 = TRUE;
            soundsmenu(id);
        }
        else if (message == "Black"){
            llSetLinkTexture(LINK_THIS, blackTexture, ALL_SIDES);
            texturesmenu(id);
        }
        else if (message == "White"){
            llSetLinkTexture(LINK_THIS, whiteTexture, ALL_SIDES);
            texturesmenu(id);
        }
    }

    sensor(integer n)
    {
        startFollowingKey(llDetectedKey(0));
    }
    
    timer()
    {
        if(llGetAgentInfo(llGetObjectOwner()) & AGENT_WALKING){
            llSetTimerEvent(Walking_Sound_Speed);
            if(walking == FALSE){
                if(On == TRUE){
                    if (sound1 == TRUE)
                        llPlaySound(sound_1, Volume_For_Sounds);
                    else if (sound2 == TRUE)
                        llPlaySound(sound_2, Volume_For_Sounds);
                    else if (sound3 == TRUE)
                        llPlaySound(sound_3, Volume_For_Sounds);
                    else if (sound4 == TRUE)
                        llPlaySound(sound_4, Volume_For_Sounds);
                    else if (sound5 == TRUE)
                        llPlaySound(sound_5, Volume_For_Sounds);
                    else if (sound6 == TRUE)
                        llPlaySound(sound_6, Volume_For_Sounds);
                    else if (sound7 == TRUE)
                        llPlaySound(sound_7, Volume_For_Sounds);
                    else if (sound8 == TRUE)
                        llPlaySound(sound_8, Volume_For_Sounds);
                }
                else
                    soundsOFF();
                walking = TRUE;
                llSetTimerEvent(Walking_Sound_Speed);
            }
            else
                soundsOFF();
        }
        keepFollowing();
    }
}