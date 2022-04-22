key owner;

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
integer userBlood           = TRUE;

list main_menu;
list Settings_Menu;
list Textures_Menu;
list zList          = [];
list Charsetx       = ["█","█","█","█","█","█","█","█","█","█"];

string desc_        = "(c)Amy (meljonna Resident) -";
string objectName   = "Carnage - Blood Barrel";
string origName;
string pList;

vector titleColor   = <0.905, 0.686, 0.924>;
vector color        = <0, 1, 0>;

/* ■ □ */
string Float2String ( float num, integer places, integer rnd)
{
    if (rnd){
        float f = llPow(10.0, places);
        integer i = llRound(llFabs(num) * f);
        string s = "00000" + (string)i;
        if(num < 0.0)
            return "-" + (string)( (integer)(i / f)) + "." + llGetSubString(s, -places, -1);
        return (string)((integer)(i / f)) + "." + llGetSubString(s, -places, -1);
    }
    if (!places)
        return (string)((integer)num);
    if ( (places = (places - 7 - (places < 1))) & 0x80000000)
        return llGetSubString((string)num, 0, places);
    return (string)num;
}

menu(key _id)
{
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    main_menu = ["Deposit 1L", "Withdraw 1L", "Done", "▼"];
    llDialog(_id, "Hello " + (string)llGetDisplayName(_id) + " (" + (string)llKey2Name(_id) + ") Select an option\nCurrent Blood volume :: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + 
        " liters(s)", main_menu, channel);
}

updateTimeDisp()
{
    //NOTE THIS IS MY BEEN LAZY LOL!!!!!
    if(currentBlood == 10.0){
        zList = ["█","█","█","█","█","█","█","█","█","█"];
        titleColor = <0.055, 0.965, 0.031>;
    }
    else if(currentBlood == 9.0){
        zList = ["█","█","█","█","█","█","█","█","█"];
        titleColor = <0.275, 0.965, 0.031>;
    }
    else if(currentBlood == 8.0){
        zList = ["█","█","█","█","█","█","█","█"];
        titleColor = <0.404, 0.965, 0.031>;
    }
    else if(currentBlood == 7.0){
        zList = ["█","█","█","█","█","█","█"];
        titleColor = <0.667, 0.965, 0.031>;
    }
    else if(currentBlood == 6.0){
        zList = ["█","█","█","█","█","█"];
        titleColor = <0.788, 0.965, 0.031>;
    }
    else if(currentBlood == 5.0){
        zList = ["█","█","█","█","█"];
        titleColor = <0.965, 0.965, 0.031>;
    }
    else if(currentBlood == 4.0){
        zList = ["█","█","█","█"];
        titleColor = <0.965, 0.667, 0.031>;
    }
    else if(currentBlood == 3.0){
        zList = ["█","█","█"];
        titleColor = <0.965, 0.404, 0.031>;
    }
    else if(currentBlood == 2.0){
        zList = ["█","█"];
        titleColor = <0.965, 0.275, 0.031>;
    }
    else if(currentBlood == 1.0){
        zList = ["█"];
        titleColor = <0.969, 0.165, 0.031>;
    }
    else{
        zList = [];
        titleColor = <0.969, 0.055, 0.031>;
    }
    llSetText(
        (string)llGetDisplayName(owner) 
        + " (" + (string)llKey2Name(owner) 
        + ")\nBlood Barrel 10L\nTotal Blood: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + "L\n"
        + (string)zList, titleColor, 1);
    llSetObjectName(objectName + " " + (string)Float2String(currentBlood, 0, FALSE) + "/" + (string)Float2String(totalBlood, 0, FALSE) + "L");
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
            else if (message == "noBlood"){  // deposit
                if(userBlood){
                    userBlood = FALSE;
                    llOwnerSay("you have no blood!");
                }
            }
            else if (message == "fullBlood"){ //Withdraw
                if(!userBlood){
                    userBlood = TRUE;
                    llOwnerSay("you are full!");
                }
            } 
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
                if (userBlood){
                    currentBlood += 1.0;
                    llSay(listenChannel, "deposit 1.0");
                    updateTimeDisp();
                    menu(id);
                }
            }
        }
        else if (message == "Withdraw 1L"){
            if(currentBlood == 0.0){
                llOwnerSay("BARREL EMPTY"); //FIXME - 
                menu(id);
            }
            else{
                if (userBlood){
                    currentBlood -= 1.0;
                    llSay(listenChannel, "withdraw 1.0");
                    updateTimeDisp();
                    menu(id);
                }
            } 
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
        llSetObjectName(objectName + " " + (string)Float2String(currentBlood, 0, FALSE) + "/" + (string)Float2String(totalBlood, 0, FALSE) + "L");
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
        llSetObjectName(objectName + " " + (string)Float2String(currentBlood, 0, FALSE) + "/" + (string)Float2String(totalBlood, 0, FALSE) + "L");
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