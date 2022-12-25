key blank;
key sticker_blank;
key heart_texture;
key renterID;
key readKey;
key owner;
key manager;
key partner;
key partner_a;
key partner_b;
key partner_c;

string renterName;
string url = "http://world.secondlife.com/resident/";
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
string status;
string settings_file = "StickerBoard Settings";
string url_a = "secondlife:///app/agent/";
string about = "/about";

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
integer profile_key_prefix_length;
integer profile_img_prefix_length;
integer profile_pic_side = 5;
integer sticker_side = 2;

integer count;
integer lineCount;

integer numberPicture = 0;
integer totalPictures = 6;

integer cost;

string nameObject = "blank";

float sticker_default_scale = 1.00000;
float sticker_default_offset = 0.00000;

float sticker_one_scale = 3.30000;
float sticker_one_offset = -0.15000;

float sticker_two_scale = 6.60000;
float sticker_two_offset = -0.80000;

float sticker_three_scale = 10.00000;
float sticker_three_offset = -0.50000;

float sticker_four_scale = 13.40000;
float sticker_four_offset = -0.20000;

float sticker_five_scale = 16.80000;
float sticker_five_offset = 0.10000;

float sticker_six_scale = 1.00000;
float sticker_six_offset = 0.00000;

DoOnlineMenu()
{
    list name = llParseString2List(llGetDisplayName(llDetectedKey(0)), [""], []);
    list user = llParseString2List(llGetDisplayName(renterID), [""], []);
    list main_menu = [ "Add", "Remove", "Clear", "Access", "Exit" ];
    llDialog(llDetectedKey(0),"Hey " + (string)name + "\nThis is " + (string)user + "'s Board\nPlease select your option:",main_menu,channel);
}

DoOfflineMenu()
{
    list name = llParseString2List(llGetDisplayName(llDetectedKey(0)), [""], []);
    list user = llParseString2List(llGetDisplayName(renterID), [""], []);
    list main_menu = [ "Clear", "Access", "Exit" ];
    llDialog(llDetectedKey(0),"Hey " + (string)name + "\nThis is " + (string)user + "'s Board\nPlease select your option:",main_menu,channel);
}

init() 
{
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", llDetectedKey(0), "");
    llRequestAgentData(renterID, DATA_NAME);
}

