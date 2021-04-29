key targetKey           = NULL_KEY;
/* key NULLKEY             = "";
key g_kLeashedTo        = ""; //NULLKEY;
key g_kLeashToPoint     = ""; //NULLKEY;
key g_kParticleTarget   = ""; //NULLKEY; */

float DELAY = 0.5;
float RANGE = 2.0;
float TAU = 1.0;
float LIMIT = 60.0;
float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float Volume_For_Bell = 0.2;
float seconds_to_check_when_avatar_walks = 0.01;
/* float g_fLeashLength;
float g_fParticleAge = 1.0;
float g_fParticleAlpha = 1.0;
float g_fBurstRate = 0.04; */

integer DEBUG           = FALSE;
integer WalkingSound;
integer walking         = FALSE;
integer leshedON        = FALSE;
integer announced       = FALSE;
/* integer g_bLeashedToAvi; */
integer ll_channel      = 665;

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
/* integer g_iLMListener;
integer g_iLMListernerDetach; */
integer tid = 0;

/* integer g_iParticleCount = 1;
integer g_bLeashActive;
integer g_iLoop;
integer g_bParticleGlow = TRUE;
integer g_bInvisibleLeash = FALSE;
integer COMMAND_PARTICLE = 20000;
integer LOCKMEISTER = -8888;

list g_lLeashPrims; */
list main_menu;
//list sounds_menu    = [ "Bell 1", "Back", "Exit"];
list textures_menu  = ["Black", "White", "Back", "Exit"];
list users_menu     = ["Add", "Remove", "List", "Clear", "Back", "Exit"];
list accessList     = [];

/* //NOTE Coming soon.. (walk sounds) with on/off option
string Default_Start_Walking_Sound = "";
string Default_Walking_Sound = "";
string Default_Stop_Walking_Sound = "";
*/

string sound_1 = "7b04c2ee-90d9-99b8-fd70-8e212a72f90d";
string sound_9 = "23e2a7d9-6dd1-6549-942c-feb4d591cc08";
/*
string sound_2 = "b442e334-cb8a-c30e-bcd0-5923f2cb175a";
string sound_3 = "1acaf624-1d91-a5d5-5eca-17a44945f8b0";
string sound_4 = "5ef4a0e7-345f-d9d1-ae7f-70b316e73742";
string sound_5 = "da186b64-db0a-bba6-8852-75805cb10008";
string sound_6 = "d4110266-f923-596f-5885-aaf4d73ec8c0";
string sound_7 = "5c6dd6bc-1675-c57e-0847-5144e5611ef9";
string sound_8 = "1dc1e689-3fd8-13c5-b57f-3fedd06b827a";
*/

string blackTexture = "790203ff-6b4f-c15c-70fc-1e95142e7225";
string whiteTexture = "9c6e07c4-52cb-be8f-9ba3-ccfef92ebe7f";

string API_Start_Sound;
string API_Stop_Sound;
string targetName = "";
string objectName = "(TEMP): Collar - Leash";
/* string CTYPE = "collar";
string g_sCheck; */

//TODO -START
/* string g_sParticleTexture;
string g_sParticleTextureID = "9a342cda-d62a-ae1f-fc32-a77a24a85d73"; */

/*
9a342cda-d62a-ae1f-fc32-a77a24a85d73 //Rope UUID
4cde01ac-4279-2742-71e1-47ff81cc3529 //Chain UUID
bd7d7770-39c2-d4c8-e371-0342ecf20921 //Transparent UUID
*/
//TODO -END

/* vector g_vLeashColor    = <1,1,1>;
vector g_vLeashSize     = <0.07, 0.07, 1.0>;
vector g_vLeashGravity  = <0.0,0.0,-1.0>; */

// TODO list START
/* //NOTE so far this works 100% but leash goesto Avi Center looks stupid!!
            i really need beer to finish this script :P
//F leash texture change
//F leash color change
//F link leash to collar LOGO

what else? oh
//F after teleport checks
//F range checks

//F CLEAN UP!!!
*/ //TODO list END

