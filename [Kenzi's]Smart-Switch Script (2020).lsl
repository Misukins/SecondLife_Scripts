integer channel;
integer listen_handle;

integer VoiceChannel    = 0;
integer soundVolume     = 1.0;

integer Group_Only      = FALSE;
integer Owner_Only      = FALSE;
integer Public_Access   = TRUE;

integer Debug           = FALSE;

key owner;

list main_menu =                    [ "LivingRoom", "Amys Room", "Hennas Room", "Kenzis Room", "BathRoom", "+-Lights-+", "Access", "Exit" ];
list AllLights_Menu =               [ "+-On-+", "+-Off-+", "Back", "Exit" ];
list LivingRoomOptions_Menu =       [ "Lights", "CeilingFan", "Back", "Exit" ];
list CeilingFanLights_Menu =        [ "Low", "Medium", "High", "Off", "Back", "Exit" ];
list CeilingFanRotation_Menu =      [ "+VerySlow+", "+Slow+", "+Medium+", "+Fast+", "+VeryFast+", "+Off+", "Back", "Exit" ];
list BedRoomOptions_Menu =          [ ">+Lights+<", "Back", "Exit" ];
list BedRoomLights_Menu =           [ "-Low-", "-Medium-", "-High-", "-Off-", "Back", "Exit" ];
list BedRoomFan_Menu =              [ ">+VerySlow+<", ">+Slow+<", ">+Medium+<", ">+Fast+<", ">+VeryFast+<", ">+Off+<", "Back", "Exit" ];
//list D_W_tint_Menu =                [ "*Open*", "*Closed*", "Back", "Exit" ];
list BathRoomLights_Menu =          [ ">Low<", ">Medium<", ">High<", ">Off<", "Back", "Exit" ];
list AccessList_Menu =              [ "Group", "Private", "Public", "Back", "Exit" ];
/*
list Upstairs_Menu =                [ "**Room1**", "**Room2**", "Back", "Exit" ];
list UpstairsBedRoomOptions_Menu =  [ "++Lights++", "++CeilingFan++", "Back", "Exit" ];
list UpstairsBedRoomFan_Menu =      [ "*+VerySlow+*", "*+Slow+*", "*+Medium+*", "*+Fast+*", "*+VeryFast+*", "*+Off+*", "Back", "Exit" ];
list UpstairsBedRoomLights_Menu =   [ "++Low++", "++Medium++", "++High++", "++Off++", "Back", "Exit" ];
list UpstairsRoomOptions_Menu =     [ "-+Lights+-", "-+CeilingFan+-", "Back", "Exit" ];
list UpstairsRoomFan_Menu =         [ "-*VerySlow*-", "-*Slow*-", "-*Medium*-", "-*Fast*-", "-*VeryFast*-", "-*Off*-", "Back", "Exit" ];
list UpstairsRoomLights_Menu =      [ "-+Low+-", "-+Medium+-", "-+High+-", "-+Off+-", "Back", "Exit" ];
*/

string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";
string  helpNotecart        = "Amy's - SmartHome Commands";

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

doAllLightsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", AllLights_Menu, channel);
}

doLivingRoomOptionsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", LivingRoomOptions_Menu, channel);
}

doCeilingFanLightsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", CeilingFanLights_Menu, channel);
}

doCeilingFanRotationMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", CeilingFanRotation_Menu, channel);
}

doBedRoomOptionsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", BedRoomOptions_Menu, channel);
}

doBedRoomLightsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", BedRoomLights_Menu, channel);
}

doBathRoomLightsMenu(key id){
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", BathRoomLights_Menu, channel);
}

AccessSound(){
    llTriggerSound(confirmedSound, soundVolume);
}

