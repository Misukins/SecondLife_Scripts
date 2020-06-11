string pokeSound            = "f6d4dd62-c5ff-5007-b8f4-2603e3692b9c";
string spankSound           = "475a3e83-6801-49c6-e7ad-d6386b2ecc29";

integer dlgHandle = -1;
integer dlgChannel;

integer channel;
integer listen_handle;

integer range = 4096;
integer gMenuPosition;

list avatarList     = [];
list avatarUUIDs    = [];

list main_menu      = [ "Poke", "Boobs", "Smack", "Options", "Exit" ];
list options_menu   = [ "Reset", "Back", "Exit" ];

integer DEBUG           = FALSE;

MainMenu(key detectedKey)
{
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, channel);
}

OptionsMenu(key detectedKey)
{
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", options_menu, channel);
}

Menu()
{
    integer Last;
    list Buttons;
    integer All = llGetListLength(avatarList);
    if(gMenuPosition >= 9){
      Buttons += "◄";
      if((All - gMenuPosition) > 10)
        Buttons += "►";
      else
        Last = TRUE;          
    }    
    else if (All > gMenuPosition+9){
      if((All - gMenuPosition) > 10)
        Buttons += "►";
      else
        Last = TRUE;
    }
    else
      Last = TRUE;
    if (All > 0){
      integer b;
      integer len = llGetListLength(Buttons);     
      for(b = gMenuPosition + len + Last - 1 ; (len < 11)&&(b < All); ++b){
          Buttons = Buttons + [llList2String(avatarList,b)];
          len = llGetListLength(Buttons);
      }
    }
    dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
    llSetTimerEvent(30.0);
    Buttons += ["▼"];
    llDialog(llGetOwner(), "Please select an avatar you want to follow", Buttons, dlgChannel);
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
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: default");
    }

    on_rez(integer x)
    {
        llResetScript();
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            MainMenu(id);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner() && message == "Poke")
            state Poke;
        else if (id == llGetOwner() && message == "Boobs")
            state Boobs;
        else if (id == llGetOwner() && message == "Smack")
            state Smack;
        else if (id == llGetOwner() && message == "Options")
            OptionsMenu(id);
        else if (id == llGetOwner() && message == "Back")
            MainMenu(id);
        else if (id == llGetOwner() && message == "Reset")
            llResetScript();
        else if (id == llGetOwner() && message == "Exit")
            return;
    }
}

state Poke
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, range, PI);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Poke");
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llList2String(llParseString2List(llDetectedName(i), [""], []), 0)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
        }
        if (llGetListLength(avatarList) > 0)
          state PokeDialog;
    }
}
 
state PokeDialog
{
    state_entry()
    {
        gMenuPosition = 0;
        Menu();
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: PokeDialog");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "▼"){
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
                llOwnerSay("InstantMessage was sent to secondlife:///app/agent/" + (string)targetKey + "/about.");
                llSetObjectName(origName);
            }
            reset();
            state default;
        }

        if (~llSubStringIndex(message,"►")){
            gMenuPosition += 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Prev");
        }
        else if (~llSubStringIndex(message,"◄")){
            gMenuPosition -= 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Next");
        }
    }
    
    timer()
    {
        reset();
        state default;
    }
}

state Boobs
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, range, PI);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Boobs");
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llList2String(llParseString2List(llDetectedName(i), [""], []), 0)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
        }
        if (llGetListLength(avatarList) > 0)
          state BoobsDialog;
    }
}

state BoobsDialog
{
    state_entry()
    {
        gMenuPosition = 0;
        Menu();
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: BoobsDialog");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "▼"){
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
                llInstantMessage(targetKey, llGetDisplayName(llGetOwner()) + " is trying to reach at you and touch your breats.\nWell hello there " + llGetDisplayName(targetKey) + "!\n I " + llGetDisplayName(llGetOwner()) + " just wanted to say, that your boobs feels so soft and nice <3!\nSay hi to them @ secondlife:///app/agent/" + (string)ownerKey + "/im");
                llOwnerSay("InstantMessage was sent to secondlife:///app/agent/" + (string)targetKey + "/about.");
                llSetObjectName(origName);
            }
            reset();
            state default;
        }

        if (~llSubStringIndex(message,"►")){
            gMenuPosition += 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Prev");
        }
        else if (~llSubStringIndex(message,"◄")){
            gMenuPosition -= 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Next");
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
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, range, PI);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Smack");
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llList2String(llParseString2List(llDetectedName(i), [""], []), 0)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
        }
        if (llGetListLength(avatarList) > 0)
          state SmackDialog;
    }
}

state SmackDialog
{
    state_entry()
    {
        gMenuPosition = 0;
        Menu();
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: SmackDialog");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "▼"){
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
                llInstantMessage(targetKey, llGetDisplayName(llGetOwner()) + " is trying to reach at you and your butt.\nWell hello there " + llGetDisplayName(targetKey) + "!\n I " + llGetDisplayName(llGetOwner()) + " just wanted to say, that your rear looks firm <3!\nSay hi to them @ secondlife:///app/agent/" + (string)ownerKey + "/im");
                llOwnerSay("InstantMessage was sent to secondlife:///app/agent/" + (string)targetKey + "/about.");
                llSetObjectName(origName);
            }
            reset();
            state default;
        }

        if (~llSubStringIndex(message,"►")){
            gMenuPosition += 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Prev");
        }
        else if (~llSubStringIndex(message,"◄")){
            gMenuPosition -= 10;
            Menu();
            if (DEBUG == TRUE)
                llOwnerSay("Next");
        }
    }
    
    timer()
    {
        reset();
        state default;
    }
}