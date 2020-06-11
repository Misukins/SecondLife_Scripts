key user;

string csName = "[Trinity Combat System v1.2]";
string customTitle = "Unamed Player";
string statusText = "OFFLINE";

integer healthInc = 5;
integer deathStatus = 0;
integer deathTime = 10;
integer hudStatus = 0;
integer hidden = 0;
integer chan = 1000;
integer _chan = 1001;
integer health = 100;
integer healthMax = 100;
integer resist = 2;
integer listener;
integer channel;
integer DEBUG = TRUE;

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
list main_menu = ["grayscale", "reds", "pinks", "violets", "dk_blues", "lt_blues", "yellows", "dk_greens", "lt_greens", "oranges"];

vector color = <1,1,1>;

menu()
{
    if (hudStatus == 0 && hidden == 0)
    {
        list main_menu = [ "» On «", "» Hide «", "» Suicide «", "» Title «", "» Color «", "» Help «", "» Exit «" ];
        string message = "» Owner Options «\nSelect one of the options below...";
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", llGetOwner(), "");
        llDialog(llGetOwner(), message, main_menu, channel);
    }
    else if (hudStatus == 1 && hidden == 0)
    {
        list main_menu = [ "» Off «", "» Hide «", "» Suicide «", "» Title «", "» Color «", "» Help «", "» Exit «" ];
        string message = "» Owner Options «\nSelect one of the options below...";
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", llGetOwner(), "");
        llDialog(llGetOwner(), message, main_menu, channel);
    }
    
    if (hudStatus == 0 && hidden == 1)
    {
        list main_menu = [ "» On «", "» Show «", "» Suicide «", "» Title «", "» Color «", "» Help «", "» Exit «" ];
        string message = "» Owner Options «\nSelect one of the options below...";
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", llGetOwner(), "");
        llDialog(llGetOwner(), message, main_menu, channel);
    }
    else if (hudStatus == 1 && hidden == 1)
    {
        list main_menu = [ "» Off «", "» Show «", "» Suicide «", "» Title «", "» Color «", "» Help «", "» Exit «" ];
        string message = "» Owner Options «\nSelect one of the options below...";
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", llGetOwner(), "");
        llDialog(llGetOwner(), message, main_menu, channel);
    }
}

setStatusText()
{
    if (hidden == 0)
        llSetText(csName + "\n" + "Health : " + (string)health + " / " + (string)healthMax + "\n" +  customTitle + "\n" + statusText, color, 1.0);
    else
        llSetText("", color, 1.0);
}

help()
{
    llOwnerSay("Command for this System are typed onto channel " + (string)chan + " and are as follows :\n1. Use Gesture (F4) when activated...or use typing.. up to you\n2. To get menu, type : /" + (string)chan + "menu\n3. To activate the system, type : /" + (string)chan + "on\n4. To deactivate the system, type : /" + (string)chan + "off \n5. To hide the system, type : /" + (string)chan + "hide \n6. To show the system, type : /" + (string)chan + "show\n7. To change your title, type : /" + (string)chan + "title (name) so for example you might type.... /" + (string)chan + "title Unamed Player.");
}

