key user;

//NOTE listener handlers so that you aren't opening redundant listens
integer syslisten;
integer dynlisten;
integer chan = 4;

//NOTE generates unique channel for a given user
integer DynamicChannel(string id){
    integer dyn;
    dyn = (integer)("0x" + llGetSubString((string)id, 0, 7));
    return dyn;
}

//NOTE AMY EDIT START
key deadSound           = "9169bd35-2b5b-0f8b-bd7d-4074ff09e33c";
key levelupSound        = "7d35e39a-65b1-e097-3d65-d1dfebdbf474";
key heartbeatSlow       = "838e3a6b-7633-0d2b-6a01-5903e79bfa1a";
key heartbeatFast       = "489c027b-034b-4283-c497-ff49a4254f41";

float experience; //NOTE 0.0 DEFAULT
float totalExperience   = 100.0;
float gain;
float blood             = 0.0;
float bloodMax          = 5.0;
float feedMin           = 0.25;
float feedMax           = 0.50;
float bloodBallCost     = 1.0; //NOTE - casting Blood ball cost (cost will be high for high damage but slow projectile)

integer _chan;
integer hand;
integer health;
integer healthMax;
integer mana;
integer manaMax;
integer armor;
integer damage;
integer llChan          = -458703;
integer listenChannel   = -458790;
integer hudStatus       = TRUE;
integer deathStatus     = FALSE;
integer override_titleC = FALSE; //NOTE - for overiting custom title colors that user has added
integer Bats_Active     = FALSE;
integer DEBUG           = TRUE;
integer EnableLeveling  = TRUE;
integer silentMode      = FALSE;
integer level           = 1;
integer attributePoints;
integer batsCost        = 10; //NOTE - casting Bat Swarm cost
integer updaterate      = 3; //NOTE - 3seconds just for redusing lag
integer random_chance()
{
    if (llFrand(1.0) < 0.1)
        return TRUE;
    return FALSE;
}

list main_buttons   = [];
list exp_buttons    = [];
list perk_buttons   = [];
list debug_buttons  = [];
list grayscale =["black",<0,0,0>,"white",<1,1,1>,"gray",<0.5,0.5,0.5>,"silver",<0.75,0.75,0.75>,"darkgray",<0.4,0.4,0.4>,
    "lightgrey",<0.83,0.83,0.83>];
list reds = ["red",<1,0,0>,"darkred",<0.55,0,0>,"crimson",<0.86,0.08,0.24>,"indianred",<0.8,0.36,0.36>,
    "orangered",<1,0.27,0>];
list pinks = ["hotpink",<1,0.41,0.71>,"pink", <1,0.75,0.8>,"lightpink",<1,0.71,0.76>,"deeppink",<1,0.08,0.58>,
    "fuchsia",<1,0,1>,"orchid",<0.85,0.44,0.84>,"plum",<0.87,0.63,0.87>];
list violets = ["violet",<0.8,0.51,0.8>,"indigo",<0.29,0,0.51>,"lavender",<0.7,0.7,1>,"magenta",<1,0,1>,
    "purple",<0.5,0,0.5>,"darkmagenta",<0.55,0,0.55>,"darkviolet",<0.58,0,0.83>,"blueviolet",<0.54,0.17,0.89>];
list dk_blues = ["darkblue",<0,0,0.55>,"blue",<0,0,1>,"deepskyblue",<0,0.75,1>,"mediumblue",<0,0,0.8>,
    "midnightblue",<0.1,0.1,0.44>,"royalblue",<0.25,0.41,0.88>,"slateblue",<0.42,0.35,0.8>,"steelblue",<0.27,0.51,0.71>];
list lt_blues = ["teal",<0,0.5,0.5>,"turquoise",<0.25,0.88,0.82>,"darkcyan",<0,0.55,0.55>, "lightblue", <0.68,0.85,0.9>,
    "aquamarine",<0.5,1,0.83>,"azure",<0.8,1,1>,"cyan",<0,1,0.9>,"skyblue",<0.53,0.81,0.92>];
