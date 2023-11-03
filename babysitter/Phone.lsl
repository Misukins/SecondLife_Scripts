key toucher;
key name;
key owner_key = "bb327145-2627-43c3-bedf-58a20e41914e";
key manager_key = "92d7a0cf-dbd1-44d1-b4ba-cc495767187a";
key henna = "076144a2-875c-4448-b0e2-ae7e4fa328d4";

string pose;
string oldpose;
string message;

integer listener;
integer channel;
integer page;
integer posenum;

list buttons;

addbutton(integer i, integer n)
{
    string name = llGetInventoryName(INVENTORY_NOTECARD,i);
    if (i < n)
        buttons += (string)name;
    else
        buttons += " ";
}

addmessage(integer i, integer n)
{
    //if (i < n) 
        //message += "\n" + (string)(i + 1) + ": " + llGetInventoryName(INVENTORY_NOTECARD, i);
}

integer rows = 2;

prepare_menu()
{
    buttons = [];
    integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
    if (page * 3 * rows + 1 >= n) page = (n - 1) / (3 * rows);
    if (page > 0) buttons += "◄"; else buttons += " ";
    buttons += "▼";
    if (n > (page + 1) * 3 * rows) buttons += "►"; 
                              else buttons += " ";
    integer k = rows;
    while (k--)
    {
        addbutton(page * 3 * rows + 3 * k    , n);
        addbutton(page * 3 * rows + 3 * k + 1, n);
        addbutton(page * 3 * rows + 3 * k + 2, n);
    }
    if ( n == 0 )
        message = "Sorry, but our daycare phone has no emergency contacts.";
    else
        message = "Choose a childs name for emergency contacts.";
    for (k = 0; k < 3 * rows; k++)
        addmessage(page * 3 * rows + k, n);
}

default
{
    on_rez(integer num)
    {
        llResetScript();
    }
        
    state_entry()
    {
        toucher = llDetectedKey(0);
        posenum = -1;
        pose = "";
    }
    
    touch_start(integer n)
    {
        key id = llDetectedKey(0);
        if ( id == owner_key || id == manager_key || id == henna )
        {
            prepare_menu();
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", "", "");
            llDialog(id, message, buttons, channel);
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        integer face;
        if (msg == "▼")
        {
            if (posenum == -1) return;
            pose = "";
            posenum = -1;
        }
        else if (msg == "◄")
        {
            page--;
            prepare_menu();
            llDialog(id, message, buttons, channel);
        }
        else if (msg == "►")
        {
            page++;
            prepare_menu();
            llDialog(id, message, buttons, channel);
        }
        else if (msg == " ")
        {
            return;
        }
        else
        {
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
            posenum = (integer)msg - 1;
            if (posenum < 0) posenum = n - 1;
            if (posenum >= n) posenum = 0;
            pose = llGetInventoryName(INVENTORY_NOTECARD, posenum);;
            llGiveInventory(id,pose);
            if (posenum == -1) return;
        }
    }
}