forward()
{
    numberPicture++;
    if (numberPicture == 0)
        llSetTexture(sticker_blank, sticker_side);
    else if (numberPicture == 1)
    {
        llScaleTexture(sticker_one_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_one_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 1;
    }
    else if (numberPicture == 2)
    {
        llScaleTexture(sticker_two_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_two_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 2;
    }
    else if (numberPicture == 3)
    {
        llScaleTexture(sticker_three_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_three_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 3;
    }
    else if (numberPicture == 4)
    {
        llScaleTexture(sticker_four_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_four_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 4;
    }
    else if (numberPicture == 5)
    {
        llScaleTexture(sticker_five_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_five_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 5;
    }
    else if (numberPicture == 6)
    {
        llScaleTexture(sticker_six_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_six_offset, sticker_default_offset, sticker_side);
        llSetTexture(sticker_blank, sticker_side);
        numberPicture = 0;
    }
}

back()
{
    numberPicture = numberPicture - 1;
    if (numberPicture == 0)
        llSetTexture(sticker_blank, sticker_side);
    else if (numberPicture == 1)
    {
        llScaleTexture(sticker_one_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_one_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 1;
    }
    else if (numberPicture == 2)
    {
        llScaleTexture(sticker_two_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_two_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 2;
    }
    else if (numberPicture == 3)
    {
        llScaleTexture(sticker_three_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_three_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 3;
    }
    else if (numberPicture == 4)
    {
        llScaleTexture(sticker_four_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_four_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 4;
    }
    else if (numberPicture == 5)
    {
        llScaleTexture(sticker_five_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_five_offset, sticker_default_offset, sticker_side);
        llSetTexture(heart_texture, sticker_side);
        numberPicture = 5;
    }
    else if (numberPicture == 6)
    {
        llScaleTexture(sticker_six_scale, sticker_default_scale, sticker_side);
        llOffsetTexture(sticker_six_offset, sticker_default_offset, sticker_side);
        llSetTexture(sticker_blank, sticker_side);
        numberPicture = 0;
    }
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

dumpAccessList()
{
    /*
    renterName = llKey2Name(renterID);
    list user = llParseString2List(llGetDisplayName(renterID), [""], []);
    llInstantMessage(owner, "added user: " + (string)user + "(" + (string)renterName + ")");
    llInstantMessage(manager, "added user: " + (string)user + "(" + (string)renterName + ")");
    llInstantMessage(partner, "added user: " + (string)user + "(" + (string)renterName + ")");
    llInstantMessage(partner_a, "added user: " + (string)user + "(" + (string)renterName + ")");
    llInstantMessage(partner_b, "added user: " + (string)user + "(" + (string)renterName + ")");
    llInstantMessage(partner_c, "added user: " + (string)user + "(" + (string)renterName + ")");
    */
}

saveData()
{
    list saveData;
    saveData += renterID;
    saveData += renterName;
    llSetObjectDesc(llDumpList2String(saveData, "|"));
}

dispData()
{
    llWhisper(0, "==========================");
    llWhisper(0, "  Daycare Sticker Board");
    llWhisper(0, "==========================");
    llWhisper(0, "To get a stickers you have to buy this slot first.");
    llWhisper(0, "It will cost you only $" + (string)cost + "L, but you will get it back.");
    llWhisper(0, "Just right click and pay $" + (string)cost + "L.");
}

default
{
    state_entry()
    {
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
    
    state_exit()
    {
        llSetTimerEvent(0);
        llOwnerSay("Initialized.");
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
                        if (integerData >= 0)
                        {
                            cost = integerData;
                        }
                        else
                        {
                            cost = 0;
                        }
                    }
                    else if (count == 1)
                    {
                        if (stringData == "")
                        {
                            blank = "";
                        }
                        else
                        {
                            blank = stringData;
                        }
                    }
                    else if (count == 2)
                    {
                        if (stringData == "")
                        {
                            sticker_blank = "";
                        }
                        else
                        {
                            sticker_blank = stringData;
                        }
                    }
                    else if (count == 3)
                    {
                        if (stringData == "")
                        {
                            heart_texture = "";
                        }
                        else
                        {
                            heart_texture = stringData;
                        }
                    }
                    else if (count == 4)
                    {
                        if (stringData == "")
                        {
                            owner = "";
                        }
                        else
                        {
                            owner = stringData;
                        }
                    }
                    else if (count == 5)
                    {
                        if (stringData == "")
                        {
                            manager = "";
                        }
                        else
                        {
                            manager = stringData;
                        }
                    }
                    else if (count == 6)
                    {
                        if (stringData == "")
                        {
                            partner = "";
                        }
                        else
                        {
                            partner = stringData;
                        }
                    }
                    else if (count == 7)
                    {
                        if (stringData == "")
                        {
                            partner_a = "";
                        }
                        else
                        {
                            partner_a = stringData;
                        }
                    }
                    else if (count == 8)
                    {
                        if (stringData == "")
                        {
                            partner_b = "";
                        }
                        else
                        {
                            partner_b = stringData;
                        }
                    }
                    else if (count == 9)
                    {
                        if (stringData == "")
                        {
                            partner_c = "";
                        }
                        else
                        {
                            partner_c = stringData;
                        }
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
                llOwnerSay("Cost: L$" + (string)llRound(cost));
                llOwnerSay("Owner UUID: " + (string)owner + " Name: (" + llGetDisplayName(owner) + ")");
                llOwnerSay("Manager UUID: " + (string)manager + " Name: (" + llGetDisplayName(manager) + ")");
                llOwnerSay("Employee #1 UUID: " + (string)partner + " Name: (" + llGetDisplayName(partner) + ")");
                llOwnerSay("Employee #2 UUID: " + (string)partner_a + " Name: (" + llGetDisplayName(partner_a) + ")");
                llOwnerSay("Employee #3 UUID: " + (string)partner_b + " Name: (" + llGetDisplayName(partner_b) + ")");
                llOwnerSay("Employee #4 UUID: " + (string)partner_c + " Name: (" + llGetDisplayName(partner_c) + ")");
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                list savedList = llParseString2List(llGetObjectDesc(), ["|"], []);
                if (llGetListLength(savedList) == 2)
                {
                    renterID    = llList2Key(savedList, 01);
                    renterName  = llList2String(savedList, 1);
                    state used_online;
                }
                else
                {
                    renterID   = NULL_KEY;
                    renterName = "Nobody";
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
        llSetPayPrice(cost, [cost, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        llSetTexture(sticker_blank, sticker_side);
        llSetTexture(blank, profile_pic_side);
    }
    
    touch_start(integer total_number)
    {
        dispData();
    }
    
    changed(integer mask)
    {
        if(mask & (CHANGED_OWNER))
            llResetScript();
    }
    
    money(key id, integer amount)
    {
        if (amount == cost)
        {
            renterID   = id;
            renterName = llKey2Name(renterID);
            saveData();
            dumpAccessList();
            llGiveMoney(id, cost);
            state used_online;
        }
        else
        {
            llGiveMoney(id, amount);
        }
    }
    
}

state used_online
{
    state_entry()
    {
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        globalListenHandle = llListen(channel, "", llDetectedKey(0), "");
        init();
        llSetTimerEvent(10);
    }
    
    touch_start(integer total_number)
    {
        renterName = llGetDisplayName(renterID);
        list user = llParseString2List(renterName, [""], []);
        key detectedKey = llDetectedKey(0);
        if (detectedKey == owner)
            DoOnlineMenu();
        else if (detectedKey == manager)
            DoOnlineMenu();
        else if (detectedKey == partner)
            DoOnlineMenu();
        else if (detectedKey == partner_a)
            DoOnlineMenu();
        else if (detectedKey == partner_b)
            DoOnlineMenu();
        else if (detectedKey == partner_c)
            DoOnlineMenu();
        else
            llWhisper(0, (string)user +"'s board");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        list name = llParseString2List(llGetDisplayName(id), [""], []);
        list user = llParseString2List(llGetDisplayName(renterID), [""], []);
        if (message == "Exit")
        {
            return;
        }
        else if (message == "Add")
        {
            forward();
            if (numberPicture != 6)
                llWhisper(0, (string)name + " gave a sticker to " + (string)user);
        }
        else if (message == "Remove")
        {
            back();
            if (numberPicture != 6)
                llWhisper(0, (string)name + " took a sticker from " + (string)user);
        }
        else if (message == "Access")
        {
            printList(id);
        }
        else if (message == "Clear")
        {
            state idle;
        }
    }
    
    timer()
    {
        llHTTPRequest(url + (string)renterID, [HTTP_METHOD, "GET"], "");
        llRequestAgentData(renterID, DATA_ONLINE);   
    }
    
    dataserver(key queryid, string data)
    {
        if ( data == "1" ) 
        {
            state used_online;
        }
        else if (data == "0")
        {
            state used_offline;
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
            profile_pic = blank;
        }
        else
        {
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
            {
                profile_pic = blank;
            }
        }
        llSetTexture(profile_pic, profile_pic_side);
    }
    
    state_exit()
    {
        llListenRemove(globalListenHandle);
    }
}

state used_offline
{
    state_entry()
    {
        llSetTimerEvent(10);
    }
    
    timer()
    {
        llRequestAgentData(renterID, DATA_ONLINE);   
    }
    
    touch_start(integer total_number)
    {
        key detectedKey = llDetectedKey(0);
        if (detectedKey == owner)
            DoOfflineMenu();
        else if (detectedKey == manager)
            DoOfflineMenu();
        else if (detectedKey == partner)
            DoOfflineMenu();
        else if (detectedKey == partner_a)
            DoOfflineMenu();
        else if (detectedKey == partner_b)
            DoOfflineMenu();
        else if (detectedKey == partner_c)
            DoOfflineMenu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Exit")
        {
            return;
        }
        else if (message == "Access")
        {
            printList(id);
        }
        else if (message == "Clear")
        {
            state idle;
        }
    }
    
    dataserver(key queryid, string data)
    {
        if ( data == "1" ) 
        {
            state used_online;
        }
        else if (data == "0")
        {
            state used_offline;
        }
    }
}