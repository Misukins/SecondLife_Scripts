key avatar;
key readKey;
key owner;
key manager;
key partner;
key partner_a;
key partner_b;
key partner_c;

integer iChanGates = 3230;
integer iChanBabyGates = 3231;

integer count;
integer lineCount;

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;

list main_menu = [ "Front Gates", "Baby Gates", "Access", "Reset", "Exit" ];
list gates_menu =[ "Lock", "Unlock", "Back", "Exit"];
list baby_gate_menu =[ "BabyLock", "BabyUnlock", "Back", "Exit"];

string url = "secondlife:///app/agent/";
string about = "/about";
string settings_file = "MasterSwitch Settings";

init() 
{
    llListenRemove(listen_handle);
    avatar = llDetectedKey(0);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", avatar, "");
}

doMenu() 
{
    list name = llParseString2List(llGetDisplayName(llDetectedKey(0)), [""], []);
    llDialog(llDetectedKey(0),"Hey " + (string)name + "\nPlease select your option:",main_menu,channel);
}

printList(key id)
{
    if (owner != "")
    {
        llInstantMessage(id,"Owner of this Daycare: " + url + (string)owner + about);
    }
    else
    {
        llInstantMessage(id,"No Owner");
    }

    if (manager != "")
    {
        llInstantMessage(id,"Manager of this Daycare: " + url + (string)manager + about);
    }
    else
    {
        llInstantMessage(id,"No Manager");
    }
    
    if (partner != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url + (string)partner + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
    }
    
    if (partner_a != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url + (string)partner_a + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
    }
    
    if (partner_b != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url + (string)partner_b + about);
    }
    else
    {
        llInstantMessage(id,"No Employee");
    }
    
    if (partner_c != "")
    {
        llInstantMessage(id,"Employee of this Daycare: " + url + (string)partner_c + about);
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
        avatar = llDetectedKey(0);
        globalListenHandle = llListen(channel, "", avatar, "");
        init();
        state loadSettings;
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
        string  stringData;
        if (requested == readKey) 
        { 
            if (data != EOF)
            {
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " "))
                {
                    stringData  = (string)data;
                    if (count == 0)
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
                    else if (count == 1)
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
                    else if (count == 2)
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
                    else if (count == 3)
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
                    else if (count == 4)
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
                    else if (count == 5)
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
                llOwnerSay("Owner UUID: " + (string)owner + " Name: (" + llGetDisplayName(owner) + ")");
                llOwnerSay("Manager UUID: " + (string)manager + " Name: (" + llGetDisplayName(manager) + ")");
                llOwnerSay("Employee #1 UUID: " + (string)partner + " Name: (" + llGetDisplayName(partner) + ")");
                llOwnerSay("Employee #2 UUID: " + (string)partner_a + " Name: (" + llGetDisplayName(partner_a) + ")");
                llOwnerSay("Employee #3 UUID: " + (string)partner_b + " Name: (" + llGetDisplayName(partner_b) + ")");
                llOwnerSay("Employee #4 UUID: " + (string)partner_c + " Name: (" + llGetDisplayName(partner_c) + ")");
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                list savedList = llParseString2List(llGetObjectDesc(), ["|"], []);
                if (llGetListLength(savedList) == 5)
                {
                    state Ready;
                }
                else
                {
                    state Ready;
                }
            }
        }
    }
}

state Ready
{
    state_entry()
    {
        avatar = llDetectedKey(0);
        globalListenHandle = llListen(channel, "", avatar, "");
        init();
        llRequestAgentData( owner, DATA_NAME);
        llRequestAgentData( manager, DATA_NAME);
        llRequestAgentData( partner, DATA_NAME);
        llRequestAgentData( partner_a, DATA_NAME);
        llRequestAgentData( partner_b, DATA_NAME);
        llRequestAgentData( partner_c, DATA_NAME);
    }
 
    touch_start(integer total_number)
    {
        key detectedKey = llDetectedKey(0);
        if (detectedKey == owner)
            doMenu();
        else if (detectedKey == manager)
            doMenu();
        else if (detectedKey == partner)
            doMenu();
        else if (detectedKey == partner_a)
            doMenu();
        else if (detectedKey == partner_b)
            doMenu();
        else if (detectedKey == partner_c)
            doMenu();
        else
            llWhisper(0, "Access Denied!");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Exit")
        {
            return;
        }
        else if (message == "Reset")
        {
            llResetScript();
        }
        else if (message == "Access")
        {
            printList(id);
        }
        else if (message == "Back")
        {
            llDialog(id, "\n\nSelect a an option", main_menu, channel);
        }
        //
        else if (message == "Front Gates")
        {
            llDialog(id, "\n\nSelect a an option", gates_menu, channel);
        }
        else if (message == "Baby Gates")
        {
            llDialog(id, "\n\nSelect a an option", baby_gate_menu, channel);
        }
        // 
        else if (message == "Lock")
        {
            llShout(iChanGates, "lock");
            llInstantMessage(id, "Front Gate's are now Locked!");
        }
        else if (message == "Unlock")
        {
            llShout(iChanGates, "unlock");
            llInstantMessage(id, "Front Gate's are now Unlocked!");
        }
        else if (message == "BabyLock")
        {
            llShout(iChanBabyGates, "lock");
            llInstantMessage(id, "Baby Gate's are now Locked!");
        }
        else if (message == "BabyUnlock")
        {
            llShout(iChanBabyGates, "unlock");
            llInstantMessage(id, "Baby Gate's are now Unlocked!");
        }
    }
    
    state_exit()
    {
        llListenRemove(globalListenHandle);
    }
}