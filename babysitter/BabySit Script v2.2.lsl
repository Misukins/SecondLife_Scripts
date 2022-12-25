float   updateInterval = 60.0;

string  tierName;
integer   rentalCost;
integer   rentalCost_a;
integer   rentalCost_b;
integer   rentalCost_c;
integer primCount;
integer rentalVolume;
float   refundFee;
key     renterID;
string  renterName;
float   rentalTime;
integer listenQueryID;
vector  initPos;
vector  initScale;
integer count;
integer lineCount;
key     readKey;
string  rentalGrade;
integer primAllotment;

integer profile_pic_side = 0;
integer profile_key_prefix_length;
integer profile_img_prefix_length;

key rentthisspace;

string url = "http://world.secondlife.com/resident/";
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
string status;
string settings_file = "Babysit Settings";
string url_a = "secondlife:///app/agent/";
string about = "/about";

key owner;
key manager;
key partner;
key partner_a;
key partner_b;
key partner_c;

float ONE_WEEK = 604800.0;
float ONE_DAY  = 86400.0;
float ONE_HOUR = 3600.0;

dispString(string value)
{
    llSetText(value, <0.827, 0.690, 0.855>, 1);
}

sendReminder(string message)
{ 
    llInstantMessage(renterID, "Daycare lease, will expire " + message);
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
    return (string)days + " days, " + (string)hours + " hours, " + (string)minutes + " minutes.";
}
 
integer setupDialogListen()
{
    integer chatChannel = (integer)llFrand(2000000);
    llListenRemove(listenQueryID);
    listenQueryID = llListen(chatChannel, "", NULL_KEY, "");
    return chatChannel;
}
 
updateTimeDisp()
{ 
    dispString("Leased by: " + renterName + "\nTime Remaining: " + getTimeString(llRound(rentalTime)));   
}
 
dispData()
{
    llWhisper(0, "========================");
    llWhisper(0, "Daycare Rental Information");
    llWhisper(0, "========================");
    llWhisper(0, "This space is currently leased by " + renterName);
    llWhisper(0, "The current rental price is L$" + (string)((integer)rentalCost) + " a week.");
    llWhisper(0, "This space will be open for lease in " + getTimeString(llRound(rentalTime)) + "."); 
    llWhisper(0, "Memory Free: " + (string)llGetFreeMemory());
}

