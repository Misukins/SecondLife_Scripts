string item;
string itemnum;

key toucher;
key name;

integer listener;
integer channel;
integer page;
string message;
list buttons;

key Meljonna    = "92d7a0cf-dbd1-44d1-b4ba-cc495767187a";
key Henna       = "076144a2-875c-4448-b0e2-ae7e4fa328d4";

addbutton(integer i, integer n)
{
    string itemname = llGetInventoryName(INVENTORY_OBJECT,i);
    if (i < n)
        buttons += (string)itemname;
    else
        buttons += " ";
}

addmessage(integer i, integer n)
{
    if (i < n) 
        message += "\n" + (string)(i + 1) + ": " + llGetInventoryName(INVENTORY_OBJECT, i);
}

integer rows = 2;

prepare_menu()
{
    buttons = [];
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    if (page * 3 * rows + 1 >= n) page = (n - 1) / (3 * rows);
    if (page > 0) buttons += "◄"; else buttons += "♡ Stock ♡";
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
        message = "OUT OF STOCK IT!";
    else
        message = " ";
    for (k = 0; k < 3 * rows; k++)
        addmessage(page * 3 * rows + k, n);
}

DoMenu() 
{
    toucher = llDetectedKey(0);
    prepare_menu();
    llListenRemove(listener);
    channel = -1000000000 - (integer)(llFrand(1000000000));
    listener = llListen(channel, "", "", "");
    llDialog(toucher, message, buttons, channel);
}

default
{
    on_rez(integer num)
    {
        llResetScript();
    }
        
    state_entry()
    {
        itemnum = "";
        item = "";
    }
    
    touch_start(integer n)
    {
        key id = llDetectedKey(0);
        if ( id == Meljonna || id == Henna)
        {
            DoMenu();
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "▼")
        {
            if (itemnum == "") return;
            item = "";
            itemnum = "";
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
        else if (msg == "♡ Stock ♡")
        {
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            llWhisper(0, "Hey " + (string)name + ", We have " + (string)n + "items on stock.");
        }
        else if (msg == " ")
        {
            return;
        }
        else
        {
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            llWhisper(0, (string)name + " grabs a " + (string)msg + " from the fidge.");
            llGiveInventory(id,msg);
            if (itemnum == "") return;
        }
    }
}
