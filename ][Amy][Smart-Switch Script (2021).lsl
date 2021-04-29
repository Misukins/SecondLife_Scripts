float soundVolume     = 1.0;

integer link_num;
integer ledlight_living;
integer ledlight_living1;
integer ledlight_living2;
integer ledlight_mainroom;
integer ledlight_melroom;
integer ledlight_questroom;
integer ledlight_bathroom;
integer LIGHT_SIDE = 1;

integer channel;
integer listen_handle;

integer VoiceChannel    = 0;
integer Group_Only      = FALSE;
integer Owner_Only      = TRUE;
integer Public_Access   = FALSE;

integer Debug           = FALSE;

key owner;

list main_menu              = [ "LivingRoom", "MainBedRoom", "MelBedRoom", "QuestBedRoom", "BathRoom", "All-Lights", "Access", "Exit" ];
list AccessList_Menu        = [ "Group", "Private", "Public", "Back", "Exit" ];

list LivingRoom_Menu        = [ "Lights", "CeilingFan", "Back", "Exit" ];
list CeilingFan_Menu        = [ "++VerySlow++", "++Slow++", "++Medium++", "++Fast++", "++VeryFast++", "++Off++", "Back", "Exit" ];

list LivingRoomLights_Menu  = [ "+Low", "+Medium", "+High", "+Off", "Back", "Exit" ];
list MainRoom_Menu          = [ "-Low", "-Medium", "-High", "-Off", "Back", "Exit" ];
list MelRoom_Menu           = [ "*Low", "*Medium", "*High", "*Off", "Back", "Exit" ];
list QuestRoom_Menu         = [ ">Low", ">Medium", ">High", ">Off", "Back", "Exit" ];
list BathRoom_Menu          = [ "|Low", "|Medium", "|High", "|Off", "Back", "Exit" ];
list AllLights_Menu         = [ "+-On-+", "+-Off-+", "Back", "Exit" ];

string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

string _LEDLIGHT_LIVING     = "LedLight-LivingRoom";
string _LEDLIGHT_LIVING1    = "LedLight-LivingRoom1";
string _LEDLIGHT_LIVING2    = "LedLight-LivingRoom2";
string _LEDLIGHT_MAINROOM   = "LedLight-MainRoom";
string _LEDLIGHT_MELROOM    = "LedLight-MelRoom";
string _LEDLIGHT_QUESTROOM  = "LedLight-QuestRoom";
string _LEDLIGHT_BATHROOM   = "LedLight-BathRoom";

doMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", main_menu, channel);
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
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", LivingRoom_Menu, channel);
}

doLivingRoomLightsMenu(key id){
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

doMainRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", MainRoom_Menu, channel);
}

doMelRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", MelRoom_Menu, channel);
}

doQuestRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", QuestRoom_Menu, channel);
}

doBathRoomMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", BathRoom_Menu, channel);
}

doAllLightsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", AllLights_Menu, channel);
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
        else if(llGetLinkName(i) == _LEDLIGHT_LIVING2){
            ledlight_living2 = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_MAINROOM){
            ledlight_mainroom = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_MELROOM){
            ledlight_melroom = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_QUESTROOM){
            ledlight_questroom = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_BATHROOM){
            ledlight_bathroom = i;
            found++;
        }
    }
    while (i-- && found < 7);
}

AllLightON(){
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.25]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.25]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.25]);
    llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
    llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
    llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
}

AllLightOFF(){
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_bathroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
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
        if (Group_Only == TRUE){
            if (sameGroup || id == owner)
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
        else if (msg == "Access"){
            if (id == llGetOwner())
                doAccessListMenu(id);
            else{
                DeniedSound();
                return;
            }
        }
        else if (msg == "LivingRoom")
            doLivingRoomMenu(id);
        else if (msg == "Lights")
            doLivingRoomLightsMenu(id);
        else if (msg == "CeilingFan")
            doCeilingFanMenu(id);
        else if (msg == "MainBedRoom")
            doMainRoomMenu(id);
        else if (msg == "MelBedRoom")
            doMelRoomMenu(id);
        else if (msg == "QuestBedRoom")
            doQuestRoomMenu(id);
        else if (msg == "BathRoom")
            doBathRoomMenu(id);
        else if (msg == "All-Lights")
            doAllLightsMenu(id);
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
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "+Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "+High"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "+Off"){
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }

        //mainRoom
        if (msg == "-Low"){
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "-Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "-High"){
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "-Off"){
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_mainroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }

        //melRoom
        if (msg == "*Low"){
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == "*Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == "*High"){
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == "*Off"){
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_melroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
            AccessSound();
        }
        
        //questRoom
        if (msg == ">Low"){
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_GLOW,LIGHT_SIDE,0.15]);
            AccessSound();
        }
        else if (msg == ">Medium"){
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_GLOW,LIGHT_SIDE,0.25]);
            AccessSound();
        }
        else if (msg == ">High"){
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_GLOW,LIGHT_SIDE,0.55]);
            AccessSound();
        }
        else if (msg == ">Off"){
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(ledlight_questroom, [PRIM_GLOW,LIGHT_SIDE,0.0]);
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
    }
}