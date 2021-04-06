key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";
key AvatarKey;

integer listener;
integer menuchannel;

integer ScannerOn = FALSE;
integer ScriptOn  = FALSE;
integer BothOn    = FALSE;

float _volume = 0.3;

init(){
    llListenRemove(listener);
    llPreloadSound(_sound_on);
    llPreloadSound(_sound_off);
}

menu(key id)
{
    if ((ScannerOn == FALSE) && (ScriptOn == FALSE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "□ Scanner", "□ Scripts", "BothOn", "Exit" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == FALSE) && (ScriptOn == TRUE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "□ Scanner", "■ Scripts", "BothOn", "Exit" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == TRUE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "■ Scanner", "■ Scripts", "BothOn", "Exit" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == FALSE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "■ Scanner", "□ Scripts", "BothOn", "Exit" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
}

StartSniffing()
{
    integer i = 1;
    for (; i <= 65; ++i)
        llListen(i, "", "", "");
}

StartScriptSniffing()
{
    //NOTE NO NEED.. THIS IS RDY TO YOU!
}

default
{
    state_entry()
    {
        init();
        llSetText("",<1,1,1>,1);
        ScannerOn = FALSE;
        ScriptOn  = FALSE;
        BothOn    = FALSE;
        menu(llGetOwner());
    }

    touch_start(integer total_number)
    {
        state default;
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "Exit")
            return;
        else if ((message == "□ Scanner") || (message == "■ Scanner")){
            if (!ScannerOn){
                state Sniffing;
                llOwnerSay("Listen Scanner is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Listen Scanner is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScannerOn = !ScannerOn;
        }
        else if ((message == "□ Scripts") || (message == "■ Scripts")){
            if (!ScriptOn){
                state Script;
                llOwnerSay("Script Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Script Counter is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScriptOn = !ScriptOn;
        }
        else if (message == "BothOn"){
            state BothOnState;
            return;
        }
    }
}

state Sniffing
{
    state_entry()
    {
        ScannerOn = TRUE;
        BothOn    = FALSE;
        ScriptOn  = FALSE;
        llPlaySound(_sound_on, _volume);
        llOwnerSay("Listen Scanner is now Online..");
        llSetText("",<1,1,1>,1);
        StartSniffing();
    }

    touch_start(integer _n)
    {
        state default;
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel != menuchannel){
            string object_name = llGetOwnerKey(id);
            list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
            llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
        }

        if (message == "Exit")
            return;
        else if ((message == "□ Scanner") || (message == "■ Scanner")){
            if (!ScannerOn){
                state Sniffing;
                llOwnerSay("Listen Scanner is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Listen Scanner is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScannerOn = !ScannerOn;
        }
        else if ((message == "□ Scripts") || (message == "■ Scripts")){
            if (!ScriptOn){
                state Script;
                ScriptOn = TRUE;
                llOwnerSay("Scripts Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                ScriptOn = FALSE;
                llOwnerSay("Scripts Counter is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScriptOn = !ScriptOn;
        }
        else if (message == "BothOn"){
            state BothOnState;
            return;
        }
    }

    state_exit()
    {
        ScannerOn = FALSE;
        llOwnerSay("Listen Scanner is now Offline..");
        llPlaySound(_sound_off, _volume);
    }
}

state Script
{
    state_entry()
    {
        ScriptOn = TRUE;
        ScannerOn = FALSE;
        BothOn    = FALSE;
        llPlaySound(_sound_on, _volume);
        llOwnerSay("Scripts Counter is now Online..");
        llSetTimerEvent(1);
    }

    touch_start( integer _n )
    {
        state default;
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "Exit")
            return;
        else if ((message == "□ Scanner") || (message == "■ Scanner")){
            if (!ScannerOn){
                state Sniffing;
                llOwnerSay("Listen Scanner is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Listen Scanner is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScannerOn = !ScannerOn;
        }
        else if ((message == "□ Scripts") || (message == "■ Scripts")){
            if (!ScriptOn){
                state Script;
                llOwnerSay("Scripts Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Scripts Counter is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScriptOn = !ScriptOn;
        }
        else if (message == "BothOn"){
            state BothOnState;
            return;
        }
    }

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if(time<=.4)
            color=<0,1,0>;
        else if (time>.4 && time <=.9)
            color=<1,1,0>;
        else if (time>.9 && time <= 1.5)
                color = <1,0,0>;
        else
            color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Scripts Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llSetTimerEvent(0);
        ScriptOn = FALSE;
        llOwnerSay("Scripts Counter is now Offline..");
        llPlaySound(_sound_off, _volume);
    }
}

state BothOnState
{
    state_entry()
    {
        ScannerOn   = TRUE;
        ScriptOn    = TRUE;
        BothOn      = TRUE;
        llSetTimerEvent(1);
        llPlaySound(_sound_on, _volume);
        llOwnerSay("Scripts Counter and Channel Sniffer are now Online..");
        StartSniffing();
    }

    touch_start( integer _n )
    {
        state default;
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel != menuchannel){
            string object_name = llGetOwnerKey(id);
            list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
            llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
        }

        if (message == "Exit")
            return;
        else if ((message == "□ Scanner") || (message == "■ Scanner")){
            if (!ScannerOn){
                state Sniffing;
                llOwnerSay("Listen Scanner is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Listen Scanner is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScannerOn = !ScannerOn;
        }
        else if ((message == "□ Scripts") || (message == "■ Scripts")){
            if (!ScriptOn){
                state Script;
                llOwnerSay("Scripts Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Scripts Counter is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScriptOn = !ScriptOn;
        }
        else if (message == "BothOn"){
            state BothOnState;
            return;
        }
    }

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if(time<=.4)
            color=<0,1,0>;
        else if (time>.4 && time <=.9)
            color=<1,1,0>;
        else if (time>.9 && time <= 1.5)
                color = <1,0,0>;
        else
            color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Scripts Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llSetTimerEvent(0);
        ScannerOn   = FALSE;
        ScriptOn    = FALSE;
        BothOn      = FALSE;
        llOwnerSay("Scripts Counter and Channel Sniffer are now Offline..");
        llPlaySound(_sound_off, _volume);
        state default;
        return;
    }
}