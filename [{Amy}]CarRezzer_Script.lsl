
integer vehiclenum;
integer listener;
integer channel;
integer page;

string message;
string vehicle;

list buttons;

float pos_x = 1.0;
float pos_y = 2.0;
float pos_z = 0.2;

float rot_x = 0.0;
float rot_y = 0.0;
float rot_z = 90.0;

float time = 5.0;

addbutton(integer i, integer n) {
    if (i < n)
        buttons += (string)(i + 1);
    else
        buttons += " ";
}

addmessage(integer i, integer n) {
    if (i < n) 
        message += "\n" + (string)(i + 1) + ": " + llGetInventoryName(INVENTORY_OBJECT, i);
}

integer rows = 2;

prepare_menu() {
    buttons = [];
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    if (page * 3 * rows + 1 >= n)
        page = (n - 1) / (3 * rows);
    if (page > 0)
        buttons += "◄";
    buttons += "▼";
    if (n > (page + 1) * 3 * rows)
        buttons += "►"; 
    integer k = rows;
    while (k--) {
        addbutton(page * 3 * rows + 3 * k    , n);
        addbutton(page * 3 * rows + 3 * k + 1, n);
        addbutton(page * 3 * rows + 3 * k + 2, n);
    }
    if ( n == 0 )
        message = "NO CARS!";
    else
        message = "Amy's Car Rezzer has enough cars";
    for (k = 0; k < 3 * rows; k++)
        addmessage(page * 3 * rows + k, n);
}

Menu() {
    key toucher = llDetectedKey(0);
    prepare_menu();
    llListenRemove(listener);
    channel = -1000000000 - (integer)(llFrand(1000000000));
    listener = llListen(channel, "", "", "");
    llDialog(toucher, message, buttons, channel);
}

update() {
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
        llAllowInventoryDrop(TRUE);
        vehiclenum = -1;
        vehicle = "";
    }

    touch_start(integer total_number)
    {
        key toucher_key = llDetectedKey(0);
        if(toucher_key == llGetOwner())
            Menu();
        else
            return;
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
            llSetTimerEvent(time);
    }
            
    listen(integer _channel, string name, key id, string msg)
    {
        if (msg == "▼"){
            if (vehiclenum == -1) return;
            vehicle = "";
            vehiclenum = -1;
        }
        else if (msg == "◄"){
            page--;
            prepare_menu();
            llDialog(id, message, buttons, channel);
        }
        else if (msg == "►"){
            page++;
            prepare_menu();
            llDialog(id, message, buttons, channel);
        }
        else if (msg == " ")
            return;
        else{
            list _name = llParseString2List(llGetDisplayName(id), [""], []);
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            vehiclenum = (integer)msg - 1;
            if (vehiclenum < 0)
                vehiclenum = n - 1;
            if (vehiclenum >= n)
                vehiclenum = 0;
            vehicle = llGetInventoryName(INVENTORY_OBJECT, vehiclenum);
            llWhisper(0, (string)_name + " is rezzing " + vehicle + ".");
            llRezAtRoot(vehicle, <pos_x, pos_y, pos_z> + llGetPos(), ZERO_VECTOR, <rot_x, rot_y, rot_z, 1.0>, 1);
            llSetTimerEvent(time);
            if (vehiclenum == -1)
                return;
        }
    }
    
    timer()
    {
        update();
    }
}