/* 

so far so good.. still alot work

*/

key targetKey                               = NULL_KEY;

float DELAY                                 = 0.5;
float TAU                                   = 1.0;
float LIMIT                                 = 60.0;
float Walking_Sound_Speed                   = 1.0;
float Volume_For_Sounds                     = 0.05;
float Volume_For_Bell                       = 0.2;
float seconds_to_check_when_avatar_walks    = 0.01;
float soundsVolume                          = 1.0;

integer channel;
integer listen_handle;
integer WalkingSound;
integer walking             = FALSE;
integer leshedON            = FALSE;
integer announced           = FALSE;
integer defdist             = TRUE;
integer fivemDist           = FALSE;
integer tenmDist            = FALSE;
integer fifteenmDist        = FALSE;
integer twentyMDist         = FALSE;
integer gotPermission       = FALSE;
integer ll_channel          = 665;
integer COLLAR_FACE         = 1;
integer dlgHandle           = -1;
integer globalListenHandle  = -0;
integer tid                 = 0;
integer RANGE               = 2;
integer listenChannel       = 1;

list main_menu;
//list sounds_menu      = [ "Bell 1", "←", "▼"];
list textures_menu      = ["Black", "White", "Brown", "Red", "←", "▼"];
list users_menu         = ["Add", "Remove", "List", "←", "▼"];
list accessList         = [];
list avatarList         = [];
list avatarUUIDs        = [];
list distance_menu      = [];
list anims_menu         = [];
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

//TODO ~ more textures
string blackTexture = "9af0ef91-122c-d867-d066-81c7929cdb40"; //Black
string whiteTexture = "6b2ffa5f-dc71-c551-c9eb-9ce636c7ef84"; //White
string brownTexture = "1d32a1d4-538c-a1fe-1d9f-33a95867e060"; //Brown
string redTexture   = "ed55e038-2e2d-4372-d0c8-a1ce50e74b81"; //Red
string tpSound      = "93070de9-ffe7-8f9e-cbbe-7a570a9a0410"; //Bleep!!!!

string API_Start_Sound;
string API_Stop_Sound;

string targetName   = "";
string objectName   = "(TEMP): Collar - Leash";
string desc_        = "(c)Amy (meljonna Resident) -";

// TODO list START
/* //NOTE so far this works 100% but leash goesto Avi Center looks stupid!!
            i really need beer to finish this script :P
//FIX leash texture change
//FIX leash color change
//FIX link leash to collar LOGO
what else? oh
//FIX after teleport checks
//FIX range checks (DONE)
//FIX CLEAN UP!!!
//FIX Sorry, someone who outranks you on
*/ //TODO list END

CheckMemory()
{
    integer free_memory = llGetFreeMemory();
    llOwnerSay((string)free_memory + " bytes of free memory available for allocation.");
}

Cleanup()
{
    llListenRemove(dlgHandle);
    dlgHandle = -1;
}

menu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    if (!leshedON){
        main_menu = ["Leash", "▼"];
        llDialog(_id, "Hello " + (string)avatar_name + " Select a an option\nCurrent Follow Distance :: " + (string)RANGE + " meter(s)", main_menu, channel);
    }
    else{
        main_menu = ["Unleash", "Animation", "Distance", "▼"];
        llDialog(_id, "Hello " + (string)avatar_name + " Select a an option\nCurrent Follow Distance :: " + (string)RANGE + " meter(s)", main_menu, channel);
    }
}

ownermenu(key _id)
{
    if(!WalkingSound)
        main_menu = ["On", "Animation", "Textures", "Users", "Reset", "▼"];
    else
        main_menu = ["Off", "Animation", "Textures", "Users", "Reset", "▼"];
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

texturesmenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", textures_menu, channel);
}

usersmenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", users_menu, channel);
}

