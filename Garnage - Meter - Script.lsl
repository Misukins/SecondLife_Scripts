//listener handlers so that you aren't opening redundant listens
integer syslisten;
integer dynlisten;

//generates unique channel for a given user
//NOTE this wont work if you add weapons if not then this is useless
integer DynamicChannel(string id) 
{
    integer dyn;
    dyn = (integer)("0x" + llGetSubString((string)id,0,7));
    return dyn;
}

string csName = "[CARNAGE v8.6.3]";
integer chan = 4;
string customTitle = "Vampire";
key user;
integer deathStatus = 0;
integer hudStatus = 1;
string statusText = "COMBAT+RP";
vector color = <1, 1, 1>;

//NOTE AMY EDIT START
integer health          = 500;
integer healthMax       = 500;
integer mana            = 100;
integer manaMax         = 100;
integer resist          = 10;
integer llChan          = -458703;

string desc_        = "(c)Amy (meljonna Resident) - ";

vector color_AFK    = <0.876, 0, 0>;
vector color_RP     = <0, 0.876, 0>;
//NOTE AMY EDIT END

setStatusText()
{
    if(!hudStatus)
        llSetText(csName 
            + "\n" + "Health : " + (string)health + "/" + (string)healthMax
            + "\n" + "Mana : " + (string)mana + "/" + (string)manaMax
            + "\n" +  customTitle + "\n" + statusText, color_AFK, 1.0);
    else
        llSetText(csName 
            + "\n" + "Health : " + (string)health + "/" + (string)healthMax
            + "\n" + "Mana : " + (string)mana + "/" + (string)manaMax
            + "\n" +  customTitle + "\n" + statusText, color_RP, 1.0);
}

integer random_chance()
{
    if (llFrand(1.0) < 0.1)
        return TRUE;
    return FALSE;
}

