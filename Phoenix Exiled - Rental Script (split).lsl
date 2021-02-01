key     renterID;
key     readKey;
key     partnerID;
key     manager1ID;
key     manager2ID;
key     manager3ID;
key     manager4ID;
key     manager5ID;
key     manager6ID;

float   ONE_WEEK = 604800.0;
float   ONE_DAY  = 86400.0;
float   ONE_HOUR = 3600.0;
float   rentalTime;
float   updateInterval = 60.0;
float   split;

integer rentalCost;
integer two_rentalCost;
integer three_rentalCost;
integer four_rentalCost;
integer listenQueryID;
integer primCount;
integer count;
integer lineCount;
integer primAllotment;
integer listener;
integer channel;
integer llrented;
integer lllocked;

string  renterName;
string  infoNotecard;
string  tierName;
string  rentalGrade;
string  settings_file    = ";:Phoenix Exiled:; Rental Settings";
string  Context          = "Sit";
string  landmark;
string  security_orb;

dispString(string value)
{
    if ( llrented == 0 )
        llSetText(value, <0.553, 1.000, 0.553>, 1);
    else
        llSetText(value, <1.000, 0.584, 1.000>, 1);
}

sendReminder(string message)
{
    string globe = "http://maps.secondlife.com/secondlife";
    string region = llGetRegionName();
    vector pos = llGetPos();
    string posx = (string)llRound(pos.x);
    string posy = (string)llRound(pos.y);
    string posz = (string)llRound(pos.z);
    llInstantMessage(renterID, "Your lease located in " + globe + "/" + llEscapeURL(region) + "/" + posx + "/" + posy + "/" + posz + " will expire " + message);
}

saveData()
{
    list saveData;
    saveData += renterID;
    saveData += renterName;
    saveData += llRound(rentalTime);
    llSetObjectDesc(llDumpList2String(saveData, "|"));
}

string getTimeString(integer time)
{
    integer days;
    integer hours;
    integer minutes;
    integer seconds;
    days = llRound(time / 86400);
    time = time % 86400;
    hours = (time / 3600);
    time  = time % 3600;
    minutes = time / 60;
    time    = time % 60;
    seconds = time;
    return (string)days + " days, " + (string)hours + " hours, " + (string)minutes + " minutes";
}

updateTimeDisp()
{
    list userName = llParseString2List(llGetDisplayName(renterID), [""], []);
    dispString("\nLeased by: " + (string)userName + " (" + renterName + ")\nPrim Limit: " + (string)primCount  + "\nTime Remaining: " + getTimeString(llRound(rentalTime)));
}

dispData()
{
    list userName = llParseString2List(llGetDisplayName(renterID), [""], []);
    llSay(0, "=======================");
    llSay(0, "== ;:Phoenix Exiled:; Rental Space Information ==");
    llSay(0, "=======================");
    llSay(0, "This space is currently leased by " + (string)userName + " (" + renterName + ")");
    llSay(0, "The current rental price is L$" + (string)((integer)rentalCost) + " per week.");
    llSay(0, "This space will be open for lease in " + getTimeString(llRound(rentalTime)) + ".");
    llSay(0, "Memory Free: " + (string)llGetFreeMemory());
}

integer setupDialogListen()
{
    integer chatChannel = (integer)llFrand(2000000);
    llListenRemove(listenQueryID);
    listenQueryID = llListen(chatChannel, "", NULL_KEY, "");
    return chatChannel;
}

