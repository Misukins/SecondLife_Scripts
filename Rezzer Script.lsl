integer delete_channel = -1110020;
integer menu_channel   = -2220020;
integer HE_channel     = -3330020;
integer menu_listen;
integer menuPosition;

key Avatar;

clear_scene()
{
    llSay(delete_channel, "delete");
}

Menu()
{
    list options = ["♡ Clear ♡"];
    integer num_scenes = llGetInventoryNumber(INVENTORY_OBJECT);
    if (num_scenes>0)
    {
        integer scene_nbr = menuPosition;
        for ( ; scene_nbr<num_scenes; scene_nbr++)
        {
            options = options + [llGetInventoryName(INVENTORY_OBJECT, scene_nbr)];
        }
    }
    options = llDeleteSubList(options,12,999);
    llDialog(Avatar, "Select the object you would like to see:", options, menu_channel);
}

default
{
    state_entry()
    {
        llSay(0,"♡ Ready ♡");
        llListen(HE_channel,"",NULL_KEY,"ping");
        menuPosition = 0;
        menu_listen = llListen(menu_channel, "", "", ""); 
    }

    touch_start(integer total_number)
    {
        Avatar = llDetectedKey(0);
        Menu();
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel==HE_channel) && (message=="ping"))
        {
            vector HE_pos = llGetPos();
            string str = (string)HE_pos.x+","+(string)HE_pos.y+","+(string)HE_pos.z;
            llSay(HE_channel, str);
        }
        else if (channel==menu_channel)
        {
            if (message=="♡ Clear ♡")
                clear_scene();
            else
            {
                clear_scene();
                llRezAtRoot(message, <0.0, 0.06, 0.035>+llGetPos(), ZERO_VECTOR, llEuler2Rot(< 0, 90, 90> * DEG_TO_RAD), 1);
            }
        }
    }
}