default
{
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    state_entry()
    {
        if(hudStatus == 1)
            llListen(_chan, "", llGetOwner(), "");
    }
    
    attach(key attached)
    {
        list userName = llParseString2List(llGetDisplayName(user), [""], []);
        if(attached == NULL_KEY)
		{
			if (DEBUG == FALSE)
				llSay(0, (string)userName + " (" +(string)llKey2Name(user) + ") has detached their " + (string)csName);
			else
				llOwnerSay((string)userName + " (" +(string)llKey2Name(user) + ") has detached their " + (string)csName);
		}
        else
        {
            hudStatus = 0;
            statusText = "OFFLINE";
            user = llGetOwner();
            llRequestPermissions(user, PERMISSION_TRIGGER_ANIMATION);
            llListen(chan, "", user, "");
            setStatusText();
            llOwnerSay("Welcome to the " + (string)csName + ". " + "Please type /" + (string)chan + "menu or /" + (string)chan + "help for a list of commands to help you activate and use this system.\nYou can also use gesture by activating it and press F4 for menu.");
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(channel == chan)
        {
            if(id == user)
            {
                if (message == "menu")
                    menu();
                else if(message == "help")
                    help();
                else if(message == "on")
                {
                    hudStatus = 1;
                    statusText = "ONLINE";
                    setStatusText();
                    llOwnerSay((string)csName + " is now online");
					llListen(_chan, "", user, "");
                }
                else if(message == "off")
                {
                    hudStatus = 0;
                    statusText = "OFFLINE";
                    setStatusText();
                    llOwnerSay((string)csName + " is now offline");
                }
                else if(llGetSubString(message, 0,4) == "title")
                {
                    if(llGetSubString(message, 5,-1) != "")
                    {
                        customTitle = llGetSubString(message, 5,-1);
                        llOwnerSay("You have changed your title to " + customTitle + ".");
                        setStatusText();
                    }
                }
                else if(message == "hide")
                {
                    hidden = 1;
                    llOwnerSay((string)csName + " is now hidden");
                    setStatusText();
                }
                else if(message == "show")
                {
                    hidden = 0;
                    llOwnerSay((string)csName + " is not hidden");
                    setStatusText();
                }
                else
                    llOwnerSay("Unknown command please try again");
            }
        }
		
		if(channel == _chan)
        {
			if(id == user)
			{
				if(hudStatus == 1)
				{
					if (message == "potion")
					{
						health += 50;
						setStatusText();
						if (DEBUG == TRUE)
							llOwnerSay("DEBUG :: _chan 1001: Potion Heard");
					}
					else if (message == "revive")
					{
						if (DEBUG == TRUE)
							llOwnerSay("DEBUG :: _chan 1001: Revive Heard");
						if(deathStatus == 1)
						{
							llStopAnimation("Dead Pose");
							llOwnerSay("You have been revived");
							deathStatus = 0;
							health += 20;
							setStatusText();
						}
						else
							llOwnerSay("you cannot use Reviver at this moment...");
					}
					else if (message == "death")
					{
						list userName = llParseString2List(llGetDisplayName(user), [""], []);
						deathStatus = 1;
						if (DEBUG == TRUE)
							llOwnerSay((string)userName + " (" +(string)llKey2Name(user) + ") took the easy way out!");
						else
							llSay(0, (string)userName + " (" +(string)llKey2Name(user) + ") took the easy way out!");
						llStartAnimation("Dead Pose");
						health = 0;
						setStatusText();
						llSetTimerEvent(deathTime);
						if (DEBUG == TRUE)
							llOwnerSay("DEBUG :: _chan 1001: Death Potion Heard");
					}
				}
				else
				{
					if (DEBUG == TRUE)
						llOwnerSay("HUD OFFLINE");
					else
						llSay(0, "HUD OFFLINE");
				}
			}
		}
		
        if(message == "» On «")
        {
            hudStatus = 1;
            statusText = "ONLINE";
            setStatusText();
            llOwnerSay((string)csName + " is now online");
            menu();
        }
        else if(message == "» Off «")
        {
            hudStatus = 0;
            statusText = "OFFLINE";
            setStatusText();
            llOwnerSay((string)csName + " is now offline");
            menu();
        }
        else if(message == "» Hide «")
        {
            hidden = 1;
            llOwnerSay((string)csName + " is now hidden");
            setStatusText();
            menu();
        }
        else if(message == "» Show «")
        {
            hidden = 0;
            llOwnerSay((string)csName + " is not hidden");
            setStatusText();
            menu();
        }
        else if(message == "» Title «")
            llTextBox(id, "To change your title type : title (name) so for example you might type.... title Unamed Player", chan);
        else if(message == "» Color «")
            llDialog(id, "\n\nSelect a color group", main_menu, channel);
        else if (message == "» Help «")
        {
            help();
            menu();
        }
		else if (message == "» Suicide «")
		{
			list userName = llParseString2List(llGetDisplayName(user), [""], []);
			deathStatus = 1;
			if (DEBUG == TRUE)
				llOwnerSay((string)userName + " (" +(string)llKey2Name(user) + ") took the easy way out!");
			else
				llSay(0, (string)userName + " (" +(string)llKey2Name(user) + ") took the easy way out!");
			llStartAnimation("Dead Pose");
			health = 0;
			setStatusText();
			llSetTimerEvent(deathTime);
		}

        if (llListFindList(main_menu, [message]) != -1)
        {
            if (message == "grayscale")
                sub_menu = grayscale; 
            else if (message == "reds")
                sub_menu = reds;
            else if (message == "pinks")
                sub_menu = pinks;
            else if (message == "violets")
                sub_menu = violets;
            else if (message == "dk_blues")
                sub_menu = dk_blues;
            else if (message == "lt_blues")
                sub_menu = lt_blues;
            else if (message == "yellows")
                sub_menu = yellows;
            else if (message == "dk_greens")
                sub_menu = dk_greens;
            else if (message == "lt_greens")
                sub_menu = lt_greens;
            else if (message == "oranges")
                sub_menu = oranges;
            llDialog(id, "\n\nSelect a color", llList2ListStrided(sub_menu, 0, -1, 2), channel);
            return;  
        } 
        
        integer index = llListFindList(sub_menu, [message]);
        if (index != -1)
        {
            color = llList2Vector(sub_menu, index+1);
            setStatusText();
            menu();
        }
    }
    
    collision_start(integer num)
    {
        if(hudStatus == 0)
            return;
        if(llDetectedType(0) == AGENT_BY_LEGACY_NAME)
            return;
        integer damage = llRound(llVecMag(llDetectedVel(0))/resist);
        health -= damage;
        setStatusText();
        llSetTimerEvent(deathTime);
        if(health <= 0)
        {
            list userName = llParseString2List(llGetDisplayName(user), [""], []);
            deathStatus = 1;
			if (DEBUG == TRUE)
				llOwnerSay((string)userName + " (" +(string)llKey2Name(user) + ") has died in combat.");
			else
				llSay(0, (string)userName + " (" +(string)llKey2Name(user) + ") has died in combat.");
            llStartAnimation("Dead Pose");
            health = 0;
            setStatusText();
            llSetTimerEvent(deathTime);
        }
    }
        
    timer()
    {
        if(deathStatus == 1)
        {
			if(health < healthMax)
			{
				health += 5;
				if(health > healthMax)
					health = healthMax;
			}
            llStopAnimation("Dead Pose");
            llOwnerSay("You have been revived");
            deathStatus = 0;
        }
        health += 1;
		setStatusText();
    }
}
