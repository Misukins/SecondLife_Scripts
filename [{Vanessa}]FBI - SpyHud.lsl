key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";
key AvatarKey;

integer listener;
integer menuchannel;
integer agentTotal;
integer targetIndex = -1;
integer objChan;
integer interval = 60;
integer lsn;
integer maxDialogButtons = 10;
integer maxDialogStringLength = 24;
integer page;
integer pageLen;
integer minPage;
integer maxPage;
integer ScannerOn = FALSE;
integer ScriptOn  = FALSE;

float _volume = 0.3;

string author   = "][Vanessa][";
string project  = "Spy Scanner";
string version  = "Version 3.0";
string copy     = "(c)Vanessa (meljonna Resident)";
string objOwner;

list agentKeys;
list agentNames;
list controls;
list menuControls = ["←", "→", "▼", "▲"];

menu(key id)
{
    if ((ScannerOn == FALSE) && (ScriptOn == FALSE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "□ Scanner", "□ Scripts", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == FALSE) && (ScriptOn == TRUE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "□ Scanner", "■ Scripts", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == TRUE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "■ Scanner", "■ Scripts", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == FALSE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "■ Scanner", "□ Scripts", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
}

StartSniffing(){
    integer i = 1;
    for (; i <= 65; ++i)
        llListen(i, "", "", "");
}

StopSniffing(){
    //TODO - 
    llSetText("",<1,1,1>,1);
}

cbcDisplayPage(){
    llListenControl(lsn, TRUE);
    llSetTimerEvent(interval);
    string txt;
    txt += "Agents: " + (string)agentTotal + "\n";
    txt += "Page (" + (string)(1 + page) + " / " + (string)(1 + maxPage) + ")\n";
    integer startIndex = page * pageLen;
    integer endIndex = startIndex + pageLen - 1;
    if (endIndex >= agentTotal) {
        endIndex = agentTotal - 1;
    }

    list aviBuffer = llList2List(agentNames, startIndex, endIndex);
    endIndex = endIndex % pageLen;
    endIndex += llGetListLength(controls) % 3;
    list avi;
    while (0 <= endIndex - 2) {
        avi += llList2List(aviBuffer, endIndex - 2, endIndex);
        endIndex = endIndex - 3;
    }

    if (-1 < endIndex && endIndex < 2) {
        avi += llList2List(aviBuffer, 0, endIndex);
    }
    llDialog(objOwner, txt, controls + avi, objChan);
}

string cbcAgentName(string agentKey)
{
    string agentName = llKey2Name(agentKey);
    integer resident = llSubStringIndex(agentName, " Resident");
    if (~resident) {
        agentName = llGetSubString(agentName, 0, resident - 1);
    }
    return agentName;
}

string cbcAgentProfile(string agentKey)
{
    return "secondlife:///app/agent/" + agentKey + "/about";
}

list attPoints =
[
    "",//0
    "Chest",//1
    "Skull",//2
    "L Shoulder",//3
    "R Shoulder",//4
    "L Hand",//5
    "R Hand",//6
    "L Foot",//7
    "R Foot",//8
    "Spine",//9
    "Pelvis",//10
    "Mouth",//11
    "Chin",//12
    "L Ear",//13
    "R Ear",//14
    "L Eye",//15
    "R Eye",//16
    "Nose",//17
    "R Upper Arm",//18
    "R Lower Arm",//19
    "L Upper Arm",//20
    "L Lower Arm",//21
    "R Hip",//22
    "R Upper Leg",//23
    "R Lower Leg",//24
    "L Hip",//25
    "L Upper Leg",//26
    "L Lower Leg",//27
    "Stomach",//28
    "L Pec",//29
    "R Pec",//30
    "",//31
    "",//32
    "",//33
    "",//34
    "",//35
    "",//36
    "",//37
    "",//38
    "Neck",//39
    "Avatar Center",//40
    "L Ring Finger",//41
    "R Ring Finger",//42
    "Tail Base",//43
    "Tail Tip",//44
    "L Wing ",//45
    "R Wing",//46
    "Jaw",//47
    "Alt L Ear",//48
    "Alt R Ear",//49
    "Alt L Eye",//50
    "Alt R Eye",//51
    "Tongue",//52
    "Groin",//53
    "L Hind Foot",//54
    "R Hind Foot"//55
];

string cbcRound(float fNumber)
{
    integer precision = 2;
    string sNumber = (string)fNumber;
    integer sLength = llSubStringIndex(sNumber, ".") + precision;\
    sNumber = llGetSubString(sNumber, 0, sLength);
    return sNumber;
}

init(){
    llPreloadSound(_sound_on);
    llPreloadSound(_sound_off);
    llSetObjectDesc(copy);
    llSetObjectName((string)author + (string)project + " - " + (string)version + ".");
    llSetTimerEvent(0);
    llSetText("",<1,1,1>,1);
    ScannerOn = FALSE;
    ScriptOn  = FALSE;
}

default
{
    state_entry(){
        init();
    }

    touch_start(integer total_number){
        menu(llGetOwner());
    }

    listen(integer channel, string name, key id, string message){
        if (message == "▼")
            return;
        else if ((message == "□ Scanner") || (message == "■ Scanner")){
            if (!ScannerOn){
                //TODO - 
                StartSniffing();
                llOwnerSay("Listen Scanner is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
            }
            else{
                //TODO - 
                StopSniffing();
                llOwnerSay("Listen Scanner is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
            }
            ScannerOn = !ScannerOn;
        }
        else if ((message == "□ Scripts") || (message == "■ Scripts")){
            if (!ScriptOn){
                //TODO - 
                llSetTimerEvent(1);
                llOwnerSay("Script Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
            }
            else{
                //TODO - 
                llSetTimerEvent(0);
                llOwnerSay("Script Counter is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
            }
            ScriptOn = !ScriptOn;
        }
        else if (message == "√ SpyAvatar"){
            //TODO - 
            return;
        }

        if (ScannerOn){
            if(channel != menuchannel){
                string object_name = llGetOwnerKey(id);
                list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
                llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
            }
        }
    }

    timer()
    {
        if (ScriptOn){
            vector color;
            float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
            integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
            if(time<=.4)
                color=<0,1,0>;
            else if (time>.4 && time <=.9)
                color=<1,1,0>;
            else if (time>.9 && time <= 1.5)
                    color = <1,0,0>;
            else
                color =<0.514, 0.000, 0.514>;
            llSetText("Scripts:"+(string)count+"\n"+"Scripts Time:"+((string)time),color,1);
        }
        else
            llSetTimerEvent(0);
    }
}