menu(key id)
{
    if ( llrented == 0 & lllocked == 0 ){
        if ( id == llGetOwner() ){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Owner Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager1ID){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager2ID){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager3ID){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager4ID){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager5ID){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager6ID){
            list main_menu = ["Lock", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
    }
    else if ( llrented == 1 ){
        if ( id == llGetOwner() ){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Owner Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager1ID){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager2ID){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager3ID){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager4ID){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager5ID){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager6ID){
            list main_menu = ["Release", "Landmark", "Info", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else{
            list main_menu = ["Release", "Info", "Landmark", "Exit"];
            string message = "Lease Options. Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
    }
    else if ( lllocked == 1 ){
        if ( id == llGetOwner() ){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Owner Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager1ID){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager2ID){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager3ID){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager4ID){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager5ID){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
        else if (id == manager6ID){
            list main_menu = ["Unlock", "Reset", "Exit"];
            string message = "Manager Options.  Select one of the options below...";
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, main_menu, channel);
        }
    }
}

default
{
    state_entry()
    {
        state initialize;
    }
}

state initialize
{
    state_entry()
    {
        llSetTimerEvent(300);
        llOwnerSay("Waiting to obtain Debit Permissions.");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        llSetText("Waiting to obtain Debit Permissions.", <1.0, 0, 0>, 1);
    }

    run_time_permissions(integer permissions)
    {
        if (permissions & PERMISSION_DEBIT)
            state loadSettings;
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    timer()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }

    touch_start(integer total_number)
    {
        integer x;
        for (x = 0; x < total_number; x += 1){
            if (llDetectedKey(x) == llGetOwner())
                llResetScript();
        }
        llSay(0, "Waiting to obtain Debit Permissions from Owner.");
    }

    state_exit()
    {
        llSetTimerEvent(0);
        llSay(0, "Initialized.");
    }
}

state loadSettings
{
    state_entry()
    {
        integer found = FALSE;
        integer x;
        count = 0;
        lineCount = 0;
        list savedList = llCSV2List(llGetObjectDesc());
        if (llGetListLength(savedList) == 4)
            rentalGrade = llList2String(savedList, 0);
        else
            rentalGrade = llGetObjectDesc();
        for (x = 0; x < llGetInventoryNumber(INVENTORY_NOTECARD); x += 1){
            if (llGetInventoryName(INVENTORY_NOTECARD, x) == settings_file)
                found = TRUE;
        }
        if (found){
            llOwnerSay("Reading Settings Notecard...");
            readKey = llGetNotecardLine(settings_file, lineCount);
        }
        else{
            llOwnerSay("Settings Notecard Not Found.");
            llResetScript();
        }
    }

    dataserver(key requested, string data)
    {
        integer integerData;
        float   floatData;
        string  stringData;
        if (requested == readKey){
            if (data != EOF){
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " ")){
                    integerData = (integer)data;
                    floatData   = (float)data;
                    stringData   = (string)data;
                    if (count == 0)
                        tierName = data;
                    else if (count == 1){
                        if (integerData >= 0)
                            rentalCost = integerData;
                        else
                            rentalCost = 0;
                    }
                    else if (count == 2){
                        if (integerData >= 0)
                            two_rentalCost = integerData;
                        else
                            two_rentalCost = 0;
                    }
                    else if (count == 3){
                        if (integerData >= 0)
                            three_rentalCost = integerData;
                        else
                            three_rentalCost = 0;
                    }
                    else if (count == 4){
                        if (integerData >= 0)
                            four_rentalCost = integerData;
                        else
                            four_rentalCost = 0;
                    }
                    else if (count == 5){
                        if (integerData >= 1)
                            primCount = integerData;
                        else
                            primCount = 0;
                    }
                    else if (count == 6){
                        if (floatData >= 0)
                            split = floatData;
                        else
                            split = 1.0;
                    }
                    else if (count == 7)
                        infoNotecard = data;
                    else if (count == 8)
                        partnerID = data;
                    else if (count == 9)
                        manager1ID = data;
                    else if (count == 10)
                        manager2ID = data;
                    else if (count == 11)
                        manager3ID = data;
                    else if (count == 12)
                        manager4ID = data;
                    else if (count == 13)
                        manager5ID = data;
                    else if (count == 14)
                        manager6ID = data;
                    else if (count == 15)
                        if (stringData == "")
                            landmark = "";
                        else
                            landmark = stringData;
                    /*
                    else if (count == 16)
                        if (stringData == "")
                            security_orb = "";
                        else
                            security_orb = stringData;
                    */
                    count += 1;
                }
                lineCount += 1;
                readKey = llGetNotecardLine(settings_file, lineCount);
            }
            else{
                llOwnerSay("===============");
                llOwnerSay("Settings Loaded");
                llOwnerSay("===============");
                llOwnerSay("Space Name: " + tierName);
                llOwnerSay("Rental Cost: L$" + (string)rentalCost + ", " + (string)two_rentalCost +  ", " + (string)three_rentalCost + ", " + (string)four_rentalCost);
                llOwnerSay("Prim Count: " + (string)primCount);
                llOwnerSay("Split: " + (string)split + "%");
                llOwnerSay("Partner: " + (string)llKey2Name(partnerID));
                llOwnerSay("Manager #1: " + (string)llKey2Name(manager1ID));
                llOwnerSay("Manager #2: " + (string)llKey2Name(manager2ID));
                llOwnerSay("Manager #3: " + (string)llKey2Name(manager3ID));
                llOwnerSay("Manager #4: " + (string)llKey2Name(manager4ID));
                llOwnerSay("Manager #5: " + (string)llKey2Name(manager5ID));
                llOwnerSay("Manager #6: " + (string)llKey2Name(manager6ID));
                llOwnerSay("Help NoteCard: " + (string)infoNotecard);
                llOwnerSay("Landmark: " + (string)landmark);
                //llOwnerSay("Security Orb: " + (string)security_orb);
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                list savedList = llParseString2List(llGetObjectDesc(), ["|"], []);
                if (llGetListLength(savedList) == 3){
                    renterID    = llList2Key(savedList, 01);
                    renterName  = llList2String(savedList, 1);
                    rentalTime  = llList2Integer(savedList, 2);
                    state rented;
                }
                else{
                    renterID   = NULL_KEY;
                    renterName = "Nobody";
                    rentalTime = 0;
                    state idle;
                }
            }
        }
    }
}

state idle
{
    state_entry()
    {
        llSetSitText(Context);
        llSetObjectDesc("");
        llSetPayPrice(rentalCost, [rentalCost, two_rentalCost, three_rentalCost, four_rentalCost]);
        llrented    = 0;
        lllocked    = 0;
        llSetTimerEvent(updateInterval);
        dispString(tierName + "\nLease this space for L$" + (string)rentalCost + " per week.\n" + (string)primCount + " prims\nPay this Sign to begin your lease.");
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

        if(change & INVENTORY_NOTECARD)
            llResetScript();
    }

    touch_start(integer num_detected)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner()){
            menu(id);
            return;
        }
        else if (id == manager1ID){
            menu(id);
            return;
        }
        else if (id == manager2ID){
            menu(id);
            return;
        }
        else if (id == manager3ID){
            menu(id);
            return;
        }
        else if (id == manager4ID){
            menu(id);
            return;
        }
        else if (id == manager5ID){
            menu(id);
            return;
        }
        else if (id == manager6ID){
            menu(id);
            return;
        }
        llSay(0, "Lease this space for L$" + (string)rentalCost + " per week. " + (string)primCount + " prims. Pay this Sign to begin your lease.");
        llGiveInventory(id , infoNotecard);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "Reset")
            llResetScript();
        else if (message == "Exit")
            return;
        else if (message == "Lock")
            state locked;
        else if (message == "Info"){
            llListenRemove(listenQueryID);
            dispData();
            llSay(0, "Lease this space for L$" + (string)rentalCost + " per week. " + (string)primCount + " prims. Pay this Sign to begin your lease.");
            llGiveInventory(id, infoNotecard);
        }
        else if (message == "Landmark"){
            if (landmark == "")
                llWhisper(0, "Sorry there's no Landmark yet!");
            else
                llGiveInventory(id, landmark);
        }
        else if (message == "Security"){
            if (security_orb == "")
                llWhisper(0, "Sorry there's no Security Orb yet!");
            else
                llGiveInventory(id, security_orb);
        }
    }

    money(key id, integer amount)
    {
        float s_amount = 0.0;
        if (amount >= rentalCost){
            if(partnerID != NULL_KEY){
                s_amount = (float)amount * split;
                integer s_iamount = (integer)s_amount;
                llGiveMoney(partnerID, s_iamount);
            }
            float o_amount = (float)amount -  s_amount;
            integer o_iamount = (integer)o_amount;
            renterID   = id;
            renterName = llKey2Name(renterID);
            list userName = llParseString2List(llGetDisplayName(renterID), [""], []);
            rentalTime = ONE_WEEK * amount / rentalCost;
            saveData();
            llSay(0, "Thank you " + (string)userName + " (" + renterName + ") for leasing! Your lease will expire in " + getTimeString((integer)rentalTime) + ".");
            state rented;
        }
        else{
            list user_Name = llParseString2List(llGetDisplayName(id), [""], []);
                llSay(0, "Sorry "  + (string)user_Name + " (" + llKey2Name(id) + ") This space costs " + (string)rentalCost + "L$ to rent. Refunding paid balance.");
            llGiveMoney(id, amount);
        }
    }
}

