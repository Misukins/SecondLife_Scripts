key owner;
key _id;

float autoStopTime = 1.5;
float standTime = 40.0;
float timerEventLength = 0.001;

integer listenRelay = 0x80000000;
integer standIndex      = 20;
integer sittingIndex    = 1;
integer sitgroundIndex  = 0;
integer hoverIndex      = 12;
integer flyingIndex     = 11;
integer flyingslowIndex = 10;
integer hoverupIndex    = 9;
integer hoverdownIndex  = 8;
integer waterTreadIndex = 25;
integer swimmingIndex   = 26;
integer swimupIndex     = 27;
integer swimdownIndex   = 28;
integer standingupIndex = 6;
integer curStandIndex   = 0;
integer numStands;
integer curStandAnimIndex = 0;
integer notecardLinesRead;
integer numOverrides;
integer lastAnimIndex = 0;
integer animOverrideOn = TRUE;
integer gotPermission  = FALSE;
integer listener;
integer channel;
integer page;
integer rows = 2;

list buttons;
list main_buttons;
list autoStop = [ 5, 6, 19 ];
list standIndexes = [ 20, 21, 22, 23, 24 ];
list stands = [ "", "", "", "", "" ];
list overrides = [];
list notecardLineKey = [];
list underwaterAnim = [ hoverIndex, flyingIndex, flyingslowIndex, hoverupIndex, hoverdownIndex ];
list underwaterOverride = [ waterTreadIndex, swimmingIndex, swimmingIndex, swimupIndex, swimdownIndex];
list stopAnimState = [ "Sitting", "Sitting on Ground" ];
list stopAnimName  = [ "sit", "sit_ground" ];
list lineNums = [ 45, // 0  Sitting on Ground
                  33, // 1  Sitting
                   1, // 2  Striding
                  17, // 3  Crouching
                   5, // 4  CrouchWalking
                  39, // 5  Soft Landing
                  41, // 6  Standing Up
                  37, // 7  Falling Down
                  19, // 8  Hovering Down
                  15, // 9  Hovering Up
                  43, // 10 FlyingSlow
                   7, // 11 Flying
                  31, // 12 Hovering
                  13, // 13 Jumping
                  35, // 14 PreJumping
                   3, // 15 Running
                  11, // 16 Turning Right
                   9, // 17 Turning Left
                   1, // 18 Walking
                  39, // 19 Landing
                  21, // 20 Standing 1
                  23, // 21 Standing 2
                  25, // 22 Standing 3
                  27, // 23 Standing 4
                  29, // 24 Standing 5
                  47, // 25 Treading Water
                  49, // 26 Swimming
                  51, // 27 Swim up
                  43  // 28 Swim Down
                ];
list animState = ["Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
                  "Soft Landing", "Standing Up", "Falling Down", "Hovering Down", "Hovering Up",
                  "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
                  "Turning Right", "Turning Left", "Walking", "Landing", "Standing" ];
list listReplace(list _source, list _newEntry, integer _index){
    return llListInsertList(llDeleteSubList(_source,_index,_index), _newEntry, _index);
}

string defaultNoteCard = "*Default Anims";
string lastAnimState = "";
string lastAnim = "";
string curStandAnim = "";
string item;
string itemnum;
string message;
string origName;

addbutton(integer i, integer n)
{
    string itemname = llGetInventoryName(INVENTORY_OBJECT,i);
    if (i < n)
        buttons += (string)itemname;
    else
        buttons += " ";
}

addmessage(integer i, integer n)
{
    if (i < n) 
        message += "\n" + (string)(i + 1) + ": " + llGetInventoryName(INVENTORY_OBJECT, i);
}

prepare_menu()
{
    buttons = [];
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    if (page * 3 * rows + 1 >= n) page = (n - 1) / (3 * rows);
    if (page > 0) buttons += "◄"; else buttons += "♡ Stock ♡";
    buttons += "▼";
    if (n > (page + 1) * 3 * rows) buttons += "►"; 
                              else buttons += " ";
    integer k = rows;
    while (k--)
    {
        addbutton(page * 3 * rows + 3 * k    , n);
        addbutton(page * 3 * rows + 3 * k + 1, n);
        addbutton(page * 3 * rows + 3 * k + 2, n);
    }
    if ( n == 0 ){
        llSetObjectName("");
        message = "OUT OF STOCK IT!";
        llSetObjectName(origName);
    }
    else
        message = " ";
    for (k = 0; k < 3 * rows; k++)
        addmessage(page * 3 * rows + k, n);
}

