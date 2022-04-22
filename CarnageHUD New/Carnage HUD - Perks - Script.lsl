/*NOTE - UNUSED

key user;

integer listenChannel   = -458790;
integer _chan;
integer hand;
integer attributePoints;

list perk_buttons   = [];

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
        + "Damage: "    + (string)damage + "\n", perk_buttons, _chan);
}

default
{
    state_entry()
    {
        user = llGetOwner();
        llListen(listenChannel, "", "", "");
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key attached)
    {
        if(attached == NULL_KEY){
            //TODO
        }
    }

    touch_start(integer total_number)
    {
        user = llDetectedKey(0);
        if(user == llGetOwner()){
            if(attributePoints != 0)
                doPerksMenu(id);
            else
                llOwnerSay("You have no PerkPoints to use!");
        }
    }

    timer()
    {
        if(attributePoints >= 1)
            state points;
        else
            state default;
    }
}

state points
{
    state_entry()
    {
        llListen(listenChannel, "", "", "");
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key attached)
    {
        if(attached == NULL_KEY){
            //TODO
        }
    }

    touch_start(integer total_number)
    {
        user = llDetectedKey(0);
        if(user == llGetOwner()){
            if(attributePoints != 0)
                doPerksMenu(id);
            else
                llOwnerSay("You have no PerkPoints to use!");
        }
    }
} */