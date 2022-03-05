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
integer channel;
integer listen_handle;

integer defdist       = TRUE;
integer fivemDist     = FALSE;
integer tenmDist      = FALSE;
integer fifteenmDist  = FALSE;
integer twentyMDist   = FALSE;

string targetName = "";
string objectName = "[{Amy}]Camera Mod v3 - Follower";

list avatarList = [];
list avatarUUIDs = [];
list main_menu = [];
list settings_menu = [];

vector _greenState = <0.000, 0.502, 0.000>;
vector _whiteState = <1.000, 1.000, 1.000>;

integer DEBUG = FALSE;

// ► ◄ ▲ ▼ \\
mainMenu(key id){
  main_menu = ["Follow", "Distance", "▼"];
  //key id == llDetectedKey(0);
  list avatar_name = llParseString2List(llGetDisplayName(id), [""], []);
  channel = llFloor(llFrand(2000000));
  listen_handle = llListen(channel, "", id, "");
  llDialog(id, "Hello " + (string)avatar_name + " Select a an option", main_menu, channel);
}

settingsMenu(key id){
  settings_menu = ["Default", "5 Meters", "10 Meters", "15 Meters", "20 Meters", "◄", "▼"];
  //key id == llDetectedKey(0);
  list avatar_name = llParseString2List(llGetDisplayName(id), [""], []);
  channel = llFloor(llFrand(2000000));
  listen_handle = llListen(channel, "", id, "");
  llDialog(id, "Hello " + (string)avatar_name + " Select a an option\nCurrent Distance :: "+ (string)RANGE +"", settings_menu, channel);
}

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

stopFollowing(string name)
{
  string origName = llGetObjectName();
  targetName = name;
  llTargetRemove(tid);
  llStopMoveToTarget();
  llSetTimerEvent(0.0);
  llSetObjectName(objectName);
  llOwnerSay("No longer following.");
  llInstantMessage(targetKey, "secondlife:///app/agent/" + (string)name + "/about is no longer following you.");
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
  llOwnerSay("Now following "+ targetName +" type /" + (string)CHANNEL + "stop to stop following");
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
  if (llGetListLength(answer)==0){
    if (!announced){
      llSetObjectName(objectName);
      llOwnerSay(targetName + " seems to be out of range.  Waiting for return...");
      llSetObjectName(origName);
    }
    announced = TRUE;
  }
  else {
    announced = FALSE;
    vector targetPos = llList2Vector(answer,0);
    float dist = llVecDist(targetPos,llGetPos());
    if (dist>RANGE){
      tid = llTarget(targetPos,RANGE);
      llMoveToTarget(targetPos,TAU);
    }
  }
}

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