state rented
{
    state_entry()
    {
        llSetPayPrice(rentalCost, [rentalCost, two_rentalCost, three_rentalCost, four_rentalCost]);
        llrented     = 1;
        updateTimeDisp();
        llResetTime();
        llSetTimerEvent(updateInterval);
    }

    touch_start(integer num_detected)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner()){
            menu(id);
            return;
        }
        else if (id == manager1ID){
            menu(id);
            return;
        }
        else if (id == manager2ID){
            menu(id);
            return;
        }
        else if (id == manager3ID){
            menu(id);
            return;
        }
        else if (id == manager4ID){
            menu(id);
            return;
        }
        else if (id == manager5ID){
            menu(id);
            return;
        }
        else if (id == manager6ID){
            menu(id);
            return;
        }
        else if (id == renterID)
            menu(id);
        else
            dispData();
    }

    money(key id, integer amount)
    {
        if ( (id == renterID) || (id == llGetOwner()) ){
            if (amount >= rentalCost){
                float s_amount = 0.0;
                if(partnerID != NULL_KEY){
                    s_amount = (float)amount * split;
                    integer s_iamount = (integer)s_amount;
                    llGiveMoney(partnerID, s_iamount);
                }
                float o_amount = (float)amount -  s_amount;
                integer o_iamount = (integer)o_amount;
                float addTime;
                addTime = ONE_WEEK*amount/rentalCost;
                rentalTime += addTime;
                llInstantMessage(id, "Adding " + getTimeString(llRound(addTime)) + " to your lease. Lease Time is Now: " + getTimeString(llRound(rentalTime)) + ".");
                saveData();
                updateTimeDisp();
            }
            else{
                list user_Name = llParseString2List(llGetDisplayName(id), [""], []);
                llSay(0, "Sorry "  + (string)user_Name + " (" + llKey2Name(id) + ") This space costs " + (string)rentalCost + "L$ to rent. Refunding paid balance.");
                llGiveMoney(id, amount);
            }
        }
        else{
            list userName = llParseString2List(llGetDisplayName(renterID), [""], []);
            llInstantMessage(id, "Refunding Money...");
            llGiveMoney(id, amount);
            llInstantMessage(id, "This space is currently leased by " + (string)userName + " (" + renterName + "). This space will be open for lease in " + getTimeString(llRound(rentalTime)) + ".");
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        string globe = "http://maps.secondlife.com/secondlife";
        string region = llGetRegionName();
        vector pos = llGetPos();
        string posx = (string)llRound(pos.x);
        string posy = (string)llRound(pos.y);
        string posz = (string)llRound(pos.z);
        integer refundAmount;
        list userName = llParseString2List(llGetDisplayName(renterID), [""], []);
        llListenRemove(listenQueryID);
        if (message == "Info"){
            dispData();
            llGiveInventory(id, infoNotecard);
        }
        else if (message == "Release")
            llDialog(id, "Are you sure you want to TERMINATE this lease?", ["Yes", "No"], setupDialogListen());
        else if (message == "Yes"){
            llInstantMessage(llGetOwner(), "LEASE TERMINATED: leased by " + (string)userName + " (" + renterName + ") located in " + globe + "/" + llEscapeURL(region) + "/" + posx + "/" + posy + "/" + posz + " has ended.");
            state idle;
        }
        else if (message == "Reset")
            llResetScript();
        else if (message == "Exit")
            return;
        else if (message == "Landmark"){
            if (landmark == "")
                llWhisper(0, "Sorry there's no Landmark yet!");
            else
                llGiveInventory(id, landmark);
        }
        else if (message == "Security"){
            if (security_orb == "")
                llWhisper(0, "Sorry there's no Security Orb yet!");
            else
                llGiveInventory(id, security_orb);
        }
    }

    timer()
    {
        string globe = "http://maps.secondlife.com/secondlife";
        string region = llGetRegionName();
        vector pos = llGetPos();
        string posx = (string)llRound(pos.x);
        string posy = (string)llRound(pos.y);
        string posz = (string)llRound(pos.z);
        list userName = llParseString2List(llGetDisplayName(renterID), [""], []);
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
        rentalTime -= timeElapsed;
        saveData();
        updateTimeDisp();
        if (rentalTime <= 0){
            llInstantMessage(llGetOwner(), "LEASE EXPIRED: leased by " + (string)userName + " (" + renterName + ") located in " + globe + "/" + llEscapeURL(region) + "/" + posx + "/" + posy + "/" + posz + " has expired.");
            state idle;
        }
        if ((rentalTime <= ONE_DAY)&&(rentalTime >= ONE_DAY - (updateInterval*2)))
            sendReminder("in one day.");
        else if ((rentalTime <= ONE_HOUR*12)&&(rentalTime >= ONE_HOUR*12 - (updateInterval*2)))
            sendReminder("in 12 hours.");
        else if ((rentalTime <= ONE_HOUR)&&(rentalTime >= ONE_HOUR - (updateInterval*2)))
            sendReminder("in one hour.");
    }
}

state locked
{
    state_entry()
    {
        llSetObjectDesc("");
        llSetText("! Locked !", <1,0,0>, 1);
        lllocked     = 1;
    }

    touch_start(integer num_detected)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner()){
            menu(id);
            return;
        }
        else if (id == manager1ID){
            menu(id);
            return;
        }
        else if (id == manager2ID){
            menu(id);
            return;
        }
        else if (id == manager3ID){
            menu(id);
            return;
        }
        else if (id == manager4ID){
            menu(id);
            return;
        }
        else if (id == manager5ID){
            menu(id);
            return;
        }
        else if (id == manager6ID){
            menu(id);
            return;
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "Reset")
            llResetScript();
        else if (message == "Exit")
            return;
        else if (message == "Unlock")
            state idle;
    }
}