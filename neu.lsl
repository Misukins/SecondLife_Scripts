default
{
    state_entry()
    {
        list keys = llGetAgentList(AGENT_LIST_REGION, []);
        integer numberOfKeys = llGetListLength(keys);
        vector currentPos = llGetPos();
        list newkeys;
        key thisAvKey;
        integer i;

        for (i = 0; i < numberOfKeys; ++i){
            thisAvKey = llList2Key(keys,i);
            newkeys += [llRound(llVecDist(currentPos, llList2Vector(llGetObjectDetails(thisAvKey, [OBJECT_POS]), 0))), thisAvKey];
        }
        newkeys = llListSort(newkeys, 2, FALSE);
        for (i = 0; i < (numberOfKeys * 2); i += 2){
            llSetText(llGetDisplayName(llList2Key(newkeys, i+1)) +" ["+ (string) llList2Integer(newkeys, i) + "m]" <0.000, 0.528, 0.528> 1.0);
        }
    }
}