list yellows = ["yellow",<1,1,0>,"gold",<1,0.84,0>,"lightyellow",<1,1,0.88>,"goldenrod",<0.85,0.65,0.13>,
    "yellowgreen",<0.6,0.8,0.2>];
list dk_greens = ["darkgreen",<0,0.39,0>,"green",<0,0.5,0>,"forestgreen",<0.13,0.55,0.13>,"lawngreen",<0.49,0.99,0>,
    "springgreen",<0,1,0.5>];
list lt_greens = ["lightgreen",<0.56,0.93,0.56>,"chartreuse",<0.5,1,0>,"greenyellow",<0.68,1,0.18>,"honeydew",<0.94,1,0.94>,
    "limegreen",<0.2,0.8,0.2>,"mintcream",<0.96,1,0.98>,"seagreen",<0.18,0.55,0.34>];
list oranges = ["orange",<1,0.65,0>,"darkorange",<1,0.55,0>,"coral",<1,0.5,0.31>,"navajowhite",<1,0.87,0.68>,
    "salmon",<0.98,0.5,0.45>,"seashell",<1,0.96,0.93>,"brown",<.24,.17,.15>];
list sub_menu;
list main_menu = ["grayscale", "reds", "pinks", "violets", "dk_blues", "lt_blues", "yellows", "dk_greens", "lt_greens", "oranges", "DEFAULT", "▼"];

string csName       = " CARNAGE ";
string version      = "v0.0.1b ";
string customTitle  = "Unamed Player";
string statusText   = "COMBAT+RP";
string desc_          = "(c)Vanessa (meljonna Resident) - ";
string InfoNote     = "CARNAGE - Information";

