key owner;

float totalBlood        = 10.0;
float currentBlood      = 0.0;

integer ll_channel      = -98754465;
integer channel;
integer listen_handle;
integer DEBUG           = TRUE;
integer Group_Only      = FALSE;
integer Owner_Only      = TRUE;
integer Public_Access   = FALSE;
integer isEMPTY;
integer texture1_enabled = FALSE;
integer texture2_enabled = FALSE;
integer texture3_enabled = TRUE;

list main_menu;
list AccessList_Menu;
list owner_name;
list Settings_Menu;
list Textures_Menu;
list Withdraw_Menu;
list Deposit_Menu;

string desc_    = "(c)Amy (meljonna Resident) -";
string name = "";
string origName;
string acc = "";

vector titleColor = <0.905, 0.686, 0.924>; //will be removed 

/*
■
□
*/

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

menu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    if(_id == llGetOwner())
        main_menu = ["Deposit", "Withdraw", "Settings", "▼"];
    else
        main_menu = ["Deposit", "Withdraw", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option\nCurrent Blood volume :: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + 
        " liters(s)", main_menu, channel);
}

settingsMenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    Settings_Menu = ["Textures", "Access", "◄", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option", Settings_Menu, channel);
}

accessMenu(key _id){
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    if((Owner_Only) && (!Group_Only) && (!Public_Access))
        AccessList_Menu = ["Group", "■Private", "Public", "◄", "▼"];
    else if((!Owner_Only) && (Group_Only) && (!Public_Access))
        AccessList_Menu = ["■Group", "Private", "Public", "◄", "▼"];
    else if((!Owner_Only) && (!Group_Only) && (Public_Access))
        AccessList_Menu = ["Group", "Private", "■Public", "◄", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option", AccessList_Menu, channel);
}

texturesMenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    if((texture1_enabled) && (!texture2_enabled) && (!texture3_enabled))
        Textures_Menu = ["■texture1", "texture2", "texture3", "◄", "▼"];
    else if((!texture1_enabled) && (texture2_enabled) && (!texture3_enabled))
        Textures_Menu = ["texture1", "■texture2", "texture3", "◄", "▼"];
    else if((!texture1_enabled) && (!texture2_enabled) && (texture3_enabled))
        Textures_Menu = ["texture1", "texture2", "■texture3", "◄", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option", Textures_Menu, channel);
}

WithdrawMenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    Withdraw_Menu = ["*1 liter", "*0.50 liter", "*0.25 liter", "*0.10 liter", "◄", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option\nCurrent Blood volume :: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + 
        " liters(s)", Withdraw_Menu, channel);
}

DepositMenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    Deposit_Menu = ["1 liter", "0.50 liter", "0.25 liter", "0.10 liter", "◄", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option\nCurrent Blood volume :: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + 
        " liters(s)", Deposit_Menu, channel);
}


saveData()
{
    list saveData;
    saveData += Float2String(totalBlood, 2, FALSE);
    llSetObjectDesc(desc_ + llDumpList2String(saveData, "-"));
}

dispString(string value)
{
    llSetText(value, titleColor, 1);
}

updateTimeDisp()
{
    if((Group_Only) && (!Owner_Only) && (!Public_Access))
        acc = "Group Access";
    else if((!Group_Only) && (Owner_Only) && (!Public_Access))
        acc = "Owner Only";
    else if((!Group_Only) && (!Owner_Only) && (Public_Access))
        acc = "Public Access";
    dispString((string)owner_name + " (" + (string)name + ")'s Blood Barrel 10L\nTotal Blood: "
        + (string)Float2String(currentBlood, 2, FALSE) + "/"
        + (string)Float2String(totalBlood, 2, FALSE) + ".\nCurrent Access: "
        + (string)acc + ".");
}

call_Deposit(key _id)
{
    if(currentBlood != totalBlood){
        if(currentBlood < totalBlood){
            currentBlood += 1.0;
            llShout(ll_channel, "depositBlood");
            if(currentBlood > totalBlood)
                currentBlood = totalBlood;
        }
    }
    else
        llOwnerSay("BARREL FULL!!");
    menu(_id);
    updateTimeDisp();
}

call_Withdraw(key _id)
{
    if(currentBlood == 0)
        isEMPTY = TRUE;
    else
        isEMPTY = FALSE;
    if(currentBlood <= totalBlood){
        if(!isEMPTY){
            currentBlood -= 1.0;
            llShout(ll_channel, "withdrawBlood");
        }
        else
            llOwnerSay("EMPTY");
    }
    menu(_id);
    updateTimeDisp();
}

