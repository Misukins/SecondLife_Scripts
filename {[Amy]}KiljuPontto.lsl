key owner;

/*TODO
key _TEXTURE_BLANK       = "dc94c34e-1ae6-f263-ab99-52001300524d";
string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";
*/

string LID_        = "Lid";
string WATER_      = "Water";
string YEAST_      = "Yeast";

integer listenid;
integer chan;
integer hand;
integer link_num;

integer _lid;
integer _water;
integer _yeast;

list main_buttons       = [];
list main_admin_buttons = [];

doMenu(key _id)
{
    if(TVOn){
        main_buttons =         [ "Close TV", "▼" ];
        main_admin_buttons =   [ "Close TV", "Access", "Reset", "▼" ];
    }
    else{
        main_buttons =         [ "Open TV", "▼" ];
        main_admin_buttons =   [ "Open TV", "Access", "Reset", "▼" ];
    }
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    if ( _id == llGetOwner())
        llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_buttons, chan);
}

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

init()
{
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    determine_display_links();
}

determine_display_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == LID_){
            _lid = i;
            found++;
        }
        else if (llGetLinkName(i) == WATER_){
            _water = i;
            found++;
        }
        else if (llGetLinkName(i) == YEAST_){
            _yeast = i;
            found++;
        }
    } while (i-- && found < 3);
}

default
{
    state_entry()
    {
        init();
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    changed(integer change)
    {
        //
    }

    touch_start(integer total_number)
    {
        //
    }

    listen(integer _chan, string n, key _id, string _message)
    {
        //
    }

    timer()
    {
        //
    }
}