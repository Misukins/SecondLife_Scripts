string vehicle;
integer vehiclenum;

key readKey;

integer listener;
integer channel;
integer page;
integer count;

string message;
string OBJname  = "{[Amy]} Heli Rezzer";
string desc_    = "(c)Amy (meljonna Resident) - ";
list buttons;

float pos_x = 6.00;
float pos_y = 6.00;
float pos_z = 4.00;

float rot_x = 0.00;
float rot_y = 0.00;
float rot_z = 45.00;

float time = 5.0;

vector axis;
vector titleColor = <0.905, 0.686, 0.924>;

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
        message += "\n" + (string)(i + 1) + ": " + llGetInventoryName(INVENTORY_OBJECT, i);
}

integer rows = 2;

prepare_menu()
{
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
    while (k--){
        addbutton(page * 3 * rows + 3 * k    , n);
        addbutton(page * 3 * rows + 3 * k + 1, n);
        addbutton(page * 3 * rows + 3 * k + 2, n);
    }
    if (n == 0)
        message = "My inventory is EMPTY!";
    else
        message = "";
    for (k = 0; k < 3 * rows; k++)
        addmessage(page * 3 * rows + k, n);
}

Menu()
{
    key toucher = llDetectedKey(0);
    prepare_menu();
    llListenRemove(listener);
    channel = -1000000000 - (integer)(llFrand(1000000000));
    listener = llListen(channel, "", "", "");
    llDialog(toucher, message, buttons, channel);
}

update()
{
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    updateTimeDisp();
    llSetTimerEvent(0);
}

//llSetObjectName(OBJname);
//llSetObjectName("");
dispString(string value)
{
    llSetText(value, titleColor, 1);
}

updateTimeDisp()
{
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    dispString("There is " + (string)n + " Air Vehicles.");
}

default
{
    on_rez(integer num)
    {
        llResetScript();
    }
    
    state_entry()
    {
        integer n = llGetInventoryNumber(INVENTORY_OBJECT);
        llAllowInventoryDrop(TRUE);
        llSetObjectDesc(desc_);
        updateTimeDisp();
        vehiclenum = -1;
        vehicle = "";
    }

    touch_start(integer total_number)
    {
        key toucher_key = llDetectedKey(0);
        if (toucher_key == llGetOwner())
            Menu();
    }

    changed(integer change)
    {
        integer n = llGetInventoryNumber(INVENTORY_OBJECT);
        if (change & CHANGED_INVENTORY)
            llSetTimerEvent(time);
    }
            
    listen(integer channel, string name, key id, string msg)
    {
        integer face;
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
            list name = llParseString2List(llGetDisplayName(id), [""], []);
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            vehiclenum = (integer)msg - 1;
            if (vehiclenum < 0)
                vehiclenum = n - 1;
            if (vehiclenum >= n)
                vehiclenum = 0;
            vehicle = llGetInventoryName(INVENTORY_OBJECT, vehiclenum);
            llWhisper(0, (string)name + " is rezzing " + vehicle + ".");
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