DeniedSound(){
    llWhisper(0, "Access Denied!");
    llTriggerSound(accessDeniedSound, soundVolume);
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
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
                llMessageLinked(LINK_SET, 0, "Medium", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "-Medium-", NULL_KEY);
                llMessageLinked(LINK_SET, 0, ">Medium<", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "-+Medium+-", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "++Medium++", NULL_KEY);
                AccessSound();     
            }
            else if (msg == "lights off"){
                llMessageLinked(LINK_SET, 0, "Off", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "-Off-", NULL_KEY);
                llMessageLinked(LINK_SET, 0, ">Off<", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "-+Off+-", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "++Off++", NULL_KEY);
                AccessSound();
            }
            else if (msg == "fan on"){
                llMessageLinked(LINK_SET, 0, "+Medium+", NULL_KEY);
                AccessSound();     
            }
            else if (msg == "fan off"){
                llMessageLinked(LINK_SET, 0, "+Off+", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom lights low"){
                llMessageLinked(LINK_SET, 0, "Low", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom lights medium"){
                llMessageLinked(LINK_SET, 0, "Medium", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom lights high"){
                llMessageLinked(LINK_SET, 0, "High", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom lights off"){
                llMessageLinked(LINK_SET, 0, "Off", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom ceilingfan very slow"){
                llMessageLinked(LINK_SET, 0, "+VerySlow+", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom ceilingfan slow"){
                llMessageLinked(LINK_SET, 0, "+Slow+", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom ceilingfan medium"){
                llMessageLinked(LINK_SET, 0, "+Medium+", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom ceilingfan fast"){
                llMessageLinked(LINK_SET, 0, "+Fast+", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom ceilingfan very fast"){
                llMessageLinked(LINK_SET, 0, "+VeryFast+", NULL_KEY);
                AccessSound();
            }
            else if (msg == "livingroom ceilingfan off"){
                llMessageLinked(LINK_SET, 0, "+Off+", NULL_KEY);
                AccessSound();
            }
            //F
            else if (msg == "bedroom lights low"){
                llMessageLinked(LINK_SET, 0, "-Low-", NULL_KEY);
                AccessSound();
            }
            else if (msg == "bedroom lights medium"){
                llMessageLinked(LINK_SET, 0, "-Medium-", NULL_KEY);
                AccessSound();
            }
            else if (msg == "bedroom lights high"){
                llMessageLinked(LINK_SET, 0, "-High-", NULL_KEY);
                AccessSound();
            }
            else if (msg == "bedroom lights off"){
                llMessageLinked(LINK_SET, 0, "-Off-", NULL_KEY);
                AccessSound();
            }
            //F
            else if (msg == "bathroom lights low"){
                llMessageLinked(LINK_SET, 0, ">Low<", NULL_KEY);
                AccessSound();
            }
            else if (msg == "bathroom lights medium"){
                llMessageLinked(LINK_SET, 0, ">Medium<", NULL_KEY);
                AccessSound();
            }
            else if (msg == "bathroom lights high"){
                llMessageLinked(LINK_SET, 0, ">High<", NULL_KEY);
                AccessSound();
            }
            else if (msg == "bathroom lights off"){
                llMessageLinked(LINK_SET, 0, ">Off<", NULL_KEY);
                AccessSound();
            }
            //F
            else if (msg == "kitchen lights low"){
                llMessageLinked(LINK_SET, 0, "-+Low+-", NULL_KEY);
                AccessSound();
            }
            else if (msg == "kitchen lights medium"){
                llMessageLinked(LINK_SET, 0, "-+Medium+-", NULL_KEY);
                AccessSound();
            }
            else if (msg == "kitchen lights high"){
                llMessageLinked(LINK_SET, 0, "-+High+-", NULL_KEY);
                AccessSound();
            }
            else if (msg == "kitchen lights off"){
                llMessageLinked(LINK_SET, 0, "-+Off+-", NULL_KEY);
                AccessSound();
            }
            //F
            else if (msg == "kidsroom lights low"){
                llMessageLinked(LINK_SET, 0, "++Low++", NULL_KEY);
                AccessSound();
            }
            else if (msg == "kidsroom lights medium"){
                llMessageLinked(LINK_SET, 0, "++Medium++", NULL_KEY);
                AccessSound();
            }
            else if (msg == "kidsroom lights high"){
                llMessageLinked(LINK_SET, 0, "++High++", NULL_KEY);
                AccessSound();
            }
            else if (msg == "kidsroom lights off"){
                llMessageLinked(LINK_SET, 0, "++Off++", NULL_KEY);
                AccessSound();
            }
            else if (msg == "help"){
                llInstantMessage(id, "Notecart Send...");
                llGiveInventory(id, helpNotecart);
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
            doLivingRoomOptionsMenu(id);
        else if (msg == "Lights")
            doCeilingFanLightsMenu(id);
        else if (msg == "CeilingFan")
            doCeilingFanRotationMenu(id);
        else if (msg == "BedRoom")
            doBedRoomOptionsMenu(id);
        else if (msg == "BathRoom")
            doBathRoomLightsMenu(id);
        else if (msg == "Window")
            doD_W_tintMenu(id);
        else if (msg == "+-Lights-+")
            doAllLightsMenu(id);
        else if (msg == ">+Lights+<")
            doBedRoomLightsMenu(id);
        else if (msg == ">+CeilingFan+<")
            doBedRoomFanMenu(id);
        else if (msg == "Upstairs")
            doUpstairsMenu(id);
        else if (msg == "**Room1**")
            doUpstairsRoomOptionsMenu(id);
        else if (msg == "**Room2**")
            doUpstairsBedRoomOptionsMenu(id);
        else if (msg == "-+Lights+-")
            doUpstairsRoomLightsMenu(id);
        else if (msg == "-+CeilingFan+-")
            doUpstairsRoomFanMenu(id);
        else if (msg == "++Lights++")
            doUpstairsBedRoomLightsMenu(id);
        else if (msg == "++CeilingFan++")
            doUpstairsBedRoomFanMenu(id);
        
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
            llMessageLinked(LINK_SET, 0, "Medium", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "-Medium-", NULL_KEY);
            llMessageLinked(LINK_SET, 0, ">Medium<", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "-+Medium+-", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "++Medium++", NULL_KEY);
            AccessSound();
            
        }
        else if (msg == "+-Off-+"){
            llMessageLinked(LINK_SET, 0, "Off", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "-Off-", NULL_KEY);
            llMessageLinked(LINK_SET, 0, ">Off<", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "-+Off+-", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "++Off++", NULL_KEY);
            AccessSound();
        }
        
        //LIVINGROOMFANLIGHTS
        else if (msg == "Low"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "Medium"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "High"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "Off"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //LIVINGROOMFANROTATION
        else if (msg == "+VerySlow+") {
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "+Slow+"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "+Medium+"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "+Fast+"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "+VeryFast+"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "+Off+"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //BEDROOMLIGHTS
        else if (msg == "-Low-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-Medium-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-High-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-Off-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //BEDROOMCEILINGFAN
        else if (msg == ">+VerySlow+<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">+Slow+<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">+Medium+<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">+Fast+<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">+VeryFast+<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">+Off+<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //BATHROOMLIGHTS
        else if (msg == ">Low<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">Medium<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">High<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == ">Off<"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //UPSTAIRSROOMFANLIGHTS
        else if (msg == "-+Low+-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-+Medium+-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-+High+-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-+Off+-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //UPSTAIRSROOMFAN
        else if (msg == "-*VerySlow*-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-*Slow*-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-*Medium*-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-*Fast*-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-*VeryFast*-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "-*Off*-"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //UPSTAIRSBEDROOMFANLIGHTS
        else if (msg == "++Low++"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "++Medium++"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "++High++"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "++Off++"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        
        //UPSTAIRSBEDROOMFAN
        else if (msg == "*+VerySlow+*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "*+Slow+*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "*+Medium+*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "*+Fast+*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "*+VeryFast+*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "*+Off+*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
            
        //Door/Windows tint
        else if (msg == "*Open*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
        else if (msg == "*Closed*"){
            llMessageLinked(LINK_SET, 0, (string)msg, NULL_KEY);
            AccessSound();
        }
    }
}