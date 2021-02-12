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

list main_menu      = [ "GOD", "Options", "Exit" ];
list options_menu   = [ "Reset", "Back", "Exit" ];

integer DEBUG           = TRUE;

key targetKey;

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
            state Dial;
    }

}

state Dial
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, range, PI);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Dial");
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
          state Dialog;
    }
}

state Dialog
{
    state_entry()
    {
        gMenuPosition = 0;
        Menu();
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Dialog");
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            state Send;
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

state Send
{
    state_entry()
    {
        key id = llGetOwner();
        MainMenu(id);
        if (DEBUG == TRUE)
            llOwnerSay("DEBUG: Send");
    }

    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (message == "GOD"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                string origName = llGetObjectName();
                list targetName = [];
                key ownerKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                ownerKey = llGetOwnerKey(llGetKey());
                llSetObjectName("");
                llTextBox(targetID, "This is your Princess speaking, and i'm the law here" + llGetDisplayName(targetKey) + "!", channel);
                llOwnerSay("TextBox was sent to secondlife:///app/agent/" + (string)targetKey + "/about.");
                llSetObjectName(origName);
                llSleep(.5);
                state default;
                return;
            }
            else if (message == "Options")
                OptionsMenu(id);
            else if (message == "Back")
                MainMenu(id);
            else if (message == "Reset")
                llResetScript();
            else if (message == "Exit")
                return;
        }

    }
}