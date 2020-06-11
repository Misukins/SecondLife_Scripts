key owner;

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

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;

float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float Volume_For_Bell = 0.2;
float seconds_to_check_when_avatar_walks = 0.01;

list main_menu = [ "Sounds", "On/Off", "Textures", "Exit" ];
list sounds_menu = [ "Bell 1", "Bell 2", "Bell 3", "Bell 4", "Bell 5", "Bell 6", "Bell 7", "Bell 8", "Back" ];
list textures_menu = ["Black", "White"];

menu(key _id)
{
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

integer CheckMono()
{
    if(llGetFreeMemory() > 40000)
        return TRUE;
    else
        return FALSE;
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

default
{
    on_rez(integer s) 
    {
        init();
    }
    
    state_entry()
    {
        llSetObjectName(llKey2Name(llGetOwner())+ "'s Collar");
        if(CheckMono() == FALSE)
            llInstantMessage(llGetObjectOwner(), "This script will run better in Mono");
        
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
            else
                return;
        }
    }

    listen(integer channel, string name, key id, string message) 
    {
        llListenRemove(listen_handle);
        if (message == "Exit")
            return;
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
    }
}