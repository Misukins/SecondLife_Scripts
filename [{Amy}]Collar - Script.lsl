key targetKey           = NULL_KEY;
key NULLKEY             = "";
key g_kLeashedTo        = ""; //NULLKEY;
key g_kLeashToPoint     = ""; //NULLKEY;
key g_kParticleTarget   = ""; //NULLKEY;

float DELAY = 0.5;
float RANGE = 2.0;
float TAU = 1.0;
float LIMIT = 60.0;
float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float Volume_For_Bell = 0.2;
float seconds_to_check_when_avatar_walks = 0.01;
float g_fLeashLength;
float g_fParticleAge = 1.0;
float g_fParticleAlpha = 1.0;
float g_fBurstRate = 0.04;

integer DEBUG           = FALSE;
integer WalkingSound;
integer walking         = FALSE;
integer leshedON        = FALSE;
integer announced       = FALSE;
integer g_bLeashedToAvi;
integer ll_channel      = 665;
integer adminChannel    = 1;
integer adminChannel_Active = FALSE;

key g_kWearer;
integer g_iLastRank;
integer g_bFollowMode;
string g_sScript="leash_";
integer POPUP_HELP          = 1001;
integer LM_SETTING_SAVE             = 2000; // to have settings saved to httpdb
integer LM_SETTING_REQUEST          = 2001; // send requests for settings on this channel
integer LM_SETTING_RESPONSE         = 2002; // responses received on this channel
integer LM_SETTING_DELETE           = 2003; // delete token from DB
integer LM_SETTING_EMPTY            = 2004;
vector g_vPos = ZERO_VECTOR;
integer g_iTargetHandle;
integer g_iLength = 3;
string TOK_LENGTH   = "leashlength";
string TOK_DEST     = "leashedto"; // format: uuid,rank
list g_lOwners=[];
integer RLV_CMD = 6000;
integer g_iLeasherInRange=FALSE;
integer g_iStrictModeOn=FALSE;
integer COMMAND_EVERYONE    = 504;
key g_kCmdGiver;
integer COMMAND_OWNER       = 500;
integer COMMAND_GROUP       = 502;
integer COMMAND_WEARER      = 503;
integer g_iRLVOn=FALSE;







integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
integer g_iLMListener;
integer g_iLMListernerDetach;
integer tid = 0;

integer g_iParticleCount = 1;
integer g_bLeashActive;
integer g_iLoop;
integer g_bParticleGlow = TRUE;
integer g_bInvisibleLeash = FALSE;
integer Use_Particles = 20000;
integer LockParticles = -8888;

list g_lLeashPrims;
list main_menu;
//list sounds_menu    = [ "Bell 1", "Back", "▼"];
list textures_menu  = ["Black", "White", "Back", "▼"];
//list users_menu     = ["Add", "Remove", "List", "Clear", "Back", "▼"];
list accessList;

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
string CTYPE = "collar";
string g_sCheck;
string g_sWearer;
string g_sWearerFirstName;

//TODO -START
string g_sParticleTexture;
string g_sParticleTextureID = "9a342cda-d62a-ae1f-fc32-a77a24a85d73";

/*
9a342cda-d62a-ae1f-fc32-a77a24a85d73 //Rope UUID
4cde01ac-4279-2742-71e1-47ff81cc3529 //Chain UUID
bd7d7770-39c2-d4c8-e371-0342ecf20921 //Transparent UUID
*/
//TODO -END

vector g_vLeashColor    = <1,1,1>;
vector g_vLeashSize     = <0.07, 0.07, 1.0>;
vector g_vLeashGravity  = <0.0,0.0,-1.0>;

// TODO list START
/* //NOTE so far this works 100% but leash goesto Avi Center looks stupid!!
            i really need beer to finish this script :P
//FIX leash texture change
//FIX leash color change
//FIX link leash to collar LOGO

what else? oh
//FIX after teleport checks
//FIX range checks

//FIX CLEAN UP!!!
*/ //TODO list END

CheckMemory(){
    integer free_memory = llGetFreeMemory();
    llOwnerSay((string)free_memory + " bytes of free memory available for allocation.");
}