distanceMenu(key id)
{
    if ((defdist) && (!fivemDist) && (!tenmDist) && (!fifteenmDist) && (!twentyMDist))
        distance_menu = ["▪Default", "▫5Meters", "▫10Meters", "▫15Meters", "▫20Meters", "◄", "▼"];
    else if ((!defdist) && (fivemDist) && (!tenmDist) && (!fifteenmDist) && (!twentyMDist))
        distance_menu = ["▫Default", "▪5Meters", "▫10Meters", "▫15Meters", "▫20Meters", "◄", "▼"];
    else if ((!defdist) && (!fivemDist) && (tenmDist) && (!fifteenmDist) && (!twentyMDist))
        distance_menu = ["▫Default", "▫5Meters", "▪10Meters", "▫15Meters", "▫20Meters", "◄", "▼"];
    else if ((!defdist) && (!fivemDist) && (!tenmDist) && (fifteenmDist) && (!twentyMDist))
        distance_menu = ["▫Default", "▫5Meters", "▫10Meters", "▪15Meters", "▫20Meters", "◄", "▼"];
    else if ((!defdist) && (!fivemDist) && (!tenmDist) && (!fifteenmDist) && (twentyMDist))
        distance_menu = ["▫Default", "▫5Meters", "▫10Meters", "▫15Meters", "▪20Meters", "◄", "▼"];
    list avatar_name = llParseString2List(llGetDisplayName(id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, "Hello " + (string)avatar_name + " Select a an option\nCurrent Distance :: "+ (string)RANGE + " meter(s)", distance_menu, channel);
}

animsmenu(key _id)
{
    anims_menu = ["booty", "bendover", "cutie", "kneel", "doggie", "STOP", "▼"];
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", anims_menu, channel);
}

dumpAccessList()
{
    llOwnerSay("current access list:\n" + llDumpList2String(accessList, ", "));
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

soundsOFF()
{
    walking = FALSE;
    llSetTimerEvent(seconds_to_check_when_avatar_walks);
}

stopFollowing(key id)
{
    string origName = llGetObjectName();
    list username = llParseString2List(llGetDisplayName(id), [""], []);
    list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
    llTargetRemove(tid);
    llStopMoveToTarget();
    llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
    llOwnerSay("No longer following " + (string)username + ".");
    llSay(0, (string)username + " lets go " + (string)owner + "'s leash.");
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
    list username = llParseString2List(llGetDisplayName(id), [""], []);
    list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
    targetKey = id;
    llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
    llOwnerSay("You are now following " + (string)username + ".");
    llSay(0, (string)username + " grabs " + (string)owner + "'s leash.");
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
    if (llGetListLength(answer) == 0){
        if (!announced){
            llSetObjectName(objectName);
            llOwnerSay(targetName + " seems to be out of range.  Waiting for return...");
            llSetObjectName(origName);
        }
        announced = TRUE;
    }
    else {
        announced = FALSE;
        vector targetPos = llList2Vector(answer,0);
        float dist = llVecDist(targetPos,llGetPos());
        if (dist > RANGE) {
            tid = llTarget(targetPos, RANGE);
            if (dist>LIMIT)
                targetPos = llGetPos() + LIMIT * llVecNorm( targetPos - llGetPos() );
            llMoveToTarget(targetPos,TAU);
        }
    }
}

stopAllAnimations()
{
    list anims = llGetAnimationList(llGetOwner());
    integer n;
    for (n = 0; n < llGetListLength(anims); n++)
        llStopAnimation(llList2String(anims,n));
}

default
{
    state_entry()
    {
        dumpAccessList();
        CheckMemory();
        globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
        llSetObjectName(llKey2Name(llGetOwner()) + "'s Collar");
        llOwnerSay("Type /" +  (string)ll_channel + "menu for Menu");
        llPreloadSound(tpSound);
        if(llGetAttached())
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
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
                    llSetObjectName("");
                    llOwnerSay((string)username + " touched your collar. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                    llSetObjectName(origName);
                    llInstantMessage(toucher_key, "Hello " + (string)username + ", you are not on the access list, ask secondlife:///app/agent/" + (string)ownerKey + "/about");
                }
                else{
                    llPlaySound(sound_9, Volume_For_Bell);
                    llSetObjectName("");
                    llOwnerSay((string)username + " touched your collar. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                    llWhisper(0, (string)username + " plays with the trinket on " + (string)owner + "'s collar.");
                    llSetObjectName(origName);
                    menu(toucher_key);
                }
            }
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        llListenRemove(listen_handle);
        if (message == "▼")
            return;
        else if ((message == "Leash") || (message == "Unleash")){
            if(leshedON){
                llInstantMessage(id, (string)owner + " is no longer following you.");
                stopFollowing(id);
                llSetObjectDesc(desc_);
            }
            else{
                llInstantMessage(id, (string)owner + " is now following you.");
                startFollowingKey(id);
                llSetObjectDesc("Following - " + (string)id + llKey2Name(id) + ".");
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
        else if (message == "←")
            ownermenu(id);
        else if (message == "Black"){
            llSetLinkTexture(LINK_THIS, blackTexture, COLLAR_FACE);
            texturesmenu(id);
        }
        else if (message == "White"){
            llSetLinkTexture(LINK_THIS, whiteTexture, COLLAR_FACE);
            texturesmenu(id);
        }
        else if (message == "Brown"){
            llSetLinkTexture(LINK_THIS, brownTexture, COLLAR_FACE);
            texturesmenu(id);
        }
        else if (message == "Red"){
            llSetLinkTexture(LINK_THIS, redTexture, COLLAR_FACE);
            texturesmenu(id);
        }
        else if (message == "Users")
            usersmenu(id);
        else if (message == "List")
            dumpAccessList();
        else if (message == "Add")
            state Owner;
        else if (message == "Remove")
            state Remove;
        else if (message == "menu")
            ownermenu(id);
        else if (message == "Animation"){
            animsmenu(id);
            stopAllAnimations();
        }
        else if (message == "booty"){
            if(gotPermission)
                llStartAnimation("booty");
        }
        else if (message == "bendover"){
            if(gotPermission)
                llStartAnimation("bendover");
        }
        else if (message == "cutie"){
            if(gotPermission)
                llStartAnimation("cutie");
        }
        else if (message == "kneel"){
            if(gotPermission)
                llStartAnimation("kneel");
        }
        else if (message == "doggie"){
            if(gotPermission)
                llStartAnimation("doggie");
        }
        else if (message == "STOP")
            stopAllAnimations();
        else if (message == "Reset")
            llResetScript();
        else if (message == "Distance")
                distanceMenu(id);
        else if (message == "▪Default"){
            defdist       = TRUE;
            fivemDist     = FALSE;
            tenmDist      = FALSE;
            fifteenmDist  = FALSE;
            twentyMDist   = FALSE;
            RANGE         = 2;
            llOwnerSay("Follow Distance has been changed to. (DEFAULT)");
            llInstantMessage(id, "Follow Distance set to DEFAULT.");
        }
        else if (message == "▫5Meters"){
            RANGE         = 0;
            defdist       = FALSE;
            fivemDist     = TRUE;
            tenmDist      = FALSE;
            fifteenmDist  = FALSE;
            twentyMDist   = FALSE;
            RANGE         += 5;
            llOwnerSay("Follow Distance has been changed to. (5Meters)");
            llInstantMessage(id, "Follow Distance set to 5Meters.");
        }
        else if (message == "▫10Meters"){
            RANGE         = 0;
            defdist       = FALSE;
            fivemDist     = FALSE;
            tenmDist      = TRUE;
            fifteenmDist  = FALSE;
            twentyMDist   = FALSE;
            RANGE         += 10;
            llOwnerSay("Follow Distance has been changed to. (10Meters)");
            llInstantMessage(id, "Follow Distance set to 10Meters.");
        }
        else if (message == "▫15Meters"){
            RANGE         = 0;
            defdist       = FALSE;
            fivemDist     = FALSE;
            tenmDist      = FALSE;
            fifteenmDist  = TRUE;
            twentyMDist   = FALSE;
            RANGE         += 15;
            llOwnerSay("Follow Distance has been changed to. (15Meters)");
            llInstantMessage(id, "Follow Distance set to 15Meters.");
        }
        else if (message == "▫20Meters"){
            RANGE         = 0;
            defdist       = FALSE;
            fivemDist     = FALSE;
            tenmDist      = FALSE;
            fifteenmDist  = FALSE;
            twentyMDist   = TRUE;
            RANGE         += 20;
            llOwnerSay("Follow Distance has been changed to. (20Meters)");
            llInstantMessage(id, "Follow Distance set to 20Meters.");
        }
        else{
            defdist       = TRUE;
            fivemDist     = FALSE;
            tenmDist      = FALSE;
            fifteenmDist  = FALSE;
            twentyMDist   = FALSE;
            RANGE         = 2;
            llInstantMessage(id, "Follow Distance set to DEFAULT.");
        }
    }

    attach(key _id)
    {
        if (_id != NULL_KEY){
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION);
            llAttachToAvatar(ATTACH_NECK);
            dumpAccessList();
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

        if (change & CHANGED_TELEPORT)
        {
            llTriggerSound(tpSound, soundsVolume);
            //TODO
        }

        if(llGetInventoryNumber(INVENTORY_SOUND) > 0)
            asLoadSounds();
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
            gotPermission = TRUE;
    }

    no_sensor()
    {
        string origName = llGetObjectName();
        llSetObjectName(objectName);
        llOwnerSay("Did not find anyone named "+ targetName);
        llSetObjectName(origName);
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

    /* state_exit()
    {
        llSetTimerEvent(0);
    } */
}

state Remove
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        llOwnerSay("type /" + (string)listenChannel + "del (username), you have 1min (60seconds)!");
        llSetTimerEvent(60); //60 Seconds
        dumpAccessList();
    }

    listen(integer channel, string name, key id, string message)
    {
        key targetKey;
        string origName = llGetObjectName();
        if (id == llGetOwner()){
            integer space = llSubStringIndex(message, " ");
            if (space > 0){
                string command = llGetSubString(message, 0, space - 1);
                string avatar = llGetSubString(message, space + 1, -1);
                targetKey = llName2Key(avatar);
                integer pos = llListFindList(accessList, [avatar]);
                if (pos >= 0){
                    accessList = llDeleteSubList(accessList, pos, pos);
                    llSetObjectName("");
                    llOwnerSay("Removed: secondlife:///app/agent/" + (string)targetKey + "/about for access list.");
                    //llInstantMessage(targetKey, "secondlife:///app/agent/" + (string)id + "/about removed you from theyr Collar.");
                    llSetObjectName(origName);
                    state default;
                }
            }
        }
    }

    timer()
    {
        llOwnerSay("Users delete time expired!");
        state default;
    }
}

state Owner
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
            state OwnerDialog;
    }
}

state OwnerDialog
{
    state_entry()
    {
        dlgHandle = llListen(listenChannel, "", "", "");
        llSetTimerEvent(30.0); //30 seconds
        avatarList += ["※Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, listenChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to start over!");
    }

    listen(integer channel, string name, key id, string message)
    {
        key targetKey;
        string origName = llGetObjectName();
        string avatar = llGetSubString(message, 0, -1);
        targetKey = llName2Key(avatar);
        if (llListFindList(accessList, [avatar]) == -1){
            accessList = llListInsertList(accessList, [avatar], 0);
            llSetObjectName("");
            llOwnerSay("Added: secondlife:///app/agent/" + (string)targetKey + "/about to access list.");
            llInstantMessage(targetKey, "secondlife:///app/agent/" + (string)id + "/about added you to theyr Collar.");
            llSetObjectName(origName);
            Cleanup();
            state default;
        }

        if (message == "※Cancel"){
            Cleanup();
            state default;
        }
    }

    timer()
    {
        llOwnerSay("Users add time expired!");
        Cleanup();
        state default;
    }
}