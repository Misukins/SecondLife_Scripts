string objectname;

integer chan;
integer hand;

integer _whisper         = FALSE;
integer _say             = TRUE;
integer _instant_message = FALSE;
integer public           = TRUE;

//list main_buttons       =   [ "Pussy lick", "Pussy finger", "Pussy rub", "Clit lick", "Clit suck", "Clit rub", "Slap", "Tickle", "Grab", "", "", "Close" ];
//list main_buttons       =   [ "Spank!", "Close" ];
//list main_admin_buttons =   [ "Pussy lick", "Pussy finger", "Pussy rub", "Clit lick", "Clit suck", "Clit rub", "Slap", "Tickle", "Grab", "Access", "Whisper", "Close" ];
list main_admin_buttons =   [ "Spank!", "Access", "Chatmode", "Close" ];
list main_chatmode_buttons  = [ "Say", "Whisper", "IM", "Back", "Close"];

list list_a_buttons =       [ "SAFE", "Suck", "Twirl", "In/Out", "Tongue tip", "Lips", "Tasting", "Passion", "Sloppy", "Inserting", "Back", "Close"];
list list_b_buttons =       [ "!SAFE","!Massage","!Cum","!Squirt","!G-Spot","!Fast","!Lick","!Gently","!Hard","!Two fingers","Back","Close"];
list list_c_buttons =       [ "*SAFE","*Pinch","*Gets Red","*Squirt","*Grab","*Fast","*Lick","*Gently","*Hard","*Between","Back","Close"];
list list_d_buttons =       [ ",SAFE",",Suck",",Twirl",",Grab",",Tongue tip",",Lips",",Bite",",Passion",",Sloppy",",Inserting","Back","Close"];
list list_e_buttons =       [ "_SAFE","_Pinch","_Spread","_Grab","_Like a cock","_Lips","_Bite","_Passion","_Sloppy","_Inserting","Back","Close"];
list list_f_buttons =       [ "`SAFE","`Pinch","`Gets red","`Squirt","`Tickle","`Fast","`Giggle","`Gently","`Hard","`Fingers","Back","Close"];
list list_g_buttons =       [ ">SAFE",">Grab",">Pussy red",">Rub",">Ass red",">Ass gently",">Cheeks",">Pussy hard",">Ass hard",">Pussy gently","Back","Close"];
list list_h_buttons =       [ "<SAFE","<Grab","<Lick Pussy","<Lick ass","<Giggle","<Ass gently","<Passout","<Pussy","<Ass","<Pussy gently","Back","Close"];
list list_i_buttons =       [ "/SAFE","/Lap","/Wall","/Bed","/Giggle","/Ass gently","/Tongue","/Pussy","/Ass","/Pussy&Ass","Back","Close"];

list sounds = [
"475a3e83-6801-49c6-e7ad-d6386b2ecc29", 
"d59780e8-fcc0-17bd-00a1-77c14520a1e0", 
"41576fdf-a519-787a-1885-210a3229af99", 
"03f9c086-cf50-0f4c-a4d5-7c32284b85ae",
"69c50631-9d17-02cb-050b-42693388f4f6"
];

menu(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llListenRemove( hand );
    chan = llRound(llFrand(99999)+10);
    hand = llListen(chan, "", id, "");
    if ( id == llGetOwner())
        llDialog(id, (string)owner_name + "'s Ass Menu\nWhat do you want to do with my ass " + (string)name + "?", main_admin_buttons, chan);
    //else
    //    llDialog(id, (string)owner_name + "'s Ass Menu\nWhat do you want to do with my ass " + (string)name + "?", main_buttons, chan);
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
    llPlaySound(llList2String(llListRandomize(sounds,1),0),0.7);
    llSetObjectName(origName);

}

default
{
    on_rez( integer _code )
    {
        llResetScript();
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
        if (toucher_key == llGetOwner()){
            //llSetObjectName("");
            //llSay(0, (string)owner_name + " spanks their own ass!");
            //llPlaySound(llList2String(llListRandomize(sounds,1),0),0.7);
            //llSetObjectName(origName);
            menu(toucher_key);
        }
        else{
            if (public){
                llSetObjectName("");
                llOwnerSay((string)username + " touched your ass. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                llSetObjectName(origName);
                spank(toucher_key);
                //menu(toucher_key);
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
        /*
        else if ( str == "Pussy lick" )
            llDialog(id, "\nPlease select an option:", list_a_buttons, channel);
        else if ( str == "Pussy finger" )
            llDialog(id, "\nPlease select an option:", list_b_buttons, channel);
        else if ( str == "Pussy rub" )
            llDialog(id, "\nPlease select an option:", list_c_buttons, channel);
        else if ( str == "Clit lick" )
            llDialog(id, "\nPlease select an option:", list_d_buttons, channel);
        else if ( str == "Clit suck" )
            llDialog(id, "\nPlease select an option:", list_e_buttons, channel);
        else if ( str == "Clit rub" )
            llDialog(id, "\nPlease select an option:", list_f_buttons, channel);
        else if ( str == "Slap" )
            llDialog(id, "\nPlease select an option:", list_g_buttons, channel);
        else if ( str == "Tickle" )
            llDialog(id, "\nPlease select an option:", list_h_buttons, channel);
        else if ( str == "Grab" )
            llDialog(id, "\nPlease select an option:", list_i_buttons, channel);
        //~~~~~~
                //~~~
        else if ( str == "SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Suck")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Twirl")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "In/Out")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Tongue tip")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Lips")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Tasting")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Passion")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Sloppy")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Inserting")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == "!SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Massage")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Cum")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Squirt")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!G-Spot")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Fast")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Lick")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Hard")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "!Two fingers")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == "*SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Pinch")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Gets Red")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Squirt")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Grab")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Fast")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Lick")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Hard")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "*Between")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == ",SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Suck")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Twirl")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Grab")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Tongue tip")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Lips")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Bite")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Passion")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Sloppy")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ",Inserting")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == "_SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Pinch")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Spread")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Grab")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Like a cock")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Lips")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Bite")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Passion")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Sloppy")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "_Inserting")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == "`SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Pinch")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Gets red")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Squirt")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Tickle")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Fast")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Giggle")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Hard")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "`Fingers")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == ">SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Grab")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Pussy red")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Rub")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Ass red")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Ass gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Cheeks")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Pussy hard")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Ass hard")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == ">Pussy gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == "<SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Grab")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Lick Pussy")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Lick ass")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Giggle")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Ass gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Passout")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Pussy")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Ass")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "<Pussy gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~
        else if ( str == "/SAFE")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Lap")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Wall")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Bed")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Giggle")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Ass gently")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Tongue")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Pussy")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Ass")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "/Pussy&Ass")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + "  " + (string)owner_name + "'s ");
            else
                llSay(0, (string)username + "  " + (string)owner_name + "'s ");
            llSetObjectName(origName);
            menu(id);
        }
        */
        //~~~
    }
}