CheckMemory(){
    integer free_memory = llGetFreeMemory();
    llOwnerSay((string)free_memory + " bytes of free memory available for allocation.");
}

menu(key _id){
    if (!leshedON)
        main_menu = ["Leash", "Exit"];
    else
        main_menu = ["Unleash", "Exit"];
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

ownermenu(key _id){
    if(!WalkingSound)
        main_menu = ["On", "Textures", "Users", "Reset", "Exit"];
    else
        main_menu = ["Off", "Textures", "Users", "Reset", "Exit"];
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

texturesmenu(key _id){
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", textures_menu, channel);
}

usersmenu(key _id){
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", textures_menu, channel);
}

dumpAccessList(){
    llOwnerSay("current access list: " + llDumpList2String(accessList, ", "));
}

asLoadSounds(){
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
            else if(llSubStringIndex(name, sound_9) != -1)
                API_Start_Sound = name;
        }
    }
    while(i++<a);
}

key llGetObjectOwner(){
    list details = llGetObjectDetails(llGetKey(), [OBJECT_OWNER]);
    return (key)llList2CSV(details);
}

/* LMSay()
{
    llShout(LOCKMEISTER, (string)llGetOwnerKey(g_kLeashedTo) + "collar");
    llShout(LOCKMEISTER, (string)llGetOwnerKey(g_kLeashedTo) + "handle");
} */

/*
init(){
    //FindLinkedPrims();
    //StopParticles(TRUE);
    //llListen(COMMAND_PARTICLE,"","","");
    //llParticleSystem([]);
}
*/

soundsOFF(){
    walking = FALSE;
    llSetTimerEvent(seconds_to_check_when_avatar_walks);
}

stopFollowing(){
  string origName = llGetObjectName();
  llTargetRemove(tid);
  llStopMoveToTarget();
  llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
  llOwnerSay("No longer following.");
  llSetObjectName(origName);
}

startFollowingName(string name){
  targetName = name;
  llSensor(targetName,NULL_KEY,AGENT,96.0,PI);
}

startFollowingKey(key id){
  string origName = llGetObjectName();
  list username = llParseString2List(llGetDisplayName(id), [""], []);
  list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
  targetKey = id;
  llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
  llOwnerSay("You are now following " + (string)username + ".");
  llSetObjectName(origName);
  keepFollowing();
  llSetTimerEvent(DELAY);
}

