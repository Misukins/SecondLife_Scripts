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

string API_Start_Sound;
string API_Stop_Sound;

integer globalListenHandle  = -0;
integer ll_channel          = 667;
integer channel;
integer listen_handle;

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

float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float seconds_to_check_when_avatar_walks = 0.01;

list main_menu = [ "Sounds", "On/Off", "Exit" ];
list sounds_menu =[ "Bell 1", "Bell 2", "Bell 3", "Bell 4", "Bell 5", "Bell 6", "Bell 7", "Bell 8", "Back" ];

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
        }
    }while(i++<a);
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
    owner = llGetOwner();
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", owner, "");
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
        if(CheckMono() == FALSE)
            llInstantMessage(llGetObjectOwner(), "This script will run better in Mono");
        if(llGetAttached() != 0){
            llSetTimerEvent(seconds_to_check_when_avatar_walks);
            asLoadSounds();
        }
        else
            llSetTimerEvent(0);
        globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
        init();
        llOwnerSay("Type /" +  (string)ll_channel + "menu for Menu");
        if (On)
            llOwnerSay("Bell is now On..");
        else
            llOwnerSay("Bell is now Off..");
    }
    
    changed(integer p)
    {
        if (llGetInventoryNumber(INVENTORY_SOUND) > 0)
            asLoadSounds();
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        if (message == "Exit")
            return;
        else if (message == "On/Off"){
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
                llDialog(owner, "\n\nSelect a an option", main_menu, channel);
            }
        }
        else if (message == "Sounds")
            llDialog(owner, "\n\nSelect a an option", sounds_menu, channel);
        else if (message == "menu")
            llDialog(owner, "\n\nSelect a an option", main_menu, channel);
        else if (message == "Back")
            llDialog(owner, "\n\nSelect a an option", main_menu, channel);
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
        }
    }
    
    timer()
    {
        if (llGetAgentInfo(llGetObjectOwner()) & AGENT_WALKING){
            llSetTimerEvent(Walking_Sound_Speed);
            if (walking == FALSE){
                if (On == TRUE){
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