default
{
    state_entry()
    {
        origName = llGetObjectName();
        owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
        name = llKey2Name(llGetOwner());
        llSetText("", <0.0, 0.0, 0.0>, 0.0);
        llSetObjectDesc(desc_);
        llListen(ll_channel, "", "", "");
        if(currentBlood == 0)
            isEMPTY = TRUE;
        else
            isEMPTY = FALSE;
        updateTimeDisp();
    }

    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key _k)
    {
        if (_k != NULL_KEY){
            llOwnerSay("YOU NEED TO REZ ME!!");
            llDetachFromAvatar();
        }
        
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(id);
        list username = llParseString2List(llGetDisplayName(id), [""], []);
        string owneruser = llKey2Name(owner);
        string avatar = llKey2Name(id);
        if (id == owner)
            menu(id);
        else if (Group_Only){
            if (sameGroup)
                menu(id);
            else{
                llSetObjectName("");
                llInstantMessage(id, "Hello " + (string)username + ", you are not in same group, ask secondlife:///app/agent/" + (string)owner + "/about for access?");
                llSetObjectName(origName);
            }
        }
        else if (Owner_Only){
            if(id == owner)
                menu(id);
            else{
                llSetObjectName("");
                llInstantMessage(id, "Hello " + (string)username + ", sorry this has been set to owner access only, ask secondlife:///app/agent/" + (string)owner + "/about for access?");
                llSetObjectName(origName);
            }
        }
        else if (Public_Access)
            menu(id);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "▼")
            return;
        else if (message == "◄")
            menu(id);
        else if (message == "Deposit"){
            if(currentBlood == totalBlood){
                llOwnerSay("BARREL FULL");
                menu(id);
            }
            else
                //state depositBlood;
        }
        else if (message == "Withdraw"){
            if(!isEMPTY)

                //state withdrawBlood;
            else{
                llOwnerSay("EMPTY");
                menu(id);
            }
        }
        else if (message == "1 liter"){
            if(HUDon)
                if(currentBlood != totalBlood){
                    if(currentBlood < totalBlood){
                        currentBlood += 0.25;
                        llShout(ll_channel, "depositBlood2");
                        if(currentBlood > totalBlood)
                            currentBlood = totalBlood;
                    }
                }
                else
                    llOwnerSay("BARREL FULL!!");
            else
                llOwnerSay("no HUD");
            DepositMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.50 liter"){
            if(currentBlood != totalBlood){
                if(currentBlood < totalBlood){
                    currentBlood += 0.25;
                    llShout(ll_channel, "depositBlood2");
                    if(currentBlood > totalBlood)
                        currentBlood = totalBlood;
                }
            }
            else
                llOwnerSay("BARREL FULL!!");
            DepositMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.25 liter"){
            if(currentBlood != totalBlood){
                if(currentBlood < totalBlood){
                    currentBlood += 0.25;
                    llShout(ll_channel, "depositBlood2");
                    if(currentBlood > totalBlood)
                        currentBlood = totalBlood;
                }
            }
            else
                llOwnerSay("BARREL FULL!!");
            DepositMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.10 liter"){
            if(currentBlood != totalBlood){
                if(currentBlood < totalBlood){
                    currentBlood += 0.25;
                    llShout(ll_channel, "depositBlood2");
                    if(currentBlood > totalBlood)
                        currentBlood = totalBlood;
                }
            }
            else
                llOwnerSay("BARREL FULL!!");
            DepositMenu(id);
            updateTimeDisp();
        }
    
        else if (message == "*1 liter"){
            //
        }
        else if (message == "*0.50 liter"){
            //
        }
        else if (message == "*0.25 liter"){
            //
        }
        else if (message == "*0.10 liter"){
            //
        }
        else if (message == "Access")
            accessMenu(id);
        else if (message == "Settings")
            settingsMenu(id);
        else if (message == "Textures")
            texturesMenu(id);
