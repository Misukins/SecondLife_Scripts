float soundVolume     = 1.0;

integer link_num;

integer ledlight_living;
integer ledlight_living1;
integer ledlight_bedroom;
integer ledlight_bedroom1;
integer ledlight_kitchen;
integer ledlight_bathroom;
integer ledlight_garage;
integer ledlight_garage1;

integer LIGHT_SIDE = 1;

integer channel;
integer listen_handle;

integer VoiceChannel    = 0;
integer Group_Only      = FALSE;
integer Owner_Only      = TRUE;
integer Public_Access   = FALSE;

integer Debug           = FALSE;

key owner;

list main_menu              = [ "LivingRoom", "BedRoom", "Garage", "BathRoom", "Kitchen", "CeilingFan", "Windows", "All-Lights", "Exit" ];
list admin_menu             = [ "Doors", "LivingRoom", "BedRoom", "Garage", "BathRoom", "Kitchen", "CeilingFan", "Windows", "All-Lights", "Access", "Reset", "Exit" ];
list AccessList_Menu        = [ "Group", "Private", "Public", "Back", "Exit" ];

list CeilingFan_Menu        = [ "++VerySlow++", "++Slow++", "++Medium++", "++Fast++", "++VeryFast++", "++Off++", "Back", "Exit" ];

list LivingRoomLights_Menu  = [ "+Low", "+Medium", "+High", "+Off", "Back", "Exit" ];
list BedRoom_Menu           = [ "-Low", "-Medium", "-High", "-Off", "Back", "Exit" ];
list Kitchen_Menu           = [ "*Low", "*Medium", "*High", "*Off", "Back", "Exit" ];
list BathRoom_Menu          = [ "|Low", "|Medium", "|High", "|Off", "Back", "Exit" ];
list Garage_Menu            = [ "|Low|", "|Medium|", "|High|", "|Off|", "Back", "Exit" ];
list AllLights_Menu         = [ "+-On-+", "+-Off-+", "Back", "Exit" ];
list WindowTint_Menu        = [ "Tint On", "Tint Off", "Back", "Exit" ];
list Doors_Menu             = [ "Lock", "Unlock", "Back", "Exit" ];

string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

string _LEDLIGHT_LIVING     = "LedLight-LivingRoom";
string _LEDLIGHT_LIVING1    = "LedLight-LivingRoom1";
string _LEDLIGHT_BEDROOM    = "LedLight-BedRoom";
string _LEDLIGHT_BEDROOM1   = "LedLight-BedRoom1";
string _LEDLIGHT_KITCHEN    = "LedLight-Kitchen";
string _LEDLIGHT_BATHROOM   = "LedLight-BathRoom";
string _LEDLIGHT_GARAGE     = "LedLight-Garage";
string _LEDLIGHT_GARAGE1    = "LedLight-Garage1";

doMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", main_menu, channel);
}

doAdminMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", admin_menu, channel);
}

doAccessListMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", AccessList_Menu, channel);
}

doLivingRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", LivingRoomLights_Menu, channel);
}

doCeilingFanMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", CeilingFan_Menu, channel);
}

doBedRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", BedRoom_Menu, channel);
}

doKitchenMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", Kitchen_Menu, channel);
}

doBathRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", BathRoom_Menu, channel);
}

doGarageMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", Garage_Menu, channel);
}

doAllLightsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", AllLights_Menu, channel);
}

doWindowTintMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", WindowTint_Menu, channel);
}

doDoorsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", Doors_Menu, channel);
}

AccessSound(){
    llTriggerSound(confirmedSound, soundVolume);
}

DeniedSound(){
    llWhisper(0, "Access Denied!");
    llTriggerSound(accessDeniedSound, soundVolume);
}

determine_display_links(){
    integer i = link_num;
    integer found = 0;
    do{
        if(llGetLinkName(i) == _LEDLIGHT_LIVING){
            ledlight_living = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_LIVING1){
            ledlight_living1 = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_BEDROOM){
            ledlight_bedroom = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_BEDROOM1){
            ledlight_bedroom1 = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_KITCHEN){
            ledlight_kitchen = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_BATHROOM){
            ledlight_bathroom = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_GARAGE){
            ledlight_garage = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_GARAGE1){
            ledlight_garage1 = i;
            found++;
        }
    }
    while (i-- && found < 14);
}

AllLightON(){
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_GLOW,LIGHT_SIDE,0.25]);
}

AllLightOFF(){
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
}