printList(key id)
{
    if (owner != "")
    {
        llInstantMessage(id,"Owner of this Daycare: " + url_a + (string)owner + about);
    }
    else
    {
        llInstantMessage(id,"No Owner");
    }

    if (manager != "")
    {
        llInstantMessage(id,"Manager of this Daycare: " + url_a + (string)manager + about);
    }
    else
    {
        llInstantMessage(id,"No Manager");
    }
    
    if (partner != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url_a + (string)partner + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
    }
    
    if (partner_a != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url_a + (string)partner_a + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
    }
    
    if (partner_b != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url_a + (string)partner_b + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
    }
    
    if (partner_c != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url_a + (string)partner_c + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
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
        llAllowInventoryDrop(FALSE);
        llSetTimerEvent(300);
        llOwnerSay("Waiting to obtain Debit Permissions.");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions & PERMISSION_DEBIT)
        {
            state loadSettings;
        }
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
        for (x = 0; x < total_number; x += 1)
        {
            if (llDetectedKey(x) == llGetOwner())
            {
                llResetScript();
            }
        }
        llWhisper(0, "Waiting to obtain Debit Permissions from Owner.");
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
        llWhisper(0, "Initialized.");
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
        for (x = 0; x < llGetInventoryNumber(INVENTORY_NOTECARD); x += 1)
        {
            if (llGetInventoryName(INVENTORY_NOTECARD, x) == settings_file)
            {
                found = TRUE; 
            }
        }
        if (found)
        {
            llOwnerSay("Reading Settings Notecard...");
            readKey = llGetNotecardLine(settings_file, lineCount); 
        }
        else
        {
            llOwnerSay("Settings Notecard Not Found.");
            llResetScript();
        }
    }
    
    dataserver(key requested, string data)
    {
        integer integerData;
        string  stringData;
        if (requested == readKey) 
        { 
            if (data != EOF)
            {
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " "))
                {
                    integerData = (integer)data;
                    stringData  = (string)data;
                    if (count == 0)
                    {
                        tierName = data;
                    }
                    else if (count == 1)
                    {
                        if (integerData >= 0)
                            rentalCost = integerData;
                        else
                            rentalCost = 0;
                    }
                    else if (count == 2)
                    {
                        if (integerData >= 0)
                            rentalCost_a = integerData;
                        else
                            rentalCost_a = 0;
                    }
                    else if (count == 3)
                    {
                        if (integerData >= 0)
                            rentalCost_b = integerData;
                        else
                            rentalCost_b = 0;
                    }
                    else if (count == 4)
                    {
                        if (integerData >= 0)
                            rentalCost_c = integerData;
                        else
                            rentalCost_c = 0;
                    }
                    else if (count == 5)
                    {
                        if (integerData >= 0)
                            refundFee = integerData;
                        else
                            refundFee = 0;
                    }
                    else if (count == 6)
                    {
                        if (stringData == "")
                            rentthisspace = "";
                        else
                            rentthisspace = stringData;
                    }
                    else if (count == 7)
                    {
                        if (stringData == "")
                            owner = "";
                        else
                            owner = stringData;
                    }
                    else if (count == 8)
                    {
                        if (stringData == "")
                            manager = "";
                        else
                            manager = stringData;
                    }
                    else if (count == 9)
                    {
                        if (stringData == "")
                            partner = "";
                        else
                            partner = stringData;
                    }
                    else if (count == 10)
                    {
                        if (stringData == "")
                            partner_a = "";
                        else
                            partner_a = stringData;
                    }
                    else if (count == 11)
                    {
                        if (stringData == "")
                            partner_b = "";
                        else
                            partner_b = stringData;
                    }
                    else if (count == 12)
                    {
                        if (stringData == "")
                            partner_c = "";
                        else
                            partner_c = stringData;
                    }
                    count += 1;
                }
                lineCount += 1;
                readKey = llGetNotecardLine(settings_file, lineCount);
            }
            else
            {
                llOwnerSay("===============");
                llOwnerSay("Settings Loaded");
                llOwnerSay("===============");
                llOwnerSay("Space Name: " + tierName);
                llOwnerSay("Rental Cost(1 week): L$" + (string)llRound(rentalCost));
                llOwnerSay("Rental Cost(2 weeks): L$" + (string)llRound(rentalCost_a));
                llOwnerSay("Rental Cost(3 weeks): L$" + (string)llRound(rentalCost_b));
                llOwnerSay("Rental Cost(4 weeks): L$" + (string)llRound(rentalCost_c));
                llOwnerSay("Refund Fee: L$" + (string)refundFee);
                llOwnerSay("Default Texture UUID: " + (string)rentthisspace);
                llOwnerSay("Owner UUID: " + (string)owner + " Name: (" + llGetDisplayName(owner) + ")");
                llOwnerSay("Manager UUID: " + (string)manager + " Name: (" + llGetDisplayName(manager) + ")");
                llOwnerSay("Employee #1 UUID: " + (string)partner + " Name: (" + llGetDisplayName(partner) + ")");
                llOwnerSay("Employee #2 UUID: " + (string)partner_a + " Name: (" + llGetDisplayName(partner_a) + ")");
                llOwnerSay("Employee #3 UUID: " + (string)partner_b + " Name: (" + llGetDisplayName(partner_b) + ")");
                llOwnerSay("Employee #4 UUID: " + (string)partner_c + " Name: (" + llGetDisplayName(partner_c) + ")");
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                list savedList = llParseString2List(llGetObjectDesc(), ["|"], []);
                if (llGetListLength(savedList) == 3)
                {
                    renterID    = llList2Key(savedList, 01);
                    renterName  = llList2String(savedList, 1);
                    rentalTime  = llList2Integer(savedList, 2);
                    state rented;
                }
                else
                {
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
        llSetObjectDesc("");
        llSetPayPrice(rentalCost, [rentalCost, rentalCost_a, rentalCost_b, rentalCost_c]);
        llSetTexture(rentthisspace, profile_pic_side);
        llSetTimerEvent(updateInterval);
        dispString(tierName + "\nLease this space for L$" + (string)llRound(rentalCost) + " a week.\nPay this Sign to begin your lease.");
    }
    
    touch_start(integer num_detected)
    {
        integer x;
        integer chatChannel;
        for (x = 0; x < num_detected; x += 1)
        {
            if (llDetectedKey(x) == owner)
            {
                llDialog(owner, "Owner Options.  Select one of the options below...", ["Info", "Access", "Reset"], setupDialogListen());
                return;
            }
            else if (llDetectedKey(x) == manager)
            {
                llDialog(manager, "Manager Options.  Select one of the options below...", ["Info", "Access", "Reset"], setupDialogListen());
                return;
            }
            else if (llDetectedKey(x) == partner)
            {
                llDialog(partner, "Partner Options.  Select one of the options below...", ["Info", "Reset"], setupDialogListen());
                return;
            }
            else if (llDetectedKey(x) == partner_a)
            {
                llDialog(partner_a, "Employee Options.  Select one of the options below...", ["Info", "Reset"], setupDialogListen());
                return;
            }
            else if (llDetectedKey(x) == partner_b)
            {
                llDialog(partner_b, "Employee Options.  Select one of the options below...", ["Info", "Reset"], setupDialogListen());
                return;
            }
            else if (llDetectedKey(x) == partner_c)
            {
                llDialog(partner_c, "Employee Options.  Select one of the options below...", ["Info", "Reset"], setupDialogListen());
                return;
            }
        }
        llWhisper(0, "Lease this space for L$" + (string)llRound(rentalCost) + " a week.. Pay this Sign to begin your lease."); 
    }
    
    changed(integer mask)
    {
        if(mask & (CHANGED_OWNER))
            llResetScript();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Reset")
        {
            llResetScript();
        }
        else if (message == "Access")
        {
            printList(id);
        }
        else if (message == "Info")
        {
            llListenRemove(listenQueryID);
            dispData();
            llWhisper(0, "Lease this space for L$" + (string)llRound(rentalCost) + " a week. Pay this Sign to begin your lease.");;
        }
    }
      
    money(key id, integer amount)
    {
        if (amount >= rentalCost)
        {
            renterID   = id;
            renterName = llKey2Name(renterID);
            rentalTime = ONE_WEEK * amount / rentalCost;
            saveData();
            llInstantMessage(llGetOwner(),llKey2Name(id) + " made a purchase for L$"  + (string)amount + ".");
            llWhisper(0, "Thank you " + renterName + " for leasing!  Your lease will expire in " + getTimeString((integer)rentalTime) + ".");
            state rented;
        }
        else
        {
            llWhisper(0, "This space costs L$" + (string)rentalCost + " to rent. Refunding paid balance.");
            llGiveMoney(id, amount);
        }
    }
}
 
