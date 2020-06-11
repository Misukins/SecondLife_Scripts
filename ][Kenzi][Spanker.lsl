string objectname;

integer chan;
integer hand;

integer _whisper         = FALSE;
integer _say             = TRUE;
integer _instant_message = FALSE;
integer public           = TRUE;
integer len;
integer sounds = 0;

list main_admin_buttons =   [ "Spank!", "Access", "Chatmode", "Close" ];
list main_chatmode_buttons  = [ "Say", "Whisper", "IM", "Back", "Close"];
list soundnames;

float volume = 1.0;

menu(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llListenRemove( hand );
    chan = llRound(llFrand(99999)+10);
    hand = llListen(chan, "", id, "");
    if ( id == llGetOwner())
        llDialog(id, (string)owner_name + "'s Ass Menu\nWhat do you want to do with my ass " + (string)name + "?", main_admin_buttons, chan);
}

spank(key id){

    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list username = llParseString2List(llGetDisplayName(id), [""], []);
    string origName = llGetObjectName();
    llSetObjectName("");
    if (id == llGetOwner()){
        if (_whisper)
            llWhisper(0, (string)owner_name + " spanks their own ass!");
        else if (_say)
            llSay(0, (string)owner_name + " spanks their own ass!");
        else if (_instant_message){
            llInstantMessage(llGetOwner(), "Hey " + (string)owner_name + " just spanked your own ass?!?");
        }
    }
    else{
        
        if (_whisper)
            llWhisper(0, (string)username + " spanks " + (string)owner_name + "'s ass!");
        else if (_say)
            llSay(0, (string)username + " spanks " + (string)owner_name + "'s ass!");
        else if (_instant_message){
            llInstantMessage(llGetOwner(), (string)username + " spanked your ass!");
            llInstantMessage(id, "You spanked " + (string)owner_name + "'s ass!.");

        }
    }
    llPlaySound(llList2String(llListRandomize(soundnames,1),0),0.7);
    llSetObjectName(origName);

}

LoadSounds()
{
    soundnames = [];
    sounds = llGetInventoryNumber( INVENTORY_SOUND );
    integer n;
    for ( n=0; n < sounds; ++n )
        soundnames += llGetInventoryName( INVENTORY_SOUND, n );
}

/*
init() 
{
    len =llGetListLength(sounds);
    integer n;
    for(n = 0;n < len;++n)
        llPreloadSound(llList2String(soundnames,n));
    LoadSounds();
}
*/

default
{
    on_rez(integer _code)
    {
        llResetScript();
    }
    
    state_entry()
    {
        LoadSounds();
        if ( sounds < 0 )
            llOwnerSay("No sounds.");
    }
    
    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
            llResetScript();
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }
    
    touch_start(integer total_number)
    {
        key toucher_key = llDetectedKey(0);
        list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
        list username = llParseString2List(llGetDisplayName(toucher_key), [""], []);
        string origName = llGetObjectName();
        if (toucher_key == llGetOwner())
            menu(toucher_key);
        else{
            if (public){
                llSetObjectName("");
                llOwnerSay((string)username + " touched your ass. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                llSetObjectName(origName);
                spank(toucher_key);
            }
            else{
                llSetObjectName("");
                llOwnerSay("!DENIED! " + (string)username + " touched your breasts. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                llSetObjectName(origName);
            }
        }
    }
    
    listen(integer channel, string name, key id, string str)
    {
        list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
        list username = llParseString2List(llGetDisplayName(id), [""], []);
        string origName = llGetObjectName();
        if ( str == "Close")
            return;
        else if ( str == "Back")
            menu(id);
        else if ( str == "Access" )
        {
            if (!public)
            {
                public = !public;
                llOwnerSay("Access: Public on!");
            }
            else
            {
                public = !public;
                llOwnerSay("Access: Public off!");
            }
        }
        else if ( str == "Chatmode" )
            llDialog(id, "\nPlease select an option:", main_chatmode_buttons, channel);
        else if ( str == "Say" )
        {
            _whisper         = FALSE;
            _say             = TRUE;
            _instant_message = FALSE;
            llOwnerSay("Chatmode: Say on!");
        }
        else if ( str == "Whisper" )
        {
            _whisper         = TRUE;
            _say             = FALSE;
            _instant_message = FALSE;
            llOwnerSay("Chatmode: Whisper on!");
        }
        else if ( str == "IM" )
        {
            _whisper         = FALSE;
            _say             = FALSE;
            _instant_message = TRUE;
            llOwnerSay("Chatmode: IM on!");
        }
        else if ( str == "Spank!"){
            spank(id);
            menu(id);
        }
    }
}