default
{
    state_entry()
    {
        if(llGetAttached())
            llSay(llChan, "meterON");
        llSetObjectDesc(desc_ 
        + (string)health + "/" + (string)healthMax
        + (string)mana + "/" + (string)manaMax
        + ".");
    }

    attach(key attached)
    {
        list owner = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        if(attached == NULL_KEY){
            llSay(0, (string)owner + " has detached their " + (string)csName);
            llSay(llChan, "meterOFF");
        }
        else{
            llSay(llChan, "meterON");
            hudStatus = 0; // = FALSE <<<<
            statusText = "OOC/AFK"; 
            user = llGetOwner(); 
            llRequestPermissions(user, PERMISSION_TRIGGER_ANIMATION); 
            if(syslisten)
                llListenRemove(syslisten);
            syslisten = llListen(chan,"","","");
            if(dynlisten)
                llListenRemove(dynlisten);
            dynlisten = llListen(DynamicChannel(llGetOwner()),"","","");
            setStatusText(); 
            llOwnerSay("Welcome to the " + (string)csName + ". " + "Please type /4help for a list of commands to help you activate and use this system"); 
        }
    }

    /*
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        NOTE! i will change this so you can click on your head for menu.. 
        it will be faster to setup and dont worry
        i will leave chat command to it channel 4 like it is now.

    */
    listen(integer channel, string name, key id, string message)
    {
        if(channel == chan){
            if((id == user) || (llGetOwnerKey(id) == user)){
                if(message == "help")
                    llOwnerSay("Command for this System are typed onto channel " + (string)chan + " and are as follows : " + "\n" +  "1. To activate the system type : /4on" + "\n" + "2. To deactivate the system type : /4off" + "\n" + "3. To change your Overhead Text color type : /4color (vector colour) so for example you might type..../4color <1,0,0>....which would set the overhead text to red." + "4. Hud On/Off icons switch your status from Combat/RP to OOC/AFK/Sleep" + "5. White fang allow you to bite using click aywhere outside... Red fangs turn them off" + "6. Smoke Icon center of hud under head lets you cast magic..will also cast in first person." + "7. Clicking the rings at bottom of hud will scan area allowing you to teleport and auto follow target...adjusting distance as needed to avoid damage." + "8. Please refer to notecard for more help..Also join the group in the notecard for support by the community..Enjoy - The Source");
                else if(message == "on"){
                    hudStatus = 1;  // = TRUE <<<<
                    statusText = "RP+COMBAT"; 
                    setStatusText(); 
                    llOwnerSay((string)csName + " is now in RP"); 
                }
                else if(message == "suicide"){
                    deathStatus = 1; 
                    llSay(0, (string)llKey2Name(user) + " has died in combat."); 
                    health = 0; 
                    setStatusText(); 
                    state dead;
                }
                else if(message == "off"){
                    hudStatus = 0; // = FALSE <<<<
                    statusText = "OOC/AFK"; 
                    setStatusText(); 
                    llOwnerSay((string)csName + " is now AFK/OOC"); 
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
                else{
                    llOwnerSay("Unknown command please try again"); 
                }
            }
        }
        else if(channel == DynamicChannel(llGetOwner()))
        {
            //incoming messages are in teh format of DamageType,AttackerName,VictimName,SubDamageType
            //it is worth noting that the sword script you sent me does not have a DamageAmount built in so you're on your own if you want some swings to hit harder than others
                    
            //convert the message to a list of params
            list incomingParams = llParseString2List(message,[","],[]);
        
            //extract values
            string damagetype = llList2String(incomingParams,0);
            
            //weird as hell that we're using names here and not uuids but whatever
            string attacker = llList2String(incomingParams,1);
            string victim = llList2String(incomingParams,2);
            
            //subtype
            string subdamagetype = llList2String(incomingParams,3);
            
            //sanity check to make sure we're the one that got hit
            if(llKey2Name( llGetOwner() ) == victim){
                //do damage or whatever here
                if(damagetype == "sword")
                    health -= 10;
                else if(damagetype == "axe")
                    health -= 20;
                else if(damagetype == "great axe")
                    health -= 20;
                else if(damagetype == "bow")
                    health -= 10;
                else if(damagetype == "lance")
                    health -= 20;
                else if(damagetype == "dagger")
                    health -= 20;
                else if(damagetype == "claw") //NOTE for Vampire Claw
                    health -= 35;
                else
                    health -= 5; //NOTE JUST FOR BACKUP...
                llOwnerSay(attacker + " hit you with damage of type " + damagetype + " ( " + subdamagetype + " )");
            }
        }
    }

    collision_start(integer num)
    {
        if(hudStatus == 0)  // = FALSE <<<<
            return;
        if(llDetectedType(0) == AGENT_BY_LEGACY_NAME)
            return;
        integer resistdamage = llRound(llVecMag(llDetectedVel(0))/resist);
        integer damage = llRound(llVecMag(llDetectedVel(0)));
        if(random_chance())
            health -= resistdamage;
        else
            health -= damage;
        setStatusText(); 
        llSetTimerEvent(10); 
        if(health <= 0){
            deathStatus = 1;
            llSay(0, (string)llKey2Name(user) + " has died in combat.");
            health = 0;
            setStatusText();
            state dead;
        }
        
        if(mana <= 0){
            llOwnerSay("out of Mana!");
            mana = 0;
            setStatusText();
        }
    }

    timer()
    {
        if(health < healthMax){
            health += 10; //autoRegen
            if(health > healthMax)
                health = healthMax;
        }
        else if(mana < manaMax){
            mana += 3; //autoRegen
            if(mana > manaMax)
                mana = manaMax;
        }
        setStatusText();
        if(deathStatus == 1){
            llStopAnimation("death");
            llOwnerSay("You have been revived");
        }
    }
}
 
state dead
{
    state_entry()
    {
        llStartAnimation("death");
        llSetTimerEvent(25);
    }

    timer()
    {
        state default;
    }

    state_exit()
    {
        llStopAnimation("death");
    }
}