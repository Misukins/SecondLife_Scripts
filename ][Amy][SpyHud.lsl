key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";

integer listener;
integer channel;
integer menuchannel = 15677449;

integer ScannerOn = FALSE;
integer ScriptOn  = FALSE;
integer BothOn    = FALSE;

float _volume = 0.3;

menu(key id)
{
    if ((ScannerOn == FALSE) && (ScriptOn == FALSE)){
        list main_menu = [ "□ Scanner", "□ Scripts", "BothOn", "Exit" ];
        /*llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));*/
        listener = llListen(menuchannel, "", llGetOwner(), "");
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == FALSE) && (ScriptOn == TRUE)){
        list main_menu = [ "□ Scanner", "■ Scripts", "BothOn", "Exit" ];
        /*llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));*/
        listener = llListen(menuchannel, "", llGetOwner(), "");
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == TRUE)){
        list main_menu = [ "■ Scanner", "■ Scripts", "BothOn", "Exit" ];
        /*llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));*/
        listener = llListen(menuchannel, "", llGetOwner(), "");
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == FALSE)){
        list main_menu = [ "■ Scanner", "□ Scripts", "BothOn", "Exit" ];
        /*llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));*/
        listener = llListen(menuchannel, "", llGetOwner(), "");
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
}

default
{
    state_entry()
    {
        llPreloadSound(_sound_on);
        llPreloadSound(_sound_off);
        llSetText("",<1,1,1>,1);
        ScannerOn = FALSE;
        ScriptOn  = FALSE;
        BothOn    = FALSE;
        llOwnerSay("Script Counter and Channel Sniffer are now Offline..");
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner())
            menu(llGetOwner());
    }

    listen(integer channel, string name, key id, string message)
    {
        /*if(ScannerOn = TRUE){
            string object_name = llGetOwnerKey(id);
            list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
            llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
        }*/
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
        else if ((message == "□ Script") || (message == "■ Script")){
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
        llSetText("",<1,1,1>,1);
        llListen(menuchannel, "", llGetOwner(), "");
        integer i = 1;
        for (; i <= 65; ++i)
            llListen(i, "", "", "");
    }

    touch_start(integer _n)
    {
        if(llDetectedKey(0) == llGetOwner())
            menu(llGetOwner());
    }

    listen(integer channel, string name, key id, string message)
    {
        string object_name = llGetOwnerKey(id);
        list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
        llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
        //F ~
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
        else if ((message == "□ Script") || (message == "■ Script")){
            if (!ScriptOn){
                state Script;
                ScriptOn = TRUE;
                llOwnerSay("Script Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                ScriptOn = FALSE;
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

    state_exit()
    {
        ScannerOn = FALSE;
    }
}

state Script
{
    state_entry()
    {
        ScriptOn = TRUE;
        ScannerOn = FALSE;
        BothOn    = FALSE;
        llSetTimerEvent(1);
    }

    touch_start( integer _n )
    {
        if(llDetectedKey(0) == llGetOwner())
            menu(llGetOwner());
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
        else if ((message == "□ Script") || (message == "■ Script")){
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

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if (time<=.4) color=<0,1,0>;
        else if (time>.4 && time <=.9) color=<1,1,0>;
        else if (time>.9 && time <= 1.5) color = <1,0,0>;
        else color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Script Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llSetTimerEvent(0);
        ScriptOn = FALSE;
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
        llOwnerSay("Script Counter and Channel Sniffer are now Online..");
    }

    touch_start( integer _n )
    {
        if(llDetectedKey(0) == llGetOwner())
            menu(llGetOwner());
    }

    listen(integer channel, string name, key id, string message)
    {
        string object_name = llGetOwnerKey(id);
        list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
        llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
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
        else if ((message == "□ Script") || (message == "■ Script")){
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

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if (time<=.4) color=<0,1,0>;
        else if (time>.4 && time <=.9) color=<1,1,0>;
        else if (time>.9 && time <= 1.5) color = <1,0,0>;
        else color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Script Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llSetTimerEvent(0);
        ScannerOn   = FALSE;
        ScriptOn    = FALSE;
        BothOn      = FALSE;
        llOwnerSay("Script Counter and Channel Sniffer are now Offline..");
        llPlaySound(_sound_off, _volume);
    }
}