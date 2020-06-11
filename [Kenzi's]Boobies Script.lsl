string objectname;

integer chan;
integer hand;

integer _whisper         = FALSE;
integer _say             = TRUE;
integer _instant_message = FALSE;
integer public           = TRUE;

list main_buttons           = [ "List 1", "List 2", "List 3", "Funny", "Close" ];
list main_admin_buttons     = [ "List 1", "List 2", "List 3", "Funny", "Access", "Chatmode", "Close" ];
list main_chatmode_buttons  = [ "+Say+", "+Whisper+", "+IM+", "Back", "Close"];

list list_a_buttons = [ "Animal", "Bite nipple", "Suck nipple", "Rip bra", "Lick", "Nails", "Twist", "Shiver", "Moan", "Together", "Back", "Close" ];
list list_b_buttons = [ "Vibrator", "Fuck", "Red nipples", "Red boobs", "Slap", "Squeeze", "Excited", "Pull", "Rub", "Twist tongue", "Back", "Close" ];
list list_c_buttons = [ "Scream", "Feather", "Between", "Slow", "Ice", "Chocolate", "Whipped cream", "Kiss boobs", "Kiss nipples", "Tease", "Back", "Close" ];
list list_d_buttons = [ "Worship", "Melons", "Exam", "Motorboat", "Fail", "Back", "Close" ];

menu(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llListenRemove( hand );
    chan = llRound(llFrand(99999)+10);
    hand = llListen(chan, "", id, "");
    if ( id == llGetOwner())
        llDialog(id, (string)owner_name + "'s Boob Menu\nWhat do you want to do with my boobs " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(id, (string)owner_name + "'s Boob Menu\nWhat do you want to do with my boobs " + (string)name + "?", main_buttons, chan);
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
    
    touch_start(integer x)
    {
        key toucher_key = llDetectedKey(0);
        list username = llParseString2List(llGetDisplayName(toucher_key), [""], []);
        string origName = llGetObjectName();
        if (toucher_key == llGetOwner())
            menu(toucher_key);
        else
        {
            if (public)
            {
                llSetObjectName("");
                llOwnerSay((string)username + " touched your breasts. (secondlife:///app/agent/" + (string)toucher_key + "/about)" );
                llSetObjectName(origName);
                menu(toucher_key);
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
        {
            
            llDialog(id, "\nPlease select an option:", main_chatmode_buttons, channel);
            /*if (!_whisper)
            {
                _whisper = !_whisper;
                llOwnerSay("Chatmode: Whisper on!");
            }
            else
            {
                _whisper = !_whisper;
                llOwnerSay("Chatmode: Whisper off!");
            }*/
        }
        else if ( str == "List 1" )
            llDialog(id, "\nPlease select an option:", list_a_buttons, channel);
        else if ( str == "List 2" )
            llDialog(id, "\nPlease select an option:", list_b_buttons, channel);
        else if ( str == "List 3" )
            llDialog(id, "\nPlease select an option:", list_c_buttons, channel);
        else if ( str == "Funny" )
            llDialog(id, "\nPlease select an option:", list_d_buttons, channel);
        else if ( str == "+Say+" )
        {
            _whisper         = FALSE;
            _say             = TRUE;
            _instant_message = FALSE;
            llOwnerSay("Chatmode: Say on!");
        }
        else if ( str == "+Whisper+" )
        {
            _whisper         = TRUE;
            _say             = FALSE;
            _instant_message = FALSE;
            llOwnerSay("Chatmode: Whisper on!");
        }
        else if ( str == "+IM+" )
        {
            _whisper         = FALSE;
            _say             = FALSE;
            _instant_message = TRUE;
            llOwnerSay("Chatmode: IM on!");
        }
        //~~~~~~
        else if ( str == "Animal")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " rips " + (string)owner_name + "'s bra with her teeth biting her nipples like an animal.");
            else if (_say)
                llSay(0, (string)username + " rips " + (string)owner_name + "'s bra with her teeth biting her nipples like an animal.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " rips " + (string)owner_name + "'s bra with her teeth biting her nipples like an animal.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Bite nipple")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " bites " + (string)owner_name + "'s nipple hard, pinning her hands behind her back.");
            else if (_say)
                llSay(0, (string)username + " bites " + (string)owner_name + "'s nipple hard, pinning her hands behind her back.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " bites " + (string)owner_name + "'s nipple hard, pinning her hands behind her back.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Suck nipple")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " bites with " + (string)owner_name + "'s nipple then suckles on it.");
            else if (_say)
                llSay(0, (string)username + " bites with " + (string)owner_name + "'s nipple then suckles on it.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " bites with " + (string)owner_name + "'s nipple then suckles on it.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Rip bra")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " rips " + (string)owner_name + "'s bra exposing her supple breasts.");
            else if (_say)
                llSay(0, (string)username + " rips " + (string)owner_name + "'s bra exposing her supple breasts.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " rips " + (string)owner_name + "'s bra exposing her supple breasts.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Lick")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " licks " + (string)owner_name + "'s nipples gently, squeezing her breast.");
            else if (_say)
                llSay(0, (string)username + " licks " + (string)owner_name + "'s nipples gently, squeezing her breast.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " licks " + (string)owner_name + "'s nipples gently, squeezing her breast.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Nails")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " bites " + (string)owner_name + "'s nipple, running her nails over her supple back, making her arch like a cat.");
            else if (_say)
                llSay(0, (string)username + " bites " + (string)owner_name + "'s nipple, running her nails over her supple back, making her arch like a cat.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " bites " + (string)owner_name + "'s nipple, running her nails over her supple back, making her arch like a cat.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Twist")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " twists " + (string)owner_name + "'s nipples gently, making her beg for more.");
            else if (_say)
                llSay(0, (string)username + " twists " + (string)owner_name + "'s nipples gently, making her beg for more.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " twists " + (string)owner_name + "'s nipples gently, making her beg for more.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Shiver")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " grabs " + (string)owner_name + "'s firm breasts making her shiver.");
            else if (_say)
                llSay(0, (string)username + " grabs " + (string)owner_name + "'s firm breasts making her shiver.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " grabs " + (string)owner_name + "'s firm breasts making her shiver.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Moan")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " grabs " + (string)owner_name + "'s luscious breasts making her moan.");
            else if (_say)
                llSay(0, (string)username + " grabs " + (string)owner_name + "'s luscious breasts making her moan.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " grabs " + (string)owner_name + "'s luscious breasts making her moan.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Together")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " grabs " + (string)owner_name + "'s breasts, pressing them together.");
            else if (_say)
                llSay(0, (string)username + " grabs " + (string)owner_name + "'s breasts, pressing them together.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " grabs " + (string)owner_name + "'s breasts, pressing them together.");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~~~~
        else if ( str == "Vibrator")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " rubs " + (string)owner_name + "'s nipples with a vibrator, making them hard.");
            else if (_say)
                llSay(0, (string)username + " rubs " + (string)owner_name + "'s nipples with a vibrator, making them hard.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " rubs " + (string)owner_name + "'s nipples with a vibrator, making them hard.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Fuck")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " makes " + (string)owner_name + " fuck her pussy with her tits, cumming all over her face.");
            else if (_say)
                llSay(0, (string)username + " makes " + (string)owner_name + " fuck her pussy with her tits, cumming all over her face.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " makes " + (string)owner_name + " fuck her pussy with her tits, cumming all over her face.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Red nipples")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " bites " + (string)owner_name + "'s nipples, making them red.");
            else if (_say)
                llSay(0, (string)username + " bites " + (string)owner_name + "'s nipples, making them red.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " bites " + (string)owner_name + "'s nipples, making them red.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Red boobs")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " bites " + (string)owner_name + "'s breasts, making them red.");
            else if (_say)
                llSay(0, (string)username + " bites " + (string)owner_name + "'s breasts, making them red.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " bites " + (string)owner_name + "'s breasts, making them red.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Slap")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " slaps " + (string)owner_name + "'s tits, making her moan like a whore.");
            else if (_say)
                llSay(0, (string)username + " slaps " + (string)owner_name + "'s tits, making her moan like a whore.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " slaps " + (string)owner_name + "'s tits, making her moan like a whore.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Squeeze")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " squeezes " + (string)owner_name + "'s breasts together and licks them senseless.");
            else if (_say)
                llSay(0, (string)username + " squeezes " + (string)owner_name + "'s breasts together and licks them senseless.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " squeezes " + (string)owner_name + "'s breasts together and licks them senseless.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Excited")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " rubs her breasts over " + (string)owner_name + "'s boobs, getting excited together.");
            else if (_say)
                llSay(0, (string)username + " rubs her breasts over " + (string)owner_name + "'s boobs, getting excited together.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " rubs her breasts over " + (string)owner_name + "'s boobs, getting excited together.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Pull")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " pulls " + (string)owner_name + "'s bra down, exposing her nipples.");
            else if (_say)
                llSay(0, (string)username + " pulls " + (string)owner_name + "'s bra down, exposing her nipples.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " pulls " + (string)owner_name + "'s bra down, exposing her nipples.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Rub")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " rubs " + (string)owner_name + "'s breasts over her bra, exciting her nipples.");
            else if (_say)
                llSay(0, (string)username + " rubs " + (string)owner_name + "'s breasts over her bra, exciting her nipples.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " rubs " + (string)owner_name + "'s breasts over her bra, exciting her nipples.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Twist tongue")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " twists her tongue around " + (string)owner_name + "'s nipples.");
            else if (_say)
                llSay(0, (string)username + " twists her tongue around " + (string)owner_name + "'s nipples.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " twists her tongue around " + (string)owner_name + "'s nipples.");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~~~~
        else if ( str == "Scream")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " sucks " + (string)owner_name + "'s nipples so hard it makes her scream.");
            else if (_say)
                llSay(0, (string)username + " sucks " + (string)owner_name + "'s nipples so hard it makes her scream.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " sucks " + (string)owner_name + "'s nipples so hard it makes her scream.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Feather")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " runs a feather over " + (string)owner_name + "'s hard nipples, making her shiver.");
            else if (_say)
                llSay(0, (string)username + " runs a feather over " + (string)owner_name + "'s hard nipples, making her shiver.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " runs a feather over " + (string)owner_name + "'s hard nipples, making her shiver.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Between")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " buries her face between " + (string)owner_name + "'s breasts, kissing and biting them.");
            else if (_say)
                llSay(0, (string)username + " buries her face between " + (string)owner_name + "'s breasts, kissing and biting them.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " buries her face between " + (string)owner_name + "'s breasts, kissing and biting them.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Slow")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " slowly licks " + (string)owner_name + "'s breast, making her way to the nipple, then suckles on it hard.");
            else if (_say)
                llSay(0, (string)username + " slowly licks " + (string)owner_name + "'s breast, making her way to the nipple, then suckles on it hard.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " slowly licks " + (string)owner_name + "'s breast, making her way to the nipple, then suckles on it hard.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Ice")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " rubs an ice cube on " + (string)owner_name + "'s nipple making it hard.");
            else if (_say)
                llSay(0, (string)username + " rubs an ice cube on " + (string)owner_name + "'s nipple making it hard.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " rubs an ice cube on " + (string)owner_name + "'s nipple making it hard.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Chocolate")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " pours chocolate syrup on " + (string)owner_name + "'s breasts and licks them clean.");
            else if (_say)
                llSay(0, (string)username + " pours chocolate syrup on " + (string)owner_name + "'s breasts and licks them clean.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " pours chocolate syrup on " + (string)owner_name + "'s breasts and licks them clean.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Whipped cream")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " puts whipped cream on " + (string)owner_name + "'s nipples and gently licks it off.");
            else if (_say)
                llSay(0, (string)username + " puts whipped cream on " + (string)owner_name + "'s nipples and gently licks it off.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " puts whipped cream on " + (string)owner_name + "'s nipples and gently licks it off.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Kiss boobs")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " kisses " + (string)owner_name + "'s breasts all over.");
            else if (_say)
                llSay(0, (string)username + " kisses " + (string)owner_name + "'s breasts all over.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " kisses " + (string)owner_name + "'s breasts all over.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Kiss nipples")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " kisses " + (string)owner_name + "'s firm nipples.");
            else if (_say)
                llSay(0, (string)username + " kisses " + (string)owner_name + "'s firm nipples.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " kisses " + (string)owner_name + "'s firm nipples.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Tease")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " presses her lips on " + (string)owner_name + "'s nipples, teasing them with her tongue.");
            else if (_say)
                llSay(0, (string)username + " presses her lips on " + (string)owner_name + "'s nipples, teasing them with her tongue.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " presses her lips on " + (string)owner_name + "'s nipples, teasing them with her tongue.");
            llSetObjectName(origName);
            menu(id);
        }
        //~~~~~~
        else if ( str == "Worship")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " bows down and worships " + (string)owner_name + "'s breasts, saying 'I'm not worthy!'");
            else if (_say)
                llSay(0, (string)username + " bows down and worships " + (string)owner_name + "'s breasts, saying 'I'm not worthy!'");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " bows down and worships " + (string)owner_name + "'s breasts, saying 'I'm not worthy!'");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Melons")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " ogles " + (string)owner_name + "'s breasts, I'm no expert, but those melons look ripe.");
            else if (_say)
                llSay(0, (string)username + " ogles " + (string)owner_name + "'s breasts, I'm no expert, but those melons look ripe.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " ogles " + (string)owner_name + "'s breasts, I'm no expert, but those melons look ripe.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Exam")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " gives " + (string)owner_name + " a thorough breast exam with her hands, and just to be sure she asks a second opinion from her tongue.");
            else if (_say)
                llSay(0, (string)username + " gives " + (string)owner_name + " a thorough breast exam with her hands, and just to be sure she asks a second opinion from her tongue.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " gives " + (string)owner_name + " a thorough breast exam with her hands, and just to be sure she asks a second opinion from her tongue.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Motorboat")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " motorboats " + (string)owner_name + "'s sweet tatas.");
            else if (_say)
                llSay(0, (string)username + " motorboats " + (string)owner_name + "'s sweet tatas.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " motorboats " + (string)owner_name + "'s sweet tatas.");
            llSetObjectName(origName);
            menu(id);
        }
        else if ( str == "Fail")
        {
            llSetObjectName("");
            if (_whisper)
                llWhisper(0, (string)username + " tries to milk " + (string)owner_name + " and fails epically.");
            else if (_say)
                llSay(0, (string)username + " tries to milk " + (string)owner_name + " and fails epically.");
            else if (_instant_message)
                llInstantMessage(llGetOwner(), (string)username + " tries to milk " + (string)owner_name + " and fails epically.");
            llSetObjectName(origName);
            menu(id);
        }
    }
}