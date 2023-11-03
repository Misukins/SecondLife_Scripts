integer chan;
integer listen_handle;
integer Silent  = FALSE;

list main_menu;
list themes_menu;
list settings_menu;

MainMenu(key detectedKey){
    if (!Silent)
        main_menu = [ "Settings", "Silent", "Exit" ];
    else
        main_menu = [ "Settings", "Sounds", "Exit" ];
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    chan = llFloor(llFrand(2000000));
    listen_handle = llListen(chan, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, chan);
}

SettingsMenu(key detectedKey){
    settings_menu = [ "Themes", "RESET", "Main", "Exit" ];
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    chan = llFloor(llFrand(2000000));
    listen_handle = llListen(chan, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", settings_menu, chan);
}

ThemesMenu(key detectedKey){
    themes_menu = [ "Android", "iPhone", "Main", "Exit" ];
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    chan = llFloor(llFrand(2000000));
    listen_handle = llListen(chan, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", themes_menu, chan);
}

ResetAllScripts(){
    //TODO
}

SilentON(){
    //TODO
    Silent = TRUE;
    llOwnerSay("Your Phone is silent");
    return;
}

SilentOFF(){
    //TODO
    Silent = FALSE;
    llOwnerSay("Your Phone has sounds now");
    return;
}

default{
    state_entry(){
        //TODO
    }

    touch_start(integer total_number){
        key detectedKey = llDetectedKey(0);
        if(detectedKey == llGetOwner())
            MainMenu(detectedKey);
    }
    
    listen(integer channel, string name, key id, string message){
        if (message == "Settings")
            SettingsMenu(id);
        else if (message == "Silent"){
            SilentON();
            MainMenu(id);
        }
        else if (message == "Sounds"){
            SilentOFF();
            MainMenu(id);
        }
        else if (message == "Themes")
            ThemesMenu(id);
        else if (message == "RESET")
            ResetAllScripts();
        else if (message == "iPhone"){
            //TODO
        }
        else if (message == "Android"){
            //TODO
        }
        else if (message == "Main")
            MainMenu(id);
        else if (message == "Exit")
            return;
    }
}