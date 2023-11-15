integer chan;
integer listen_handle;
integer Silent  = FALSE;
integer Adult   = FALSE;

list main_menu;
list themes_menu;
list settings_menu;
list adult_menu;

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
    settings_menu = [ "AdultMenu", "Themes", "RESET", "Main", "Exit" ];
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

AdultMenu(key detectedKey){
    if (Adult)
        adult_menu = [ "■ Adult", "Main", "Exit" ];
    else
        adult_menu = [ "□ Adult", "Main", "Exit" ];
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    chan = llFloor(llFrand(2000000));
    listen_handle = llListen(chan, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", adult_menu, chan);
}

//AdultMenu(key detectedKey){
//    themes_menu = [ "PornHub", "Chaturbate", "OnlyFans", "RedTube", "YouPorn", "Main", "Exit" ];
//    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
//    chan = llFloor(llFrand(2000000));
//    listen_handle = llListen(chan, "", detectedKey, "");
//    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", themes_menu, chan);
//}

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

    on_rez(integer num)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
            llResetScript();
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
        else if (message == "AdultMenu")
            AdultMenu(id);
        else if (message == "RESET")
            ResetAllScripts();
        else if (message == "iPhone"){
            //TODO
            llOwnerSay("Coming Soon......");
        }
        else if (message == "Android"){
            //TODO
            llOwnerSay("Coming Soon......");
        }
        else if (message == "□ Adult"){
            llMessageLinked(LINK_SET, 0, "PHON", NULL_KEY);
            Adult = TRUE;
            AdultMenu(id);
        }
        else if (message == "■ Adult"){
            llMessageLinked(LINK_SET, 0, "PHOFF", NULL_KEY);
            Adult = FALSE;
            AdultMenu(id);
        }
        else if (message == "Main")
            MainMenu(id);
        else if (message == "Exit")
            return;
    } 
}