state rented
{
    state_entry()
    {
        llSetPayPrice(rentalCost, [rentalCost, rentalCost_a, rentalCost_b, rentalCost_c]);
        llRequestAgentData(renterID, DATA_NAME);
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        updateTimeDisp();
        llResetTime();
        llSetTimerEvent(updateInterval);
    }
    
    touch_start(integer num_detected)
    {
        integer x;
        key     detectedKey;
        for (x = 0; x < num_detected; x += 1)
        {
            detectedKey = llDetectedKey(x);
            if (detectedKey == owner)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info", "Release", "Reset"], setupDialogListen());
            else if (detectedKey == manager)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info", "Release", "Reset"], setupDialogListen());
            else if (detectedKey == partner)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info", "Release", "Reset"], setupDialogListen());
            else if (detectedKey == partner_a)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info", "Release", "Reset"], setupDialogListen());
            else if (detectedKey == partner_b)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info", "Release", "Reset"], setupDialogListen());
            else if (detectedKey == partner_c)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info", "Release", "Reset"], setupDialogListen());
            else if (detectedKey == renterID)
                llDialog(detectedKey, "Lease Options. Select one of the options below...", ["Refund Time", "Info"], setupDialogListen());
            else
                dispData();
        }
    }
    
    changed(integer mask)
    {
        if(mask & (CHANGED_ALLOWED_DROP | CHANGED_INVENTORY))
        {
            llWhisper(0, "Thank you, your picture has been changed... Please stand up...");
        }
    }
    
    money(key id, integer amount)
    {
        if ((id == renterID)||(id == llGetOwner()))
        {
            float addTime;
            addTime = ONE_WEEK*amount/rentalCost;
            rentalTime += addTime;
            llInstantMessage(llGetOwner(),llKey2Name(id) + " made a purchase for L$"  + (string)amount + ".");
            llInstantMessage(id, "Adding " + getTimeString(llRound(addTime)) + " to your lease. Lease Time is Now: " + getTimeString(llRound(rentalTime)) + ".");
            saveData();
            updateTimeDisp();
        }
        else
        {
            llInstantMessage(id, "Refunding Money...");
            llGiveMoney(id, amount);
            llInstantMessage(id, "This space is currently leased by " + renterName + ". This space will be open for lease in " + getTimeString(llRound(rentalTime)) + "."); 
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        integer refundAmount;
        llListenRemove(listenQueryID);
        if (message == "Info")
        {
            dispData();
        }
        else if (message == "Refund Time")
        {
            llDialog(id, "Are you sure you want to TERMINATE your lease and refund your money, minus a L$" + (string)refundFee + " fee?", ["YES", "NO"], setupDialogListen());
        }
        else if (message == "YES")
        {
            refundAmount = llRound((rentalTime/ONE_HOUR)*rentalCost - refundFee);
            llInstantMessage(renterID, "Refunding L$" + (string)refundAmount + ", which includes a L$" + (string)refundFee + " termination fee.");
            llGiveMoney(renterID, refundAmount);
            llInstantMessage(llGetOwner(), "LEASE REFUNDED: leased by " + renterName + " has ended. Refunded L$" + (string)refundAmount + ".");
            state idle;
        }
        else if (message == "Release")
        {
            llDialog(id, "Are you sure you want to TERMINATE this lease with NO REFUND?", ["Yes", "No"], setupDialogListen());
        }
        else if (message == "Yes")
        {
            llInstantMessage(llGetOwner(), "LEASE TERMINATED: leased by " + renterName + " has ended. Refunded L$0.");
            state idle;            
        }
        else if (message == "Reset")
        {
            llResetScript();
        }
    }
    
    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
        {
            timeElapsed = updateInterval;
        }
        rentalTime -= timeElapsed;
        saveData();
        updateTimeDisp(); 
        if (rentalTime <= 0)
        {
            llInstantMessage(llGetOwner(), "LEASE EXPIRED: leased by " + renterName + " has expired.");
            state idle;
        }
        if ((rentalTime <= ONE_DAY)&&(rentalTime >= ONE_DAY - (updateInterval*2)))
        {
            sendReminder("in one day.");
        }
        else if ((rentalTime <= ONE_HOUR*12)&&(rentalTime >= ONE_HOUR*12 - (updateInterval*2)))
        {
            sendReminder("in 12 hours.");
        }
        else
        if ((rentalTime <= ONE_HOUR)&&(rentalTime >= ONE_HOUR - (updateInterval*2)))
        {
            sendReminder("in one hour.");
        }
        llHTTPRequest(url + (string)renterID, [HTTP_METHOD, "GET"], "");
        llRequestAgentData(renterID, DATA_ONLINE);  
    }
    
    dataserver(key queryid, string data)
    {
        if ( data == "1" ) 
        {
            //
        }
        else if (data == "0")
        {
            //
        }
    }
    
    http_response(key request_id,integer status, list metadata, string body)
    {
        string profile_pic;
        integer s1 = llSubStringIndex(body, profile_key_prefix);
        integer s1l = profile_key_prefix_length;
        if(s1 == -1)
        {
            s1 = llSubStringIndex(body, profile_img_prefix);
            s1l = profile_img_prefix_length;
        }
 
        if (s1 == -1)
        {
            profile_pic = rentthisspace;
        }
        else
        {
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
            {
                profile_pic = rentthisspace;
            }
        }
        llSetTexture(profile_pic, profile_pic_side);
    }
}