drinksMenu(key _id)
{
    prepare_menu();
    llListenRemove(listener);
    channel = -1000000000 - (integer)(llFrand(1000000000));
    listener = llListen(channel, "", _id, "");
    llDialog(_id, message, buttons, channel);
}

// √ ×
menu(key _id)
{
    if(animOverrideOn)
        main_buttons = [ "AO √", "Drinks", "▼" ];
    else
        main_buttons = [ "AO ×", "Drinks", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(listener);
    channel = llFloor(llFrand(2000000));
    listener = llListen(channel, "", _id, "");
    llDialog(_id, (string)owner_name + "'s Backpack Menu\nChoose an option! " + (string)name + "?", main_buttons, channel);

}

startAnimationList(string csvAnims)
{
    list anims = llCSV2List(csvAnims);
    integer numAnims = llGetListLength(anims);
    integer i;
    for(i=0; i<numAnims; i++)
        llStartAnimation(llList2String(anims,i));
}

stopAnimationList(string csvAnims)
{
    list anims = llCSV2List(csvAnims);
    integer numAnims = llGetListLength(anims);
    integer i;
    for(i=0; i<numAnims; i++)
        llStopAnimation(llList2String(anims,i));
} 

startNewAnimation(string _anim, integer _animIndex, string _state)
{
    if(_anim != lastAnim){
        if(_anim != ""){
            startAnimationList(_anim);
            if(_state != lastAnimState && llListFindList(stopAnimName, [_state]) != -1 ) {
                llStopAnimation( llList2String(stopAnimName, llListFindList(stopAnimName, [_state])) );
            } 
            else if(llListFindList(autoStop, [_animIndex]) != -1 ){
                if(lastAnim != "") {
                    stopAnimationList(lastAnim);
                    lastAnim = "";
                }
                llSleep(autoStopTime);
                stopAnimationList(_anim);
            }
        }
        if(lastAnim != "")
            stopAnimationList(lastAnim);
        lastAnim = _anim;
    }
    lastAnimIndex = _animIndex;
    lastAnimState = _state;
}

loadNoteCard(string _notecard)
{
    integer i;
    if (llGetInventoryKey(_notecard) == NULL_KEY){
        llSetObjectName("");
        llOwnerSay("Notecard '" + _notecard + "' does not exist.");
        llSetObjectName(origName);
        return;
    }
    notecardLinesRead = 0;
    notecardLineKey = [];
    for (i=0; i<numOverrides; i++)
        notecardLineKey += [llGetNotecardLine(_notecard, llList2Integer(lineNums,i))];
}

animOverride()
{
    string  curAnimState = llGetAnimation(llGetOwner());
    integer curAnimIndex;
    integer underwaterAnimIndex;
    vector  curPos;
    if (curAnimState == "CrouchWalking"){
        if (llVecMag(llGetVel()) < .5)
            curAnimState = "Crouching";
    }
    if (curAnimState == lastAnimState)
        return;
    curAnimIndex        = llListFindList(animState, [curAnimState]);
    underwaterAnimIndex = llListFindList(underwaterAnim, [curAnimIndex]);
    curPos              = llGetPos();
    if (curAnimIndex == -1){
        llSetObjectName("");
        llOwnerSay("Unknown animation state '" + curAnimState + "'");
        llSetObjectName(origName);
    }
    else if (curAnimIndex == standIndex){
        startNewAnimation(curStandAnim, curStandAnimIndex, curAnimState);
    }
    else{
        if (underwaterAnimIndex != -1 && llWater(ZERO_VECTOR) > curPos.z)
            curAnimIndex = llList2Integer(underwaterOverride, underwaterAnimIndex);
        startNewAnimation(llList2String(overrides,curAnimIndex), curAnimIndex, curAnimState);
    }
}

initialize()
{
    origName = llGetObjectName();
    loadNoteCard(defaultNoteCard);
    if (animOverrideOn)
        llSetTimerEvent(timerEventLength);
    else
        llSetTimerEvent(0);
    lastAnim = "";
    lastAnimIndex = -1;
    lastAnimState = "";
    gotPermission = FALSE;
    itemnum = "";
    item = "";
}

updateinv()
{
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    list name = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
    llSetObjectName("");
    llOwnerSay("Hey " + (string)name + ", We have " + (string)n + " items on stock.");
    llSetObjectName(origName);
}

default
{
    state_entry()
    {
        integer i;
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
        numStands = llGetListLength(stands);
        numOverrides = llGetListLength(lineNums);
        curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);
        for(i=0; i<numOverrides; i++){
            overrides += [ "" ];
        }
        initialize();
        if (autoStopTime == 0)
            autoStop = [];
        llResetTime();
        updateinv();
    }

    on_rez(integer _code)
    {
        initialize();
    }

    changed(integer change)
    {
        if(change & CHANGED_INVENTORY){
            initialize();
            updateinv();
        }
        if(change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        owner = llGetOwner();
        if(llDetectedKey(0) == llGetOwner())
            menu(owner);
    }
    
    run_time_permissions(integer _parm)
    {
        if(_parm == (PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS)){
            llTakeControls(CONTROL_DOWN|CONTROL_UP|CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|CONTROL_RIGHT
                            |CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT, TRUE, TRUE);
            gotPermission = TRUE;
        }
    }
    
    attach(key _k)
    {
        if (_k != NULL_KEY)
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
    }
    
    listen(integer channel, string name, key _id, string msg)
    {
        string objectname = llGetObjectName();
        if (msg == "▼")
        {
            if (itemnum == "")
                return;
            item = "";
            itemnum = "";
        }
        else if (msg == "◄")
        {
            page--;
            prepare_menu();
            llDialog(_id, message, buttons, channel);
        }
        else if (msg == "►")
        {
            page++;
            prepare_menu();
            llDialog(_id, message, buttons, channel);
        }
        else if (msg == "♡ Stock ♡")
        {
            integer n = llGetInventoryNumber(INVENTORY_OBJECT);
            list name = llParseString2List(llGetDisplayName(_id), [""], []);
            llSetObjectName("");
            llOwnerSay("Hey " + (string)name + ", We have " + (string)n + " items on stock.");
            llSetObjectName(origName);
            drinksMenu(_id);
        }
        else if (msg == "AO ×"){
            llSetTimerEvent(timerEventLength);
            animOverrideOn = TRUE;
            if (gotPermission)
                animOverride();
            llSetObjectName("");
            llOwnerSay(objectname + " AO is online.");
            llSetObjectName(origName);
            menu(_id);
        }
        else if (msg == "AO √"){
            llSetTimerEvent(0);
            animOverrideOn = FALSE;
            startNewAnimation("", -1, lastAnimState);
            llSetObjectName("");
            llOwnerSay(objectname + " AO is offline.");
            llSetObjectName(origName);
            menu(_id);
        }
        else if (msg == "Drinks")
            drinksMenu(_id);
        else if (msg == " ")
            return;
        else
        {
            list name = llParseString2List(llGetDisplayName(_id), [""], []);
            llSetObjectName("");
            llSay(0, "/me " + (string)name + " grabs a " + (string)msg + " from the backpack.");
            llSetObjectName(origName);
            llGiveInventory(_id, msg);
            if (itemnum == "")
                return;
        }
    }
    
    dataserver( key _query_id, string _data )
    {
        integer index = llListFindList( notecardLineKey, [_query_id] );
        if ( _data != EOF && index != -1 ){
            if ( index == curStandAnimIndex )
                curStandAnim = _data;              
            if (animOverrideOn && gotPermission && index == lastAnimIndex){
                integer stopAnim;
                startNewAnimation( _data, lastAnimIndex, lastAnimState );
                if ( _data != "" ){
                    stopAnim = llListFindList( stopAnimState, [ lastAnimState ] );
                    if (stopAnim != -1)
                        llStartAnimation( llList2String(stopAnimName, stopAnim) );
                }
            }
            overrides = listReplace( overrides, [_data], index );
        }
    }
    
    control(key _id, integer _level, integer _edge)
    {
        if(animOverrideOn && gotPermission)
            animOverride();
    }

    timer()
    {
        if(animOverrideOn && gotPermission){
            animOverride();
            if(llGetTime() > standTime){
                curStandIndex = (curStandIndex+1) % numStands;
                curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);
                curStandAnim = llList2String(overrides, curStandAnimIndex);
                if(lastAnimState == "Standing")
                    startNewAnimation(curStandAnim, curStandAnimIndex, lastAnimState);
                llResetTime();
            }
        }
    }
}
