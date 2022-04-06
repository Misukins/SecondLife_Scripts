key owner;
key texture1 = "9027e14e-51e5-3a34-4e01-0e53e80c9597";
key texture2 = "3c52c863-44ba-5433-0b51-ba463a0c7174";
key texture3 = "67b4de19-a738-e83a-ba1f-b0298937ac7f";

float totalBlood            = 10.0;
float currentBlood          = 0.0;

integer listenChannel       = -458790;
integer channel;
integer listen_handle;
integer DEBUG               = TRUE;
integer METERfound          = FALSE;
integer texture1_enabled    = FALSE;
integer texture2_enabled    = FALSE;
integer texture3_enabled    = TRUE;
integer waittime            = 10;

list main_menu;
list Settings_Menu;
list Textures_Menu;
list zList = [];
list Charsetx = ["█","█","█","█","█","█","█","█","█","█"];

string desc_    = "(c)Amy (meljonna Resident) -";
string origName;
string pList;

vector titleColor   = <0.905, 0.686, 0.924>;
vector color        = <0, 1, 0>;

/* ■ □ */
string Float2String ( float num, integer places, integer rnd)
{
    if (rnd){
        float f = llPow( 10.0, places );
        integer i = llRound(llFabs(num) * f);
        string s = "00000" + (string)i;
        if(num < 0.0)
            return "-" + (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
        return (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
    }
    if (!places)
        return (string)((integer)num );
    if ( (places = (places - 7 - (places < 1) ) ) & 0x80000000)
        return llGetSubString((string)num, 0, places);
    return (string)num;
}

menu(key _id)
{
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    main_menu = ["Deposit 1L", "Withdraw 1L", "Settings", "▼"];
    llDialog(_id, "Hello " + (string)llGetDisplayName(_id) + " (" + (string)llKey2Name(_id) + ") Select an option\nCurrent Blood volume :: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + 
        " liters(s)", main_menu, channel);
}

settingsMenu(key _id)
{
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    Settings_Menu = ["Textures", "Access", "◄", "▼"];
    llDialog(_id, "Hello " + (string)llGetDisplayName(_id) + " (" + (string)llKey2Name(_id) + ") Select an option", Settings_Menu, channel);
}

texturesMenu(key _id)

{
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    if((texture1_enabled) && (!texture2_enabled) && (!texture3_enabled))
        Textures_Menu = ["■texture1", "texture2", "texture3", "◄", "▼"];
    else if((!texture1_enabled) && (texture2_enabled) && (!texture3_enabled))
        Textures_Menu = ["texture1", "■texture2", "texture3", "◄", "▼"];
    else if((!texture1_enabled) && (!texture2_enabled) && (texture3_enabled))
        Textures_Menu = ["texture1", "texture2", "■texture3", "◄", "▼"];
    llDialog(_id, "Hello " + (string)llGetDisplayName(_id) + " (" + (string)llKey2Name(_id) + ") Select an option", Textures_Menu, channel);
}

updateTimeDisp()
{
    //NOTE THIS IS MY BEN LAZY LOL!!!!!
    if(currentBlood == 10.0){
        zList = ["█","█","█","█","█","█","█","█","█","█"];
        titleColor = <0,1,0>;
    }
    else if(currentBlood == 9.0){
        zList = ["█","█","█","█","█","█","█","█","█"];
        titleColor = <0,1,0>;
    }
    else if(currentBlood == 8.0){
        zList = ["█","█","█","█","█","█","█","█"];
        titleColor = <0,1,0>;
    }
    else if(currentBlood == 7.0){
        zList = ["█","█","█","█","█","█","█"];
        titleColor = <0,1,0>;
    }
    else if(currentBlood == 6.0){
        zList = ["█","█","█","█","█","█"];
        titleColor = <1,1,0>;
    }
    else if(currentBlood == 5.0){
        zList = ["█","█","█","█","█"];
        titleColor = <1,1,0>;
    }
    else if(currentBlood == 4.0){
        zList = ["█","█","█","█"];
        titleColor = <1,0,0>;
    }
    else if(currentBlood == 3.0){
        zList = ["█","█","█"];
        titleColor = <1,0,0>;
    }
    else if(currentBlood == 2.0){
        zList = ["█","█"];
        titleColor = <1,0,0>;
    }
    else if(currentBlood == 1.0){
        zList = ["█"];
        titleColor = <1,0,0>;
    }
    else{
        zList = [];
        titleColor = <1,0,0>;
    }
    llSetText(
        (string)llGetDisplayName(owner) 
        + " (" + (string)llKey2Name(owner) 
        + ")\nBlood Barrel 10L\nTotal Blood: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + "L\n"
        + (string)zList, titleColor, 1);
}

default
{
    state_entry()
    {
        owner = llGetOwner();
        origName = llGetObjectName();
        llSetObjectDesc(desc_);
        llListenRemove(listen_handle);
        llListen(listenChannel, "", "", "");
        if(METERfound)
            llSetTimerEvent(300);
        else
            state waiting;
        updateTimeDisp();
    }

    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key _k)
    {
        if (_k != NULL_KEY){
            llOwnerSay("YOU NEED TO REZ ME!!");
            llDetachFromAvatar();
        }
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if(llGetOwnerKey(id) == owner){
            if(!METERfound)
                state looking;
            else
                menu(id);
        }
        else
            llSay(0, "Sorry only " + (string)llGetDisplayName(owner) + " (" + (string)llKey2Name(owner) + ") has access!");
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == listenChannel){
            if(message == "METER_FOUND"){
                METERfound = TRUE;
                state looking;
            }
            else if(message == "METER_NOTFOUND")
                state waiting;
        }

        if (message == "▼")
            return;
        else if (message == "◄")
            menu(id);
        else if (message == "Done"){
            METERfound == FALSE;
            state waiting;
        }
        else if (message == "Deposit 1L"){
            if(currentBlood == totalBlood){
                llOwnerSay("BARREL FULL"); //FIXME - 
                menu(id);
            }
            else{
                currentBlood += 1.0;
                llSay(listenChannel, "deposit 1.0");
                updateTimeDisp();
                menu(id);
            }
        }
        else if (message == "Withdraw 1L"){
            if(currentBlood == 0.0){
                llOwnerSay("BARREL EMPTY"); //FIXME - 
                menu(id);
            }
            else{
                currentBlood -= 1.0;
                llSay(listenChannel, "withdraw 1.0");
                updateTimeDisp();
                menu(id);
            }
        }
        else if (message == "Settings")
            settingsMenu(id);
        else if (message == "Textures")
            texturesMenu(id);
        else if (message == "texture1"){
            texture1_enabled = TRUE;
            texture2_enabled = FALSE;
            texture3_enabled = FALSE;
            llSetLinkTexture(LINK_THIS, texture1, ALL_SIDES);
            llSetObjectName("");
            llOwnerSay("Barrel Texture Changed!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "texture2"){
            texture1_enabled = FALSE;
            texture2_enabled = TRUE;
            texture3_enabled = FALSE;
            llSetLinkTexture(LINK_THIS, texture2, ALL_SIDES);
            llSetObjectName("");
            llOwnerSay("Barrel Texture Changed!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "texture3"){
            texture1_enabled = FALSE;
            texture2_enabled = FALSE;
            texture3_enabled = TRUE;
            llSetLinkTexture(LINK_THIS, texture3, ALL_SIDES);
            llSetObjectName("");
            llOwnerSay("Barrel Texture Changed!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
    }

    timer()
    {
        if(METERfound)
            METERfound == FALSE;
        state waiting;
    }
}

state looking
{
    state_entry()
    {
        llListenRemove(listen_handle);
        llSetText("Waiting fo Carnage Meter...\n" + llDumpList2String(Charsetx, ""), color, 1.0);
        llListen(listenChannel, "", "", "");
        llSetTimerEvent(1);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == listenChannel){
            if(llGetOwnerKey(id) == llGetOwner()){
                if(message == "METER_FOUND")
                    METERfound = TRUE;
                else if(message == "METER_NOTFOUND")
                    state waiting;
            }
        }
    }

    timer()
    {
        integer num = 10;
        if(!METERfound){
            waittime -= num;
            if(waittime < 7)
                color = <1,1,0>;
            if(waittime < 4)
                color = <1,0,0>;
            if(waittime == 0){
                waittime = 10;
                color = <0,1,0>;
            }
            zList = llList2List(Charsetx, 0, waittime);
            pList = llDumpList2String(zList, "");
            llSetText("Please Wait...\n" + pList, color, 1.0);
            llSay(listenChannel, "METER_OK");
        }
        else{
            llSetText("DONE...", color, 1.0);
            llSleep(3.0);
            state default;
        }
    }
}

state waiting
{
    state_entry()
    {
        llListenRemove(listen_handle);
        llSetText("Waiting for " + (string)llGetDisplayName(owner) + " (" + (string)llKey2Name(owner) + ")", color, 1.0);
        METERfound = FALSE;
    }

    touch_start(integer num_detected)
    {
        key id = llDetectedKey(0);
        if(llGetOwnerKey(id) == owner){
            if(!METERfound)
                state looking;
            else
                menu(id);
        }
        else
            llSay(0, "Sorry only " + (string)llGetDisplayName(owner) + " (" + (string)llKey2Name(owner) + ") has access!");
    }

    state_exit()
    {
        llSetText("", color, 1.0);
    }
}