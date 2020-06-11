integer dlgHandle = -1;
integer dlgChannel;

list avatarList = [];
list avatarUUIDs = [];

/*
1. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR rubs (target) 's cheek with her soft Papi Paddle and whispers, this is just a taste papi. 
2. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR taps (target) 's booty with her Papi Paddle and growls...you wanna say that to me again using a softer tone maybe? 
3. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR  slaps herself with her Papi Paddle and screams, "NO! NO! NO! HELL NO! I will NOT!" 
4. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR waves her Papi Paddle around (target)'s head and giggles ... don't make me send more foot pics please!
5. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR licks her Papi Paddle and pats her fine ass with it, looking at (target) thinking mmm mmm mmm you just do not know what's on my mind! 
6. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR rubs her Papi Paddle over her toes and then rubs it on (target)'s cute face. Get a whiff of my toe jam ha ha ha! 
7. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR pats (target)'s fine ass with her Papi Paddle and says, "MINE, MINE, MINE ... it's ALL MINES!!" 
8. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR rinses her Papi Paddle in the ocean and hopes the next time I slap (target), you get sea crabs for a whole week!
9. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR rubs her Papi Paddle on (target) and looks at it. OMG!!! Now it has bed bugs on it you dirty ho grrrrrr =P
10. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR slaps (target) upside the head with her Papi Paddle and screams, "NO! YOU ARE NOT MY PAPI FAKER! Go pick on someone smaller than you for a change cuz I'll beat the stupid out you today. " 
11. Cђὗłᾄᾄ کօکքօɨʟêɖ ℳἷXmᾄSƬêR picks up her Papi Paddle and looks at (target) angrily, then smiles. It's OK, I'm good good. I love you papi ... I'ma behave ... giggles.

                llSay(0, llGetDisplayName(llGetOwner()) + " rubs " + llGetDisplayName(targetKey) + "'s cheek with her soft Papi Paddle and whispers, this is just a taste papi.");
                llSay(0, llGetDisplayName(llGetOwner()) + " taps " + llGetDisplayName(targetKey) + "'s booty with her Papi Paddle and growls...you wanna say that to me again using a softer tone maybe? ");
                llSay(0, llGetDisplayName(llGetOwner()) + " slaps herself with her Papi Paddle and screams, \"NO! NO! NO! HELL NO! I will NOT!\"");
                llSay(0, llGetDisplayName(llGetOwner()) + " waves her Papi Paddle around " + llGetDisplayName(targetKey) + "'s head and giggles ... don't make me send more foot pics please!");
                llSay(0, llGetDisplayName(llGetOwner()) + " licks her Papi Paddle and pats her fine ass with it, looking at " + llGetDisplayName(targetKey) + " thinking mmm mmm mmm you just do not know what's on my mind!");
                llSay(0, llGetDisplayName(llGetOwner()) + " rubs her Papi Paddle over her toes and then rubs it on " + llGetDisplayName(targetKey) + "'s cute face. Get a whiff of my toe jam ha ha ha!");
                llSay(0, llGetDisplayName(llGetOwner()) + " pats " + llGetDisplayName(targetKey) + "'s fine ass with her Papi Paddle and says, \"MINE, MINE, MINE ... it's ALL MINES!!\"");
                llSay(0, llGetDisplayName(llGetOwner()) + " rinses her Papi Paddle in the ocean and hopes the next time I slap " + llGetDisplayName(targetKey) + ", you get sea crabs for a whole week!");
                llSay(0, llGetDisplayName(llGetOwner()) + " rubs her Papi Paddle on  " + llGetDisplayName(targetKey) + " and looks at it. OMG!!! Now it has bed bugs on it you dirty ho grrrrrr =P");
                llSay(0, llGetDisplayName(llGetOwner()) + " slaps " + llGetDisplayName(targetKey) + " upside the head with her Papi Paddle and screams, \"NO! YOU ARE NOT MY PAPI FAKER! Go pick on someone smaller than you for a change cuz I'll beat the stupid out you today.\"");
                llSay(0, llGetDisplayName(llGetOwner()) + " picks up her Papi Paddle and looks at " + llGetDisplayName(targetKey) + " angrily, then smiles. It's OK, I'm good good. I love you papi ... I'ma behave ... giggles.");
*/

reset(){
    string origName = llGetObjectName();
    llSetTimerEvent(0.0);
    llListenRemove(dlgHandle);
    dlgHandle = -1;
    llSetObjectName(origName);
}

default
{
    state_entry()
    {
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        //llOwnerSay("("+llGetScriptName()+": "+(string)llGetFreeMemory()+" bytes free.)");
    }

    attach(key attached)
    {
        if(attached != NULL_KEY){
            llResetScript();
        }
    }

    touch_start(integer tnum)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner())
            state Scan;
    }
}

state Scan
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 20.0, PI);
    }
    
    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llDetectedName(i)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
        }
        if (llGetListLength(avatarList) > 0)
          state Dialog;
    }
}

state Dialog
{
    state_entry()
    {
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                string origName = llGetObjectName();
                list targetName = [];
                key targetKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                llSay(0, llGetDisplayName(llGetOwner()) + " taps " + llGetDisplayName(targetKey) + "'s booty with her Papi Paddle and growls...you wanna say that to me again using a softer tone maybe? ");
            }
            reset();
            state default;
        }
    }
    
    timer()
    {
        reset();
        state default;
    }
}
