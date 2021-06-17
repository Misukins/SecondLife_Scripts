float Walking_Sound_Speed = 1.0;
float Volume_For_Sounds = 0.05;
float Volume_For_Bell = 0.2;
float seconds_to_check_when_avatar_walks = 0.01;

integer WalkingSound;
integer walking;
integer ll_channel          = 665;
integer globalListenHandle  = -0;
integer channel;
integer listen_handle;

list main_menu;
list textures_menu  = ["Black", "White", "Back", "▼"];

string sound_1 = "7b04c2ee-90d9-99b8-fd70-8e212a72f90d";

string blackTexture = "790203ff-6b4f-c15c-70fc-1e95142e7225";
string whiteTexture = "9c6e07c4-52cb-be8f-9ba3-ccfef92ebe7f";

string API_Start_Sound;
string API_Stop_Sound;

ownermenu(key _id)
{
    if(!WalkingSound)
        main_menu = ["On", "Textures", "Reset", "▼"];
    else
        main_menu = ["Off", "Textures", "Reset", "▼"];
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
        }
    }
    while(i++<a);
}

key llGetObjectOwner()
{
    list details = llGetObjectDetails(llGetKey(), [OBJECT_OWNER]);
    return (key)llList2CSV(details);
}

soundsOFF(){
    walking = FALSE;
    llSetTimerEvent(seconds_to_check_when_avatar_walks);
}

default
{
    on_rez(integer s)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
            llResetScript();
        if(llGetInventoryNumber(INVENTORY_SOUND) > 0)
            asLoadSounds();
    }

    state_entry()
    {
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

    listen(integer channel, string name, key id, string message)
    {
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        key targetKey;
        llListenRemove(listen_handle);
        if (message == "▼")
            return;
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
        else if (message == "menu")
            ownermenu(id);
        else if (message == "Reset")
            llResetScript();
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
    }
}