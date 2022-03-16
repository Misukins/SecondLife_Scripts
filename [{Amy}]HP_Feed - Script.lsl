key targetKey;

integer dlgHandle = -1;
integer dlgChannel;
integer listenChannel = 1;
integer announced = FALSE;

string origName = "[{Amy}]-- this will change";
string desc_    = "(c)Amy (meljonna Resident) -";

list avatarList = [];
list avatarUUIDs = [];

integer random_chance(){
    if (llFrand(1.0) < 0.2)
        return TRUE;
    return FALSE;
}

integer DEBUG = TRUE;

/*NOTE
    You may change this time.
    float ONE_WEEK = 604800.0; //Week
    float ONE_DAY  = 86400.0;  //Day
    float ONE_HOUR = 3600.0;   //Hour
    float ONE_HHOUR = 1800.0;  //Half an Hours
    float ONE_MINUTE = 60.0;   //Minute
*/
//float ONE_DAY = 86394.0; //little less than 24hours
float ONE_DAY = 10.0;
float updateInterval = 5.0; //DEFAULT 30SEC

//needs to change
integer health = 100;
integer healthMax = 100;

float totaltime;

vector titleColor = <0.905, 0.686, 0.924>; //will be removed 

reset()
{
    llSetTimerEvent(0.0);
    llListenRemove(dlgHandle);
    dlgHandle = -1;
    llSetObjectName(origName);
}

saveData()
{
    list saveData;
    saveData += llRound(health);
    llSetObjectDesc(desc_ + llDumpList2String(saveData, ","));
}

dispString(string value)
{
    llSetText(value, titleColor, 1); //llSetText = just for DEBUGGING!!!
}

string getTimeString(integer time)
{
    integer days;
    integer hours;
    integer minutes;
    integer seconds;
    days = llRound(time / 86400);
    time = time % 86400;
    hours = (time / 3600);
    time  = time % 3600;
    minutes = time / 60;
    time    = time % 60;
    seconds = time;
    return (string)hours + " hours, " + (string)minutes + " minutes";
}

updateTimeDisp()
{
    dispString(
        "Health: " +(string)health + "/" + (string)healthMax + "\n"
        +"You will die in:\n" 
        + getTimeString(llRound(totaltime))
        +"\nThis is set to 10seconds for testing\nobject text will be removed once im tested this fully!"
        );
}

default
{
    state_entry()
    {
        llSetText("", <0.0, 0.0, 0.0>, 0.0);
        llSetObjectDesc(desc_);
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        llParticleSystem([]);
        llListen(listenChannel, "", llGetOwner(), "");
        if(DEBUG)
            updateTimeDisp();
        llResetTime();
        llSetTimerEvent(updateInterval);
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
        if (id == llGetOwner()){
            llSensor("", NULL_KEY, AGENT, 1.0, PI);
            if (llGetListLength(answer)==0){
                if (!announced){
                state default;
                }
                announced = TRUE;
            }
            else{
                announced = FALSE;
                state Feed;
            }
        }
    }

    no_sensor()
    {
        if(DEBUG)
            llOwnerSay("Did not find anyone");
    }

    sensor(integer num_detected)
    {
        state Feed;
    }

    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
        totaltime -= timeElapsed;
        if (totaltime <= 0){
            health -= 10;
            totaltime = ONE_DAY;
            saveData();
            if(DEBUG)
                updateTimeDisp();
        }
        if(DEBUG)
            updateTimeDisp();

        if(health <= 0)
        {
            state Death;
        }
    }
}

state Feed
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 1.0, PI);
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
            state FeedDialog;
    }

    no_sensor()
    {
        llOwnerSay("Did not find anyone");
        state default;
    }
}

state FeedDialog
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["※Cancel"];
        llDialog(llGetOwner(), "Please select an avatar you want", avatarList, dlgChannel);
        llOwnerSay("You have 30seconds to send this.. or else you have to start over!");
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "※Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                list targetName = [];
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                llSetObjectName("");
                //ACTIONS HERE!!!
                if(random_chance()){
                    if(health != 100){
                        if(health < healthMax){
                            health += 50;
                            if(health > healthMax)
                                health = healthMax;
                        }
                        llOwnerSay("[RESIST]: You bit " + llGetDisplayName(targetKey) + ", you got only half liter's of blood.");
                        state default;
                    }
                    else
                        llOwnerSay("you are full silly!");
                }
                else{
                    if(health != 100){
                        if(health < healthMax){
                            health += 100;
                            if(health > healthMax)
                                health = healthMax;
                        }
                        llOwnerSay("[SUCCESS]: You bit " + llGetDisplayName(targetKey) + ", you got full liter of blood.");
                        state default;
                    }
                    else
                        llOwnerSay("you are full silly!");
                }
                totaltime = ONE_DAY;
                saveData();
            }
            reset();
            state default;
        }
    }

    dataserver(key requested, string data)
    {
        list savedList = llParseString2List(llGetObjectDesc(), [","], []);
        if (llGetListLength(savedList) == 1){
            health = llList2Integer(savedList, 1);
        }
    }

    timer()
    {
        reset();
        state default;
    }
}

state Death
{
    state_entry()
    {
        if(DEBUG)
            llSetText("you are dead.. no what?", <1.0, 0.0, 0.0>, 1.0);
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if (id == llGetOwner()){
            llResetScript();
        }
    }
}