menu(key _id){
    if (!leshedON)
        main_menu = ["Leash", "▼"];
    else
        main_menu = ["Unleash", "▼"];
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

ownermenu(key _id){
    if(!WalkingSound)
        main_menu = ["On", "Textures", "Users", "List", "Reset", "▼"];
    else
        main_menu = ["Off", "Textures", "Users", "List", "Reset", "▼"];
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
    llOwnerSay("current access list: " + llDumpList2String(accessList, ".\n "));
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

LMSay(){
    llShout(LockParticles, (string)llGetOwnerKey(g_kLeashedTo) + "collar");
    llShout(LockParticles, (string)llGetOwnerKey(g_kLeashedTo) + "handle");
}

init(){
    FindLinkedPrims();
    StopParticles(TRUE);
    llListen(Use_Particles, "", "", "");
    llListen(1, "", llGetOwner(), "");
    llParticleSystem([]);
}

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

FindLinkedPrims()
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
        g_lLeashPrims = ["leashpoint", LINK_THIS, "1"];
        if(DEBUG)
            llOwnerSay("DEBUG: collar !llGetListLength");
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
}

Notify(key kID, string sMsg, integer iAlsoNotifyWearer){
    if (kID == g_kWearer) {
        llOwnerSay(sMsg);
    } else {
        llInstantMessage(kID, sMsg);
        if (iAlsoNotifyWearer) {
            llOwnerSay(sMsg);
        }
    }
}

integer CheckCommandAuth(key kCmdGiver, integer iAuth){
    // Check for invalid auth
    if (iAuth < COMMAND_OWNER && iAuth > COMMAND_WEARER) return FALSE;
    
    // If leashed, only move leash if Comm Giver outranks current leasher
    if (g_kLeashedTo != NULL_KEY && iAuth > g_iLastRank){
        Notify(kCmdGiver, "Sorry, someone who outranks you on " + g_sWearer +"'s " + CTYPE + " leashed " + g_sWearerFirstName + " already.", FALSE);
        return FALSE;
    }
    return TRUE;
}

ApplyRestrictions(){
    //Debug("Applying Restrictions");
    if (g_iLeasherInRange){
        if (g_iStrictModeOn){
            if (g_iRLVOn){
                if (g_kLeashedTo){
                    //Debug("Setting restrictions");
                    llMessageLinked(LINK_SET, RLV_CMD, "fartouch=n,sittp=n,tplm=n,tplure=n,tploc=n", NULL_KEY);     //set all restrictions
                    return;
                }
            //} else {
                //Debug("RLV is off");
            }
        //} else {
            //Debug("Strict is off");
        }
    //} else {
        //Debug("Leasher out of range");
    }
    //Debug("Releasing restrictions");
    llMessageLinked(LINK_SET, RLV_CMD, "fartouch=y,sittp=y,tplm=y,tplure=y,tploc=y", NULL_KEY);     //release all restrictions
}

integer LeashTo(key kTarget, key kCmdGiver, integer iAuth, list lPoints, integer iFollowMode){
    // can't leash wearer to self.
    if (kTarget == g_kWearer) return FALSE;
    
    if (!CheckCommandAuth(kCmdGiver, g_iLastRank)){
        return FALSE;
    }
    
    if (g_kLeashedTo){
        DoUnleash();
    }
    integer bCmdGiverIsAvi=llGetAgentSize(kCmdGiver) != ZERO_VECTOR;
    integer bTargetIsAvi=llGetAgentSize(kTarget) != ZERO_VECTOR;

    // Send notices to wearer, leasher, and target
    // Only send notices if Leasher is an AV, as objects normally handle their own messages for such things
    if (bCmdGiverIsAvi) {
        string sTarget = llKey2Name(kTarget);
        string sWearMess;
        if (kCmdGiver == g_kWearer) {// Wearer is Leasher
            if (iFollowMode){
                sWearMess = "You begin following " + sTarget + ".";
            } else {
                //sCmdMess = ""; // Only one message will need to be sent
                sWearMess = "You take your leash";
                if (bTargetIsAvi) { // leashing self to someone else
                    sWearMess += ", and hand it to " + sTarget + ".";
                } else { // leashing self to an object
                    sWearMess += ", and tie it to " + sTarget + ".";
                }
            }
        } else {// Leasher is not Wearer
            string sCmdMess;
            if (iFollowMode){
                if (kCmdGiver != kTarget) { // LeashTo someone else
                    Notify(kTarget, llKey2Name(kCmdGiver) + " commands " + g_sWearer + " to follow you.", FALSE);
                    sCmdMess= "You command " + g_sWearer + " to follow " + sTarget + ".";
                    sWearMess = llKey2Name(kCmdGiver) + " commands you to follow " + sTarget + ".";
                } else {
                    sCmdMess= "You command " + g_sWearer + " to follow you.";
                    sWearMess = llKey2Name(kCmdGiver) + " commands you to follow them.";
                }
            } else {
                string sPsv = "'s"; // Possessive, will vary if name ends in "s"
                if (llGetSubString(g_sWearer, -1,-1)=="s") sPsv = "'";
                sCmdMess= "You grab " + g_sWearer + sPsv + " leash";
                sWearMess = llKey2Name(kCmdGiver) + " grabs your leash";
                if (kCmdGiver != kTarget) { // Leasher is not LeashTo
                    if (bTargetIsAvi) { // LeashTo someone else
                        sCmdMess += ", and hand it to " + sTarget + ".";
                        sWearMess += ", and hands it to " + sTarget + ".";
                        Notify(kTarget, llKey2Name(kCmdGiver) + " hands you " + g_sWearer + sPsv + " leash.", FALSE);
                    } else {// LeashTo object
                        sCmdMess += ", and tie it to " + sTarget + ".";
                        sWearMess += ", and ties it to " + sTarget + ".";
                    }
                }
            }
            Notify(kCmdGiver, sCmdMess, FALSE);
        }
        Notify(g_kWearer, sWearMess, FALSE);
    }

    g_bFollowMode = iFollowMode; // leashing, or following
    if (bTargetIsAvi) g_bLeashedToAvi = TRUE;
    DoLeash(kTarget, iAuth, lPoints);
    
    // Notify Target how to unleash, only if:
    // Avatar
    // Didn't send the command
    // Don't own the object that sent the command
    if (g_bLeashedToAvi && kCmdGiver != kTarget && llGetOwnerKey(kCmdGiver) != kTarget) {
        if (iFollowMode){
            llMessageLinked(LINK_SET, POPUP_HELP, g_sWearer + " has been commanded to follow you.  Say \"_PREFIX_unfollow\" to relase them.", g_kLeashedTo);
        } else {
            llMessageLinked(LINK_SET, POPUP_HELP, g_sWearer + " has been leashed to you.  Say \"_PREFIX_unleash\" to unleash them.  Say \"_PREFIX_giveholder\" to get a leash holder.", g_kLeashedTo);
        }
    }
    return TRUE;
}

DoLeash(key kTarget, integer iAuth, list lPoints){
    g_iLastRank = iAuth;
    g_kLeashedTo = kTarget;

    if (g_bFollowMode) {
        llMessageLinked(LINK_THIS, Use_Particles, "unleash", g_kLeashedTo);
    } else {
        integer iPointCount = llGetListLength(lPoints);
        g_sCheck = "";  
        if (iPointCount) {//if more than one leashpoint, listen for all strings, else listen just for that point
            if (iPointCount == 1) g_sCheck = (string)llGetOwnerKey(kTarget) + llList2String(lPoints, 0) + " ok";
        }
        //Send link message to the particle script
        //Debug("leashing with "+g_sCheck);
        llMessageLinked(LINK_THIS, Use_Particles, "leash" + g_sCheck + "|" + (string)g_bLeashedToAvi, g_kLeashedTo);
        llSetTimerEvent(3.0);   //check for leasher out of range
    }

    // change to llTarget events by Lulu Pink 
    g_vPos = llList2Vector(llGetObjectDetails(g_kLeashedTo, [OBJECT_POS]), 0);
    //to prevent multiple target events and llMoveToTargets
    llTargetRemove(g_iTargetHandle);
    llStopMoveToTarget();
    g_iTargetHandle = llTarget(g_vPos, (float)g_iLength);
    if (g_vPos != ZERO_VECTOR) {
        llMoveToTarget(g_vPos, 0.7);
    }
    llMessageLinked(LINK_SET, LM_SETTING_SAVE, g_sScript + TOK_DEST + "=" + (string)kTarget + "," + (string)iAuth + "," + (string)g_bLeashedToAvi + "," + (string)g_bFollowMode, "");
    if (! ~llListFindList(g_lOwners,[g_kLeashedTo])) {
        llMessageLinked(LINK_SET, RLV_CMD, "tplure:" + (string) g_kLeashedTo + "=add", NULL_KEY);
    }
    g_iLeasherInRange=TRUE;
    ApplyRestrictions();
}

// Wrapper for DoUnleash()
Unleash(key kCmdGiver)
{
    string sTarget = llKey2Name(g_kLeashedTo);
    if ( (key)g_kLeashedTo ){
        string sCmdGiver = llKey2Name(kCmdGiver);
        string sWearMess;
        string sCmdMess;
        string sTargetMess;
        
        integer bCmdGiverIsAvi=llGetAgentSize(kCmdGiver) != ZERO_VECTOR;
    
        if (bCmdGiverIsAvi) {
            if (kCmdGiver == g_kWearer) // Wearer is Leasher
            {
                if (g_bFollowMode) {
                    sWearMess = "You stop following " + sTarget + ".";
                    sTargetMess = g_sWearerFirstName + " stops following you.";
                } else {
                    sWearMess = "You unleash yourself from " + sTarget + "."; // sTarget might be an object
                    sTargetMess = g_sWearerFirstName + " unleashes from you.";
                }
                if (g_bLeashedToAvi) Notify(g_kLeashedTo, sTargetMess, FALSE);
            } else { // Unleasher is not Wearer
                if (kCmdGiver == g_kLeashedTo) {
                    if (g_bFollowMode) {
                        sCmdMess= "You release " + g_sWearerFirstName + " from following you.";
                        sWearMess = sCmdGiver + " releases you from following.";
                    } else {
                        sCmdMess= "You unleash  " + g_sWearer + ".";
                        sWearMess = sCmdGiver + " unleashes you.";
                    }
                } else {
                    if (g_bFollowMode) {
                        sCmdMess= "You release " + g_sWearerFirstName + " from following " + sTarget + ".";
                        sWearMess = sCmdGiver + " releases you from following " + sTarget + ".";
                        sTargetMess = g_sWearer + " stops following you.";
                    } else {
                        sCmdMess= "You unleash  " + g_sWearerFirstName + " from " + sTarget + ".";
                        sWearMess = sCmdGiver + " unleashes you from " + sTarget + ".";
                        sTargetMess = sCmdGiver + " unleashes " + g_sWearerFirstName + " from you.";
                    }
                    if (g_bLeashedToAvi) Notify(g_kLeashedTo, sTargetMess, FALSE);
                }
                Notify(kCmdGiver, sCmdMess, FALSE);
            }
            Notify(g_kWearer, sWearMess, FALSE);
        }
        DoUnleash();
    } else {
        Notify(kCmdGiver, g_sWearerFirstName+" is not leashed", FALSE);
    }
}

DoUnleash(){
    llTargetRemove(g_iTargetHandle);
    llStopMoveToTarget();
    llMessageLinked(LINK_SET, Use_Particles, "unleash", g_kLeashedTo);
    if (g_iStrictModeOn){
        //Debug("Unleashing a Real leash");
        if (! ~llListFindList(g_lOwners,[g_kLeashedTo]) ){ //if not in owner list
            //Debug("leash holder ("+(string)g_kLeashedTo+")is not an owner");
            llMessageLinked(LINK_SET, RLV_CMD, "tplure:" + (string) g_kLeashedTo + "=rem", NULL_KEY);
        } else {
            //Debug("leash holder is an owner");
        }
    }
    g_kLeashedTo = NULL_KEY;
    g_iLastRank = COMMAND_EVERYONE;
    llMessageLinked(LINK_SET, LM_SETTING_DELETE, g_sScript + TOK_DEST, "");
    llSetTimerEvent(0.0);   //stop checking for leasher out of range
    g_iLeasherInRange=FALSE;

    ApplyRestrictions();
}

YankTo(key kIn){
    llMoveToTarget(llList2Vector(llGetObjectDetails(kIn, [OBJECT_POS]), 0), 0.5);
    llSleep(2.0);
    llStopMoveToTarget();    
}

default
{
    /*on_rez(integer s)
    {
        llResetScript();
    }*/

    state_entry()
    {
        init();
        dumpAccessList();
        CheckMemory();
        globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
        llSetObjectName(llKey2Name(llGetOwner()) + "'s Collar");
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
        g_kParticleTarget = id;
        key targetKey;
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        llListenRemove(listen_handle);
        if(channel == adminChannel){
            if ((id == llGetOwner()) && (adminChannel_Active)){
                integer space = llSubStringIndex(message, " ");
                if (space > 0){
                    string command = llGetSubString(message, 0, space - 1);
                    string avatar = llGetSubString(message, space + 1, -1);
                    targetKey = llName2Key(avatar);
                    if (command == "add"){
                        if (llListFindList(accessList, [avatar]) == -1){
                            accessList = llListInsertList(accessList, [avatar], 0);
                            llOwnerSay("Added: " + avatar + " to access list");
                            llInstantMessage(targetKey, "secondlife:///app/agent/" + (string)id + "/about added you to her Collar");
                            adminChannel_Active = FALSE;
                            dumpAccessList();
                        }
                    }
                    else if (command == "del"){
                        integer pos = llListFindList(accessList, [avatar]);
                        if (pos >= 0){
                            accessList = llDeleteSubList(accessList, pos, pos);
                            llOwnerSay("Added: " + avatar + " to access list");
                            llInstantMessage(targetKey, "secondlife:///app/agent/" + (string)id + "/about removed you from her Collar");
                            adminChannel_Active = FALSE;
                            dumpAccessList();
                        }
                    }
                }
            }
        }
        else{
            if (message == "▼")
                return;
            else if ((message == "Leash") || (message == "Unleash")){
                if(leshedON){
                    llInstantMessage(id, (string)owner + " is no longer following you.");
                    //llMessageLinked(LINK_ALL_OTHERS, Use_Particles, "leash|" + (string)g_kParticleTarget, g_kLeashedTo);
                    LeashTo(targetKey, id, iAuth, ["handle"], FALSE);

                    llMessageLinked(LINK_THIS, Use_Particles, "leash" + g_sCheck + "|" + (string)g_bLeashedToAvi, g_kLeashedTo);
                    stopFollowing();
                    StopParticles(TRUE);
                }
                else{
                    llInstantMessage(id, (string)owner + " is now following you.");
                    llMessageLinked(LINK_THIS, Use_Particles, "unleash", g_kLeashedTo);
                    startFollowingKey(id);
                    StartParticles(g_kParticleTarget);
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
                if(id == llGetOwner()){
                    adminChannel_Active = TRUE;
                    llOwnerSay("type /1add (username) or if you wish to remove users then type /1del (username), you have 1min (60seconds)!");
                    llSetTimerEvent(60);
                }
            }
            else if (message == "List")
            {
                if(id == llGetOwner())
                    dumpAccessList();
                else
                    return;
            }
            else if (message == "menu")
                ownermenu(id);
            else if (message == "Reset")
                llResetScript();
        }
    }

    link_message(integer iSenderPrim, integer iNum, string sMessage, key kMessageID)
    {
        if (iNum == Use_Particles)
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
                if (!g_bInvisibleLeash){
                    integer bLeasherIsAv = (integer)llList2String(llParseString2List(sMessage, ["|"], [""]), 1);
                    g_kParticleTarget = g_kLeashedTo;
                    StartParticles(g_kParticleTarget);
                    if (bLeasherIsAv){
                        llListenRemove(g_iLMListener);
                        llListenRemove(g_iLMListernerDetach);
                        if (llGetSubString(sMessage, 0, 10)  == "leashhandle"){
                            g_iLMListener = llListen(LockParticles, "", "", (string)g_kLeashedTo + "handle ok");
                            g_iLMListernerDetach = llListen(LockParticles, "", "", (string)g_kLeashedTo + "handle detached");
                        }
                        else{
                            g_iLMListener = llListen(LockParticles, "", "", "");
                        }
                        LMSay();
                    }
                }
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH | PERMISSION_TAKE_CONTROLS){
            llAttachToAvatar(ATTACH_NECK);
        }
    }

    attach(key _id)
    {
        if (_id != NULL_KEY){
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH | PERMISSION_TAKE_CONTROLS);
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