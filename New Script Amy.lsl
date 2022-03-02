key id;

integer channel;
integer listen_handle;
integer ll_channel = -8888

list main_menu;

MainMenu(key detectedKey)
{
    main_menu = [ "Leash", "unLeash", "Exit" ];
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, channel);
}

default
{
    state_entry()
    {
        
    }

    touch_start(integer total_number)
    {
        id = llDetectedKey(0);
        MainMenu(id);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Leash"){
            llSay(ll_channel, "Leash");
        }
        else if (message == "unLeash"){
            llSay(ll_channel, "unLeash");
        }
        else if (message == "Exit")
            return;
    }
}
