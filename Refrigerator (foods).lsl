string food;
integer foodnum;

key toucher;
key name;

integer listener;
integer channel;
integer page;
string food_message;
list buttons;

float time = 5.0;

addbutton(integer i, integer n)
{
    if (i < n)
        buttons += (string)(i + 1);
    else
        buttons += " ";
}

addmessage(integer i, integer n)
{
    if (i < n) 
        food_message += "\n" + (string)(i + 1) + ": " + llGetInventoryName(INVENTORY_OBJECT, i);
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
        food_message = "REFRIGERATOR IS OUT OF STOCK!";
    else
        food_message = "Refrigerator has enough Food";
    for (k = 0; k < 3 * rows; k++)
        addmessage(page * 3 * rows + k, n);
}

update()
{
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    llWhisper(0, "There is still " + (string)n + " foods on stock.");
    llSetTimerEvent(0);
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
        integer n = llGetInventoryNumber(INVENTORY_OBJECT);
        llWhisper(0, "There is still " + (string)n + " foods on stock.");
        foodnum = -1;
        food = "";
    }
    
    changed(integer change)
    {
        integer n = llGetInventoryNumber(INVENTORY_OBJECT);
        if (change & CHANGED_INVENTORY)
        {
            llWhisper(0, "There is still " + (string)n + " foods on stock.");
        }
    }
    
    link_message(integer n, integer num, string message, key id)
    {
        if(message == "Foods")
        {
            prepare_menu();
            llListenRemove(listener);
            channel = -1000000000 - (integer)(llFrand(1000000000));
            listener = llListen(channel, "", id, "");
            llDialog(id, food_message, buttons, channel);
        }
        else if(message == "Stock")
        {
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            llWhisper(0, "Hey " + (string)name + ", We have " + (string)n + " foods on stock.");
        }
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        integer face;
        if (msg == "▼")
        {
            if (foodnum == -1) return;
            food = "";
            foodnum = -1;
        }
        else if (msg == "◄")
        {
            page--;
            prepare_menu();
            llDialog(id, food_message, buttons, channel);
        }
        else if (msg == "►")
        {
            page++;
            prepare_menu();
            llDialog(id, food_message, buttons, channel);
        }
        else if (msg == "♡ Stock ♡")
        {
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            llWhisper(0, "Hey " + (string)name + ", We have " + (string)n + " foods on stock.");
            if (foodnum == -1) return;
            food = "";
            foodnum = -1;
        }
        else if (msg == " ")
        {
            return;
        }
        else
        {
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            foodnum = (integer)msg - 1;
            if (foodnum < 0) foodnum = n - 1;
            if (foodnum >= n) foodnum = 0;
            food = llGetInventoryName(INVENTORY_OBJECT, foodnum);
            llWhisper(0, (string)name + " grabs a " + food + " from the Refrigerator.");
            llGiveInventory(id,food);
            llSetTimerEvent(time);
            if (foodnum == -1) return;
        }
    }
    
    timer()
    {
        update();
    }
}