keepFollowing(){
  llTargetRemove(tid);
  llStopMoveToTarget();
  list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
  string origName = llGetObjectName();
  if (llGetListLength(answer)==0)
    announced = TRUE;
  else{
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

debug(string sText){
    llOwnerSay(llGetScriptName() + " DEBUG: " + sText);
}

/* FindLinkedPrims()
{
    integer linkcount = llGetNumberOfPrims();
    for (g_iLoop = 2; g_iLoop <= linkcount; g_iLoop++)
    {
        string sPrimDesc = (string)llGetObjectDetails(llGetLinkKey(g_iLoop), [OBJECT_DESC]);
        list lTemp = llParseString2List(sPrimDesc, ["~"], []);
        integer iLoop;
        for (iLoop = 0; iLoop < llGetListLength(lTemp); iLoop++){
            string sTest = llList2String(lTemp, iLoop);
            if(DEBUG)
                debug(sTest);
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
    if (!llGetListLength(g_lLeashPrims))
    {
        g_lLeashPrims = ["collar", LINK_THIS, "1"];
        if(DEBUG)
            llOwnerSay("DEBUG: collar !llGetListLength (if we did not find any leashpoint... we unset the root as one)");
    }
}

Particles(integer iLink, key id)
{
    if (id == NULLKEY){
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
        PSYS_SRC_TARGET_KEY,id,
        PSYS_SRC_MAX_AGE, 0,
        PSYS_SRC_TEXTURE, g_sParticleTextureID
            ];
    llLinkParticleSystem(iLink, lTemp);
}

StartParticles(key id)
{
    for (g_iLoop = 0; g_iLoop < llGetListLength(g_lLeashPrims); g_iLoop = g_iLoop + 3){
        if ((integer)llList2String(g_lLeashPrims, g_iLoop + 2)){
            Particles((integer)llList2String(g_lLeashPrims, g_iLoop + 1), id);
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
        g_kLeashedTo = NULLKEY;
        g_kLeashToPoint = NULLKEY;
        g_kParticleTarget = NULLKEY;
        llSensorRemove();
    }
} */

default
{
    on_rez(integer s)
    {
        llResetScript();
    }

    state_entry()
    {
        //init();
        CheckMemory();
        globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
        llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
        llOwnerSay("Type /" +  (string)ll_channel + "menu for Menu");
        if(llGetAttached() != 0){
            llSetTimerEvent(seconds_to_check_when_avatar_walks);
            asLoadSounds();
        }
        else
            llSetTimerEvent(0);
        
        if (WalkingSound)
            llOwnerSay("Bell is now On..");
        else
            llOwnerSay("Bell is now Off..");
    }

    touch_start(integer total_number)
    {
        integer i;
        key toucher_key = llDetectedKey(0);
        list username = llParseString2List(llGetDisplayName(toucher_key), [""], []);
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        for (i = 0;i < total_number;i += 1){
            if(toucher_key == llGetOwner())
                ownermenu(toucher_key);
            else{
                key ownerKey = llGetOwner();
                string owneruser = llKey2Name(ownerKey);
                string avatar = llKey2Name(toucher_key);
                string origName = llGetObjectName();
                if (llListFindList(accessList, [avatar]) < 0 && toucher_key != ownerKey){
                    if(!DEBUG){
                        llSetObjectName("");
                        llOwnerSay((string)username + " touched your collar. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                        llSetObjectName(origName);
                        llInstantMessage(toucher_key, "Hello " + (string)username + ", you are not on the access list, ask secondlife:///app/agent/" + (string)ownerKey + "/about");
                    }
                    return;
                }
                else{
                    if(!DEBUG){
                        llPlaySound(sound_9, Volume_For_Bell);
                        llSetObjectName("");
                        llWhisper(0, (string)username + " plays with the trinket on " + (string)owner + "'s collar.");
                        llSetObjectName(origName);
                    }
                    menu(toucher_key);
                }
            }
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        //g_kParticleTarget = id;
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        llListenRemove(listen_handle);
        if (message == "Exit")
            return;
        else if ((message == "Leash") || (message == "Unleash")){
            if(leshedON){
                llInstantMessage(id, (string)owner + " is no longer following you.");
                //llMessageLinked(LINK_ALL_OTHERS, COMMAND_PARTICLE, "leash|" + (string)g_kParticleTarget, g_kLeashedTo);
                stopFollowing();
                //StopParticles(TRUE);
            }
            else{
                llInstantMessage(id, (string)owner + " is now following you.");
                //llMessageLinked(LINK_ALL_OTHERS, COMMAND_PARTICLE, "unleash", g_kLeashedTo);
                startFollowingKey(id);
                //StartParticles(g_kParticleTarget);
            }
            leshedON = !leshedON;
        }
        else if((message == "On") || (message == "Off")){
            if(!WalkingSound){
                llOwnerSay("Bell is now On..");
                WalkingSound = TRUE;
                ownermenu(id);
            }
            else{
                llOwnerSay("Bell is now Off..");
                WalkingSound = FALSE;
                ownermenu(id);
            }
            !WalkingSound = WalkingSound;
        }
        else if (message == "Textures")
            texturesmenu(id);
        else if (message == "Back")
            ownermenu(id);
        else if (message == "Black"){
            llSetLinkTexture(LINK_THIS, blackTexture, ALL_SIDES);
            texturesmenu(id);
        }
        else if (message == "White"){
            llSetLinkTexture(LINK_THIS, whiteTexture, ALL_SIDES);
            texturesmenu(id);
        }
        else if (message == "Users")
        {
            if(id == llGetOwner())
                state Owner;
            else
                return;
        }
        else if (message == "menu"){
            ownermenu(id);
        }
        else if (message == "Reset")
            llResetScript();
    }

    /* link_message(integer iSenderPrim, integer iNum, string sMessage, key kMessageID)
    {
        if (iNum == COMMAND_PARTICLE)
        {
            g_kLeashedTo = kMessageID;
            if (sMessage == "unleash"){
                StopParticles(TRUE);
                llListenRemove(g_iLMListener);
                llListenRemove(g_iLMListernerDetach);
            }
            else{
                if(DEBUG)
                    debug("leash active");
                if (! g_bInvisibleLeash){
                    integer bLeasherIsAv = (integer)llList2String(llParseString2List(sMessage, ["|"], [""]), 1);
                    g_kParticleTarget = g_kLeashedTo;
                    StartParticles(g_kParticleTarget);
                    if (bLeasherIsAv){
                        llListenRemove(g_iLMListener);
                        llListenRemove(g_iLMListernerDetach);
                        if (llGetSubString(sMessage, 0, 10)  == "leashhandle"){
                            g_iLMListener = llListen(LOCKMEISTER, "", "", (string)g_kLeashedTo + "handle ok");
                            g_iLMListernerDetach = llListen(LOCKMEISTER, "", "", (string)g_kLeashedTo + "handle detached");
                        }
                        else{
                            g_iLMListener = llListen(LOCKMEISTER, "", "", "");
                        }
                        LMSay();
                    }
                }
            }
        }
    } */

    attach(key kAttached)
    {
        if (kAttached == NULL_KEY){
            //TODO ---
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_TELEPORT){
            //TODO ---
        }
        if(llGetInventoryNumber(INVENTORY_SOUND) > 0)
            asLoadSounds();
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
                if(WalkingSound == TRUE)
                    llPlaySound(sound_1, Volume_For_Sounds);
                else
                    soundsOFF();
                walking = TRUE;
                llSetTimerEvent(Walking_Sound_Speed);
            }
            else
                soundsOFF();
        }
        if(leshedON)
            keepFollowing();
    }
}

state Owner
{
    state_entry()
    {
        llListen(1, "", llGetOwner(), "");
        llOwnerSay("type /1add (username) or if you wihs to remove users then type /1del (username)");
        dumpAccessList();
    }

    listen(integer channel, string name, key id, string message)
    {
        key targetKey;
        if (id == llGetOwner()){
            integer space = llSubStringIndex(message, " ");
            if (space > 0) {
                string command = llGetSubString(message, 0, space - 1);
                string avatar = llGetSubString(message, space + 1, -1);
                targetKey = llName2Key(avatar);
                if (command == "add"){
                    if (llListFindList(accessList, [avatar]) == -1) {
                        accessList = llListInsertList(accessList, [avatar], 0);
                        llOwnerSay("Added: " + avatar + " to access list");
                        llInstantMessage(targetKey, " secondlife:///app/agent/" + (string)id + "/about added you to her Collar");
                        state default;
                    }
                }
                else if (command == "del"){
                    integer pos = llListFindList(accessList, [avatar]);
                    if (pos >= 0) {
                        accessList = llDeleteSubList(accessList, pos, pos);
                        llOwnerSay("Added: " + avatar + " to access list");
                        llInstantMessage(targetKey, " secondlife:///app/agent/" + (string)id + "/about removed you from her Collar");
                        dumpAccessList();
                        state default;
                    }
                }
            }
        }
    }
}