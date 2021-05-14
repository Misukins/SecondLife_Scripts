integer onState;
integer linkNumberLamp = 2;
integer lampChannel = -77851641;

list onList;

list lampRulesOn = [
    PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 0.800>, 1.0,
    PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
    PRIM_GLOW, ALL_SIDES, 0.3,
    PRIM_POINT_LIGHT, TRUE, <1.000, 1.000, 0.800>, 1.0, 10.0, 0.75
];

list lampRulesOff = [
    PRIM_COLOR, ALL_SIDES, <0.80, 0.80, 0.80>, 1.0,
    PRIM_FULLBRIGHT, ALL_SIDES, FALSE,
    PRIM_GLOW, ALL_SIDES, 0.0,
    PRIM_POINT_LIGHT, FALSE, ZERO_VECTOR, 0.0, 0.0, 0.0
];

string lampCmdOn = "ON";
string lampCmdOff = "OFF";

addToOnList(key id)
{
    if(!~llListFindList(onList, [id])){
        onList += id;
        check();
    }
}

removeFromOnList(key id)
{
    integer index = llListFindList(onList, [id]);
    if(~index){
        onList = llDeleteSubList(onList, index, index);
        check();
    }
}

check()
{
    integer length = llGetListLength(onList);
    integer index;
    while(index < length){
        if(!llGetListLength(llGetObjectDetails(llList2Key(onList, index), [OBJECT_NAME]))){
            onList=llDeleteSubList(onList, index, index);
            length--;
        }
        else{
            index++;
        }
    }
    if(length){
        if(!onState){
            turnOn();
        }
    }
    else{
        if(onState){
            turnOff();
        }
    }
}

turnOn()
{
    onState = TRUE;
    llSetLinkPrimitiveParams(linkNumberLamp, lampRulesOn);
}

turnOff()
{
    onState = FALSE;
    llSetLinkPrimitiveParams(linkNumberLamp, lampRulesOff);
}

default
{
    state_entry()
    {
        turnOff();
        llListen(lampChannel, "", NULL_KEY, "");
        llSetTimerEvent(60.0);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if(llGetOwner() == llGetOwnerKey(id)){
            if(msg == lampCmdOn){
                addToOnList(id);
            }
            else if(msg == lampCmdOff){
                removeFromOnList(id);
            }
        }
    }

    timer()
    {
        check();
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }
}