Reset(){
    llOwnerSay("Script Reset!");
    llResetScript();
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        link_num = llGetNumberOfPrims();
        determine_display_links();
        llPreloadSound(confirmedSound);
        llPreloadSound(accessDeniedSound);
        llListen(VoiceChannel, "", "", "");
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(id);
        if (id == owner)
            doAdminMenu(id);
        else if (Group_Only == TRUE){
            if (sameGroup)
                doMenu(id);
            else
                DeniedSound();
        }
        else if (Owner_Only == TRUE){
            if(id == owner)
                doMenu(id);
            else
                DeniedSound();
        }
        else if (Public_Access == TRUE)
            doMenu(id);
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (Debug)
            llOwnerSay((string)msg + " Said!");

        if (chan == VoiceChannel){
            if (msg == "lights on"){
                AllLightON();
                AccessSound();
            }
            else if (msg == "lights off"){
                AllLightOFF();
                AccessSound();
            }
            else if (msg == "fan on"){
                llMessageLinked(LINK_SET, 0, "++Medium++", NULL_KEY);
                AccessSound();
            }
            else if (msg == "fan off"){
                llMessageLinked(LINK_SET, 0, "++Off++", NULL_KEY);
                AccessSound();
            }
        }

        //Defaults
        if (msg == "Exit")
            return;
        else if (msg == " ")
            return;
        else if (msg == "Back")
            doMenu(id);

        //MAINPRIM
        else if (msg == "Access")
            doAccessListMenu(id);
        else if (msg == "Reset")
            Reset();
        else if (msg == "LivingRoom")
            doLivingRoomMenu(id);
        else if (msg == "CeilingFan")
            doCeilingFanMenu(id);
        else if (msg == "BedRoom")
            doBedRoomMenu(id);
        else if (msg == "Kitchen")
            doKitchenMenu(id);
        else if (msg == "BathRoom")
            doBathRoomMenu(id);
        else if (msg == "Garage")
            doGarageMenu(id);
        else if (msg == "All-Lights")
            doAllLightsMenu(id);
        else if (msg == "Windows")
            doWindowTintMenu(id);
        else if (msg == "Doors")
            doDoorsMenu(id);
        else if (msg == "Group"){
            Group_Only      = TRUE;
            Owner_Only      = FALSE;
            Public_Access   = FALSE;
            llWhisper(0, "Group mode has been set!");
        }
        else if (msg == "Private"){
            Group_Only      = FALSE;
            Owner_Only      = TRUE;
            Public_Access   = FALSE;
            llWhisper(0, "Private mode has been set!");
        }
        else if (msg == "Public"){
            Group_Only      = FALSE;
            Owner_Only      = FALSE;
            Public_Access   = TRUE;
            llWhisper(0, "Public mode has been set!");
        }

        //ALLLIGHTS ON/OFF
        else if (msg == "+-On-+"){
            AllLightON();
            AccessSound();
        }
        else if (msg == "+-Off-+"){
            AllLightOFF();
            AccessSound();
        }

        //CeilingFan
        else if (msg == "++VerySlow++"){
            llMessageLinked(LINK_SET, 0, "++VerySlow++", NULL_KEY);
            AccessSound();
        }
        else if (msg == "++Slow++"){
            llMessageLinked(LINK_SET, 0, "++Slow++", NULL_KEY);
            AccessSound();
        }
        else if (msg == "++Medium++"){
            llMessageLinked(LINK_SET, 0, "++Medium++", NULL_KEY);
            AccessSound();
        }
        else if (msg == "++Fast++"){
            llMessageLinked(LINK_SET, 0, "++Fast++", NULL_KEY);
            AccessSound();
        }
        else if (msg == "++VeryFast++"){
            llMessageLinked(LINK_SET, 0, "++VeryFast++", NULL_KEY);
            AccessSound();
        }
        else if (msg == "++Off++"){
            llMessageLinked(LINK_SET, 0, "++Off++", NULL_KEY);
            AccessSound();
        }

        //LivingRoom
        else if (msg == "+Low"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "+Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "+High"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "+Off"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }

        //mainRoom
        if (msg == "-Low"){
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "-Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "-High"){
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "-Off"){
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bedroom1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }

        //melRoom
        if (msg == "*Low"){
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "*Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "*High"){
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "*Off"){
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_kitchen, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }

        //bathRoom
        if (msg == "|Low"){
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "|Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "|High"){
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "|Off"){
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }

        //garage
        if (msg == "|Low|"){
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "|Medium|"){
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "|High|"){
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "|Off|"){
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_garage1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }
        
        //windowtint
        if (msg == "Tint On"){
            llMessageLinked(LINK_SET, 0, "*Closed*", NULL_KEY);
            AccessSound();
        }
        else if (msg == "Tint Off"){
            llMessageLinked(LINK_SET, 0, "*Open*", NULL_KEY);
            AccessSound();
        }

        //doorlocks
        if (msg == "Lock"){
            llMessageLinked(LINK_SET, 0, "*Lock Door*", NULL_KEY);
            //AccessSound();
        }
        else if (msg == "Unlock"){
            llMessageLinked(LINK_SET, 0, "*Unlock Door*", NULL_KEY);
            //AccessSound();
        }
    }
}