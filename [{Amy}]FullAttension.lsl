/* 
NOTE - this is just stupid
*/

string TRIGGER = "amy you ready";

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
        string origName = llGetObjectName();
        list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
        if (llSubStringIndex (llToLower (msg), llToLower (TRIGGER)) != -1){
            if (random_chance()){
                llSetObjectName("");
                llSay(0, "Yes " + (string)owner_name + " has full attension now!");
                llSetObjectName(origName);
            }
            else{
                llSetObjectName("");
                llSay(0, "No " + (string)owner_name + " dont know who you are?! please remind her.");
                llSetObjectName(origName);
            }
        }
    }
}