string Float2String ( float num, integer places, integer rnd)
{
    if (rnd){
        float f = llPow( 10.0, places );
        integer i = llRound(llFabs(num) * f);
        string s = "00000" + (string)i;
        if(num < 0.0)
            return "-" + (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
        return (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
    }
    if (!places)
        return (string)((integer)num );
    if ( (places = (places - 7 - (places < 1) ) ) & 0x80000000)
        return llGetSubString((string)num, 0, places);
    return (string)num;
}

vector color            = <1, 1, 1>;        //NOTE WHITE
vector color_AFK        = <0.876, 0, 0>;    //NOTE RED
vector color_RP         = <0, 0.876, 0>;    //NOTE GREEN
//NOTE AMY EDIT END

doMenu(key id)
{
    if ((!hudStatus) && (!DEBUG)) //NOTE DEBUG not on
        main_buttons = [ "» Title «", "» Color «", "» Silent «", "» Stats «", "» Help «", "▼" ];
    else if ((!hudStatus) && (DEBUG)) //NOTE if DEBUG is on
        main_buttons = [ "» Title «", "» Color «", "» Silent «", "» Stats «", "» DEBUG «", "» Help «", "▼" ];
    else if ((hudStatus) && (DEBUG)) //NOTE if DEBUG is on
        main_buttons = [ "» Title «", "» Color «", "» Silent «", "» Stats «", "» DEBUG «", "» Help «", "▼" ];
    else{
        if(attributePoints >= 1)
            main_buttons = [ "» Suicide «", "» Title «", "» Color «", "» Stats «", "» Perks «", "» Help «", "▼" ];
        else
            main_buttons = [ "» Suicide «", "» Title «", "» Color «", "» Stats «", "» Help «", "▼" ];
    }
    llListenRemove(hand);
    _chan = llFloor(llFrand(2000000));
    hand = llListen(_chan, "", id, "");
    llDialog(id, (string)llGetDisplayName(id) + " (" + (string)llKey2Name(id) + ") Carnage Meter Menu\n"
        + "You have "       + (string)attributePoints + " Perk Points to use.\nCurrent Stats :: \n"
        + "Health: "        + (string)healthMax + "\n"
        + "Stamina: "       + (string)manaMax + "\n"
        + "Blood: "         + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters.\n"
        + "Armor: "         + (string)armor + "\n"
        + "Damage: "        + (string)damage + "\n"
        + "Level: "         + (string)level + "\n"
        + "PerkPoints: "    + (string)attributePoints + "\n", main_buttons, _chan);
}

doDEBUGmenu(key id)
{
    debug_buttons = [ "levelup", "damage", "addblood", "remoblood", "exp", "addperk", "» Perks «", "◄", "▼" ];
    llListenRemove(hand);
    _chan = llFloor(llFrand(2000000));
    hand = llListen(_chan, "", id, "");
    llDialog(id, (string)llGetDisplayName(id) + " (" + (string)llKey2Name(id) + ")'s Carnage Meter DEBUG Menu\nChoose an option?", debug_buttons, _chan);
}

doEXPMenu(key id)
{
    exp_buttons = [ "give_exp10", "give_exp20", "give_exp30", "give_exp40", 
                    "give_exp50", "give_exp60", "give_exp70", "give_exp80",
                    "give_exp90", "give_exp100", "◄", "▼" ];
    llListenRemove(hand);
    _chan = llFloor(llFrand(2000000));
    hand = llListen(_chan, "", id, "");
    llDialog(id, (string)llGetDisplayName(id) + " (" + (string)llKey2Name(id) + ")'s Carnage Meter Menu\nChoose an option?", exp_buttons, _chan);
}

doPerksMenu(key id)
{
    perk_buttons = [ "Health+", "Stamina+", "Blood+", "Armor+", "Damage+", "◄", "▼" ];
    llListenRemove(hand);
    _chan = llFloor(llFrand(2000000));
    hand = llListen(_chan, "", id, "");
    llDialog(id, (string)llGetDisplayName(id) + " (" + (string)llKey2Name(id) + ") Select what stast you want to increase\n"
        + "You have "   + (string)attributePoints + " Perk Points to use.\nCurrent Stats :: \n"
        + "Health: "    + (string)healthMax + "\n"
        + "Stamina: "   + (string)manaMax + "\n"
        + "Blood: "     + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters.\n"
        + "Armor: "     + (string)armor + "\n"
        + "Damage: "    + (string)damage + "\n"
        + "Level: "    + (string)level + "\n"
        + "PerkPoints: "    + (string)attributePoints + "\n", perk_buttons, _chan);
}

setStatusText()
{
    if(!silentMode){
        if(!EnableLeveling){
            if((!hudStatus) && (!override_titleC))
                llSetText("[" + csName + version + "]" 
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" +  customTitle + "\n" + statusText, color_AFK, 1.0);
            else if((hudStatus) && (!override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" +  customTitle + "\n" + statusText, color_RP, 1.0);
            else if((!hudStatus) && (override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" +  customTitle + "\n" + statusText, color, 1.0);
            else if((hudStatus) && (override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" +  customTitle + "\n" + statusText, color, 1.0);
        }
        else{
            if((!hudStatus) && (!override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Level : [" + (string)level + "]" 
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters." 
                    + "\n" + "EXP : " + (string)Float2String(gain, 2, FALSE) + "/" + (string)Float2String(totalExperience, 2, FALSE) 
                    + "\n" + "Perk Points : [" + (string)attributePoints + "]" 
                    + "\n" +  customTitle + "\n" + statusText, color_AFK, 1.0);
            else if((hudStatus) && (!override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Level : [" + (string)level + "]" 
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" + "EXP : " + (string)Float2String(gain, 2, FALSE) + "/" + (string)Float2String(totalExperience, 2, FALSE) 
                    + "\n" + "Perk Points : [" + (string)attributePoints + "]" 
                    + "\n" +  customTitle + "\n" + statusText, color_RP, 1.0);
            else if((!hudStatus) && (override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Level : [" + (string)level + "]" 
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" + "EXP : " + (string)Float2String(gain, 2, FALSE) + "/" + (string)Float2String(totalExperience, 2, FALSE) 
                    + "\n" + "Perk Points : [" + (string)attributePoints + "]" 
                    + "\n" +  customTitle + "\n" + statusText, color, 1.0);
            else if((hudStatus) && (override_titleC))
                llSetText("[" + csName + version + "]"
                    + "\n" + "Level : [" + (string)level + "]" 
                    + "\n" + "Health : " + (string)health + "/" + (string)healthMax 
                    + "\n" + "Stamina : " + (string)mana + "/" + (string)manaMax 
                    + "\n" + "Blood : " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + " liters."
                    + "\n" + "EXP : " + (string)Float2String(gain, 2, FALSE) + "/" + (string)Float2String(totalExperience, 2, FALSE) 
                    + "\n" + "Perk Points : [" + (string)attributePoints + "]" 
                    + "\n" +  customTitle + "\n" + statusText, color, 1.0);
        }
    }
    else
        llSetText("", <1, 1, 1>, 1.0); //NOTE WHITE
}

stats()
{
    llOwnerSay("--------------------------------------------\n"
        + "[" + (string)csName + (string)version + "]\n"
        + "Health: " + (string)health + "/" + (string)healthMax + "\n"
        + "Stamina: " + (string)mana + "/" + (string)manaMax + "\n"
        + "Blood: " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + "\n"
        + "Armor: " + (string)armor + "\n"
        + "Damage: " + (string)damage + "\n"
        + "PerkPoints: " + (string)attributePoints + "\n"
        + "Level/EXP: " + (string)level + " : " + (string)Float2String(gain, 2, FALSE) + "/" + (string)Float2String(totalExperience, 2, FALSE) + "\n"
        + "--------------------------------------------"
    );
}

addEXP(key id, float experience)
{
    if(EnableLeveling){
        gain = gain + experience;
        experience++;
        if (gain == totalExperience){
            totalExperience += 100;
            gain = 0;
            level += 1;
            attributePoints += 1;
            llTriggerSound(levelupSound, 1.0);
            llOwnerSay("You have gained a Level to (" + (string)level + ") and you have (" + (string)attributePoints + ") Perk Points.");
            Leveling();
        }
    if(DEBUG)
        llOwnerSay("EXP:: " 
            + (string)llGetDisplayName(id) + " (" + (string)llKey2Name(id) + ") | " 
            + (string)Float2String(gain, 1, FALSE) + "/" 
            + (string)Float2String(totalExperience, 1, FALSE) + " Points:: " 
            + (string)attributePoints);
    setStatusText();
    }
}

Leveling()
{
    if(EnableLeveling){
        if(level == 1){
            health      = 70;
            healthMax   = 70;
            mana        = 50;
            manaMax     = 50;
            armor       = 1;
            damage      = 1;
            bloodMax    = 5.0;
        }
        else{
            health      += 5;
            healthMax   += 5;
            mana        += 5;
            manaMax     += 5;
        }
    }
}

default
{
    state_entry()
    {
        if(blood >= 1.0)
            llSay(listenChannel, "okBlood");
        llStopSound();
        llPreloadSound(deadSound);
        llPreloadSound(levelupSound);
        llPreloadSound(heartbeatSlow);
        llPreloadSound(heartbeatFast);
        if(llGetAttached())
            llSay(llChan, "meterON");
        llSay(listenChannel, "healthFULL");
        llSetObjectDesc(desc_);
        llListen(listenChannel, "", "", "");
        llListen(chan, "", llGetOwner(), "");
        if(EnableLeveling){
            health          = 70;
            healthMax       = 70;
            mana            = 50;
            manaMax         = 50;
            armor           = 2;
            damage          = 1;
            bloodMax        = 5.0;
            Leveling();
        }
        else{
            health          = 500;
            healthMax       = 500;
            mana            = 100;
            manaMax         = 100;
            armor           = 10;
            damage          = 0;
            bloodMax        = 5.0;
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key attached)
    {
        if(attached == NULL_KEY){
            llSay(llChan, "meterOFF");
            llSay(listenChannel, "METER_NOTFOUND");
        }
        else{
            llSay(llChan, "meterON");
            hudStatus = FALSE;
            statusText = "OOC/AFK"; 
            user = llGetOwner();
            llRequestPermissions(user, PERMISSION_TRIGGER_ANIMATION); 
            if(syslisten)
                llListenRemove(syslisten);
            syslisten = llListen(chan, "", "", "");
            if(dynlisten)
                llListenRemove(dynlisten);
            dynlisten = llListen(DynamicChannel(llGetOwner()), "", "", "");
            if(blood <= feedMax)
                llOwnerSay("You need blood to cast bloodmagic!");
            setStatusText();
            llOwnerSay("Welcome to the " + (string)csName + (string)version + ". " + "Please type /4help for a list of commands to help you activate and use this system"); 
            if(hudStatus)
                llOwnerSay((string)csName + (string)version + " - RP+COMBAT");
            else
                llOwnerSay((string)csName + (string)version + " - OOC/AFK");
            if(silentMode){
                llOwnerSay("Silentmode Active (Combat Disabled)");
                llSay(listenChannel, "silentModeON");
            }
            else
                llSay(listenChannel, "silentModeOFF");
        }
    }

    on_rez(integer start_param)
    {
        //TODO - for fixing relog bugs
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if(llGetOwner())
            doMenu(id);
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel == chan){
            if(llGetOwnerKey(id) == user){
                if(message == "help")
                    llGiveInventory(user, InfoNote);
                else if(message == "on"){
                    if(!silentMode){
                        hudStatus = TRUE;
                        statusText = "RP+COMBAT"; 
                        setStatusText(); 
                        llOwnerSay((string)csName + (string)version + " is now in RP");
                        doMenu(user);
                    }
                    else
                        llOwnerSay("You need to disable SilentMode!");
                }
                else if(message == "suicide"){
                    deathStatus = TRUE;
                    llSay(0, (string)llGetDisplayName(user) + " (" + (string)llKey2Name(user) + ") took the easy way out!");
                    health = 0; 
                    setStatusText(); 
                    state dead;
                }
                else if(message == "off"){
                    hudStatus = FALSE;
                    statusText = "OOC/AFK";
                    setStatusText();
                    llOwnerSay((string)csName + (string)version + " is now AFK/OOC");
                }
                else if(llGetSubString(message, 0,4) == "title"){
                    if(llGetSubString(message, 5,-1) != ""){
                        customTitle = llGetSubString(message, 5,-1);
                        llOwnerSay("You have changed your title to " + customTitle + "."); 
                        setStatusText();
                    }
                }
                else if(llGetSubString(message, 0,6) == "color"){
                        if(llGetSubString(message, 7,-1) != ""){
                            color = (vector)llGetSubString(message, 7,-1); 
                            setStatusText(); 
                        }
                }
                else if(message == "perks"){
                    if(attributePoints >= 1)
                        doPerksMenu(user);
                    else
                        llOwnerSay("You do not have enough Perk Points!");
                }
                else if (message == "silent"){
                    if(!silentMode){
                        silentMode = TRUE;
                        llSay(listenChannel, "silentModeON");
                        llOwnerSay("Silentmode Active (Combat Disabled)"); // you can still FEED without title texts
                    }
                    else{
                        silentMode = FALSE;
                        llSay(listenChannel, "silentModeOFF");
                        llOwnerSay("Silentmode Deactive (Combat Enabled)");
                    }
                }
                else if (message == "stats"){
                    stats();
                    doMenu(user);
                }
                else if (message == "menu")
                    doMenu(user);
                else
                    llOwnerSay("Unknown command please try again"); 
            }
        }
        else if(channel == DynamicChannel(llGetOwner())){
            list incomingParams = llParseString2List(message,[","],[]);
            string damagetype = llList2String(incomingParams,0);
            string attacker = llList2String(incomingParams,1);
            string victim = llList2String(incomingParams,2);
            string subdamagetype = llList2String(incomingParams,3);
            if(llKey2Name(llGetOwner()) == victim){
                if(damagetype == "sword")
                    health -= damage + 10;
                else if(damagetype == "axe")
                    health -= damage + 20;
                else if(damagetype == "great axe")
                    health -= damage + 20;
                else if(damagetype == "bow")
                    health -= damage + 10;
                else if(damagetype == "lance")
                    health -= damage + 20;
                else if(damagetype == "bloodball")
                    health -= damage + 50;
                else if(damagetype == "claw"){ //NOTE for Vampire Claw
                    health -= damage + 25; //will change high just for testing
                    if(attacker != llGetOwner())
                        llSay(listenChannel, "give_exp2");
                }
                else if(damagetype == "bats"){ //NOTE for batSwarm
                    health -= damage + 10; //will change high just for testing
                    if(attacker != llGetOwner())
                        llSay(listenChannel, "give_exp2");
                }
                else
                    health -= damage + 10; //NOTE JUST FOR BACKUP... everytype of weapon works with this now
                //FIX
                llOwnerSay((string)llGetDisplayName(attacker) + " (" + (string)llKey2Name(attacker) + ") hit you with their " + damagetype + ", you took " + (string)damage + " points of damage!");
            }
        }
        else if(channel == listenChannel){
            if(llGetOwnerKey(id) == user){
                if (message == "give_exp4")
                    addEXP(user, 4);
                else if (message == "give_exp10")
                    addEXP(user, 10);
                else if (message == "give_exp20")
                    addEXP(user, 20);
                else if (message == "give_exp30")
                    addEXP(user, 30);
                else if (message == "give_exp40")
                    addEXP(user, 40);
                else if (message == "give_exp50")
                    addEXP(user, 50);
                else if (message == "give_exp60")
                    addEXP(user, 60);
                else if (message == "give_exp70")
                    addEXP(user, 70);
                else if (message == "give_exp80")
                    addEXP(user, 80);
                else if (message == "give_exp90")
                    addEXP(user, 90);
                else if (message == "give_exp100")
                    addEXP(user, 100);
                else if (message == "damageHealth")
                    health -= 5;
                else if(message == "Bats_Active"){
                    Bats_Active = TRUE;
                    mana -= batsCost;
                }
                else if(message == "METER_OK")
                    llSay(listenChannel, "METER_FOUND");
                else if (message == "STATS")
                    stats();
/*                 else if (message == "PERKS"){
                    
                } */
                else if (message == "SILENTON")
                {
                    if(!silentMode){
                        silentMode = TRUE;
                        llSay(listenChannel, "silentModeON");
                        llOwnerSay("Silentmode Active (Combat Disabled)"); // you can still FEED without title texts
                    }
                }
                else if (message == "SILENTOFF")
                {
                    if(silentMode){
                        silentMode = FALSE;
                        llSay(listenChannel, "silentModeOFF");
                        llOwnerSay("Silentmode Deactive (Combat Enabled)");
                    }
                }
                else if(message == "deposit 1.0"){
                    if(blood != 0.0){
                        blood -= 1.0;
                        if(blood == 0.0) //NOTE - for backup!
                            blood = 0.0;
                    }
                    else
                        llSay(listenChannel, "noBlood");
                }
                else if(message == "withdraw 1.0"){
                    if(blood < bloodMax){
                        blood += 1.0;
                        if(blood > bloodMax)
                            blood = bloodMax;
                    }
                    else
                        llSay(listenChannel, "fullBlood");
                }
                else if(message == "Bats_Deactive")
                    Bats_Active = FALSE;
                else if(message == "BloodBall_Casted"){
                    blood -= bloodBallCost;
                }
                else if (message == "blood " + (string)Float2String(feedMin, 2, FALSE)){
                    if(blood != bloodMax){
                        if(blood < bloodMax){
                            blood += feedMin;
                            if(blood > bloodMax)
                                blood = bloodMax;
                        }
                        if(blood >= 1.0){
                            llOwnerSay("You sense fresh blood nearby!\nCurrent Blood: " 
                            + (string)Float2String(blood, 2, FALSE) 
                            + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                            + " liters.");
                            llSay(listenChannel, "okBlood");
                        }
                        else
                            llOwnerSay("You need more blood to cast bloodmagic!\nCurrent Blood: " 
                            + (string)Float2String(blood, 2, FALSE) 
                            + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                            + " liters.");
                    }
                    if(blood == bloodMax){
                        llOwnerSay("You are full!\nCurrent Blood: " 
                        + (string)Float2String(blood, 2, FALSE) 
                        + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                        + " liters.");
                        addEXP(user, -10);
                    }
                }
                else if (message == "blood " + (string)Float2String(feedMax, 2, FALSE)){
                    if(blood != bloodMax){
                        if(blood < bloodMax){
                            blood += feedMax;
                            if(blood > bloodMax)
                                blood = bloodMax;
                        }
                        if(blood >= 1.0){
                            llOwnerSay("You sense fresh blood nearby!\nCurrent Blood: " 
                            + (string)Float2String(blood, 2, FALSE) 
                            + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                            + " liters.");
                            llSay(listenChannel, "okBlood");
                            //FIX - llSay(listenChannel, "bloodupdate");
                        }
                        else if(blood == bloodMax)
                            llOwnerSay("You are full!\nCurrent Blood: " 
                            + (string)Float2String(blood, 2, FALSE) 
                            + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                            + " liters.");
                        else
                            llOwnerSay("You need more blood to cast bloodmagic!\nCurrent Blood: " 
                            + (string)Float2String(blood, 2, FALSE) 
                            + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                            + " liters.");
                    }
        
                    if(blood == bloodMax){
                        llOwnerSay("You are full!\nCurrent Blood: " 
                        + (string)Float2String(blood, 2, FALSE) 
                        + "/" + (string)Float2String(bloodMax, 2, FALSE) 
                        + " liters.");
                        addEXP(user, -20);
                    }
                }
            }
            setStatusText();
        }

        if(message == "» Title «")
            llTextBox(id, "To change your title type : title (name)\nso for example you might type.. title Unamed Player", chan);
        else if(message == "» Color «")
            llDialog(id, "\n\nSelect a color group", main_menu, channel);
        else if (message == "» Help «")
            llGiveInventory(user, InfoNote);
        else if(message == "» Suicide «"){
            deathStatus = TRUE;
            llSay(0, (string)llGetDisplayName(user) + " (" + (string)llKey2Name(user) + ") took the easy way out!");
            health = 0;
            setStatusText();
            state dead;
        }
        else if (message == "» Stats «")
            stats();
        else if (message == "» Perks «")
            doPerksMenu(user);
        else if (message == "» DEBUG «")
            doDEBUGmenu(user);
        else if (message == "Health+"){
            healthMax += 10;
            attributePoints -= 1;
            llOwnerSay("You have increaced your MaxHealth to " + (string)healthMax + ".");
            if(attributePoints >= 1)
                doPerksMenu(user);
        }
        else if (message == "Stamina+"){
            manaMax += 10;
            attributePoints -= 1;
            llOwnerSay("You have increaced your MaxStamina to " + (string)manaMax + ".");
            if(attributePoints >= 1)
                doPerksMenu(user);
        }
        else if (message == "Blood+"){
            bloodMax += .5;
            attributePoints -= 1;
            llOwnerSay("You have increaced your MaxBlood to " + (string)Float2String(bloodMax, 2, FALSE) + " liters.");
            if(attributePoints >= 1)
                doPerksMenu(user);
        }
        else if (message == "Armor+"){
            damage += 1;
            attributePoints -= 1;
            llOwnerSay("You have increaced your Damage to " + (string)damage + ".");
            if(attributePoints >= 1)
                doPerksMenu(user);
        }
        else if (message == "Damage+"){
            armor += 1;
            attributePoints -= 1;
            llOwnerSay("You have increaced your Armor to " + (string)armor + ".");
            if(attributePoints >= 1)
                doPerksMenu(user);
        }
        //---------------------------------------------------
        //will be removed when im done
        //NOTE "GM" Commands for testing (GM? = GameMaster :P lol) works only if DEBUG is TRUE!
        else if (message == "damage"){
            health -= damage + 10;
            llOwnerSay((string)csName + (string)version + (string)health + "/" + (string)healthMax + ".");
            setStatusText();
            doDEBUGmenu(user);
        }
        else if(message == "levelup"){
            addEXP(user, totalExperience);
            doDEBUGmenu(user);
        }
        else if (message == "addblood"){
            blood += 5.0;
            llSay(listenChannel, "bloodupdate " + (string)Float2String(blood, 2, FALSE));
            setStatusText();
            doDEBUGmenu(user);
        }
        else if (message == "remoblood"){
            blood -= 5.0;
            setStatusText();
            doDEBUGmenu(user);
        }
        else if (message == "addperk"){
            attributePoints += 1;
            setStatusText();
            doDEBUGmenu(user);
        }
        else if (message == "exp")
            doEXPMenu(user);
        else if (message == "give_exp50")
            addEXP(user, 50);
        //---------------------------------------------------
        else if (message == "◄")
            doMenu(user);
        else if (message == "▼")
            return;

        if (llListFindList(main_menu, [message]) != -1){
            if (message == "grayscale")
                sub_menu = grayscale + "▼"; 
            else if (message == "reds")
                sub_menu = reds + "▼";
            else if (message == "pinks")
                sub_menu = pinks + "▼";
            else if (message == "violets")
                sub_menu = violets + "▼";
            else if (message == "dk_blues")
                sub_menu = dk_blues + "▼";
            else if (message == "lt_blues")
                sub_menu = lt_blues + "▼";
            else if (message == "yellows")
                sub_menu = yellows + "▼";
            else if (message == "dk_greens")
                sub_menu = dk_greens + "▼";
            else if (message == "lt_greens")
                sub_menu = lt_greens + "▼";
            else if (message == "oranges")
                sub_menu = oranges + "▼";
            else if (message == "DEFAULT")
                override_titleC = FALSE;
            llDialog(id, "Select a color", llList2ListStrided(sub_menu, 0, -1, 2), channel);
            return;  
        } 
        
        integer index = llListFindList(sub_menu, [message]);
        if (index != -1){
            override_titleC = TRUE;
            color = llList2Vector(sub_menu, index + 1);
            setStatusText();
        }
    }

    collision_start(integer num)
    {
        if(!hudStatus) //NOTE == FALSE
            return;
        if(llDetectedType(0) == AGENT_BY_LEGACY_NAME)
            return;
        integer armordamage = llRound(llVecMag(llDetectedVel(0)) / armor); //FIXME 
        health -= armordamage;
        setStatusText();
        llSetTimerEvent(updaterate);
        if(health <= 0){
            deathStatus = TRUE;
            llSay(0, (string)llGetDisplayName(user) + " (" + (string)llKey2Name(user) + ") has died in combat.");
            health = 0;
            setStatusText();
            state dead;
        }
    }

    timer()
    {
        if(health < healthMax){
            health += 2;
            if(health > healthMax)
                health = healthMax;
        }
        else if(mana < manaMax){
            if(Bats_Active)
                mana -= 3; //NOTE bats consume 3mana per second..
            else
                mana += 1;
            if(mana > manaMax)
                mana = manaMax;
        }

        if(health <= 0){
            deathStatus = TRUE;
            llSay(0, (string)llGetDisplayName(user) + " (" + (string)llKey2Name(user) + ") has died in combat.");
            health = 0;
            setStatusText();
            state dead;
        }
        if(mana <= 0){
            llSay(listenChannel,"noMana");
            llOwnerSay("You are out of Stamina!");
            mana = 0;
        }

        if(blood <= 0){
            llSay(listenChannel,"noBlood");
            blood = 0.0;
        }
        setStatusText();
    }
}

state dead
{
    state_entry()
    {
        llTriggerSound(deadSound, 1.0);
        llStartAnimation("death");
        llSetTimerEvent(25); //NOTE 25seconds?
    }

    timer()
    {
        if(deathStatus){
            llStopAnimation("death");
            llOwnerSay("You have been revived");
            deathStatus = FALSE;
            state default;
        }
    }

    state_exit()
    {
        llStopAnimation("death");
        health = healthMax; //NOTE - full HP after dead
    }
}