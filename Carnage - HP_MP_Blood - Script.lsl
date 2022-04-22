key id;

integer DEBUG = TRUE;
//integer syslisten;
//integer dynlisten;
integer listenChannel   = -458790;
//integer Channel   = -458791;

string newBlood;
string newEXP;
string newHealth;
string newStamina;
string Float2String (float num, integer places, integer rnd)
{
    if (rnd){
        float f = llPow(10.0, places);
        integer i = llRound(llFabs(num) * f);
        string s = "00000" + (string)i;
        if(num < 0.0)
            return "-" + (string)((integer)(i / f)) + "." + llGetSubString(s, -places, -1);
        return (string)((integer)(i / f)) + "." + llGetSubString(s, -places, -1);
    }
    if (!places)
        return (string)((integer)num);
    if ((places = (places - 7 - (places < 1))) & 0x80000000)
        return llGetSubString((string)num, 0, places);
    return (string)num;
}

updateHealthMeter(key id, integer health)
{
    if(DEBUG)
        llOwnerSay("DEBUG:: " + (string)llGetDisplayName(id) + (string)health);
    if(health <= 0){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 1 && health <= 10){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 11 && health <= 20){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 21 && health <= 30){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 31 && health <= 40){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 41 && health <= 50){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 51 && health <= 60){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 61 && health <= 70){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 71 && health <= 80){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 81 && health <= 90){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
    else if (health >= 91 && health <= 100){
        llSay(listenChannel, "UPDATEHEALTH" + "," + (string)health);
    }
}

updateStaminaMeter(key id, integer mana)
{
    if(DEBUG)
        llOwnerSay("DEBUG:: " + (string)llGetDisplayName(id) + (string)mana);
    if(mana <= 0){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 1 && mana <= 10){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 11 && mana <= 20){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 21 && mana <= 30){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 31 && mana <= 40){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 41 && mana <= 50){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 51 && mana <= 60){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 61 && mana <= 70){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 71 && mana <= 80){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 81 && mana <= 90){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
    else if (mana >= 91 && mana <= 100){
        llSay(listenChannel, "UPDATESTAMINA" + "," + (string)mana);
    }
}

updateBloodMeter(key id, float blood)
{
    if(DEBUG)
        llOwnerSay("DEBUG:: " + (string)llGetDisplayName(id) + (string)Float2String(llRound(blood), 0, FALSE));
    if(blood <= 0){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 0 && blood <= 1){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 1 && blood <= 2){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 2 && blood <= 3){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 3 && blood <= 4){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 4 && blood <= 5){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 5 && blood <= 6){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 6 && blood <= 7){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 7 && blood <= 8){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 8 && blood <= 9){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
    else if (blood >= 9 && blood <= 10){
        llSay(listenChannel, "UPDATEBLOOD" + "," + (string)Float2String(llRound(blood), 0, FALSE));
    }
}

updateEXPMeter(key id, float experience)
{
    if(DEBUG)
        llOwnerSay("DEBUG:: " + (string)llGetDisplayName(id) + (string)llRound(experience));
    if(experience <= 0){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience) , 0, FALSE));
    }
    else if (experience >= 1 && experience <= 10){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 11 && experience <= 20){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 21 && experience <= 30){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 31 && experience <= 40){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 41 && experience <= 50){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 51 && experience <= 60){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 61 && experience <= 70){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 71 && experience <= 80){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 81 && experience <= 90){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
    else if (experience >= 91 && experience <= 100){
        llSay(listenChannel, "UPDATEEXP" + "," + (string)Float2String(llRound(experience), 0, FALSE));
    }
}

default
{
    state_entry()
    {
        id = llGetOwner();
        llListen(listenChannel, "", "", "");
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llListen(listenChannel, "", "", "");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel == listenChannel){
            if(llGetSubString(message, 0, 4) == "UPDATEHEALTH"){
                if(llGetSubString(message, 13, -1) != ""){
                    newHealth = llGetSubString(message, 13, -1);
                    updateHealthMeter(id, (integer)newHealth);
                }
            }
            else if(llGetSubString(message, 0, 4) == "UPDATESTAMINA"){
                if(llGetSubString(message, 14, -1) != ""){
                    newStamina = llGetSubString(message, 14, -1);
                    updateHealthMeter(id, (integer)newStamina);
                }
            }
            else if(llGetSubString(message, 0, 4) == "UPDATEBLOOD"){
                if(llGetSubString(message, 12, -1) != ""){
                    newBlood = llGetSubString(message, 12, -1);
                    updateHealthMeter(id, (integer)newBlood);
                }
            }
            else if(llGetSubString(message, 0, 4) == "UPDATEEXP"){
                if(llGetSubString(message, 10,-1) != ""){
                    newEXP = llGetSubString(message, 10, -1);
                    updateHealthMeter(id, (integer)newEXP);
                }
            }
        }
    }
}

