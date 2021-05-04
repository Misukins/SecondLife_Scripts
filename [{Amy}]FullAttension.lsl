/* 

NOTE - this is just stupid

NOTE - NOT COMPELTED YET!!!!

*/

integer random_chance(){
    if (llFrand(1.0) < 0.5)
        return TRUE;
    return FALSE;
}

default
{
    state_entry()
    {
        llListen (0, "", NULL_KEY, "");
    }

    listen(integer ch, string name, key id, string msg){
        if (llSubStringIndex (llToLower (msg), llToLower (TRIGGER)) != -1){
            if (voice_random_chance()){
                llSetObjectName("");
                llOwnerSay("secondlife:///app/agent/" + (string)llDetectedKey(0) + "/about");
                llSetObjectName(origName);
            }
            else{

            }
        }
    }
}
