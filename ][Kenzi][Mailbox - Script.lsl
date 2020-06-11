key readKey;
key owner;
key manager;
key partner;
key partner_a;
key partner_b;
key partner_c;
key companylogo;

string title;
string title_a;
string title_b;
string message;
string settings_file = "MailBox Settings";
string url = "secondlife:///app/agent/";
string about = "/about";

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
integer count;
integer lineCount;

list main_menu = [ "Take all", "Delete", "Access", "Update", "Exit" ];

list gItems;
list gNocopy;
list gList_types = [ INVENTORY_NOTECARD ];
list gList_names = [ "Notecard" ];

integer LINK_NUM = 2;
integer LINK_FACE = 1;
integer counter = 0;

/*
Off(){
    llSetLinkPrimitiveParamsFast(LINK_NUM, [PRIM_POINT_LIGHT, TRUE, <1,1,1>, 1.0, 10, .1, PRIM_FULLBRIGHT, LINK_FACE,1, PRIM_GLOW, LINK_FACE, 1.0]);
}

On(){
    llSetLinkPrimitiveParamsFast(LINK_NUM, [PRIM_POINT_LIGHT, FALSE, <1,1,1>, 1.0, 10, .1, PRIM_FULLBRIGHT, LINK_FACE,0, PRIM_GLOW, LINK_FACE, 0.0]);
}
*/

init(){
    llSetText(title + "\n" + title_a + "\n" + title_b, <0.827, 0.690, 0.855>, 1);
    llSetLinkTexture(LINK_THIS, companylogo, ALL_SIDES);
    llListenRemove(listen_handle);
}

menu(){
    key detectedKey = llDetectedKey(0);
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    integer inv_num = llGetInventoryNumber(INVENTORY_NOTECARD);
    llDialog(detectedKey, "Hello " + (string)avatar_name + " There is " + (string)inv_num + " letters on this mailbox.\nBE SURE YOU HAVE TAKEN ALL LETTERS BEFORE YOU HIT DELETE\nSelect a an option", main_menu, channel);
}

printList(key id)
{
    if (owner != "")
        llInstantMessage(id,"Owner: " + url + (string)owner + about);
    else
        llInstantMessage(id,"No Owner");
    if (manager != "")
        llInstantMessage(id,"Manager: " + url + (string)manager + about);
    else
        llInstantMessage(id,"No Manager");
    if (partner != "")
        llInstantMessage(id,"Employee #1: " + url + (string)partner + about);
    else
        llInstantMessage(id,"No Employee #1");
    if (partner_a != "")
        llInstantMessage(id,"Employee #2: " + url + (string)partner_a + about);
    else
        llInstantMessage(id,"No Employee #2");
    if (partner_b != "")
        llInstantMessage(id,"Employee #3: " + url + (string)partner_b + about);
    else
        llInstantMessage(id,"No Employee #3");
    if (partner_c != "")
        llInstantMessage(id,"Employee #4: " + url + (string)partner_c + about);
    else
        llInstantMessage(id,"No Employee #4");
}

delete_all_other_contents()
{
    string thisScript = llGetScriptName();
    string inventoryItemName;
    integer index = llGetInventoryNumber(INVENTORY_ALL);
    if (index > 2){
        while (index){
            --index;
            inventoryItemName = llGetInventoryName(INVENTORY_ALL, index);
            if (inventoryItemName != thisScript & inventoryItemName != settings_file)
                llRemoveInventory(inventoryItemName); 
        }
        llOwnerSay("CLEARED!");
    }
    else
        llOwnerSay("No items to clear!");
}

default
{
    state_entry()
    {
        llSetLinkTexture(LINK_THIS, "59facb66-4a72-40a2-815c-7d9b42c56f60", ALL_SIDES);
        llSetText("", <1, 1, 1>, 1);
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
        string  stringData;
        if (requested == readKey) {
            if (data != EOF){
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " ")){
                    stringData  = (string)data;
                    if (count == 0)
                        title = data;
                    else if (count == 1)
                        title_a = data;
                    else if (count == 2)
                        title_b = data;
                    else if (count == 3){
                        if (stringData == "")
                            companylogo = "";
                        else
                            companylogo = stringData;
                    }
                    else if (count == 4){
                        if (stringData == "")
                            owner = "";
                        else
                            owner = stringData;
                    }
                    else if (count == 5){
                        if (stringData == "")
                            manager = "";
                        else
                            manager = stringData;
                    }
                    else if (count == 6){
                        if (stringData == "")
                            partner = "";
                        else
                            partner = stringData;
                    }
                    else if (count == 7){
                        if (stringData == "")
                            partner_a = "";
                        else
                            partner_a = stringData;
                    }
                    else if (count == 8){
                        if (stringData == "")
                            partner_b = "";
                        else
                            partner_b = stringData;
                    }
                    else if (count == 9){
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
                llOwnerSay("Title: " + title + "\n" + title_a + "\n" + title_b);
                llOwnerSay("Company Logo UUID: " + (string)companylogo);
                llOwnerSay("Owner UUID: " + (string)owner + " Name: (" + llGetDisplayName(owner) + ")");
                llOwnerSay("Manager #1 UUID: " + (string)manager + " Name: (" + llGetDisplayName(manager) + ")");
                llOwnerSay("Manager #2 UUID: " + (string)partner + " Name: (" + llGetDisplayName(partner) + ")");
                llOwnerSay("Manager #3 UUID: " + (string)partner_a + " Name: (" + llGetDisplayName(partner_a) + ")");
                llOwnerSay("Manager #4 UUID: " + (string)partner_b + " Name: (" + llGetDisplayName(partner_b) + ")");
                llOwnerSay("Manager #5 UUID: " + (string)partner_c + " Name: (" + llGetDisplayName(partner_c) + ")");
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                list savedList = llParseString2List(llGetObjectDesc(), ["|"], []);
                if (llGetListLength(savedList) == 5)
                    state Ready;
                else
                    state Ready;
            }
        }
    }
}

state Ready
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
        llRequestAgentData( owner, DATA_NAME);
        llRequestAgentData( manager, DATA_NAME);
        llRequestAgentData( partner, DATA_NAME);
        llRequestAgentData( partner_a, DATA_NAME);
        llRequestAgentData( partner_b, DATA_NAME);
        llRequestAgentData( partner_c, DATA_NAME);
        integer All = llGetInventoryNumber(INVENTORY_ALL);
        while (All){
            string name = llGetInventoryName(INVENTORY_ALL, All - 1);
            if (name != llGetScriptName() && name != settings_file)
                gItems += [name];
            --All;
        }
        init();
    }

    touch_start(integer total_number)
    {
        key detectedKey = llDetectedKey(0);
        list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
        if ( detectedKey == owner)
            menu();
        else if ( detectedKey == manager )
            menu();
        else if ( detectedKey == partner )
            menu();
        else if ( detectedKey == partner_a )
            menu();
        else if ( detectedKey == partner_b )
            menu();
        else if ( detectedKey == partner_c )
            menu();
        else
            llWhisper(0, "Sorry " + (string)avatar_name  + " >Access Denied< !");
    }
    
    changed(integer mask)
    {
        if(mask & (CHANGED_ALLOWED_DROP | CHANGED_INVENTORY)){
            llWhisper(0, "Thank you for submitting your notecard!");
            state Ready;
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Exit")
            return;
        else if (message == "Update")
            llResetScript();
        else if (message == "Take all"){
            llInstantMessage(id, "Look for unpacked items in a folder named " + llGetObjectName() + " in your inventory.");
            llGiveInventoryList(id, llGetObjectName(), gItems);
        }
        else if (message == "Access")
            printList(id);
        else if (message == "Delete")
            delete_all_other_contents();
    }
}
