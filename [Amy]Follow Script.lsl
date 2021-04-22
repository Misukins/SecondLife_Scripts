key targetKey = NULL_KEY;

float DELAY = 0.5;
float RANGE = 1.5;
float TAU = 1.0;
float LIMIT = 60.0;

integer CHANNEL = 789;
integer lh = 0;
integer tid = 0;
integer announced = FALSE;
integer followOn = FALSE;
integer dlgHandle = -1;
integer dlgChannel;
integer gMenuPosition;

string targetName = "";
string objectName = "][Kenzi][Camera Mod - Follower";

list avatarList = [];
list avatarUUIDs = [];

vector _greenState = <0.000, 0.502, 0.000>;
vector _whiteState = <1.000, 1.000, 1.000>;

integer DEBUG = TRUE;

// ► ◄ ▲ ▼ \\  
Menu()
{
    integer Last;
    list Buttons;
    integer All = llGetListLength(avatarList);
    string origName = llGetObjectName();
    if(gMenuPosition >= 9){
      Buttons += "◄";
      if((All - gMenuPosition) > 10)
        Buttons += "►";
      else
        Last = TRUE;          
    }    
    else if (All > gMenuPosition+9){
      if((All - gMenuPosition) > 10)
        Buttons += "►";
      else
        Last = TRUE;
    }
    else
      Last = TRUE;
    if (All > 0){
      integer b;
      integer len = llGetListLength(Buttons);     
      for(b = gMenuPosition + len + Last - 1 ; (len < 11)&&(b < All); ++b){
          Buttons = Buttons + [llList2String(avatarList,b)];
          len = llGetListLength(Buttons);
      }
    }
    dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
    llSetTimerEvent(30.0);
    Buttons += ["▼"];
    llSetObjectName(objectName);
    llDialog(llGetOwner(), "Please select an avatar you want to follow", Buttons, dlgChannel);
    llSetObjectName(origName);
    llListenRemove(lh);
    lh = llListen(CHANNEL,"",llGetOwner(),"");
}

reset()
{
  llSetTimerEvent(0.0);
  llListenRemove(dlgHandle);
  dlgHandle = -1;
  followOn = FALSE;
  llSetLinkColor(LINK_THIS, _whiteState, ALL_SIDES);
}

init()
{
  llListenRemove(lh);
  lh = llListen(CHANNEL,"",llGetOwner(),"");
}

stopFollowing()
{
  string origName = llGetObjectName();
  llTargetRemove(tid);
  llStopMoveToTarget();
  llSetTimerEvent(0.0);
  llSetObjectName(objectName);
  llOwnerSay("No longer following.");
  llSetObjectName(origName);
}

startFollowingName(string name)
{
  targetName = name;
  llSensor(targetName,NULL_KEY,AGENT,96.0,PI);
}

startFollowingKey(key id)
{
  string origName = llGetObjectName();
  targetKey = id;
  llSetObjectName(objectName);
  llOwnerSay("Now following "+targetName+" type /" + (string)CHANNEL + "stop to stop following");
  llSetObjectName(origName);
  keepFollowing();
  llSetTimerEvent(DELAY);
}

keepFollowing()
{
  llTargetRemove(tid);  
  llStopMoveToTarget();
  list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
  string origName = llGetObjectName();
  if (llGetListLength(answer)==0) {
    if (!announced){
      llSetObjectName(objectName);
      llOwnerSay(targetName+" seems to be out of range.  Waiting for return...");
      llSetObjectName(origName);
    }
    announced = TRUE;
  }
  else {
    announced = FALSE;
    vector targetPos = llList2Vector(answer,0);
    float dist = llVecDist(targetPos,llGetPos());
    if (dist>RANGE) {
      tid = llTarget(targetPos,RANGE);
      if (dist>LIMIT)
        targetPos = llGetPos() + LIMIT * llVecNorm( targetPos - llGetPos() );
      llMoveToTarget(targetPos,TAU);
    }
  }
}

default
{
  state_entry()
  {
    dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
    init();
  }

  changed(integer change)
  {
    if (change & CHANGED_OWNER)
      llResetScript();
  }

  attach(key attached)
  {
    if(attached != NULL_KEY)
      llResetScript();
  }

  on_rez(integer x)
  {
    llResetScript();
  }

  touch_start(integer total_number)
  {
    key id = llDetectedKey(0);
    if (id == llGetOwner()){
      if (followOn != TRUE)
        state Scan;
    }
  }
    
  listen(integer c,string n,key id,string msg)
  {
    if (msg == "off")
      stopFollowing();
    else if (msg == "follow"){
      if (id == llGetOwner())
        state Scan;
    }
    else
      startFollowingName(msg);
  }

  no_sensor()
  {
    string origName = llGetObjectName();
    llSetObjectName(objectName);
    llOwnerSay("Did not find anyone named "+targetName);
    llSetObjectName(origName);
  }

  sensor(integer n)
  {
    startFollowingKey(llDetectedKey(0));
  }

  timer()
  {
    keepFollowing();
  }

  at_target(integer tnum,vector tpos,vector ourpos)
  {
    llTargetRemove(tnum);
    llStopMoveToTarget();  
  }
}

state Scan
{
  state_entry()
  {
    avatarList = [];
    avatarUUIDs = [];
    llSensor("", NULL_KEY, AGENT, 96.0, PI);
  }
  
  sensor(integer num_detected)
  {
    integer i;
    while((i < num_detected) && (i < 64)){
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
    llListenRemove(lh);
    gMenuPosition = 0;
    Menu();
  }

  touch_start(integer total_number)
  {
    key id = llDetectedKey(0);
    if (id == llGetOwner()){
      if (followOn == TRUE)
        stopFollowing();
        reset();
        state default;
    }
  }
  
  listen(integer channel, string name, key id, string message)
  {
    if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
      if (message != "▼"){
        list targetName = [];
        key targetKey;
        targetName += [message];
        string targetID = (key)llList2String(targetName,0);
        targetKey = llName2Key(targetID);
        startFollowingName(message);
        followOn = TRUE;
        llSetLinkColor(LINK_THIS, _greenState, ALL_SIDES);
        llInstantMessage(targetKey, " secondlife:///app/agent/" + (string)id + "/about is now following you");
      }
      else if(message == "▼"){
        reset();
        state default;  
      }
    }
    
    if (message == "off"){
      stopFollowing();
      reset();
      state default;
    }
    else if (~llSubStringIndex(message, "►")){
      gMenuPosition += 10;
      Menu();
    }
    else if (~llSubStringIndex(message, "◄")){
      gMenuPosition -= 10;
      Menu();
    }
  }

  no_sensor()
  {
    string origName = llGetObjectName();
    llSetObjectName(objectName);
    llOwnerSay("Did not find anyone named "+targetName);
    llSetObjectName(origName);
  }

  sensor(integer n)
  {
    startFollowingKey(llDetectedKey(0));
  }
  
  timer()
  {
    keepFollowing();
  }
}