default
{
  state_entry()
  {
    if(DEBUG)
      llOwnerSay("state DEF");
    llSetObjectName(objectName);
    dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
    if(RANGE == 1.5)
      info("Follow Distance has been set to DEFAULT");
    else if(RANGE == 5.0)
      info("Follow Distance has been set to 5 Meters");
    else if(RANGE == 10.0)
      info("Follow Distance has been set to 10 Meters");
    else if(RANGE == 15.0)
      info("Follow Distance has been set to 15 Meters");
    else
      info("Follow Distance has been set to 20 Meters");
    init();
  }

  changed(integer change)
  {
    if (change & CHANGED_OWNER)
      llResetScript();
  }

  attach(key attached)
  {
    if(attached != NULL_KEY){
      if(RANGE == 1.5)
        info("Follow Distance has been set to DEFAULT");
      else if(RANGE == 5.0)
        info("Follow Distance has been set to 5 Meters");
      else if(RANGE == 10.0)
        info("Follow Distance has been set to 10 Meters");
      else if(RANGE == 15.0)
        info("Follow Distance has been set to 15 Meters");
      else
        info("Follow Distance has been set to 20 Meters");
    }
  }

  touch_start(integer total_number)
  {
    key id = llDetectedKey(0);
    if (id == llGetOwner()){
      if (followOn != TRUE)
        mainMenu(id);
    }
  }

  listen(integer c, string n, key id, string msg)
  {
    if (msg == "Distance")
      settingsMenu(id);
    else if (msg == "Follow"){
      if (followOn != TRUE)
        state Scan;
    }
    else if (msg == "◄")
      mainMenu(id);
    else if (msg == "▼")
      return;
    else if (msg == "Default"){
      defdist       = TRUE;
      fivemDist     = FALSE;
      tenmDist      = FALSE;
      fifteenmDist  = FALSE;
      twentyMDist   = FALSE;
      RANGE         = 1.5;
      llOwnerSay("Follow Distance has been changed to " + (string)RANGE + ". (DEFAULT)");
      mainMenu(id);
    }
    else if (msg == "5 Meters"){
      defdist       = FALSE;
      fivemDist     = TRUE;
      tenmDist      = FALSE;
      fifteenmDist  = FALSE;
      twentyMDist   = FALSE;
      RANGE         += 3.5;
      llOwnerSay("Follow Distance has been changed to " + (string)RANGE + ". (5Meters)");
      mainMenu(id);
    }
    else if (msg == "10 Meters"){
      defdist       = FALSE;
      fivemDist     = FALSE;
      tenmDist      = TRUE;
      fifteenmDist  = FALSE;
      twentyMDist   = FALSE;
      RANGE         += 8.5;
      llOwnerSay("Follow Distance has been changed to " + (string)RANGE + ". (10Meters)");
      mainMenu(id);
    }
    else if (msg == "15 Meters"){
      defdist       = FALSE;
      fivemDist     = FALSE;
      tenmDist      = FALSE;
      fifteenmDist  = TRUE;
      twentyMDist   = FALSE;
      RANGE         += 13.5;
      llOwnerSay("Follow Distance has been changed to " + (string)RANGE + ". (15Meters)");
      mainMenu(id);
    }
    else if (msg == "20 Meters"){
      defdist       = FALSE;
      fivemDist     = FALSE;
      tenmDist      = FALSE;
      fifteenmDist  = FALSE;
      twentyMDist   = TRUE;
      RANGE         += 18.5;
      llOwnerSay("Follow Distance has been changed to " + (string)RANGE + ". (20Meters)");
      mainMenu(id);
    }

    if(c == CHANNEL){
      if (id == llGetOwner()){
        if (msg == "follow"){
          if (id == llGetOwner())
            state Scan;
        }
      }
    }
    /* else
        startFollowingName(msg); */
  }

  link_message(integer from, integer to, string msg, key id)
  {
    if (msg == "RESET"){
      llOwnerSay("Resetting - Follower Script!");
      llResetScript();
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

  at_target(integer tnum, vector tpos, vector ourpos)
  {
    llTargetRemove(tnum);
    llStopMoveToTarget();
  }
}

state Scan
{
  state_entry()
  {
    if(DEBUG)
      llOwnerSay("state Scan");
    avatarList = [];
    avatarUUIDs = [];
    llSensor("", NULL_KEY, AGENT, 96.0, PI);
  }

  changed(integer change)
  {
      if (change & CHANGED_OWNER)
          llResetScript();
  }

  link_message(integer from, integer to, string msg, key id)
  {
    if (msg == "RESET"){
      llOwnerSay("Resetting - Follower Script!");
      llResetScript();
    }
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
    init();
    if(DEBUG)
      llOwnerSay("state Dialog");
  }

  changed(integer change)
  {
      if (change & CHANGED_OWNER)
          llResetScript();
  }

  touch_start(integer total_number)
  {
    key _id = llDetectedKey(0);
    if (_id == llGetOwner()){
      if (followOn == TRUE)
        stopFollowing(_id);
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
        if(followOn)
          llInstantMessage(targetKey, "secondlife:///app/agent/" + (string)id + "/about is now following you.");
      }
      else if(message == "▼"){
        reset();
        state default;
      }
    }
    else if (~llSubStringIndex(message, "►")){
      gMenuPosition += 10;
      Menu();
    }
    else if (~llSubStringIndex(message, "◄")){
      gMenuPosition -= 10;
      Menu();
    }

    if(channel == CHANNEL){
      if (id == llGetOwner()){
        if (message == "follow"){
          if (id == llGetOwner())
            llOwnerSay("You are already following somebody!");
        }
        else if (message == "stop"){
          if (id == llGetOwner()){
            stopFollowing(id);
            reset();
            state default;
          }
        }
      }
    }
  }

  link_message(integer from, integer to, string msg, key id)
  {
    if (msg == "RESET"){
      llOwnerSay("Resetting - Follower Script!");
      llResetScript();
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