integer CurrentTempUser2 = 0;
integer chan;

list Users2;

key GetUser;

float ScanAroundM = 30.0;
float RepeatScanTime = 0.1;

integer TurnOn = FALSE;

integer lH = -213645771;          
integer lT;
integer lT2;

ET()
{
    llSetTimerEvent(0.0);
    if(lH == -213645771)
    lH = llListen(chan,"","","");
    lT = (integer)llGetTime() + 120;
        llSetTimerEvent(45);
} 
ET2()
{
   llSetTimerEvent(0.0);
   TurnOn = TRUE;
   lT2 = (integer)llGetTime() + 5;
    llSetTimerEvent(1);
}

integer isUser(string name)
{
    integer i;
    for (i=0;i<llGetListLength(Users2);i++)
    {
        string s = llList2String(Users2,i);  
        if (s==llToLower(name)) return 1;
    }
    return 0;
}
SetupScanner()
{
 llSensorRemove();
 llSensorRepeat("","" , AGENT, ScanAroundM, 2*PI, RepeatScanTime);
}

ListUsers2List(integer user1, key id) {
    integer UserCount2 = llGetListLength(Users2) - 1;
    CurrentTempUser2 = user1;
    if (CurrentTempUser2 == -1) {
       CurrentTempUser2 = UserCount2;
    } else if (CurrentTempUser2 > UserCount2) {
        CurrentTempUser2 = 0;
   } 
if (Users2 == [])
{
 return;
    }
ET();
list Buttons = [];
integer RangeSet = (integer)ScanAroundM;
string title="\n*** Access Scan Database Manager ***\n*** Scan Range Setting: "+(string)RangeSet+"m *** \n\nUser (" + (string)(CurrentTempUser2 + 1) + " of " + (string)(UserCount2 + 1)+ ")\nName:"+llList2String(Users2,CurrentTempUser2);  
Buttons+=["<< Prev","Next >>","Add User","Menu","(A)DataB","Exit"];
llDialog(id,title,Buttons,chan);
 return;
    }

default
{
sensor(integer total_number)
    {
        integer i;
        for (i=0;i<total_number;i++)
        {
            key person  = llDetectedKey(i);
            string name = llToLower(llDetectedName(i));
            key K2N = llToLower(llKey2Name(person));
            if ((isUser(K2N)==0))
            {
            Users2 = llListInsertList(Users2,[(string)K2N],llGetListLength(Users2));
        }
    }
}
no_sensor()
{
llSetTimerEvent(0.0); 
llSensorRemove();
TurnOn = FALSE;
list Buttons = [];
string title="\n*** Access Scan Database Manager.\n\nNo one in Range detected!";
ET();
Buttons+=["Menu","Exit"];
llDialog(GetUser,title,Buttons,chan);
}
  listen(integer channel, string name, key id, string message) 
    {
 if (message == "Add User" && (id == llGetOwner()))
 {
  GetUser = id;
  llMessageLinked(LINK_SET,0,"SET ID",id);
  llSleep(1);
  string SetNewAccess = llList2String(Users2,CurrentTempUser2);
  llMessageLinked(LINK_SET,0,"SCAN ACCESS ADD",SetNewAccess);
  ListUsers2List(CurrentTempUser2,GetUser);
  return;
 }
 if (message == "Next >>" && (id == llGetOwner()))
        {   
       GetUser = id;
       ListUsers2List(CurrentTempUser2 + 1,id);
       return;
        }
     if (message == "<< Prev" && (id == llGetOwner()))
        {   
        GetUser = id;
       ListUsers2List(CurrentTempUser2 - 1,id);
       return;
        }
     if (message == "Menu" && (id == llGetOwner()))
        {   
         GetUser = id;
         llMessageLinked(LINK_SET,0,"MAIN MENU",GetUser);
       return;
        }
      if (message == "(A)DataB" && (id == llGetOwner()))
        { 
        GetUser = id;
         llMessageLinked(LINK_SET,0,"ACCESS DATABASE MENU",GetUser);
       return;
        }
    }
  link_message(integer sender_num,integer num,string str,key id)
    { 
      if (str == "START SCAN AROUND FOR ACCESS")
      {
      chan = (integer)llFrand(1000) + 1000;
      llListenRemove(lH);
       lH = -213645771;
       GetUser = id;
       Users2 = [];
       llOwnerSay("Please Wait... Scan Around Database will be done within 5 Secs...");
       ET2();
       SetupScanner();
      }
      if (str == "GET USER")
     { 
      GetUser = id;
     }
     if (str == "SET SCAN AROUND M")
     { 
      ScanAroundM = (float)num;
     }
      if (str == "RESET WIZARD")
     {
      llResetScript();
     }
}
 timer()
    {
          if(llGetTime() > lT2)
        {
          if (TurnOn)
          {
          TurnOn = FALSE;
          llSensorRemove();
          llSetTimerEvent(0.0); 
          ListUsers2List(CurrentTempUser2,GetUser);
        }
        if(llGetTime() > lT)
        {
            Users2 = [];
            llListenRemove(lH);   
            lH = -213645771;
            llSetTimerEvent(0.0);
        }
    }
  }
}
