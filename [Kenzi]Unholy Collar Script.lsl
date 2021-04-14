key targetKey = NULL_KEY;

float DELAY = 0.5;
float RANGE = 3.0;
float TAU = 1.0;
float LIMIT = 60.0;
float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float Volume_For_Bell = 0.2;
float seconds_to_check_when_avatar_walks = 0.01;

integer On              = TRUE;
integer sound1          = TRUE;
integer walking         = FALSE;
integer leshedON        = FALSE;
integer announced       = FALSE;

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
integer tid = 0;

list accessList = [];
list main_menu;
list sounds_menu = [ "Bell 1", "Back", "Exit"];
list textures_menu = ["Black", "White", "Back", "Exit"];
list users_menu = ["Add", "Remove", "List", "Clear", "Back", "Exit"];

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

CheckMemory()
{
    integer free_memory = llGetFreeMemory();
    llOwnerSay((string)free_memory + " bytes of free memory available for allocation.");
}

menu(key _id)
{
    if (!leshedON){
        main_menu = ["Leash", "Exit"];
    }
    else{
        main_menu = ["Unleash", "Exit"];
    }
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

ownermenu(key _id)
{
    if (!leshedON){
        main_menu = ["Sounds", "On/Off", "Textures", "Users", "Exit"];
    }
    else{
        main_menu = ["Sounds", "On/Off", "Textures", "Users", "Exit"];
    }
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

soundsmenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", sounds_menu, channel);
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
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", textures_menu, channel);
}

dumpAccessList()
{
    llOwnerSay("current access list: " + llDumpList2String(accessList, ", "));
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

init() 
{
    llListenRemove(listen_handle);
    CheckMemory();
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
  //llSetTimerEvent(0.0);
  llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
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
  list username = llParseString2List(llGetDisplayName(id), [""], []);
  list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
  targetKey = id;
  llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
  llOwnerSay("You are now following " + (string)username + ".");
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
                    llInstantMessage(toucher_key, "Hello " + (string)username + ", you are not on the access list, ask " + (string)owner + " (" + owneruser + ") if you would like to get access :P");
                    return;
                }
                else{
                    llPlaySound(sound_9, Volume_For_Bell);
                    llSetObjectName("");
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
        if (message == "Exit")
            return;
        else if ((message == "Leash") || (message == "Unleash")){
            if(leshedON){
                llInstantMessage(id, (string)owner + " is no longer following you.");
                stopFollowing();
            }
            else{
                llInstantMessage(id, (string)owner + " is now following you.");
                startFollowingKey(id);
            }
            leshedON = !leshedON;
        }
        else if (message == "On/Off")
        {
            if (On){
                llOwnerSay("Bell is now Off..");
                On = FALSE;
                sound1 = FALSE;
            }
            else{
                llOwnerSay("Bell is now On..");
                On = TRUE;
                sound1 = TRUE;
                ownermenu(id);
            }
        }
        else if (message == "Sounds")
            soundsmenu(id);
        else if (message == "Textures")
            texturesmenu(id);
        else if (message == "Back")
            ownermenu(id);
        else if (message == "Bell 1"){
            llOwnerSay("Bell 1 sound enabled..");
            sound1 = TRUE;
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
        else if (message == "Users")
        {
            if(id == llGetOwner())
                state Owner;
            else
                return;
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
                }
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
        if (id == llGetOwner()){
            integer space = llSubStringIndex(message, " ");
            if (space > 0) {
                string command = llGetSubString(message, 0, space - 1);
                string avatar = llGetSubString(message, space + 1, -1);
                if (command == "add"){
                    if (llListFindList(accessList, [avatar]) == -1) {
                        accessList = llListInsertList(accessList, [avatar], 0);
                        llOwnerSay("Added: " + avatar + " to access list");
                        state default;
                    }
                }
                else if (command == "del"){
                    integer pos = llListFindList(accessList, [avatar]);
                    if (pos >= 0) {
                        accessList = llDeleteSubList(accessList, pos, pos);
                        llOwnerSay("Added: " + avatar + " to access list");
                        dumpAccessList();
                        state default;
                    }
                }
                dumpAccessList();
            }
        }
    }
}