/*     NOTE    
        else if (message == "RESET")
            llResetScript();
*/
        else if (message == "Group"){
            Group_Only      = TRUE;
            Owner_Only      = FALSE;
            Public_Access   = FALSE;
            llSetObjectName("");
            llOwnerSay("Group mode has been set!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "Private"){
            Group_Only      = FALSE;
            Owner_Only      = TRUE;
            Public_Access   = FALSE;
            llSetObjectName("");
            llOwnerSay("Private mode has been set!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "Public"){
            Group_Only      = FALSE;
            Owner_Only      = FALSE;
            Public_Access   = TRUE;
            llSetObjectName("");
            llOwnerSay("Public mode has been set!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "texture1"){
            texture1_enabled = TRUE;
            texture2_enabled = FALSE;
            texture3_enabled = FALSE;
            llSetLinkTexture(LINK_THIS, "Barrel1_Basecolor", ALL_SIDES); //FIX change it
            llSetObjectName("");
            llOwnerSay("Barrel Texture Changed!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "texture2"){
            texture1_enabled = FALSE;
            texture2_enabled = TRUE;
            texture3_enabled = FALSE;
            llSetLinkTexture(LINK_THIS, "Barrel2_Basecolor", ALL_SIDES); //FIX change it
            llSetObjectName("");
            llOwnerSay("Barrel Texture Changed!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else if (message == "texture3"){
            texture1_enabled = FALSE;
            texture2_enabled = FALSE;
            texture3_enabled = TRUE;
            llSetLinkTexture(LINK_THIS, "Barrel3_Basecolor", ALL_SIDES); //FIX change it
            llSetObjectName("");
            llOwnerSay("Barrel Texture Changed!");
            llSetObjectName(origName);
            updateTimeDisp();
            settingsMenu(id);
        }
        else
            menu(id);

        /* if (channel == ll_channel){
            if(message == "depositBlood"){
                if(DEBUG)
                    llOwnerSay("HEARD: depositBlood");
            }
            else if (message == "withdrawBlood"){
                if(DEBUG)
                    llOwnerSay("HEARD: withdrawBlood");
            }
        } */
    }
}

state depositBlood
{
    state_entry()
    {
        llListen(ll_channel, "", "", "");
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(id);
        if (id == owner)
            DepositMenu(id);
        else if (Group_Only){
            if (sameGroup)
                DepositMenu(id);
            else{
                llSetObjectName("");
                llInstantMessage(id, "SORRY YOU ARE NOT IN SAMEGROUP!");
                llSetObjectName(origName);
            }
        }
        else if (Owner_Only){
            if(id == owner)
                DepositMenu(id);
            else{
                llSetObjectName("");
                llInstantMessage(id, "SORRY YOU ARE NOT THE OWNER!");
                llSetObjectName(origName);
            }
        }
        else if (Public_Access)
            DepositMenu(id);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "1"){
            if(currentBlood != totalBlood){
                if(currentBlood < totalBlood){
                    currentBlood += 1.0;
                    llShout(ll_channel, "depositBlood1");
                    if(currentBlood > totalBlood)
                        currentBlood = totalBlood;
                }
            }
            else
                llOwnerSay("BARREL FULL!!");
            DepositMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.25"){
            if(currentBlood != totalBlood){
                if(currentBlood < totalBlood){
                    currentBlood += 0.25;
                    llShout(ll_channel, "depositBlood2");
                    if(currentBlood > totalBlood)
                        currentBlood = totalBlood;
                }
            }
            else
                llOwnerSay("BARREL FULL!!");
            DepositMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.10"){
            if(currentBlood != totalBlood){
                if(currentBlood < totalBlood){
                    currentBlood += 0.10;
                    llShout(ll_channel, "depositBlood3");
                    if(currentBlood > totalBlood)
                        currentBlood = totalBlood;
                }
            }
            else
                llOwnerSay("BARREL FULL!!");
            DepositMenu(id);
            updateTimeDisp();
        }
        else if (message == "Done")
            state default;
        else
            state default;
        if (channel == ll_channel){
            if(message == "depositBlood"){
                if(DEBUG)
                    llOwnerSay("HEARD: depositBlood");
                //FIXME
            }
        }
    }
}

state withdrawBlood
{
    state_entry()
    {
        llListen(ll_channel, "", "", "");
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(id);
        if (id == owner)
            WithdrawMenu(id);
        else if (Group_Only){
            if (sameGroup)
                WithdrawMenu(id);
            else{
                llSetObjectName("");
                llInstantMessage(id, "SORRY YOU ARE NOT IN SAMEGROUP!");
                llSetObjectName(origName);
            }
        }
        else if (Owner_Only){
            if(id == owner)
                WithdrawMenu(id);
            else{
                llSetObjectName("");
                llInstantMessage(id, "SORRY YOU ARE NOT THE OWNER!");
                llSetObjectName(origName);
            }
        }
        else if (Public_Access)
            WithdrawMenu(id);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "1"){
            if(currentBlood == 0)
                isEMPTY = TRUE;
            else
                isEMPTY = FALSE;
            if(currentBlood <= totalBlood){
                if(!isEMPTY){
                    currentBlood -= 1.0;
                    llShout(ll_channel, "withdrawBlood1");
                }
                else
                    llOwnerSay("EMPTY");
            }
            WithdrawMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.25"){
            if(currentBlood == 0)
                isEMPTY = TRUE;
            else
                isEMPTY = FALSE;
            if(currentBlood <= totalBlood){
                if(!isEMPTY){
                    currentBlood -= 0.25;
                    llShout(ll_channel, "withdrawBlood2");
                }
                else
                    llOwnerSay("EMPTY");
            }
            WithdrawMenu(id);
            updateTimeDisp();
        }
        else if (message == "0.10"){
            if(currentBlood == 0)
                isEMPTY = TRUE;
            else
                isEMPTY = FALSE;
            if(currentBlood <= totalBlood){
                if(!isEMPTY){
                    currentBlood -= 0.10;
                    llShout(ll_channel, "withdrawBlood3");
                }
                else
                    llOwnerSay("EMPTY");
            }
            WithdrawMenu(id);
            updateTimeDisp();
        }
        else if (message == "Done")
            state default;
        else
            state default;
        if (channel == ll_channel){
            if (message == "withdrawBlood"){
                if(DEBUG)
                    llOwnerSay("HEARD: withdrawBlood");
                //FIXME
            }
        }
    }
}