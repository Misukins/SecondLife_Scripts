//Key of the user of the Menu 
key UserID;

//Channel to listen for item the avatar has put in.
integer InputDialogChannel;

//Handle to listen for input
integer InputListenHandle;

list avatarList     = [];
list avatarUUIDs    = [];

integer range = 4096;
integer gMenuPosition;

Menu()
{
    integer Last;
    list Buttons;
    integer All = llGetListLength(avatarList);
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
    llDialog(llGetOwner(), "Please select an avatar you want to send an AdminMessage", Buttons, dlgChannel);
}

default
{
 
    state_entry()
    {
        //F
    }
  
    touch_start(integer num_detected)
    {
        state Dial;

    //Get the UUID of the user that has touched the object
        UserID = llDetectedKey(0);
       
    //Assign the listen to a handle so we can kill it when the user don't respond to the text box
        llListenRemove(InputListenHandle);
        InputListenHandle = llListen(InputDialogChannel, "", "", "");    
      
        llTextBox(UserID, "Please enter...", InputDialogChannel);
    
    }

    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(InputListenHandle);
        llSetTimerEvent(0);
        llOwnerSay("You wrote: " + message);
    }
 
     //Take action if the user did not respond within time    
    timer()
    {
    //Stop timer and listening because the user did not responds within the time given.
    //User could have touched the ignore button, walk or tp away or crashed
        llSetTimerEvent(0);
        llListenRemove(InputListenHandle);

    }   
    
}

state Dial
{
    state_entry()
    {
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, range, PI);
    }

    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llList2String(llParseString2List(llDetectedName(i), [""], []), 0)];
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
        gMenuPosition = 0;
        Menu();
        InputDialogChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            //F state Send;
        }

        if (~llSubStringIndex(message,"►")){
            gMenuPosition += 10;
            Menu();
        }
        else if (~llSubStringIndex(message,"◄")){
            gMenuPosition -= 10;
            Menu();
        }
    }

    timer()
    {
        reset();
        state default;
    }
}

state Send
{
    state_entry()
    {
        
    }

    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == llGetOwner()){
            UserID = llDetectedKey(0);
            llListenRemove(InputListenHandle);
            InputListenHandle = llListen(InputDialogChannel, "", "", "");
            llTextBox(UserID, "Please enter...", InputDialogChannel);
            /*NOTE
            if (message == "Poke"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                string origName = llGetObjectName();
                list targetName = [];
                key ownerKey;
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                ownerKey = llGetOwnerKey(llGetKey());
                llSetObjectName("");
                llInstantMessage(targetKey, llGetDisplayName(llGetOwner()) + " is trying to reach at you and poke you.\nWell hello there " + llGetDisplayName(targetKey) + "!\n I " + llGetDisplayName(llGetOwner()) + " just wanted to say you look amazing <3!\nSay hi to them @ secondlife:///app/agent/" + (string)ownerKey + "/im");
                llOwnerSay("InstantMessage was sent to secondlife:///app/agent/" + (string)targetKey + "/about.");
                llSetObjectName(origName);
                llSleep(.5);
                state default;
                return;
            }
            */
        }

    }
}

