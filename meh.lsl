key owner;

default
{
    state_entry()
    {
        owner = llGetOwner();
        llListen(-156535255,"","","");
        llSetTexture("HP00",ALL_SIDES);
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        list temp = llCSV2List(msg);
        integer HP;
        // kinda security check if owner matchs and item needs to update
        if((llList2Key(temp,0) == owner) && (llList2String(temp,1) == "UPDATE"))
            HP = (integer)llList2Integer(temp,2);
        // if previous statement failed because its conditions didn't match, script better returns here
        else
            return;
        // first statement seems passed. script can continue with validatin HP
        if(HP == 0)
            llSetTexture("HP00",ALL_SIDES);
        else if(HP >= 1 && HP <= 10)
            llSetTexture("HP01",ALL_SIDES);
        else if(HP >= 11 && HP <= 20)
            llSetTexture("HP02",ALL_SIDES);
        else if(HP >= 21 && HP <= 30)
            llSetTexture("HP03",ALL_SIDES);
        else if(HP >= 31 && HP <= 40)
            llSetTexture("HP04",ALL_SIDES);
        else if(HP >= 41 && HP <= 50)
            llSetTexture("HP05",ALL_SIDES);
        else if(HP >= 51 && HP <= 60)
            llSetTexture("HP06",ALL_SIDES);
        else if(HP >= 61 && HP <= 70)
            llSetTexture("HP07",ALL_SIDES);
        else if(HP >= 71 && HP <= 80)
            llSetTexture("HP08",ALL_SIDES);
        else if(HP >= 81 && HP <= 90)
            llSetTexture("HP09",ALL_SIDES);
        else if(HP >= 91 && HP <= 100)
            llSetTexture("HP10",ALL_SIDES);
        // if none of the previous statements passed, something seems to went wrong. 
        // especially on development it's nice to know about such cases
        else
            llOwnerSay("Something went wrong! HP above 100 or below 0 somehow");
    }
}